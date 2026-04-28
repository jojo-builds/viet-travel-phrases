# T-161: Implement Parallel-Safe Queue Claiming And Worker Lane Contract

## Objective

Make the SpeakLocal repo-local queue safe for multiple Codex Desktop workers running at the same time.

The desired end state is not "one task at a time." The desired end state is:

- Jojo can keep this pinned thread as the orchestrator.
- The orchestrator can create multiple substantial tasks.
- Multiple worker sessions or automation runs can claim different tasks in parallel.
- Workers do not overwrite one another because the claim path enforces write-scope/lock conflicts.
- Every task remains recoverable through heartbeat, lease expiry, result artifacts, and commit/block closeout.
- A tiny launch prompt still works because all substantive instructions live in task files.

## Current Problem To Fix

The docs already say parallel workers are allowed when write scopes do not overlap, but the current queue helper does not enforce write-lock conflicts at claim time. That means parallelism is currently policy-driven and hand-curated, not robust enough for repeated `Run now` usage or multiple automation cards.

## Success Criteria

- Update queue tooling so `claim-next` skips queued/reclaimable tasks whose `locks.write` conflicts with any currently active `in_progress` task's `locks.write`.
- The lock conflict check must happen in both `--dry-run` and real claim paths.
- The claim output should report skipped lock conflicts clearly, similar to skipped ineligible tasks.
- Conflict handling should be conservative:
  - exact matching lock names conflict;
  - broad path-style locks such as `native-ios/App/**` should conflict with narrower descendants when reasonably detectable;
  - task-local locks such as `agent_task_T-161` should not block unrelated tasks.
- Update queue docs so future orchestrators know how to create parallel-safe tasks:
  - define lock classes;
  - avoid broad write locks unless needed;
  - split tasks by ownership boundary, not tiny size;
  - parallel workers may run only when write locks do not overlap;
  - one automation run still processes one task, but multiple runs/cards may run at the same time.
- Keep the meaningful-task review-runtime gate usable by the desktop worker lane. If the helper requires `SPEAKLOCAL_REVIEW_RUNTIME=subagents`, make the bootstrap docs and validation explain how workers pass that environment into helper commands.
- Add or create a small repeatable validation surface for lock-conflict behavior. Prefer a Python unit-style smoke test if practical; otherwise create a deterministic dry-run fixture/check script under `.agent/tasks/T-161/logs/` and document how to rerun it.
- Validate that current queued tasks remain healthy:
  - `T-161` should be claimable first because it has lower `selectionOrder`;
  - `T-160` should remain queued and become claimable after `T-161` completes.
- Do not make the queue require one global active worker.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read First

