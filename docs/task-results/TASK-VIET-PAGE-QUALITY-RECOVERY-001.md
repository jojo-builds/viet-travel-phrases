# TASK-VIET-PAGE-QUALITY-RECOVERY-001 Result

Status: done

Implementation commit: `10b96c2b92eaece03a00c85480fcf71fc818b6c9`

## Root Cause

`Xin chào` regressed because the SQLite-backed runtime could open canonical/generated detail pages that were not treated as authored article pages by the detail renderer. The legacy/home IDs also competed with the canonical SQLite page identity, so `viet-polite-hello`, `viet-family-polite-hello`, and `viet-phrase-polite-1` could surface simpler generated behavior instead of the accepted flagship article rhythm.

The fix restores one canonical flagship page for `Xin chào`, stores the legacy IDs as aliases to `viet-phrase-polite-1`, deduplicates catalog items by page ID, and renders every SQLite/detail page through the article template so generated baseline pages do not fall back to the older simple detail layout.

## Page Universe

- Current Viet source phrases: `919`
- Current canonical phrase pages: `911`
- Current canonical pages audited: `911`
- Current canonical pages passing: `911`
- Authored/article-resource pages: `164`
- Generated baseline pages upgraded by generator: `747`
- Tier 1 families audited: `150`
- Tier 1 classification: `strong: 150`, all other classes `0`

## Audit Artifacts

- Full page audit: `docs/content-audits/viet-page-quality-recovery-001.md`
- Tier 1 validator summary: `node native-ios/scripts/validate-tier-one-listing-pages.js`
- SQLite report: `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`

## Pages Fixed

- All `911` current canonical pages now have article sections and a valid `Break it down` gate.
- `Xin chào` is restored as the flagship `Hello (universal greeting)` page and all tested aliases resolve to `viet-phrase-polite-1`.
- `Không sao đâu` now breaks into `Không sao = it is okay`, `đâu = soft reassurance`, then the full phrase.
- Premium/non-Tier-1 pages now receive baseline article sections instead of placeholder-feeling fallback pages.
- Long generated phrases now use smaller learner-facing chunks instead of one-card full-phrase duplication.
- Residual internal or negative wording was removed from relevant generated/user-facing surfaces, including `key word`, `Watch out`, `repair phrase`, `Understanding Repair`, and `question marker`.

## Validation

- `node --check` passed for the changed generator, validator, test, and audit scripts.
- `node native-ios/scripts/generate-authored-tier-one-pages.js` passed: `150` Tier 1 families, `149` authored main pages, `15` child pages, `0` missing assigned audio.
- `node native-ios/scripts/validate-tier-one-listing-pages.js` passed: `150/150` strong, `0` thin/awkward/placeholder/over-templated/negative/missing-links rows.
- `node native-ios/scripts/generate-viet-catalog.js` passed: `900` families, `919` phrases.
- `npm exec --package=tsx -- tsx scripts/build-family-pack.ts --variant viet` passed.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` passed: `18` scenarios, `900` clusters, `919` phrases, `911` pages, SQLite integrity `ok`.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with `bannedFileMatches: 0`.
- `node native-ios/scripts/audit-viet-page-quality.js` passed: `911/911` canonical pages.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed: `1/1`.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test` passed: `116` tests, `0` failures.
- Banned/internal wording scan over content, native resources, SQLite report, app pack, source CSV, and copy-review doc returned no matches.
- SQLite spot-check returned `911|911|0|2|0` for pages, breakdown pages, missing audio rows, hello aliases, and bad non-final glosses.
- Report validation counters for bad glosses, banned user-facing matches, duplicate canonical groups, sectionless pages, broken relations, missing search targets, and audio mismatches are all `0`.
- `git diff --check` and `git diff --cached --check` passed.
- `git diff --name-only -- native-ios/Resources/Audio` returned no files; no audio was generated.

## Simulator Screenshots

Captured with direct detail-route launch hooks on the booted simulator because the desktop/headless simulator session did not expose reliable tap/scroll input. Native `AppChromeTests` and `SQLiteLanguagePackRepositoryTests` cover the Home, Browse, Search, alias, and canonical routing behavior.

- `docs/task-results/assets/TASK-VIET-PAGE-QUALITY-RECOVERY-001/xin-chao-home-alias.png`
- `docs/task-results/assets/TASK-VIET-PAGE-QUALITY-RECOVERY-001/xin-chao-browse-alias.png`
- `docs/task-results/assets/TASK-VIET-PAGE-QUALITY-RECOVERY-001/xin-chao-search-canonical.png`
- `docs/task-results/assets/TASK-VIET-PAGE-QUALITY-RECOVERY-001/khong-sao-dau-breakdown.png`
- `docs/task-results/assets/TASK-VIET-PAGE-QUALITY-RECOVERY-001/khong-sao-dau-breakdown-scrolled.png`
- `docs/task-results/assets/TASK-VIET-PAGE-QUALITY-RECOVERY-001/premium-quiet-room-breakdown.png`
- `docs/task-results/assets/TASK-VIET-PAGE-QUALITY-RECOVERY-001/long-phrase-breakdown.png`

## Peer Review Outcomes

- Content/pedagogy reviewer found weak generated breakdown glosses, over-templated Tier 1 copy, stale audit checks, and residual internal wording. Addressed with semantic breakdown generation, stronger validators, one-by-one audit gates, positive copy cleanup, and `key word`/placeholder wording removal.
- Canonical/runtime reviewer found the page identity and link graph direction sound, with one stale report-note issue. Addressed by updating generated report notes to reflect SQLite as the default runtime unless disabled.

## Remaining Blockers

None for the current `911`-page universe. The validator/audit path is ready to enforce the same quality bar as more Viet phrase sources are added.

## Recommended Next Task

Create a focused visual verification task for scroll-position screenshots or UI-test-driven screenshot capture so future content recovery cards can capture lower article sections, including `Break it down`, without relying on manual Simulator input.
