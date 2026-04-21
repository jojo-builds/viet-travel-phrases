# Turkish Source Notes

## Current reality

- This lane is still prep-only and is not wired into the runtime app registry.
- Use this file plus `.agent/tasks/T-121/logs/turkish-graduation-packet.md` as the retrieval surface for the Turkish closure packet instead of reopening `T-104`.
- The practical coffee and shopping tail is already closed.
- The current lane snapshot has `56` promoted prep rows and `14` deliberately unpromoted residual rows.

## Outcome mapping for this lane

- `translated-draft` = promote
- `translated-draft-contextual-only` = later-only
- `translated-draft-needs-localization-check` = native-review-only
- `translated-draft-needs-expert-review` = native-review-only until expert review lands
- `deferred-lower-priority` = later-only
- `deferred-rewrite-needed` = rewrite-needed
- retire = none in the current packet

## Graduation-boundary packet

### Promote: `56` rows

- Treat the `56` `translated-draft` rows as the effective Turkish starter-utility prep set.
- This promoted set includes the coffee-shop and shopping rows closed in `T-104`:
  - `turkish-coffee-shop-1`
  - `turkish-coffee-shop-2`
  - `turkish-coffee-shop-3`
  - `turkish-coffee-shop-4`
  - `turkish-asking-price-2`
  - `turkish-asking-price-3`
- Future planning should not reopen this promoted set unless a specific phrase regresses or a new lane-wide standard is introduced.

### Later-only: `9` rows

- `turkish-asking-price-4`
- `turkish-asking-price-5`
- `turkish-small-talk-1`
- `turkish-small-talk-2`
- `turkish-small-talk-3`
- `turkish-small-talk-4`
- `turkish-small-talk-5`
- `turkish-small-talk-6`
- `turkish-small-talk-7`
- Keep the bargaining pair translated for context-limited bazaar use, but outside the default starter-core slice.
- Keep all `7` social rows parked until product explicitly asks for a hospitality or friendliness expansion.

### Native-review-only: `3` rows

- `turkish-street-food-3`: keep visible for no-spice utility, but do not treat as promoted until native Turkish food-context review lands.
- `turkish-simple-problems-7`: keep visible for service repair, but do not treat as promoted until native register review lands.
- `turkish-simple-problems-6`: keep visible because traveler utility is high, but do not treat as promoted until medically informed review lands.

### Rewrite-needed: `2` rows

- `turkish-directions-1`: rewrite toward a Turkey-natural landmark, ferry, metro, or station target before translation.
- `turkish-street-food-6`: rewrite away from chopsticks toward a Turkey-natural utensil or napkin request before translation.

### Retire: `0` rows

- No current Turkish residual row needs retirement; the remaining unpromoted set still has a clear future owner.

## Boundary rules for future pickup

- Do not reopen the later-only social bucket until product asks for a hospitality and friendliness expansion.
- Do not promote the bargaining pair into default starter-core guidance without an explicit product call.
- Keep the food-fit, service-register, and medical rows visible but unpromoted until the named review types land.
- Rewrite the `2` source-fit rows before any translation attempt.

## Draft posture still open

### Register

- Prefer polite question forms with `lütfen` in taxi, shop, and staff-facing asks.
- Keep the bargaining rows visible but explicitly non-core.
- Preserve softer service wording for `turkish-simple-problems-7` without pretending the phrasing is locally final.

### Pronunciation

- Pronunciation remains helper-only draft truth.
- This pass still does not freeze a final house standard for stress, dotted vs dotless `i`, or `ğ`.
- Dotless `ı`, `ş`, `ç`, and rounded vowels still need cleaner lane-wide guidance before runtime promotion.

### Search and script posture

- Keep full Turkish orthography in `target_text`.
- Do not flatten dotted and dotless `i` in authored content.
- Later search work can add ASCII helper aliases without replacing real Turkish spelling.
