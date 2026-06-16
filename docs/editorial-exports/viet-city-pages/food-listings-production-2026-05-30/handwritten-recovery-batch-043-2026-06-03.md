# Handwritten Recovery Batch 043

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered 5 Hue entries from v2.2 source into handwritten production copy:

- `viet-family-city-hue-place-chu-van-an-street` - Chu Van An Street
- `viet-family-city-hue-place-com-am-phu` - Com am phu
- `viet-family-city-hue-place-com-hen` - Com hen
- `viet-family-city-hue-place-cyclo-citadel-loop` - Citadel cyclo loop
- `viet-family-city-hue-place-dai-nam-restaurant` - Dai Nam Restaurant

Progress after this batch: 214 / 520 recovered. Remaining: 306.

## Editorial Notes

- Folded factual/source-risk QA into the food pages so unfamiliar names and ingredients are visible to U.S. first-time travelers.
- `Com am phu` now explains the translated "hell rice" name and describes the plate directly: rice, pork, egg, shrimp or shrimp floss, herbs, vegetables, and fish-sauce-style dressing.
- `Com hen` now calls out shellfish, peanuts, shrimp paste, fish sauce, and pork cracklings as common concern points.
- `Citadel cyclo loop` now includes fare, duration, and route agreement instead of only romantic route language.
- `Dai Nam Restaurant` now names Hue cakes, the Imperial City context, and likely shrimp/pork/fish-sauce concerns.
- Replaced label-like headings such as "Useful For Bearings," "Visual Opening Impression," and "Hue Cakes Matter" with more human-readable headings.

## Sub-Agent QA

- Factual/source-risk QA: `019e8b68-6668-7dd1-b0f1-2d575d236ffa`
  - Result: revise requested for `com-am-phu`, `com-hen`, `cyclo-citadel-loop`, and `dai-nam-restaurant`; feedback folded into source.
- U.S. first-time traveler readability QA: `019e8b68-73bc-74f2-b043-384292a5c5d6`
  - Result: revise requested for label-like headings and duplicate cyclo heading; feedback folded into source.

## Validation

Focused Batch 043 visible-copy scan: PASS.

Full chain: PASS.

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

Validation summary:

- v2.2 source projection: 520 entries.
- Strict production validation: 520 pass, 0 revise, 0 fail.
- City production copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library validation: 826 pages.
- SQLite fixture validation: PASS.
- Listing production QA: 0 blockers, 0 majors.
- `git diff --check`: PASS.

## Render Proof

Simulator profile: `city-listings-production-ready`
Simulator: `SpeakLocal City Listings`

Rendered page left open for review:

- `viet-family-city-hue-place-com-am-phu`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-043-screenshots/001-hue-com-am-phu-top.jpg`

## Phone Build

Physical iPhone build from this worktree:

- Build: PASS.
- Install: PASS.
- Launch: blocked because the phone was locked.
- Post-build repo signing scan: PASS.
- `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` remained free of repo-visible personal signing settings.