- `AGENTS.md`
- `.agent/README.md`
- `.agent/AUTOMATION.md`
- `.agent/QUEUE_START.md`
- `.agent/QUEUE_MAINTENANCE.md`
- `.agent/TASK_PROMPTING.md`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent/CODEX_MANUAL_TASK_PROMPT.txt`
- `.agent/queue_tool.py`
- `.agent/coordination/locks.yaml`
- `.agent/coordination/queue-index.json`
- `.agent/tasks/T-160/state.json`
- `.agent/tasks/T-160/spec.md`

## Worker Judgment

- Use GPT-5.5 reasoning to make the parallel model operational without making the queue brittle.
- Prefer narrow, explainable lock behavior over clever scheduling.
- Do not rewrite the whole queue system if a focused claim-safety patch plus docs/tests is enough.
- Preserve the current single-task-per-run behavior. Parallelism should come from multiple runs or automation cards, not one worker claiming many tasks.
- Record concise decisions, evidence, and tradeoffs in `result.md`; do not dump hidden chain-of-thought.

## Scope

- expected worker size: `60` to `180` minutes

### Allowed Write Scopes

- `.agent/queue_tool.py`
- `.agent/README.md`
- `.agent/AUTOMATION.md`
- `.agent/QUEUE_START.md`
- `.agent/QUEUE_MAINTENANCE.md`
- `.agent/TASK_PROMPTING.md`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent/CODEX_MANUAL_TASK_PROMPT.txt`
- `.agent/tasks/T-161/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only
- optional `.agent/tests/**` or `.agent/tasks/T-161/logs/**` for validation fixtures if the worker chooses that path

### Allowed Read Scopes

- `.agent/**`
- `docs/**`
- repo git history if needed

### Must Not Touch

- Native app implementation files.
- Content drafts outside queue/process docs.
- `T-160` spec content except read-only inspection.
- Audio files.
- Existing blocked task states unless a queue helper repair command legitimately rewrites generated queue-index only.

## Source-Of-Truth Notes

- `state.json` is lifecycle truth.
- `.agent/coordination/queue-index.json` is a rebuildable fast-selection aid.
- `locks.write` must become the machine-enforced ownership boundary for parallel workers.
- `blockedBy` is still useful task metadata, but parallel claim safety should not depend on humans remembering to set it.
- Current `T-160` is queued and should remain queued unless this task's validation deliberately dry-runs it.

## Required Checks

- `python3 -m py_compile .agent/queue_tool.py`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- `python3 .agent/queue_tool.py health`
- `git diff --check`
- Run the new or updated lock-conflict validation and record the exact command in `result.md`.
- If JSON files are edited, validate them with `python3 -m json.tool <path> >/tmp/<safe-name>.json`.

## Relevant Skills

- `superpowers:systematic-debugging` for queue claim behavior verification.
- `superpowers:test-driven-development` if adding a focused test or fixture for lock conflict behavior.

## Heartbeat And Recovery Contract

- keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`
- heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after validation, before/after spawned subagent waits, and before finish
- preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-161 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- if helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`

## Review Gate

Review is mandatory. Use 3 gates. Each gate uses exactly 4 read-only Codex subagents and must loop until all 4 explicitly return `Approval: APPROVE`.

Gate 1, concurrency design:

- claim-lock semantics reviewer;
- recovery/heartbeat reviewer;
- multi-automation workflow reviewer;
- task-authoring ergonomics reviewer.

Gate 2, implementation correctness:

- queue helper code reviewer;
- dry-run/real-claim parity reviewer;
- lock fixture/test reviewer;
- current queue compatibility reviewer.

Gate 3, readiness:

- source-of-truth docs reviewer;
- operational safety reviewer;
- validation evidence reviewer;
- follow-up automation-card strategy reviewer.

Review artifacts should be stored under `.agent/tasks/T-161/reviews/gate-XX-pass-YY/`.

## Automation State Contract

This task is a meaningful queue/tooling task:

- `automation.taskClass`: `meaningful`
- `automation.proofTask`: `false`
- `automation.reviewersRequired`: `4`
- `automation.reviewGatesRequired`: `3`
- `automation.reviewGateConsensusRequired`: `4`
- all 3 gates require unanimous approval in the latest pass before the task can finish

## Definition Of Done

- Queue claim behavior prevents active write-lock conflicts.
- Parallel worker policy is written in the queue docs in plain English.
- Validation proves a conflicting task is skipped while a non-conflicting task remains claimable.
- Existing queued `T-160` remains available after `T-161` is done.
- `result.md` exists and includes:
  - status;
  - summary;
  - files changed;
  - validation;
  - review gates;
  - follow-up tasks if any;
  - process feedback.
- All 3 review gates pass with unanimous 4-subagent approval.
- `state.json` is finalized through the helper if run by a worker.
- The worker commits its changes if it owns the task.

## Blocker Rule

Do not block just because full multi-card automation orchestration needs UI/manual pressing. This task only needs to make the repo queue safe for multiple workers to claim non-overlapping work. If desktop automation card fan-out needs another task, recommend it in `result.md`.

## Token Discipline

Do not paste entire queue files or long generated indexes into `result.md`. Use compact evidence, commands, and paths.
