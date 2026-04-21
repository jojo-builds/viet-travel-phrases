# Japan Travel Research

## Scope

- Prep-only research for a future Japan / Japanese lane inside the SpeakLocal family repo.
- This document does not promote Japan into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. Japan does not need a new category model yet.
- Default the first lane to polite everyday standard Japanese, using service-safe set phrases and desu/masu posture instead of casual plain forms.
- Treat Japanese as a mixed-script lane from day one. Travelers need natural show-screen text plus an honest pronunciation aid; romaji alone is not enough.
- Bias the first starter pack toward high-pressure utility: excuse me / thanks / price / take me here / reservation / card or cash / where is the exit / I do not understand / slower please / lost item / doctor escalation.
- De-emphasize bargaining language. Japan travel reality makes price confirmation, station navigation, convenience-store utility, and hotel desk friction more important than negotiating for discounts.

## Destination framing

- Destination: Japan
- Language target: Japanese
- Default spoken baseline for the first lane: standard polite Japanese appropriate for routine service encounters
- Product framing: traveler-first Japan support, not a general Japanese-learning curriculum

Why this framing is the safest now:

- The family model is destination-first, so Japan remains the product surface and Japanese remains the language layer.
- Travelers will hear regional variation, but a polite standard baseline is the safest national starting point.
- JNTO's traveler guidance still assumes English is uneven outside major hubs and small local shops, which supports a short utility-first pack instead of a classroom sequence.

## Traveler-use reality

The strongest Japan lane opportunity is less about survival-from-zero and more about reducing friction in fast-moving service environments:

- Trains, station exits, convenience stores, hotel desks, cafes, and restaurant ordering produce many of the same short transactional moments that SpeakLocal already serves well.
- JNTO still recommends learning a few basic Japanese phrases and notes that English is generally understood in major tourist infrastructure but not reliably in rural areas or small local shops.
- JNTO also highlights how broadly IC cards are used across trains, buses, convenience stores, vending machines, and some taxis. That makes transport, payment, receipt, and small-purchase language unusually valuable in Japan.
- Japan-specific usefulness is therefore not about adding a brand-new scenario system. It is about reordering the existing baseline around station navigation, reservations, convenience stores, and screen-showable short requests.

Implication for SpeakLocal:

- The first Japan pack should optimize for speed, politeness, and show-screen clarity.
- The first authoring wave should prefer phrases that unlock transport, check-in, payment, and repair rather than sightseeing filler or textbook self-introductions.
- The shared `asking-price` scenario remains valid, but its Japan-specific usage should shift toward price confirmation and item selection rather than bargaining.

## Politeness and register posture

Japanese politeness matters, but the first pack should solve it with safe defaults instead of grammar lectures.

What looks safe for the future lane:

- Default sentence style to polite everyday service Japanese rather than plain or slangy forms.
- Favor durable set phrases such as `sumimasen`, `arigatou gozaimasu`, `onegaishimasu`, and polite question endings over clipped command forms.
- Avoid teaching casual `da` / plain-form travel lines as the default starter surface.
- Avoid overusing explicit pronouns when Japanese would normally omit them.

What SpeakLocal should do:

- Translate the first wave with polite service-safe wording by default.
- Keep English intent simple while letting the Japanese surface carry the necessary politeness.
- Use notes and review flags when a phrase can sound too blunt, too formal, or too dependent on context.

What not to do:

- Do not turn the starter pack into business-Japanese or etiquette theater.
- Do not overfit to anime-style casual speech.
- Do not promise that a romaji-only layer is good enough for exact pronunciation in every case.

## Script posture

Japanese script is a product decision, not a formatting detail.

What matters:

- Japanese writing normally mixes kanji, hiragana, katakana, and sometimes Latin text in the same interface.
- Kanji is excellent for show-screen usefulness, but it can hide pronunciation from nervous first-time speakers.
- JNTO's phrase guidance for travelers is romanized, but that does not remove the need for script on the card itself.

Product recommendation:

- Keep `target_text` in natural Japanese script for show-screen use.
- Keep `pronunciation` as the traveler-facing speech aid, but treat it as support rather than the canonical display layer.
- When a phrase uses kanji whose reading is not obvious, preserve the kana reading in source notes or review material until the schema grows a dedicated reading surface.
- Do not author a romaji-only lane. Script must remain visible on every card.

## Pronunciation posture

The first Japanese lane needs an honest, lightweight pronunciation contract.

Recommended posture for prep work now:

- Use a traveler-friendly ASCII romaji in the `pronunciation` field, broadly aligned with common Hepburn-style spellings.
- Prefer recognizable traveler spellings over linguistically dense notation.
- Keep long-vowel and doubled-consonant risk visible in notes when they materially affect clarity.
- Treat audio as important before runtime graduation, because romaji will help confidence but will not fully solve pronunciation accuracy.

Confidence note:

