Approval: APPROVE

Findings
- None.

Rationale
The fail-together contract is now bound in all three places: the manifest carries `sampleId: viet-relation-sample-v1` and `sampleClusterCount: 29`, the canonical doc block repeats the same source boundary, and the validator explicitly checks both against `content-draft/viet/relation-sample-v1.json`. The exported starter surface stays bounded at 14 covered clusters across 6 modules, advisory-only, and the current checks are tight enough for this gate.
