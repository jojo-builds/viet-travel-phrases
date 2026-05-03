# TASK-VIET-EDITORIAL-MODEL-SUPPORT-001 Result

Status: complete, support-only. The deferred ChatGPT pilot rows remain `REVIEW_ONLY`; no deferred pilot section copy was imported.

Commit: recorded in the final thread report after this result artifact is committed.

## Accepted Steers

- Linked canonical targets were created only where required by the 17 deferred pilot rows.
- New targets are full source-owned canonical pages, not stubs.
- Existing canonical page IDs and canonical Vietnamese titles were preserved.
- Deferred ChatGPT section copy was not imported in this task.
- EP-005 and EP-007 use only stable sourced visitor-flow facts; volatile hours, prices, schedules, policies, rankings, awards, wait times, and "best" claims are excluded.
- Readiness is honest: this task does not force all deferred rows into the ready bucket.

## What Changed

- Added the task card: `docs/task-cards/TASK-VIET-EDITORIAL-MODEL-SUPPORT-001.md`.
- Added the source-owned support lane: `content-draft/viet/editorial-model-support/TASK-VIET-EDITORIAL-MODEL-SUPPORT-001/`.
- Added 32 full canonical support pages for the deferred pilot graph:
  - restaurant ordering, menu/drinks, payment, and ride-back rows;
  - dish order, ingredient, spice, and diet/allergy rows;
  - place journey/navigation rows for tickets, cable car, entrance, driver wait, photo help, and return flow;
  - street pronouncer rows for street-only, driver sentence, confirmation, drop-off, wrong-place, and pickup-location flows;
  - title-preserving route/ticket full-sentence support;
  - EP-020 politeness/English-help follow-up support.
- Extended `native-ios/scripts/generate-viet-catalog.js` and `native-ios/scripts/generate-authored-tier-one-pages.js` so the support lane is assembled through source-driven generation.
- Added `native-ios/scripts/validate-viet-editorial-model-support.js`.
- Extended SQLite validation with the intentional reviewed compound form `Anh/chị chỉ giúp tôi được không?`.
- Regenerated Viet catalog, authored listing pages, SQLite fixture/report, audio audit, planned missing-audio queue, and canonical/page-quality audit artifacts.

## Readiness Classification

Ready to ask Jojo for approval in a follow-up import task: `EP-001`, `EP-002`, `EP-004`, `EP-005`, `EP-006`, `EP-007`, `EP-008`, `EP-009`, `EP-010`, `EP-011`, `EP-013`, `EP-016`, `EP-020`.

Ready only as a title-preserving import variant after Jojo approval: `EP-012`, `EP-014`, `EP-015`.

Blocked: `EP-003`. Reason: proposed copy changes the canonical identity from `Cao lầu ở Hội An` toward `Cao lầu`; import needs a Jojo decision on whether to preserve the existing city-specific title or create a separate dish-name page.

Blocked for research-needed: none.

Blocked for unresolved linked rows: none.

Detailed artifact: `content-draft/viet/editorial-model-support/TASK-VIET-EDITORIAL-MODEL-SUPPORT-001/audit/deferred-readiness.json`.

## Stable Fact Evidence

- EP-005 Bà Nà Hills: used only stable attraction/cable-car journey context from Vietnam Tourism and the official Sun World destination listing. No prices, schedules, current policies, route counts, or rankings were imported.
- EP-007 Ngũ Hành Sơn / Marble Mountains: used only stable attraction/entrance/cave/pagoda visitor-flow context from Da Nang Fantasticity and Vietnam Tourism. No prices, hours, or current policy details were imported.

## Validation

- `node native-ios/scripts/generate-viet-catalog.js` PASS: 3,059 families, 3,078 phrases.
- `node native-ios/scripts/generate-authored-tier-one-pages.js` PASS: 32 editorial model support pages generated; 2,126 planned missing-audio rows.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` PASS: 3,070 pages, SQLite integrity OK.
- `node native-ios/scripts/validate-viet-editorial-model-support.js` PASS: 17 deferred rows checked; 13 ready; 3 title-preserving ready; 1 blocked title identity; 32 support pages.
- `node scripts/practice/generate-viet-practice-deck.js --check` PASS: 7,200 items.
- `node native-ios/scripts/validate-viet-city-library.js` PASS: 750 city pages.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` PASS: 0 duplicate canonical groups; 0 banned file matches; 0 release-blocking missing audio.
- `node native-ios/scripts/audit-viet-canonical-content.js --check` PASS: 3,070 / 3,070 pages PASS.
- `node native-ios/scripts/audit-viet-page-quality.js` PASS: 3,070 / 3,070 canonical pages PASS.
- `node native-ios/scripts/validate-tier-one-listing-pages.js` PASS: 150 / 150 strong; 0 thin/awkward/placeholder/over-templated/negative/missing-link pages.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` PASS.
- `node --test scripts/practice/generate-viet-practice-deck.test.js` PASS.
- Broad wrong-template/internal wording scan PASS: no matches for the known wrong-template/internal phrases in generated Viet resources and the new support lane.
- `git diff --check` PASS.
- Scope proof PASS: `native-ios/App/**`, `native-ios/Resources/Audio/**`, `native-ios/project.yml`, and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` unchanged.

## Reviewer Gate

Focused read-only reviewer gate passed:

- Traveler usefulness: support pages are practical first-time-traveler tasks, not half-pages.
- Page-kind fit: restaurant, dish, place journey, street pronouncer, route/ticket, and politeness support rows use their own content shape.
- Canonical graph integrity: every visible linked row in the readiness artifact resolves to exactly one canonical page.
- Future import readiness: ready rows are safe to ask Jojo about next; blocked/title-preserving rows are separated instead of silently imported.

## Recommended Next Task

Ask Jojo whether to approve the ready subset (`EP-001`, `EP-002`, `EP-004`, `EP-005`, `EP-006`, `EP-007`, `EP-008`, `EP-009`, `EP-010`, `EP-011`, `EP-013`, `EP-016`, `EP-020`) for an editorial import task.

Then handle `EP-012`, `EP-014`, and `EP-015` as a title-preserving import variant, and keep `EP-003` blocked until the canonical identity decision is explicit.
