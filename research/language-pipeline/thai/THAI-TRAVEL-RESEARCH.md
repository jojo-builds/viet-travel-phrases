# Thai Travel Research

## Scope

- Prep-only research for a future Thailand / Thai lane inside the SpeakLocal family repo.
- This document does not promote Thailand into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. Thailand does not need a new category model yet.
- Default the future lane to Central Thai / Bangkok Thai for the first pack.
- Treat Thai as a non-Latin, tone-sensitive lane from day one. Thai script, traveler-facing romanization, and audio all matter more here than in the Latin-script prep lanes.
- Do not rely on official RTGS romanization alone for the learner surface. It is useful for signage familiarity, but it omits tone and vowel-length detail and is not enough as the only pronunciation layer for anxious travelers.
- Bias the first Thai starter pack toward short, polite, service-safe phrases: greeting, thanks, sorry/excuse me, price, not spicy, no ice, here/there, stop here, I do not understand, please say it slowly, and help/doctor/police escalation.

## Destination framing

- Destination: Thailand
- Language target: Thai
- Default spoken baseline for the first lane: Central Thai / Bangkok Thai
- Product framing: traveler-first Thailand support, not a general Thai-learning curriculum

Why this framing is the safest now:

- Central Thai is the nationally taught and most broadly understood baseline.
- Travelers will still hear regional variation, but a Central Thai pack is the clearest first authoring target for common service encounters.
- The app should present Thailand as the destination truth and Thai as the language layer, matching the family's destination-first posture.

## Traveler-use reality

The strongest Thai lane opportunity looks similar to Viet in product shape but harder in pronunciation and search:

- Many tourist interactions are short and transactional: arrivals, hotel desks, rides, markets, cafes, pharmacies, convenience stores, and payment friction.
- Thailand now has traveler-visible digital flows that justify modern travel phrases, not just old phrasebook staples.
- A Thai pack should assume many users will try speaking first, then show the screen second.
- The app should not assume English is absent; it should assume English is uneven.

Implication for SpeakLocal:

- The first Thai pack should optimize for speed and confidence, not grammar coverage.
- Search, recent phrases, and pressure-safe quick phrases matter even more than usual because Thai typing is a higher barrier for many English-speaking travelers.

## Politeness model

Thai politeness materially affects whether a phrase sounds acceptably soft.

What looks safe for the future lane:

- Teach sentence-ending politeness particles early.
- Men will often end polite sentences with `ครับ` / `khrap`.
- Women will often end polite statements with `ค่ะ` / `kha`, while some question forms use `คะ` / `kha`.
- Keep the first pack biased toward polite defaults rather than clipped bare commands.
- Treat these examples as provisional authoring guidance, not final teaching copy. Native review is still needed before the app explains particle choice to travelers.

What SpeakLocal should do:

- Default many service phrases to a polite traveler form, not the shortest raw imperative.
- Keep the visible English simple, but note when the Thai surface includes a politeness particle that softens the interaction.
- Avoid overloading the user with grammar explanations. A lightweight "polite ending" cue is enough for starter content.

What not to do:

- Do not build the lane around formal cultural performance such as teaching the wai as if it were required in every interaction.
- Do not overfit to hyper-formal textbook Thai.
- Do not present gendered particle choice carelessly; the pack needs later review so the pronunciation and help text stay accurate and respectful.

## Script and romanization posture

Thai is the first likely family lane where script and search posture become a major product decision, not a formatting detail.

What matters:

- Thai script is an abugida.
- Thai has five tones.
- Spaces normally separate phrases, not words.
- Official RTGS romanization is what travelers often see on road signs and official signage, but it uses plain Latin letters and does not mark tone or vowel length in the general system.

Product recommendation:

- Show all three layers when possible:
  - English intent
  - Thai script
  - SpeakLocal traveler romanization
- Index search primarily on English intent and curated aliases first.
- Add Thai-script matching later for pasted text or native review workflows.
- Treat RTGS familiarity as a secondary reference, not the learner-facing pronunciation contract.

Why RTGS alone is not enough:

- It is useful for consistency with public signs.
- It is weak for teaching tourists how to produce usable spoken Thai under pressure because it leaves out the tone and length information that meaning depends on.

Recommended pronunciation posture for later implementation:

- Keep a simplified traveler romanization for immediate use, but mark it as approximate rather than authoritative.
- Preserve script on every phrase card so the user can show the phrase even if speaking confidence is low.
- Add audio early in the graduation path because Thai tone risk is higher than in Latin-script prep lanes.
- Treat RTGS as secondary signage familiarity only; it should not replace SpeakLocal's learner-facing pronunciation layer.
- Keep an explicit warning in the scaffold that tone and vowel length remain unresolved until audio plus native review are in place.

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

