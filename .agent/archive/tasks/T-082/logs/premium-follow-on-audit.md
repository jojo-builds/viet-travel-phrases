# Premium Follow-On Audit

## Main-pass decision

- Kept the `16` starter-core rows unchanged.
- Reduced the active non-starter queue from `7 + 1` to `5 + 1`.
- Kept these rows in the active premium-follow-on queue:
  - `tagalog-directions-1`
  - `tagalog-hotel-hostel-1`
  - `tagalog-hotel-hostel-2`
  - `tagalog-hotel-hostel-5`
  - `tagalog-convenience-store-6`
- Kept `tagalog-polite-basics-4` as the lone deferred refusal row.
- Parked these former holdouts back into the broader drafted backlog:
  - `tagalog-simple-problems-7`
  - `tagalog-grab-taxi-7`

## Why this reduction is honest

- The narrowed follow-on queue now centers on map-showing, hotel arrival, room issue, and card-payment utility.
- The parked rows remain visible in `phrase-source.csv` and `research-backlog.md`; they were not deleted or silently promoted.
- The refusal row remains explicit and unresolved.
- The lane stays prep-only; no runtime or registry surfaces were touched.

## Files aligned in the pass

- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/research-backlog.md`

## Validation snapshot

- `Import-Csv content-draft/tagalog/phrase-source.csv` -> `16` `first-wave-core`, `5` `first-wave-holdout`, `1` `first-wave-deferred`
- `Import-Csv content-draft/tagalog/first-wave-priority.csv` -> `22` total rows with `16 / 5 / 1`
- `Import-Csv content-draft/tagalog/tagalog-v2-first-wave.csv` -> `22` total rows with `16 / 5 / 1`
- `git -c safe.directory=E:/AI/SpeakLocal-App-Family rev-parse --show-toplevel` -> repo resolves through compatibility alias `E:/AI/Viet-Travel-Phrases`
- `git -c safe.directory=E:/AI/SpeakLocal-App-Family status --short -- content-draft/tagalog .agent/tasks/T-082` -> only task-local and Tagalog draft surfaces listed

## Known caveat

- The repo currently has unrelated tracked changes under `app/`, `site/`, and `docs/operations/`, so changed-path verification has to distinguish task-local edits from pre-existing workspace churn rather than assuming a clean tree.
