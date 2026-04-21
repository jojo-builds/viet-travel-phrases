# T-081 Translation Pack Audit

## Baseline at claim

- `content-draft/spanish/phrase-source.csv` had `70` rows total.
- `17` rows were still `needs-translation`.
- `1` row was an explicit medical holdout (`first-wave-flagged-holdout`).
- `content-draft/spanish/first-wave-priority.csv` only tracked the top `30` rows.

## Work completed in this pass

- Cleared all `17` remaining `needs-translation` rows with explicit outcomes.
- Rewrote these low-fit source rows before translation:
  - `spanish-grab-taxi-2` -> `Take me to the train station`
  - `spanish-street-food-2` -> `I'll have this one`
  - `spanish-street-food-6` -> `A fork please`
- Added draft coverage for the remaining polite-basics and small-talk tail so the lane no longer needs another tiny cleanup pass.
- Extended `content-draft/spanish/first-wave-priority.csv` from `30` to `47` ranked rows to capture the resolved residual tail.
- Documented a durable pronunciation normalization rule in `content-draft/spanish/source-notes.md`.

## Resulting lane state

- `phrase-source.csv` now has:
  - `39` rows with `drafted`
  - `24` rows with `first-wave-promoted-core`
  - `6` rows with `rewritten-and-drafted`
  - `1` row with `first-wave-flagged-holdout`
- Remaining unresolved ordinary rows: `0`
- Remaining sensitive holdouts: `1` (`spanish-simple-problems-6`)

## Notes

- The task requirement to clear at least `24` unresolved outcomes was satisfied under the spec's exception because the genuinely remaining unresolved set at claim time was only `17` rows.
- This pass deliberately avoided runtime wiring and kept all changes inside `content-draft/spanish/**` plus task-local artifacts.
