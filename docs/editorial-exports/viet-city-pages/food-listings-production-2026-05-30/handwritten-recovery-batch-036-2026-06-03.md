# Handwritten Recovery Batch 036 - 2026-06-03

## Scope

- `viet-family-city-hcmc-place-tao-dan-park` - Công viên Tao Đàn - Tao Dan Park
- `viet-family-city-hcmc-place-thao-dien` - Thảo Điền - Thao Dien
- `viet-family-city-hcmc-place-thien-hau-pagoda` - Chùa Bà Thiên Hậu - Thien Hau Pagoda
- `viet-family-city-hcmc-place-thu-thiem-riverfront` - Bờ sông Thủ Thiêm - Thu Thiem riverfront
- `viet-family-city-hcmc-place-ton-duc-thang-museum` - Bảo tàng Tôn Đức Thắng - Ton Duc Thang Museum

## Editorial Recovery Notes

- Tao Dan Park now avoids defensive “whole point” language and explains the park as shade, benches, walkers, and ordinary central Saigon park life.
- Thao Dien passed QA as a slower riverside cafe/restaurant pocket; its related-card reason was cleaned of visible “Related because” boilerplate.
- Thien Hau Pagoda now explains the Chinese-community and Thiên Hậu sea-goddess context and replaces the unrelated Bạch Đằng Wharf card with Chợ Lớn district context.
- Thu Thiem riverfront now avoids command-like “Do not expect” wording while keeping the skyline, dusk, weather, and crossing payoff clear.
- Ton Duc Thang Museum now explains President Tôn Đức Thắng, removes generic “objects and memory” copy, and swaps ticket-counter phrasing for closing-time/photo/entrance phrases.

## QA Support

- Factual/source-risk QA subagent: `019e8aec-dc18-7732-b54e-550e7f98e9ae`
- Human-readability QA subagent: `019e8aec-ef83-7a60-914d-17ae70d7fa18`

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

Focused visible-copy banned-language scan passed for all five Batch 036 pages.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Simulator page left open: `viet-family-city-hcmc-place-ton-duc-thang-museum`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-036-screenshots/001-hcmc-ton-duc-thang-museum-top.jpg`
- Simulator build/run result: passed

## Phone Build

- Worktree explicitly pinned with `SPEAKLOCAL_REPO_ROOT`.
- Physical iPhone build: passed.
- Physical iPhone install: passed.
- Physical iPhone launch: blocked because the phone was locked.
- Repo signing hygiene scan: passed; no personal signing values were found in repo-visible project signing files.

## Progress

- Recovered through Batch 036: 179 / 520 pages.
- Remaining after Batch 036: 341 pages.
