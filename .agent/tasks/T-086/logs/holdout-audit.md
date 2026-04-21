# Indonesian Holdout Audit

## Starting point

- Claimed state already reflected a translated `65`-row queue plus a `17`-row unresolved tail.
- The unresolved tail consisted of:
  - `asking-price-3`
  - `convenience-store-4`
  - `convenience-store-6`
  - `directions-1`
  - `directions-4`
  - `directions-5`
  - `directions-6`
  - `directions-7`
  - `directions-8`
  - `simple-problems-6`
  - `small-talk-1` through `small-talk-7`

## Cleared in this pass

- `indonesian-convenience-store-4`
  - English: `Where is the sunscreen`
  - Indonesian: `Di mana tabir surya?`
  - Reason: practical mini-mart or pharmacy lookup with clearer utility than the remaining filler tail
- `indonesian-directions-8`
  - English: `Where is the port?`
  - Indonesian: `Di mana pelabuhannya?`
  - Reason: useful Indonesia-fit ferry or harbor lookup that does not require reopening the broader turn-by-turn direction filler

## Deferred intentionally

- `indonesian-asking-price-3`
  - harder bargaining posture still needs a rewrite decision
- `indonesian-convenience-store-6`
  - duplicate of card-payment coverage already present in the shared payment cluster
- `indonesian-directions-1`
  - generic city-center routing still needs a stronger destination-specific rewrite
- `indonesian-directions-4` through `indonesian-directions-7`
  - low-fit turn-by-turn filler remains less useful than pinned-destination and route-repair language
- `indonesian-simple-problems-6`
  - medical wording remains expert-review-needed
- `indonesian-small-talk-1` through `indonesian-small-talk-7`
  - still lower-utility filler compared with the cleared practical travel set

## Result

- The translated ranked queue moved from `65` to `67` rows.
- The residual unresolved tail dropped from `17` rows to `15` rows.
- The remaining tail is now more explicit: bargaining, generic direction filler, duplicate payment coverage, one medical holdout, and small talk.
