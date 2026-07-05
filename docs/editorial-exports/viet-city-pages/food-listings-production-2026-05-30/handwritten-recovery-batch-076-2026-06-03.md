# Handwritten Recovery Batch 076 - 2026-06-03

## Scope

- `city-hcmc-place-rex-hotel-rooftop`
- `city-hcmc-place-russian-market`
- `city-hcmc-place-saigon-railway-station`
- `city-hcmc-place-saigon-river`
- `city-hcmc-place-saigon-river-boat`
- `city-hcmc-place-saigon-skydeck`
- `city-hcmc-place-saigon-square`
- `city-hcmc-place-southern-women-museum`

Also micro-polished older HCMC visible body copy where the same drift pattern reappeared: `the scene`, `the reason`, `the point`, and abstract `shape/feel` wording.

## Editorial Notes

- Replaced checklist or planner-ish lines with concrete traveler context: river banks, boarding points, return points, station bags, shopping counters, skyline views, and museum rooms.
- Removed current-batch formula failures such as `fits a day` and `looks best`, then reduced abstract `shape/feel` wording until the voice audit passed again.
- Preserved useful phrase cards and related cards; the fix was richer human-facing prose, not deleting affordances.
- Kept the newest steering active: avoid command/verdict headings, avoid visible app rationale, and explain the place from what a first-time U.S. traveler can picture.

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
- Rendered page: `viet-family-city-hcmc-place-southern-women-museum`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-076-screenshots/001-hcmc-southern-women-museum-top.jpg`

## Progress

- Completed through batch 076: 411 / 520
- Remaining: 109
