# TASK-VIET-EDITORIAL-MODEL-SUPPORT-001

## Task Done

The task is done when the 17 deferred ChatGPT editorial pilot rows have source-owned canonical linked-row support, validators can prove future imports will not create broken links or wrong page-kind templates, and the result honestly classifies which rows are ready for a future Jojo-approved import. The task must not import the deferred `REVIEW_ONLY` rows.

## Context

- Pilot source: `docs/editorial-exports/viet-canonical-pages/chatgpt-pilot-2026-05-03/`.
- P0 import result: `docs/task-results/TASK-VIET-EDITORIAL-PILOT-IMPORT-001.md`.
- Existing page-kind model result: `docs/task-results/TASK-VIET-CITY-PLACE-TEMPLATE-VALIDATOR-001.md`.
- Accepted Jojo steers:
  - Support commit only.
  - Do not import deferred pilot section copy.
  - New linked canonical targets are allowed only when required for the 17 deferred rows.
  - Any new linked target must be a full source-owned canonical page, never a stub.
  - Preserve existing canonical IDs and canonical Vietnamese titles.
  - For `EP-005` and `EP-007`, use only stable sourced facts; otherwise mark blocked.
  - The result should classify readiness honestly, not force every row ready.

## Worker Judgment

Build the support layer through durable source and generators. Do not hand-edit generated resources except by regeneration. If a pilot row proposes changing a canonical Vietnamese title, keep that row out of direct import readiness unless Jojo later approves the identity change or the future import is explicitly title-preserving.

## Required Outcome

- Add the task-owned support lane under `content-draft/viet/editorial-model-support/TASK-VIET-EDITORIAL-MODEL-SUPPORT-001/`.
- Add full canonical support pages only for visible linked rows required by the deferred pilot rows.
- Add a deferred-readiness artifact covering `EP-001` through `EP-016` and `EP-020`.
- Extend generators so support records flow into the catalog, authored pages, SQLite, audio queue, and practice surfaces.
- Add validators so unresolved linked rows, duplicate normalized Vietnamese pages, wrong templates, title changes, unsupported volatile facts, and accidental deferred imports fail.
- Write a task result with readiness classifications, created/reused targets, stable-fact evidence, validation, reviewer gate, and the recommended next import subset.

## Boundaries

- Do not import deferred `REVIEW_ONLY` rows.
- Do not generate audio or edit `native-ios/Resources/Audio/**`.
- Do not edit native Swift UI under `native-ios/App/**`.
- Do not change existing canonical Vietnamese titles or page IDs.
- Do not include volatile facts such as prices, hours, schedules, wait times, awards, current policies, or “best” claims.

## Validation

- New deferred readiness validator.
- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- Broad wrong-template/internal wording scan.
- `git diff --check`
- Proof that `native-ios/App/**` and `native-ios/Resources/Audio/**` are unchanged.

## Result Contract

Write `docs/task-results/TASK-VIET-EDITORIAL-MODEL-SUPPORT-001.md` with status, commit hash, accepted steers, final readiness classification for all 17 rows, support pages created/reused, stable source evidence, validator outcomes, reviewer outcome, and the exact recommended next import subset requiring Jojo approval.
