# SpeakLocal repo-local agent workflow

This folder is the repo-local task surface for Codex queue work.

## Structure

```text
.agent/
  README.md
  coordination/
    locks.yaml
    queue-index.json
  tasks/
    TEMPLATE/
      spec.md
      state.json
      result.md
```

## Truth
- task lifecycle truth lives in each task's `state.json`
- interrupted-task to recovery-task linkage lives in task `state.json` under `recovery`; `.agent/coordination/desktop-app-recovery.json` may mirror that linkage for maintenance visibility, but it is not lifecycle authority
- `.agent/coordination/queue-index.json` is a fast-selection aid only
- if `queue-index.json` and `state.json` disagree, trust `state.json`
- full logs belong in a task-local `logs/` folder
- review artifacts belong in a task-local `reviews/` folder
- for meaningful review tasks, reviewer subagents return judgments only; the parent worker persists the review artifacts after collecting those judgments

## Desktop queue rule
- Prompt-only desktop runs should claim and finish by patching the chosen task's `state.json` directly with exact context and then re-reading to confirm ownership.
- Treat that as an optimistic compare-and-swap claim: if the patch no longer applies or the re-read session id is not yours, move to the next eligible task.
- Use `.agent/coordination/queue-index.json` to choose candidates quickly, but never trust it over the candidate's live `state.json`.
- Once a task is claimed, ordinary runs should stop reading or writing hot queue surfaces other than that task's own `state.json` unless the task is explicitly a queue-maintenance/self-heal task.
- For interrupted meaningful-task salvage on the Mac, inspect with `python3 .agent/queue_tool.py recovery-handoff --task-id T-xxx --dry-run` before any write-mode recovery handoff generation or legacy metadata backfill.
- Best-effort queue-index and event-log updates are optional for desktop prompt-only runs; they must never block task claim or completion.

## Mac worker shape
- The queue is for execution-grade work that can occupy one worker session for `30` minutes to several hours, not just tiny next-step chores.
- Make tasks large enough to justify a worker: a real implementation/content packet, validations, review, result, and commit can all belong in one task when the write scope is clear.
- Scope tasks by ownership and recovery boundaries, not by the smallest possible edit. A good task has clear writable paths, clear stop conditions, and enough heartbeat checkpoints that another worker can recover if the session dies.
- The launch prompt should stay short. The prompt Jojo gives a manual worker should identify the repo and task id; the substantive instructions live in `.agent/tasks/T-xxx/spec.md`, with the task-local prompt archived beside it when useful.
- Keep `session.owner` as `codex-desktop-automation` for both manual and automation workers. The queue helper validates that owner; use `session.label` to distinguish `manual-*` from `automation-*`.
- Heartbeat during long work:
  - immediately after claiming, with a phase that proves the post-claim heartbeat path works
  - every `10` to `15` minutes during active work
  - before long builds, simulator checks, review passes, or subagent waits
  - after harvesting subagent results, before writing review artifacts, and before finish
- Preferred heartbeat command after claim:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-xxx --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 120
```

- Preferred finish command after `result.md` exists:

```bash
python3 .agent/queue_tool.py finish --task-id T-xxx --status done --session-id "<session-id>"
```

- If the helper is blocked, patch `state.json` directly and explain the helper failure in `result.md`.

## Scope
- each real task gets its own folder under `tasks/`
- process one task per automation run
- stay inside the chosen task's write scope
- use `.agent/QUEUE_START.md` for the queue-run entry flow
