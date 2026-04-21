# Tagalog Starter-Core Hardening Log

## Main-pass change set

- Preserved the `16`-row `starter-core` slice as the direct authoring-ready set for the next runtime/content task.
- Promoted `tagalog-directions-1` out of `first-wave-deferred` into `first-wave-holdout` / `premium-follow-on` after tightening the generic map-showing wording to `Paumanhin, paano po pumunta sa lugar na ito`.
- Left `tagalog-polite-basics-4` as the lone deferred refusal row so the remaining unresolved bucket is narrower and more explicit.
- Updated the prep-lane notes so `README.md`, `source-notes.md`, `rewrite-notes.md`, `risk-review.md`, and `research-backlog.md` all agree on the new `16 / 7 / 1` split.

## Validation snapshot

- `Import-Csv content-draft/tagalog/tagalog-v2-first-wave.csv` -> `24` rows, `16` `starter-core`, `7` `premium-follow-on`, `1` `deferred-review`, `0` missing `scenario_id`, `0` missing `phrase_id`
- `Import-Csv content-draft/tagalog/first-wave-priority.csv` -> `16` `first-wave-core`, `7` `first-wave-holdout`, `1` `first-wave-deferred`
- `Import-Csv content-draft/tagalog/phrase-source.csv` -> `70` total rows with the same `16 / 7 / 1` first-wave split
- `rg` scan for stale `6 holdouts / 2 deferred` wording in `content-draft/tagalog` -> no remaining matches

## Open caution

- `tagalog-directions-1` is improved enough to leave the deferred bucket, but it still needs a later native-confidence check before promotion into the direct starter build.
