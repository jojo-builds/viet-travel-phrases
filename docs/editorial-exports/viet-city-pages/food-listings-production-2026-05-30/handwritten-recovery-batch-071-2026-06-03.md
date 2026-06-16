# Handwritten Recovery Batch 071 - 2026-06-03

## Scope

Recovered and micro-polished 8 Saigon entries in source order:

- `city-hcmc-place-district-3`
- `city-hcmc-place-dong-khoi-landmark-walk`
- `city-hcmc-place-dong-khoi-street`
- `city-hcmc-place-fine-arts-museum`
- `city-hcmc-place-fito-museum`
- `city-hcmc-place-gia-dinh-park`
- `city-hcmc-place-goi-cuon`
- `city-hcmc-place-golden-dragon-water-puppet`

## Editorial Notes

- Replaced command/checklist route language such as `Start with`, `Choose`, `Why The Walk Works`, and `Leave a little extra time` with traveler-facing context.
- Kept District 3 and Đồng Khởi useful as orientation pages, but made them less worksheet-like and more place-observed: streets, facades, cafés, traffic, landmarks, and river direction.
- Repaired Fine Arts Museum around the yellow colonial-era mansion, tiled floors, courtyards, shade, and rooms rather than generic museum utility.
- Repaired FITO Museum around traditional medicine, herb drawers, old tools, wooden rooms, and healing history without `Go for` / `Come for` language.
- Reframed Gia Định Park as ordinary airport-side city life: trees, paths, families, open lawns, and shade, with no negative `not a detour` contrast.
- Kept gỏi cuốn clear for first-time U.S. travelers: fresh spring rolls, not fried egg rolls, with rice paper, herbs, shrimp or pork, and dipping sauce.
- Kept Golden Dragon Water Puppet Theater specific to the actual experience: water stage, live musicians, puppet movement, tickets, showtimes, and visual storytelling.

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

Current validation notes:

- V2.2 strict production: PASS, 520 entries.
- Voice audit: PASS, no failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero section hidden at render-time, 500 missing-audio priority rows.

## Render Proof

Simulator: `SpeakLocal City Listings`

Rendered page:

- `viet-family-city-hcmc-place-golden-dragon-water-puppet`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-071-screenshots/001-hcmc-golden-dragon-water-puppet-top.jpg`

## Progress

- Batch recovered/polished: 8 entries.
- Total recovered after this batch: 371 / 520.
- Remaining: 149.
