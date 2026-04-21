# Gate 1 Pass 1 Indonesian Language Risk Review

- reviewer: Chandrasekhar (`019da7c0-6aae-7701-a486-ab8868068366`)
Approval: APPROVE
- scope: untouched Indonesian lane plus planned scaffold direction

## Findings

- Politeness posture is appropriately conservative: neutral polite standard Indonesian, no clipped commands, no automatic `Anda`, and no early-core dependence on `Pak`, `Bu`, `Mas`, `Mbak`, or `Kak`.
- Standard Indonesian versus colloquial posture is honest enough to proceed: standard spelling stays the default surface, while colloquial forms remain alias or later-note material instead of core phrasebook text.
- Pronunciation and search cautions are correctly framed for a Latin-script lane, with only light helper needs plus explicit watchpoints around schwa `e`, `ng`, `ny`, and colloquial alias spread.
- Sensitive later-review areas are already visible and should stay flagged in the scaffold pass: medical or police language, allergy and religion-sensitive food wording, transport disputes, QR and payment friction, and regional address terms.

## Recommended edits

- Keep colloquial variants alias-only in the scaffold metadata unless a row is explicitly promoted later.
- Make sure the future `phrase-source.csv` notes and status fields visibly flag `tolong`, `permisi`, and `maaf` choice points, QR-payment friction, and emergency or food-risk rows.
- Preserve rewrite flags for bargaining-heavy and `city center` carryovers instead of treating them as settled starter English.
