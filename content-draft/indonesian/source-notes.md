# Indonesian Source Notes

Current reality:

- This lane is still prep-only and is not wired into the runtime app registry.
- The shared traveler baseline remains the structural starting point, but the Indonesian lane now has a reusable row-level scaffold plus a translated first-wave core, a second translated support pack, a smaller holdout-reduction pass, and a final practical remainder cleanup.
- `first-wave-priority.csv` now marks the top `67` ranked outcomes explicitly instead of leaving the lane at the original `30`-row first-wave boundary.
- `phrase-source.csv` now carries translated target text, pronunciation, and updated status markers across the cleared high-value rows for hospitality, payment follow-through, hotel support, repair language, and the promoted cafe, garnish, sunscreen, and port holdouts.

## Authoring stance

- Default to neutral polite standard Indonesian.
- Prefer short service-safe requests over clipped commands or textbook-formal phrasing.
- Keep `target_text` in standard Indonesian spelling for show-screen usefulness.
- Use `pronunciation` only as a light helper where English speakers are likely to misread the spelling.
- Treat `Anda` as formal and usually unnecessary for the earliest service phrases.
- Keep regional address terms such as `Pak`, `Bu`, `Mas`, `Mbak`, and `Kak` visible as later review topics instead of forcing them into the first core.
- Keep colloquial Indonesian variants alias-only for now unless a future review explicitly promotes one into the visible phrase surface.

## Phrase selection adjustments for Indonesia

- Keep the shared 10 scenarios, but bias authoring toward polite basics, price checks, ride pickup and dropoff, food modifiers, hotel arrival, convenience-store needs, and repair language.
- Treat generic `city center` direction prompts as rewrite-before-translation debt rather than literal translation targets.
- Keep the Indonesian-specific supplementals focused on real traveler friction: ride pickup, scan or QR payment, cash or card acceptance, toilet access, and repair phrases such as repeat, write it down, and show me on the map.
- Treat small talk as low priority for the first wave.
- Keep medical, police, lost-passport, allergy, and transport-dispute rows visible but behind later expert review.

## Rows already rewritten before translation

- `coffee-shop-5` now uses `Less sugar please` instead of the blunter no-sugar carryover.
- `street-food-2` now uses `I would like this one` instead of a bowl-specific order.
- `street-food-4` now uses `More vegetables please` instead of the herb-specific baseline.
- `street-food-6` now uses `A spoon and fork please` instead of a chopsticks-based carryover.
- `grab-taxi-2` now uses `Please take me to this address` instead of generic city-center routing.
- `grab-taxi-4` now uses `Please follow the map` instead of vague route guidance.
- `asking-price-4` and `asking-price-5` now lean toward cheaper-option and total-price wording instead of stronger bargaining posture.

## Pronunciation and search posture notes

- English-intent retrieval should remain the primary search assumption.
- Standard Indonesian spelling should stay visible on cards even when pronunciation help is present.
- Light pronunciation attention should focus on schwa `e`, `ng`, `ny`, and the fact that Indonesian spelling is usually more transparent than English.
- Future search alias planning should stay narrow and honest, especially around colloquial negatives such as `nggak` versus standard `tidak`, and around payment vocabulary tied to cash, card, and scan flows.
- Show-screen usefulness is high in this lane, so address, map, port, hotel, and payment rows should stay easy to display even before deeper pronunciation coverage exists.

## First translated batch completed

- The first translated batch cleared `30` ranked rows centered on politeness, ride control, payment clarification, hotel arrival, bottled water, not-spicy food requests, and repair language.
- `Excuse me` and `Sorry` were both translated but still keep later `permisi` versus `maaf` review visible instead of flattening that distinction away.
- `Can I scan to pay?`, `Can I pay by card?`, and `Can I pay cash?` are now translated while still keeping payment-review flags visible because QR and mixed-payment wording should remain honest.
- `Not spicy please` is now translated but still keeps its food-review flag because natural phrasing matters more than literal coverage.
- Lightweight pronunciation is now present on the cleared rows and stays intentionally compact rather than turning the lane into phonetic-heavy study material.

