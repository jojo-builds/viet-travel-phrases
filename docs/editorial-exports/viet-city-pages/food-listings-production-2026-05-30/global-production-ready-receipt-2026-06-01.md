# Global City Listings Production-Ready Receipt - 2026-06-01

Reviewer: Codex desktop

Worktree / branch / commit:

- `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
- `feature/city-listings-production-ready`
- source commit before this receipt: `558c9a653 Checkpoint city listings copy production`

Scope:

- First-class V2.2 app-detail source objects in `content-draft/viet/city-library/app-detail-v2-2/`
- Generated native resources and SQLite compatibility outputs derived from those source objects
- Static rendered listing QA model for the broader Viet listing runtime

## Decision

Status: `PASS_GLOBAL_PRODUCTION_READY`

All current first-class Viet city/place app-detail source objects are production-ready by the V2.2 contract as of this receipt. The approval authority is the V2.2 source object set, not the legacy city-library projection or generated native runtime files.

This supersedes the older `REVISE_BEFORE_GLOBAL_PRODUCTION` status in the 2026-05-30 review. The later 2026-05-31 repair passes removed the known visible save-mechanic leaks, generic related-card blockers, and voice drift patterns that were keeping the full set out of production approval.

## Evidence

Commands run on 2026-06-01:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/audit-viet-listing-production-qa.js
```

Results:

- V2.2 strict production validation: `PASS`
- V2.2 source entries: `520`
- City totals:
  - Đà Nẵng: `106 FINAL_PASS=106`
  - Hà Nội: `106 FINAL_PASS=106`
  - Hội An: `102 FINAL_PASS=102`
  - Huế: `100 FINAL_PASS=100`
  - Saigon: `106 FINAL_PASS=106`
- Status totals: `pass=520 revise=0 fail=0 unknown=0`
- Voice drift audit: `PASS`; no formula failures, no casing failures, no failures
- Static listing production QA: `1778` pages, `0` blockers, `0` majors, `63` minors, `3` info notes
- Duplicate hero sections: `1` data duplicate hidden at render time
- Hero image follow-ups: `0`
- Missing-audio priority rows: `500`, with no release-blocking missing audio rows reported by the stricter SQLite/content validation receipts from the handoff

## Accepted Non-Blocking Warnings

The remaining static-QA warnings are accepted for this production-ready classification:

- `section_body_long` warnings are minor copy-length prompts, not visible blockers. They flag paragraphs around 26-39 words for spot-checking if a rendered page feels heavy.
- section-order optional warnings reflect the current V2.2 authored section model, not a broken page contract. The current standard explicitly allows natural headings and page-specific section shape.
- `many_rendered_sections` appears on Bà Nà Hills, a macro attraction with route, ticket, cable-car, photo, and return-planning utility. It is intentionally denser than a restaurant or cafe page.
- `external_surface_probe` rows for Shopping, Da Nang, and All Vietnam are native browse or hub surfaces, not authored listing JSON defects.
- the single duplicate hero-section row is hidden at render time and is not a visible user-facing blocker.

## Production Gate Summary

The global set passes the V2.2 production gate because:

- every source object has a first-class V2.2 app-detail record;
- every source object is `FINAL_PASS` under strict production validation;
- rendered phrase-card and page-structure regressions were covered by the existing handoff validation chain;
- the voice audit no longer detects repeated formula failures or blocked internal-language patterns;
- the production QA model reports no blockers and no majors across the generated listing runtime;
- the known visible copy leaks called out in the handoff (`counter to save`, `part of the stop`, ambiguous comparison labels, `same-city` / `different pace` related-card copy) were repaired in the 2026-05-31 passes and remain at zero in the recorded scans.

## Do Not Change

- Do not revert to legacy `city-v1` or generated runtime files as approval truth.
- Do not treat old `humanizer-gate-500` or 2026-05-30 `REVISE_BEFORE_GLOBAL_PRODUCTION` language as current after this receipt.
- Do not bulk-rewrite production copy with scripts. Future changes should stay authored at the page level, then projected and validated.

## Next Release Notes

Before App Store submission or a marketing-heavy launch, run a fresh rendered simulator sample over representative restaurants, cafes, markets, drinks, dish pages, streets, transit points, and macro attractions. That is a release confidence pass, not a blocker on this production-ready source approval.
