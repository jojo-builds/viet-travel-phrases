## Summary
- The French prep lane is tight enough for the next authoring pass.
- The scaffold is concrete: 70 source rows, a ranked 30-row first wave, France-specific register guidance, and row-level review flags on the sensitive items.
- The language-risk posture is now specific enough to guide translation rather than just warn about it.

## Checks
- `README.md` and `source-notes.md` agree on polite, `vous`-safe traveler-facing French and on keeping the lane prep-only.
- `scenario-plan.json` preserves the shared 10-scenario seam while biasing toward France-appropriate utility.
- `phrase-source.csv` has the row-level rewrite decisions staged, with blank `target_text` and `pronunciation` intentionally reserved.
- `first-wave-priority.csv` is ranked, concrete, and separates first-wave rows from deferred and rewrite-needed rows.

## Risks
- Pronunciation is still unresolved by design, so the next pass still needs one consistent ASCII helper rule before that column is filled.
- A few rows remain intentionally review-flagged for medical, bill, transit, service-wording, and room-problem risk, but those flags are specific enough for handoff.
- `coffee-shop-4` still needs rewrite or retirement before translation, so it should stay out of the starter wave.

## Approval
- The language-risk and localization-risk posture is sufficiently tight for the next authoring pass.

Approval: APPROVE
