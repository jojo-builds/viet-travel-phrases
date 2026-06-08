# Handwritten Recovery Batch 084

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Hoi An authored-source recovery continued for 8 listing pages:

- `city-hoian-place-faifo-coffee`
- `city-hoian-place-folk-culture-museum`
- `city-hoian-place-from-danang-airport`
- `city-hoian-place-from-danang-railway-station`
- `city-hoian-place-fujian-assembly-hall`
- `city-hoian-place-hainan-assembly-hall`
- `city-hoian-place-handicraft-workshop`
- `city-hoian-place-history-culture-museum`

Progress after this batch: 473 / 520 recovered, 47 remaining.

## Editorial Notes

- Preserved useful phrase cards and related cards, except for one mismatched airport-to-beach card that now points to the Da Nang railway transfer page.
- Rewrote transfer pages around physical arrival details: bags, pickup signs, station doors, driver names, pickup points, and the road into Hội An.
- Rewrote museum/workshop pages away from `scope`, `planning`, `pairing`, `context`, and `phrase matters` language.
- Applied the new heading translation pass: visible headings now come from traveler-facing nouns/actions rather than module jobs.
- Reworked assembly-hall headings and bodies around gates, courtyards, incense, tiled roofs, worship areas, and community memory.
- Carried forward the new city-food rule for upcoming/backward passes: city food pages must explain what the city version changes, not only define the dish generically.

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

- `viet-family-city-hoian-place-history-culture-museum`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-084-screenshots/001-hoian-history-culture-museum-top.jpg`
