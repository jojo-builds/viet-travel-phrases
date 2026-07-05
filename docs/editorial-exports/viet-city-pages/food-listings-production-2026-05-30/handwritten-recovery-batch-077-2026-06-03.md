# Handwritten Recovery Batch 077 - 2026-06-03

## Scope

- `city-hcmc-place-street-food-evening`
- `city-hcmc-place-takashimaya-saigon-centre`
- `city-hcmc-place-tan-son-nhat-airport`
- `city-hcmc-place-tao-dan-park`
- `city-hcmc-place-thao-dien`
- `city-hcmc-place-thien-hau-pagoda`
- `city-hcmc-place-thu-thiem-riverfront`
- `city-hcmc-place-ton-duc-thang-museum`

Also folded Batch 076 steering into `city-hcmc-place-saigon-river`, `city-hcmc-place-saigon-river-boat`, and `city-hcmc-place-southern-women-museum`.

## Editorial Notes

- Replaced planner/reviewer logic with physical traveler images: river bank traffic, bridge lights, Thu Thiem across the water, boat return points, mall resets, airport arrival flow, park shade, temple worship movement, and focused museum rooms.
- Preserved phrase cards and related cards; Saigon Square specificity from Batch 076 was left intact.
- Removed formula-triggering `enough` and `are enough` lines by turning them into concrete images or actions.
- Kept the forward gate active: avoid direct save commands, verdict headings, app-rationale language, and generic mood lines when visible details can carry the page.

## Validation

Ran:

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

Result: PASS.

- V2.2 app-detail validation: 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no formula failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero hidden at render-time, 500 missing-audio priority rows.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Rendered page: `viet-family-city-hcmc-place-ton-duc-thang-museum`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-077-screenshots/001-hcmc-ton-duc-thang-museum-top.jpg`

## Progress

- Completed through batch 077: 419 / 520
- Remaining: 101
