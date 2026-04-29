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

Commit: be5b16a

Changes:
- Restored the post-article catalog shelf as a clearly separate `Browse more` section below authored page content.
- Exposed the catalog shelf resolver so tests can verify shelf availability for every canonical SQLite page.
- Added coverage that catalog shelf rows exclude the current page while still rendering app-store-style three-row groups.

Validation:
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests/testSQLiteCanonicalPagesShowCatalogExploreShelf -only-testing:SpeakLocalNativeTests/AppChromeTests/testExploreCatalogUsesAppStoreStyleThreeRowGroups` passed, 2 tests.
- `git status --short native-ios/Resources/Audio` returned no changes.

Reviewer gate:
- APPROVED. The bottom catalog shelf is now distinct from authored `Explore next`, uses the existing three-row horizontal shelf behavior, and is available for all sampled canonical SQLite pages without self-row repeats.

## Bug 6 - Relationship/pronoun shelf scope

Commit: a9b02fa

Changes:
- Replaced global `relationship-words` injection with a phrase-sensitive eligibility rule for greeting, relationship-word, and pronoun-sensitive pages.
- Updated generator and validator reporting to fail if eligible pages miss the shelf or ineligible pages receive it.
- Regenerated the Viet SQLite fixture/report and updated the native repository test from global shelf coverage to contextual shelf coverage.

Validation:
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` completed with 18 scenarios, 927 clusters, 946 phrases, and 938 pages.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with 0 missing eligible shelves, 0 unexpected ineligible shelves, 0 bad relationship shelves, and 0 banned wording matches.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed.
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests/testSQLiteRelationshipWordShelfIsContextual` passed.
- SQL proof: 38 canonical pages have relationship shelves; `Xin chào` and `Chào` have the shelf; `Tôi đến từ Mỹ` does not.

Reviewer gate:
- APPROVED. Relationship/pronoun shelves are now contextual: they remain on greeting and relationship-word pages, and they no longer appear on unrelated pages such as `Tôi đến từ Mỹ`.

## Bug 7 - Quick Say semantics

Commit: 631bc6f

Changes:
- Added generator/report and validator checks that Quick Say/Standard Way rows must be canonical self rows, except the approved beginner shortcut `Xin chào` -> `Chào`.
- Tightened generated Quick Say body copy for catalog-built pages so it teaches the fastest useful phrase without “main idea” phrasing.
- Added a native repository regression for `Xin chào`, `Chào`, a directions page, and a health page.

Validation:
- SQL audit found 939 Quick Say/Standard Way phrase rows and 0 rows outside the canonical-self-or-approved-shortcut rule.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` completed with 18 scenarios, 927 clusters, 946 phrases, and 938 pages.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with `badQuickSayTeachingRowCount: 0`.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed.
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests/testSQLiteQuickSayRowsUseCanonicalPhraseOrApprovedBeginnerShortcut` passed.

Reviewer gate:
- APPROVED. Quick Say now defaults to the page’s canonical phrase; `Xin chào` keeps the authored `Chào` beginner shortcut; sampled greeting, direction, health, and catalog-built pages resolve cleanly.

## Bug 8 - Compound/two-phrase reasoning audit

Commit: c357934

Changes:
- Added `docs/content-audits/viet-compound-phrase-rows-2026-04-30.md` with a row-by-row reasoning audit for every suspicious slash, `and/or`, dual-pronoun, `và`, or `hoặc` canonical row.
- Added a validator allowlist for the reviewed compound set so future suspicious canonical rows fail until they are reviewed.
- No canonical page IDs changed, no duplicate pages were created, and no audio was generated.

Validation:
- SQL inventory flagged 14 suspicious canonical rows.
- Reasoned audit approved all 14 as single learner-intent pages or reviewed relationship-choice notation; no split was required in this batch.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed.
- SQL proof: unreviewed suspicious compound rows = 0.

Reviewer gate:
- APPROVED. Copy/learning flow review and technical/canonical review both approve the flagged-case report and the validator now blocks unreviewed future suspicious rows.

## Bug 9 - Breakdown carousel affordance

Commit: d01120f

Changes:
- Added `BreakdownLayout` constants for breakdown-card width, separator width, and trailing peek behavior.
- Narrowed non-final breakdown cards and added extra trailing inset only for multi-card breakdowns so the next card is visibly discoverable.
- Kept single-token breakdown strips on the clean, non-overflowing inset.

Validation:
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/AppChromeTests/testBreakdownCarouselKeepsMultiCardPeekWithoutSingleCardOverflow` passed.

Reviewer gate:
- APPROVED. Layout constants now enforce a multi-card peek while preserving single-card breakdown behavior; simulator screenshot capture is deferred to the final screenshot sweep after the remaining UI fixes.

## Bug 10 - Dense text and homepage/glass polish

Commit: pending

Changes:
- Kept the SQLite dense-text validator active and re-ran it after UI changes.
- Changed Home travel-situation rows from variable minimum-height cards to fixed-height cards with a stable icon column.
- Added subtle top and bottom separation gradients behind static chrome so content does not visually merge with the bottom toolbar/search island or top back chrome.

Validation:
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed, including `textOnlySectionRunCount: 0` through the report check.
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/AppChromeTests/testBottomChromeLayoutUsesCompactIslandMetrics -only-testing:SpeakLocalNativeTests/AppChromeTests/testHomeSituationRowsUseStableCardMetrics` passed, 2 tests.
- Source scan found no `Different ways`, stale `situationRowMinHeight`, or generated `main idea` text in the touched native app files.

Reviewer gate:
- APPROVED. Home situation cards now use stable card/icon metrics, dense text remains validator-blocked, and static chrome has a soft separation layer from scrolling content.
