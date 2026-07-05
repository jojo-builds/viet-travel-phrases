# Handwritten Recovery Batch 026 - 2026-06-03

Status: COMPLETE_FOR_BATCH

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Previous recovered count: 124 / 520

Batch size: 5

Current recovered count: 129 / 520

Remaining: 391

Recovered source entries:

- `viet-family-city-hcmc-place-cu-chi-tunnels`
- `viet-family-city-hcmc-place-cuc-gach-quan`
- `viet-family-city-hcmc-place-district-1`
- `viet-family-city-hcmc-place-district-3`
- `viet-family-city-hcmc-place-dong-khoi-landmark-walk`

## Copy Recovery Notes

- Cu Chi Tunnels now explains the site as a guided wartime-history visit outside Saigon, with earth paths, preserved tunnel areas, shaded stops, Bến Đình / Bến Dược planning context, heat/tight-space expectations, and a clear first move: listen before wandering.
- Cục Gạch Quán now reads as an old-house, family-style Vietnamese dinner instead of a generic restaurant: shared dishes with rice, vegetables, soup, fish, tofu, garden corners, koi pond, and why the setting changes the meal.
- District 1 now uses the district name as a practical central-Saigon shorthand without overclaiming current administrative status, and it gives a first-time visitor a clear way to read Ben Thanh, Nguyễn Huệ, Đồng Khởi, hotels, cafés, and the river in smaller corridors.
- District 3 now explains why it differs from District 1: less polished central streets, War Remnants Museum, Turtle Lake, Tân Định Church, Bàn Cờ Market, cafés, apartments, and small nearby walks instead of one forced loop.
- Đồng Khởi landmark walk now explains why this walk exists: it turns scattered District 1 landmarks into one readable line from the cathedral/post office area toward the Opera House and river, with cafés and Nguyễn Huệ as flexible breaks.

## QA Loop

Two read-only sub-agents reviewed the exact five-page scope:

- Factual/source-risk QA checked current support and fragile claims.
- Human-readability/save-worthiness QA checked the revised copy against Jojo's U.S. first-time traveler lens.

Concrete QA fixes integrated:

- Replaced vague or internal phrasing including `photo pass`, `base map`, `riverward movement`, `anchor`, `works better`, `not a`, and `it is not`.
- Removed unexplained visible `Bib Gourmand` wording from Cục Gạch Quán while keeping source support in the receipt.
- Replaced unsupported or source-light Cục Gạch interior details with source-backed garden / koi / shared Vietnamese meal details.
- Added Cu Chi planning context around Bến Đình / Bến Dược and the need to confirm which site a tour or car is visiting.
- Treated District 1 and District 3 as familiar traveler map names without making brittle current-government claims.
- Replaced abstract line-level phrases such as `rice-table rhythm`, `museum weight`, `food-and-market life`, and `the street teaches the center`.

## Freshness Sources Checked

- Vietnam Tourism Cu Chi overview: https://www.vietnam.travel/index.php/vi/node/137
- VNAT Cu Chi heritage-recognition article: https://vietnamtourism.vn/en/index.php/news/items/16106
- Michelin Cục Gạch Quán listing: https://guide.michelin.com/gb/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/cuc-gach-quan
- Vietnam Tourism weekend HCMC / Cục Gạch Quán context: https://vietnam.travel/node/470
- Vietnam Tourism HCMC overview: https://vietnam.travel/places-to-go/southern-vietnam/ho-chi-minh-city
- Vietnam Tourism HCMC attractions: https://www.vietnam.travel/index.php/vi/node/137
- Vietnam Tourism museums: https://vietnam.travel/things-to-do/best-museums-vietnam
- SGGP HCMC ward reorganization context: https://en.sggp.org.vn/hcmc-reveals-newly-established-wards-communes-post117069.html
- VietnamNet HCMC ward reorganization context: https://vietnamnet.vn/en/ho-chi-minh-city-creates-con-dao-special-district-new-saigon-ward-2412311.html

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

- Final V2.2 strict validation passed for all 520 entries.
- Voice audit reported `failures: []`.
- City copy, city library, SQLite fixture, production QA, and `git diff --check` all passed.
- Production QA reported 0 blockers and 0 majors.

## Render Proof

Simulator profile: `city-listings-production-ready`

Simulator: `SpeakLocal City Listings`

Rendered page left open for review: `viet-family-city-hcmc-place-dong-khoi-landmark-walk`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-026-screenshots/001-hcmc-dong-khoi-landmark-walk-top.jpg`

Render proof result: PASS, app built and launched on simulator with the revised page open.

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

Batch 026 is complete. The overall recovery goal remains active at 129 / 520 recovered.
