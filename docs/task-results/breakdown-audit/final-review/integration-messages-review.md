# Integration and Messages Review

Status: HARD_BLOCK

Reviewed evidence:
- Current branch is `feature/breakdown-audit`; diff includes generator/validator work, 5 ledger JSON entries, generated Viet resources/SQLite, and a Practice/Messages definition lookup change.
- `node native-ios/scripts/validate-viet-breakdown-audit.js --json`: PASS with `2770` runtime pages, `2770` pages with breakdown, `5` reviewed ledger entries.
- `node native-ios/scripts/validate-viet-breakdown-audit.js --require-all-reviewed --json`: FAILS as expected with `2765` missing reviewed ledger entries; all 5 seeded entries also have `visualReview.status: "pending"`.
- `native-ios/Resources/viet-authored-listing-pages.json`: `2770` pages, all `2770` have breakdown sections, `10403` breakdown tokens.
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`: `badBreakdownGlossCount: 0`, `duplicateBreakdownGlossCount: 0`, `bannedUserFacingMatchCount: 0`, `brokenRelationCount: 0`, `audioUsageMismatchCount: 0`, `searchDocumentsWithMissingPageTargets: 0`.
- `node native-ios/scripts/viet-breakdown-audit.test.js`: PASS, 3/3.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`: PASS, `2770` canonical pages, `2778` source phrases, `456` city phrase tags, release-blocking missing audio `0`.
- Focused native test suite via XcodeBuildMCP on `iPhone 17 Pro`: PASS, 185/185 for `AppChromeTests`, `SQLiteLanguagePackRepositoryTests`, and `PracticeScenarioModeTests`.
- Messages/Practice reuse path is present: `PracticeStoryTranscriptView` asks `PracticeStoryBreakdownDefinitions.tokens(for:)`; that resolves `turn.source?.pageID` or exact Vietnamese title candidates, then loads `PhraseDetailPage.page(...).sections.flatMap(\.breakdown)`. The passed `testMessageDefinitionBubblesDoNotShowInternalOrWholeSentenceGlosses` covers the broad Messages definition-bubble path.

Findings:
- HARD_BLOCK: This cannot be called fully done under the plan. Only `5 / 2770` runtime breakdown pages have ledger entries, and strict validation reports `2765` missing reviewed entries.
- HARD_BLOCK: None of the 5 seeded reviewed entries satisfy the required visual review gate. They all have `visualReview.status: "pending"`, so the required app-opened inspection with `--detail-page <pageID> --detail-scroll first-breakdown` has not been completed.
- HARD_BLOCK: I found no native screenshot/sample evidence proving the seeded pages were visually inspected in the rendered Break it down carousel. The generated audit export proves data parity for the 5 entries, not the required visual app review.
- Required-plan gap: `generate-authored-tier-one-pages.js` still runs `repair-viet-breakdown-glosses.js` as a generation-time mutation step. Reviewed ledger overrides are reapplied afterward, so the 5 reviewed pages survive correctly, but unreviewed pages still depend on old output repair behavior. For final completion, that repair needs to become audit-only or be fully superseded by ledger-owned source truth.
- Integration status is otherwise healthy for the subset: generated resources strip review-only fields, SQLite validation is clean, and Messages/Practice definition lookup now consumes detail-page breakdown tokens without the previous focused native failures.

Required fixes before full completion:
- Add reviewed ledger entries for all `2770` current Viet runtime detail pages.
- Mark every page `visualReview.status: "reviewed"` only after actual native inspection of the Break it down carousel.
- Rerun strict audit validation until `--require-all-reviewed` passes with zero missing pages and zero pending visual reviews.
- Remove/demote blind output repair so the full corpus is ledger/source-owned, with any helper acting only as an audit or validator.
- Regenerate authored listing resources and SQLite after the full ledger lands, then rerun the SQLite validator and focused native suite.
- Run and save the final two-reviewer gate again only after strict full-corpus validation passes; this review is a HARD_BLOCK, not an approval.

Coordinator follow-up:
- After this review, `native-ios/scripts/viet-breakdown-audit.test.js` was expanded to 4/4 passing with review-export coverage. The HARD_BLOCK remains because full ledger coverage, visual review, and output-repair demotion are still incomplete.
