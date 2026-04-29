# SpeakLocal App Bug Recovery - 2026-04-30

Status: in progress

## Bug 1 - Search/Home navigation

Commit: pending

Changes:
- Added explicit focus state for the expanded search field in `AppShellView`.
- Search taps now request focus even if search is already presented.
- Home/Saved/Search close paths clear search focus so the bottom chrome cannot get stuck in a half-open interaction state.
- Added a regression test for detail -> search -> home -> search -> back.

Validation:
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/AppChromeTests/testRepeatedDetailSearchHomeSearchFlowDoesNotTrapBackNavigation -only-testing:SpeakLocalNativeTests/AppChromeTests/testOpeningHomeFromSearchClearsHistoryToHome -only-testing:SpeakLocalNativeTests/AppChromeTests/testSearchBackCanBeForwardedLikeBrowserHistory` passed, 3 tests.
- A broader `AppChromeTests` run still has pre-existing stale alias-ID expectations; canonical test cleanup is tracked under Bug 3.

Reviewer gate:
- APPROVED. The bug fix has a focused regression for detail -> search -> home -> search -> back, Home clears search/detail state, and search can be re-opened without trapping Back.
