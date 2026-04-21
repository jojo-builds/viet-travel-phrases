Findings
- No scope creep blocker. The revised plan stays additive, preserves the current scenario -> family -> phrase row model, keeps `app/family/packs/viet.generated.ts` unchanged, and limits new authored truth to the sidecar relation sample plus one optional CSV column.

Risks
- The plan introduces two relation authoring surfaces: row-level `relation_cluster_memberships_json` and family-level `familyRelations`. That is still within scope, but it will need a clear precedence rule to avoid ambiguity later.
- The render-language constraints like `you may hear` and `possible response` are fine as doc-level guidance, but they should not become runtime behavior assumptions in this task.

Approval: APPROVE
