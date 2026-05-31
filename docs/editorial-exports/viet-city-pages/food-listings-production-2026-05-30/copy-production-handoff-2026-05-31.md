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

Highest-leverage next pass:

1. Broaden simulator rendered review beyond the spot-check set. Cover revised restaurants, seafood, desserts, vegetarian pages, high-use phrase pages, and a sample of remaining simple dish/stall pages.
2. Sample the remaining `53` repeated `food-menu | food-1 | food-3` pages in app. Keep obvious dish-order pages if the cards fit; retarget any remaining restaurant page that feels too generic.
3. Continue the food/restaurant desire pass over cafes, drinks, desserts, local classics, and any MICHELIN-supported pages that still feel credential- or support-role-led after render.
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
