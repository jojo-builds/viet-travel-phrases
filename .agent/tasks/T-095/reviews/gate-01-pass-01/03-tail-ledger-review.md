# Gate 1 Tail Ledger Review

Reviewer: Tail Ledger
Gate: 1
Approval: BLOCK
Findings:
- The residual tail is described as low-priority and future-only in prose, but the reviewed files do not assign the remaining small-talk rows into explicit `next`, `later-review`, or `deferred` buckets.
- The pharmacy-adjacent follow-on remains conditional and underspecified. `research-backlog.md` mentions a small pharmacy / medicine follow-on set, but it does not name the rows, the ordering test, or whether that work is next or deferred.
- `README.md` and `source-notes.md` still phrase the tail as an open decision, which would force a future worker to re-triage it.
Recommended changes:
- Add an explicit tail ledger section that names the remaining small-talk rows as `deferred` or `later-review` with short reasons, and record pharmacy-adjacent items as `next`, `later-review`, or `deferred`.
- Replace open-ended wording such as "decide whether" and "if it outranks" with a concrete bucketed contract.
