# Germany Residual-Tail Audit

## Scope
- task: `T-084`
- lane: `content-draft/german`
- goal: reduce the explicit Germany residual tail without claiming runtime graduation

## Starting point
- `phrase-source.csv` had `13` unresolved rows: `12` `pending-later` plus `1` `deferred-rewrite-needed`
- the open set was `german-street-food-4`, `german-polite-basics-1/3/6/7`, `german-small-talk-1/2/3/4/5/6/7`, and `german-coffee-shop-4`

## Rows cleared in this pass
- `german-street-food-4`
- `german-polite-basics-1`
- `german-polite-basics-3`
- `german-polite-basics-6`
- `german-polite-basics-7`
- `german-small-talk-1`
- `german-small-talk-2`
- `german-small-talk-3`
- `german-small-talk-4`
- `german-small-talk-5`
- `german-small-talk-6`
- `german-small-talk-7`

## Remaining holdout
- `german-coffee-shop-4`
  - still deferred because "Just a little ice" remains a weak Germany-first cafe intent and did not justify a forced rewrite

## Expected post-pass state
- `phrase-source.csv`: `69` rows with non-empty `target_text`, `1` explicit holdout
- `first-wave-priority.csv`: `12` rows moved from `pending-later` to `translated-third-pass`
- lane posture: prep-only, near-complete, and still review-visible on medical, transit, ride-guidance, and service-sensitive wording

