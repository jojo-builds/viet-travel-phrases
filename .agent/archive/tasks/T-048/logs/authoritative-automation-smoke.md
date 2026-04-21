# Authoritative Automation Smoke

## Goal
Prove that the stale automation-entry drift was repaired and that one authoritative desktop queue runner remains.

## Automation surfaces
### Survivor
- File: `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`
- `id = "task-queue-10"`
- `status = "ACTIVE"`
- `cwds = ["E:\\AI\\SpeakLocal-App-Family"]`
- Prompt explicitly instructs the helper claim path and preserves structured `warnings` in task-local artifacts.

### Retired duplicate
- File: `C:\Users\Administrator\.codex\automations\task-queue-10-2\automation.toml`
- `id = "task-queue-10-2"`
- `status = "PAUSED"`
- Prompt explicitly says the entry is retired and that `task-queue-10` is the sole authoritative runner.

## Smoke evidence
- The survivor prompt matches the repo prompt posture in `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt` on the critical claim/heartbeat/finish rules.
- The survivor points at the canonical repo root, not a compatibility alias.
- The duplicate surface is no longer an active competing automation entry.

## Live emulation
- T-048 batch runs used the same canonical cwd as the survivor automation: `E:\AI\SpeakLocal-App-Family`
- T-048 batch runs used the same helper claim path named by the survivor prompt:

```text
py .agent\queue_tool.py claim-next --session-id "<session-id>" --label "<label>" --review-runtime no-review-subagents
```

- Those live emulation bursts produced 11 successful proof-task passes after repair.

## Conclusion
- One stale automation surface was explicitly retired instead of left active.
- One authoritative automation entry remains active with the hardened prompt and canonical cwd.
- The live proof-task runs demonstrate that the authoritative entry’s execution posture is viable on the repaired helper lane.
