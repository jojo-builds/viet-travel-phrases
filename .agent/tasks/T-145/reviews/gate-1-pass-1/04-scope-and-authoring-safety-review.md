# Gate 1 Pass 1: Scope and Authoring Safety Review

Approval: BLOCK

## Summary

The task remains safely scoped to the allowed Viet content/model surfaces, but the authoring contract still needs clearer boundaries before Gate 1 can pass.

## Findings

- The current notes blur the boundary between relation truth and answer-page module truth.
- The notes do not yet explicitly forbid duplicating phrase wording inside answer modules.
- The payload boundary for compact module content is still too loose.

## Suggested adjustments

- Let `relation-sample-v1.json` own cross-family and follow-up link truth.
- Let `answer-page-sample-v1.json` store phrase ids, relation references, and short instructional copy only.
- Keep `phrase-source.csv` note edits limited to trace markers for enriched hubs.
