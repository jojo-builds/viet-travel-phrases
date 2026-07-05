# Handwritten Recovery Batch 015 - 2026-06-02

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

Status after this batch: 75 / 520 listings recovered; 445 remaining.

Timestamp: 2026-06-02 21:21:01 +07

## Batch Scope

Recovered five HCMC attraction / landmark-route pages:

- `city-hcmc-place-cho-lon-walking-route` - Đi bộ Chợ Lớn
- `city-hcmc-place-cu-chi-day-trip` - Đi Củ Chi trong ngày
- `city-hcmc-place-dong-khoi-landmark-walk` - Đi bộ Đồng Khởi
- `city-hcmc-place-golden-dragon-water-puppet` - Nhà hát Múa rối nước Rồng Vàng
- `city-hcmc-place-landmark-81` - Landmark 81

## Editorial Recovery Notes

- Reframed Chợ Lớn walking as a Chinatown / trade-district route with named stops, not a vague walk.
- Reframed Củ Chi as physical wartime history outside the city core, with travel time, heat, guided context, and return energy.
- Reframed Đồng Khởi as a central District 1 landmark spine connecting old facades, Opera House, cafes, shops, and the river direction.
- Reframed Golden Dragon as Vietnamese water puppetry: a short visual show with live music, puppets moving over water, and enough action to follow without much Vietnamese.
- Reframed Landmark 81 as modern Saigon's vertical skyline marker, distinct from older District 1 streets.
- Removed content-system language such as "anchor," "Related because," "works best," "strongest," and excess "feel/feels" usage before validation.

## Source Checks

Visible copy stays to stable facts and avoids fragile schedules, prices, access rules, booking claims, show times, and observation-deck availability.

Current reachability checks:

- Vietnam Travel HCMC overview returned 200 and supports broad HCMC context:
  - https://vietnam.travel/places-to-go/southern-vietnam/ho-chi-minh-city
- Several guessed current travel-guide URLs returned 404 or failed in this environment and were not used as receipt citations.
- Stable reference links returned 200 for the basic fact boundaries used in visible copy:
  - https://en.wikipedia.org/wiki/Ch%E1%BB%A3_L%E1%BB%9Bn,_Ho_Chi_Minh_City
  - https://en.wikipedia.org/wiki/C%E1%BB%A7_Chi_tunnels
  - https://en.wikipedia.org/wiki/%C4%90%E1%BB%93ng_Kh%E1%BB%9Fi_street
  - https://en.wikipedia.org/wiki/Water_puppetry
  - https://en.wikipedia.org/wiki/Landmark_81

Repo-local source notes also referenced prior production intake fields: Vietnam Travel HCMC, Visit HCMC portal, and existing city-library source notes.

## Validation

Passed:

- `node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js`
- `node native-ios/scripts/import-viet-city-handwritten-copy.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-listing-production-qa.js`
- `git diff --check`

Production QA result: 1778 pages, 0 blockers, 0 majors.

## Simulator Proof

Profile: `city-listings-production-ready`

Simulator page left open: `viet-family-city-hcmc-place-cho-lon-walking-route`

Visible proof text:

> Chợ Lớn is Saigon’s historic Chinatown and trade district. A good first walk connects a few named stops: Bình Tây Market, Thiên Hậu Temple, Chinese-Vietnamese signs, and short street crossings.

Screenshot:

`/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_a7f82fea-f8a5-4d65-8de1-483ca765ffb4.jpg`

## Phone Build

Physical iPhone build from this worktree:

- Build: succeeded.
- Install: succeeded.
- Launch: blocked because the iPhone was locked and iOS denied launch.

Signing hygiene:

- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean.
- Repo-visible signing scan: clean.

No personal signing settings were written into tracked project files.