## T-080 second translation-pack decisions

- The lane now carries `59` ranked outcomes in `first-wave-priority.csv`, and the next high-value unresolved cluster was translated instead of staying parked below the first-wave line.
- Ride follow-through coverage now includes `Please take me to this address`, `Please follow the map`, `Please turn on the air conditioning`, `Wait for me five minutes`, `I will pay cash`, and `Please wait a moment`.
- Checkout and purchase follow-through now includes `How much per kilo`, `What is the total price`, `Show me another one`, `I will take this one`, `Do you have a bag`, and `Please give me the receipt`.
- Hotel support coverage now includes `This room is too hot`, `The air conditioner is not working`, `More towels please`, and `Please hold my luggage`.
- Practical repair coverage now includes `I left something behind`, `The Wi Fi is not working`, and `Please call for me`.
- The pass also filled lightweight pronunciation for every newly translated row so the high-value translated set keeps a consistent traveler-help posture.

## T-086 holdout-management decisions

- The lane now carries `65` ranked outcomes in `first-wave-priority.csv`, with the worthwhile coffee and food-adjustment tail cleared instead of leaving those rows mixed into the broad unresolved remainder.
- Cafe coverage now includes `One iced milk coffee please`, `I would like an iced black coffee`, `I would like an iced latte`, and `Just a little ice`, using simple show-screen-friendly wording instead of trying to over-localize cafe menu language.
- Food follow-through now includes `More vegetables please`, promoting a previously rewritten garnish row into practical traveler coverage.
- Purchase comparison now includes `Is there a cheaper one`, but the stronger bargaining row `That is too expensive` still stays deferred so the lane does not overstate haggling confidence.

## T-086 practical remainder cleanup

- The lane now carries `67` ranked outcomes in `first-wave-priority.csv`, with the last clearly practical remainder rows cleared instead of leaving them mixed into the broad unresolved tail.
- Convenience-store coverage now includes `Where is the sunscreen`, translated as `Di mana tabir surya?` so the lane covers a common pharmacy or mini-mart beach-day lookup without leaning on an English loanword by default.
- Indonesia-fit directions coverage now includes `Where is the port?`, translated as `Di mana pelabuhannya?` so ferry and harbor lookups no longer sit unresolved beside the otherwise practical travel set.
- Generic turn-by-turn direction filler, the duplicate convenience-store card-payment row, the harder bargaining row, medical wording, and the small-talk cluster remain explicit holdouts rather than being flattened into the translated set.

## Rows that still carry explicit risk or caution

- Payment rows now have usable Indonesian text, but the lane should still preserve review visibility around QR, cash, and card wording before any runtime graduation.
- `Excuse me` and `Sorry` now have starter translations, but later native review should still confirm how broadly `permisi` and `maaf` should anchor the visible starter surface.
- `I need a doctor` remains in `phrase-source.csv` as an expert-review-needed holdout and should not be treated as runtime-ready just because nearby repair rows are now translated.
- The remaining unresolved tail is now narrower and more explicit: bargaining-heavy price language, generic `city center` directions, most turn-by-turn direction filler, duplicate card-payment coverage, the medical holdout, and the small-talk cluster are still unresolved and should stay honest as later holdouts instead of being flattened into fake completeness.

## Next content pass should

- continue from the remaining low-fit holdouts rather than reopening the translated top `67`
- keep the translated top `67` stable unless later review exposes a concrete issue
- decide the smallest useful colloquial alias set without weakening the standard Indonesian surface
- keep rewrite-before-translation rows explicit instead of smoothing them into fake certainty
- decide whether `asking-price-3`, `directions-1`, and the turn-by-turn filler rows should be rewritten into stronger Indonesia-fit intents or remain late optional coverage
- decide the honest audio posture before any runtime wiring discussion
