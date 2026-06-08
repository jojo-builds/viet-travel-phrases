# Handwritten Recovery Batch 078 - 2026-06-03

## Scope

- `city-hcmc-place-turtle-lake`
- `city-hcmc-place-vincom-dong-khoi`
- `city-hcmc-place-vinhomes-central-park`
- `city-hcmc-place-war-remnants-museum`
- `city-hcmc-place-workshop-coffee`
- `city-hcmc-place-zoo-botanical-gardens`

This batch closes the remaining HCMC source-order entries.

## Editorial Notes

- Replaced generic `Expect`, `useful`, `helps`, `the scene`, and abstract `feel` wording with physical details: fountain edges, snack stalls, Dong Khoi traffic, mall air, Landmark 81, river wind, serious museum rooms, coffee gear, pour-over pace, zoo paths, shade, and family-day rhythm.
- Preserved phrase cards and related cards while tightening headings that sounded like conclusions.
- Kept War Remnants Museum sober and direct without turning the page into checklist advice.
- Closed the HCMC sequence with the current forward gate: concrete traveler-facing prose over reviewer/planner logic.

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
- Rendered page: `viet-family-city-hcmc-place-zoo-botanical-gardens`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-078-screenshots/001-hcmc-zoo-botanical-gardens-top.jpg`

## Progress

- Completed through batch 078: 425 / 520
- Remaining: 95
