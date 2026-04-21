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
- Best-effort queue-index and event-log updates are optional for desktop prompt-only runs; they must never block task claim or completion.

## Scope
- each real task gets its own folder under `tasks/`
- process one task per automation run
- stay inside the chosen task's write scope
- use `.agent/QUEUE_START.md` for the queue-run entry flow
