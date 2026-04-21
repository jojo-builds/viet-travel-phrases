# South Korea Travel Research

## Scope

- Prep-only research for a future South Korea / Korean lane inside the SpeakLocal family repo.
- This document does not promote South Korea into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. South Korea does not need a new category model yet.
- Default the first lane to polite everyday standard Korean, using safe `-yo` style service language instead of blunt casual speech or unusually stiff ceremonial wording.
- Treat Korean as a script-plus-pronunciation lane from day one. Hangul should stay visible for show-screen use, and romanization should stay helper-only.
- Bias the first starter pack toward high-pressure utility: excuse me / thank you / how much is this / take me here / I have a reservation / card or cash / I do not understand / please speak slowly / not spicy please / I need a doctor.
- De-emphasize bargaining language. South Korea travel reality makes ordering, navigation, payment confirmation, and repair phrases more useful than discount negotiation.

## Destination framing

- Destination: South Korea
- Language target: Korean
- Default spoken baseline for the first lane: standard polite Korean suitable for routine service encounters
- Product framing: traveler-first South Korea support, not a general Korean-learning curriculum

Why this framing is the safest now:

- The family model is destination-first, so South Korea remains the product surface and Korean remains the language layer.
- Travelers will hear regional accents and dialect features, but standard Seoul-style polite Korean is the safest national baseline.
- South Korea travel friction is usually not full communication collapse; it is fast-moving service moments where short polite phrases reduce stress.

## Traveler-use reality

The strongest South Korea lane opportunity is not textbook conversation. It is quick, socially safe help in dense urban travel moments:

- Coffee shops, convenience stores, subway exits, taxi drop-offs, hotel desks, and casual restaurant ordering create repeat short interactions.
- Many travelers can point at menus or show a map, but a short Korean phrase still helps with payment method, less spicy food, repeat that slowly, and reservation or check-in follow-through.
- South Korea is unusually strong on kiosk ordering, apps, and card usage. That shifts phrase value away from bargaining and toward repair, confirmation, and polite transaction language.
- English support is uneven across traveler contexts. Major tourist infrastructure may handle some English, but smaller shops, older taxi drivers, or busy counters still reward a compact Korean utility layer.

Implication for SpeakLocal:

- The first Korea pack should optimize for speed, politeness, and show-screen clarity.
- The first authoring wave should prefer phrases that unlock ordering, payment, directions, check-in, and communication repair.
- The shared `asking-price` scenario remains valid, but its South Korea usage should focus on price confirmation and item choice rather than negotiation.

## Politeness and register posture

Korean politeness matters, but the first pack should solve it with safe defaults instead of grammar lessons.

What looks safe for the future lane:

- Default to polite everyday service Korean, usually with `-yo` endings or established service phrases.
- Favor durable travel-safe set phrases such as `gamsahamnida`, `joesonghamnida`, `sillyehamnida`, and request patterns like `... juseyo`.
- Avoid defaulting to casual `banmal` forms even when they look shorter on paper.
- Avoid overloading the first pack with honorific explanations, speech-level taxonomy, or particle teaching.

What SpeakLocal should do:

- Translate the first wave with polite service-safe wording by default.
- Keep English intent simple while letting the Korean surface carry the necessary softening.
- Use notes and review flags when a literal baseline translation would sound too direct, too formal, or too context-dependent.

What not to do:

- Do not teach travelers that short blunt dictionary forms are socially neutral.
- Do not overfit to K-drama or entertainment speech.
- Do not pretend one English-friendly romanization layer removes the need for audio before runtime graduation.

## Script posture

Korean script is a product decision, not a formatting detail.

What matters:

- Hangul is the normal written form travelers will see in South Korea.
- Hangul is more pronunciation-friendly than kanji-heavy Japanese, but it is still not enough for many first-time English-speaking users to pronounce confidently.
- A romanized-only lane would weaken show-screen usefulness and train users away from the text locals actually read.

Product recommendation:

- Keep `target_text` in natural Hangul for show-screen use.
- Keep `pronunciation` as the traveler-facing speech aid, but treat it as support rather than the canonical display layer.
- Preserve note-level guidance when sound changes, silent consonants, or compressed spoken forms could mislead first-time travelers.
- Do not author a romanized-only lane. Hangul must remain visible on every card.

## Pronunciation and romanization posture

The first Korean lane needs an honest, lightweight pronunciation contract.

Recommended posture for prep work now:

