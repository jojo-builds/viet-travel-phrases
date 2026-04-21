# Italian Source Notes

Current reality:

- This lane is prep-only and is not wired into the runtime app registry yet.
- The shared traveler baseline remains the structural starting point, but Italy-specific prioritization is now documented.
- `first-wave-priority.csv` is the working queue for the next translation task.

## Authoring stance

- Default to polite everyday standard Italian for service encounters.
- Keep `target_text` in natural Italian spelling for show-screen usefulness.
- Use `pronunciation` as traveler-friendly support, not as a substitute for real Italian text.
- Keep phrases short and service-usable rather than textbook-complete.
- Prefer language that works in hotels, transport, cafes, and shops before lighter conversation filler.

## Phrase selection adjustments for Italy

- Keep the shared 10 scenarios, but bias authoring toward reservations, transport, payment, directions, and repair phrases.
- Treat `asking-price` as price confirmation and item selection language, not a bargaining-heavy scenario.
- Keep `small-talk` as low priority for the first wave.
- Keep medical, police, lost-passport, and ingredient-risk content behind explicit expert-review flags.

## Scaffold lines likely to need rewriting before direct translation

- coffee-specific lines such as `One iced milk coffee please`, `I would like an iced black coffee`, and `I would like an iced latte`, which fit the current baseline more than a first Italy pack
- bargaining-oriented lines such as `Can you lower it a little` and `What is your final price`
- any direction line that should point to a station, platform, or landmark instead of generic `city center` wording
- any line whose safest Italian phrasing needs a softer request form rather than a literal transfer

## Pronunciation / search posture notes

- Traveler-facing pronunciation should stay ASCII-friendly and compact.
- Add pronunciation help where doubled consonants, stress, `gli`, `gn`, `chi/che`, or `ci/ce` could trip up English speakers.
- English-intent retrieval should remain the primary search assumption.
- Preserve real Italian spelling on cards even if later search helpers normalize accents or punctuation.

## Current graduation-boundary handoff

- Treat the lane as effectively translation-complete for the current prep scope, not runtime-ready.
- Keep `italian-asking-price-4` as a later-only bargaining hold. Reason: discount-seeking remains weak Italy-first utility for this lane. Next owner: product plus localization review if a market-style shopping variant is ever needed.
- Keep `italian-coffee-shop-4` as the one rewrite-needed cafe-fit hold. Reason: ice customization still is not a strong Italy-first coffee-bar intent. Next owner: source rewrite or future cafe-fit content pass.
- Keep `italian-simple-problems-6` expert-review gated and keep `italian-small-talk-1` through `italian-small-talk-7` translated but non-promotable pending native register review.
- Continue pronunciation, audio, search/localization, and validation planning before any runtime wiring discussion.

## T-014 first-wave translation decisions

- The top `24` first-wave rows now have explicit row-level dispositions in `first-wave-priority.csv`; the top `20` were translated, and rows `21-24` were translated as medium-priority follow-ons.
- `italian-polite-basics-5` was rewritten from the merged English gloss `Excuse me sorry` to a narrower `Excuse me` decision so `Scusi.` can stay service-safe instead of awkwardly mixing apology and attention-getting.
- `italian-coffee-shop-6` was rewritten from generic `To go` to `To take away` before translation so `Da asporto, per favore.` reflects an Italy-fit takeaway request.
- `italian-simple-problems-1` now uses `Non trovo la strada.` so the traveler gets a directly usable gender-neutral repair line in a pressure moment.
- `italian-simple-problems-6` is translated but still treated as medically sensitive; keep the expert-review expectation visible in later passes.
- `italian-coffee-shop-4` remains rewrite-needed because ice customization is still a weak Italy-first coffee-bar intent.
- `italian-asking-price-4` stays outside the active prep closure because bargaining is still a weak Italy-first shopping intent.

## T-030 second-pass translation decisions

- The lane now carries `45` ranked rows in `first-wave-priority.csv`, and the ranked unresolved holdouts from `T-014` were either translated or consciously deferred with explicit reasons.
- `italian-coffee-shop-1` through `italian-coffee-shop-3` were rewritten into `A coffee, please`, `An Americano, please`, and `A cappuccino, please` before translation so the coffee scenario reflects Italy-first orders instead of iced-drink leftovers.
- `italian-directions-1` was rewritten into `How do I get to the station?` and `italian-asking-price-5` was rewritten into `What is the total price?` before translation to keep the next-wave batch grounded in stronger travel intent.
- `italian-asking-price-4` remains deliberately deferred as a bargaining-heavy row, and `italian-coffee-shop-4` remains deferred because ice customization is still a weak Italy-first coffee-bar intent.
- The second pass also widened practical support coverage across hotel room issues, cafe payment, store help, directions follow-ups, forgotten-item repair, and Wi-Fi trouble without touching runtime wiring.

## T-111 residual-tail cleanup decisions

- The lane now carries `53` ranked rows in `first-wave-priority.csv`, resolves `68` of the `70` phrase rows, and leaves only `italian-coffee-shop-4` plus `italian-asking-price-4` as explicit deferred holdouts.
- `italian-street-food-4` is now translated as `Un po' più di erbe, per favore.` so the garnish row no longer sits as an open practical holdout.
- `italian-small-talk-1`, `italian-small-talk-2`, `italian-small-talk-4`, `italian-small-talk-5`, `italian-small-talk-6`, and `italian-small-talk-7` are now translated as low-pressure social cleanup rows rather than staying in a fuzzy pending tail.
- `italian-small-talk-7` now uses the polite `Come sta?` form so the social tail stays service-safe with strangers and staff.
- Keep the translated social rows closed for now unless a later native review wants to tune warmth or register; do not reopen them as live translation debt.

## T-118 graduation-boundary decisions

- The lane now has no ambiguous translation tail: `68` rows are resolved, `italian-asking-price-4` is an explicit later-only hold, and `italian-coffee-shop-4` is an explicit rewrite-needed hold.
- `italian-asking-price-4` is parked as a later-only bargaining hold rather than a rewrite blocker. Keep it outside any starter or near-graduation packet unless product plus localization review later proves that an Italy-market bargaining row is worth carrying.
- `italian-coffee-shop-4` remains rewrite-needed because the current ice-customization intent is still weak for an Italy-first coffee-bar pack. Do not reopen it until a stronger cafe-fit rewrite exists.
- `italian-simple-problems-6` stays expert-review gated, and `italian-small-talk-1` through `italian-small-talk-7` stay translated but non-promotable until native register review lands.
- Future runtime planning should treat Italy as prep-complete for translation scope but not runtime-ready because pronunciation coverage, audio posture, search/localization planning, validation planning, and later review holds are still open.
