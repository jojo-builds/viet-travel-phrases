# Handwritten Recovery Batch 035 - 2026-06-03

## Scope

- `viet-family-city-hcmc-place-saigon-square` - Saigon Square - Saigon Square
- `viet-family-city-hcmc-place-southern-women-museum` - Bảo tàng Phụ nữ Nam Bộ - Southern Women's Museum
- `viet-family-city-hcmc-place-street-food-evening` - Ăn vặt Sài Gòn buổi tối - Saigon street-food evening
- `viet-family-city-hcmc-place-takashimaya-saigon-centre` - Saigon Centre - Takashimaya Saigon Centre
- `viet-family-city-hcmc-place-tan-son-nhat-airport` - Sân bay Tân Sơn Nhất - Tan Son Nhat International Airport

## Editorial Recovery Notes

- Saigon Square now reads as a quick indoor bargain-shopping stop near Ben Thanh, with first-lap, size, color, price, and brand-style quality-check expectations.
- Southern Women's Museum now explains the specific museum subject: southern Vietnamese women's history, wartime roles, family life, clothing, photographs, textiles, and everyday objects.
- Saigon street-food evening now uses food-ordering phrase cards instead of route-finding cards, matching the small-order, portion, and spice decisions in the visible copy.
- Takashimaya Saigon Centre now uses the visible Saigon Centre context and reads as a practical indoor reset for food counters, bathrooms, meetups, cool air, and central regrouping.
- Tan Son Nhat International Airport now includes terminal and arrival-form freshness context while keeping exact pickup doors, prices, and airline rules out of visible copy.

## QA Support

- Factual/source-risk QA subagent: `019e8ae0-505c-7931-b5d7-c28fab434901`
- Human-readability QA subagent: `019e8ae0-5da8-7b83-8f91-a090fda15b5e`

## Validation

Passed:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
git diff --check
```

Focused visible-copy banned-language scan passed for all five Batch 035 pages.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Simulator page left open: `viet-family-city-hcmc-place-southern-women-museum`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-035-screenshots/001-hcmc-southern-women-museum-top.jpg`
- Simulator build/run result: passed

## Phone Build

- Worktree explicitly pinned with `SPEAKLOCAL_REPO_ROOT`.
- Physical iPhone build: passed.
- Physical iPhone install: passed.
- Physical iPhone launch: blocked because the phone was locked.
- Repo signing hygiene scan: passed; no personal signing values were found in repo-visible project signing files.

## Progress

- Recovered through Batch 035: 174 / 520 pages.
- Remaining after Batch 035: 346 pages.
