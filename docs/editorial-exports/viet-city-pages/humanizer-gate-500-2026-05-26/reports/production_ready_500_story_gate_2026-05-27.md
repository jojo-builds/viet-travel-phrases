# 500 City Listings Story Gate

Date: 2026-05-27

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-pages`

Status: PASS for v2.2 copy, runtime projection, native rendered chrome, and physical-device install.

## Scope

- 500 Viet city-library place listings across Da Nang, Hanoi, Ho Chi Minh City, Hoi An, and Hue.
- Source files:
  - `content-draft/viet/city-library/handwritten-copy/danang.json`
  - `content-draft/viet/city-library/handwritten-copy/hanoi.json`
  - `content-draft/viet/city-library/handwritten-copy/hcmc.json`
  - `content-draft/viet/city-library/handwritten-copy/hoian.json`
  - `content-draft/viet/city-library/handwritten-copy/hue.json`
- Runtime projections regenerated into the city library, native authored listing pages, SQLite fixture, and practice deck.

## What Changed

- The v2.2 standard now requires a story spine: one truthful local, cultural, city, route, food, neighborhood, or place-memory reason the page belongs where it does.
- The story spine is an internal authoring compass, not a visible required `Story` section.
- The 500 imported listings were repaired around story-led first screens and short practical sections.
- Native top chrome now keeps the status/back area readable when page content scrolls underneath it.
- The local ChatGPT Project source pack and linked Google Docs for Project Instructions, Source Bundle, and New Chat Prompt were refreshed with the story-spine rule and the superseding 2026-05-27 status.

## Copy Gate

- `node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/validate-humanizer-chunks.js --strict`
  - `Humanizer chunk validation passed. entries=500 warnings=0`
- `node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/audit-production-voice.js`
  - `Production voice audit: entries=500 hard=0 soft=0`
- `node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/audit-production-story.js`
  - `Production story audit: entries=500 review=0`
- Reader review export:
  - `docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/reader-review/speaklocal-city-pages-500-reader-review.html`

## Runtime Gate

- `node native-ios/scripts/validate-viet-city-copy.js`
  - `Validated city production copy: 5 hubs, 500 city noun pages, 500 unique target heroes`
- `node native-ios/scripts/validate-viet-city-library.js`
  - `City library OK: 806 pages, 706 beginner, 95 intermediate, 5 advanced`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `ok: true`
  - `cityPlaces: 500`
  - `cityPhraseTags: 806`
  - `releaseBlockingMissingAudioAuditRows: 0`
  - `cityReadyAudioPhraseRows: 150`
  - `cityPlannedAudioPhraseRows: 656`
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - `Practice deck check OK: 2791 items, 14 scenarios, 7 question types`
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - `Viet hero image asset validation passed`
  - Note: the unique city-place hero asset gate was not run; unique hero expansion remains production-image backlog, not this copy gate.
- `node scripts/guard-native-only.js`
  - `Native-only guard passed: no active Expo/React Native app surface found.`

## Native Render Gate

- Simulator: `SpeakLocal Browse`, iPhone 17 Pro, iOS 26.4.1.
- `xcodebuild ... -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testCaptureV22CityPageProductionProof ... test-without-building`
  - `Executed 1 test, with 0 failures`
  - `TEST EXECUTE SUCCEEDED`
- Screenshot proof folder:
  - `docs/design/city-pages/screenshots/v2-2-500-story-production-2026-05-27`
  - 20 screenshots exported, covering 10 sampled v2.2 story pages in top and scrolled states.
- Spot-checked screenshots:
  - `01-danang-international-terminal-scrolled.png`
  - `08-hcmc-ben-thanh-market-scrolled.png`
  - `10-hoian-ancient-town-ticket-booth-scrolled.png`
- Result: top status/back chrome is readable, phrase cards render, story-led sections render, Mentioned Here/related modules render where expected, and bottom chrome does not block the sampled content.

## Physical iPhone Gate

- Built from this worktree with local-only signing overrides.
- Build: PASS.
- Install: PASS.
- Launch: PASS.
- Post-build signing scan: PASS.
- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: no output.

## Remaining Non-Blocking Backlog

- Planned audio rows remain planned, with `releaseBlockingMissingAudioAuditRows: 0`.
- Unique per-city-place hero asset expansion was not part of this copy gate.
- Future net-new listings must still pass the v2.2 story-spine rule, rendered screenshot review, and production review gate before being called production-ready.

## Decision

PASS. The 500 city-library listings are production-ready for v2.2 copy, runtime projection, and native rendered app review as of 2026-05-27.
