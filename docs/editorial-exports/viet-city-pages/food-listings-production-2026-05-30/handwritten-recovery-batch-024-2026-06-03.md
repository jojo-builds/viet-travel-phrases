# Handwritten Recovery Batch 024 - 2026-06-03

Status: COMPLETE_FOR_BATCH

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Previous recovered count: 114 / 520

Batch size: 5

Current recovered count: 119 / 520

Remaining: 401

Recovered source entries:

- `viet-family-city-hcmc-place-cheo-leo-cafe`
- `viet-family-city-hcmc-place-cho-lon`
- `viet-family-city-hcmc-place-cho-lon-walking-route`
- `viet-family-city-hcmc-place-ciel`
- `viet-family-city-hcmc-place-city-hall`

## Copy Recovery Notes

- Cheo Leo Cafe now explains the old coffee-room draw: District 3 alley, cloth-filter coffee, iced milk coffee, compact room, and a family story reaching back to 1938.
- Chợ Lớn now reads as Saigon's historic Chinatown area rather than a neat administrative district, with markets, Chinese-Vietnamese temples, medicine shops, dried goods, and short rides between named stops.
- The Chợ Lớn walking route now gives the practical first-visit logic: Bình Tây Market, nearby shop streets, Thiên Hậu Temple, and walking only the nearby pieces.
- CieL now uses precise One MICHELIN Star language and explains the night as a Thao Dien chef's-table tasting menu with open-kitchen cooking, Vietnamese ingredients, French technique, and wine service.
- City Hall now explains what the building is: the People's Committee building, a working government headquarters, mainly viewed from outside from Nguyen Hue Walking Street.

## QA Loop

Two read-only sub-agents reviewed the exact five-page scope:

- Factual/source-risk QA checked current support and fragile claims.
- Human-readability/save-worthiness QA checked the copy against Jojo's U.S. first-time traveler lens.

Concrete QA fixes integrated:

- Changed CieL from generic Michelin wording to `One MICHELIN Star`.
- Changed Chợ Lớn from a clean "district" frame to a historic Chinatown area across parts of District 5 and District 6.
- Added Cheo Leo's 1938 family-shop context and kept the copy away from fragile "oldest cafe" superlatives.
- Added City Hall's normal outside-view guidance while allowing that interior access can depend on current registration.
- Replaced mismatched phrase cards: Chợ Lớn now uses directions/address/walking phrases; CieL uses reservation/recommendation/card-payment phrases; City Hall uses directions/walking/photos.
- Removed abstract or mechanical phrasing such as "the point," "guide signal," "What time does it start?" on a neighborhood page, and ticket/entrance phrases on an outside landmark.

## Freshness Sources Checked

- Michelin CieL listing: https://guide.michelin.com/us/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/ciel%C2%A0
- Michelin CieL inspector article: https://guide.michelin.com/vn/en/article/dining-out/the-inspectors-reveal-all-ciel-ho-chi-minh-city
- CieL official site: https://cieldining.com/
- Saigoneer Cheo Leo feature: https://www.saigoneer.com/saigon-street-food-restaurants/13232-video-h%E1%BA%BBm-gems-80-years-of-c%C3%A0-ph%C3%AA-v%E1%BB%A3t-in-saigon-s-oldest-cafe
- Vietnam Tourism Chợ Lớn guide: https://vietnam.travel/things-to-do/best-ways-explore-cho-lon
- Vietnam Tourism database for Bình Tây Market: https://csdl.vietnamtourism.gov.vn/dest/?item=429
- People's Committee Building access nuance: https://www.nomadotravel.app/en/attractions/peoples-committee-building

## Validation

Command chain:

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

Result: PASS

Notes:

- First run caught a top/best-style phrase from `top of Nguyen Hue`; fixed in source and reran.
- Final run passed all gates with production QA reporting 0 blockers and 0 majors.

## Render Proof

Simulator profile: `city-listings-production-ready`

Simulator: `SpeakLocal City Listings`

Rendered page left open for review: `viet-family-city-hcmc-place-city-hall`

Proof screenshots:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-024-screenshots/001-hcmc-landmark-city-hall-top.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-024-screenshots/001-hcmc-landmark-city-hall-middle.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-024-screenshots/001-hcmc-landmark-city-hall-bottom.png`

Render proof command result: PASS, 1 page, 3 screenshots, 0 failures.

## Phone Build

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: BLOCKED because the physical iPhone was locked
- Repo signing files: clean
- Repo signing scan: no matches

## Overall

Batch 024 is complete. The overall recovery goal remains active at 119 / 520 recovered.
