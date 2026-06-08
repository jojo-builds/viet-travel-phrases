# Handwritten Recovery Batch 003 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 003 is complete as a five-page authored recovery batch. It is not a global production-ready claim for all 520 listings.

The batch was rewritten page by page from the authored source, then imported into the V2.2 app-detail source, regenerated into native resources, and passed the existing safety validators. The point of the batch was not shorter copy. The point was copy with enough plain traveler value to answer what the place is, why it might matter, and how a first-time U.S.-based visitor should read it.

## Pages Recovered

1. `city-danang-place-cong-caphe-bach-dang`
   - Before: river-walk coffee copy used "hinge" and generic seat/heat phrasing without explaining the branded cafe value.
   - After: frames the branch as a recognizable retro Cộng Cà Phê riverfront pause: coconut coffee, iced milk coffee, green chairs, air-conditioning, Dragon Bridge timing, and a useful comparison with Long Coffee.

2. `city-danang-place-le-duan-night-market`
   - Before: short-browse language was accurate but thin, with formula risk around "full food crawl" and "are enough."
   - After: explains the compact market role: clothing racks, phone cases, small gifts, snack smoke, one lap before buying, light bargaining, and Helio as the larger comparison.

3. `city-hoian-place-streets-restaurant-cafe`
   - Before: "purposeful room" and "social-training story" were too vague for readers who do not already know the venue.
   - After: plainly identifies STREETS as a seated Hội An restaurant tied to hospitality training for local young people, with a calmer dinner role after market grazing, lantern walks, and heat.

4. `city-hanoi-place-pho-gia-truyen`
   - Before: the page described steam, beef, and room pace but did not explain the dish clearly enough for first-time travelers.
   - After: explains phở bò as beef noodle soup and frames Phở Gia Truyền as a recognizable Old Quarter place for broth, sliced beef, herbs, quick ordering, and a focused bowl.

5. `city-hue-place-night-market`
   - Before: "easy night browse" copy did not give enough route, behavior, or decision value.
   - After: frames the market as the after-dark Perfume River walk after Citadel, tomb, or museum-heavy days, with snack/gift browsing, price phrases, small cash, and flexible dinner expectations.

## Source Files Edited

- `content-draft/viet/city-library/handwritten-copy/danang.json`
- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/handwritten-copy/hue.json`
- `content-draft/viet/city-library/app-detail-v2-2/danang.json`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`
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

This batch improved the positive traveler value of the selected pages. Each page now makes a clearer promise without telling the reader to save anything:

- Cộng Bạch Đằng: reliable riverfront branded coffee reset, with coconut coffee and Long Coffee contrast.
- Lê Duẩn Night Market: compact browse, light bargaining, and a scale comparison against Helio.
- STREETS: seated restaurant plus hospitality-training purpose, explained in plain language.
- Phở Gia Truyền: beef pho defined before the Old Quarter shop rhythm takes over.
- Hue Night Market: after-royal-sites river walk, price phrases, small cash, and flexible dinner planning.

Validators were used only after the prose existed. They caught formula remnants such as `it fits`, `Use ...` section opening, and `are enough`; they did not author the pages.

## Remaining Work

15 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages
- Batch 003: 5 pages

Remaining authored recovery scope: 505 listings.

Continue with small batches chosen from high formula-risk pages and user-flagged screenshots. Do not mark all listings production-ready until every listing has page-level authored review, regenerated resources, validation, and rendered reading proof.
