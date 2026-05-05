# TASK-NATIVE-BOTTOM-CHROME-FOREGROUND-MORPH-001

Status: complete

Commit: recorded in final closeout

## Summary

Fixed the bottom chrome search/admin morph so the selected dock icon and search icon stay in the foreground during the transition instead of disappearing, reordering, or blurring under the search field glass.

The dock now also has an App Store-style selected pill/lens behind the active item, and that lens uses matched geometry so it can glide between selected dock items.

## Root Cause

- The collapsed search button and expanded search-field icon did not share a foreground matched-geometry identity, so SwiftUI could create a new magnifier during the morph instead of moving the existing one.
- The search field glass sat above the origin/admin icon layer, causing the origin icon to appear buried or blurred during the transition.
- The active dock item only changed icon/text color; there was no selected lens behind the active tab, so dock-to-dock selection changes lacked the liquid-glass selected-state motion.

## Changes

- Added explicit morph IDs for the dock selection lens and search icon.
- Reordered bottom chrome z-index constants so the origin/admin icon stays above the search field during search transitions.
- Added a selected dock pill/lens using native glass and matched geometry.
- Gave the collapsed search icon and expanded search-field icon the same matched-geometry identity, with source ownership based on whether search is presented.
- Added unit tests for foreground morph ordering, distinct morph IDs, and selected pill metrics.
- Added a UI proof test that captures selected dock and search-origin states.

## Files Changed

- `native-ios/App/Design/NativeGlass.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/Tests/AppChromeTests.swift`
- `native-ios/UITests/AdminChromeUITests.swift`

## Proof Screenshots

Captured under:

`docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-FOREGROUND-MORPH-001/`

- `home-selected-lens.png`
- `home-search-origin-and-field.png`
- `home-returned-lens.png`
- `saved-selected-lens.png`

## Validation

- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests`
  - Passed: 75 tests, 0 failures
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/AdminChromeUITests/testSearchChromeMorphHomeAndBrowseProofScreenshots`
  - Passed: 1 test, 0 failures
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/AdminChromeUITests/testBottomChromeForegroundMorphProofScreenshots`
  - Passed: 1 test, 0 failures
- `xcodebuild build -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`
  - Passed
- `git diff --check`
  - Passed

## Scope

- No content files changed.
- No generated Viet catalog/SQLite resources changed.
- No audio resources changed.
- No signing or project settings changed.

## Notes

The visual behavior is now protected by named constants and tests instead of being a one-off screenshot tweak. Future chrome work should preserve:

- selected dock lens remains visible behind the active dock item;
- selected dock icon and search icon use distinct foreground morph IDs;
- search origin/admin icon stays above the search field glass during the transition.
