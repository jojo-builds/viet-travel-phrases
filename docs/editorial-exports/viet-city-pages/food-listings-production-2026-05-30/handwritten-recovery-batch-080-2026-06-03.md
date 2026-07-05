# Handwritten Recovery Batch 080

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Hoi An authored-source recovery continued for 8 listing pages:

- `city-hoian-place-banh-dap-hen-xao`
- `city-hoian-place-banh-mi`
- `city-hoian-place-banh-mi-phuong`
- `city-hoian-place-banh-xeo`
- `city-hoian-place-bay-mau-coconut-forest`
- `city-hoian-place-bebe-tailor`
- `city-hoian-place-bus-station`
- `city-hoian-place-cam-chau`

Progress after this batch: 441 / 520 recovered, 79 remaining.

## Editorial Notes

- Folded in the Hoi An steering from Batch 079 review: avoid polished planning shorthand such as `old core`, `practical side`, `clearer route`, and `simple boarding moment`.
- Preserved useful phrase cards and related cards.
- Rewrote food pages with clearer dish definitions for first-time U.S.-based visitors: smashed rice paper with clams, Hội An bánh mì choices, Bánh Mì Phượng counter rhythm, and savory bánh xèo table rhythm.
- Rewrote place/logistics pages around physical traveler moments: coconut channels and basket boats, tailor fabric-to-fitting flow, bus-station bags/routes/local signs, and Cam Chau as a lived-in garden-lane neighborhood.
- Removed visible/source seams caught during review and validation: `Related because:`, `old core`, `it fits`, `anchor`, direct audience naming, `best version`, `not the whole`, and `not only`.

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
- Signing scan: PASS.

## Render Proof

Rendered page left open on Simulator:

- `viet-family-city-hoian-place-cam-chau`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-080-screenshots/001-hoian-cam-chau-top.jpg`
