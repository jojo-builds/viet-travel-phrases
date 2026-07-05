# Handwritten Recovery Batch 053 - 2026-06-03

Status: PASS

Progress: 264 / 520 recovered, 256 remaining.

Scope:
- `viet-family-city-hue-place-phu-bai-airport`
- `viet-family-city-hue-place-phu-cam-church`
- `viet-family-city-hue-place-phu-hau-market`
- `viet-family-city-hue-place-railway-station`
- `viet-family-city-hue-place-royal-antiquities-museum`

## Authored Fixes

- Phu Bai Airport now identifies Phu Bai International Airport as Hue's main airport arrival point southeast of the city center, with transfer copy that avoids exact fares, pickup doors, or timing claims.
- Phu Cam Church now introduces the site as Hue's main Catholic cathedral and explains why its modern concrete Catholic worship space adds context beyond pagodas, tombs, and royal temples.
- Phu Hau Market was reframed from a casual visitor market to a working wholesale market tied to early supply movement. The page now points first-time visitors toward Dong Ba Market for an easier browse.
- Hue Railway Station now explains `Ga Hue` as the city's train station and focuses on arrival, baggage, taxis, and central-river orientation.
- Hue Museum of Royal Antiquities now explains the Long An Palace setting and Nguyễn-dynasty court objects without repeating a generic object inventory.

## Review Gate Updates

- Added Jojo's screenshot feedback to the production review gate: reject checklist and `group` / `object group` language unless it is the public name of the attraction.
- Carry-forward rule: monument, museum, temple, market, and walking-area sections must read for the person standing there: what am I looking at, why is it here, what should I notice, and why would I remember this instead of the next similar stop?
- Applied that rule immediately to the previous Cửu Đỉnh / Nine Dynastic Urns page after the rendered lower sections still sounded like an object-classification checklist.

## QA

- Source-risk QA: `019e8c6a-658f-7882-817f-0162cee27bdb`
  - Phu Bai, Phu Cam, Railway Station, and Royal Antiquities: pass with source-backed identity.
  - Phu Hau: revised after source review flagged that available sources frame it as a working wholesale / early market, not a casual neighborhood browse.
- U.S.-traveler readability QA: `019e8c6b-0ed5-7821-876e-818a77036d07`
  - Revised Phu Cam, Phu Hau, and Royal Antiquities for checklist/inventory feel.
  - Phu Bai and Railway Station passed as practical traveler copy.

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
- Production QA: 0 blockers, 1 major, 1 duplicate hero hidden at render time, 500 missing-audio priority rows.
- `git diff --check`: PASS.

Signing scan:
- PASS: no committed project signing secrets found in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Render Proof

- Cửu Đỉnh revised page left open on Simulator after Jojo's feedback:
  - `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-053-screenshots/001-hue-nine-dynastic-urns-revised.jpg`
- Batch 053 museum proof:
  - `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-053-screenshots/002-hue-royal-antiquities-museum-top.jpg`

## Carry Forward

- Source identity beats convenient traveler framing. A working wholesale market needs different copy from a visitor-facing market.
- Avoid `reason is`, `value is`, `group`, `object group`, and route-checklist prose. Those phrases make the copy sound like a template or review worksheet.
- Do not reduce copy length just to solve readability. Keep the value, but make every section answer a human question a first-time U.S. visitor would actually have.
- Phone build was not retried in this batch because the previous physical-device install attempt hung inside `devicectl`; Simulator proof remains current for copy review.
