# Handwritten Recovery Batch 072 - 2026-06-03

## Scope

Recovered and micro-polished 8 Saigon entries in source order:

- `city-hcmc-place-history-museum`
- `city-hcmc-place-ho-chi-minh-city-museum`
- `city-hcmc-place-ho-thi-ky-flower-market`
- `city-hcmc-place-hu-tieu`
- `city-hcmc-place-independence-palace`
- `city-hcmc-place-jade-emperor-pagoda`
- `city-hcmc-place-japan-town`
- `city-hcmc-place-landmark-81`

## Editorial Notes

- Replaced instruction-heavy headings and bodies such as `Start With`, `Choose A Few Rooms`, `Go for`, `Give The Lane Room`, `Keep The Visit Light`, and `Easy To Pair Nearby`.
- Kept the two museum pages distinct for first-time U.S. travelers: the History Museum is zoo-side and older-artifact focused; Ho Chi Minh City Museum is District 1 city-history context inside Gia Long Palace.
- Repaired Ho Thi Ky around working flower-lane details: tight alleys, bouquets, scooters, damp pavement, delivery timing, and nearby food.
- Kept hủ tiếu defined plainly as a southern noodle dish beyond phở, with soup/dry versions, pork, shrimp, herbs, broth, and table sauce.
- Repaired Independence Palace around both names, 1960s building, ceremonial rooms, basement command areas, front lawn, and the April 30, 1975 tank story.
- Kept Jade Emperor Pagoda respectful and concrete: active Taoist-Buddhist worship space, incense, altars, carved rooms, courtyard, turtle pond, and photo awareness.
- Kept Japan Town specific to Lê Thánh Tôn/Thái Văn Lung dining lanes, signs, curtains, ramen/sushi doors, upstairs businesses, and later-night bars.
- Reframed Landmark 81 as the newer high-rise version of Saigon: Vietnam’s tallest building, Saigon River, Vinhomes Central Park, mall floors, residences, hotel space, and skyline views.

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

- `viet-family-city-hcmc-place-landmark-81`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-072-screenshots/001-hcmc-landmark-81-top.jpg`

## Progress

- Batch recovered/polished: 8 entries.
- Total recovered after this batch: 379 / 520.
- Remaining: 141.
