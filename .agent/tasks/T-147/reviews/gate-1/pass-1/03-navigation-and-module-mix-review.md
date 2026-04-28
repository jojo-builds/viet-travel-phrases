## Gate 1 Pass 1

- Role: `03-navigation-and-module-mix-review.md`
- Artifact reviewed: pre-edit implementation plan for T-147
- Reviewer: subagent `Pauli`

Approval: BLOCK

## Summary

The `Swap hero` versus `Open page` split is directionally correct, but the plan still needs one canonical navigation identity, explicit fallback precedence for unresolved relation targets, and a locked proof set that visibly demonstrates different module mixes.

## Findings

- The plan does not yet name one canonical runtime key for deeper navigation, so search, browse, and relation rows could fragment instead of resolving through one supported-hub index.
- Unresolved relation targets are common in this sample, not edge cases, so a loose fallback rule would either produce dead links or hollow follow-up lanes.
- “Module cards/rows from hub modules” is not yet concrete enough to guarantee visibly different lower-page shapes across the four authored phrase classes.

## Suggested adjustments

- Use `familyId` as the preview page identity and resolve every `Open page` row, search result, and browse card through one sampled-hub map.
- Define fallback precedence before editing: resolved sampled targets first; unresolved targets become clearly non-navigable preview rows or deterministic resolved replacements, but never silent removals.
- Lock a proof set with visible class diversity and real variant/link coverage, such as `viet-greeting-thank-you`, `viet-medical-pharmacy`, `viet-repair-number`, and `viet-directions-map-pin`.
