# Copy Production Handoff - 2026-05-31

## Where To Continue

Open this folder for the next copy-production session:

`/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch:

`feature/city-listings-production-ready`

Use the root app-family docs plus:

- `AGENTS.md`
- `native-ios/AGENTS.md`
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/production_readiness_review.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/copy-production-handoff-2026-05-31.md`

Do not continue this work from the Browse UI lane. Browse can be used for rendered review, but the copy source of truth is this city-listings feature lane.

## Current Product Direction

SpeakLocal Vietnam is not trying to be a language course. The listing copy should make Vietnam feel vivid, searchable, and easy to act on: places, dishes, restaurants, cafes, drinks, routes, and phrases worth remembering before or during a trip.

The page should make something feel worth saving without saying "save this." Avoid app-internal phrasing such as "counter to save," "route the user," "same-city comparison," or copy that assumes the reader already knows Vietnamese venue names.

Voice target:

- shorter, sharper, observed, adult, calm, useful;
- concrete details over broad travel adjectives;
- U.S.-based English-speaking traveler lens;
- no default template across restaurants, food pages, city pages, drinks, cafes, markets, and phrase pages.

## What This Checkpoint Changed

- Repaired remaining generic related-card copy across Da Nang, Hanoi, Saigon, and Hoi An after the earlier Hue pass.
- Removed visible generic related-card patterns such as "same-city," "different pace," and save-instruction style language from authored related cards.
- Tightened a few visible non-related residues where "different pace" or "counter" language sounded unnatural.
- Restored the top photo-backdrop chrome to match `main` after a prior pinned-audio shield commit caused a white wash over the hero image.
- Regenerated native resources and SQLite from the authored copy.

## Current Validation Receipts

Latest successful checks in this lane:

- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-city-michelin-coverage.js`
- `node native-ios/scripts/audit-viet-listing-production-qa.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node scripts/guard-native-only.js`
- `git diff --check`

Simulator proof:

- Built and launched `SpeakLocalNative` on simulator `SpeakLocal City Listings`.
- Direct route used for visual proof: `--detail-page viet-family-city-hoian-place-banh-mi-phuong`.
- The top hero/chrome now matches `main`: no giant white wash over the image.

## Remaining Work

Correction, 2026-06-01:

The earlier `PASS_GLOBAL_PRODUCTION_READY` classification was revoked after a full copy audit. Current status is `NOT_PRODUCTION_READY`; continue from `full-copy-audit-2026-06-01.md`.

Second repair batch, 2026-06-01:

- Fresh read-only food, non-food, and phrase-card subagents audited the current lane.
- The next blocker batch was repaired and projected: fixed-price mall phrase cards, coffee-route cards, cooking-class/craft/lagoon-seafood cards, the singular ticket-buying tap-through risk, and visible editor-language residue across V2.2 app-detail source.
- Current validators pass after regeneration, but this still is not a final production-ready receipt. Continue from the `Second Repair Batch - 2026-06-01` section in `full-copy-audit-2026-06-01.md`.

Third repair batch, 2026-06-01:

- Read-only audits found two current risks: thin high-use generated phrase pages and `85` repeated `food-menu | food-1 | food-3` card sets.
- Repaired source copy for ticket buying, walking, less sugar, hot coffee, recommendations, and pack-for-travel phrase pages.
- Retargeted `32` high-risk food listings across fine dining, seafood-by-weight, dessert, vegetarian, and service-led restaurant pages.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; the repeated food-card set is now `53` pages, mostly simple dish/stall pages.
- Built and launched on simulator `SpeakLocal City Listings`; spot-checked Anan Saigon, Be Man Seafood, che xoa xoa hat luu, less-sugar phrase page, pack-for-travel phrase page, and Lien Hoa Vegetarian. Render review found one compact-card issue on Lien Hoa, fixed by switching to shorter ready phrase `food-premium-no-meat`, then rebuilt and rechecked successfully.
- This is improved but still not a final production-ready receipt because rendered review needs broader category coverage.

Fourth repair batch, 2026-06-01:

- Read-only audits found `7` remaining hard-block restaurant retargets in the repeated food-card set and `3` hard-block related-card mismatches in non-food/native projection.
- Retargeted those restaurant pages, repaired Tiên Sa Port / Perfume River / Tòa Khâm Boat Station related links, retargeted Trường Tiền Plaza mall cards, and repaired a small safe-fix set across cafes, nature/activity pages, and Thủy Biều Village.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; the repeated food-card set is now `46` pages: `33` Dish and `13` focused one-dish/snack Restaurant pages.
- Rebuilt and spot-checked Bếp Cuốn, Trường Tiền Plaza, and Perfume River on simulator `SpeakLocal City Listings`.

Fifth repair batch, 2026-06-01:

- Cleaned remaining process-language residue in related/mentioned candidate metadata: `387` internal reason fields normalized, plus `5` visible related-card subtitles hand-rewritten.
- Retargeted the two render-review restaurant rows: Cô Chủ Nhỏ and Bánh Xèo 46A now use distinct table/recommendation/payment or sauce utility cards instead of the old repeated generic food set.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; process/residue relationship strings are now `0`, and exact repeated phrase-card sets across V2.2 source are now `0`.
- Rebuilt and spot-checked Cô Chủ Nhỏ and Bánh Xèo 46A on simulator `SpeakLocal City Listings`.

Sixth repair batch, 2026-06-01:

- Repaired the six visible soft freshness/status phrases found by the final sidecar audit: Asia Park, Dragon Carp Statue, Noi Bai Airport, Quan Thanh Temple, Ben Thanh Metro Station, and Golden Dragon Water Puppet Theater.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; targeted soft schedule/rules/open/timing phrases are now `0`.
- Final source-completeness sidecar: `PASS` for all `520` V2.2 source objects.
- Final native/generated sidecar: structural native evidence passes, but global status remains `REVISE` until the rendered screenshot evidence is promoted from representative proof to a final global receipt.

Highest-leverage next pass:

1. Decide whether to satisfy the V2.2 production gate literally with top/scrolled screenshot proof for all `520` V2.2 pages, or amend the receipt standard to accept full source/runtime text review plus representative rendered proof.
2. If using the literal screenshot standard, build a repeatable UI-test harness that captures top and scrolled screenshots for all `520` `viet-family-city-*` pages into a dated proof folder.
3. Run the final requirement-by-requirement production receipt against the V2.2 gate after that proof exists.
4. Keep generated resources in sync: project V2.2 to handwritten copy, import handwritten copy, generate authored listing pages, generate SQLite, then validate.

Good starter pages/searches for rendered review:

- `viet-family-city-hoian-place-banh-mi-phuong`
- `viet-family-city-hoian-place-madame-khanh`
- `viet-family-city-hcmc-place-anan-saigon`
- `viet-family-city-hcmc-place-pho-minh`
- `viet-family-city-hanoi-place-bun-cha-huong-lien`
- `viet-family-city-danang-place-han-market`
- `viet-family-city-hcmc-place-42-nguyen-hue-apartment`
- `viet-family-city-hoian-place-the-field`
- `viet-family-city-danang-place-ba-na-hills`

## Subagent Note

This desktop thread repeatedly hung when using real subagent spawn/close controls. A fresh session can try subagents again, but keep each agent read-only and narrow:

- one agent reviews phrase-page thinness;
- one reviews food/restaurant desire;
- one reviews city/place related-card usefulness;
- one reviews rendered simulator pages for visual/copy fit.

Do not let subagents auto-edit the same files concurrently. Fold their findings back through the authored V2.2 source and regeneration chain.

Seventh repair batch, 2026-06-01:

- User screenshot review found `city-hcmc-place-banh-xeo-46a` still too hard to read on-device: stiff section language such as `A Dish-Specific Meal`, `table attention`, and `carry the stop`.
- Ran a full taxonomy audit across all `520` V2.2 entries with read-only food, culture/attraction, mobility/route, and place-feel slices.
- Repaired the screenshot page and first taxonomy hard-block batch in source: food pages with app-architecture language, transport phrase-card mismatches, wrong culture/attraction related cards, Cửa Đại Beach phrase cards, Kim Bồng/Trà Nhiêu wording leaks, and several visible grammar or voice issues.
- Repaired related-card fallback clusters with page-specific route/comparison cards rather than suppressing all relationships.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current source/runtime validators pass: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Global status is still not final production-ready until the rendered proof gate is closed or explicitly amended. Continue from `full-taxonomy-copy-audit-2026-06-01.md`.

Rendered proof expansion, 2026-06-01:

- Added a resumable native UI-test harness for the V2.2 screenshot gate: `CityAppDetailV22RenderProofUITests/testCaptureCityAppDetailV22RenderProofBatch`.
- Added a full `520`-page manifest under `render-proof-2026-06-01-v2-2-global/`.
- Proved `25` category-balanced pages with `75` screenshots and `0` failures, including the user-flagged `city-hcmc-place-banh-xeo-46a`.
- Multi-page-in-one-test runs can kill the UI-test runner; use single-page xcodebuild invocations with `TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_OFFSET=<n>` and `TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_LIMIT=1` for reliable continuation.
- Remaining global proof gap: `495` V2.2 pages still need rendered screenshots, unless Jojo explicitly amends the final gate to accept source/runtime validation plus category-balanced native proof.
