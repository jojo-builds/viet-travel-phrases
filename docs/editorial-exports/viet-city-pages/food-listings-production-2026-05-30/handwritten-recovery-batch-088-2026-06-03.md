# Handwritten Recovery Batch 088 - 2026-06-03

## Scope

- `city-hoian-place-phung-hung-old-house`
- `city-hoian-place-pottery-workshop`
- `city-hoian-place-precious-heritage-museum`
- `city-hoian-place-quan-cong-temple`
- `city-hoian-place-quan-thang-old-house`
- `city-hoian-place-reach-out-tea-house`
- `city-hoian-place-reaching-out-arts-crafts`
- `city-hoian-place-rice-fields`

## Copy Gate

- Positive-proof pass ran before validation: each page was checked for the concrete place identity, first-time U.S. traveler picture, phrase-card moment, and related-card trip value.
- Cold visible-copy gate: PASS before validators after translating `Expect`, `Come after`, `remember`, `reason`, `context`, `route`, and `stop` style lines into visible traveler detail.
- Abstract-noun translation pass: PASS before validators. Soft terms such as `memory`, `keepsake`, `generic`, and similar abstractions were replaced with objects, rooms, route details, and sensory cues.
- Anti-thinning check: PASS. Phrase cards and related cards were preserved; no context was removed to make the copy pass.
- Mechanism analysis, not Five Whys: one projection failure came from duplicate visible headings on Phung Hung Old House. The source heading was changed so the first section survives as the runtime `place-brief`.

## Notable Repairs

- Phung Hung Old House now centers wooden balcony, yellow corner, lanterns, roof detail, and merchant-house surfaces. A mismatched related-card reason mentioning Trieu Chau was corrected.
- Thanh Ha pottery workshop now shows wheel, damp clay, tools, terracotta shelves, workshop tables, and village lanes.
- Precious Heritage Museum now leans on portraits, textiles, regional dress, warm walls, and old-town gallery rooms.
- Quan Cong Temple now uses red gates, incense, altars, worship movement, shade, and courtyards rather than generic respect labels.
- Quan Thang Old House now focuses on carved wood, doorway detail, inner rooms, and old-house surfaces.
- Reaching Out Tea House now explains the hush through tea, handmade cups, table notes, soft gestures, and gesture-led service.
- Reaching Out Arts & Crafts now uses ceramics, textiles, glaze, weave, wood, cloth, workshop tables, and careful object choice.
- Hoi An rice fields now show green edges, narrow paths, irrigation water, village lanes, weather, and working-field respect.

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
- Rendered page: `viet-family-city-hoian-place-rice-fields`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-088-screenshots/001-hoian-rice-fields-top.jpg`
- Build/run: PASS on `SpeakLocal City Listings` simulator.

## Progress

- Recovered after Batch 088: `505 / 520`.
- Remaining: `15`.
