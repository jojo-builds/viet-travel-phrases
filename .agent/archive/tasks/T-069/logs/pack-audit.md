# T-069 Pack Audit

## Scope

- Task: `T-069`
- Objective: build a prep-only Tagalog first-wave translation pack with explicit starter vs premium boundary posture.

## Required output check

- `content-draft/tagalog/README.md` exists
- `content-draft/tagalog/source-notes.md` exists
- `content-draft/tagalog/phrase-source.csv` exists
- `content-draft/tagalog/first-wave-priority.csv` exists
- `content-draft/tagalog/rewrite-notes.md` exists
- `content-draft/tagalog/tagalog-v2-first-wave.csv` exists

## Row and boundary check

- `tagalog-v2-first-wave.csv` parses with `24` rows
- all `24` rows keep both `scenario_id` and `phrase_id`
- pack bucket counts:
  - `starter-core`: `16`
  - `premium-follow-on`: `6`
  - `deferred-review`: `2`
- access-tier candidate counts in `first-wave-priority.csv`:
  - `starter`: `16`
  - `premium`: `8`
- next-action counts in `first-wave-priority.csv`:
  - `translate-now`: `16`
  - `review-before-promotion`: `6`
  - `rewrite-pattern-review`: `2`
- `phrase-source.csv` still parses with `70` rows and preserves the same first-wave status counts:
  - `first-wave-core`: `16`
  - `first-wave-holdout`: `6`
  - `first-wave-deferred`: `2`

## Targeted phrase hardening

- `tagalog-directions-3` now reads as a direct walking-time question
- `tagalog-asking-price-6` now uses a clearer polite request shape
- `tagalog-convenience-store-1` now uses clearer bottle wording
- `tagalog-hotel-hostel-2` now uses cleaner check-in wording while staying a holdout
- `tagalog-simple-problems-7` now uses a clearer polite call-for-me request while staying a holdout

## Boundary posture

- The `16` core rows are projected as the next starter-safe build surface.
- The `6` holdouts and `2` deferred rows remain prep-only premium follow-on material, not starter promotion candidates.
