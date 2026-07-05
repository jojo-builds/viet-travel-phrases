# Handwritten Recovery Batch 083

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Hoi An authored-source recovery continued for 8 listing pages:

- `city-hoian-place-com-ga-ba-buoi`
- `city-hoian-place-cooking-class`
- `city-hoian-place-countryside-bicycle-loop`
- `city-hoian-place-cua-dai-beach`
- `city-hoian-place-cua-dai-estuary`
- `city-hoian-place-cua-dai-pier`
- `city-hoian-place-duc-an-old-house`
- `city-hoian-place-espresso-station`

Progress after this batch: 465 / 520 recovered, 55 remaining.

## Editorial Notes

- Preserved useful phrase cards, Mentioned Here cards, and related cards.
- Rewrote Bà Buội around the named chicken-rice lunch rather than generic dish/place logic.
- Rewrote the cooking class and bicycle loop around hands, ingredients, fields, roads, weather, and time instead of itinerary commands.
- Split the Cửa Đại pages by traveler job:
  - Beach: sand, sea air, weather, and shoreline reset.
  - Estuary: river mouth, sea edge, working boats, sandbars, and geography.
  - Pier: boarding, departure, pickup, and boat-route clarity.
- Rewrote Duc An Old House around room-scale heritage details.
- Rewrote The Espresso Station around narrow-lane coffee rather than generic cafe comparison.
- Removed visible/source seams caught during review and validation: `Related because:`, `Mentioned here because:`, `the scene`, `the value`, `the point`, `belongs`, `pause` overuse, `shape` overuse, `helps`, `best`, `fits`, `expect`, and direct instruction phrasing.

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

- `viet-family-city-hoian-place-espresso-station`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-083-screenshots/001-hoian-espresso-station-top.jpg`
