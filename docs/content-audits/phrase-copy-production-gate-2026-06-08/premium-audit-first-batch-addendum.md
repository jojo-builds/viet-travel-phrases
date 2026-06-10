# Premium Audit First Batch Addendum

Date: 2026-06-09

This addendum records the first stricter premium-copy repair batch after the visible-copy audit introduced `HARD_REVIEW`, `WEAK_REVIEW`, `WATCH`, and `PASS` scoring.

## Result

- repaired page IDs checked: `10`
- rendered `PASS 0`: `8`
- rendered `WATCH`: `2`
- rendered `HARD_REVIEW`: `0`
- rendered `WEAK_REVIEW`: `0`
- phrase-card removals: `0`
- breakdown-card removals: `0`

The two remaining `WATCH` rows are `viet-phrase-v500-hote-acco-can-i-pay-now` and `viet-phrase-v500-hote-acco-can-i-have-more-soap`; both are watch-only because their hotel desk response lines repeat across other hotel pages, not because the individual pages lost specificity or cards.

## Repaired Pages

- `viet-phrase-v500-tran-can-i-put-my-bag-here`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-have-an-extra-bed`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-see-the-room-first`: `PASS 0`
- `viet-phrase-v900-tran-can-you-help-me-contact-the-company`: `PASS 0`
- `viet-phrase-v500-hote-acco-can-i-pay-now`: `WATCH 7`
- `viet-phrase-v900-hote-acco-can-i-have-a-baby-crib`: `PASS 0`
- `viet-phrase-v900-tran-where-is-the-boat-pier`: `PASS 0`
- `viet-phrase-v900-tran-are-we-going-the-right-way`: `PASS 0`
- `viet-phrase-v900-tran-please-take-me-to-this-address`: `PASS 0`
- `viet-phrase-v500-hote-acco-can-i-have-more-soap`: `WATCH 7`

## Anti-Thinning Notes

The repair edited visible source copy only. It did not remove phrase cards, related/explore cards, or breakdown strips.

Representative rendered preservation after regeneration:

- `viet-phrase-v900-hote-acco-can-i-have-an-extra-bed`: `9` phrase cards, `7` breakdown rows
- `viet-phrase-v900-hote-acco-can-i-see-the-room-first`: `9` phrase cards, `7` breakdown rows
- `viet-phrase-v900-tran-can-you-help-me-contact-the-company`: `9` phrase cards, `9` breakdown rows
- `viet-phrase-v500-hote-acco-can-i-pay-now`: `9` phrase cards, `6` breakdown rows
- `viet-phrase-v900-hote-acco-can-i-have-a-baby-crib`: `9` phrase cards, `7` breakdown rows
- `viet-phrase-v500-hote-acco-can-i-have-more-soap`: `9` phrase cards, `7` breakdown rows

## Copy Lesson

The right production fix is source authoring, not validator thinning. Pages improved when formula-triggering source lines such as `Use this when...`, `Keep [Vietnamese]...`, or `The reply may be...` were replaced with concrete traveler moments, while the existing phrase-card graph stayed intact.
