# TASK-VIET-EDITORIAL-PILOT-IMPORT-001 Result

Status: done

Commit hash: `8c797730fb42c94bf2b49570fb3a286ad1d1b993`

## Accepted Approval

Jojo approved **P0 fixes only** for this import:

> Import only the highest-risk correctness rows that fix wrong breakdowns or objectively incorrect teaching. Defer restaurant/place/street rewrites until their linked phrase rows and canonical pages are safe.

Approved and imported patch IDs:

- `EP-017` — `Dạ, chào cô`
- `EP-018` — `Hành lý của tôi chưa tới`
- `EP-019` — `Có giấy vệ sinh không?`

Rows skipped as `REVIEW_ONLY`: `17`

## Pilot Row Review

| Patch | Page | Recommendation | Import result | Reason |
| --- | --- | --- | --- | --- |
| `EP-001` | Bún chả Hương Liên | Defer | Skipped | Restaurant rewrite needs safe linked phrase pages first. |
| `EP-002` | Phở Bát Đàn | Defer | Skipped | Same restaurant/source-link issue. |
| `EP-003` | Cao lầu ở Hội An | Revise | Skipped | Proposed canonical text change to `Cao lầu` needs identity decision. |
| `EP-004` | Bún bò Huế | Revise | Skipped | Good direction, but linked rows need canonical resolution. |
| `EP-005` | Bà Nà Hills | Research | Skipped | Journey/ticket/cable-car details need factual check. |
| `EP-006` | Cầu Rồng | Revise | Skipped | Useful, but proposed linked rows need canonical pages. |
| `EP-007` | Ngũ Hành Sơn | Research | Skipped | Attraction-specific claims need verification. |
| `EP-008` | Bán đảo Sơn Trà | Defer | Skipped | Needs area-route model and safe linked rows. |
| `EP-009` | Đường Bạch Đằng | Defer | Skipped | Street-pronouncer model needs source support first. |
| `EP-010` | Đường Nguyễn Văn Linh | Defer | Skipped | Same street-pronouncer issue. |
| `EP-011` | Đường Võ Nguyên Giáp | Defer | Skipped | Same street-pronouncer issue. |
| `EP-012` | Đi Bà Nà Hills | Defer | Skipped | Proposed full-sentence replacement changes canonical phrase. |
| `EP-013` | Bà Nà Hills ở đâu? | Revise | Skipped | Good recovery flow, but links need mapping. |
| `EP-014` | Một vé vào Ngũ Hành Sơn | Defer | Skipped | Proposed full-sentence replacement changes canonical phrase. |
| `EP-015` | Đi cầu Rồng | Defer | Skipped | Proposed full-sentence replacement changes canonical phrase. |
| `EP-016` | Đường Nguyễn Văn Linh gần đây không? | Revise | Skipped | Good concept, but street rows need canonical support. |
| `EP-017` | Dạ, chào cô | Approve | Imported | Fixed `cô` as aunt-age/respectful female address. |
| `EP-018` | Hành lý của tôi chưa tới | Approve | Imported | Fixed `chưa` as not yet. |
| `EP-019` | Có giấy vệ sinh không? | Approve | Imported | Fixed `giấy vệ sinh` as one toilet-paper chunk. |
| `EP-020` | Dạ, chào anh | Revise | Skipped | Tone cleanup is useful but not P0 correctness. |

Classification counts:

- Safe to approve/import: `3`
- Needs Jojo wording decision or revision: `6`
- Needs factual research: `2`
- Needs source/data model work before import or deferred: `9`

## What Changed

- Added an approval overlay: `docs/editorial-exports/viet-canonical-pages/chatgpt-pilot-2026-05-03/approved-imports-TASK-VIET-EDITORIAL-PILOT-IMPORT-001.json`.
- Added a source-driven importer: `native-ios/scripts/import-viet-editorial-pilot.js`.
- Added a targeted validator: `native-ios/scripts/validate-viet-editorial-pilot-import.js`.
- Wired the authored-page generator to apply approved editorial imports after generation/repair.
- Hardened breakdown repair and SQLite fallback handling for accent-sensitive homographs: `có` vs `cô`, `chưa` vs `chùa`, and `vé` vs `vệ`.
- Added canonical-audit protection for wrong breakdown dictionary/context failures.
- Regenerated Viet authored pages, SQLite resources, canonical audit artifacts, and page-quality audit output.

Imported page outcomes:

- `Dạ, chào cô`: `cô` now teaches aunt-age/respectful female address; exact `cô` audio key is used.
- `Hành lý của tôi chưa tới`: `chưa` now teaches not yet; page copy focuses on baggage tag and counter handoff.
- `Có giấy vệ sinh không?`: breakdown now teaches `Có ... không?` and `giấy vệ sinh` as one toilet-paper chunk.

## Validation

Passed:

- `node native-ios/scripts/import-viet-editorial-pilot.js --dry-run` — 3 approved, 17 skipped.
- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-editorial-pilot-import.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check` — 3,038/3,038 pass; duplicate canonical groups: 0.
- `node native-ios/scripts/audit-viet-page-quality.js` — 3,038/3,038 pass.
- `node native-ios/scripts/validate-tier-one-listing-pages.js` — 150 strong, 0 needs work.
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-practice-expansion.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- Refined user-facing bad-label scan for `cô -> have / yes`, `chưa -> pagoda`, `vệ -> ticket`, `Watch out`, `repair phrase`, `Understanding Repair`, and `question marker`.
- `git diff --check`

Resource counts after regeneration:

- Canonical pages: `3,038`
- Source phrases: `3,046`
- Relations: `27,949`
- Missing audio audit rows: `2,094`
- Release-blocking missing audio rows: `0`

Audio impact:

- No new audio generated.
- `native-ios/Resources/Audio/**` unchanged.
- Exact audio lookup now prefers accent-preserving matches before normalized fallback.

Scope proof:

- `native-ios/App/**` unchanged.
- `native-ios/Resources/Audio/**` unchanged.
- Native signing/project files unchanged.

## Reviewer Outcome

Focused read-only review passed after validation:

- Traveler usefulness: approved P0 pages now teach the correct Vietnamese chunks and stay practical for first-time travelers.
- Graph/resource integrity: canonical IDs preserved; no new pages or duplicate phrase rows created; 17 non-approved pilot rows skipped.
- Audio discipline: no audio generated; missing audio queue remains planned-only; exact `cô` audio reuse is accent-safe.

## Deferred Next Batch

Recommended next editorial task:

- Build the linked-row/canonical-page support needed for the deferred restaurant, dish, place, street-pronouncer, route, and ticket-counter rows before importing those patches.
- Re-export or refresh the editorial Sheet after this commit so staging CSVs no longer show the pre-import bad breakdown evidence as current page state.
