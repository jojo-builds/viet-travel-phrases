# Japanese Source Notes

Current reality:

- This lane is still prep-only and is not wired into the runtime app registry.
- The shared traveler baseline remains the structural starting point, but the Japan lane is no longer a live translation queue.
- `content-draft/japanese/first-wave-priority.csv` now carries the authoritative `final_outcome` ledger for the graduation packet.
- Future planning should use this file plus `.agent/tasks/T-122/logs/japan-graduation-packet.md` instead of reopening `T-101`.

## Authoring stance

- Default to polite everyday service Japanese.
- Prefer safe set phrases and `desu/masu` posture over casual or plain-form translations.
- Keep `target_text` in natural Japanese script for show-screen usefulness.
- Use `pronunciation` as traveler-friendly romaji support, not as a substitute for script.
- Keep kana-reading notes where kanji pronunciation would otherwise be unclear to first-time travelers.

## Phrase selection adjustments for Japan

- Keep the shared 10 scenarios, but bias authoring toward station navigation, convenience-store checkout, hotel desks, cafes, and screen-showable repair phrases.
- Treat `asking-price` as price confirmation and item-selection language, not a bargaining-heavy scenario.
- Treat `small-talk` as low priority and out-of-scope for the current graduation packet unless a future hospitality expansion is explicitly requested.
- Keep medical, police, lost-passport, and allergy content behind explicit expert-review flags.

## Graduation-boundary packet

- Promoted graduation set:
  - `34` rows
  - use this as the honest Japan starter and prep-handoff set
  - practical coverage now includes opener and repair phrases, station and taxi navigation, hotel arrival, convenience-store checkout, bounded shopping, cafe payment, Wi-Fi repair, and core courtesy lines
- Later-only rows:
  - `japanese-asking-price-2`
  - `japanese-asking-price-3`
  - `japanese-small-talk-3`
  - `japanese-small-talk-5`
  - reason: these rows are usable drafted content, but they do not outrank the service-first promoted set and should only reopen after the practical handoff is stable
  - next owner: future shopping-tone or light-social follow-on after native review and runtime blockers are clearer
- Native-review-only row:
  - `japanese-simple-problems-6`
  - reason: the short medical line is useful, but it should not be promoted or relied on without expert medical review
  - next owner: expert or medically informed Japanese review
- Rewrite-needed rows:
  - `japanese-street-food-4`
  - `japanese-grab-taxi-2`
  - `japanese-asking-price-5`
  - reason: garnish requests, generic city-center routing, and final-price bargaining still point at weak Japan-first intents
  - reopen rule: do not translate or promote these until the English source text is rewritten toward a stronger Japan-natural traveler use
- Retired rows:
  - `japanese-small-talk-1`
  - `japanese-small-talk-2`
  - `japanese-small-talk-4`
  - `japanese-small-talk-6`
  - `japanese-small-talk-7`
  - reason: origin answers, generic positive chatter, weather talk, and direct wellness small talk do not justify live graduation debt for the current Japan lane
  - reopen rule: only revive these if product explicitly asks for a hospitality or friendliness expansion

## Review-sensitive rows that remain explicit

- `japanese-simple-problems-6` stays `native-review-only` until expert medical review lands.
- `japanese-simple-problems-7` and `japanese-hotel-hostel-7` stay promoted, but later native feedback may still soften register or hotel-desk phrasing.
- `japanese-street-food-3` stays promoted with food-review caution rather than being treated as fully unconstrained.
- The rewrite-needed trio stays outside promotion even though the broader lane is otherwise translation-complete.

## Pronunciation and search posture notes

- Traveler-facing romaji should stay ASCII-friendly and broadly Hepburn-like.
- Do not over-promise that romaji alone is enough for accurate speaking.
- English-intent retrieval should remain the primary search assumption.
- Non-Latin runtime search should be treated as a later localization gate, not inherited automatically from Viet and Tagalog.

## Next content pass should

- treat the translation queue as closed for the current Japan prep scope
- preserve the `34` promoted rows as the active handoff surface
- keep the `4` later-only rows visible but non-promoted
- keep the one medical row isolated as `native-review-only`
- keep the `3` rewrite-needed rows blocked until stronger Japan-fit source text exists
- keep the `5` retired rows out of graduation planning unless product explicitly broadens social coverage
