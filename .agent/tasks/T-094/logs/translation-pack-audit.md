# T-094 Translation Pack Audit

## Scope

- Updated only `content-draft/japanese/**` plus task-local review and log artifacts.
- Cleared the bounded `23`-row `needs-translation` remainder from `content-draft/japanese/phrase-source.csv`.

## Row outcomes

- Translated `19` rows into new `drafted` entries:
  - `japanese-coffee-shop-2`
  - `japanese-coffee-shop-3`
  - `japanese-coffee-shop-4`
  - `japanese-coffee-shop-7`
  - `japanese-grab-taxi-4`
  - `japanese-grab-taxi-5`
  - `japanese-grab-taxi-6`
  - `japanese-asking-price-2`
  - `japanese-asking-price-3`
  - `japanese-asking-price-7`
  - `japanese-polite-basics-6`
  - `japanese-directions-7`
  - `japanese-simple-problems-5`
  - `japanese-small-talk-1`
  - `japanese-small-talk-2`
  - `japanese-small-talk-3`
  - `japanese-small-talk-4`
  - `japanese-small-talk-5`
  - `japanese-small-talk-6`
- Deferred `4` rows explicitly instead of leaving them as raw unresolved debt:
  - `japanese-street-food-4` -> `deferred-rewrite-needed`
  - `japanese-grab-taxi-2` -> `deferred-rewrite-needed`
  - `japanese-asking-price-5` -> `deferred-rewrite-needed`
  - `japanese-small-talk-7` -> `deferred-lower-priority`

## Intent notes

- Kept the pass utility-first: cafe payment, Wi-Fi repair, taxi routing, ride comfort, and purchase commitment were prioritized ahead of weak-fit bargaining or generic destination scaffolds.
- Treated the small-talk tail as cleanup work only after the stronger travel utility rows were already covered.
- Preserved the existing medical holdout posture on `japanese-simple-problems-6`.
