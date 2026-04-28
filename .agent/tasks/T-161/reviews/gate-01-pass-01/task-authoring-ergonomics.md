Approval: APPROVE

Future orchestrator guidance is clear enough for Gate 1. The updated queue docs cover lock classes, narrow vs broad/path locks, task-local locks, ownership-boundary task sizing, and one-task-per-run with multi-card parallelism.

Non-blocking caveat: `.agent/coordination/locks.yaml` still reads like a legacy lock registry, but the newer docs are explicit enough that this gate should not block on it.
