## Gate 1 Pass 1

- Role: `04-scope-fallback-and-provenance-review.md`
- Artifact reviewed: pre-edit implementation plan for T-147
- Reviewer: subagent `Laplace`

Approval: BLOCK

## Summary

The write scope is disciplined and the Viet content worktree is being treated correctly as read-only source context, but provenance and unresolved-target fallback rules are not yet strict enough for the actual source shape.

## Findings

- The plan does not yet explicitly require the preview-local fixture to stay anchored to real upstream hub ids, which makes the “real proof hub” bar harder to measure.
- The fallback rule is too loose unless it explicitly forbids `Open page` affordances for unresolved relation targets outside the local preview set.
- If the proof set shifts away from the old medical-only page list, the branch-local blueprint must be updated so the repo truth matches the new preview shape.

## Suggested adjustments

- State explicitly that only 1:1 mapped hubs from `answer-page-sample-v1.json` count toward the real-hub proof requirement.
- Carry provenance per record in the derived fixture: upstream `hubId`, `relationClusterId`, source file paths, and the selected phrase/family ids used to derive the preview shape.
- Only show `Open page` when a target resolves to a preview-local page record; otherwise omit the page affordance or present the item as non-page guidance with different copy.
- Keep broader operations and onboarding docs untouched and update only the preview-local blueprint if the proof set changes.
