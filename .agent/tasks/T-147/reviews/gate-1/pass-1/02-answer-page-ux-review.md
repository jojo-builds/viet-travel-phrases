## Gate 1 Pass 1

- Role: `02-answer-page-ux-review.md`
- Artifact reviewed: pre-edit implementation plan for T-147
- Reviewer: subagent `Erdos`

Approval: BLOCK

## Summary

The direction preserves the best parts of the Liquid Glass prototype, but the plan still needs explicit UX guardrails for hubs without real hero swaps, for module-copy cleanup, and for discovery beyond the old medical-only demo.

## Findings

- Several real hubs have no meaningful quick/default split, so the current `Quick say` and swap-lane affordances would become no-op UI unless the plan defines section-presence fallbacks.
- The generated module copy still contains authoring-style scaffolding and should not be surfaced raw without a normalization pass.
- Search suggestions, browse cards, and prompt chips are still hardcoded to the old medical lane, which would hide the intended multi-class proof even if the page body becomes data-driven.

## Suggested adjustments

- Collapse or relabel `Quick say` and the swap lane when there is no distinct quick/alternate phrase, and reuse that space for the first meaningful module group instead.
- Normalize preview-module copy by stripping repetitive scaffolding, preferring concrete phrase text from `phrase-source.csv`, and using relation reasons only where they improve traveler-facing labeling.
- Make `Break it down` class-specific instead of forcing one fixed phrase-gloss treatment across every hub.
- Include search, suggested, and browse updates in the implementation plan so repair and service/navigation hubs are discoverable, not just renderable.
