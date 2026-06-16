# Handwritten Recovery Batch 020

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Pages Recovered

1. `viet-family-city-hcmc-place-banh-xeo`
2. `viet-family-city-hcmc-place-banh-xeo-46a`
3. `viet-family-city-hcmc-place-ben-thanh-market`
4. `viet-family-city-hcmc-place-bep-me-in`
5. `viet-family-city-hcmc-place-binh-tay-market`

## Count

- Previous recovered count: 94 / 520
- Batch 020 recovered: 5
- Current recovered count: 99 / 520
- Remaining: 421

## Copy Recovery Notes

- Rewrote the batch from first-class V2.2 source in `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`.
- Removed label-like or abstract phrasing caught in review, including "named table," "market read," "the table relaxes," "the value is," "fancy star," "opening bearings," and "working-market rhythm."
- Explained Bib Gourmand in visible Bếp Mẹ Ỉn copy as Michelin's good-food-for-the-price category, separate from star ratings.
- Clarified bánh xèo for U.S. readers as a crisp crepe-like dish with shrimp or pork, bean sprouts, greens, herbs, and sauce, not an American breakfast pancake.
- Made Bánh Xèo 46A a specialist, hands-on table rather than vague guide-status copy.
- Separated Ben Thanh as the central first-market reference from Bình Tây as a Chợ Lớn working-market and trade-district visit.

## QA Loop

- Read-only readability QA agent reviewed the five scoped pages and returned `REVISE` notes for all five.
- Integrated the useful QA fixes into source, then reran projection and validation.
- A second fact-risk QA agent stalled and was closed; factual-risk checks stayed conservative by omitting hours, prices, access, closure, and award-year claims from visible copy.

## Validation

Commands run:

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

Results:

- V2.2 strict validation: PASS, 520 entries, 520 pass / 0 revise / 0 fail.
- V2.2 voice audit: PASS, 0 failures after source fixes.
- City production copy validation: PASS, 520 city noun pages.
- City library validation: PASS, 826 pages.
- SQLite fixture validation: PASS, `ok: true`, 0 banned file matches.
- Listing production QA audit: PASS, 0 blockers, 0 majors.
- `git diff --check`: PASS.

## Render Proof

Simulator profile: `city-listings-production-ready`
Simulator: `SpeakLocal City Listings`
Rendered page: `viet-family-city-hcmc-place-binh-tay-market`

Screenshots:

- `render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-020-screenshots/binh-tay-market-hero.jpg`
- `render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-020-screenshots/binh-tay-market-sections.jpg`

Simulator was left open on the repaired Binh Tay body sections for Jojo review.

## Phone Build

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: blocked because the phone was locked. The app installed successfully; iOS denied launch until the device is unlocked.
- Repo signing hygiene: PASS. Project signing files stayed clean; no personal signing settings were written to tracked project files.

## Status

Batch 020 is recovered and projected into native runtime resources. The overall goal remains active: 99 / 520 pages recovered, 421 remaining.
