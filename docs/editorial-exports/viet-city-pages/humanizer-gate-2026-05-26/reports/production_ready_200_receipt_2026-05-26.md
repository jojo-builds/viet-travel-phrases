# Production-Candidate Import Receipt: 200 City Listings

Date: 2026-05-26

Scope:

- Da Nang city-library listings `001-100`
- Hanoi city-library listings `001-100`
- Source chunks: `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/*.json`
- Promoted source files:
  - `content-draft/viet/city-library/handwritten-copy/danang.json`
  - `content-draft/viet/city-library/handwritten-copy/hanoi.json`

## Decision

Status: superseded and narrowed after rendered phone review on 2026-05-26.

This pass proves only production-candidate import integrity for the current city-library/native runtime copy contract. It does not prove production-ready copy voice, rendered-phone readability, or top/bottom chrome behavior.

The later 500-listing humanizer gate included these 200 listings and was revoked after phone review exposed unacceptable copy voice and a top-chrome overlap on `city-danang-place-da-nang-museum`. Do not cite this receipt as production-ready approval.

## Humanizer Gate Changes

- `Useful Phrases` is now reserved for audio-backed phrase-card sections only.
- `quick-say` sections without `phraseIDs` must use another natural title and prose body.
- The gate now blocks process/catalog wording such as `entry`, `city library`, `condition-aware`, `claims`, `the page`, `useful moment`, and `visible copy`.
- The gate now blocks top/best-style drift such as `best for`, `best as`, `best when`, `best treated`, `best approached`, and `reads best`.
- Native city-copy validators were updated to recognize legitimate practical/travel hooks such as `station`, `airport`, `ticket`, `route`, `luggage`, `bowl`, `broth`, `meal`, `show`, `theatre`, `lake`, `park`, `pagoda`, `temple`, `plaza`, `street`, `district`, `puppet`, and `gallery`.
- The city-library validator now recognizes `meal`, `bite`, `bread`, `sandwich`, `banh mi`, and `bánh mì` as valid food identities for dish pages.

## Review Gates

- Eight humanizer chunks pass: `entries=200`, `errors=0`, `warnings=0`, `missingChunks=0`.
- Final post-repair reports:
  - `final_gate_post_repair_danang_001_050.md`: 50 safe, 0 unsafe.
  - `final_gate_post_repair_danang_051_100.md`: initially 43 safe, 7 unsafe; the 7 unsafe plus adjacent last-touch items were repaired and rechecked in `focused_final_patch_recheck_2026-05-26.md`.
  - `final_gate_post_repair_hanoi_001_050.md`: 50 safe, 0 unsafe.
  - `final_gate_post_repair_hanoi_051_100.md`: 50 safe, 0 unsafe.
  - `focused_final_patch_recheck_2026-05-26.md`: 11 safe, 0 unsafe.

## Promotion

Commands run:

```sh
node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/import-humanized-chunks.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
```

Generated/promoted outputs include:

- `content-draft/viet/city-library/v1.json`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`

## Validation

All required commands passed:

```sh
node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js
node scripts/guard-native-only.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-hero-image-assets.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
```

Key results:

- `Humanizer chunk validation passed. entries=200 warnings=0`
- `Native-only guard passed`
- `Validated city production copy: 5 hubs, 500 city noun pages, 500 unique target heroes`
- `City library OK: 806 pages, 706 beginner, 95 intermediate, 5 advanced`
- `Viet hero image asset validation passed`
- SQLite validation `ok: true`

## Process Notes For Next Batch

- Do not create new one-off phrase cards to satisfy a listing.
- Reuse `Useful Phrases` only when the section has at least two reusable, ready-audio phrase IDs.
- If no reusable phrase IDs fit, keep `quick-say` as prose with a natural title specific to the moment.
- Treat subagent final-gate findings as hard blockers when they flag visible process language, even if mechanical validation passes.
- After any repair, rerun both the humanizer gate and the native validators before promotion.
- Before any production-ready claim, review representative rendered phone/simulator pages for voice, section readability, and chrome overlap.
