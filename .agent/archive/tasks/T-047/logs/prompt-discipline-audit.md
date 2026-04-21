# T-047 Prompt discipline audit

## Surfaces checked
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`

## Findings
1. The runner prompt is mostly lean and operationally aligned with queue rules.
2. The strongest anti-wandering controls are present: fixed read order, explicit `claim-next`, explicit `no_task`/`retry` stop conditions, task-scope restriction, and helper-only claim/finish.
3. One recovery/observability gap remains: the prompt says to inspect `.agent/coordination/queue-events.jsonl` when claim or lock behavior looks wrong, but it does not also tell the worker to write the exact event evidence into the task-local log/result before stopping. That weakens interrupted-run recovery because later operators may know a failure happened without seeing the captured evidence in the task folder.
4. One heartbeat-timing clarification would help: the prompt says to heartbeat on material phase change and every 15 minutes after roughly 10 minutes, but it does not explicitly call out a pre-finish heartbeat when a run stayed short. The helper currently accepts claim-time heartbeat for short runs, but the wording could be clearer for operators reading artifacts later.
5. The automation TOML prompt body matches the checked runner prompt closely. I did not find obvious drift that would cause a different execution path.

## Recommended wording changes
- Add one sentence after the queue-events guidance: `Copy the exact failing command, traceback, and any relevant queue-events lines into the task-local log/result before finishing blocked.`
- Add one sentence near the heartbeat bullets: `For short runs, send at least one post-claim heartbeat when the task phase changes before writing result.md.`

## Recovery / observability notes
- Current prompt is good at preventing extra reads and extra task chaining.
- Current prompt is weaker at ensuring failure evidence is preserved inside the claimed task folder, which is the main artifact a future recovery operator is most likely to inspect first.
- For this run, the event trail felt recoverable because claim output, state ownership, and heartbeat were all deterministic and easy to verify.
