# Handwritten Recovery Batch 086 - 2026-06-03

## Scope

- `city-hoian-place-mango-mango`
- `city-hoian-place-market`
- `city-hoian-place-memories-land`
- `city-hoian-place-metiseko`
- `city-hoian-place-mi-quang`
- `city-hoian-place-minh-an-ward`
- `city-hoian-place-morning-glory`
- `city-hoian-place-mot-herbal-drink`

## Copy Gate

- Positive-proof pass ran before validation: each page was checked for the place/food identity, the first-time U.S. traveler picture, the real phrase-card moment, and why the related cards help the trip.
- Cold visible-copy gate: PASS before validators after revising module-job and thin-safe lines in intros, section headings, first section sentences, Mentioned Here subtitles, and Related subtitles.
- Anti-thinning check: PASS. Phrase cards, Mentioned Here cards, and related cards were preserved; weak rationale lines were translated into visible traveler moments rather than removed.
- City-food rule applied to `Mì Quảng ở Hội An`: the page now defines the bowl while anchoring it in central-coast cooking, texture, herbs, cracker, sauce, and the Hội An comparison with cao lầu.

## Notable Repairs

- Mango Mango now reads as a riverside dinner with plates, drinks, lantern glow, night air, and foot traffic instead of a generic dinner choice.
- Hoi An Market keeps the working-market edge: produce, food stalls, yellow awnings, bargaining, snacks, and small purchases.
- Hoi An Memories Land now describes the island arrival, show lights, bridge approach, seating, and return walk without planner labels.
- Metiseko now describes the fabric room, folded prints, silk/linen browsing, and the difference between a boutique and a tailor room.
- Minh An Ward now explains the old-town core as lanes, cafes, small shops, hotel edges, evening walks, river bearings, and nearby doorways.
- Morning Glory now positions the table around cao lầu, white rose dumplings, bánh xèo, herbs, rice paper, sauces, and ingredient questions.
- Mót herbal drink now describes herbal sweetness, lemongrass, lotus-leaf garnish, cold glass, heat relief, and the old-town walking rhythm.

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
- Rendered page: `viet-family-city-hoian-place-mot-herbal-drink`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-086-screenshots/001-hoian-mot-herbal-drink-top.jpg`
- Build/run: PASS on `SpeakLocal City Listings` simulator.

## Progress

- Recovered after Batch 086: `489 / 520`.
- Remaining: `31`.

## Addendum - Abstract-Noun Carry-Forward Polish

During Batch 087, Jojo's abstract-noun steering was applied to nearby Batch 086 Hoi An lines in the same source file:

- Metiseko: replaced `keepsake/memory/generic` phrasing with fabric, print, label, texture, and fitting/no-fitting detail.
- Minh An Ward: replaced `bearing` headings with hotel edge, dinner walk, lanes, cafes, and doorways.
- Mót herbal drink: replaced `memory` phrasing with herbal sweetness, cold glass, lemongrass, lotus leaf, and street-side line.

No cards or useful context were removed.
