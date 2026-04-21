# Result: T-077

## Status

- done
- Gate 3 is unanimously approved and `state.json` should match this final status

## Truth changed

- prepared-next

## Changed files

- `content-draft/tagalog/README.md` - updated the handoff contract to the new `16 / 7 / 1` split and clarified the next-task pickup order.
- `content-draft/tagalog/source-notes.md` - synced the pack boundary, non-core queue, and next-pass rule to the new premium follow-on versus deferred split.
- `content-draft/tagalog/phrase-source.csv` - tightened `tagalog-directions-1` into a clearer generic map-showing line and moved it from deferred to holdout.
- `content-draft/tagalog/first-wave-priority.csv` - reclassified `tagalog-directions-1` as `premium-follow-on` with a narrower review note.
- `content-draft/tagalog/rewrite-notes.md` - documented the row-level hardening and the new `16 / 7 / 1` projection.
- `content-draft/tagalog/tagalog-v2-first-wave.csv` - preserved the 24-row handoff while moving `tagalog-directions-1` into premium follow-on with updated wording and notes.
- `content-draft/tagalog/risk-review.md` - reduced the deferred-risk description to the lone refusal row and added the map-showing follow-on caution.
- `content-draft/tagalog/research-backlog.md` - updated the remaining review queue so the backlog matches the new lane truth.
- `.agent/tasks/T-077/logs/pack-hardening.md` - recorded the main-pass changes and the count/linkage checks used for review.

## Validation performed

- `Import-Csv content-draft/tagalog/tagalog-v2-first-wave.csv` - passed with `24` rows, `16` `starter-core`, `7` `premium-follow-on`, `1` `deferred-review`, and no missing `scenario_id` or `phrase_id`
- `Import-Csv content-draft/tagalog/first-wave-priority.csv` - passed with `16` `first-wave-core`, `7` `first-wave-holdout`, and `1` `first-wave-deferred`
- `Import-Csv content-draft/tagalog/phrase-source.csv` - passed with `70` total rows and the same `16 / 7 / 1` first-wave split
- `rg` scan for stale `6 holdouts / 2 deferred` wording under `content-draft/tagalog` - passed with no remaining matches
- review gate check - passed with `4` review files and explicit `Approval: APPROVE` in the latest pass of Gate 1, Gate 2, and Gate 3

## Review findings and fixes

- Gate 1 reviewers unanimously approved the pre-edit pack as a valid starting surface for a real hardening pass.
- Gate 2 reviewers unanimously approved the main pass and explicitly agreed that moving `tagalog-directions-1` out of deferred was an honest unresolved-row reduction rather than a cosmetic relabel.
- The concrete fix was to tighten `tagalog-directions-1` into `Paumanhin, paano po pumunta sa lugar na ito`, move it to `first-wave-holdout` / `premium-follow-on`, and leave `tagalog-polite-basics-4` as the sole deferred refusal row.

## Gate summary

- Gate 1 latest pass: `gate-01-pass-01` with `4` approval files and unanimous `Approval: APPROVE`
- Gate 2 latest pass: `gate-02-pass-01` with `4` approval files and unanimous `Approval: APPROVE`
- Gate 3 latest pass: `gate-03-pass-01` with `4` approval files and unanimous `Approval: APPROVE`

## Remaining open

- `tagalog-directions-1` is stronger and no longer deferred, but it still needs a later native-confidence check before promotion into the direct starter build.
- `tagalog-polite-basics-4` remains the lone deferred refusal row and still needs refusal-tone review.
- Pronunciation remains helper-only draft guidance across the lane.

## Process feedback

- BUG: `T-077` still references `.agent/tasks/T-032/result.md`, but that artifact is absent in this checkout, so queue workers have to proceed with partial historical context.
- SUGGESTION: the queue specs for prep-lane hardening tasks should state whether `research-backlog.md` is expected to stay in sync when the unresolved counts change, because it is effectively part of the same truth surface.

## Recommended next step

- Use the current `16` starter-core rows as the direct runtime/content pickup set, then pull `tagalog-directions-1` first from premium follow-on before reopening the remaining hotel, payment, escalation, and refusal-review rows.
