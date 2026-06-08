# Handwritten Recovery Batch 008 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 008 is complete as a five-page authored recovery batch. It is not a global production-ready claim for all 520 listings.

This batch focused on HCMC street-food dish pages where first-time U.S.-based visitors need plain definitions before the copy asks them to care. The work moved the pages away from vague "food memory" language and toward direct dish explanations, table behavior, ingredient checks, and ordering confidence.

## Pages Recovered

1. `city-hcmc-place-bot-chien`
   - Before: described a visual griddle moment but still did not define bột chiên cleanly enough up front.
   - After: defines bột chiên as fried rice-flour cakes cooked on a flat griddle with egg, green onions, and sauce, then explains the crisp-edge / soft-center snack role.

2. `city-hcmc-place-oc`
   - Before: said "snails and seafood" but repeated sauce language and did not clearly explain that ốc can mean a broader shellfish table.
   - After: explains that ốc literally means snails but in Saigon can include clams, scallops, shellfish, herbs, sauces, and small shared plates. It adds better allergy caution and small-first-round guidance.

3. `city-hcmc-place-goi-cuon`
   - Before: called fresh spring rolls a light food memory, but the first paragraph could still feel generic.
   - After: defines gỏi cuốn as fresh spring rolls: soft rice paper wrapped around herbs, rice noodles, shrimp or pork, then dipped in peanut sauce or fish sauce.

4. `city-hcmc-place-bo-la-lot`
   - Before: described a grilled leaf bite but used generic "food moment" wording and a loose betel-leaf explanation.
   - After: defines bò lá lốt as grilled beef wrapped in fragrant lá lốt leaves, then explains the hands-on roll with herbs, rice paper, and dipping sauce.

5. `city-hcmc-place-pha-lau`
   - Before: gave the offal-stew idea but carried an irrelevant shellfish-allergy phrase card and only three body sections.
   - After: defines phá lấu as rich Saigon offal stew with bread for dipping, replaces the shellfish phrase with `Không cay nhé`, and adds a group-sharing caution for people who avoid offal.

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

The pre-validation smell scan caught `because it`, `part of the point`, and one overlong handwritten summary. Those were fixed in authored copy before the final passing run.

## Simulator Proof

Simulator build/run was completed from this feature worktree with XcodeBuildMCP.

- Simulator: `SpeakLocal City Listings`
- Project: `native-ios/SpeakLocalNative.xcodeproj`
- Scheme: `SpeakLocalNative`
- Build/run: succeeded
- Left open for Jojo: `viet-family-city-hcmc-place-oc`
- Visible confirmation: the page showed `Ốc Sài Gòn ở Thành phố Hồ Chí Minh` and the new intro explaining that ốc means snails but a Saigon ốc table can include clams, scallops, shellfish, herbs, sauces, and small plates.

## Phone Build

Physical iPhone build was attempted from this feature worktree after regenerated resources changed.

- Build: succeeded
- Install: succeeded
- Launch: blocked because the phone was locked; iOS refused to open the app until the device is unlocked
- Signing hygiene: repo signing files stayed clean
- Explicit signing-file status: no modified `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- Explicit signing scan: no personal team, provisioning, certificate, or phone-specific signing values were found in those repo files

## Copy Judgment

This batch continued the recovery standard Jojo clarified:

- Longer copy is acceptable when it explains unfamiliar terms or reduces real travel uncertainty.
- First mention should define unfamiliar food names before using them as a reason to go.
- Dish pages should teach what the traveler will actually see, order, share, dip, avoid, or ask about.
- Phrase cards should match the actual food risk or ordering moment.
- Validators are evidence, not taste approval; the copy still needs a human read.

## Remaining Work

40 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages
- Batch 003: 5 pages
- Batch 004: 5 pages
- Batch 005: 5 pages
- Batch 006: 5 pages
- Batch 007: 5 pages
- Batch 008: 5 pages

Remaining authored recovery scope: 480 listings.

Continue with small batches chosen from high-visibility food pages, screenshot-flagged pages, unfamiliar food/place/format terms, and pages that pass validators while still failing the first-time traveler read.
