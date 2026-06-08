# Handwritten Recovery Batch 089 - 2026-06-03

## Scope

- `city-hoian-place-roastery`
- `city-hoian-place-rosies-cafe`
- `city-hoian-place-sa-huynh-culture-museum`
- `city-hoian-place-silk-village`
- `city-hoian-place-streets-restaurant-cafe`
- `city-hoian-place-tailor-fitting`
- `city-hoian-place-tan-ky-old-house`
- `city-hoian-place-thanh-ha`

## Copy Gate

- Positive-proof pass ran before validation: each page was checked for what the place is, what the traveler should picture, what the phrase-card moment is, and why the related card helps.
- Cold visible-copy gate: PASS before validators after translating `come`, `choose`, `remember`, `phrase fits`, `practical`, `context`, and planner wording into physical traveler moments.
- Abstract-noun translation pass: PASS before validators.
- Anti-thinning check: PASS. Phrase cards and related cards were preserved; weak source-rationale copy was rewritten rather than removed.
- Mechanism analysis, not Five Whys: validator failures were treated as process evidence and fixed in source. No chained Five Whys was needed.

## Notable Repairs

- Hoi An Roastery now centers iced glass, shade, coffee seat, and street-side view inside the walking loop.
- Rosie's Cafe now reads as leafy breakfast, iced coffee, courtyard table, and a softer start before bikes, tailors, or old-town walking.
- Sa Huynh Culture Museum now defines Sa Huynh as an ancient central-Vietnam culture and uses bowls, jars, pottery forms, burial objects, and museum light.
- Hoi An Silk Village now shows silk thread, yarn spools, weaving rooms, fabric texture, labels, and the tailor/fabric decision.
- STREETS now explains the seated restaurant table and hospitality-training mission without phrase-card rationale.
- Tailor fitting now centers measurements, pins, mirror checks, pickup hour, departure timing, and possible fixes.
- Tan Ky Old House now focuses on carved beams, door frames, narrow rooms, trade-era interiors, and old-house comparison.
- Thanh Ha Pottery Village now shows clay, wheels, terracotta vessels, workshop tables, village lanes, water, and hand pressure.

## Validation

Ran:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-authored-tier-one-pages.js &&
node native-ios/scripts/generate-viet-sqlite-fixture.js &&
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production &&
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js &&
node native-ios/scripts/validate-viet-city-copy.js &&
node native-ios/scripts/validate-viet-city-library.js &&
node native-ios/scripts/validate-viet-sqlite-fixture.js &&
node native-ios/scripts/audit-viet-listing-production-qa.js &&
git diff --check
```

Result:

- V2.2 projection: PASS, 520 entries.
- Strict v2.2 validation: PASS, 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no formula failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS, integrity check OK.
- Production QA: PASS, 0 blockers, 0 majors, 1 duplicate hero section hidden at render-time, 500 missing-audio priority rows.
- `git diff --check`: PASS.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Rendered page: `viet-family-city-hoian-place-thanh-ha`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-089-screenshots/001-hoian-thanh-ha-top.jpg`
- Build/run: PASS on `SpeakLocal City Listings` simulator.

## Progress

- Recovered after Batch 089: `513 / 520`.
- Remaining: `7`.
