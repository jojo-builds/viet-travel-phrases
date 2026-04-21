# Germany Holdout Decision

## Row reviewed

- `german-coffee-shop-4`
- English intent: `Just a little ice`

## Decision

- Do not force a Germany-first rewrite.
- Convert the row from `deferred-rewrite-needed` to `deferred-native-review`.

## Why

- The lane already covers the stronger Germany cafe utility rows: standard coffee orders, black coffee, cappuccino, no sugar, takeaway, and payment.
- A direct less-ice customization request is still a weak Germany-first traveler need compared with those already-cleared rows.
- The exact wording depends on real drink context and local ordering norms enough that a synthetic rewrite would be lower-trust than an explicit handoff.

## Lane effect

- The Germany lane now has `69` resolved rows plus `1` explicit native-review handoff instead of a vague rewrite holdout.
- The residual posture is cleaner and more honest because the row no longer pretends to be waiting on a rewrite that this task cannot justify.
