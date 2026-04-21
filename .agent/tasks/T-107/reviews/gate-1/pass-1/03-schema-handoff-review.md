Findings
- BLOCK: The plan is directionally aligned with the current model, but it is not specific enough for a frontend/runtime handoff because it does not define the exact authored schema for `relation-sample-v1.json` or the optional CSV linkage columns. The docs support a sidecar relation layer, but the plan still leaves the runtime-facing contract ambiguous.
- BLOCK: "Optional CSV linkage columns for sample families only" reads like a prototype escape hatch, not a reusable contract. That creates a risk that implementation will hard-code sample behavior instead of extending the existing family/row model in a way the runtime can consume consistently.

Risks
- Family-level vs row-level relation ownership is still underspecified, so the sample could drift from the actual generated pack shape.
- The starter-safe website subset and app/runtime subset are not clearly separated, so export consumers may not know which relation fields are guaranteed.
- Without explicit field names and required/optional semantics, the handoff will require re-interpretation during implementation, which defeats the goal of avoiding redesign work.

Approval: BLOCK
