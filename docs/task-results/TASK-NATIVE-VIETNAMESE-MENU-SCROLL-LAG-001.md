# Vietnamese Menu Scroll Lag Root-Cause Receipt

Date: 2026-05-29
Lane: `feature/menu-section`
Scope: Native iOS Vietnamese food/drink menu scrolling, top glass section picker, and section jump behavior.

## Outcome

The section-boundary scroll lag investigation found two invalidation paths:

- photo-backdrop scroll offset was broad view state, so normal vertical scrolling could rebuild too much menu surface
- section-boundary changes updated page state, top glass chrome state, and hidden in-page rail position at the same time
- a follow-up CPU sample of the same fast section-boundary scroll found AttributeGraph deep-comparing `VietnameseMenuSection` / `VietnameseMenuItem` values, so section-body updates could walk large menu payload arrays even after the top glass label churn was reduced

The fix keeps the user-facing menu intact while narrowing those updates:

- `VietnameseMenuPhotoBackdropScrollCoordinator` publishes only display offset changes that actually affect the bottom chrome backing
- `VietnameseMenuSectionTrackingCoordinator` owns current section and rail pinning so repeated frame preference updates do not publish
- pinned top-picker scroll boundary changes are coalesced before publishing to the glass label, so a fast fling across several section titles produces one settled label update instead of a label rebuild at every boundary
- `VietnameseMenuSectionChromeCoordinator` lets the small top glass picker update its label without forcing AppShell to treat every section label change as a pinned-state change
- hidden/pinned section rail no longer auto-scrolls while the user is vertically scrolling beneath the top glass picker
- top section jumps use immediate direct scroll, not delayed animated scroll
- explicit top-picker jumps own the label through a short settle window, preventing lazy-stack geometry from relabeling the pill to a neighboring section while the direct jump is landing
- large menu payload/section/item structs no longer conform to `Equatable`, preventing SwiftUI/AttributeGraph from doing deep equality over menu item arrays during scroll rendering

## Five Whys

1. Why did scrolling lag at section titles?
   Because section titles are exactly where current-section tracking changes.
2. Why did a section change cost visible frame time?
   Because the section change updated menu page state, top glass section chrome, and the horizontal rail together.
3. Why did the top glass picker appear involved?
   Because its current label was driven by the same section state and propagated through AppShell.
4. Why did it still hitch only while crossing title sections after the first fix?
   Because the pinned glass label still published each scroll-derived boundary immediately, so fast scrolling through adjacent sections could ask the top chrome to relabel during the busiest part of the fling.
5. Why did earlier fixes not remove this last hitch?
   Because the previous fixes reduced broad scroll-offset churn, rail auto-scroll, and animated jumps, but scroll-driven pinned label updates still needed to be coalesced separately from direct user section jumps.
6. Why was there still measurable scroll-time work after the label churn fix?
   Because the menu data models still advertised deep `Equatable` conformance, letting AttributeGraph compare whole section/item payloads while updating SwiftUI body output at section boundaries.

## Direct-Jump Follow-Up

The first pinned-boundary coalescing pass exposed a race in `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`: choosing `Seafood` could reach the Seafood content while the top pill failed to settle on `Seafood`. The cause was the same scroll-derived geometry path competing with an explicit user choice while the lazy stack finished placing the section.

The follow-up fix adds a short programmatic-jump settle window. Direct dropdown and rail selections still update the label immediately and scroll directly, but scroll-derived section tracking is ignored briefly so it cannot override the explicit choice with a neighboring section.

## Regression Proof

Focused simulator proof:

```sh
xcodebuild -project native-ios/SpeakLocalNative.xcodeproj \
  -scheme SpeakLocalNative \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testOnlyTopAdminAndAppSpecificChromeStayLayeredAboveContent \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testPinnedAudioSpeedChromeAppearsWithVietnameseMenuSectionChrome \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testVietnameseMenuSectionsExposeFullVerticalInventory \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testVietnameseMenuPhotoBackdropScrollCoordinatorPublishesOnlyDisplayOffsetChanges \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testVietnameseMenuSectionTrackingCoordinatorPublishesOnlyMeaningfulChanges \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testVietnameseMenuSectionTrackingDefersPinnedScrollBoundaryChanges \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testVietnameseMenuSectionJumpPolicyUsesImmediateScroll \
  -only-testing:SpeakLocalNativeTests/AppChromeTests/testVietnameseMenuSectionChromeCoordinatorSeparatesPinnedChangesFromLabelChanges \
  -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testVietnameseFoodMenuSectionRailScrollsToCategory \
  -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testVietnameseMenuTopSectionPillAppearsAfterInPageRailScrollsOff \
  -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToSeafood \
  -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive \
  -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testVietnameseFoodMenuCategoryPhotoBackdropImageTapTogglesImmersiveFromInitialPosition \
  -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testVietnameseDrinkMenuCategoryPhotoBackdropImageTapTogglesImmersiveFromInitialPosition \
  test CODE_SIGNING_ALLOWED=NO
```

Observed latest focused results:

- AppChrome menu/chrome set: `8` tests passed, `0` failures.
- BrowseSearch top-picker/menu section set: `5` tests passed, `0` failures.
- Combined direct-jump and boundary-coalescing smoke set: `4` tests passed, `0` failures.
- Current combined menu smoothness set after removing the large-model equality path: `6` tests passed, `0` failures.
- Physical iPhone focused UI run after the second-layer fix: `2` tests passed, `0` failures, covering fast section-boundary scrolling plus top picker jumps to `Seafood`, `Pork`, and `Beef & goat`.

Additional hygiene/proof:

- `git diff --check` passed
- `node scripts/guard-native-only.js` passed
- `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` stayed clean of local signing changes
- physical iPhone Debug build/install/launch succeeded with signing kept local
- physical iPhone UI automation also passed the focused fast-scroll and top-picker jump tests
- simulator manual gesture proof fast-scrolled through multiple section title boundaries and settled cleanly with the top glass picker still responsive
- simulator manual gesture proof selected `Pork` from the top picker and landed in the `Pork` section with the pill still reading `Pork`
- simulator CPU sample during the fast section-boundary swipe initially showed `VietnameseMenuSection.__derived_struct_equals` / `VietnameseMenuItem.__derived_struct_equals` in AttributeGraph output; after removing unnecessary large-model `Equatable` conformances, the same sample no longer contained those equality stacks
- `AppChromeTests/testVietnameseMenuLargeModelsAvoidDeepEquatableComparisons` guards against reintroducing the deep model equality path

## Future-Agent Validation Checklist

When this bug is suspected again:

1. Reproduce on the Vietnamese Food Menu with fast vertical scrolling across section headers.
2. Watch for section-boundary hitches, not only generic scroll smoothness.
3. Confirm the top glass section picker appears after the in-page rail scrolls off.
4. Open the top picker and jump to Seafood; the jump should feel direct and should land on `VietnameseMenu.SectionTitle.seafood` with `VietnameseMenu.Row.food-tom-rang-muoi` available.
5. Run the focused test command above.
6. Build/install/launch the current branch on the physical iPhone before handoff.

Do not "fix" this by removing the top picker, removing section tracking, disabling section rail behavior, or narrowing menu inventory. Those are user-visible features and must stay intact.