- Use traveler-friendly ASCII romanization in the `pronunciation` field.
- Keep spellings broadly compatible with recognizable Revised Romanization shapes, but bias toward sayability over strict official transliteration.
- Preserve the highest-risk pronunciation notes around `eo`, `eu`, aspirated versus plain consonants, and final-consonant sound changes.
- Treat audio as important before runtime graduation, because romanization will help confidence but will not fully solve pronunciation accuracy.

Confidence note:

- High confidence: Korean needs both Hangul and pronunciation help.
- Medium confidence: the exact future normalization rules for romanization.
- Lower confidence until later native review: how much to expose assimilation, tense consonants, and edge-case sound change detail for travelers.

## Repair-layer and likely-reply opportunities

Korean needs a strong repair layer because service encounters are fast and polite.

Future authoring should prioritize:

- I do not understand
- Please speak slowly
- Please say it again
- This one / here / take me here
- card or cash confirmation
- where is the exit / station / bathroom
- not spicy please
- reservation / check in / hold my luggage
- lost item / call for me / doctor escalation

This repair layer matters most for:

- kiosk plus counter handoff moments
- taxi or ride-app drop-off clarification
- subway exit and station navigation
- restaurant ordering when the menu or side-dish flow is unfamiliar
- hotel front-desk troubleshooting

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

South Korea-specific value should appear in tip copy, quick-phrase ranking, and phrase selection instead of a new runtime seam.

High-value South Korea emphasis by scenario:

1. Coffee Shop
   - iced or hot, less ice, no syrup, takeaway, receipt, busy pickup flow
2. Street Food / Restaurant
   - one portion, this one, not spicy, water, takeaway, utensil or side-dish clarification
3. Ride App / Taxi
   - take me here, stop here, please wait, card or cash, destination confirmation from a phone screen
4. Asking the Price
   - how much, which one, final item choice, card or cash, less focus on bargaining
5. Polite Basics
   - excuse me, thank you, sorry, no thank you, respectful yes or acknowledgment
6. Convenience Store
   - water, bag, receipt, card payment, charger or tissue help, open this for me
7. Hotel / Hostel
   - reservation, check in, check out time, luggage hold, room problem reporting
8. Directions
   - station, exit, line, near here, walk time, left or right confirmation
9. Simple Problems
   - I do not understand, slower please, I am lost, call for me, doctor escalation
10. Small Talk
   - keep light and optional; travel utility stays more important than conversation practice

## Search and localization implications

Korean is the next family prep lane where non-Latin discovery risk matters, even though Hangul is more regular than Japanese script.

Recommendation for later implementation:

- Keep English-intent search as the primary retrieval path.
- Add curated English aliases for likely traveler phrasing, not grammar labels.
- Plan for later Hangul matching and pasted-text support, but do not assume the current Latin-script search contract can be inherited without review.
- Preserve Hangul on cards even if the user searches in English, because show-screen behavior is part of the product value.
- Treat romanization search as helper behavior only. It should not become the canonical authored surface.

## High-risk review areas

These areas need later native or expert review before runtime graduation:

- medical and emergency wording
- police, theft, lost-passport, and reporting language
- allergy or ingredient-risk wording
- hotel complaints that can sound too blunt or too indirect
- payment, refund, or card-declined repair wording
- exact romanization normalization guidance
- phrases where the current English scaffold likely needs Korea-specific rewriting instead of direct translation

## First starter-pack recommendation

Recommended first Korean starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth.
- Put the highest-pressure phrases first, especially those that still work when the user ends up showing the screen.

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
- where is the exit or station
- is it near here
- how long on foot
- please call for me
- I need a doctor

## Open questions for the next lane

- Which Korea-specific scaffold lines should be rewritten before translation rather than translated literally, especially in `asking-price`, `street-food`, and `directions`?
- Should the future runtime surface expose a stricter internal romanization contract than the traveler-facing pronunciation helper?
- What is the best compact repair mini-set for subway exits, payment confirmation, and kiosk fallback?
- How much food-modification coverage is needed for the first pack beyond `not spicy`, water, and basic menu selection?
- Which convenience-store and hotel phrases now outrank older phrasebook filler for a first 60-90 family launch?

## Sources checked

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/PRIORITIES.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - current prep files under `content-draft/tagalog/` and `content-draft/japanese/`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- Mode note:
  - This automation run used repo sources plus bounded product reasoning from general Korean travel and language-use knowledge.
  - No live external browsing was performed in this run.

## Confidence note

- High confidence: keep the shared 10-scenario skeleton, bias the first wave toward polite utility, and keep Hangul visible.
- Medium confidence: the final balance between official romanization, traveler sayability, and search alias behavior.
- Lower confidence until later review: exact emergency wording, allergy wording, and pronunciation edge cases.
