# Handwritten Recovery Batch 034 - 2026-06-03

## Scope

- `viet-family-city-hcmc-place-russian-market` - Chợ Nga - Russian Market
- `viet-family-city-hcmc-place-saigon-railway-station` - Ga Sài Gòn - Saigon Railway Station
- `viet-family-city-hcmc-place-saigon-river` - Sông Sài Gòn - Saigon River
- `viet-family-city-hcmc-place-saigon-river-boat` - Đi thuyền sông Sài Gòn - Saigon River boat ride
- `viet-family-city-hcmc-place-saigon-skydeck` - Saigon Skydeck - Saigon Skydeck

## Editorial Recovery Notes

- Russian Market now reads as a practical clothing-market browse for jackets, bags, textiles, clothes, and small gifts, with mall-vs-market expectations made clear.
- Saigon Railway Station now focuses on the travel-day sequence: tickets, signs, platform questions, waiting, baggage, and pickup timing.
- Saigon River now explains why the river helps orient central Saigon, Thu Thiem, bridges, skyline, and boat choices without pretending it is only scenery.
- Saigon River boat ride now stays operator-agnostic and makes the first user job clear: confirm pier, route, return point, schedule, and pickup.
- Saigon Skydeck now states that it is an indoor paid observation-deck stop and uses ticket, entrance, and photo phrase cards instead of generic walking phrases.

## QA Support

- Factual/source-risk QA subagent: `019e8acd-157a-7541-bcf6-7640cd10c0e1`
- Human-readability QA subagent: `019e8acd-2b4b-72c1-8828-1e79d03952f0`

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

Focused visible-copy banned-language scan passed for all five Batch 034 pages.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Simulator page left open: `viet-family-city-hcmc-place-saigon-skydeck`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-034-screenshots/001-hcmc-saigon-skydeck-top.jpg`
- Simulator build/run result: passed

## Phone Build

- Worktree explicitly pinned with `SPEAKLOCAL_REPO_ROOT`.
- Physical iPhone build: passed.
- Physical iPhone install: passed.
- Physical iPhone launch: blocked because the phone was locked.
- Repo signing hygiene scan: passed; no personal signing values were found in repo-visible project signing files.

## Progress

- Recovered through Batch 034: 169 / 520 pages.
- Remaining after Batch 034: 351 pages.
