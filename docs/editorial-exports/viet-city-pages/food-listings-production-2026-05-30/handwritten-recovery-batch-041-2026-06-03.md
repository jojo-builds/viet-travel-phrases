# Handwritten Recovery Batch 041 - 2026-06-03

## Scope

- `viet-family-city-hue-place-banh-khoai` - Bánh khoái ở Huế / Banh khoai
- `viet-family-city-hue-place-banh-nam` - Bánh nậm ở Huế / Banh nam
- `viet-family-city-hue-place-bao-quoc-pagoda` - Chùa Báo Quốc / Bao Quoc Pagoda
- `viet-family-city-hue-place-bao-vinh-ancient-town` - Phố cổ Bao Vinh / Bao Vinh Ancient Town
- `viet-family-city-hue-place-ben-ngu-market` - Chợ Bến Ngự / Ben Ngu Market

## Editorial Recovery

- Rewrote bánh khoái as a concrete Hue dish page: crisp yellow pancake, shrimp/pork, herbs, green banana, fig or starfruit, and peanut-based sauce.
- Added practical allergy/dietary context for bánh khoái: peanuts, pork, shellfish, and possible pork liver in sauce.
- Rewrote bánh nậm as a soft rice-flour banana-leaf parcel and kept shellfish/pork context visible.
- Reframed Bao Quoc Pagoda around active Buddhist use, monastery/courtyard context, and respectful visitor behavior.
- Reframed Bao Vinh around its old riverside trade-street reason, not generic "ancient town" atmosphere.
- Rewrote Ben Ngu Market around its smaller everyday local-market role, with safer source-backed market goods language.
- Removed app-ish phrasing caught by QA: `market lap`, `river-neighborhood pace`, `respectful body language`, `fits naturally`, `just another`, and `the appeal is`.

## Subagent QA

- Factual/source-risk QA: `019e8b42-e8e1-7450-983d-814c13498087`
- Human-readability QA: `019e8b42-f933-7892-9711-4f81f6d751f3`
- Both reviews were folded into the source before projection and validation.

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

- V2.2 strict production validation: pass, 520 entries, 520 `FINAL_PASS`
- Voice audit: pass, no failures
- City production copy: pass, 520 city noun pages
- City library: pass, 826 pages
- SQLite fixture: pass, `integrity_check: ok`
- Listing production QA: 0 blockers, 0 majors

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Simulator: `SpeakLocal City Listings`
- Rendered page left open: `viet-family-city-hue-place-ben-ngu-market`
- Screenshot: `render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-041-screenshots/001-hue-ben-ngu-market-top.jpg`

## Phone Build

- Worktree build source: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
- Build: succeeded
- Install: succeeded
- Launch: blocked because the phone was locked
- Repo-visible signing scan: pass

## Progress

- Recovered so far: 204 / 520
- Remaining: 316