No Thailand-specific category deviation is strong enough yet to justify a new runtime seam. Thai-specific value should show up in phrase choice, scenario tips, and quick-phrase ranking instead.

High-value Thai emphasis by scenario:

1. Coffee Shop
   - iced vs hot, sweetness, less ice, takeaway
2. Street Food / Restaurant
   - not spicy, no ice, allergy repair, takeaway
3. Ride App / Taxi
   - take me here, meter, stop here, wrong pickup point, wrong route, call the driver
4. Asking the Price
   - how much, final price, cash vs card or QR, receipt, wrong change
5. Polite Basics
   - hello, thank you, sorry or excuse me, yes or no, okay, polite attention-getters
6. Convenience Store
   - water, tissues, charger, SIM or data top-up, bag, receipt
7. Hotel / Hostel
   - reservation, check-in, passport, deposit, towels, air conditioning, key-card problems
8. Directions
   - where is, left or right, straight, nearest station, platform or exit, can I walk there
9. Simple Problems
   - I do not understand, say it slowly, I am lost, my phone is dead, I need a doctor, call the police
10. Small Talk
   - first trip, where are you from, this food is good, basic warm replies

## Likely reply and repair layers

Thai needs a strong repair layer because even a good starter pack will not prevent rapid local replies.

Future authoring should prioritize:

- yes, no, okay, not available, finished, later
- numbers, prices, and time confirmations
- left, right, straight, here, there, this one, that one
- today, tomorrow, now, later, how many minutes
- repeat please, slower please, can you type it, can you show me, can you point
- is this correct, do you mean this, can I pay here, can I scan, cash only

This repair layer is especially important for:

- transport pickup confusion
- food restrictions
- payment mismatches
- hotel check-in and deposits
- direction-following around stations, exits, and piers

## High-risk review areas

These areas should get later native or expert review before any runtime graduation:

- medical and emergency language
- police, theft, passport loss, and reporting language
- allergy and spice wording
- transport disputes and safety boundaries
- money disputes, refunds, and QR-payment misunderstandings
- gendered politeness-particle help text
- romanization choices that may accidentally train the wrong tone or vowel length

## First starter-pack recommendation

Recommended first Thai starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth immediately.
- Put the highest-pressure phrases first, not broad sightseeing filler.

Suggested first-wave family priorities:

- greeting, thanks, sorry or excuse me
- how much is this
- take me here
- please use the meter
- stop here
- not spicy please
- no ice please
- bottled water please
- I have a reservation
- where is the station
- I do not understand
- please speak slowly
- can you write it down
- I need a doctor
- please call the police

## Open questions for the next lane

- What exact traveler romanization standard should SpeakLocal own for Thai beyond RTGS familiarity?
- Should the first Thai starter pack include explicit tone mnemonics or keep that hidden behind audio plus script?
- Which payment phrases matter most now that tourist QR payment is becoming more visible?
- How far should the first lane go on food restrictions beyond spice, ice, peanuts, shellfish, and vegetarian or no-meat?
- What is the safest minimal pronoun strategy for travelers so the pack stays polite without sounding unnatural?

## Sources checked

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - existing prep-lane files under `content-draft/japanese/`, `content-draft/tagalog/`, and `content-draft/turkish/`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- External references carried forward from the original research pass:
  - [Thailand Foundation: How to use "Krub" and "Kha" in the Thai Language](https://thailandfoundation.or.th/how-to-use-krub-and-kha-in-the-thai-language/)
  - [Royal Thai General System of Transcription overview](https://en.wikipedia.org/wiki/Royal_Thai_General_System_of_Transcription)
  - [W3C Thai orthography notes](https://r12a.github.io/scripts/thai/th.html)
  - [TAT: Guideline Thailand Digital Arrival Card (TDAC)](https://www.tourismthailand.org/Articles/tdac)
  - [TAT: TAGTHAi Easy Pay / Thai QR Payment for foreign tourists](https://www.tourismthailand.org/Articles/tagthai-easy-pay-en)
  - [thai-language.com overview of Central Thai and regional variation](https://www.thai-language.com/ref/overview)

## Confidence note

- High confidence: keep the shared 10-scenario skeleton; Thai needs stronger script, audio, and repair planning than the Latin-script prep lanes.
- Medium confidence: exact first-wave phrase mix and the final romanization strategy.
- Lower confidence until later review: emergency language, nuanced gendered politeness guidance, and any phrase whose meaning depends heavily on tone precision.
