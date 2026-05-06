# TASK-NATIVE-PINNED-AUDIO-SPEED-001

## Summary

Implemented a pinned top audio speed control for phrase/detail listing pages.

When the main playback dock is visible, speed remains only in the main player. Once that player scrolls above the top chrome, a compact speed segmented control appears in the top admin area beside the persistent back affordance. When the player returns to view, the pinned control hides again.

The selected speed is a global playback preference. The main play button, phrase-row speaker buttons, and breakdown audio cards now use the same selected rate.

## Files Changed

- `native-ios/App/Views/AudioControls.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/App/Design/NativeGlass.swift`
- `native-ios/Tests/AppChromeTests.swift`
- `native-ios/UITests/AdminChromeUITests.swift`
- `docs/task-results/assets/TASK-NATIVE-PINNED-AUDIO-SPEED-001/player-visible.png`
- `docs/task-results/assets/TASK-NATIVE-PINNED-AUDIO-SPEED-001/pinned-speed-control.png`

## Behavior Notes

- Pinned speed control is route-scoped, so an offscreen player from another detail page cannot activate the current top chrome.
- Search chrome suppresses the pinned speed control.
- The designed Xin chao detail route now reports its actual detail route to the player visibility tracker.
- The phrase article content container stays alive while scrolled so the player can keep reporting its offscreen frame.
- Follow-up chrome refinement: the pinned top-admin visual backdrop was removed from behind the liquid glass controls. The status-bar readability fade is now shorter and softer, while an invisible top-admin hit-test envelope still prevents taps from leaking through to scrolled content behind the back/speed controls.
- No audio files, generated Viet content resources, asset catalog files, signing files, or Xcode project settings were changed.

## Proof

- Player-visible screenshot:
  `docs/task-results/assets/TASK-NATIVE-PINNED-AUDIO-SPEED-001/player-visible.png`
- Pinned-speed screenshot:
  `docs/task-results/assets/TASK-NATIVE-PINNED-AUDIO-SPEED-001/pinned-speed-control.png`

## Validation

- `git diff --check`
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests`
  - 80 tests, 0 failures
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/AdminChromeUITests/testDetailPagePinsAudioSpeedControlAfterPlayerScrollsOffscreen`
  - 1 test, 0 failures
- `xcodebuild build -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`
  - Build succeeded

## Final Status

Follow-up refinement committed in this checkpoint (`Refine pinned audio top chrome backdrop`).
