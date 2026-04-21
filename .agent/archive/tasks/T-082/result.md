# Result: T-082

## Status

- done
- Gate 3 is unanimously approved and `state.json` should match this final status

## Truth changed

- prepared-next

## Changed files

- `content-draft/tagalog/README.md` - narrowed the active first-wave contract from `16 / 7 / 1` to `16 / 5 / 1` and clarified the next-pass pickup order.
- `content-draft/tagalog/source-notes.md` - synced the active handoff boundary, parked-backlog rows, and next authoring rule to the smaller premium-follow-on queue.
- `content-draft/tagalog/phrase-source.csv` - moved `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` out of the active first-wave queue and back into drafted backlog status with explicit notes.
- `content-draft/tagalog/first-wave-priority.csv` - reduced the ranked active handoff to `22` rows and reordered the active follow-on queue around directions, hotel, and card-payment utility.
- `content-draft/tagalog/tagalog-v2-first-wave.csv` - dropped the parked escalation and cash rows from the merged active handoff and aligned the remaining `16 / 5 / 1` pack.
- `content-draft/tagalog/rewrite-notes.md` - documented the queue reduction and why the two parked rows no longer belong in the active first-wave target.
- `content-draft/tagalog/risk-review.md` - rewrote the risk clusters around the smaller active queue and separated parked backlog risk from active follow-on risk.
- `content-draft/tagalog/research-backlog.md` - updated the later review backlog to reflect the five active holdouts, one deferred refusal row, and two parked rows.
- `.agent/tasks/T-082/logs/premium-follow-on-audit.md` - recorded the main-pass reduction decision and the validation snapshot.

## Validation performed

- `Import-Csv content-draft/tagalog/phrase-source.csv` - passed with `16` `first-wave-core`, `5` `first-wave-holdout`, `1` `first-wave-deferred`
- `Import-Csv content-draft/tagalog/first-wave-priority.csv` - passed with `22` total rows and `16 / 5 / 1`
- `Import-Csv content-draft/tagalog/tagalog-v2-first-wave.csv` - passed with `22` total rows and `16 / 5 / 1`
- Gate 1 review check - passed with `4` approval files and unanimous `Approval: APPROVE`
- Gate 2 review check - passed with `4` approval files and unanimous `Approval: APPROVE`
- Gate 3 review check - passed with `4` approval files and unanimous `Approval: APPROVE`

## Review findings and fixes

- Gate 1 reviewers aligned on bounded de-scoping instead of pretending more rows were ready than the evidence supported.
- The main fix was to keep the strongest active premium-follow-on cluster visible (`tagalog-directions-1`, hotel arrival/room issue, and card payment) while moving `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` back into the broader drafted backlog.
- Gate 2 reviewers unanimously agreed that the narrowed queue is backed by real row-level changes rather than cosmetic relabeling.
- `tagalog-polite-basics-4` remains the lone deferred refusal row and still acts as the honesty boundary for this lane.

## Gate summary

- Gate 1 latest pass: `gate-01-pass-01` with `4` approval files and unanimous `Approval: APPROVE`
- Gate 2 latest pass: `gate-02-pass-01` with `4` approval files and unanimous `Approval: APPROVE`
- Gate 3 latest pass: `gate-03-pass-01` with `4` approval files and unanimous `Approval: APPROVE`

## Remaining open

- `tagalog-directions-1` still needs native confidence review before promotion beyond premium follow-on.
- The hotel and card-payment follow-on rows still carry loanword/payment caution.
- `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` remain drafted backlog rows rather than active first-wave rows.
- Pronunciation remains helper-only draft guidance across the lane.

## Process feedback

- BUG: Git resolves this workspace through the compatibility alias `E:/AI/Viet-Travel-Phrases`, which makes status/diff verification noisier than it should be for queue tasks rooted in `E:\AI\SpeakLocal-App-Family`.
- SUGGESTION: future prep-lane queue specs should say explicitly whether reducing an active handoff by parking weaker rows back into drafted backlog is the preferred form of holdout reduction when promotion would be dishonest.
