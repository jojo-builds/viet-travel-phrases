# SpeakLocal App Bug Recovery - 2026-04-30

Status: in progress

## Bug 1 - Search/Home navigation

Commit: 3caeb24

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

## Bug 2 - Hero subtitle must be the English phrase

Commit: pending

Changes:
- Changed listing article hero subtitles from `page.summary` to `page.englishTitle`.
- Added a SQLite validator guard against internal/explanatory wording in hero English subtitles.

Validation:
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with 938 canonical pages, 0 missing-audio audit rows, and 0 banned file matches.
- SQL spot check confirmed hero subtitle source values for `Xin chào`, `Đi đâu đấy?`, and `Ở gần đây không?` are `Hello`, `Where are you going?`, and `Is it near here?`.
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/AppChromeTests/testCatalogAndSearchRowsAllowReadableSubtitles` passed.

Reviewer gate:
- APPROVED. The visible hero subtitle now comes from the English phrase field, while article teaching copy remains below the hero.
