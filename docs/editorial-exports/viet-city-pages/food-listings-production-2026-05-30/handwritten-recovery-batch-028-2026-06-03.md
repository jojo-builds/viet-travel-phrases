# Handwritten Recovery Batch 028

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Recovered five HCMC V2.2 source listings:

- `viet-family-city-hcmc-place-golden-dragon-water-puppet`
- `viet-family-city-hcmc-place-history-museum`
- `viet-family-city-hcmc-place-ho-chi-minh-city-museum`
- `viet-family-city-hcmc-place-ho-thi-ky-flower-market`
- `viet-family-city-hcmc-place-hu-tieu`

Progress after this batch: 139 / 520 recovered, 381 remaining.

## Human Rewrite Notes

- Golden Dragon Water Puppet Theater now explains that this is a ticketed Vietnamese water-puppet show, not a drop-in landmark. The copy explains the water stage, musicians, showtime planning, and why the performance can still be followed when some Vietnamese is unfamiliar.
- Museum of Vietnamese History now distinguishes itself from Ho Chi Minh City Museum. It names the zoo-and-botanical-garden setting and focuses the page on older artifacts and wider Vietnamese history.
- Ho Chi Minh City Museum now identifies the former Gia Long Palace / District 1 city-history role, instead of vague "city-history room" language.
- Ho Thi Ky Flower Market now reads as a District 10 working flower lane with nearby food streets, delivery movement, and practical lane etiquette.
- Hu tieu now explains the food for a U.S. first-time visitor: southern noodle dish, hủ tiếu nước vs hủ tiếu khô, clear broth or dry noodles, common toppings, and the phở comparison.

## Review Loop

Two sub-agent reviews were used:

- Factual/source-risk QA: `019e8a47-8320-70c2-b60c-eec36398407a`
- Human-readability QA: `019e8a4c-853f-7b42-8da3-63f058dbf769`

Reviewer-driven fixes applied:

- Removed app-internal language such as "this page."
- Removed formulaic `works well`, duplicate `stage, stage`, and repeated heading cadence.
- Replaced negative-definition phrasing such as `not a...` with direct descriptions.
- Reduced `feel/feels/feeling` usage so the voice audit passes.
- Changed label-like headings such as `A Central Reset`, `Use A Focused Route`, and `Real Flower Trade`.

## Validation

Command chain passed:

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

Result:

- V2.2 strict production validation: PASS
- Voice audit failures: none
- City copy validation: PASS
- City library validation: PASS
- SQLite fixture validation: PASS
- Production QA audit: 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator build/run succeeded on `SpeakLocal City Listings` with launch arg:

```sh
--detail-page viet-family-city-hcmc-place-hu-tieu
```

Screenshot:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-028-screenshots/001-hcmc-hu-tieu-top.jpg`

The Simulator was left open on the revised hủ tiếu listing for Jojo review.

## Phone Build

Physical iPhone build and install were run via the SpeakLocal device-build helper with `SPEAKLOCAL_REPO_ROOT` pointed at this worktree.

Result:

- Build: PASS
- Install: PASS
- Launch: blocked because the phone was locked
- Signing hygiene: repo project files stayed clean
