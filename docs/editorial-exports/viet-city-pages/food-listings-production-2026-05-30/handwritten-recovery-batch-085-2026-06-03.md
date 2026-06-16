# Handwritten Recovery Batch 085

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Hoi An authored-source recovery continued for 8 listing pages:

- `city-hoian-place-hoai-river`
- `city-hoian-place-japanese-bridge`
- `city-hoian-place-kim-bong-carpentry-village`
- `city-hoian-place-lantern-boat`
- `city-hoian-place-lantern-making-class`
- `city-hoian-place-lune-center`
- `city-hoian-place-madam-khanh`
- `city-hoian-place-mai-fish`

Progress after this batch: 481 / 520 recovered, 39 remaining.

## Editorial Notes

- Applied the new positive-proof and cold visible-copy workflow before validation.
- Rewrote module-job headings such as route/pairing/planned-night language into visible traveler anchors: boats, bridges, roof, water, tools, hands, tickets, seats, and table details.
- Preserved useful phrase cards, Mentioned Here cards, and related cards.
- Strengthened Madam Khanh as a city-specific food page: Hội An bánh mì now reads as named-shop, crisp-roll, filling, herb, sauce, line, and shop-comparison context rather than a generic sandwich definition.
- Preserved restaurant table utility for Mai Fish without turning the sections into checklist instructions.
- Cold visible-copy gate result: PASS before validators. No lines classified as `module-job/rationale` or `thin-safe` remained in intro heading/body, section headings, first section sentences, Mentioned Here subtitles, or Related subtitles.
- Carry-forward/backward-pass note: Batch 059 phở/Phạm Ngũ Lão pages need the same cold gate and source-rationale cleanup, especially city-specific phở table decisions and visible/source related-card reasons.

## Validation

Passed:

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

Validation results:

- V2.2 projection: 520 entries, 5 cities.
- Strict v2.2 validation: PASS, 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no formula failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero section hidden at render-time, 500 missing-audio priority rows.

## Render Proof

Rendered page left open on Simulator:

- `viet-family-city-hoian-place-mai-fish`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-085-screenshots/001-hoian-mai-fish-top.jpg`
