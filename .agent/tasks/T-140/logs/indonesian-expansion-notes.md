# T-140 Indonesian Expansion Notes

## Starting point

- The lane began as an `82`-row prep packet with `67` ranked resolved outcomes.
- The unresolved tail still included softer bargaining, generic directions filler, a duplicate convenience-store payment row, the medical line, and the full small-talk cluster.
- The task goal was to land a materially larger Indonesia-fit packet without touching runtime wiring.

## What changed

- Expanded `content-draft/indonesian/phrase-source.csv` from `82` rows to `115` rows.
- Landed exactly `48` new or newly-resolved outcomes:
  - `33` brand-new rows
  - `15` previously unresolved rows now rewritten and translated
- Expanded `content-draft/indonesian/first-wave-priority.csv` from `67` ranked outcomes to `115`.
- Updated prep handoff docs so the written lane truth matches the new packet:
  - `content-draft/indonesian/README.md`
  - `content-draft/indonesian/source-notes.md`
  - `content-draft/indonesian/research-backlog.md`
  - `docs/LANGUAGE_PREP_WORKFLOW.md`

## Coverage added

- Ride-hailing pickup and ferry flow:
  - `I cannot find the car`
  - `I am at the main entrance`
  - `Please come to this pickup point`
  - `This is the wrong pickup point`
  - `What is your license plate number?`
  - `Please drop me at the ferry terminal`
  - `I already paid in the app`
- Payment and purchase follow-through:
  - softer bargaining
  - tax included
  - service included
  - change
  - nearby ATM
  - phone-credit top-up
- Hotel and recovery support:
  - shower not working
  - no hot water
  - room key does not work
  - late checkout
  - pharmacy lookup
  - diarrhea medicine
  - oralit
  - bandages
  - `I feel sick`
  - `My stomach hurts`
  - translated but expert-gated `I need a doctor`
- Food adjustments:
  - no meat
  - no peanuts
  - no egg
  - vegetarian
  - halal
  - cannot eat seafood
- Tail resolution:
  - rewrote weak directions rows toward ferry terminal, station, gate, pier, ticket counter, and boat-line support
  - translated all seven small-talk rows while keeping them low priority

## Final packet shape

- `asking-price`: `14`
- `coffee-shop`: `9`
- `convenience-store`: `13`
- `directions`: `9`
- `grab-taxi`: `16`
- `hotel-hostel`: `11`
- `polite-basics`: `10`
- `simple-problems`: `13`
- `small-talk`: `7`
- `street-food`: `13`

## Validation facts

- `phrase-source.csv`: `115` rows, `0` blank `target_text` values, `0` duplicate `phrase_id` values
- `first-wave-priority.csv`: `115` rows, rank range `1-115`, `0` duplicate ranks
- Changed-file scope stayed inside:
  - `content-draft/indonesian/*`
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
- `npx --no-install tsc --noEmit` from `app/` returned the TypeScript stub message because the compiler is not installed in this worktree environment
