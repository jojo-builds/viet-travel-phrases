# City Copy Final Production Gate Receipt

Date: 2026-06-08

Branch: `codex/city-copy-final-production-gate`

Base commit: `083c87301e7bf235a99d68cdc4ec2e8eb39340e1`

Status: `PASS` after cold visible-copy audit, anti-thinning proof, regenerated projections/resources, edited-page render proof, strict validation, and two read-only subagent reviews. This receipt belongs to the isolated copy-gate branch/worktree, not `main`.

## Scope

- Audited all `520` first-class V2.2 city/place app-detail source entries.
- Earlier final gate edited `31` source pages for copy/card quality without deleting useful phrase cards or useful page graph coverage.
- Clean-pass cleanup normalized `160` source `reason` fields across `147` first-class V2.2 pages by removing stale `Related because:` / `Mentioned here because:` prefixes while preserving the rationale sentence.
- Clean-pass projection fix repaired Bà Nà Hills native section headings so the rendered app keeps the authored V2.2 labels: `More Park Than Viewpoint` and `Give It Room`.
- Paywall remained excluded. No phone build was attempted from this feature branch.

## Branch-Local Receipt Files

- Cold audit: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/cold-visible-copy-audit-2026-06-08.jsonl`
- Cold audit summary: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/cold-visible-copy-audit-summary-2026-06-08.json`
- Original anti-thinning ledger: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/anti-thinning-ledger-2026-06-08.md`
- Clean-pass anti-thinning addendum: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/anti-thinning-clean-pass-addendum-2026-06-08.md`
- Duplicate-card demotion adjudication: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/duplicate-card-demotion-adjudication-2026-06-08.md`
- Prior edited-page render proof: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-final-gate/`
- Clean-pass Bà Nà render proof: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-clean-pass/`

## Cold Visible-Copy Audit

- Audited pages: `520`
- PASS: `520`
- HARD_BLOCK: `0`
- SAFE_FIX_NOW: `0`
- ACCEPTED_TEMPORARY_RISK: `0`
- Source reason prefix matches: `0`
- Native intro mismatches: `0`
- Native generic titles: `0`
- Thin-safe hits: `0`
- Changed source pages in clean pass: `147`
- Changed rendered pages in clean pass: `1`

## Anti-Thinning Result

- Useful phrase-card sets unchanged in the clean pass: `520 / 520` pages.
- Mentioned Here card targets/status/display subtitles unchanged in the clean pass: `520 / 520` pages.
- Related card targets/status/display subtitles unchanged in the clean pass: `520 / 520` pages.
- No phrase cards were removed.
- No Mentioned Here or Related cards were removed, hidden, or retargeted in the clean pass.
- No visible prose was shortened to satisfy validators.
- Full-branch duplicate-card demotions versus `main`: `12`.
- Duplicate-card adjudication result: all `12 / 12` demoted targets still render once on the same page in the other visible card module with a traveler-useful subtitle; this is accepted as de-duplication, not thinning.

## Bà Nà Hills Projection

Clean-pass projection fix:

- Source page: `viet-family-city-danang-place-ba-na-hills`
- Rendered heading fix: `About` -> `More Park Than Viewpoint`
- Rendered heading fix: `Good to know` -> `Give It Room`
- Journey utility rows preserved: useful phrases, getting there, tickets, cable car, photos, getting back, and food/cash rows still render.
- Render proof passed for the edited page with `3 / 3` screenshots.

## Generation

PASS:

- `node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js`
  - `5` cities, `520` entries projected
- `node native-ios/scripts/import-viet-city-handwritten-copy.js`
  - `520` handwritten city copy entries imported
- `node native-ios/scripts/generate-viet-catalog.js`
  - `1767` families, `1785` phrases
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
  - `150` Tier 1 families, `826` city library pages, `0` release-blocking missing-audio rows
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
  - SQLite integrity OK, `1778` canonical pages

## Validation Chain

PASS:

- `jq empty content-draft/viet/city-library/app-detail-v2-2/*.json`
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
  - `520` pass, `0` revise, `0` fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
  - PASS, no failures; `first` exactly at `175 / 175` max
- `node native-ios/scripts/audit-viet-city-listing-what-why.js`
  - `520` entries, `0` findings, `0` hard-review pages
- `node native-ios/scripts/validate-viet-city-copy.js`
  - `5` hubs, `520` city noun pages, `520` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - `826` pages
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - SQLite fixture OK, `1778` canonical pages, `0` release-blocking missing-audio rows
- `node native-ios/scripts/audit-viet-listing-production-qa.js`
  - `1778` pages, `0` blockers, `0` majors
- `node native-ios/scripts/validate-viet-ba-na-hills-journey-patch.js`
  - Bà Nà Hills V2.2 journey validation passed
- `git diff --check`
  - PASS
- `xcodebuild build-for-testing -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=7C386DD3-4BF1-4A34-A918-768C43CD1258' -derivedDataPath /Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/city-copy-final-production-gate/DerivedData/SpeakLocalNative CODE_SIGNING_ALLOWED=NO`
  - `** TEST BUILD SUCCEEDED **`

## Render Proof

- Prior proof folder: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-final-gate/`
- Prior edited-page proof: `31 / 31` PASS, `93 / 93` screenshots
- Clean-pass proof folder: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-clean-pass/`
- Clean-pass edited-page proof: `1 / 1` PASS, `3 / 3` screenshots for `viet-family-city-danang-place-ba-na-hills`
- Combined current proof: `520 / 520` pages PASS, `0` current failures, `1560` current screenshots
- Missing manifest pages: `0`
- Parse errors: `0`

## Review Gate

- Visible copy/projection reviewer: `PASS`
  - Verified all `520` audit rows against native projected intro/section/phrase fields with `0` mismatches.
  - Verified Bà Nà rendered headings and clean-pass render proof.
- Anti-thinning/card reviewer: `PASS`
  - Verified the clean-pass cleanup changed only `160` reason fields across `147` pages, with entries, phrase cards, sections, candidate counts, candidate targets, and candidate statuses unchanged.
  - Verified full-lane structure versus `main`: `520 -> 520` entries, `1560 -> 1560` phrase cards, `2035 -> 2035` sections, `73 -> 73` Mentioned Here candidates, `587 -> 587` related candidates.
  - Reassessed the `12` full-branch duplicate-card demotions and confirmed they are acceptable duplicate-card cleanup because each target still renders once on the same page and remains in the runtime card graph.

## Remaining Non-Copy Risks

These are not current copy-production blockers:

- `500` missing-audio priority rows in production QA.
- `700` planned missing-audio rows, with `0` release-blocking missing-audio rows.
- `1` duplicate hero section hidden at render time.
