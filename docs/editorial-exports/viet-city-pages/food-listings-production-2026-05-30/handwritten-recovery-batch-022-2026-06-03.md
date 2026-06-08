# Handwritten Recovery Batch 022 - 2026-06-03

Status: COMPLETE_FOR_BATCH

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Previous recovered count: 104 / 520

Batch size: 5

Current recovered count: 109 / 520

Remaining: 411

Recovered source entries:

- `viet-family-city-hcmc-place-bun-bo-hue-14b`
- `viet-family-city-hcmc-place-pho-le-district-5`
- `viet-family-city-hcmc-place-pho-minh`
- `viet-family-city-hcmc-place-pho-huong-binh`
- `viet-family-city-hcmc-place-bun-thit-nuong`

## Copy Recovery Notes

- Bún Bò Huế 14B now explains what the dish is, why a District 4 shop matters, how the bowl differs from phở, and what toppings/heat choices a first-time visitor should expect.
- Phở Lệ now frames the page as southern beef phở in District 5, with rich broth, table herbs/sauces, and mixed beef cuts instead of a vague "full and southern" label.
- Phở Minh now makes the save reason explicit: narrow Pasteur alley, since 1945, beef-cut choice, and pâté chaud for a slower breakfast.
- Phở Hương Bình now centers the real group decision: chicken phở or beef phở in one second-generation shop, with add-ons that change the bowl.
- Bún thịt nướng now reads as a useful southern dish page: grilled pork, cool vermicelli, herbs, pickles, peanuts, fish-sauce dressing, and a hot-day contrast with soup bowls.

## QA Loop

Two read-only sub-agents reviewed the exact five-page scope after source inspection:

- Factual/source-risk QA checked current support and fragile claims.
- Human-readability/save-worthiness QA checked the copy against Jojo's U.S. first-time traveler lens.

Concrete QA fixes integrated:

- Removed broad "phở is beef noodle soup" framing where chicken phở matters.
- Removed weak visible-copy phrasing such as "the appeal is" and app-like "save reason" language.
- Added source-backed restaurant texture for 14B so the page reads as a place, not only a bowl definition.
- Replaced repeated "feel/feels" lines in the batch with plainer nouns and verbs.

## Freshness Sources Checked

- Michelin feature on Bún Bò Huế 14B: https://guide.michelin.com/vn/en/article/dining-out/behind-the-bib-bun-bo-hue-14b
- Michelin page for Phở Lệ District 5: https://guide.michelin.com/us/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/pho-le-district-5
- Michelin page for Phở Minh: https://guide.michelin.com/us/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/pho-minh
- Michelin page for Phở Hương Bình: https://guide.michelin.com/us/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/pho-huong-binh
- TasteAtlas bún thịt nướng reference: https://www.tasteatlas.com/bun-thit-nuong
- NGON Vietnam bún thịt nướng reference: https://ngon-vietnam.com/bun-thit-nuong/

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

- First run caught banned visible phrase `fits when`; fixed in source and reran.
- Second run caught global `feel/feels/feeling` drift by one entry; fixed in this batch and reran.
- Third run caught missing restaurant texture for Bún Bò Huế 14B; fixed in source and reran.
- Final run passed all gates with production QA reporting 0 blockers and 0 majors.

## Render Proof

Simulator profile: `city-listings-production-ready`

Simulator: `SpeakLocal City Listings`

Rendered page left open for review: `viet-family-city-hcmc-place-bun-bo-hue-14b`

Proof screenshots:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-022-screenshots/001-hcmc-restaurant-bun-bo-hue-14b-top.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-022-screenshots/001-hcmc-restaurant-bun-bo-hue-14b-middle.png`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-022-screenshots/001-hcmc-restaurant-bun-bo-hue-14b-bottom.png`

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

Batch 022 is complete. The overall recovery goal remains active at 109 / 520 recovered.
