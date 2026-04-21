Findings
- The handoff is still missing an explicit runtime consumption seam. The current generated pack only exposes scenarios and a flattened phrases export in `app/family/packs/viet.generated.ts`, while the revised plan adds a CSV sidecar and sample JSON but never says which consumer merges them or whether generated runtime output should expose relation fields. That makes it additive in concept, but not yet concrete enough for frontend/runtime handoff.
- The relation referent model is still underspecified. The current docs explicitly allow family-to-family and row-to-row relations in `docs/PHRASE_RELATIONSHIP_MODEL.md`, but the revised plan only defines `familyRelations` labels and `relation_cluster_memberships_json` without stating whether each reference points at `familyId`, `primaryPhraseId`, or both.

Risks
- JSON-in-CSV will need escaping and validation rules, or the new column will be brittle in authoring.
- `whatYouMayHear` is advisory-only, but the plan does not define a provenance rule, so approximations may drift from the actual row content.
- The 12-cluster minimum is useful, but without a category quota the sample can still overfit a few traveler moments.

Approval: BLOCK
