# Handwritten Recovery Batch 057 - 2026-06-03

Status: PASS

Progress: 284 / 520 recovered, 236 remaining.

Scope:
- `viet-family-city-hue-place-tinh-gia-vien`
- `viet-family-city-hue-place-toa-kham-boat-station`
- `viet-family-city-hue-place-truong-tien`
- `viet-family-city-hue-place-truong-tien-plaza`
- `viet-family-city-hue-place-tu-duc-tomb`

## Workflow Correction

This batch used the 2026-06-03 Five Whys addendum before authoring. The operating rule was positive proof first, validator second:

- What is this place?
- What can a first-time U.S. traveler picture?
- Why does it matter in Hue?
- Which phrase-card or related-card moment is real?
- Why would someone remember it without being told to save it?

The fixes below were written from those answers, then validated. The validator was used as a safety check only.

## Positive Proof And Authored Fixes

- Tinh Gia Vien: a garden-house restaurant for Hue's imperial-style cuisine. The new copy explains the Nguyen court-food connection, careful presentation, courtyard greenery, slower pacing, outdoor seating, and why this is different from a quick local lunch.
- Toa Kham Boat Station: the physical moment where Hue streets become Perfume River boats. The new copy gives steps down to the water, boat noses, operators, bridge views, fare confirmation, return-point questions, and `ben thuyen` as the plain-English boat-pier term.
- Truong Tien Bridge: the pale steel bridge that orients central Hue. The new copy gives six arches, evening lights, everyday crossing, the Perfume River, and the bridge's role as a quick visual marker rather than a content-rationale `orientation` label.
- Truong Tien Plaza Hue: corrected the English name from `Trang Tien Plaza Hue` to `Truong Tien Plaza Hue`. The new copy explains why a mall belongs in the app through heat/rain recovery, bathrooms, card payment, bags, snacks, meeting point, and river/bridge proximity.
- Tu Duc Tomb: the mausoleum complex of Emperor Tu Duc, a Nguyen ruler of Vietnam. The new copy frames it as a royal retreat as much as a tomb: lake edge, pavilions, pine shade, old walls, courtyards, stone paths, and a layout made for lingering.

## Drift Fixes

- Removed current-batch label headings such as `A Practical River Edge`, `When A Boat Route Has A Point`, `Exact Point Matters`, `Landmark Before Attraction`, `Shopping Center, Simple Job`, `Indoor Break Between Stops`, `Indoor Break In The Center`, `Landscape Holds The Memory`, `A Slower Royal Stop`, and `Give It Time`.
- Removed Batch 057 and Hue-wide `Related because:` source reasons. Related links were preserved and the reasons were rewritten in traveler-facing language.
- Avoided direct saved-list calls. The pages now imply value through context, scene, and use, rather than telling the reader to save.
- Avoided thinning the prose to pass validators. When a line failed, it was rewritten with a concrete place image or traveler action instead of stripped down.

## Validation

Command:

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
- v2.2 projection: 520 entries.
- Strict production validation: PASS, 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS, integrity check OK.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero section hidden at render time, 500 missing-audio priority rows.
- `git diff --check`: PASS.

Signing scan:
- PASS: no committed project signing secrets found in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Render Proof

- Simulator left open on Lang Tu Duc - Tomb of Tu Duc:
  - `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-057-screenshots/001-hue-tu-duc-tomb-top.jpg`

## Carry Forward

- Record positive proof before writing each page. If the proof is weak, the page is not ready for validation.
- Related-card reasons must stay clean even when they do not render, because source wording influences review thinking.
- A strict validator failure should trigger richer, clearer copy, not shorter copy by default.
- For practical pages such as malls, stations, and piers, make the traveler need vivid: heat, rain, bathrooms, bags, fare questions, meeting points, route names, and recovery moments.
