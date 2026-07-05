# Handwritten Recovery Batch 023 - 2026-06-03

Status: COMPLETE_FOR_BATCH

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Previous recovered count: 109 / 520

Batch size: 5

Current recovered count: 114 / 520

Remaining: 406

Recovered source entries:

- `viet-family-city-hcmc-place-ca-phe-sua-da`
- `viet-family-city-hcmc-place-cafe-apartment-nguyen-hue`
- `viet-family-city-hcmc-place-cafe-hop-nguyen-hue`
- `viet-family-city-hcmc-place-cafe-vot-pham-ngoc-thach`
- `viet-family-city-hcmc-place-che`

## Copy Recovery Notes

- `ca-phe-sua-da` now explains the drink for a first-time U.S. reader: Vietnamese iced coffee with condensed milk, strong, sweet, cold, and useful after heat, walking, traffic, or pickup waits.
- `cafe-apartment-nguyen-hue` now says what the place is: the old 42 Nguyen Hue apartment block with cafes, small shops, signs, balconies, iced drinks, and views over the walking street.
- `cafe-hop-nguyen-hue` now frames the route plainly: start at 42 Nguyen Hue, pick one or two upstairs rooms, then return to the walking street.
- `cafe-vot-pham-ngoc-thach` now centers the coffee method: cloth-filter coffee, hot or iced, with condensed milk if wanted. The visible copy avoids overclaiming a fragile current street anchor.
- `che` now defines the dessert category and gives recognizable first choices such as che ba mau and che thap cam.

## QA Loop

Two read-only sub-agents reviewed the exact five-page scope after source inspection:

- Factual/source-risk QA checked current support and fragile claims.
- Human-readability/save-worthiness QA checked the copy against Jojo's U.S. first-time traveler lens.

Concrete QA fixes integrated:

- Replaced "less sugar" with "less condensed milk" for iced coffee accuracy.
- Added 42 Nguyen Hue, stairs/elevator, balcony-facing room, iced drinks, and street-view details for the Cafe Apartment.
- Removed unsupported landmark chains from the Nguyen Hue cafe-hop page and kept the route to the apartment block, walking street, river, and City Hall direction.
- Kept the ca phe vot page method-focused because the exact Pham Ngoc Thach public-source anchor is weaker than the coffee-style evidence.
- Replaced abstract dessert guidance with concrete pointing behavior and first-choice names for che.
- Removed visible phrases that read like app labels or AI texture, including "works because," "the day needs a pause," "stable thing," "rhythm," and "long drink list."

## Freshness Sources Checked

- Vietnamese iced coffee reference: https://7kafe.vn/en/blog/vietnamese-iced-coffee/
- Vietnamese iced coffee reference: https://go2-vietnam.com/en/drinks/ca-phe-sua-da/
- Vietnamese iced coffee overview: https://en.wikipedia.org/wiki/Vietnamese_iced_coffee
- Vietnam Airlines guide to the Cafe Apartment: https://www.vietnamairlines.com/gb/en/plan-book/travel/travel-guide/the-cafe-apartment
- Remembrew guide to 42 Nguyen Hue: https://remembrew.com/cafes/cafe-apartment-building-42-nguyen-hue-ho-chi-minh-city/
- Nguyen Hue Boulevard overview: https://en.wikipedia.org/wiki/Nguy%E1%BB%85n_Hu%E1%BB%87_Boulevard
- Ca phe vot cultural reference: https://vntravellive.com/en/ca-phe-vot-van-hoa-ca-phe-dam-chat-sai-gon-d35719.html
- Vietcetera coffee reference: https://vietcetera.com/amp/vn/mot-vong-the-gioi-ca-phe-ngon-dau-chi-pha-phin
- Che ba mau reference: https://www.takeaway.com/foodwiki/vietnam/che-ba-mau/
- Che ba mau reference: https://www.hungryhuy.com/che-ba-mau/
- Che overview: https://en.wikipedia.org/wiki/Ch%C3%A8

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

- First run caught banned visible phrases `layer` and `not a`; fixed in source and reran.
- Second run caught missing cafe sensory cues on `city-hcmc-place-cafe-apartment-nguyen-hue`; fixed in source and reran.
- Final run passed all gates with production QA reporting 0 blockers and 0 majors.

## Render Proof

Simulator profile: `city-listings-production-ready`

Simulator: `SpeakLocal City Listings`

Rendered page left open for review: `viet-family-city-hcmc-place-cafe-apartment-nguyen-hue`

Live Simulator screenshot:

- `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_68afd0f6-9900-4bc0-be7c-7f2e1e239f48.jpg`

Proof screenshots:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-023-screenshots/001-hcmc-cafe-cafe-apartment-nguyen-hue-top.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-023-screenshots/001-hcmc-cafe-cafe-apartment-nguyen-hue-middle.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-023-screenshots/001-hcmc-cafe-cafe-apartment-nguyen-hue-bottom.png`

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

Batch 023 is complete. The overall recovery goal remains active at 114 / 520 recovered.
