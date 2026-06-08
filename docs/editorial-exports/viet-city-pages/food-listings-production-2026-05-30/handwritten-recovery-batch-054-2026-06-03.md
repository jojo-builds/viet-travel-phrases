# Handwritten Recovery Batch 054 - 2026-06-03

Status: PASS

Progress: 269 / 520 recovered, 251 remaining.

Scope:
- `viet-family-city-hue-place-royal-court-music-show`
- `viet-family-city-hue-place-ru-cha-mangrove`
- `viet-family-city-hue-place-song-huong-floating-restaurant`
- `viet-family-city-hue-place-songlab`
- `viet-family-city-hue-place-southern-bus-station`

## Authored Fixes

- Royal court music show now explains `nhã nhạc` in plain English as Vietnamese royal court music tied to Nguyễn-dynasty ceremonies. Removed unsupported nighttime, masks, and "after monuments close" framing; added a freshness flag for venue/showtime changes.
- Ru Cha Mangrove Forest now explains the Tam Giang Lagoon edge, chá trees, brackish water, birds, roots, and why the stop changes Hue from royal-stone history to lagoon landscape. Removed repeated "green break" and abstract calm-language loops.
- Song Huong Floating Restaurant now positions the listing as a setting-led floating restaurant on the Perfume River. It says plainly that this is a river-view dinner, not the strongest food-first Hue choice, and glosses `bún bò` and `bánh lọc` for first-time U.S. readers.
- SốngLab now says what the visitor gets: a digital art experience with projection, immersive rooms, and Vietnamese visual/sound artists. Removed `creative room`, `local design motifs`, `helps the stop land`, and abstract `layer` wording.
- Hue Southern Bus Station now reads as a useful logistics page: station name, pickup, luggage, route boards, multiple transport-point confusion, and how the page helps on transfer days. Removed poetic "bus edge" and "old capital reappears" language.

## QA

- Source-risk QA: `019e8c8a-b231-7a02-8fe0-25821902b2ce`
  - Royal court music: REVISE for unsupported night/mask/after-dark framing; fixed.
  - Ru Cha: PASS; source supports mangrove/lagoon/nature contrast.
  - Song Huong: PASS; source supports floating restaurant, Perfume River, Truong Tien Bridge, seafood/Hue dishes; freshness flag added.
  - SốngLab: REVISE for freshness and operational/exhibition volatility; fixed with freshness flag and concrete experience copy.
  - Southern Bus Station: PASS; freshness flag added for routes and pickup conventions.
- U.S.-traveler readability QA: `019e8c8a-c138-78c3-884d-7eb825eae0b2`
  - Royal court music: PASS with minor "stage craft" polish; fixed anyway.
  - Ru Cha: REVISE for repeated abstract role language; fixed.
  - Song Huong: REVISE for writerly setting lines and unexplained food terms; fixed.
  - SốngLab: REVISE for abstract/app-review-ish language; fixed.
  - Southern Bus Station: REVISE for poetic logistics language; fixed.

Sources referenced by QA included VNAT Duyet Thi Duong / royal court music context, Vietnam Tourism Ru Cha, Hue Discovery Song Huong Floating Restaurant, Hue Discovery SốngLab, SốngLab's own site, and Hue bus-route/station references.

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

- Simulator left open on Sống Platform - SốngLab:
  - `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-054-screenshots/001-hue-songlab-top.jpg`

## Carry Forward

- Do not rely on poetic "role" language to make a listing feel meaningful. If a page is a bus station, make the logistics useful.
- When a Vietnamese term appears, explain it on first visible mention. `Nhã nhạc` now gets a plain English explanation before any cultural value claim.
- For food references, first-time U.S. readers need quick glosses when the dish is doing decision-making work.
- Freshness flags are not copy approval, but live restaurants, showtimes, exhibitions, bus routes, and outdoor conditions need them when visible copy avoids exact operational claims.
