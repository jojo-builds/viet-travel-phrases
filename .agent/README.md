# SpeakLocal repo-local agent workflow

This folder is the repo-local task surface for Codex queue work.

## Structure

```text
.agent/
  README.md
  coordination/
    locks.yaml
    queue-index.json
  orchestrator/
    digests/
  tasks/
    TEMPLATE/
      spec.md
      state.json
      result.md
```

## Task Prompting
- `.agent/TASK_PROMPTING.md` owns the queue task-prompting standard.
- Write worker specs as outcome contracts, not line-by-line scripts.
- The worker should reason from the goal, constraints, source truth, and validation requirements.
- Put hard requirements, write scopes, validation, and stopping conditions in the task file.
- Leave implementation path choices to the worker unless the sequence is a real safety requirement.

## Pinned orchestrator behavior
- The pinned Codex thread is primarily an orchestrator, not the default worker.
- Its normal job is to absorb Jojo's brain dumps, shape them into task packets, update source-of-truth docs, keep queue state clean, and stay available for the next idea.
- Long research, implementation, simulator/device proof, multi-file content work, audio generation, and broad audits should normally become `.agent/tasks/T-xxx` work for fresh worker sessions.
- Keep direct orchestrator edits small and queue/source-of-truth oriented unless Jojo explicitly asks this thread to execute the task itself.
- A good handoff prompt should be short: identify the repo and task ID, then let the task files carry the real specification.
- When a worker finishes, the orchestrator should read that task's `result.md` and changed source-of-truth docs, then report back to Jojo with a completion digest: what changed, what we learned, what decisions are now locked in, what remains risky, and the recommended next tasks.
- Worker completion is not "done" from the orchestrator perspective until the outcome is folded into the roadmap/source truth or explicitly parked.
- Store durable completion digests under `.agent/orchestrator/digests/T-xxx.md` so future sessions can recover the strategic meaning without rereading every worker artifact.

Copy-paste shape for a manual worker:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family and process queue task T-XXX.
Read .agent/CODEX_MANUAL_TASK_PROMPT.txt, then follow .agent/tasks/T-XXX/spec.md exactly.
Process only T-XXX, commit or block it, and stop.
```

## Truth
- task lifecycle truth lives in each task's `state.json`
- interrupted-task to recovery-task linkage lives in task `state.json` under `recovery`; `.agent/coordination/desktop-app-recovery.json` may mirror that linkage for maintenance visibility, but it is not lifecycle authority
- `.agent/coordination/queue-index.json` is a fast-selection aid only
- if `queue-index.json` and `state.json` disagree, trust `state.json`
- full logs belong in a task-local `logs/` folder
- review artifacts belong in a task-local `reviews/` folder
- for meaningful review tasks, reviewer subagents return judgments only; the parent worker persists the review artifacts after collecting those judgments

## Write Locks And Parallel Claims
- `locks.write` is the machine-enforced ownership boundary for queue parallelism.
- Use a named lane lock for shared conceptual ownership, for example `ios_family_shared_ui`, `shared_audio_pipeline`, `tagalog_relation_model`, or `queue_parallel_claim_safety`.
- Use a path-scope lock only when the task owns a broad filesystem area, for example `native-ios/App/**`; that conflicts with narrower descendants such as `native-ios/App/Models/PhrasePage.swift`.
- Include the task-local lock, for example `agent_task_T-161`, for task-folder ownership; task-local locks do not block unrelated tasks.
- Prefer the narrowest durable lock that protects the real write scope. Do not use a broad lock as a substitute for clear task ownership.
- `claim-next` skips queued or reclaimable candidates whose write locks conflict with an active `in_progress` task. Exact lock names conflict, and path-scope `/**` locks conflict with descendants.
- One worker run still processes one task. Parallelism comes from multiple workers or automation cards claiming different non-overlapping tasks.

## Desktop queue rule
- Prefer helper-backed claiming with `SPEAKLOCAL_REVIEW_RUNTIME=subagents python3 .agent/queue_tool.py claim-next ...` when the worker lane can call reviewer subagents; this enforces active write-lock conflicts before claim.
- Prompt-only desktop fallback runs may claim and finish by patching the chosen task's `state.json` directly with exact context and then re-reading to confirm ownership.
- Treat a direct patch as an optimistic compare-and-swap claim: if the patch no longer applies, the re-read session id is not yours, or the candidate's write locks conflict with an active `in_progress` task, move to the next eligible task.
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
