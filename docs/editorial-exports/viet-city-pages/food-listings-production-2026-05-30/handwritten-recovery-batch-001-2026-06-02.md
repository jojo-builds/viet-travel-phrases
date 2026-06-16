# Handwritten Recovery Batch 001 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Status

Batch 001 is a real authored recovery batch, not a global production-ready claim.

Five high formula-risk listings were rewritten by page-level reasoning, mirrored into `handwritten-copy`, regenerated into native resources, and passed the existing safety validators. The larger 520-listing objective remains open.

## Pages Recovered

1. `city-danang-place-reply-1988`
   - Before: retro cafe facts were present, but the page read like a generic support cafe note.
   - After: positions Reply 1988 as a playful K-drama-style dessert-and-coffee break in Hải Châu, with salted/egg coffee, cake, photo corners, and a clear boundary that it is not the main Da Nang food memory.

2. `city-danang-place-wonderlust`
   - Before: described an iced drink and a bright room, but did not explain why someone would remember the listing.
   - After: frames Wonderlust as a practical modern reset: cold coffee, clean table, regrouping before markets, beach time, dinner, or the next ride.

3. `city-hanoi-place-hang-da-market`
   - Before: useful but generic market behavior: one lap, price question, small buy.
   - After: makes Hàng Da more specific as a compact central Hanoi market browse for bags, clothing, small goods, scooters at the edge, and a lighter alternative to giving the whole afternoon to Đồng Xuân.

4. `city-hanoi-place-lam-cafe`
   - Before: stronger than many pages, but repeated simple drink / room / short sit too often.
   - After: leans into the old Hanoi coffee-room identity: wall paintings, dark coffee, worn tables, street noise at the door, and a short atmospheric sit rather than a work session.

5. `city-hanoi-place-vietnam-art-gallery`
   - Before: repeated small/light/interior/calm without enough reason to care.
   - After: gives the page a clearer role as a small Hanoi art stop: a few works to notice, photo etiquette, a coffee/lake/museum pairing, and the advantage of adding art without losing the whole route.

## Source Files Edited

- `content-draft/viet/city-library/handwritten-copy/danang.json`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/app-detail-v2-2/danang.json`
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`
- Regenerated projection/source:
  - `content-draft/viet/city-library/v1.json`
  - `native-ios/Resources/viet-authored-listing-pages.json`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
  - `docs/content-audits/viet-city-copy-production-2026-05-17.json`
  - `docs/content-audits/viet-listing-production-qa-001/*`

## Safety Validation

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

This batch is materially better than the previous validator-led copy because each page now answers a concrete traveler question:

- What is this place?
- Why would it belong in this trip?
- What should I picture?
- What would I do first?
- What nearby or comparable plan does it pair with?

This does not mean all 520 pages are production-ready. It means the recovery method works on the first batch and should be repeated page by page.

## Length Policy

No arbitrary character cap was used. The page should be as long as needed to give real value, and no longer than the phone can comfortably read. Future batches should judge copy by specificity, travel usefulness, and rendered readability, not by making every page equally short.

## Remaining Work

Continue with the same method:

1. Pick the next small batch from high formula-risk or user-flagged listings.
2. Read the specific page object and source notes.
3. Add current venue/menu/source research when the listing makes factual restaurant, cafe, shop, or attraction claims.
4. Handwrite the page.
5. Regenerate resources.
6. Run validators as safety checks only.
7. Review the rendered page on iPhone/simulator for taste.

The active objective remains: all 520 listings need this level of authored review before a production-ready claim is honest.
