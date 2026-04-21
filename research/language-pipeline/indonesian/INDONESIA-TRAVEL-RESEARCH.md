# Indonesia Travel Research

## Scope

- Prep-only research for a future Indonesia / Indonesian lane inside the SpeakLocal family repo.
- This document does not promote Indonesia into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. Indonesia does not need a new category model yet.
- Default the future lane to standard Indonesian (`Bahasa Indonesia`) rather than a regional language.
- Treat Indonesian as a relatively pronunciation-friendly Latin-script lane, but keep lightweight helper notes for the schwa `e`, `ng`, `ny`, and final-stop pronunciation.
- Bias the first Indonesian starter pack toward short service-safe phrases for rides, food, price checks, hotel arrival, convenience-store stops, and repair language.
- Keep address terms such as `Pak`, `Bu`, `Mas`, `Mbak`, and `Kak` out of the earliest core until the lane gets a tighter politeness review; they are useful, but region and age context matters.

## Destination framing

- Destination: Indonesia
- Language target: Indonesian / `Bahasa Indonesia`
- Default spoken baseline for the first lane: standard Indonesian used with strangers and service staff
- Product framing: traveler-first Indonesia support, not a general Indonesian-learning curriculum

Why this framing is the safest now:

- Indonesian is the national language and the cross-region service language even though many people also use a local language at home.
- Travelers will hear regional accents and local terms, but a standard Indonesian pack is still the clearest first authoring target for hotels, transport, shops, cafes, and tourist services.
- The app should present Indonesia as the destination truth and Indonesian as the language layer, matching the family's destination-first posture.

## Traveler-use reality

The strongest Indonesia lane opportunity looks close to Viet in product shape:

- Many tourist interactions are short and transactional: airport arrival, hotel desks, ride-hailing pickups, cafes, warungs, markets, pharmacies, convenience stores, and ferry or station handoffs.
- Ride-hailing matters enough to treat it as a first-wave scenario priority. Both Grab and Gojek are visible parts of the transport reality in Indonesia.
- Payment clarification is increasingly part of real travel interactions because travelers may encounter cash, cards, and QRIS signs in the same trip.
- Indonesian is easier to type and visually recognize than non-Latin lanes, so search and show-screen behavior can stay simple.
- The app should still assume English is uneven rather than absent.

Implication for SpeakLocal:

- The first Indonesian pack should optimize for speed and confidence, not grammar coverage.
- Speak-first is more realistic here than in Thai, but show-screen still matters for names, addresses, allergy or medical issues, and noisy ride or market situations.
- Search should focus on English intent first, then exact Indonesian spelling plus a few high-value colloquial aliases.

## Politeness model

Indonesian politeness is less morphology-heavy than Thai or Japanese, but tone still matters.

What looks safe for the future lane:

- Use short polite defaults built around `tolong`, `permisi`, `maaf`, and `terima kasih`.
- Favor request shapes that sound soft with strangers, especially `tolong ...`, `bisa ...?`, and `mau ...`.
- Keep most starter phrases pronoun-light. Indonesian often sounds more natural without forcing `saya` or `Anda` into every service interaction.
- Treat `Anda` as formal and often more written than spoken. It should not be the automatic traveler default.
- Treat kinship or address terms such as `Pak`, `Bu`, `Mas`, `Mbak`, and `Kak` as valuable later review topics rather than mandatory early-core content.

What SpeakLocal should do:

- Default service phrases to neutral polite everyday Indonesian, not clipped commands.
- Keep the visible English simple, but note where a phrase is softened by `tolong` or `permisi`.
- Avoid overexplaining grammar. A compact note that a phrase is a polite request is enough for starter content.

What not to do:

- Do not teach the lane like classroom Indonesian with heavy pronoun drills.
- Do not assume Jakarta slang belongs in the starter pack just because travelers may hear it.
- Do not let regional address terms blur into "universal" guidance before later review.

## Script and pronunciation posture

Indonesian should be treated as a Latin-script lane with light pronunciation support, not a full transliteration problem.

What matters:

- Indonesian uses the Latin alphabet.
- Spelling is relatively phonetic compared with English.
- The main beginner friction points are not a separate script but sound expectations, especially the schwa-like `e`, the `ng` and `ny` clusters, and final consonants that may sound softer or shorter than English speakers expect.
- Older or alternate spellings may still appear in names or signs, but modern standard spelling is the right default surface.

Product recommendation:

- Show English intent, Indonesian text, and a light traveler pronunciation helper when needed.
- Do not overload every phrase with heavy phonetic notation. Most rows can keep pronunciation short and simple.
- Search should prioritize English intent, then exact Indonesian spelling, then a small set of likely traveler alias inputs.
- Prepare for common alias variation later, especially `tidak` versus `tak` or `nggak`, without teaching the most casual forms as the default starter surface.

