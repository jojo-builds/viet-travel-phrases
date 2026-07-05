# Handwritten Recovery Batch 079 - 2026-06-03

## Scope

- `city-hoian-place-an-bang`
- `city-hoian-place-an-hoi-bridge`
- `city-hoian-place-an-hoi-island`
- `city-hoian-place-ancient-town`
- `city-hoian-place-ancient-town-ticket-booth`
- `city-hoian-place-bach-dang-boat-pier`
- `city-hoian-place-bach-dang-street`
- `city-hoian-place-bale-well`

## Editorial Notes

- Started the Hoi An source-order segment after closing HCMC.
- Replaced old-town formula language such as `Expect`, `Related because`, `works better`, and `works for` with physical details: river crossings, lantern-lit lanes, ticket booths, yellow walls, boat noses, beach basket boats, and Bale Well's hands-on shared set.
- Preserved phrase cards and related cards while making related-card reasons source-clean.
- Kept the voice gate focused on first-time U.S. travelers: define the place or meal before asking the reader to care.

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
- Rendered page: `viet-family-city-hoian-place-bale-well`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-079-screenshots/001-hoian-bale-well-top.jpg`

## Progress

- Completed through batch 079: 433 / 520
- Remaining: 87
