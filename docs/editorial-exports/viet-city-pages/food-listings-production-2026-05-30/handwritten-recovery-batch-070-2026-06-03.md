# Handwritten Recovery Batch 070 - 2026-06-03

## Scope

Recovered and micro-polished 8 Saigon entries in source order:

- `city-hcmc-place-coco-dining`
- `city-hcmc-place-com-tam`
- `city-hcmc-place-com-tam-ba-ghien`
- `city-hcmc-place-cong-ca-phe-dong-khoi`
- `city-hcmc-place-cu-chi-day-trip`
- `city-hcmc-place-cu-chi-tunnels`
- `city-hcmc-place-cuc-gach-quan`
- `city-hcmc-place-district-1`

Also folded in Batch 069 heartbeat nits for:

- `city-hcmc-place-cheo-leo-cafe`
- `city-hcmc-place-cho-lon-walking-route`
- `city-hcmc-place-ciel`
- `city-hcmc-place-city-hall`

## Editorial Notes

- Removed subtle command/rationale language such as `useful`, `Come for`, `Let the guide`, `reason to choose`, `Pick one corridor`, and negative `not a` phrasing where it was driving the copy back toward app/validator voice.
- Clarified Coco Dining as a Vietnamese tasting-menu dinner, including the `Lữ Hành` or journey menu, pairings, and CoCo Bar context.
- Kept cơm tấm and Ba Ghiền practical and specific for a first-time U.S. traveler: broken rice, pork chop, egg/add-ons, sauce, lunch pace, and direct ordering.
- Reframed Cộng Cà Phê Đồng Khởi as a recognizable Vietnamese coffee-chain stop with coconut coffee, mall air-conditioning, and a central District 1 address rather than pretending it is a hidden local cafe.
- Kept Củ Chi practical but more human-facing: outdoor travel time, guide context, forest-edge paths, tunnel displays, and the ride back.
- Repaired Cục Gạch Quán around old-house rooms, garden corners, shared dishes, and an unhurried dinner without visible save/reason language.
- Repaired District 1 as a readable central Saigon map for first walks, streets with different moods, and heat/traffic breaks.
- Removed Batch 069 object-group drift: `goods groups` became visible market details, and Cheo Leo/CieL/City Hall lines now read as traveler-facing prose.

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

Current validation notes:

- V2.2 strict production: PASS, 520 entries.
- Voice audit: PASS, no failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero section hidden at render-time, 500 missing-audio priority rows.

## Render Proof

Simulator: `SpeakLocal City Listings`

Rendered page:

- `viet-family-city-hcmc-place-district-1`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-070-screenshots/001-hcmc-district-1-top.jpg`

## Progress

- Batch recovered/polished: 8 entries.
- Total recovered after this batch: 363 / 520.
- Remaining: 157.
