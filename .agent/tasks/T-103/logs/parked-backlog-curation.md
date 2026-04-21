# Parked Backlog Curation

## Objective

Convert the Tagalog v2 parked backlog into one sharper next-pass contract after the `16` starter-core plus `1` deferred-refusal handoff from `T-096`.

## Decisions

- Kept `tagalog-polite-basics-4` deferred as the lone refusal-boundary row outside promotion.
- Split the `7` parked drafted rows into one exact recommended next-pass pickup set:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
  4. `tagalog-hotel-hostel-5`
  5. `tagalog-convenience-store-6`
- Split the remaining parked drafted rows into one exact later-only hold set:
  1. `tagalog-simple-problems-7`
  2. `tagalog-grab-taxi-7`

## Why this split

- The five-row pickup set preserves the existing reopen order while converting it into one real next-pass contract instead of a generic parked cluster.
- The two later-only holds stay behind the pickup set because escalation register risk and narrow cash-declaration utility remain weaker than the map-showing, hotel, and card-payment rows.
- The lane stays prep-only; no parked row was promoted into the active `16`-row starter core or the lone deferred refusal boundary.

## Surfaces updated

- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`

## Validation plan

- Re-parse the touched CSV surfaces.
- Confirm required outputs exist.
- Confirm only task-scope files changed.
