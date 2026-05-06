# TASK-VIET-HERO-IMAGE-PRODUCTION-001

## Summary

Built and wired an app-owned hero image pass for SpeakLocal Vietnam pages that were missing specific mastheads or were falling back to generic Vietnam imagery.

This pass intentionally uses deterministic app-owned generated illustrations, not unlicensed web photos. Real restaurant/place photography should be a separate licensed-source workflow with source receipts.

## What Changed

- Added `native-ios/scripts/generate-viet-hero-image-assets.py` to generate owned `853 x 1844` hero PNG assets and asset catalog imagesets.
- Generated `156` hero assets covering city hubs, category/country hubs, compact phrase masthead fallback, and approved city-library place pages that lacked shipped hero art.
- Updated `content-draft/viet/city-library/v1.json` so approved place pages now carry explicit `heroImageName` values.
- Regenerated authored listing JSON and the bundled Viet SQLite resources from source.
- Updated Browse city/category/country hub masthead routing:
  - Saigon: `HeroCityHcmc`
  - Da Nang/Hanoi/Hoi An/Hue: city-specific mastheads
  - Greetings: `HeroCategoryGreetings`
  - Emergency: `HeroCategoryEmergency`
  - All Vietnam: `HeroCountryVietnam`
- Fixed generated hero crop behavior in `HeroMastheadImage` so generated city/category/country mastheads do not inherit the old generic Vietnam vertical offset.
- Updated the hero image tracker mirror so current source/runtime hero names take precedence over stale follow-up rows.
- Added `native-ios/scripts/validate-viet-hero-image-assets.js` for durable validation.
- Added unit/UI tests for owned hub mastheads and simulator proof capture.
- Updated the persistent `speaklocal-listing-pages` skill with the new hero workflow guardrails.

## Coverage Proof

- Generated hero report: `docs/editorial-exports/viet-image-assets/hero-image-production-001/generated_hero_assets.json`
- Generated hero CSV: `docs/editorial-exports/viet-image-assets/hero-image-production-001/generated_hero_assets.csv`
- Tracker rows: `154`
- Tracker shipped rows: `154`
- Image queue rows remaining: `0`
- Approved city-library place pages with hero images: `149`
- Browse/category/country hero mappings with assets: `13`

## Screenshot Proof

Simulator proofs are committed under `docs/task-results/assets/TASK-VIET-HERO-IMAGE-PRODUCTION-001/`:

- `saigon-city-top.png`
- `greetings-category-top.png`
- `ben-thanh-market-top.png`
- `anan-saigon-top.png`

The proof set specifically checks:

- Saigon is no longer blank and has a Saigon/city masthead.
- Greetings no longer uses the generic mountain/boat masthead.
- Ben Thanh Market shows a market-specific masthead in the rendered crop.
- Anăn Sài Gòn shows a food/restaurant masthead in the rendered crop.

## Validation

Passed:

- `python3 -m py_compile native-ios/scripts/generate-viet-hero-image-assets.py`
- `node --check native-ios/scripts/export-viet-hero-image-production-tracker.js`
- `node --check native-ios/scripts/validate-viet-hero-image-assets.js`
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `xcodebuild test ... AppChromeTests/testBrowseCollectionMastheadsUseOwnedHeroArtForVisibleHubs`
- `xcodebuild test ... AppChromeTests/testDaNangCityDescriptorUsesTravelModeHubInsteadOfPhraseFeed`
- `xcodebuild test ... AppChromeTests/testAllVietnamDescriptorUsesCountryHubInsteadOfPhraseFeed`
- `xcodebuild test ... BrowseSearchUITests/testCaptureRepresentativeHeroImagesForProductionReview`

Final `git diff --check` and `git status --short` were run before commit.

## Notes

- No web-sourced restaurant photos were imported because that would need explicit licensing/source receipts.
- No audio resources, signing files, provisioning files, or Xcode project settings were intentionally changed.
- The generated art is a production-safe baseline so pages stop shipping blank/generic mastheads while a richer licensed-photo workflow can be built later.
