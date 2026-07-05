# Handwritten Recovery Batch 002 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 002 is complete as a five-page authored recovery batch. It is not a global production-ready claim for all 520 listings.

The batch was selected from high formula-risk pages, then rewritten page by page in the authored source. Copy was mirrored into the V2.2 app-detail source, regenerated into native resources, and passed the existing safety validators.

## Pages Recovered

1. `city-hanoi-place-nang-cafe`
   - Before: repeated "simple / short / room" language without enough reason to remember Năng.
   - After: frames Năng as an older Hanoi coffee sit: phin coffee, condensed milk, ice, small tables, street noise, and a useful contrast after sweeter egg-coffee stops.

2. `city-hanoi-place-hom-market`
   - Before: useful but generic market behavior and repeated practical-market wording.
   - After: makes Chợ Hôm specific as a fabric-and-household market: bolts of cloth, tight aisles, price questions, small buys, and stepping aside so everyday buying can keep moving.

3. `city-hoian-place-che-bap-cam-nam`
   - Before: repeated small/sweet/simple language without making Cẩm Nam carry the memory.
   - After: makes the dish place-linked: corn sweet soup, coconut milk, one bowl, less-sugar phrase, bridge-walk context, and the river-island side of Hội An.

4. `city-hue-place-le-ba-dang-art-center`
   - Before: described a calm indoor art stop but did not quickly explain why Lê Bá Đảng mattered.
   - After: gives the page a plain frame: one Vietnamese-born modern artist, a focused art center, gallery rooms, photo etiquette, and a modern-art counterpoint to Hue's tombs and citadel history.

5. `city-hue-place-phu-hau-market`
   - Before: leaned on local rhythm / modest market language without enough concrete behavior.
   - After: frames Phú Hậu as a neighborhood-market browse: produce, small snacks, vendor umbrellas, small cash, one price question, and a nearby-use case without overselling it.

## Source Files Edited

- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `content-draft/viet/city-library/handwritten-copy/hue.json`
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`
- `content-draft/viet/city-library/app-detail-v2-2/hue.json`
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

## Copy Judgment

This batch improved the positive traveler value of the selected pages. Each page now gives a clearer reason to remember the listing:

- Năng: old-Hanoi coffee habit and contrast with egg coffee.
- Chợ Hôm: fabric-counter shopping, not generic market browsing.
- Chè bắp Cẩm Nam: a place-linked Hội An sweet soup.
- Lê Bá Đảng: a named artist and modern-art frame in Hue.
- Phú Hậu: ordinary neighborhood-market behavior without overselling.

Validators were used only after the prose existed. They caught and helped remove formula language such as `stronger`, `why it belongs`, `best`, and `not a`; they did not author the pages.

## Remaining Work

10 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages

Remaining authored recovery scope: 510 listings.

Continue with small batches chosen from high formula-risk pages and user-flagged screenshots. Do not mark all listings production-ready until every listing has page-level authored review, regenerated resources, validation, and rendered reading proof.
