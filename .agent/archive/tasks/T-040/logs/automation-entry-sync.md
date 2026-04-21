# Automation entry sync audit, T-040

## Checked surfaces
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`
- `.agent/queue_tool.py`

## Verdict
Drift found. The live repo docs and helper support a constrained desktop-runtime claim path, but the desktop automation entry surfaces still advertise the plain claim command without the runtime gate override.

## Evidence
1. Claim command shape drift
   - `.agent/QUEUE_START.md`: task selection guidance explicitly says to add `--review-runtime no-review-subagents` when the runtime cannot execute the nested meaningful review workflow.
   - `.agent/AUTOMATION.md`: claim protocol and cron-safe behavior also explicitly require `--review-runtime no-review-subagents` for runtimes that cannot run review subagents.
   - `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`: claim example is only `py .agent\queue_tool.py claim-next --session-id "<session-id>" --label "<label>"` with no `--review-runtime` override.
   - `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`: embedded prompt repeats the same plain claim command with no `--review-runtime` override.
   - `.agent/queue_tool.py`: `claim-next` supports `--review-runtime` and will reject meaningful tasks for runtimes that do not support the required review workflow.

2. Runtime-capability guidance drift
   - `.agent/QUEUE_START.md` and `.agent/AUTOMATION.md` both say unsupported meaningful tasks must be skipped and the helper enforcement path should carry the runtime capability signal.
   - The repo prompt and cron automation entry do not carry that signal, so a plain run can rely on the helper default `meaningful-capable` profile instead of the intended desktop proof-only profile.

3. Stop-condition alignment
   - Clean/aligned: prompt, queue docs, and helper all agree that `no_task` should stop immediately and `retry` should stop instead of looping.
   - Clean/aligned: prompt and queue docs both require `--session-id` on heartbeat/finish.

4. Crash/claim troubleshooting alignment
   - Clean/aligned: prompt and queue docs both direct operators to inspect `.agent/coordination/queue-events.jsonl` if claim or lock behavior looks wrong, and to stop blocked on helper crash instead of improvising.

## Recommendations
- Update `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt` to include the desktop-safe claim form with `--review-runtime no-review-subagents`.
- Update `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml` to embed the same runtime-gated claim command.
- Optionally add one explicit sentence in the prompt that this queue is currently proof-task-only unless runtime review capability is proven.
