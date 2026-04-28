# Gate 1 Pass 2: Operator Clarity Review
## Summary
The revised contract is clear enough to proceed with edits. It closes the main Pass 1 operator-facing gap by making recovery handoff a third explicit queue-tool path, separate from cheap non-seeding `repair` and app/ledger-only `desktop-recover`, which are already distinct in the current surface (`.agent/QUEUE_REPAIR.md:19-21`, `.agent/QUEUE_MAINTENANCE.md:67-90`, `.agent/queue_tool.py:1898-1908`). The added `--task-id` and `--dry-run` behavior, machine-readable dedupe metadata, legacy-pair handling for `T-139`/`T-140`, and explicit locked write ordering make the expected operator outcome understandable before implementation.

## Key Risks
- The main remaining risk is implementation drift, not contract ambiguity: help text and docs still need to say plainly that `repair` never seeds recovery work and `desktop-recover` never authors recovery packets.
- The dry-run output must keep the promised operator cues together: qualification result, existing or proposed recovery task id, dedupe outcome, and whether write mode would backfill metadata or create a new task, especially for the legacy `T-139 -> T-141` and `T-140 -> T-142` cases (`.agent/tasks/T-139/recovery-notes.md:13-18`, `.agent/tasks/T-140/recovery-notes.md:12-16`).
- The historical-truth model should stay explicit in docs and output: the original task remains blocked interrupted history while the recovery task owns closeout, consistent with `.agent/AUTOMATION.md:34-40`.

## Recommendation
Approve Gate 1 Pass 2. The revised contract now gives operators a clear mental model for when to use each command, what the inspection path will show, and how duplicate prevention and legacy recovery pairs behave.

Approval: APPROVE
