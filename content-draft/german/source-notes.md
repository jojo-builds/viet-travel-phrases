# German Source Notes

Current reality:

- This lane is prep-only and is not wired into the runtime app registry.
- `phrase-source.csv` now carries three meaningful translated batches: the original 30-row first-wave core, a 27-row second practical pack, and a 12-row residual-tail cleanup pass.
- The old 13-row residual tail is now down to one explicit native-review handoff: `coffee-shop-4`.
- `first-wave-priority.csv` now tracks the whole ranked Germany lane through 69 translated outcomes plus the lone explicit native-review handoff instead of stopping at the old top-30 snapshot.

## Authoring stance

- Default to polite everyday standard German for service encounters.
- Keep `target_text` in natural German spelling for show-screen usefulness.
- Use `pronunciation` as traveler-friendly support, not as a substitute for real German text.
- Keep phrases short and service-usable rather than textbook-complete.
- Prefer practical hotel, transit, repair, checkout, and food-ordering lines before social filler.

## Residual-tail completion decisions

- The compact politeness sweep is now explicit through `Guten Tag`, `Ja`, `Kein Problem`, and `Auf Wiedersehen`.
- `street-food-4` is now translated as `Noch Kräuter, bitte.` so the garnish row no longer sits as a practical holdout.
- The remaining social set is now translated with simple, low-pressure wording instead of staying as an open queue.
- `How are you` uses the polite `Wie geht es Ihnen?` form to stay safe with strangers and service staff.
- `coffee-shop-4` is now parked as an explicit native-review handoff because a direct `Just a little ice` row is still a weak Germany-first cafe intent and depends too much on real drink context to force a confident rewrite.

## Rows that still carry explicit risk or caution

- The residual packet is now grouped instead of implied:
- Deferred native-review handoff: `coffee-shop-4` stays untranslated and out of active coverage unless later cafe evidence proves a stronger Germany-fit replacement.
- Runtime-blocked expert review: `simple-problems-6` stays translated for prep reference, but it must not be treated as runtime-safe until expert medical review happens.
- Keep-translated but review-visible before runtime graduation: service-wording rows `polite-basics-5`, `grab-taxi-1`, `simple-problems-3`, `hotel-hostel-2`, `grab-taxi-3`, `convenience-store-7`, `simple-problems-7`, `coffee-shop-7`, `hotel-hostel-7`, `convenience-store-5`, and `grab-taxi-4`; transit rows `grab-taxi-2`, `directions-1`, `directions-5`, and `directions-6`; context wording row `simple-problems-4`.
- Keep-translated and closed for now unless native review arrives: politeness register rows `polite-basics-1`, `polite-basics-3`, `polite-basics-6`, and `polite-basics-7`, plus social rows `small-talk-1` through `small-talk-7`.
- This packet is the honest release posture for the Germany lane; do not reopen already translated rows unless a later native or expert review actually changes the recommendation.

## Pronunciation / search posture notes

- Traveler-facing pronunciation should stay ASCII-friendly and compact.
- Keep adding pronunciation help where umlauts, `ch`, `ei/ie`, `eu`, weak final `r`, or separable verbs could trip up English speakers.
- English-intent retrieval should remain the primary search assumption.
- Preserve real German spelling on cards even if later search helpers normalize umlauts or sharp-s.

## Next content pass should

- treat the translation backlog as functionally closed, with `coffee-shop-4` now moved out of rewrite limbo and into an explicit native-review handoff
- keep `coffee-shop-4` parked unless a native reviewer or later evidence produces a stronger Germany-fit cafe intent
- run native or expert review against the grouped residual packet instead of inventing fresh Germany drafting work
- keep tightening pronunciation help for `Kräuter`, `Wiedersehen`, `USA`, and formal `Ihnen`
- preserve service-wording, transit, medical, context, and register caution instead of flattening those review flags away


