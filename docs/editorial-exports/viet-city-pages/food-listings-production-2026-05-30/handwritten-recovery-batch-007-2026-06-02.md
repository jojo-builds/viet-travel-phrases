# Handwritten Recovery Batch 007 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 007 is complete as a five-page authored recovery batch. It is not a global production-ready claim for all 520 listings.

This batch focused on HCMC food pages where the original copy assumed readers already understood dish names, noodle-shop formats, or why one phở listing deserved attention beside another. The work made first mentions plain-English, more concrete, and more valuable for first-time U.S.-based visitors.

Length was treated as value-first: longer copy is acceptable when it explains an unfamiliar dish, reduces ordering uncertainty, or gives a real reason to remember the place. Thin copy is the problem, not length by itself.

## Pages Recovered

1. `city-hcmc-place-com-tam-ba-ghien`
   - Before: named broken rice and the pork chop, but still read like a compact internal note around "one focused plate."
   - After: defines cơm tấm as the broken-rice pork-chop plate many visitors meet in Saigon, then explains the full plate: grilled pork chop, rice, egg, pickles, fish sauce, quick lunch-shop pace, and direct ordering.

2. `city-hcmc-place-hu-tieu`
   - Before: called hủ tiếu a flexible noodle bowl, but still did not fully teach the soup-or-dry decision or why the dish matters beside phở.
   - After: defines hủ tiếu as a lighter Saigon noodle bowl that can come as clear-broth soup or dry noodles with sauce, usually with pork, shrimp, herbs, and lime.

3. `city-hcmc-place-bun-bo-hue-14b`
   - Before: used "Hue-style bowl" too early and assumed the reader understood bún bò Huế.
   - After: defines bún bò Huế as spicy beef noodle soup from Huế, then makes 14B specific through lemongrass broth, round noodles, beef, tendon, herbs, chili, lime, and a Saigon setting for a central-Vietnam bowl.

4. `city-hcmc-place-pho-minh`
   - Before: had good alley and 1945 source facts, but did not define phở clearly enough or explain pâté chaud for a U.S. reader.
   - After: frames Phở Minh as an early beef-phở morning down a Pasteur Street alley, explains beef cuts, and defines pâté chaud as a flaky savory pastry side.

5. `city-hcmc-place-pho-huong-binh`
   - Before: said the shop was "not only beef" and duplicated "long-running," while leaving phở gà and phở bò under-explained.
   - After: defines phở gà as chicken phở and phở bò as beef phở, then gives the shop a clearer family-room lane built around chicken, beef, clear broth, herbs, and add-ons.

## Source Files Edited

- `content-draft/viet/city-library/handwritten-copy/hcmc.json`
- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
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

The full-chain validator initially caught one banned tone word, `stronger`, on Bún Bò Huế 14B. It was fixed in authored copy as `deeper, spicier` before the final passing run.

## Simulator Proof

Simulator build/run was completed from this feature worktree with XcodeBuildMCP.

- Simulator: `SpeakLocal City Listings`
- Project: `native-ios/SpeakLocalNative.xcodeproj`
- Scheme: `SpeakLocalNative`
- Build/run: succeeded
- Left open for Jojo: `viet-family-city-hcmc-place-hu-tieu`
- Visible confirmation: the page showed `Hủ tiếu ở Thành phố Hồ Chí Minh` and the new intro explaining hủ tiếu as a flexible Saigon noodle bowl that can be soup or dry noodles.

## Phone Build

Physical iPhone build was attempted from this feature worktree after regenerated resources changed.

- Build: succeeded
- Install: succeeded
- Launch: blocked because the phone was locked; iOS refused to open the app until the device is unlocked
- Signing hygiene: repo signing files stayed clean
- Explicit signing-file status: no modified `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- Explicit signing scan: no personal team, provisioning, certificate, or phone-specific signing values were found in those repo files

## Copy Judgment

This batch uses the updated human-readable recovery standard:

- Define unfamiliar dish names on first contact.
- Explain table or ordering behavior in ordinary English.
- Give the place or dish a distinct reason to exist beside similar listings.
- Allow extra words when they add travel value.
- Avoid app-internal language, fragile current operational claims, unexplained awards, and "save this" command wording.

## Remaining Work

35 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages
- Batch 003: 5 pages
- Batch 004: 5 pages
- Batch 005: 5 pages
- Batch 006: 5 pages
- Batch 007: 5 pages

Remaining authored recovery scope: 485 listings.

Continue with small batches chosen from high-visibility food pages, screenshot-flagged pages, unfamiliar food/place/format terms, and pages that pass validators while still failing the first-time traveler read.
