# Handwritten Recovery Batch 073 - 2026-06-03

## Scope

- `city-hcmc-place-le-thanh-ton-street`
- `city-hcmc-place-le-van-tam-park`
- `city-hcmc-place-little-hanoi-egg-coffee`
- `city-hcmc-place-long-trieu`
- `city-hcmc-place-lusine-thao-dien`
- `city-hcmc-place-man-moi`
- `city-hcmc-place-mariamman-temple`
- `city-hcmc-place-mien-dong-bus-station`

Also folded in the completed Batch 072 heartbeat nits for Hủ tiếu, Jade Emperor Pagoda, Japan Town, and Landmark 81, plus one nearby source leak cleanup for `Related because:` and the Nephele top/best voice-audit blocker.

## Editorial Notes

- Replaced task-style headings such as `Look For`, `Read`, and `Check` with place-based headings.
- Removed `matters because`, `worth knowing`, and direct saved-list/rationale phrasing where it was visible in this scope.
- Kept phrase cards and related links intact while making surrounding copy more natural for first-time U.S.-based travelers.
- Preserved useful explanations for unfamiliar terms, including egg coffee, Bib Gourmand, Tamil Hindu context, and old/new Mien Dong terminal caution.

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
- Rendered page: `viet-family-city-hcmc-place-mien-dong-bus-station`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-073-screenshots/001-hcmc-mien-dong-bus-station-top.jpg`

## Progress

- Completed through batch 073: 387 / 520
- Remaining: 133
