# Hanoi 001-025 Humanizer Report

Date: 2026-05-26
Worker: H1
Output chunk: `chunks/hanoi_001_025_humanized.json`

## Scope

Rewrote Hanoi entries 001-025 into production-candidate city-library source objects for integrity review.

Read sources:
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/target-ranges.md`
- Relevant ChatGPT project handoffs from batches 030-034, especially 033/034 for entries 014-025.

## Changed Themes

- Replaced scaffold language with one owned traveler moment per page: civic scale, small-table dish ritual, lake reset, sidewalk beer pause, upstairs cafe arrival, ordinary district edges, and short route behavior.
- Removed repeated legacy heading families and command-like travel prompts.
- Revised the stricter-gate blockers: command-led headings, visible sentences beginning with `Use`, `helps ...`, `works best ...`, and `this page` phrasing.
- Shortened summaries and section bodies so every paragraph stays under 45 words.
- Preserved stable details from the source and drafts: Ba Dinh civic scale, bun cha table rhythm, banh cuon texture, bia hoi stools/snacks, Dinh Cafe upstairs arrival, Cho Buoi plant/housewares mood, Dong Xuan market aisles, and Gia's planned-dinner tone.
- Avoided unstable hours, prices, exact access, current menu, fixed routes, ceremony schedules, ticketing, and operating claims.
- Kept the requested source section IDs, including restored humanized `when-to-use` sections wherever the source had them.

## Repair Pass

- Restored non-mechanical `when-to-use` sections for the 23 source entries that had dropped them: 001-006, 008-017, and 019-025.
- Removed visible/importable review language from the chunk, replacing it with traveler-facing cautions about changeable hours, entrances, menus, routes, and venue specifics.
- Normalized source phrase-backed quick-say sections for `city-hanoi-place-bun-cha` and `city-hanoi-place-dinh-cafe`: title `Useful Phrases`, empty body, and exact preserved `phraseIDs`.
- Re-ran `validate-humanizer-chunks.js || true`; aggregate validation still fails on other chunks, but `hanoi_001_025_humanized.json` reports `status: pass`, `entries: 25`, `errors: 0`, `warnings: 0`.

## Revise Pages

No page is marked `revise_before_import` at this humanizer stage. All 25 are marked `ready_for_integrity_review`.

Integrity review should still check:
- `city-hanoi-place-cha-ca` and `city-hanoi-place-cha-ca-thang-long`: catalog mapping between generic chả cá and any existing `food-cha-ca-la-vong` item.
- `city-hanoi-place-gia`: current venue status, booking posture, menu/service format, and whether the intentionally general copy is enough for the page.
- `city-hanoi-place-cong-ca-phe-trieu-viet-vuong`: branch status and whether any drink mentions should become rendered catalog cards.
- `city-hanoi-place-cyclo-old-quarter`: fare/route/access freshness before any operational detail is added.
- `city-hanoi-place-ba-dinh-square`: access, photo, ceremony, and nearby-stop timing should remain out of visible copy unless freshly checked.

## Phrase And Audio Risks

- Preserved only source-existing `phraseIDs`.
- `city-hanoi-place-bun-cha` retains `food-menu`, `food-3`, `coffee-7`.
- `city-hanoi-place-dinh-cafe` retains `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`.
- No new phraseIDs were added for pages whose source did not already include them.
- ChatGPT draft phrase suggestions from batches 030-034 were treated as reference material only, not imported into this chunk.
- Place-name audio and v2.2 phrase-card mapping still need a later integrity pass; this chunk is source-copy humanization, not final audio/catalog approval.

## Notes For Importer

- The JSON top-level shape is:
  `{"cityID":"hanoi","range":"001-025","entries":[...],"decisions":[...]}`
- Each entry includes `sourceMode: "expanded-detail"`.
- This output intentionally does not edit `content-draft/viet/city-library/handwritten-copy/hanoi.json` or generated runtime resources.

## Stricter Gate Recheck

- Removed H1 command-led headings beginning with `Use`, `Keep`, `Choose`, `Ask`, `Confirm`, `Leave`, `Start`, or `Let`.
- Removed H1 visible `Use ...` sentence openings plus `helps ...`, `works best ...`, and `this page` wording.
- Re-ran `validate-humanizer-chunks.js || true`; aggregate validation still fails on other chunks, but `hanoi_001_025_humanized.json` reported `status: pass`, `entries: 25`, `errors: 0`, `warnings: 0`.

## Coordinator Repair Note 2026-05-26

- Replaced the flagged Gia visible heading with traveler-facing copy while preserving section IDs and phraseID behavior.
- Reworded tightened-validator reviewer-language fragments in `city-hanoi-place-bun-cha-ta`, `city-hanoi-place-cong-ca-phe-trieu-viet-vuong`, and `city-hanoi-place-gia`.
- Re-ran `node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true`; aggregate validation still fails on other chunks, but `hanoi_001_025_humanized.json` reports `status: pass`, `entries: 25`, `errors: 0`, `warnings: 0`.
