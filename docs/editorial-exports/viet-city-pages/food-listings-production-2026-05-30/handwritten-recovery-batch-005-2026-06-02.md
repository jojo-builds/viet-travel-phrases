# Handwritten Recovery Batch 005 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 005 is complete as a five-page authored recovery batch. It is not a global production-ready claim for all 520 listings.

This batch focused on high-visibility food pages where the earlier copy assumed too much: bánh mì, phở, and bún chả needed plain-English definitions, table behavior, comparison logic, and a stronger reason for a first-time U.S.-based visitor to care.

Length was not treated as the enemy. The standard for this batch was value per line: a field may be longer when it explains the food, the ordering moment, or the reason this place belongs in the trip.

## Pages Recovered

1. `city-hcmc-place-banh-mi-huynh-hoa`
   - Before: framed Huỳnh Hoa as a named sandwich shop, but did not define bánh mì or explain why this shop is useful to picture.
   - After: defines bánh mì as Vietnam's baguette sandwich, names pâté, butter, cold cuts, pickles, herbs, chili, line pace, and takeaway expectations.

2. `city-hcmc-place-pho-le-district-5`
   - Before: described a generous District 5 bowl, but still assumed readers knew phở and why the District 5 comparison mattered.
   - After: defines phở as Vietnamese beef noodle soup, explains southern-style table add-ins, beef-cut choices, and why Phở Lệ is worth leaving the central Pasteur Street pattern for.

3. `city-hcmc-place-pho-hoa-pasteur`
   - Before: readable but still mostly role language: central, familiar, busy, useful beside Phở Lệ.
   - After: defines phở, frames Phở Hòa Pasteur as a practical first Saigon bowl, and explains the herbs, sprouts, lime, sauces, room pace, and comparison to Phở Lệ.

4. `city-hanoi-place-bun-cha-huong-lien`
   - Before: said Hương Liên was famous and dish-focused, but did not define bún chả or explain the familiar U.S. reference.
   - After: defines bún chả as Hanoi grilled pork with rice noodles, herbs, and warm dipping broth, then explains the Obama and Anthony Bourdain context without letting fame replace the food.

5. `city-hanoi-place-bun-cha-ta`
   - Before: more concrete than some pages, but still assumed the dish and Old Quarter role were obvious.
   - After: defines bún chả, gives Bún Chả Ta a clearer seated Old Quarter role, and compares it naturally against Hương Liên's fame.

## Source Files Edited

- `content-draft/viet/city-library/handwritten-copy/hcmc.json`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`
- Regenerated projection/source:
  - `content-draft/viet/city-library/v1.json`
  - `native-ios/Resources/viet-authored-listing-pages.json`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
  - `docs/content-audits/viet-city-copy-production-2026-05-17.json`
  - `docs/content-audits/viet-listing-production-qa-001/*`

## Source Checks

- Bún chả Hương Liên: public check confirmed the Obama / Anthony Bourdain meal context and the dish format before adding that explanation to visible copy.
  - VOV: `https://vovworld.vn/en-US/thats-life/obama-grilled-pork-noodles-in-hanoi-with-italian-customers-791427.vov`
  - Time: `https://time.com/4345465/barack-obama-anthony-bourdain-vietnam-food-meal/`

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

Physical iPhone build was attempted from this feature worktree after the regenerated resources changed.

- Build: succeeded
- Install: succeeded
- Launch: blocked because the phone was locked; iOS refused to open the app until the device is unlocked
- Signing hygiene: repo signing files stayed clean
- Explicit signing-file status: no modified `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- Signing scan note: only the generic existing `CODE_SIGN_IDENTITY = "iPhone Developer"` entries were present in the project file; personal team/provisioning values were not written into repo files

## Copy Judgment

This batch makes the unfamiliar familiar before asking the reader to care:

- Huỳnh Hoa now explains bánh mì and the actual counter/takeaway experience.
- Phở Lệ and Phở Hòa Pasteur now explain phở, southern table add-ins, and why the two Saigon bowls have different trip roles.
- Hương Liên now explains both the dish and the Obama/Bourdain fame in a way that helps U.S. readers orient.
- Bún Chả Ta now explains the same dish through the Old Quarter table experience rather than vague room language.

Validators were used only after the prose existed. They caught residue such as `better when`, casing issues, and banned phrasing during the final pass; they did not author the pages.

## Remaining Work

25 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages
- Batch 003: 5 pages
- Batch 004: 5 pages
- Batch 005: 5 pages

Remaining authored recovery scope: 495 listings.

Continue with small batches chosen from high-visibility food pages, screenshot-flagged pages, unfamiliar food/place/format terms, and pages that pass validators while still failing the first-time traveler read.
