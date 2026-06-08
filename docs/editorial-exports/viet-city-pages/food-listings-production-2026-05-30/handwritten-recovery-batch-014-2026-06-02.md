# Handwritten Recovery Batch 014 - 2026-06-02

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

Status after this batch: 70 / 520 listings recovered; 450 remaining.

Timestamp: 2026-06-02 20:58:31 +07

## Batch Scope

Recovered five HCMC food-adjacent pages:

- `city-hcmc-place-bo-kho-ganh` - Bò Kho Gánh
- `city-hcmc-place-ca-phe-sua-da` - Cà phê sữa đá Sài Gòn ở Thành phố Hồ Chí Minh
- `city-hcmc-place-cafe-hop-nguyen-hue` - Đi cà phê Nguyễn Huệ
- `city-hcmc-place-man-moi` - Mặn Mòi
- `city-hcmc-place-motorbike-food-tour` - Tour ăn tối bằng xe máy

## Editorial Recovery Notes

- Removed traveler-facing instruction language such as "Come here," "decide early," and internal "reason" phrasing.
- Reframed Bò Kho Gánh around what bò kho is: Vietnamese beef stew, bread or noodles, herbs, sauce, and a specific casual-value street-food setting.
- Reframed cà phê sữa đá as a first-time-reader coffee explainer: Vietnamese iced coffee with condensed milk, sweetness expectation, heat relief, and cafe setting.
- Reframed Nguyễn Huệ cafe hopping as the visitor action around the old 42 Nguyễn Huệ apartment block, with floor choice, balcony signs, and reuse as the Saigon-specific reason.
- Reframed Mặn Mòi around a shared Vietnamese restaurant dinner, staff recommendations, rice, sauces, and why it differs from a snack crawl or hotel-style fine dining.
- Reframed the Saigon motorbike food tour as guided route value: multi-stop evening movement, helmets, pickup, rain, comfort, and the ride between bites.
- Removed duplicate related card from the motorbike food tour page.

## Source Checks

Used current/stable sources for fact boundaries and avoided fragile hours, prices, booking, closure, and exact menu claims in visible copy.

- Bò Kho Gánh: Michelin Guide live page and 2025 guide materials identify it as Ho Chi Minh City street food / casual value.
  - https://guide.michelin.com/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/bo-kho-ganh
- Mặn Mòi: Michelin Guide 2025 materials identify it as a Ho Chi Minh City casual-value restaurant; visible copy stays to shared-table and service-guidance claims.
  - https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf
- Nguyễn Huệ cafe hop / 42 Nguyễn Huệ: travel sources describe the old apartment block on Nguyễn Huệ with stacked cafes, shops, balconies, and floor-by-floor tenants.
  - https://www.vietnamairlines.com/en/useful-information/travel-guide/the-cafe-apartment
- Cà phê sữa đá: coffee/travel sources describe the drink as Vietnamese coffee served over ice with condensed milk.
  - https://vietnam.travel/things-to-do/vietnamese-coffee
- Motorbike food tour: HCMC food-tour sources describe guided multi-stop evening routes by motorbike; copy stays operator-neutral.
  - https://saigonbackalleytours.com/saigon-street-food-motorbike-tour/

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

Simulator page left open: `viet-family-city-hcmc-place-cafe-hop-nguyen-hue`

Visible proof text:

> A Nguyễn Huệ cafe hop usually starts at the old 42 Nguyễn Huệ apartment block, where cafes and small shops stack above the city’s main walking street.

Screenshot:

`/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_78a641d4-eb01-4170-8400-845c1a6217e6.jpg`

Note: the first simulator proof attempt used the wrong launch flag and landed on Home. Relaunched with the correct `--detail-page` flag before taking the proof above.

## Phone Build

Physical iPhone build from this worktree:

- Build: succeeded.
- Install: succeeded.
- Launch: blocked because the iPhone was locked and iOS denied launch.

Signing hygiene:

- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean.
- Repo-visible signing scan: clean.

No personal signing settings were written into tracked project files.
