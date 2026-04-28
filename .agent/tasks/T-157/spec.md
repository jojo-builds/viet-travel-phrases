# T-157: Mac queue heartbeat smoke test and short-prompt handoff

## Goal

Prove the Mac queue shape we want before using it for large worker sessions:

- Jojo gives a short prompt that names the repo and task id.
- The real task lives in this folder, not in the chat prompt.
- The worker claims one explicit task, sends a helper-backed heartbeat, writes a result, finishes through the helper, and commits.
- The worker stays out of app source, content, docs, simulator settings, and unrelated tasks.

This is a proof task. Larger real tasks may run `30` minutes to several hours; this task only tests the mechanics.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read first

1. `AGENTS.md`
2. `.agent/README.md`
3. `.agent/CODEX_MANUAL_TASK_PROMPT.txt`
4. `.agent/tasks/T-157/state.json`
5. `.agent/tasks/T-157/spec.md`

Do not auto-pick another queued task. Process `T-157` only.

## Allowed writes

You may write:

```text
.agent/tasks/T-157/state.json
.agent/tasks/T-157/result.md
.agent/coordination/queue-index.json
```

`queue_tool.py heartbeat` and `queue_tool.py finish` may rewrite `queue-index.json`. That is allowed for this smoke test.

Do not write app source, generated resources, content drafts, migrated archives, docs outside this task folder, simulator settings, or any other task folder.

## Claim

Claim this task by patching `.agent/tasks/T-157/state.json` directly:

- set `status` to `in_progress`
- set `phase` to `manual-smoke-claimed`
- set `session.owner` to `codex-desktop-automation`
- set `session.sessionId` to a unique id for your Codex worker session
- set `session.label` to `manual-T-157-heartbeat-smoke`
- increment `execution.attempt` from `0` to `1`
- set `execution.claimedAt`, `execution.lastHeartbeatAt`, `execution.leaseExpiresAt`, and `lastUpdated`

Immediately re-read `state.json`. If the session id is not yours, stop and report the conflict.

## Heartbeat Proof

After claim, send a helper-backed heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-157 --session-id "<your-session-id>" --phase "manual-smoke-heartbeat-tested" --lease-minutes 120
```

Re-read `state.json` and confirm:

- `phase` is `manual-smoke-heartbeat-tested`
- `execution.lastHeartbeatAt` is later than `execution.claimedAt`
- `session.sessionId` is still yours

## Work Steps

1. Run `git status --short` and record what you see.
2. Write `.agent/tasks/T-157/result.md` using this shape:

```markdown
# Result: T-157

## Status
- done

## Summary
- ...

## Files changed
- ...

## Verification
- ...

## Process feedback
- NONE: ...
```

3. The `Process feedback` section must include one bullet beginning exactly with `- NONE:`, `- BUG:`, or `- SUGGESTION:`.
4. Finish with the helper:

```bash
python3 .agent/queue_tool.py finish --task-id T-157 --status done --session-id "<your-session-id>"
```

5. Commit only the smoke-test changes with:

```text
Complete queue heartbeat smoke test T-157
```

## Done Criteria

The task is complete when:

- `.agent/tasks/T-157/result.md` exists
- `.agent/tasks/T-157/state.json` says `status: done` and `phase: completed`
- helper heartbeat succeeded after claim
- helper finish succeeded after `result.md` existed
- the task changes are committed
- `git status --short` is clean after the commit, or the result explains exactly why it is not clean