Recommended pronunciation posture for later implementation:

- Use standard Indonesian spelling as the main target text.
- Add concise pronunciation help only where English speakers are likely to misread the word.
- Keep show-screen usefulness high because the target text itself is readable on screen even when the user does not want to attempt speech.
- Treat colloquial spellings as search or notes material first, not as the main phrasebook text.

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

No Indonesia-specific category deviation is strong enough yet to justify a new runtime seam. Indonesia-specific value should show up in phrase choice, scenario tips, and first-wave ranking instead.

High-value Indonesia emphasis by scenario:

1. Coffee Shop
   - iced or hot, less sugar, takeaway, and milk-coffee style orders
2. Street Food / Restaurant
   - not spicy, takeaway, bottled water, ingredient checks, and bill or pay-now language
3. Ride App / Taxi
   - take me here, pickup-point repair, stop here, wait a moment, and cash or in-app payment clarification
4. Asking the Price
   - how much, final price, another one, too expensive, and light bargaining where context allows
5. Polite Basics
   - hello, thank you, excuse me, sorry, yes, no thanks, and okay
6. Convenience Store
   - water, tissues, bag, receipt, SIM or top-up help, and card or cash clarification
7. Hotel / Hostel
   - reservation, check-in, checkout time, towels, air conditioning, and luggage hold
8. Directions
   - where is, near here, left, right, straight, station, port, and landmark confirmation
9. Simple Problems
   - I do not understand, slower please, I am lost, I left something behind, doctor help, and call-for-me repair
10. Small Talk
   - keep short and optional: first trip, where are you from, the food is good, and simple positive comments

## Likely reply and repair layers

Indonesian needs a practical repair layer even though the language is structurally friendly.

Future authoring should prioritize:

- yes, no, okay, not available, finished, later
- here, there, this one, that one
- numbers, prices, and time confirmations
- cash, card, transfer, and scan or QR payment clarification
- repeat please, slower please, can you write it down, can you show me, can you point
- is this correct, which gate, which exit, how many minutes, and where should I wait

This repair layer is especially important for:

- ride-hailing pickup confusion
- market and shop price checks
- ferry, station, and port navigation
- hotel requests
- food restrictions and ingredient repair

## High-risk review areas

These areas should get later native or expert review before any runtime graduation:

- medical and emergency language
- police, theft, lost-passport, and reporting language
- allergy and dietary-risk wording
- transport dispute or safety-boundary language
- payment phrases involving QRIS, transfer, deposit, or cashless misunderstandings
- regional address terms and how broadly the pack should teach them
- the point where colloquial variants should become searchable aliases without replacing the standard default text

## First starter-pack recommendation

Recommended first Indonesian starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth immediately.
- Put the highest-pressure phrases first, not broad sightseeing filler.

Suggested first-wave family priorities:

- excuse me
- thank you
- sorry
- how much is this
- please help me
- take me here
- stop here
- wait a moment
- not spicy please
- bottled water please
- I have a reservation
- what time is check out
- where is the toilet
- I do not understand
- please speak slowly
- can you write it down
- I need a doctor

## Open questions for the next lane

- How much colloquial Indonesian should appear in notes or search without weakening the standard starter surface?
- Should the first pack include one or two QRIS-specific payment rows, or is `cash / card / can I scan` enough for the first authoring wave?
- Which address terms are worth teaching early for service interactions across major tourist destinations?
- Which direction phrases should bias toward island and port travel rather than generic `city center` wording?
- How far should the first lane go on food restrictions beyond `not spicy`, `no pork`, `vegetarian`, and common allergy language?

## Sources checked

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/PRIORITIES.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - existing prep-lane files under `content-draft/tagalog/`, `content-draft/thai/`, and `content-draft/italian/`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- External references:
  - [Indonesian phrasebook - Wikivoyage](https://en.wikivoyage.org/wiki/Indonesian_phrasebook)
  - [Indonesian language - Wikipedia](https://en.wikipedia.org/wiki/Indonesian_language)
  - [Grab Indonesia transport overview](https://www.grab.com/id/en/transport/)
  - [GoBluebird in Gojek](https://www.gojek.com/en-id/gobluebird)
  - [Bank Indonesia QRIS overview](https://www.bi.go.id/en/fungsi-utama/sistem-pembayaran/ritel/kanal-layanan/QRIS/default.aspx)

## Confidence note

- High confidence: keep the shared 10-scenario skeleton; standard Indonesian is the right default lane target; the lane should stay pronunciation-light and search-friendly compared with non-Latin prep lanes.
- Medium confidence: exact first-wave phrase mix, how early to teach QR payment wording, and how much colloquial aliasing belongs in the starter search surface.
- Lower confidence until later review: emergency language, sensitive food-risk wording, and broad guidance on regional address terms.
