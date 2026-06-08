# Handwritten Recovery Batch 090 - 2026-06-03

## Scope

- `city-hoian-place-the-field`
- `city-hoian-place-thu-bon-river`
- `city-hoian-place-tra-nhieu-village`
- `city-hoian-place-tra-que`
- `city-hoian-place-trade-ceramics-museum`
- `city-hoian-place-traditional-art-performance-house`
- `city-hoian-place-tran-phu-street`
- `city-hoian-place-trieu-chau-assembly-hall`
- `city-hoian-place-u-cafe`
- `city-hoian-place-vys-market`
- `city-hoian-place-white-rose-dumplings`
- `city-hoian-place-white-rose-restaurant`
- `city-hoian-place-wonton`
- `city-hoian-place-yaly-couture`

## Copy Gate

- Positive-proof pass ran before validation: each page was checked for what the place, dish, river edge, workshop, street, or tailor stop is; what a first-time U.S. traveler should picture; what the phrase-card moment is; and why each related or mentioned card helps the trip.
- Cold visible-copy gate: PASS before validators. Final visible headings, intros, section leads, Mentioned Here subtitles, and Related subtitles read as traveler-facing copy, not module jobs.
- Abstract-noun translation pass: PASS before validators.
- Reader-interpretation language sweep: PASS before validators. Residual terms such as `checklist`, `helps`, `read as`, `matters`, `reason`, `context`, `memory`, and `keepsake` were checked against visible copy and removed or avoided where they explained the writer's intent instead of showing the place.
- Anti-thinning check: PASS. Phrase cards, Mentioned Here cards, related cards, and useful dish/place specificity were preserved; weak seams were rewritten into physical traveler details.
- Full-source high-risk visible phrase scan: PASS across all 520 v2.2 entries after a focused backward pass removed residual `the scene`, `the value is`, `phrase matters`, `Doorway Before Checklist`, and `read as` copy from older batches.
- Stop-closeout correction after orchestrator heartbeat: PASS. A stricter all-520 visible-copy gate scanned the complete current Jojo hard-block list, including `Group Table Reality`, `Daytime Is Practical`, `Crowd Expectations`, `Arrival Planning`, `Built-Heritage Pairing`, `Assembly-Hall Contrast`, `Craft-Day Pairing`, `Modest Scope`, `The Stops Do Different Jobs`, `Scale Changes The Stop`, `Cafes Hold The Stop`, `Coffee As The Stop`, `Wind Changes The Stop`, `the stop`, `checklist`, `read as`, `phrase matters`, and saved-list commands. Result: `hard_hits=0`.
- Soft module-heading inventory: PASS. Headings matching planner/reviewer patterns such as `* Planning`, `* Pairing`, `* Context`, `* Expectations`, `* Reality`, `* Scope`, `* Practical`, `* Contrast`, `* Holds The Stop`, `* Changes The Stop`, `* As The Stop`, and `* Do Different Jobs` were translated into physical traveler headings. Result: `soft_heading_hits=0`.
- Five Whys not used for this batch. The final-tail count issue was a receipt/progress accounting correction, not a copy-drift root-cause chain.

## Notable Repairs

- The Field now reads as rice-field air, open space, water edges, and sunset light outside the old-town crush.
- Thu Bon River now centers markets, bridges, cafes, boats, reflections, evening light, and lantern water without abstract river-rationale language.
- Tra Nhieu now shows bamboo, nets, low boats, garden edges, and a village-water outing beyond old-town lanes.
- Tra Que now explains the herb-and-vegetable village through planted beds, water, soil, cooking-class links, and farm boundaries.
- Trade Ceramics Museum now defines the old trade-port evidence through bowls, jars, trade objects, labels, and maps.
- Traditional Art Performance House now frames music, masks, costumes, instruments, stage light, and the small-theater pause.
- Tran Phu Street now centers yellow walls, shopfronts, tailor windows, cafe doors, and slow old-town crossings.
- Trieu Chau Assembly Hall now uses carved wood, lanterns, altars, thresholds, incense, and short courtyard rooms instead of respect labels.
- U Cafe now reads as a seated riverside drink with plants, water, shade, and old-town decompression.
- Vy's Market now makes the food-station setup concrete: cao lầu, white rose dumplings, bánh xèo, herbs, counters, and table questions.
- White Rose Dumplings and White Rose Restaurant now split the dish and named-room jobs clearly, including wrapper texture, crisp topping, shellfish awareness, and the making/ordering moment.
- Wonton now explains the Hội An plate through sauce, wrapper, herbs, filling, and the place it holds between dumplings and a larger noodle bowl.
- Yaly Couture now focuses on fabric walls, measuring tape, mirrors, sample garments, cut, lining, alterations, pickup timing, and departure deadlines.
- Final all-source sweep also patched a small set of older residual voice seams in Đà Nẵng, Hà Nội, Saigon, Hội An, and Huế so the known Jojo pet-peeve phrases no longer appear in visible v2.2 city app-detail copy.
- Stop-closeout backward pass patched additional planner/template headings across all cities, including `Group Table Reality`, `Crowd Expectations`, `The Stops Do Different Jobs`, `Scale Changes The Stop`, `Cafes Hold The Stop`, `Coffee As The Stop`, and `Wind Changes The Stop`.

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
- Signing scan: PASS; `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` do not contain local signing/team/provisioning settings.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Rendered page: `viet-family-city-hoian-place-yaly-couture`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-090-screenshots/001-hoian-yaly-couture-top.jpg`
- Build/run: PASS on `SpeakLocal City Listings` simulator.

## Progress

- Batch 089's receipt undercounted the final tail. The source still had 14 entries after Thanh Ha.
- Authored coverage after Batch 090: `520 / 520`.
- Full hard-block visible scan after stop-closeout correction: PASS.
- Validators after stop-closeout correction: PASS.
- Remaining: `0`.

## Remaining Known Risks

- Missing-audio priority rows remain tracked by the existing audio audit: 500 listing-priority rows / 700 planned missing audio rows in the SQLite fixture report, with 0 release-blocking missing-audio rows.
- Production QA still reports 1 duplicate hero section hidden at render-time, with 0 blockers and 0 majors.
