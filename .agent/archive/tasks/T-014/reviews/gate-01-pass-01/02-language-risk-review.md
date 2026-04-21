Decision: APPROVE

Rationale:
- The current Italian prep lane already captures the main language-risk controls needed before translation starts: explicit rewrite-before-translation rows for weak Italy-fit baseline English, a polite everyday standard Italian default for service encounters, an honest pronunciation posture that keeps real Italian spelling visible, and explicit expert-review flags for sensitive medical and ingredient-risk language.
- The first-wave shortlist also avoids the worst risk pattern here, which would be treating literal transfer as equal to useful traveler language. Bargaining-heavy rows and several iced-coffee rows are already marked for rewrite rather than early direct translation, and `I need a doctor` is prioritized with an `expert-review-medical` flag instead of being presented as fully solved.

Concrete risks:
- `Excuse me sorry` is correctly flagged for politeness review, but it still risks being translated into an over-apologetic or awkward combined form if the pass does not choose one clear Italian service-safe default for attention-getting versus apology.
- The coffee rows remain risky if the translation pass preserves baseline beverage assumptions that fit the shared scaffold better than Italy-first traveler behavior.
- Pronunciation can become misleading if it pretends to fully encode Italian stress or consonant timing; compact support is appropriate, but false precision would be worse than partial help.
- Medical wording is only partly protected right now. `I need a doctor` is flagged, but the same caution must carry into related illness, pharmacy, allergy, and ingredient-risk rows once they enter the pass, or the lane will look safer than it is.

Concrete adjustments:
- Keep `italian-polite-basics-5` as a deliberate register choice in the pass notes: separate “get attention politely” from “I am sorry” if one combined English gloss produces awkward Italian.
- Treat the flagged bargaining and iced-coffee rows as rewrite-or-defer rows, not quota-filler for first-wave completion.
- Keep pronunciation ASCII-friendly and selective: add help only where it materially prevents misuse, and do not imply native-like accuracy.
- Preserve or expand explicit review notes on medical and ingredient-sensitive rows whenever they are translated, so the lane does not silently graduate those phrases from “needs expert review” to “ready”.
