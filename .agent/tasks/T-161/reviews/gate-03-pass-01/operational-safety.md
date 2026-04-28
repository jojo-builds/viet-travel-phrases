Approval: APPROVE

Operational safety looks preserved. `claim-next` checks active `in_progress` `locks.write` conflicts in dry-run and real claim paths, keeps one-task-per-run behavior, allows parallel non-overlapping claims, preserves bounded direct-patch fallback with immediate re-read, and leaves heartbeat/finish helper compatibility intact. No global active-worker requirement was introduced.
