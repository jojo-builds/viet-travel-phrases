# Proof-Run Ledger

## Summary
- Successful end-to-end proof-task queue runs after repair: `11`
- Required minimum successful passes: `10`
- Failed verification attempts during burn-in: `1`
- Failure evidence: `.agent/tasks/T-048/logs/parallel-claim-interruption.md`

## Successful passes
| Task | Session | Claimed at | Finish at | Outcome |
| --- | --- | --- | --- | --- |
| `T-050` | `t048-b1-jason` | `2026-04-19T11:44:38.679354-05:00` | `2026-04-19T11:46:02.553126-05:00` | `done` |
| `T-051` | `t048-b1-rawls` | `2026-04-19T11:44:45.861420-05:00` | `2026-04-19T11:46:09.437573-05:00` | `done` |
| `T-052` | `t048-b1-dalton` | `2026-04-19T11:44:50.914062-05:00` | `2026-04-19T11:45:57.073796-05:00` | `done` |
| `T-053` | `t048-b1-harvey` | `2026-04-19T11:45:07.192041-05:00` | `2026-04-19T11:46:08.872201-05:00` | `done` |
| `T-054` | `t048-b2-dalton` | `2026-04-19T11:47:02.127856-05:00` | `2026-04-19T11:47:46.801756-05:00` | `done` |
| `T-055` | `t048-b2-rawls` | `2026-04-19T11:47:04.400785-05:00` | `2026-04-19T11:48:02.925176-05:00` | `done` |
| `T-056` | `t048-b2-harvey` | `2026-04-19T11:47:09.911727-05:00` | `2026-04-19T11:47:49.541851-05:00` | `done` |
| `T-057` | `t048-b3-jason` | `2026-04-19T11:50:03.955972-05:00` | `2026-04-19T11:50:41.602174-05:00` | `done` |
| `T-058` | `t048-b3-rawls` | `2026-04-19T11:50:06.596304-05:00` | `2026-04-19T11:50:48.942119-05:00` | `done` |
| `T-059` | `t048-b3-dalton` | `2026-04-19T11:50:08.746931-05:00` | `2026-04-19T11:50:54.093214-05:00` | `done` |
| `T-060` | `t048-b3-harvey` | `2026-04-19T11:50:09.184249-05:00` | `2026-04-19T11:50:52.727233-05:00` | `done` |

## Per-task artifacts
- `T-050`: `.agent/tasks/T-050/logs/proof-run.md`
- `T-051`: `.agent/tasks/T-051/logs/proof-run.md`
- `T-052`: `.agent/tasks/T-052/logs/proof-run.md`
- `T-053`: `.agent/tasks/T-053/logs/proof-run.md`
- `T-054`: `.agent/tasks/T-054/logs/proof-run.md`
- `T-055`: `.agent/tasks/T-055/logs/proof-run.md`
- `T-056`: `.agent/tasks/T-056/logs/proof-run.md`
- `T-057`: `.agent/tasks/T-057/logs/proof-run.md`
- `T-058`: `.agent/tasks/T-058/logs/proof-run.md`
- `T-059`: `.agent/tasks/T-059/logs/proof-run.md`
- `T-060`: `.agent/tasks/T-060/logs/proof-run.md`

## Notes
- Every successful pass used the real helper claim path, sent at least one helper heartbeat, and finished through the helper.
- `T-060` was added only after the failed batch-2 concurrent claim attempt, so the ledger keeps failed and successful verification attempts separated honestly.
