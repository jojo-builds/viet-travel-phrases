# SpeakLocal Launch-Readiness Orchestrator Receipt

Updated: 2026-07-04 19:50 PHT

## Scope

- Branch: `main`
- App surface: `native-ios`
- Paywall: inspected separately by worker, still excluded from `main`
- Device target: simulator proof completed; physical iPhone build/install/launch completed in this run

## Fixes Applied

- Added a runtime fallback for missing city/place hero assets so missing `HeroCity*Place*` images use the shared fallback instead of rendering blank.
- Strengthened the top chrome separation gradient over photo backdrops.
- Regenerated Viet authored listing/SQLite outputs after compact city support-page hero changes.
- Fixed Browse fallback routes for `airport-border-arrival` and `hotel-accommodation` so they use Airport/Hotel hero art, subcategory cards, friendly titles, subtitles, starter labels, and message section labels.
- Fixed Home shelf duplicate visible English subtitles.
- Repaired Home scroll jank without removing the existing panel/card design: moved the scroll-driven photo-backdrop/chrome offset out of the full Home content view into a focused `HomePhotoBackdropChromeLayer`, and throttled restoration/display scroll publishing so scrolling no longer invalidates the designed Home panels as aggressively.
- Fixed city location menu/related card lookup so SQLite canonical IDs do not hide family-keyed curated city cards.
- Updated stale city/menu/relationship-word test expectations to current generated source truth.
- Reconciled `drink-ca-phe-sua-da` source/CSV copy with the shipped runtime menu copy.
- Repaired Practice scenario choices so visible message choices use exact bundled audio or are replaced/removed.
- Updated Practice message breakdown tests to the current reviewed semantic chunks.

## Validation

- `git diff --check`: pass
- `node scripts/guard-native-only.js`: pass
- `node native-ios/scripts/guard-native-chrome.js`: pass
- `node native-ios/scripts/generate-vietnamese-menu-copy.js --check`: pass, 355 items
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`: pass, 355 pages, 15 ready helper phrases
- `node native-ios/scripts/generate-viet-sqlite-fixture.test.js`: pass
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`: pass, 1793 canonical pages, 11728 relations, 778 planned missing audio rows, 0 release-blocking missing audio rows
- `node native-ios/scripts/validate-viet-hero-image-assets.js`: pass, 520 city-library places, 524 active premium hero assets; unique city-place hero gate intentionally skipped
- `node native-ios/scripts/audit-viet-listing-production-qa.js --check`: pass, 1793 pages, 0 blockers, 0 majors
- `node native-ios/scripts/validate-tier-one-listing-pages.js`: pass, 150/150 strong
- `node native-ios/scripts/validate-viet-listing-intent-routing.js`: pass
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js`: pass, 520/520
- `XcodeBuildMCP test_sim -only-testing:SpeakLocalNativeTests`: pass, 410 passed, 0 failed, 26 skipped
- `xcodebuild test -only-testing:SpeakLocalNativeTests/AppChromeTests/testHomePhotoBackdropPublishesScrollStateAtCoarserPerformanceStride`: pass
- `xcodebuild test -only-testing:SpeakLocalNativeUITests/AdminChromeUITests/testHomeLiquidGlassRedesignProofScreenshots`: pass after Home scroll coordinator change
- `xcodebuild test -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests`: pass after the restored-design Home scroll coordinator change; 60 tests, 0 failures; result bundle `docs/task-results/launch-readiness-audit-2026-07-04/runtime/browse-search-full-post-home-fix.xcresult`
- Physical iPhone build: pass
- Physical iPhone install: pass
- Physical iPhone launch: pass
- Signing hygiene: pass; `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` stayed unchanged by local signing

## Visual Proof

Screenshots saved under `docs/task-results/launch-readiness-audit-2026-07-04/final-visual-proof/`:

- `home.jpg`
- `food-category.jpg`
- `airport-fallback-category-fixed-title.jpg`
- `hotel-fallback-category-fixed-title.jpg`

Home scroll/performance visual proof saved under `docs/task-results/launch-readiness-audit-2026-07-04/home-performance-visual-proof/current/`:

- `home-after-coordinator-launch-top.png`
- `after-coordinator-home-liquid-top.png`
- `after-coordinator-home-liquid-city.png`
- `after-coordinator-home-liquid-bottom.png`

## Remaining Notes

- Unique per-place city hero images are still not complete. Runtime fallback prevents blank images, and the current validation intentionally skips the strict unique city-place hero gate.
- Missing audio audit rows remain planned/non-blocking: 778 planned, 0 release-blocking.
- Paywall remains isolated from `main`; ship/no-ship decision should happen after this non-paywall build is stable on the phone.
- Jojo should still feel-test Home on the physical phone after this 19:20 build, especially slow and fast vertical scrolling from Essentials through Explore by city and Eating Out. The simulator visual proof and full Browse/Search suite show the original panel/card styling restored and related surfaces stable; the remaining proof needed is human device feel for any hitching.
