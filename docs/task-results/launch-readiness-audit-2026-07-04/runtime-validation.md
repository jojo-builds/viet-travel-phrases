# Runtime Validation

Status: complete for Worker C pass

## Summary Verdict

FIX NOW before launch signoff.

No direct simulator launch crash was reproduced on `main` (`07a2db5d8`) for Home, Browse, Food Menu, Airport, Hotel, Search, Saved, or Practice. The app built, installed, and launched successfully on the dedicated simulator `SpeakLocal Launch Runtime`.

However, native test evidence is not launch-green: focused `AppChromeTests` currently fail with 80 failures, and multiple UI tests fail or lose accessibility connection to the app. Treat this as a launch-readiness blocker for validation confidence, even though direct route launches render screenshots.

## Scope / Edit Statement

- Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Branch/commit validated: `main` at `07a2db5d8` (`Record launch readiness phone proof`)
- Simulator only: `SpeakLocal Launch Runtime` (`iPhone 17 Pro`, iOS 26.5)
- Paywall: not merged, not edited, not launched.
- Physical phone: not used.
- Files edited by this worker: this report only.
- Artifacts written by this worker: logs/screenshots under `docs/task-results/launch-readiness-audit-2026-07-04/runtime/`.

## Commands Run

| Command / Check | Result |
| --- | --- |
| `./scripts/status.sh` | PASS. `main` at `07a2db5d8`; repo already dirty from docs/ops/report work; paywall separate at `775687823`; Messages separate at `04dd789f2`. |
| `node scripts/guard-native-only.js` | PASS: no active Expo/React Native surface. |
| `node native-ios/scripts/guard-native-chrome.js` | PASS: no opaque light top chrome shield detected. |
| `git diff --check` | PASS. |
| `node native-ios/scripts/validate-viet-sqlite-fixture.js` | PASS. `releaseBlockingMissingAudioAuditRows: 0`; `sourcePhrases: 1800`; `canonicalPages: 1793`; `cityPlaces: 520`; `vietnameseMenuItems: 355`. |
| XcodeBuildMCP `build_run_sim` with `CODE_SIGNING_ALLOWED=NO` | PASS. Build/install/launch succeeded in 204.128s. Bundle: `app.speaklocal.vietnam.native`. |
| XcodeBuildMCP `snapshot_ui` after launch | FAIL/LIMITATION. Accessibility hierarchy capture failed: `No translation object returned for simulator`. |
| Focused XcodeBuildMCP `test_sim` slice | FAIL/INCOMPLETE. MCP wrapper timed out; underlying log shows test build succeeded, then unit/UI failures before the run was cut off. |
| Direct `xcodebuild ... test` for `BrowseSearchUITests/testBrowseLaunchShowsDedicatedBrowsePage` after erasing dedicated simulator | FAIL. XCTest lost connection to the app while waiting for `Browse.Title`. |
| Direct route launches via XcodeBuildMCP `launch_app_sim` | PASS for `--browse`, `--browse-category vietnamese-food-menu`, `--browse-category food`, `--browse-category airport`, `--browse-category hotel`, `--search-query hotel`, `--saved`, `--practice`. |

## Screenshot / Log Artifacts

Runtime artifact folder:

`docs/task-results/launch-readiness-audit-2026-07-04/runtime/`

Key screenshots:

- `01-home-launch.jpg`
- `02-browse-direct.jpg`
- `03b-food-menu-direct.jpg`
- `03-food-category-direct.jpg`
- `04-airport-category-direct.jpg`
- `05-hotel-category-direct.jpg`
- `06-search-hotel-direct.jpg`
- `07-saved-direct.jpg`
- `08-practice-direct.jpg`

Key logs:

- `build_run_sim_2026-07-04T075507Z.log`
- `focused-ui-unit-tests_2026-07-04T075941.log`
- `ui-browse-launch-test.log`
- `log-error-scan.txt`
- Per-route `runtime_*.log` and `oslog_*.log`

Bulky generated artifacts created during testing (`DerivedData`, partial/corrupt `.xcresult`) were removed from the report folder after logs/screenshots were preserved.

