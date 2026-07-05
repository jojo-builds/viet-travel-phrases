# Handwritten Recovery Batch 087 - 2026-06-03

## Scope

- `city-hoian-place-museum`
- `city-hoian-place-my-son-sanctuary`
- `city-hoian-place-nguyen-hoang-night-market`
- `city-hoian-place-nguyen-phuc-chu-street`
- `city-hoian-place-nguyen-thai-hoc-street`
- `city-hoian-place-night-market`
- `city-hoian-place-nu-eatery`
- `city-hoian-place-phin-coffee`

## Copy Gate

- Positive-proof pass ran before validation: each page was checked for the concrete place or table identity, what a first-time U.S. traveler should picture, the real phrase-card moment, and why the related card helps the trip.
- Cold visible-copy gate: PASS before validators after revising visible module-job and thin-safe lines.
- Abstract-noun translation pass: PASS before validators. `bearing`, `memory`, `keepsake`, `generic`, `practical`, and similar soft abstractions were translated into physical details where they appeared in visible headings or lead lines.
- Anti-thinning check: PASS. Phrase cards and related cards were preserved; weak rationale lines were rewritten into traveler-facing detail.
- Five Whys note: no Five Whys was used in this receipt because the batch did not require a chained root-cause analysis. The process issue was handled as gate-based mechanism correction.

## Notable Repairs

- Hội An Museum now leans on yellow walls, old cases, ceramics, photos, cooler rooms, and street-history context rather than short-visit rationale.
- Mỹ Sơn Sanctuary now defines the Cham temple valley with brick towers, ceremonial courtyards, green hills, morning air, road time, and ruin paths.
- Nguyen Hoang Night Market now names the lane through lantern stalls, gift tables, food smoke, river edges, and the first-lap shopping rhythm.
- Nguyen Phuc Chu and Nguyen Thai Hoc streets now read as visible street lines: shopfronts, signs, crossings, balconies, cafes, river edges, and old-town grid details.
- Hội An Night Market now distinguishes the broader lantern browse from Nguyen Hoang without app-rationale phrasing.
- Nu Eatery now has courtyard scale, shared plates, quieter service, and a smaller table register after old-town noise.
- Phin Coffee now centers the Vietnamese phin, iced glasses, leafy table, slow drip, sweetness, and seated coffee break.

## Carry-Forward Polish

- While applying the abstract-noun gate, lightly tightened nearby Batch 086 Hoi An lines in the same source file:
  - Metiseko: `keepsake/memory/generic` wording became printed silk, linen, folded patterns, labels, fabric texture, and fitting/no-fitting decisions.
  - Minh An Ward: `bearing` headings became hotel edge, dinner walk, lanes, cafes, and doorways.
  - Mót herbal drink: `memory` wording became herbal sweetness, cold glass, lemongrass, lotus leaf, and street-side line.

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
- Rendered page: `viet-family-city-hoian-place-phin-coffee`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-087-screenshots/001-hoian-phin-coffee-top.jpg`
- Build/run: PASS on `SpeakLocal City Listings` simulator.

## Progress

- Recovered after Batch 087: `497 / 520`.
- Remaining: `23`.
