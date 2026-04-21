# Turkish Utility Audit

## Scope executed

- Completed the bounded Turkish utility pass in `content-draft/turkish/**`.
- Updated the Turkish lane docs, ranked queue, and phrase ledger together so the new row outcomes stay synchronized.
- Kept the work prep-only with no runtime, app, site, ops, or release-surface edits.

## Row decisions

### Newly translated in this pass

- `turkish-grab-taxi-2`
- `turkish-grab-taxi-6`
- `turkish-directions-4`
- `turkish-directions-5`
- `turkish-street-food-2`
- `turkish-street-food-4`
- `turkish-polite-basics-3`
- `turkish-polite-basics-6`
- `turkish-convenience-store-4`

### Tightened but still flagged

- `turkish-street-food-3`
- `turkish-asking-price-5`
- `turkish-asking-price-4`
- `turkish-simple-problems-7`
- `turkish-simple-problems-6`

### Explicitly deferred

- `turkish-street-food-6` because the source should be rewritten toward a Turkey-natural utensil request before translation

## Residual queue after this pass

- Remaining `needs-translation` rows: `12`
- Remaining `needs-translation` ids:
  - `turkish-coffee-shop-1`
  - `turkish-coffee-shop-2`
  - `turkish-coffee-shop-3`
  - `turkish-coffee-shop-4`
  - `turkish-asking-price-2`
  - `turkish-asking-price-3`
  - `turkish-small-talk-1`
  - `turkish-small-talk-2`
  - `turkish-small-talk-4`
  - `turkish-small-talk-5`
  - `turkish-small-talk-6`
  - `turkish-small-talk-7`

## Validation

- `phrase-source.csv` parses with `Import-Csv`.
- `first-wave-priority.csv` parses with `Import-Csv`.
- Post-pass status counts:
  - `translated-draft`: `50`
  - `translated-draft-contextual-only`: `2`
  - `translated-draft-needs-localization-check`: `2`
  - `translated-draft-needs-expert-review`: `1`
  - `deferred-lower-priority`: `1`
  - `deferred-rewrite-needed`: `2`
  - `needs-translation`: `12`
- `git status` could not be used for changed-file verification because the repo resolves through the `E:/AI/Viet-Travel-Phrases` compatibility alias and hits Git's dubious ownership safe-directory guard in this environment.
