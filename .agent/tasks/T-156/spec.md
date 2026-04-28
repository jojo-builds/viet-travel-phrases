# T-156: Mac queue smoke test and manual worker handoff

## Goal

Prove the repo-local `.agent` queue can hand one explicit task from this orchestrator session to a separate Codex worker session on this Mac.

This is a proof task. Do not change the app, content catalog, generated resources, simulator, or docs outside this task folder.

## Worker setup

Work from:

```text
/Users/jojolim/Developer/products/speaklocal/app-family
```

Read these first:

1. `AGENTS.md`
2. `.agent/README.md`
3. `.agent/CODEX_MANUAL_TASK_PROMPT.txt`
4. `.agent/tasks/T-156/state.json`
5. `.agent/tasks/T-156/spec.md`

Do not auto-pick any other queued task. Process `T-156` only.

## Allowed writes

You may write:

```text
.agent/tasks/T-156/state.json
.agent/tasks/T-156/result.md
```

You may also let normal git metadata change as part of committing the task.

Do not write app source, generated resources, content drafts, migrated archives, or other task folders.

## Claim steps

Claim this task by patching `.agent/tasks/T-156/state.json` directly:

- set `status` to `in_progress`
- set `phase` to `manual-smoke-claimed`
- set `session.owner` to `codex-manual-worker`
- set `session.sessionId` to a unique id for your Codex worker session
- set `session.label` to `manual-T-156-queue-smoke`
- increment `execution.attempt` from `0` to `1`
- set `execution.claimedAt`, `execution.lastHeartbeatAt`, `execution.leaseExpiresAt`, and `lastUpdated`

Immediately re-read `state.json`. If the session id is not yours, stop and report the conflict.

## Work steps

1. Run `git status --short` and record what you see.
2. Write `.agent/tasks/T-156/result.md` with:
   - `Summary`
   - `Files changed`
   - `Verification`
   - `Process feedback`
3. In `Process feedback`, include exactly one of these labels:
   - `NONE:` if the queue handoff was clear
   - `BUG:` if the queue docs or state blocked you
   - `SUGGESTION:` if the flow worked but should be improved
4. Mark `.agent/tasks/T-156/state.json` as complete:
   - `status`: `done`
   - `phase`: `completed`
   - update `execution.lastHeartbeatAt` and `lastUpdated`
5. Commit only your task changes with:

```text
Complete queue smoke test T-156
```

## Done criteria

The task is complete when:

- `.agent/tasks/T-156/result.md` exists
- `.agent/tasks/T-156/state.json` says `status: done` and `phase: completed`
- the task changes are committed
- `git status --short` is clean after the commit, or the result explains exactly why it is not clean

