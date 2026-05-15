APPROVE

There are no skipped pages, no spot-check-only approval, and no unresolved Messages/Practice regression.

Scope:
- Final reviewer 2 for Break It Down audit integration/Messages.
- Read-only review for product/source files. I did not edit the ledger, generator, Swift, resources, or tests.
- I replaced only this report file: `docs/task-results/breakdown-audit/final-review/integration-messages-review.md`.

Fresh evidence:
- `node native-ios/scripts/validate-viet-breakdown-audit.js --require-all-reviewed --json`
  - PASS: `runtimePages: 2770`, `pagesWithBreakdown: 2770`, `ledgerEntries: 2770`, `reviewedEntries: 2770`, `missingReviewedEntries: 0`.
- `node native-ios/scripts/viet-breakdown-audit.test.js`
  - PASS: `14` passed, `0` failed, `0` skipped.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - PASS: `canonicalPages: 2770`, `sourcePhrases: 2778`, `searchDocuments: 2778`, `relations: 19881`, `practiceSeeds: 2770`, `plannedMissingAudioBreakdownRows: 0`, `releaseBlockingMissingAudioAuditRows: 0`.
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
  - PASS: `badBreakdownGlossCount: 0`, `duplicateBreakdownGlossCount: 0`, `bannedUserFacingMatchCount: 0`, `brokenRelationCount: 0`, `audioUsageMismatchCount: 0`, `searchDocumentsWithMissingPageTargets: 0`.
- Focused native tests via XcodeBuildMCP on `iPhone 17 Pro` simulator:
  - PASS: `185` passed, `0` failed, `0` skipped.
  - Selection: `SpeakLocalNativeTests/PracticeScenarioModeTests`, `SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests`, and `SpeakLocalNativeTests/AppChromeTests`.
  - Covered Messages definition-bubble regressions, semantic chunking, partial-coverage fallback, persistence/coherent transcript flow, SQLite article loading, and breakdown carousel layout.

Coverage and parity:
- Audit export summary at `content-draft/viet/breakdown-audit/audit/rendered-breakdown-audit.json`: `pages: 2770`, `reviewed: 2770`, `visualReviewed: 2770`, `missing: 0`.
- Generated runtime JSON at `native-ios/Resources/viet-authored-listing-pages.json`: `2770` pages, `2770` pages with `breakdown`, `13284` breakdown tokens, and `0` review-only field leaks (`reviewStatus`, `visualReview`, `keepTogetherReason`, `reviewNotes`, `notes`).
- Runtime JSON breakdowns match the rendered audit export for every page: `runtimeMismatchCount: 0`.
- SQLite rows at `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`: `phrase_page: 2770`, pages with breakdown rows: `2770`, `breakdown_token: 13284`, breakdown `page_section_item` rows: `13284`, `page_alias: 3661`.
- JSON-to-SQLite breakdown row parity passes through `page_alias`: `jsonRows: 13284`, `sqliteRows: 13284`, `mismatchCount: 0`, `missingSqlCount: 0`.
- Broad compound blocker scan: `42` blocker targets checked, `splitHitCount: 0`.

Native rendered sample evidence:
- `docs/task-results/breakdown-audit/visual-spot-check.md` records native `--detail-page <pageID> --detail-scroll first-breakdown` samples after regenerating authored resources and the Viet SQLite fixture.
- There are `11` screenshot files under `docs/task-results/breakdown-audit/screenshots/`.
- Sampled screenshots for email, Tier 1, city/place, editorial/menu support, practice expansion, emergency, and food allergy pages are present and renderable at `368x800`.
- The visual spot-check also records the same simulator evidence for the post-blocker compound fixes and focused native tests: `185` passed, `0` failed.

Messages/Practice integration:
- `PracticeStoryTranscriptView` still routes Vietnamese transcript lines through `PracticeStoryBreakdownDefinitions.tokens(for:)`.
- `PracticeStoryBreakdownDefinitions` resolves `turn.source?.pageID` first, then normalized title candidates, then loads detail-page data through `PhraseDetailPage.page(withID:).sections.flatMap(\.breakdown)`.
- The returned `PracticeStoryDefinitionToken` values are derived from existing detail-page `BreakdownToken` rows; Messages does not author a separate definition glossary.
- Token mode is gated by full phrase coverage. Partial matches keep normal transcript text, which avoids misleading tap targets.
- The focused native test run includes `testMessageDefinitionBubblesDoNotShowInternalOrWholeSentenceGlosses`, semantic chunk tests, partial-coverage fallback, exact-audio visible choice checks, and durable Messages transcript flow tests.

Generator/source-truth:
- `generate-authored-tier-one-pages.js` loads the breakdown audit ledger and applies reviewed source truth through `applyReviewedBreakdownOverride(...)` for `breakdown` sections.
- `applyReviewedBreakdownOverride(...)` returns app-facing tokens only for `reviewStatus: "reviewed"` ledger entries.
- Generation validates the ledger with `validateBreakdownAuditCoverage(...)`; the strict validator proves the full `2770 / 2770` reviewed runtime-page coverage.
- `renderBreakdownAuditExport(...)` exposes review-facing evidence separately from app-facing runtime tokens.
- `repair-viet-breakdown-glosses.js` remains in the repo as a script, but `rg` found no call to it from `generate-authored-tier-one-pages.js` or `generate-viet-sqlite-fixture.js`. Final glosses are not authored by blind post-generation repair.

Conclusion:
- APPROVE for integration/Messages. Runtime page coverage is complete, generated JSON/SQLite parity is clean, the strict audit and SQLite validators are green, rendered native sample evidence exists, and the Messages/Practice tap-to-define path reuses detail-page `BreakdownToken` data without an unresolved regression.
