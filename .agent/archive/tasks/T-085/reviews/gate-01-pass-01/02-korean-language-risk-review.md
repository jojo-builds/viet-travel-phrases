# Gate 1 Review
- Role: Korean language risk
- Scope checked: `.agent/tasks/T-085/spec.md`, `.agent/tasks/T-085/state.json`, `content-draft/korean/README.md`, `content-draft/korean/source-notes.md`, `content-draft/korean/phrase-source.csv`, `content-draft/korean/first-wave-priority.csv`, `content-draft/korean/research-backlog.md`
- Findings: `content-draft/korean/phrase-source.csv` and `content-draft/korean/research-backlog.md` still leave the `small-talk-1..7` tail as a mixed set of generic `needs-translation` and `pending-next-pass` rows. That keeps them visible, but it does not yet satisfy the task requirement to convert the whole low-value social cluster into explicit low-priority or native-review handoff decisions. The medically sensitive line remains correctly fenced as expert-review-visible, so the blocker is only the unresolved social-tail posture.
- Approval: BLOCK
