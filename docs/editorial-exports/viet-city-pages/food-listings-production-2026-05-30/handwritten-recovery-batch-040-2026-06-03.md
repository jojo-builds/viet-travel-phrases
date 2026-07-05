# Handwritten Recovery Batch 040 - 2026-06-03

## Scope

- `viet-family-city-hue-place-ancient-space-restaurant` - Không gian xưa / Ancient Space Restaurant
- `viet-family-city-hue-place-ba-van-banh-loc` - Bánh lọc Bà Vân / Ba Van Banh Loc
- `viet-family-city-hue-place-bach-ma-national-park` - Vườn quốc gia Bạch Mã / Bach Ma National Park
- `viet-family-city-hue-place-banh-beo` - Bánh bèo ở Huế / Banh beo
- `viet-family-city-hue-place-banh-bot-loc` - Bánh bột lọc ở Huế / Banh bot loc

## Editorial Recovery

- Added clearer dish identity for bánh bột lọc and bánh bèo, including texture, sauce, and ingredient cues that first-time U.S. travelers should not have to infer.
- Added shrimp/pork and shellfish/pork cautions for Ba Van Banh Loc and bánh bột lọc.
- Reframed Ancient Space Restaurant around the real setting: a nhà rường timber house, garden paths, clay-pot rice, local dishes, and a slower shared-table dinner.
- Added a current-access caution for Bach Ma National Park transport so the page does not imply one fixed access pattern.
- Removed remaining formula language from the batch, including excess `stop` usage, and kept the wording positive and plain.

## Subagent QA

- Factual/source-risk QA: `019e8b29-0eee-73b0-a851-f890e02e48fd`
- Human-readability QA: `019e8b29-3d7d-7d53-b7de-3727ffaa0093`
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
- Rendered page left open: `viet-family-city-hue-place-banh-bot-loc`
- Screenshot: `render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-040-screenshots/001-hue-banh-bot-loc-top.jpg`

## Phone Build

- Worktree build source: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
- Build: succeeded
- Install: succeeded
- Launch: blocked because the phone was locked
- Repo-visible signing scan: pass

## Progress

- Recovered so far: 199 / 520
- Remaining: 321
