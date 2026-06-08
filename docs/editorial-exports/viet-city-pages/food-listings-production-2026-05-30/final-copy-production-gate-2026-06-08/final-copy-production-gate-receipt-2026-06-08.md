# City Copy Final Production Gate Receipt

Date: 2026-06-08

Branch: `codex/city-copy-final-production-gate`

Base commit: `083c87301e7bf235a99d68cdc4ec2e8eb39340e1`

Status: PASS_WITH_RISKS after validation, edited-page render proof, and final read-only subagent review. This receipt belongs to the isolated copy-gate branch/worktree, not `main`.

## Scope

- Audited all `520` first-class V2.2 city/place app-detail source entries.
- Edited `31` source pages and regenerated projections/resources from source.
- Preserved richness: no phrase-card deletion, no useful card deletion, and no broad rewrite. Duplicate rendered card instances were hidden with `do_not_render`; wrong related targets were retargeted instead of deleted.
- Paywall remained excluded. No phone build was attempted from this feature branch.

## Edited Pages

- `viet-family-city-danang-place-bep-cuon`
- `viet-family-city-danang-place-bun-cha-ca-hon`
- `viet-family-city-danang-place-con-market`
- `viet-family-city-danang-place-han-market`
- `viet-family-city-hanoi-place-ba-dinh-district`
- `viet-family-city-hanoi-place-bia-hoi`
- `viet-family-city-hanoi-place-mien-luon`
- `viet-family-city-hanoi-place-national-museum-history`
- `viet-family-city-hanoi-place-noi-bai-airport`
- `viet-family-city-hanoi-place-pho-bo-lam`
- `viet-family-city-hanoi-place-red-river`
- `viet-family-city-hanoi-place-vietnam-art-gallery`
- `viet-family-city-hcmc-place-pho-minh`
- `viet-family-city-hcmc-place-cho-lon-walking-route`
- `viet-family-city-hcmc-place-cu-chi-tunnels`
- `viet-family-city-hoian-place-cao-lau-thanh`
- `viet-family-city-hoian-place-com-ga`
- `viet-family-city-hoian-place-com-ga-ba-buoi`
- `viet-family-city-hoian-place-cooking-class`
- `viet-family-city-hoian-place-morning-glory`
- `viet-family-city-hoian-place-the-field`
- `viet-family-city-hue-place-banh-khoai`
- `viet-family-city-hue-place-bun-bo-city`
- `viet-family-city-hue-place-diem-phung-thi-art-center`
- `viet-family-city-hue-place-dong-ba`
- `viet-family-city-hue-place-dong-ba-bun-bo`
- `viet-family-city-hue-place-duc-duc-tomb`
- `viet-family-city-hue-place-incense-village-workshop`
- `viet-family-city-hue-place-le-ba-dang-memory-space`
- `viet-family-city-hue-place-phu-bai-airport`
- `viet-family-city-hue-place-thanh-toan-bridge`

## Cold Visible-Copy Audit

- Audit file: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/cold-visible-copy-audit-2026-06-08.jsonl`
- Summary: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/cold-visible-copy-audit-summary-2026-06-08.json`
- Audited pages: `520`
- PASS: `520`
- HARD_BLOCK: `0`
- SAFE_FIX_NOW: `0`
- ACCEPTED_TEMPORARY_RISK: `1`
- Accepted risk: Inherited source candidate reasons still use Related because / Mentioned here because prefixes in 160 visible source candidates across 147 pages, but generated/native rendered resources strip those prefixes; no literal prefix appears in native-ios/Resources/viet-authored-listing-pages.json.

## Anti-Thinning Ledger

- Ledger: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/anti-thinning-ledger-2026-06-08.md`
- The ledger records before/after visible prose, phrase-card counts, rendered Mentioned Here cards, rendered Related cards, card status/target changes, and traveler value improved for every edited page.
- Result: phrase cards were preserved exactly on every edited page; duplicate/wrong card fixes preserved page utility instead of thinning.

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
- `git diff --check`
  - PASS
- `xcodebuild build-for-testing ... CODE_SIGNING_ALLOWED=NO`
  - `** TEST BUILD SUCCEEDED **`

## Render Proof

- Proof folder: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-final-gate/`
- Edited-page results: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-final-gate/edited-page-results.jsonl`
- Edited-page proof: `31 / 31` PASS
- Edited-page screenshots: `93 / 93`
- Combined current proof: `520 / 520` pages PASS, `0` current failures, `1560` current screenshots
- Missing manifest pages: `0`
- Parse errors: `0`

## Review Gate

- Pre-fix read-only subagent prose audit found module-ish/thin copy; this branch repaired those findings.
- Pre-fix read-only subagent card audit found missing targets and duplicate rendered card targets; this branch retargeted or hid duplicate rendered instances without deleting page utility.
- Final read-only subagent review after fixes: `PASS_WITH_RISKS`
- Reviewer result: no hard source-copy blocker across the `520` source rows; `31` changed pages matched the anti-thinning claims; phrase cards were preserved exactly; duplicate-card decreases were duplicate hides or target corrections.
- Accepted reviewer risks: `viet-family-city-danang-place-ba-na-hills` still renders through the existing special/native projection with generic `About` / `Good to know` section labels even though the V2.2 source has stronger headings; inherited source candidate reasons still contain non-rendered `Related because` / `Mentioned here because` prefixes.

## Remaining Risks

These are not current copy-production blockers:

- `500` missing-audio priority rows in production QA.
- `700` planned missing-audio rows, with `0` release-blocking missing-audio rows.
- `1` duplicate hero section hidden at render time.
- Source candidate reasons still include inherited `Related because` / `Mentioned here because` prefixes, but generated/native rendered resources strip those prefixes and no literal prefix appears in `native-ios/Resources/viet-authored-listing-pages.json`.
- `viet-family-city-danang-place-ba-na-hills` uses the existing special rendered/native projection labels `About` and `Good to know`; the stronger V2.2 source copy is present and validated, but this page is not a clean projection-label pass.
