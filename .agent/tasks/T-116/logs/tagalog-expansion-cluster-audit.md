# Tagalog Expansion Cluster Audit

## Objective

Convert the inherited five-row Tagalog expansion cluster into one direct-pickup contract with an explicit graduation boundary, without changing the current `24`-outcome prep-only split.

## What changed

- Replaced history-heavy `T-114` phrasing in `phrase-source.csv`, `first-wave-priority.csv`, and `tagalog-v2-first-wave.csv` with direct contract language for:
  - the deferred refusal boundary
  - the five direct-pickup rows
  - the two later-only hold rows
- Added one explicit `handoffContract.directPickupContract` object in `content-draft/tagalog/scenario-plan.json`.
- Added one explicit `handoffContract.graduationBoundary` object in `content-draft/tagalog/scenario-plan.json`.
- Updated `README.md`, `source-notes.md`, `research-backlog.md`, and `risk-review.md` so the next runtime-facing lane can read one compact stop condition instead of stitching promotion blockers together from multiple notes.

## Resulting contract

- Visible outcomes remain `24` total:
  - `16` starter rows
  - `1` deferred refusal row
  - `5` direct-pickup rows
  - `2` later-only hold rows
- The five direct-pickup rows remain one ordered review lane:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
  4. `tagalog-hotel-hostel-5`
  5. `tagalog-convenience-store-6`
- The later-only hold boundary remains:
  1. `tagalog-simple-problems-7`
  2. `tagalog-grab-taxi-7`

## Promotion boundary

- The lane stays prep-only.
- Reopening later-only holds is separate from safe promotion.
- Runtime-safe promotion is still blocked by:
  - refusal-tone review for `tagalog-polite-basics-4`
  - directions confidence review for `tagalog-directions-1`
  - hotel-language review for `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, and `tagalog-hotel-hostel-5`
  - payment-language review for `tagalog-convenience-store-6`
  - escalation and register review for `tagalog-simple-problems-7`
  - pronunciation posture review for the expanded Tagalog lane

## Why retrieval is sharper now

- The main handoff surface now exposes both the direct-pickup contract and the graduation boundary in `scenario-plan.json`.
- The CSV notes now say what each non-starter row is for in the current contract instead of referring back to an older task pass.
- A downstream runtime-facing worker can now start from one stop condition and one ordered pickup lane without rereading `T-103`, `T-109`, `T-114`, `research-backlog.md`, and `risk-review.md` to reconstruct promotion posture.
