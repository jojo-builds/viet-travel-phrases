# TASK-NATIVE-SWIPE-TRANSITION-POLISH-001 Result

## Status

Done. Native swipe transitions and the Browse-to-Search bottom chrome morph were polished in the shared SwiftUI chrome/transition layer.

## Root Cause

- Interactive back/forward presentation scaled page layers during drag. Even subtle `scaleEffect` changes altered the perceived vertical lock between the active page and the preview page.
- Committed edge swipes mutated navigation immediately with a normal route animation while clearing `interactiveDrag`, so the page could finish the finger-driven movement and then perform a second autonomous route slide.
- The Browse-to-Search chrome morph reused the whole dock glass as the search-origin accessory geometry while also morphing the selected tab icon. That compounded parent and child motion, which could make Browse drift before landing at the left search accessory.

## Behavior Fixed

- Back and forward swipe commits now animate the interactive drag to the edge first, then mutate route history with animations disabled.
- Canceled swipes animate the drag back to zero, then clear drag state with route animations disabled.
- `NavigationPageMotion` now uses `AppInteractiveNavigationPresentation`, a testable value helper, and reports `scale == 1` for all interactive layers.
- Browse/Search/Home/Saved/Practice chrome remains outside page motion and tappable after swipe navigation.
- Search morph now keeps the dock glass out of the accessory morph. Only the selected tab icon uses a position-only matched geometry path into the search-origin button, while the search pill expands from the search island.
- Dock item hit shapes are explicit, keeping visual and tap frames aligned after Search closes.

## Files Changed

- `native-ios/App/Design/NativeGlass.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/Tests/AppChromeTests.swift`
- `native-ios/UITests/AdminChromeUITests.swift`
- `native-ios/UITests/BackSwipeUITests.swift`
- `docs/task-results/assets/TASK-NATIVE-SWIPE-TRANSITION-POLISH-001/*.png`

## Validation

- `git status --short` before edits: clean for this task aside from pre-existing unrelated drift; no unrelated files were staged.
- Red test pass: new transition tests initially failed before `AppInteractiveNavigationPresentation` and deterministic completion/cancel targets existed.
- `git diff --check`: passed.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`: passed.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeTests/AppChromeTests`: passed, 67 tests.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeUITests/AdminChromeUITests -only-testing:SpeakLocalNativeUITests/BackSwipeUITests`: passed, 6 tests.
- `xcodegen generate`: skipped; no new Swift files or project membership changes.

## Proof Assets

- `docs/task-results/assets/TASK-NATIVE-SWIPE-TRANSITION-POLISH-001/detail-chao-anh-chrome.png`
- `docs/task-results/assets/TASK-NATIVE-SWIPE-TRANSITION-POLISH-001/browse-selected-chrome.png`
- `docs/task-results/assets/TASK-NATIVE-SWIPE-TRANSITION-POLISH-001/search-home-origin-chrome.png`

`xcrun simctl io booted recordVideo` was attempted twice for a short motion proof, but the simulator returned `SimRenderServer.SimulatorError Code=2`. Screenshot proof was captured instead, and the motion-specific behavior is covered by the targeted UI tests above.

## Reviewer Outcome

Read-only peer-style review: PASS. The transition math is centralized and test-pinned, route commits happen after the controlled drag completion with animations disabled, static chrome remains outside page motion, and the search morph no longer reuses the dock container as the accessory geometry. No route-history regression was found in the targeted tests.

## Remaining Risks

- Simulator tests and screenshots can verify route/chrome state, but the final subtle motion feel should still be checked on Jojo's physical device.
- Full native suite was not run; targeted AppChrome, AdminChrome, and BackSwipe coverage passed for this task.

## Final `git status --short`

```text
 M native-ios/App/Design/NativeGlass.swift
 M native-ios/App/Views/AppShellView.swift
 M native-ios/Tests/AppChromeTests.swift
 M native-ios/UITests/AdminChromeUITests.swift
 M native-ios/UITests/BackSwipeUITests.swift
?? docs/task-results/TASK-NATIVE-SWIPE-TRANSITION-POLISH-001.md
?? docs/task-results/assets/TASK-NATIVE-SWIPE-TRANSITION-POLISH-001/
```
