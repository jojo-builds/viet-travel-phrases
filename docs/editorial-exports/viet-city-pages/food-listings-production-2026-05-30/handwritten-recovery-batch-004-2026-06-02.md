# Handwritten Recovery Batch 004 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 004 is complete as a five-page authored recovery batch. It is not a global production-ready claim for all 520 listings.

This batch focused on screenshot-class failures: unexplained restaurant formats, unexplained food terms, visible save-command language, and seafood copy that validated while still feeling too vague for a first-time U.S.-based visitor.

## Pages Recovered

1. `city-danang-place-banh-xeo-ba-duong`
   - Before: assumed readers knew bánh xèo and leaned on table rhythm without enough dish definition.
   - After: defines bánh xèo as a sizzling savory pancake, names rice paper, herbs, skewered pork, pickled papaya, and peanut sauce, then explains the wrap-and-dip behavior.

2. `city-danang-place-be-man`
   - Before: useful but still abstract about the seafood display and "recognized ritual."
   - After: frames Bé Mặn as the louder My Khe-side seafood restaurant where dinner starts with tanks, trays, price or size confirmation, and cooking style.

3. `city-danang-place-nam-danh-seafood`
   - Before: had visible `Why Save It` / `Save it` language and a generic local-seafood frame.
   - After: removes save-command wording and explains Năm Đảnh as the local-feeling residential-neighborhood seafood table: shared shellfish, cold drinks, many tables, price checks, and small dishes to compare.

4. `city-hanoi-place-hibana-by-koki`
   - Before: improved from the original screenshot, but still carried polished `splurge` shorthand and did not fully center the U.S. hibachi-style mental model.
   - After: plainly explains Japanese teppanyaki: a chef cooking at a hot grill in front of a small counter inside Capella Hanoi, closer to refined hibachi-style dining than a normal restaurant table.

5. `city-hcmc-place-banh-xeo-46a`
   - Before: said the pancake slowed the table down, but still did not define the food enough for someone new to Vietnam.
   - After: explains the huge sizzling pancake, bean sprouts, mung beans, pork, shrimp, greens, and sauce, then gives the practical table behavior and ingredient warning.

## Source Files Edited

- `content-draft/viet/city-library/handwritten-copy/danang.json`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/handwritten-copy/hcmc.json`
- `content-draft/viet/city-library/app-detail-v2-2/danang.json`
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`
- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
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

This batch improved the positive traveler value of the selected pages by making the unfamiliar familiar:

- Bà Dưỡng: bánh xèo is defined before the roll-and-dip ritual appears.
- Bé Mặn: the seafood-display ordering format is explained before dinner begins.
- Năm Đảnh: the page now makes the local-table contrast clear without telling the reader to save it.
- Hibana: teppanyaki is explained through the U.S. hibachi-style mental model.
- Bánh Xèo 46A: the dish filling and table behavior are clear enough for a first-time visitor.

Validators were used only after the prose existed. They caught formula residue such as `best` during the targeted batch scan; they did not author the pages.

## Remaining Work

20 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages
- Batch 003: 5 pages
- Batch 004: 5 pages

Remaining authored recovery scope: 500 listings.

Continue with small batches chosen from high formula-risk pages, screenshot-flagged pages, and listings with unfamiliar food/place/format terms. Do not mark all listings production-ready until every listing has page-level authored review, regenerated resources, validation, and rendered reading proof.
