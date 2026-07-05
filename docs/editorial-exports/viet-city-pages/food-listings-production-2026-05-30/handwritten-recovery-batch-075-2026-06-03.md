# Handwritten Recovery Batch 075 - 2026-06-03

## Scope

- `city-hcmc-place-opera-a-o-show`
- `city-hcmc-place-opera-house`
- `city-hcmc-place-pasteur-street`
- `city-hcmc-place-pha-lau`
- `city-hcmc-place-pham-ngu-lao-street`
- `city-hcmc-place-pho-hoa-pasteur`
- `city-hcmc-place-pho-nam`
- `city-hcmc-place-post-office`

Also folded in Batch 074 heartbeat steering for `city-hcmc-place-nephele`, `city-hcmc-place-nguyen-trai-street`, `city-hcmc-place-notre-dame`, and `city-hcmc-place-oc`.

## Editorial Notes

- Replaced command/verdict headings such as `Remember It`, `Exterior Is The Visit`, `What You Are Ordering`, `Taste Before Adding`, and `Turn It Into A Stop`.
- Preserved first-time traveler definitions for À Ố Show, phá lấu, phở, southern phở, Pasteur Street, and the Central Post Office.
- Kept phrase cards and related cards intact while making the prose more human-facing and less validator/planner-like.
- Folded current steering into the gate: avoid command/verdict headings even when validators pass, keep safety/planning details human, and do not thin useful sections to solve voice issues.

## Validation

Ran:

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

Result: PASS.

- V2.2 app-detail validation: 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no formula failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero hidden at render-time, 500 missing-audio priority rows.

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Rendered page: `viet-family-city-hcmc-place-post-office`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-075-screenshots/001-hcmc-post-office-top.jpg`

## Progress

- Completed through batch 075: 403 / 520
- Remaining: 117
