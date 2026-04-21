# T-088 Follow-On Audit

## Main-pass decision

- Cleared the active premium-follow-on queue instead of promoting the five unresolved rows.
- Preserved the clean `16`-row starter core as the only direct runtime-handoff set.
- Kept `tagalog-polite-basics-4` visible as the lone deferred refusal boundary.

## Rows moved out of the active handoff

- `tagalog-directions-1`
- `tagalog-hotel-hostel-1`
- `tagalog-hotel-hostel-2`
- `tagalog-hotel-hostel-5`
- `tagalog-convenience-store-6`

## Why

- The five rows are still useful, but keeping them as an active premium-follow-on queue overstated runtime readiness.
- The cleaned handoff is now a tighter prep surface: direct authoring rows plus one explicit honesty boundary.
- Later review order remains documented in `source-notes.md`, `risk-review.md`, and `research-backlog.md`.

## Validation snapshot

- `Import-Csv content-draft/tagalog/phrase-source.csv` -> `70` rows, `16` `first-wave-core`, `0` `first-wave-holdout`, `1` `first-wave-deferred`.
- `Import-Csv content-draft/tagalog/first-wave-priority.csv` -> `17` rows, `16` `first-wave-core`, `0` `first-wave-holdout`, `1` `first-wave-deferred` via `current_status`.
- `Import-Csv content-draft/tagalog/tagalog-v2-first-wave.csv` -> `17` rows, `16` `first-wave-core`, `0` `first-wave-holdout`, `1` `first-wave-deferred` via `current_status`.
- Required task output files exist under `content-draft/tagalog/**` and `.agent/tasks/T-088/logs/follow-on-audit.md`.
- `git status` requires `-c safe.directory=E:/AI/Viet-Travel-Phrases` in this environment because the checkout resolves through the compatibility alias.
