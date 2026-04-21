# Gate 1 Review
- Role: Traveler utility
- Scope checked: `.agent/tasks/T-085/spec.md`, `.agent/tasks/T-085/state.json`, `content-draft/korean/README.md`, `content-draft/korean/source-notes.md`, `content-draft/korean/phrase-source.csv`, `content-draft/korean/first-wave-priority.csv`, `content-draft/korean/research-backlog.md`
- Findings: `content-draft/korean/phrase-source.csv:65-71` still leaves `korean-small-talk-1..4` and `korean-small-talk-7` as generic `needs-translation` rows, so the residual tail is not yet converted into the explicit low-priority or native-review handoff posture the task calls for. `content-draft/korean/first-wave-priority.csv` still stops at the last resolved row and does not surface any residual-tail or deferred section, so the ranked lane output still hides the final posture instead of making it explicit.
- Approval: BLOCK
