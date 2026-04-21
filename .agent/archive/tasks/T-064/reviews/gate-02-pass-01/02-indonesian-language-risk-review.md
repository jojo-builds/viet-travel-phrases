# Gate 2 Indonesian Language Risk Review

- reviewer: Chandrasekhar (`019da7c0-6aae-7701-a486-ab8868068366`)
Approval: APPROVE
- scope: completed Indonesian scaffold package

## Findings

- No blocking language-risk issue remains in the completed scaffold package. The lane stays standard-first, prep-only, and explicitly keeps colloquial Indonesian alias-only rather than promoting slang into the visible starter surface.
- Politeness posture is appropriately conservative: `Anda` stays non-default, `permisi` versus `maaf` remains visibly unresolved, and regional address terms are still held back for later review instead of being flattened into universal guidance.
- Pronunciation and search posture stays honest: pronunciation is still deferred to light helper coverage only, and colloquial search alias handling is explicitly future work rather than implied complete now.
- Sensitive rows remain visibly flagged across the package: food risk, ride-hailing transport friction, QR, card, and cash payment clarification, and medical language all stay review-marked, and `I need a doctor` remains an explicit expert-review holdout in the scaffold.

## Recommended edits

- Optional only: when the translation pass starts, mirror the shortlist review signals into especially sensitive `phrase-source.csv` notes where that would improve row-level durability.
- Keep QR and payment wording generic and honest unless a later native review clearly justifies stronger QRIS-specific visible phrasing.
- Preserve the current separation between standard target text and colloquial alias handling.