## Runtime Issues Found

### FIX NOW: Native tests are not green

Evidence: `focused-ui-unit-tests_2026-07-04T075941.log`

- `AppChromeTests`: 236 executed, 80 failures.
- Failure clusters include:
  - city/menu picks resolving to empty arrays where menu item IDs are expected;
  - entity detail pages not hiding generated place template rows;
  - Han Market related-place expectation drift;
  - duplicate visible English subtitle on Home phrase shelves;
  - missing/incorrect V2.2 related/mentioned-here cards and missing related-card images;
  - Vietnamese menu detail pages not using expected handwritten source copy.
- `PhrasePageFixtureTests`: 85 executed, 26 skipped, 0 failures.
- `PracticeNativeMVPTests`: 25 executed, 0 failures.

Recommendation: assign a fix lane to separate stale/retired assertions from real regressions. The current state cannot be called launch-ready with 80 focused native unit failures.

### FIX NOW: UI automation cannot reliably prove route traversal

Evidence:

- `focused-ui-unit-tests_2026-07-04T075941.log`
- `ui-browse-launch-test.log`

Observed failures:

- `AdminChromeUITests/testBottomChromeControlsWinEdgeBiasedTapsOverDenseDetailContent` passed.
- `AdminChromeUITests/testPrimarySystemTabsRemainReachableAroundSearch` failed.
- `BottomInsetUITests` failed both selected tests, including UI query timeout and `Unknown kAXError value -25218`.
- `BrowseSearchUITests/testAdminDetoursFromBrowseCollectionBackReturnToCollection` failed waiting for `SavedPagesView`.
- `BrowseSearchUITests/testBrowseCategoryCardOpensCollectionAndBackReturnsToBrowse` failed because `Browse.Situation.hotel` was not hittable.
- Clean rerun of `BrowseSearchUITests/testBrowseLaunchShowsDedicatedBrowsePage` failed with `Lost connection to the application`.

Direct route launches and screenshots succeeded after this, so this is not proven to be a normal user launch crash. But launch readiness still needs a stable automated traversal or a clearly documented simulator/Xcode accessibility limitation with replacement proof.

### ACCEPTED TEMPORARY RISK: Simulator accessibility/WebKit warning noise

Direct runtime logs repeatedly include:

- `Class UIAccessibilityLoaderWebShared is implemented in both ... WebCore ... and ... WebKit ...`
- Occasional `IOSurfaceClientSetSurfaceNotify failed e00002c7`

I did not find direct-launch `fatal`, app crash, uncaught exception, or main-thread-checker evidence in the per-route direct logs. Given direct screenshots rendered correctly, this looks like simulator/accessibility noise unless paired with the XCTest lost-connection failures above.

## Direct Launch Coverage

Direct route launches rendered visible, nonblank screenshots for:

- Home: `01-home-launch.jpg`
- Browse: `02-browse-direct.jpg`
- Food Menu: `03b-food-menu-direct.jpg`
- Eating Out category: `03-food-category-direct.jpg`
- Airport: `04-airport-category-direct.jpg`
- Hotel: `05-hotel-category-direct.jpg`
- Search for hotel: `06-search-hotel-direct.jpg`
- Saved: `07-saved-direct.jpg`
- Practice: `08-practice-direct.jpg`

No direct launch failure was observed for these routes.

## Safe Fixes Recommended

1. Fix or intentionally retire the failing `AppChromeTests` clusters before final launch signoff. Start with the city/menu related-card and handwritten menu-copy assertions because they match Jojo's current concern about missing images and inconsistent menu/admin treatment.
2. Stabilize simulator UI automation for launch readiness: rerun Browse/Search/BottomInset tests on a clean dedicated simulator after the AppChrome failures are addressed. If the WebKit accessibility duplicate warning is a platform issue, document it and replace the failing AX proof with a stable UI-test/screenshot harness.
3. Keep the direct-launch screenshot set as current smoke proof, but do not treat it as a substitute for passing traversal tests. The screenshots prove route launch/render, not tap stability or bottom chrome behavior under interaction.
