Approval: BLOCK

Findings
- The five direct-pickup rows are still only classified as an ordered review cluster in `content-draft/tagalog/tagalog-v2-first-wave.csv`.
- `content-draft/tagalog/scenario-plan.json` still describes a coherent cluster-level gate, but not the required per-row promotion packet.

Required fixes before Gate 1 can approve
- Add an explicit disposition for each of the five direct-pickup rows using `promote now`, `keep prep-only`, `defer for native/expert review`, or `later-only`.
- Keep the deferred refusal row and the two later-only hold rows explicitly non-promoted.
- Mirror the row-level dispositions in the README, CSV notes, and scenario plan so the next lane does not have to infer intent from blocker labels.

Notes
- The gap is boundary specificity for the five direct-pickup rows, not the existence of the boundary itself.
