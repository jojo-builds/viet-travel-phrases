# French Source Notes

Current reality:

- This lane is still prep-only and is not wired into the runtime app registry.
- The shared traveler baseline remains the structural starting point, but France-specific prioritization is now documented and translated through rank `62`.
- The old `8`-row residual handoff is now one explicit graduation-boundary packet instead of a fuzzy next-pass tail.
- `phrase-source.csv` and `first-wave-priority.csv` now agree on the packet split:
  - later-only social holds: `french-small-talk-1` through `french-small-talk-6`
  - native-review-only social hold: `french-small-talk-7`
  - retired weak-fit cafe row: `french-coffee-shop-4`

## Authoring stance

- Default to France-focused polite everyday French for service encounters.
- Treat `vous`-safe wording as the default until a later task proves a narrower casual need.
- Keep `target_text` in natural French spelling with accents and apostrophes for show-screen usefulness.
- Use `pronunciation` as compact ASCII-friendly support, not as a substitute for real French text.
- Keep phrases short, greeting-aware, and service-usable rather than textbook-complete.
- When a row can stay neutral without choosing a pronoun, that is acceptable; when it directly addresses staff, a driver, or a front desk, keep the later French `vous`-safe.
- Softer service variants are allowed only when they reduce bluntness without turning the row into a classroom sentence.

## Phrase selection adjustments for France

- Keep the shared 10 scenarios, but bias authoring toward greetings, repair phrases, reservation handling, metro or station navigation, payment, bill requests, and simple cafe or bakery ordering.
- Treat `street-food` as cafe, brasserie, takeaway, and casual restaurant language rather than literal street-food-only coverage.
- Treat `asking-price` as price confirmation and item choice, not a bargaining-heavy scenario.
- Treat `small-talk` as low priority for the first France closure packet.
- Keep medical, police, lost-passport, and ingredient-risk content behind explicit expert-review flags.

## Graduation-boundary packet

- Later-only social holds:
  - `french-small-talk-1`
  - `french-small-talk-2`
  - `french-small-talk-3`
  - `french-small-talk-4`
  - `french-small-talk-5`
  - `french-small-talk-6`
  - reason: these rows are visible backlog only and remain outside the practical France traveler pack unless product later asks for a hospitality or friendliness expansion
  - next owner: future hospitality and small-talk expansion pass after native-review and runtime blockers are better understood
- Native-review-only social hold:
  - `french-small-talk-7`
  - reason: English wellness small talk still does not map cleanly to high-value France travel utility and should not be forced into the lane without native guidance
  - next owner: native French register review if later product scope decides the row is still worth carrying
- Retired weak-fit cafe row:
  - `french-coffee-shop-4`
  - reason: a less-ice customization row is still a weak France-first cafe intent and no longer deserves live rewrite debt in this lane
  - reopen rule: only reintroduce this slot if a future cafe-fit source rewrite replaces the current English prompt with a stronger France-first ordering or customization row

## Review-sensitive rows that remain explicit

- `simple-problems-6` stays expert-review medical from the start.
- `hotel-hostel-4` and `hotel-hostel-5` now have second-wave translations but still stay room-problem review because complaint tone can drift quickly in French.
- `grab-taxi-2`, `grab-taxi-4`, `grab-taxi-6`, `grab-taxi-7`, and the `directions-*` platform or line rows now have second-wave translations but still stay transit, payment, or service review so routing phrasing does not become unnaturally blunt.
- `asking-price-4` stays shopping-tone review even after translation so comparison wording does not slide back into bargaining tone.
- `coffee-shop-7` and `convenience-store-7` stay bill or service wording review because checkout phrasing should stay natural and brief.
- The packet above is the honest France release posture: do not reopen already resolved rows unless later native or expert review changes the recommendation.

## Pronunciation and search posture notes

- Traveler-facing pronunciation should stay ASCII-friendly and compact.
- Use one normalization rule for this lane: lowercase ASCII only, remove accents, render apostrophes as spaces, keep ordinary word spacing, and skip liaison or silent-letter micro-marking.
- Keep the helper short enough to support read-aloud use by an English speaker without trying to encode every French sound precisely.
- Add pronunciation help where French spelling would likely mislead English speakers in high-pressure moments.
- English-intent retrieval should remain the primary search assumption.
- Pronunciation must not become a surrogate search field or a replacement for `target_text`.
- Future runtime search should accept accentless lookup only as a helper while keeping full French spelling visible on cards.
- Keep likely traveler aliases visible during drafting for `bill`, `payment`, `card`, `station`, `platform`, `reservation`, `receipt`, `luggage`, `charger`, `takeaway`, `doctor`, and `bathroom`.

## Starter-pack posture

- The first France starter pack no longer stops at the top `30`; the ranked practical block through `62` is now translated.
- Keep greetings, repair phrases, reservation handling, station help, payment, bill requests, and water or cafe basics ahead of small talk and weak-fit customization.
- Keep every candidate starter row paired with a row-level `review_flag`, plus `status` in `phrase-source.csv` and `execution_status` in `first-wave-priority.csv`, so the explicit packet remains visible instead of slipping back into implied debt.

## Next content pass should

- treat the translation backlog as functionally closed for the current France prep scope
- keep `french-small-talk-1` through `french-small-talk-6` closed as later-only social holds until a future hospitality expansion explicitly reopens them
- keep `french-small-talk-7` as the one native-review-only social hold unless native review later proves a France-fit version belongs
- keep `french-coffee-shop-4` retired from the lane unless a future cafe-fit source rewrite explicitly replaces it
- preserve review-visible caution on medical, room-problem, platform, shopping-tone, payment, and service-wording rows
- decide the honest short-term audio posture before runtime wiring
