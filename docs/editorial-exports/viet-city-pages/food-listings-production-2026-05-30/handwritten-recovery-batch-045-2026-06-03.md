# Handwritten Recovery Batch 045

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered 5 Hue entries from v2.2 source into handwritten production copy:

- `viet-family-city-hue-place-dong-khanh-tomb` - Tomb of Dong Khanh
- `viet-family-city-hue-place-duc-duc-tomb` - Tomb of Duc Duc
- `viet-family-city-hue-place-duyet-thi-duong-theater` - Duyet Thi Duong Royal Theater
- `viet-family-city-hue-place-flag-tower` - Hue Flag Tower
- `viet-family-city-hue-place-forbidden-purple-city` - Forbidden Purple City

Progress after this batch: 224 / 520 recovered. Remaining: 296.

## Editorial Notes

- Added clearer first-time-traveler hooks for Hue heritage pages so they do not blur into generic palace/tomb language.
- `Dong Khanh Tomb` now explains the mixed-period architecture, red-and-gold details, tiled roofs, courtyard sequence, and why it pairs with Tu Duc.
- `Duc Duc Tomb` now explains the short reign context and why the modest tomb matters at human scale.
- `Duyet Thi Duong Royal Theater` now explains that this is the royal theater inside the Citadel, tied to nhã nhạc court music and performance culture.
- `Hue Flag Tower` now frames the tower as the visual orientation marker before Ngo Mon Gate and the Imperial City.
- `Forbidden Purple City` now explains the unfamiliar name as the emperor's private palace area inside the Citadel, with ruins, restored walkways, foundations, gardens, and missing buildings.
- Folded readability QA while avoiding label-like suggestions such as `Why Save It`, `not another`, and template-starting `Use...`.

## Sub-Agent QA

- Factual/source-risk QA: `019e8b89-d1dc-78b0-b9ed-23a902c7922b`
  - Result: PASS for all 5 pages.
- U.S. first-time traveler readability QA: `019e8b89-e8e7-7781-846b-da793d07b38c`
  - Result: PASS for `forbidden-purple-city`; REVISE for 4 pages; feedback folded into source.

## Validation

Focused Batch 045 visible-copy scan: PASS.

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

- `viet-family-city-hue-place-forbidden-purple-city`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-045-screenshots/001-hue-forbidden-purple-city-top.jpg`

## Phone Build

Physical iPhone build from this worktree:

- Build: PASS.
- Install: PASS.
- Launch: PASS.
- Post-build repo signing scan: PASS.
- `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` remained free of repo-visible personal signing settings.
