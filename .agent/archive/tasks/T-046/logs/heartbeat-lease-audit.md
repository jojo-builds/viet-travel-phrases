# Heartbeat and lease observability audit

## Scope
- Task: T-046
- Session: `6899ad1d-3e8e-4380-8c6c-28ae75599ef1`
- Command used for claim: `py .agent\queue_tool.py claim-next --session-id "6899ad1d-3e8e-4380-8c6c-28ae75599ef1" --label "queue-burnin-r3-edgehunter-20260419-1006" --review-runtime no-review-subagents`

## Evidence checked
- `.agent/coordination/queue-events.jsonl`
- `.agent/tasks/T-026/state.json`
- `.agent/tasks/T-027/state.json`
- `.agent/tasks/T-028/state.json`
- `.agent/tasks/T-029/state.json`
- `.agent/tasks/T-046/state.json`

## Observations
1. The live event stream tells a mostly coherent story when claim, heartbeat, and finish all happen. Example: T-040 through T-043 show clean `claim-next-claimed` -> `heartbeat` -> `finish` sequences with distinct phases.
2. For blocked meaningful tasks T-026 through T-029, each `state.json` preserves enough core lease fields to reconstruct the last owner and terminal timing: `claimedAt`, `lastHeartbeatAt`, `leaseExpiresAt`, `attempt`, and `reclaimReason`.
3. A brittle detail remains: after `finish`, `leaseExpiresAt` is overwritten with the finish timestamp. That makes the field stop meaning "lease expiry" and start meaning "run ended here," which can blur operator interpretation.
4. Another ambiguity: the queue events log records heartbeat phases, but the task `state.json` for blocked tasks only shows final `phase: "blocked"`. Mid-run phases such as `contract-check-blocked`, `implementation`, and `blocked-awaiting-review-path` survive only in `queue-events.jsonl`, not in task-local durable state.
5. The event log is append-only and useful, but operator clarity depends on reading both `state.json` and `queue-events.jsonl` together. A state-only check cannot explain why T-026 through T-029 were abandoned versus intentionally blocked unless the blocker text is read carefully.
6. Slight-variance risk: multiple proof tasks were claimable within seconds during burn-in. If two runs accidentally reused a label pattern or if logs are filtered by label rather than `sessionId`, operator attribution could get fuzzy fast.
7. Slight-variance risk: meaningful tasks were recently claimable even though older logs showed them being skipped under `no-review-subagents`. That suggests the runtime-readiness gating story changed over time, which is operationally important but not surfaced directly in the claimed task state.

## Operator verdict
- **Mostly sufficient for forensic reconstruction, not ideal for quick-glance observability.**
- Healthy vs abandoned can usually be distinguished if the operator checks both the task state and queue event log.
- The surface is weaker for quick answers to "what was the last real working phase?" and "did the lease truly expire, or was the task intentionally finished?"

## Concrete improvements
1. Preserve a separate terminal field such as `execution.finishedAt` instead of reusing `leaseExpiresAt` on finish.
2. Store `execution.lastNonTerminalPhase` or a short phase history in `state.json` so the final durable task record keeps the last meaningful working stage.
3. Add an explicit `execution.endedReason` enum (`done`, `blocked`, `reclaimed`, `crashed-suspected`, `lease-expired`) to reduce inference from mixed fields.
4. Consider persisting the last heartbeat event id or timestamp correlation so operators can jump from `state.json` to the matching queue event range.
