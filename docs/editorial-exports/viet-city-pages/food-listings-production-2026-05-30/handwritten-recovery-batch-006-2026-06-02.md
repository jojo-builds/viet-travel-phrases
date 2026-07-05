# Handwritten Recovery Batch 006 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 006 is complete as a five-page authored recovery batch. It is not a global production-ready claim for all 520 listings.

This batch focused on Hanoi food pages where the reader needed more than a famous name or a dish label. The work made the dish definition, first ordering/table behavior, and place-to-place comparison clearer for first-time U.S.-based visitors.

## Pages Recovered

1. `city-hanoi-place-banh-cuon-ba-hoanh`
   - Before: named the steam-table breakfast but still leaned on soft food imagery without enough plain-English dish explanation or audience cue.
   - After: defines bánh cuốn as steamed rice rolls, explains soft-not-crispy texture, fish-sauce dip, morning meal role, and the lighter-classic contrast with Bà Xuân.

2. `city-hanoi-place-banh-cuon-ba-xuan`
   - Before: had good ingredient detail but still assumed readers understood the dish and why egg or sausage mattered.
   - After: defines bánh cuốn through soft steamed rice rolls, then explains the fuller plate: pork-and-mushroom filling, herbs, dipping sauce, egg, sausage, and why extras should not bury the rice sheets.

3. `city-hanoi-place-bun-cha-dac-kim`
   - Before: had useful sauce and mango detail but still did not define bún chả early enough for first-time visitors.
   - After: defines bún chả as Hanoi grilled pork with rice noodles, herbs, and warm dipping broth, then makes Đắc Kim specific through sweet fish-sauce dip, pickled green mango, smoky slices, and pork patties.

4. `city-hanoi-place-pho-bat-dan`
   - Before: described steam and a short Old Quarter meal, but did not define phở or clarify why this page should exist beside other phở shops.
   - After: defines phở and phở bò, adds a Mentioned Here dish candidate, and compares Bát Đàn against Phở Gia Truyền as the plainer Old Quarter counter-feeling bowl.

5. `city-hanoi-place-pho-gia-truyen`
   - Before: already explained phở bò, but the page still needed a sharper first-Hanoi-baseline role and a clearer contrast with Bát Đàn.
   - After: frames Gia Truyền as a first Hanoi phở baseline: clear broth, rice noodles, sliced beef, herbs, moving line, beef-cut choices, and a focused Old Quarter bowl.

## Source Files Edited

- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`
- Regenerated projection/source:
  - `content-draft/viet/city-library/v1.json`
  - `native-ios/Resources/viet-authored-listing-pages.json`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
  - `docs/content-audits/viet-city-copy-production-2026-05-17.json`
  - `docs/content-audits/viet-listing-production-qa-001/*`

## Validation

Passed after the final rewrite/regeneration pass:

```sh
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

Validation result highlights:

- V2.2 app-detail strict production validation: `PASS`
- Voice audit: `failures: []`
- City production copy: 5 hubs, 520 city noun pages, 520 unique target heroes
- City library: 826 pages, 726 beginner, 95 intermediate, 5 advanced
- SQLite integrity check: `ok`
- Listing production QA: 0 blockers, 0 majors
- `git diff --check`: clean

## Phone Build

Physical iPhone build was attempted from this feature worktree after regenerated resources changed.

- Build: succeeded
- Install: succeeded
- Launch: blocked because the phone was locked; iOS refused to open the app until the device is unlocked
- Signing hygiene: repo signing files stayed clean
- Explicit signing-file status: no modified `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- Explicit signing scan: no personal team, provisioning, certificate, or phone-specific signing values were found in those repo files

## Copy Judgment

This batch continued the human-readable recovery pattern:

- It defines the dish before expecting the reader to care.
- It explains table behavior in plain English.
- It gives the place a role beside a nearby or same-dish alternative.
- It avoids hours, prices, booking, fragile current-award claims, app-internal language, and save-command wording.

The validators caught source-level issues after writing: a template-like `Use...` heading, a repeated-word pattern, and a missing restaurant texture cue. Those were fixed in authored copy rather than by weakening validation.

## Remaining Work

30 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages
- Batch 003: 5 pages
- Batch 004: 5 pages
- Batch 005: 5 pages
- Batch 006: 5 pages

Remaining authored recovery scope: 490 listings.

Continue with small batches chosen from high-visibility food pages, screenshot-flagged pages, unfamiliar food/place/format terms, and pages that pass validators while still failing the first-time traveler read.
