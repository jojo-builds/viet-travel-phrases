# TASK-VIET-LISTING-QA-DIVERSE-20-001

## Summary

Ran a rendered iOS simulator QA loop across 20 diverse SpeakLocal Vietnam listing pages, using real native detail routes and top / middle / bottom screenshots for each page.

This was a checkpoint loop, not a claim that all 3,070 pages are production-ready. The loop found one systemic issue and fixed it: city-library entity pages without their own correct hero art were still falling through to the generic Vietnam masthead. They now use the neutral masthead fallback instead.

## Pages Captured

| # | Page | Intent |
|---|---|---|
| 1 | Tôi không hiểu | simple phrase |
| 2 | Bàn này còn trống | traveler may hear |
| 3 | Bà Nà Hills | macro attraction / journey |
| 4 | Ngũ Hành Sơn | macro attraction / journey |
| 5 | Cầu Rồng | landmark |
| 6 | Chùa Linh Ứng | landmark |
| 7 | Biển Mỹ Khê | landmark / beach |
| 8 | Đường Nguyễn Văn Linh | street |
| 9 | Đường Bạch Đằng | street |
| 10 | Anăn Sài Gòn | restaurant |
| 11 | Bún chả Hương Liên | restaurant |
| 12 | Phở Bát Đàn | restaurant |
| 13 | Bún bò Huế | dish |
| 14 | Cao lầu ở Hội An | dish |
| 15 | Bưu điện Thành phố ở đâu? | derived place phrase |
| 16 | Nhà hàng Nén Đà Nẵng ở đâu? | derived place phrase |
| 17 | Nhà vệ sinh ở đâu? | practical flow |
| 18 | Tôi có đặt phòng | practical flow |
| 19 | Quầy taxi ở đâu? | practical flow |
| 20 | Gọi taxi giúp tôi được không? | practical flow |

## Proof Artifacts

- Screenshot folder: `native-ios/artifacts/TASK-VIET-LISTING-QA-DIVERSE-20-001/`
- Contact sheets:
  - `native-ios/artifacts/TASK-VIET-LISTING-QA-DIVERSE-20-001/contact-top.png`
  - `native-ios/artifacts/TASK-VIET-LISTING-QA-DIVERSE-20-001/contact-middle.png`
  - `native-ios/artifacts/TASK-VIET-LISTING-QA-DIVERSE-20-001/contact-bottom.png`

## Fix Applied

- Added `ListingProductionQADiverse20ProofUITests` to capture a repeatable 20-page proof set.
- Updated `generate-authored-tier-one-pages.js` so city-library entity pages with no approved page-specific asset use `HeroNeutralMasthead`.
- Kept `HeroBaNaHills` and `HeroDragonBridge` page-specific art.
- Kept derived place phrase pages on `HeroCompactPhraseMasthead`.
- Updated the production QA audit so `HeroNeutralMasthead` still counts as a hero-art follow-up, not as a finished page-specific asset.
- Updated the local `speaklocal-listing-pages` skill with the same neutral fallback rule.

## Rendered Review Notes

- Bà Nà Hills and Dragon Bridge kept their page-specific hero art.
- Marble Mountains, Linh Ung Pagoda, My Khe Beach, streets, restaurants, and dishes now use a neutral masthead instead of unrelated generic Vietnam imagery when no page-specific art exists.
- Derived place phrase pages stayed compact and did not use destination-style hero treatment.
- The sampled phrase rows stayed relevant for the checked pages: no relationship-word leakage appeared, no obvious random Browse-more feed appeared, and the table-availability page showed recognition / next-action rows instead of unrelated allergy or emergency rows.
- Bottom screenshots showed content clearing the bottom chrome in this sample.
- The pinned speed control appeared as expected after scrolling past the player; no sampled page showed it as a blocker, though it remains worth watching during live phone testing.

## Validation

Passed:

- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/audit-viet-listing-production-qa.js --check`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/ListingProductionQADiverse20ProofUITests/testCaptureDiverseTwentyListingPages test`
- `git diff --check`

## Current Counts

- 3,070 canonical pages
- 3,078 source phrases
- 0 duplicate canonical page groups
- 2,126 planned missing-audio rows
- 500 missing-audio priority rows in the production QA report
- 147 neutral/page-specific hero-art follow-up rows in the production QA report

## Remaining Follow-Ups

- This 20-page loop passed after the neutral hero fallback fix, but it does not prove all 3,070 pages are production-ready.
- Neutral mastheads are intentionally safer than unrelated images, but high-value pages still need the hero image production workflow.
- Continue running broader random rendered loops, especially hub pages and long scrolling pages, before calling the whole catalog production-ready.
