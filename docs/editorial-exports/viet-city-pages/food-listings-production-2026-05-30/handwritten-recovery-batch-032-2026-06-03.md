# Handwritten Recovery Batch 032 - 2026-06-03

## Scope

- `viet-family-city-hcmc-place-oc` - Ốc Sài Gòn ở Thành phố Hồ Chí Minh - Saigon snails and seafood
- `viet-family-city-hcmc-place-opera-a-o-show` - À Ố Show - A O Show at Saigon Opera House
- `viet-family-city-hcmc-place-opera-house` - Nhà hát Thành phố - Saigon Opera House
- `viet-family-city-hcmc-place-pasteur-street` - Đường Pasteur - Pasteur Street
- `viet-family-city-hcmc-place-pha-lau` - Phá lấu ở Thành phố Hồ Chí Minh - Pha lau

## Editorial Recovery Notes

- Ốc now explains that Saigon ốc is more than literal snails: a night shellfish table with shared plates, sauces, cold drinks, and a group-ordering rhythm.
- À Ố Show now leads with the actual performance type: Vietnamese bamboo circus, acrobatics, dance, live music, bamboo props, and a ticketed Opera House evening.
- Saigon Opera House got lighter heading cleanup while preserving the difference between exterior landmark and working theatre.
- Pasteur Street now reads as an address street, not a vague walk: exact number, doorway, District 1 / District 3 corridor, and Pasteur Institute context.
- Phá lấu keeps the offal explanation plain for U.S. readers and adds common organ-cut examples without exoticizing the dish.

## QA Support

- Factual/source-risk QA subagent: `019e8aa5-12ad-7861-b587-45524da4f7d2`
- Human-readability QA subagent: `019e8aa5-23a5-7562-8d57-b2bcd5b16758`

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

Focused visible-copy banned-language scan passed for all five Batch 032 pages.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Simulator page left open: `viet-family-city-hcmc-place-oc`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-032-screenshots/001-hcmc-oc-top.jpg`
- Simulator build/run result: passed

## Phone Build

- Worktree explicitly pinned with `SPEAKLOCAL_REPO_ROOT`.
- Physical iPhone build: passed.
- Physical iPhone install: passed.
- Physical iPhone launch: blocked because the phone was locked.
- Repo signing hygiene scan: passed; no personal signing values were found in repo-visible project signing files.

## Progress

- Recovered through Batch 032: 159 / 520 pages.
- Remaining after Batch 032: 361 pages.
