# Gate 1 Pass 1: Operator Clarity Review
## Summary
The planned direction is understandable before edits. The current lean set already separates cheap `repair` (`.agent/QUEUE_REPAIR.md:3-21`), heavier maintenance/top-up (`.agent/QUEUE_MAINTENANCE.md:3-26`), and guarded desktop-app restart recovery (`.agent/QUEUE_MAINTENANCE.md:67-90`, `.agent/queue_tool.py:1312-1434`). The main gap is that recovery-task generation exists today mostly as worker guidance (`.agent/AUTOMATION.md:34-40`), not yet as an operator-facing CLI/doc contract.

## Key Risks
- `.agent/QUEUE_REPAIR.md:19-21` plus `T-143/spec.md:78-90`: cheap repair explicitly does not seed new tasks, so the docs must say recovery-handoff generation is not part of ordinary `repair`. Otherwise operators can misread a mutating recovery generator as “just repair.”
- `.agent/QUEUE_MAINTENANCE.md:67-90`, `.agent/AUTOMATION.md:34-40`, and `.agent/queue_tool.py:1903-1908`: the CLI/help/docs must clearly distinguish `desktop-recover` from recovery-handoff generation. Restart recovery is for a stuck desktop episode; recovery-handoff generation is for salvaging already-landed meaningful work from a stale interrupted task.
- `.agent/tasks/T-139/recovery-notes.md:3-18`, `.agent/tasks/T-140/recovery-notes.md:3-16`, and `T-143/spec.md:83-90`: the docs and inspection output must make the bounded scope explicit: what already landed, what closeout remains, how the original task stays historical truth, and how duplicate recovery-task generation is prevented.

## Recommendation
Approve Gate 1. The edits should make four things explicit in durable docs and the CLI surface: the exact trigger conditions for recovery-handoff generation, that `repair` stays cheap/non-seeding, that `desktop-recover` only starts/restarts the app and never authors recovery packets, and that at least one read-only inspection or `--dry-run` path shows candidate task id, qualification reasons, proposed recovery-task linkage, duplicate-suppression result, and whether anything would mutate.

Approval: APPROVE
