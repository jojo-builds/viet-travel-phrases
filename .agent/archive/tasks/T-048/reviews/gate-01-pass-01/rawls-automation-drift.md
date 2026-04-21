BLOCK

- The active duplicate automation entry still creates authoritative-entry ambiguity.
- The plan was too weak on choosing one surviving automation id and explicitly retiring the duplicate.
- Prompt/cwd drift is real, but alias spelling alone is not the full root cause.
- Helper hardening must explicitly cover both failing write paths:
  - `.agent/coordination/queue-index.json`
  - `.agent/coordination/queue-events.jsonl`

Reviewer note:
- Promote `task-queue-10` as the only authoritative runner.
- Retire `task-queue-10-2` explicitly so the same-name duplicate cannot keep drifting.
