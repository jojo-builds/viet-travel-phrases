Approval: APPROVE

Findings
None.

Rationale
The hardening preserved the starter-only and exported-target-only boundary. The manifest, docs, and relation sample agree on the bounded contract: `viet-relation-sample-v1`, `29` sample clusters, `14` covered clusters, and advisory-only relation fields. The exported website payloads expose `relationContext` only on covered starter phrases, and the validator filters relation edges and response hints to targets already inside the exported website family set, so there is no premium or non-exported relation leakage.