- High confidence: Japanese needs both script and pronunciation help.
- Medium confidence: the exact future romanization normalization rules.
- Lower confidence until later native review: how aggressively to encode long vowels, devoicing, and pitch-sensitive distinctions for travelers.

## Repair-layer and likely-reply opportunities

Japanese needs a stronger repair layer than the current scaffold suggests.

Future authoring should prioritize:

- I do not understand
- Please speak slowly
- Please say it again
- Here / this one / this place
- Is it near here
- How long on foot
- card or cash confirmation
- receipt / bag / reservation / luggage storage
- lost item / call for me / doctor escalation

This repair layer matters most for:

- station and exit navigation
- taxi drop-off and pickup clarification
- restaurant ordering when the menu is machine- or tablet-driven
- convenience-store checkout questions
- hotel desk troubleshooting

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

Japan-specific value should appear in tip copy, quick-phrase ranking, and phrase selection instead of a new runtime seam.

High-value Japan emphasis by scenario:

1. Coffee Shop
   - takeaway, ice/sugar tweaks, quick payment, busy pickup counters
2. Street Food / Restaurant
   - water, takeaway, not spicy, utensil requests, short menu clarifications
3. Ride App / Taxi
   - take me here, stop here, station or exit confusion, payment method clarity
4. Asking the Price
   - how much, which one, final item choice, tax-free or receipt clarification, not bargaining
5. Polite Basics
   - excuse me, thank you, sorry, no thank you, brief polite acknowledgments
6. Convenience Store
   - water, bag, receipt, card, ATM, charger, basic item-finding help
7. Hotel / Hostel
   - reservation, check-in, checkout time, luggage hold, room problem reporting
8. Directions
   - station, exit, near here, walk time, left/right/straight confirmation
9. Simple Problems
   - I do not understand, slower please, I am lost, call for me, doctor escalation
10. Small Talk
   - keep light and optional; travel utility stays more important than conversation practice

## Search and localization implications

Japanese is the first family prep lane where non-Latin discovery risk is unavoidable.

Recommendation for later implementation:

- Keep English-intent search as the primary retrieval path.
- Add curated English aliases for likely traveler phrasing, not textbook grammar labels.
- Plan for later kana / kanji matching and pasted-text support, but do not assume the current Latin-script search contract can be inherited without review.
- Keep the runtime graduation gate strict: Japanese needs a dedicated UX/localization review before inheriting Viet + Tagalog search behavior.
- Preserve script on cards even if the user searches in English, because show-screen behavior is part of the product value.

## High-risk review areas

These areas need later native or expert review before runtime graduation:

- medical and emergency wording
- police, theft, lost-passport, and reporting language
- allergy or ingredient-risk wording
- hotel complaints that can sound too blunt or too vague
- transport-dispute wording
- exact pronunciation/romaji normalization guidance
- phrases where the current English scaffold likely needs Japan-specific rewriting rather than direct translation

## First starter-pack recommendation

Recommended first Japanese starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth.
- Put the highest-pressure phrases first, especially those that work even when the user ends up showing the screen.

Suggested first-wave family priorities:

- excuse me / sorry
- thank you
- take me here
- how much is this
- I do not understand
- please speak slowly
- I have a reservation
- I would like to check in
- can I pay by card
- bottled water please
- not spicy please
- where is the station / exit / bathroom
- is it near here
- how long on foot
- please call for me
- I need a doctor

## Open questions for the next lane

- Which Japan-specific scaffold lines should be rewritten before translation rather than translated literally, especially in `directions` and `asking-price`?
- Should the future runtime surface expose kana readings separately from romaji for better show-screen plus speak-first behavior?
- What is the best compact repair mini-set for station exits, platforms, and transfer language?
- How much food/dietary coverage is needed for the first pack beyond `not spicy`, water, and basic menu clarification?
- Which convenience-store and hotel phrases now outrank older phrasebook filler for a first 60-90 family launch?

## Sources checked

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - current Japanese prep files under `content-draft/japanese/`
  - `research/language-pipeline/thai/THAI-TRAVEL-RESEARCH.md`
  - `content-draft/thai/research-backlog.md`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- External references:
  - JNTO FAQ: https://www.japan.travel/en/faq/
  - JNTO Japanese language page: https://www.japan.travel/en/plan/japanese-language
  - JNTO manners guide: https://www.japan.travel/en/guide/understanding-and-mastering-japanese-manners-and-etiquette/
  - JNTO IC card guide: https://www.japan.travel/en/plan/ic-card/
  - W3C Japanese script resources: https://www.w3.org/TR/jpan-lreq/

## Confidence note

- High confidence: keep the shared 10-scenario skeleton, bias the first wave toward polite utility, and keep script visible.
- Medium confidence: the final balance between romaji normalization, kana support, and search alias behavior.
- Lower confidence until later review: exact medical, police, allergy, and pronunciation edge cases.
