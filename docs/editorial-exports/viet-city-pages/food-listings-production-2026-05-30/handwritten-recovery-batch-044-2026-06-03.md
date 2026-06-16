# Handwritten Recovery Batch 044

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered 5 Hue entries from v2.2 source into handwritten production copy:

- `viet-family-city-hue-place-de-po-cafe` - De Po Cafe
- `viet-family-city-hue-place-diem-phung-thi-art-center` - Diem Phung Thi Art Center
- `viet-family-city-hue-place-dien-tho-palace` - Dien Tho Palace
- `viet-family-city-hue-place-dong-ba` - Dong Ba Market
- `viet-family-city-hue-place-dong-ba-bun-bo` - Bun bo at Dong Ba Market

Progress after this batch: 219 / 520 recovered. Remaining: 301.

## Editorial Notes

- Added specific "why this one" context instead of generic stop/value language.
- `De Po Cafe` now explains the upstairs Dong Ba Market setting, balcony view, and why it belongs to a market day.
- `Diem Phung Thi Art Center` now explains the Hue-born artist, the donated work, and the repeated geometric-form idea a first-time visitor can actually look for.
- `Dien Tho Palace` now clearly identifies the queen mother residence role inside the Imperial City.
- `Dong Ba Market` now frames the historic central market near the Perfume River and names food, fabric, sweets, gifts, and daily shopping.
- `Bun bo at Dong Ba Market` now ties the bowl to the market setting while removing the over-specific unsourced stool-level claim.
- Removed crutch language that failed the voice audit, including excess `feel` usage and `are enough`.

## Sub-Agent QA

- Factual/source-risk QA: `019e8b7c-b22f-7e61-9030-86b2df0ef2f6`
  - Result: PASS for 4 pages; REVISE for `dong-ba-bun-bo` due to unsourced `stool-level eating`; feedback folded into source.
- U.S. first-time traveler readability QA: `019e8b7c-c945-7a33-9ee4-e8bf9381b340`
  - Result: PASS for 2 pages; REVISE for `de-po-cafe`, `dong-ba`, and `dong-ba-bun-bo`; line-level voice feedback folded into source.

## Validation

Focused Batch 044 visible-copy scan: PASS.

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

- `viet-family-city-hue-place-dong-ba`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-044-screenshots/001-hue-dong-ba-top.jpg`

## Phone Build

Physical iPhone build from this worktree:

- Build: PASS.
- Install: PASS.
- Launch: blocked because the phone was locked.
- Post-build repo signing scan: PASS.
- `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` remained free of repo-visible personal signing settings.
