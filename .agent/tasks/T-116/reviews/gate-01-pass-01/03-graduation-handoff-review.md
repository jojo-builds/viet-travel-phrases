Approval: BLOCK

Findings:
- The row contract is mostly tight now: `README.md`, `source-notes.md`, `scenario-plan.json`, and the CSVs all agree on the `16 + 1 + 5 + 2 = 24` split, so backlog-shape ambiguity is largely gone.
- The graduation boundary is still not explicit enough as a single surface. The actual runtime-safe promotion blockers are spread across `research-backlog.md` and `risk-review.md`, so a downstream handoff still has to stitch together what blocks promotion.
- `scenario-plan.json` has a reopen rule for the later-only hold rows, but that is not the same as a promotion gate. It does not explicitly say what must be resolved before this Tagalog lane can graduate.

Must-fix guidance:
- Add one compact graduation-boundary section in the main handoff surface, ideally `scenario-plan.json` or `README.md`, that names the exact runtime-safe promotion blockers and the stop condition.
- That surface should separate `reopen later-only hold rows` from `safe to promote`, and explicitly list the unresolved review surfaces: refusal tone, hotel wording, payment wording, directions confidence, escalation risk, and pronunciation posture.
- Keep the contract prep-only and make the promotion boundary readable without consulting the backlog/risk docs first.
