# Handwritten Recovery Batch 025 - 2026-06-03

Status: COMPLETE_FOR_BATCH

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Previous recovered count: 119 / 520

Batch size: 5

Current recovered count: 124 / 520

Remaining: 396

Recovered source entries:

- `viet-family-city-hcmc-place-coco-dining`
- `viet-family-city-hcmc-place-com-tam`
- `viet-family-city-hcmc-place-com-tam-ba-ghien`
- `viet-family-city-hcmc-place-cong-ca-phe-dong-khoi`
- `viet-family-city-hcmc-place-cu-chi-day-trip`

## Copy Recovery Notes

- Coco Dining now reads as a reservation-worthy tasting dinner: Lữ Hành menu, Vietnamese regions and farmers, optional pairings, courses, CoCo Bar context, and a planned evening rather than abstract “journey menu” copy.
- Cơm tấm now adds more sensory broken-rice detail and narrows the meal claim to breakfast or lunch.
- Cơm tấm Ba Ghiền now makes the pork chop the reason to go and treats egg/add-ons as choices rather than default guarantees.
- Cộng Cà Phê Đồng Khởi now uses the official Vincom branch framing, avoids implying a street storefront, and explains coconut coffee as a sweet, creamy signature order.
- Củ Chi day trip now explains Bến Dược / Bến Đình visitor-route context, heat, uneven ground, guide stops, and half-day energy without overclaiming exact schedules or mandatory tunnel crawling.

## QA Loop

Two read-only sub-agents reviewed the exact five-page scope:

- Factual/source-risk QA checked current support and fragile claims.
- Human-readability/save-worthiness QA checked the copy against Jojo's U.S. first-time traveler lens.

Concrete QA fixes integrated:

- Replaced seasonal `current Lữ Hành` wording with `source-checked Lữ Hành`.
- Replaced abstract Coco language with physical dinner expectations: reservation, paced courses, pairings, longer table, and nearby CoCo Bar.
- Changed Ba Ghiền egg language so egg and extra pieces are optional add-ons.
- Replaced Cộng's vague central-loop language with official Vincom Đồng Khởi branch context.
- Removed `the appeal is`, `its value is`, `works naturally`, `not a...`, and other mechanical contrast phrasing before validation.
- Added Củ Chi first-time-visitor value: heat, uneven ground, outdoor paths, Bến Dược / Bến Đình, and guide context.

## Freshness Sources Checked

- CoCo Dining official page: https://cocosgn.com/coco-dining/
- CoCo Saigon about/philosophy: https://cocosgn.com/about-us/
- Michelin 2025 Vietnam press release: https://www.michelin.com/en/publications/products-and-services/the-2025-michelin-guide-hanoi
- Michelin Coco Dining listing: https://guide.michelin.com/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/coco-dining
- Michelin article on cơm tấm / Ba Ghiền: https://guide.michelin.com/vn/en/article/dining-out/what-is-com-tam-com-tam-ba-ghien
- Cộng Coconut Coffee official product page: https://congcaphe.com/product/1069/coconut-coffee
- Cộng Vincom Đồng Khởi official branch page: https://congcaphe.com/store-detail/ho-chi-minh/351/cong-caphe-vincom-dong-khoi
- Vietnam Tourism Củ Chi Tunnels: https://vietnamtourism.vn/en/index.php/tourism/items/274

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

- Pre-validation sweep caught visible `not a...` contrast phrasing and removed it in source before running the full chain.
- Final run passed all gates with production QA reporting 0 blockers and 0 majors.

## Render Proof

Simulator profile: `city-listings-production-ready`

Simulator: `SpeakLocal City Listings`

Rendered page left open for review: `viet-family-city-hcmc-place-cong-ca-phe-dong-khoi`

Proof screenshots:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-025-screenshots/001-hcmc-cafe-cong-ca-phe-dong-khoi-top.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-025-screenshots/001-hcmc-cafe-cong-ca-phe-dong-khoi-middle.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-025-screenshots/001-hcmc-cafe-cong-ca-phe-dong-khoi-bottom.png`

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

Batch 025 is complete. The overall recovery goal remains active at 124 / 520 recovered.
