# Gate 1 Pass 2: Queue Tool Safety Review
## Summary
The revised contract is safe enough to proceed. It fixes the main Gate 1 concerns by keeping recovery handoff generation as a new explicit command instead of hiding it inside `repair` or `desktop-recover`, making duplicate prevention task-local and machine-readable via `recovery.dedupeKey`, and explicitly recognizing the legacy manual pairs `T-139 -> T-141` and `T-140 -> T-142` so the tool can inspect or backfill instead of creating duplicate successors.

## Key Risks
- Partial-failure behavior still needs careful implementation: if a run dies after creating the recovery task but before blocking the original, retry logic must treat the created successor as authoritative and converge without reopening the original path.
- Legacy backfill should stay narrowly scoped to confirmed original/recovery pairs and only add the new `recovery` metadata, not widen into broader task rewrites or external worktree path handling.
- Dry-run output needs to remain explicit about eligibility, dedupe result, existing/proposed recovery task id, and whether any mutation would occur so operators can safely inspect before writing.

## Recommendation
Proceed with edits. The contract now preserves the current queue-tool boundaries, gives the implementation an authoritative idempotence model, and narrows the write surface enough for a safe recovery-handoff path as long as all queue mutations stay under the existing lock and `repair` remains non-seeding while `desktop-recover` remains app/ledger-only.

Approval: APPROVE
