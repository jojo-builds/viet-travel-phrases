## Gate 1 Pass 1

- Role: `01-data-consumer-review.md`
- Artifact reviewed: pre-edit implementation plan for T-147
- Reviewer: subagent `Gauss`

Approval: APPROVE

## Summary

The preview-local derived fixture is the right seam because the current prototype is still hardcoded while the Viet source packet already separates wording truth, relation truth, and module-mix truth cleanly.

## Findings

- Relation links still need an explicit `targetFamilyId -> sampled hub` resolver so the preview never invents page ids.
- `Quick say` is not always a real swap, so duplicate quick/default cases need a no-op-safe presentation rule.

## Suggested adjustments

- Make the transform contract explicit up front: `hubById`, `hubByFamilyId`, `phraseById`, `linkableRelationTargets`, `unresolvedRelationTargets`, plus provenance metadata on the derived fixture.
- Prefer generating all 24 hubs into the fixture even if the first pass only surfaces a tighter proof set in the UI.
- Keep `Break it down` derived only from authored fields such as phrase text, English, pronunciation, and context.
