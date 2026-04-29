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

Commit: 5c288ff

Changes:
- Changed listing article hero subtitles from `page.summary` to `page.englishTitle`.
- Added a SQLite validator guard against internal/explanatory wording in hero English subtitles.

Validation:
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with 938 canonical pages, 0 missing-audio audit rows, and 0 banned file matches.
- SQL spot check confirmed hero subtitle source values for `Xin chào`, `Đi đâu đấy?`, and `Ở gần đây không?` are `Hello`, `Where are you going?`, and `Is it near here?`.
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/AppChromeTests/testCatalogAndSearchRowsAllowReadableSubtitles` passed.

Reviewer gate:
- APPROVED. The visible hero subtitle now comes from the English phrase field, while article teaching copy remains below the hero.

## Bug 3 - Canonical link and duplicate-row audit

Commit: fad7871

Changes:
- Updated native navigation tests to expect canonical detail page IDs instead of stale legacy aliases.
- Added a launch-argument regression proving a legacy alias opens its canonical page.
- Added a phrase-row navigation regression proving current-page/self rows do not show a navigable destination.
- Extended the SQLite validator so every phrase section row must carry the exact canonical page destination note for its phrase.

Validation:
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/AppChromeTests` passed, 39 tests.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed.
- SQL proof: phrase rows without exact canonical destination notes = 0; duplicate canonical normalized groups = 0.

Reviewer gate:
- APPROVED. Runtime tests now assert canonical route identity, legacy aliases still resolve, broken phrase-row destinations are validator-blocked, and self links are suppressed by `PhraseRowNavigation`.

## Bug 4 - Explore Next should not reteach the same page content

Commit: 4df712c

Changes:
- Updated `generate-viet-sqlite-fixture.js` so authored `explore-next` rows skip destinations already taught earlier on the same page.
- Added a SQLite validator guard that fails when `Explore next` repeats a non-relationship phrase row already shown on the same page.
- Regenerated the Viet SQLite fixture and report.

Validation:
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` completed and wrote the Viet SQLite fixture/report.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with 938 canonical pages, 3,794 relations, and 0 missing-audio audit rows.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed.
- SQL proof: Explore Next repeats of previously taught page rows dropped to 0; Explore Next still has 249 useful phrase rows.

Reviewer gate:
- APPROVED. The generator now preserves the authored Explore Next shelf while removing repeated rows already taught in Quick Say, usage, insight, local-tip, or other article teaching sections.

## Bug 5 - Restore bottom category shelves on all canonical pages

Commit: pending

Changes:
- Restored the post-article catalog shelf as a clearly separate `Browse more` section below authored page content.
- Exposed the catalog shelf resolver so tests can verify shelf availability for every canonical SQLite page.
- Added coverage that catalog shelf rows exclude the current page while still rendering app-store-style three-row groups.

Validation:
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests/testSQLiteCanonicalPagesShowCatalogExploreShelf -only-testing:SpeakLocalNativeTests/AppChromeTests/testExploreCatalogUsesAppStoreStyleThreeRowGroups` passed, 2 tests.
- `git status --short native-ios/Resources/Audio` returned no changes.

Reviewer gate:
- APPROVED. The bottom catalog shelf is now distinct from authored `Explore next`, uses the existing three-row horizontal shelf behavior, and is available for all sampled canonical SQLite pages without self-row repeats.
