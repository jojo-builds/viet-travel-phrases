# Tagalog Starter Contract Audit

## Scope

- Task: `T-109`
- Lane: prep-only `content-draft/tagalog`
- Goal: leave one retrieval-ready starter contract, one ordered next-pass expansion cluster, and one explicit later-only hold boundary without implying runtime promotion

## Final contract

- Outcome counts:
  - `16` starter handoff rows
  - `1` deferred refusal boundary
  - `5` ordered next-pass expansion rows
  - `2` later-only hold rows
  - `24` total named row outcomes
- Starter handoff rows stay in `phrase-source.csv`, `first-wave-priority.csv`, `tagalog-v2-first-wave.csv`, and `scenario-plan.json`.
- The deferred boundary remains `tagalog-polite-basics-4`.
- The next-pass expansion cluster is:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
  4. `tagalog-hotel-hostel-5`
  5. `tagalog-convenience-store-6`
- The later-only hold boundary is:
  1. `tagalog-simple-problems-7`
  2. `tagalog-grab-taxi-7`

## What changed

- Standardized terminology across the lane around `starter handoff`, `next-pass expansion cluster`, and `later-only hold boundary`.
- Added a structured `handoffContract` object to `scenario-plan.json` so downstream pickup can read one machine-friendly contract instead of stitching together several prose files.
- Tightened row-level notes in `phrase-source.csv` and the two active handoff CSVs so the current boundary language matches the narrative docs.
- Kept the lane prep-only and did not promote any parked or deferred row into runtime-adjacent truth.

## Validation targets

- `Import-Csv` should still parse:
  - `content-draft/tagalog/phrase-source.csv`
  - `content-draft/tagalog/first-wave-priority.csv`
  - `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `scenario-plan.json` should still parse as valid JSON.
- Required task outputs should all exist before finish.
