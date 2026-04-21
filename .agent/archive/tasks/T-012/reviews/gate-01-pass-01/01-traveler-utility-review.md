Approval: APPROVE

Findings
- `content-draft/turkish/first-wave-priority.csv` already ranks the highest-value traveler rows around apology, thanks, taxi routing, price checks, hotel arrival, payment, and repair language.
- The first useful pass is to translate the top 24 rows, not the whole scaffold, so the lane leaves behind visible prepared-next coverage.
- The strongest traveler-value gap is still the empty `phrase-source.csv`, so the pass should focus on filling target text, pronunciation, notes, and status on the ranked first wave.

Required changes before proceed
- Translate the top 24 ranked rows in `content-draft/turkish/phrase-source.csv`.
- Rewrite weak English source only where the baseline would otherwise push an awkward Turkish phrase.
- Keep the bargaining and medical rows explicitly flagged instead of pretending they are fully settled.
