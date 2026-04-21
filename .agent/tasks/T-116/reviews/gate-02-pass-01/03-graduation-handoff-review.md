Approval: APPROVE

Findings:
- `content-draft/tagalog/scenario-plan.json` now exposes one explicit graduation boundary in `handoffContract.graduationBoundary`, including the blocker list and a single `stopCondition`, so a downstream runtime-facing lane can use one structured surface instead of reconstructing blockers from multiple docs.
- The supporting draft files now mirror that same boundary cleanly enough that the split between direct-pickup, later-only hold, and prep-only promotion is readable from the handoff itself.

Must-fix guidance:
- None for this gate.
