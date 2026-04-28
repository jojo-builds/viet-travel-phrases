# Gate 1 Pass 2: Recovery Policy Review
## Summary
The revised contract now preserves the right recovery policy and lifecycle truth. It keeps recovery handoff generation in a new explicit queue-tool command instead of expanding `repair` or `desktop-recover`, which matches the current repo split between cheap repair and app/ledger recovery. It also moves duplicate prevention into machine-readable `state.json` metadata, which aligns with the repo rule that `state.json` is authoritative while `queue-index.json` is advisory only. The bidirectional recovery metadata plus legacy-pair recognition covers the existing `T-139 -> T-141` and `T-140 -> T-142` cases without creating another recovery successor.

## Key Risks
- The implementation still needs a clear salvage qualification check so it does not generate recovery handoffs for stale meaningful tasks that have no real landed work worth preserving.
- Legacy backfill should stay conservative; if an older pair is not clearly established, the tool should inspect/no-op rather than infer a risky match.
- Retry safety depends on dedupe lookup using the recovery task's `recovery.dedupeKey`, not only the original task's backlink, so partial failures converge cleanly.

## Recommendation
Approve. This contract now keeps the original interrupted task as blocked historical truth, makes the recovery task the single explicit follow-up, preserves existing command boundaries, and gives dry-run enough visibility to inspect qualification, dedupe, existing pairs, and mutation intent before writing.

Approval: APPROVE
