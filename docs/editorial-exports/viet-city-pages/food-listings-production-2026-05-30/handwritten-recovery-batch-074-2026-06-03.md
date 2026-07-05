# Handwritten Recovery Batch 074 - 2026-06-03

## Scope

- `city-hcmc-place-mien-tay-bus-station`
- `city-hcmc-place-motorbike-food-tour`
- `city-hcmc-place-municipal-theatre-square`
- `city-hcmc-place-nephele`
- `city-hcmc-place-nguyen-trai-street`
- `city-hcmc-place-nhieu-loc-canal`
- `city-hcmc-place-notre-dame`
- `city-hcmc-place-oc`

## Editorial Notes

- Replaced task/checklist headings with place-based headings, especially around bus logistics, ride details, shopping streets, canal starts, and ốc ordering.
- Removed visible rationale language such as `matters because`, `the scene`, `the value`, `works as`, `the point`, and direct `Think...` instructions in this batch.
- Kept phrase cards and related links intact while making the surrounding copy read as traveler context.
- Preserved useful first-time definitions and context: Mien Tay as the western/Mekong bus terminal, motorbike food tours as guided moving dinners, Nephele as a tasting-menu dinner, and ốc as Saigon night shellfish beyond literal snails.

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
- Rendered page: `viet-family-city-hcmc-place-oc`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-074-screenshots/001-hcmc-oc-top.jpg`

## Progress

- Completed through batch 074: 395 / 520
- Remaining: 125
