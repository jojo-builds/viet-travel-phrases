# Traveler Utility Review

Decision: APPROVE

Conditions:
- Keep the rewrite pass strictly inside the `16` promoted-core rows for direct authoring.
- Leave the `6` holdouts and `2` deferred rewrites visible for sequencing context, but clearly outside the authoring-ready pack.
- Apply the planned reorder so the first traveler-need slice starts with repair, transport control, price, water, food comfort, and near-here / walking help before courtesy anchors and lower-leverage shopping lines.
- Ensure `quickPhraseIds` contains only promoted-core rows after the scenario-plan update.
- Make `phrase-source.csv` the row-level filter source of truth and keep its status labels aligned with `first-wave-priority.csv`.
- Use `README.md` to make the workflow between `README`, `source-notes`, `first-wave-priority`, `phrase-source`, and `rewrite-notes` explicit.

Why:
- This contract resolves the main traveler-utility weaknesses from pass 01: the pack is narrowed, the order is more useful under real travel friction, and the quick set no longer depends on deferred material.
- The source-of-truth contract is now strong enough for a bounded rewrite pass without reopening shortlist sprawl.
- No further narrowing is needed before editing; execution discipline is the remaining requirement.
