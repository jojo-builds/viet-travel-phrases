# Handwritten Recovery Batch 081

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Hoi An authored-source recovery continued for 8 listing pages:

- `city-hoian-place-cam-kim-island`
- `city-hoian-place-cam-nam`
- `city-hoian-place-cam-pho`
- `city-hoian-place-cam-thanh`
- `city-hoian-place-cam-thanh-basket-boat`
- `city-hoian-place-cam-thanh-coconut-village`
- `city-hoian-place-cantonese-assembly-hall`
- `city-hoian-place-cao-lau-city`

Progress after this batch: 449 / 520 recovered, 71 remaining.

## Editorial Notes

- Continued the Hoi An-specific correction from Batch 079: physical traveler moments over planning shorthand.
- Preserved useful phrase cards and related cards.
- Rewrote island/neighborhood pages around concrete movement and place cues: river crossings, island roads, fields, low-key lanes, hotel edges, water-coconut channels, docks, palms, basket boats, and village routes.
- Rewrote Cantonese Assembly Hall to explain what an assembly hall means in Hội An: community architecture tied to trading-port history, not just another heritage interior.
- Rewrote the cao lầu page to define the dish immediately for first-time visitors: thick chewy noodles, pork, greens, herbs, crisp crackers, and shallow sauce.
- Removed visible/source seams caught during review: `Related because:`, `the scene`, `the value`, `old core`, `yellow-wall core`, `not another`, `do not`, `skip the`, `strongest`, `works as`, `the point is`, and `expect a`.

## Validation

Passed:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
git diff --check
```

Validation results:

- V2.2 projection: 520 entries, 5 cities.
- Strict v2.2 validation: PASS, 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no formula failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero section hidden at render-time, 500 missing-audio priority rows.

## Render Proof

Rendered page left open on Simulator:

- `viet-family-city-hoian-place-cao-lau-city`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-081-screenshots/001-hoian-cao-lau-city-top.jpg`
