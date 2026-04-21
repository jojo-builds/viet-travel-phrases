# Current State

This file is a compatibility pointer for older references.

Current durable state now lives in:

- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`

Queue lifecycle truth does not live here. For queue runs, use:

- `.agent/coordination/queue-index.json` for shortlist order
- `.agent/tasks/T-xxx/state.json` for live lifecycle truth

Do not grow this file into a second maintained status surface.
