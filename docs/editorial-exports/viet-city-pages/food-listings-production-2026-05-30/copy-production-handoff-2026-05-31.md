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

Update, 2026-06-01:

The global V2.2 source set is now classified as `PASS_GLOBAL_PRODUCTION_READY` in `global-production-ready-receipt-2026-06-01.md`.

Highest-leverage next pass:

1. Review the 63 static-QA minor issues and classify each as fix now, follow-up, or acceptable risk.
2. Do a thin phrase-page pass, starting with pages that feel under-explained, such as `Cai nay bao nhieu?`.
3. Do a food/restaurant desire pass over top restaurants, MICHELIN-supported restaurants, cafes, drinks, and local classics.
4. Use simulator rendered review, not just JSON scans. Spot-check search and detail routes for restaurants, food, drinks, markets, city pages, and phrase pages.
5. Keep generated resources in sync: project V2.2 to handwritten copy, import handwritten copy, generate authored listing pages, generate SQLite, then validate.

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
