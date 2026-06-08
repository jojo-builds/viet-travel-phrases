# Handwritten Recovery Batch 082

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Hoi An authored-source recovery continued for 8 listing pages:

- `city-hoian-place-cao-lau-thanh`
- `city-hoian-place-cargo-club`
- `city-hoian-place-cham-islands`
- `city-hoian-place-cham-islands-snorkel-boat`
- `city-hoian-place-che-bap-cam-nam`
- `city-hoian-place-chuc-thanh-pagoda`
- `city-hoian-place-cocobox`
- `city-hoian-place-com-ga`

Progress after this batch: 457 / 520 recovered, 63 remaining.

## Editorial Notes

- Folded in the Batch 081 heartbeat steering while still in the Hoi An source:
  - Replaced the basket-boat `scene`-shaped heading/body with physical details: docks, palms, village lanes, and channels.
  - Reduced repeated Cam Thanh language by clarifying page jobs: neighborhood, ride, and wider village-waterway setting.
  - Softened the cao lầu lunch line away from command-adjacent wording.
- Preserved useful phrase cards, Mentioned Here cards, and related cards.
- Rewrote Cao Lầu Thanh around the specific bowl at a simple Thái Phiên table.
- Rewrote Cargo Club around its riverfront restaurant-and-patisserie role instead of vague group-fit logic.
- Rewrote Cham Islands and snorkel-boat pages around water, weather, boarding, transfer, and horizon.
- Rewrote chè bắp, Chúc Thánh Pagoda, Cocobox, and Hội An chicken rice with clearer first-time context and fewer planner/reviewer seams.
- Removed visible/source seams caught during review and validation: `Related because:`, `Mentioned here because:`, `the scene`, `the value`, `the reason`, `belongs`, `not the whole`, `pause` overuse, `works better`, `fits`, `helps`, and `page is here`.

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

- `viet-family-city-hoian-place-com-ga`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-082-screenshots/001-hoian-com-ga-top.jpg`
