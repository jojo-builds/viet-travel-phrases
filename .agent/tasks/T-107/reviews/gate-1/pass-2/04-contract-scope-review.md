Findings
- `relation_cluster_refs` plus a single `relation_cluster_role` is not contract-safe as written if a row can join more than one cluster. The docs call for relation arrays and optional row-level overrides, which implies relation-specific metadata rather than one role for many refs. A single role cannot unambiguously describe multiple authored cluster memberships.

Risks
- `reply-response` does not match the doc's current relation labels (`reply_to`, `likely_answer_to`), so the JSON sidecar needs an explicit mapping note to avoid schema drift.
- The plan adds a CSV-side relation layer plus a JSON cluster sidecar, while the docs prefer family-level relation arrays as the first implementation shape. That is still additive, but only if the sample clearly defines how row-level authored refs roll up to family-level truth.

Approval: BLOCK
