# Handwritten Recovery Batch 033 - 2026-06-03

## Scope

- `viet-family-city-hcmc-place-pham-ngu-lao-street` - Phố Phạm Ngũ Lão - Pham Ngu Lao Street
- `viet-family-city-hcmc-place-pho-hoa-pasteur` - Phở Hòa Pasteur - Pho Hoa Pasteur
- `viet-family-city-hcmc-place-pho-nam` - Phở Sài Gòn ở Thành phố Hồ Chí Minh - Southern pho
- `viet-family-city-hcmc-place-post-office` - Bưu điện Thành phố - Saigon Central Post Office
- `viet-family-city-hcmc-place-rex-hotel-rooftop` - Sân thượng khách sạn Rex - Rex Hotel rooftop

## Editorial Recovery Notes

- Phạm Ngũ Lão now reads as a backpacker-area logistics street with real bus offices, budget stays, Bùi Viện contrast, and exact pickup doors.
- Phở Hòa Pasteur now explains the fast working-room feel, keeps the 260C Pasteur address, and softens ranking language into a first-reference role.
- Southern pho keeps the table-adjusted herb/sprout/lime/sauce explanation for first-time readers.
- Saigon Central Post Office now states the public-post-office context and avoids abstract old-city language.
- Rex Hotel rooftop now reads as a rooftop bar/restaurant, not a free public viewpoint; phrase cards now support table, menu, and reservation use, and the duplicate Nguyễn Huệ related card was removed.

## QA Support

- Factual/source-risk QA subagent: `019e8abe-4921-71c2-8bdf-7f0ccb05cd12`
- Human-readability QA subagent: `019e8abe-5712-7d83-8ce9-6192119eff41`

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

Focused visible-copy banned-language scan passed for all five Batch 033 pages.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Simulator page left open: `viet-family-city-hcmc-place-rex-hotel-rooftop`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-033-screenshots/001-hcmc-rex-hotel-rooftop-top.jpg`
- Simulator build/run result: passed

## Phone Build

- Worktree explicitly pinned with `SPEAKLOCAL_REPO_ROOT`.
- Physical iPhone build: passed.
- Physical iPhone install: passed.
- Physical iPhone launch: blocked because the phone was locked.
- Repo signing hygiene scan: passed; no personal signing values were found in repo-visible project signing files.

## Progress

- Recovered through Batch 033: 164 / 520 pages.
- Remaining after Batch 033: 356 pages.
