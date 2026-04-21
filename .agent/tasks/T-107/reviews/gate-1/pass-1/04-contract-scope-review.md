Findings
- The plan is within the current spec boundary as written: it keeps the existing scenario -> family -> phrase-row model, adds relation truth as a sidecar layer, and limits the CSV change to optional sample-only linkage fields.
- The proposed `relation-sample-v1.json` with 12 Viet clusters matches the task's required sample scope and does not imply a broader graph-storage or runtime rewrite.

Risks
- The CSV linkage columns need to stay strictly additive and blank-compatible for non-sample rows; if they require generator/runtime changes beyond the authored handoff, that would become scope creep.
- `relation-authoring-notes.md` should remain guidance only. If it starts defining new runtime behavior or website product surface rules beyond starter-safe consumption, it will drift past this task's contract.

Approval: APPROVE
