# France Travel Research

## Scope

- Prep-only research for a future France / French lane inside the SpeakLocal family repo.
- This document does not promote France into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. France does not need a new category model yet.
- Default the lane to France-focused polite everyday French, with `vous`-safe service wording and greeting-first openings instead of classroom-complete sentences or casual `tu`-leaning phrasing.
- Treat French as a Latin-script show-screen lane with real spelling and accents visible on every card. Use pronunciation as compact ASCII-friendly support only, not as a replacement text layer.
- Bias the first starter pack toward `bonjour` / `bonsoir`, `merci`, `excusez-moi`, `je ne comprends pas`, `plus lentement`, hotel reservation language, take me here or stop here transport help, `c'est combien ?`, card-payment checks, and bill-request wording.
- De-emphasize bargaining lines and several baseline iced-drink assumptions. France travel reality makes greetings, cafe or bakery ordering, metro or station navigation, reservation handling, and repair phrases more valuable than negotiation language.

## Destination framing

- Destination: France
- Language target: French
- Default spoken baseline for the first lane: polite everyday France-focused French for routine service interactions
- Product framing: traveler-first France support, not a general French-learning curriculum

Why this framing is the safest now:

- The family model stays destination-first, so France remains the product surface and French remains the language layer.
- France travelers will still encounter regional accents and some English availability, but the highest-value product use is fast retrieval for cafes, bakeries, trains, metro, taxis, hotels, shops, and simple repair moments.
- France-specific service expectations matter enough that the lane should not pretend generic classroom French or casual chat French is the same thing as socially safe travel phrasing.

## Traveler-use reality

France fits SpeakLocal well because many travel interactions are short, practical, and mildly formal:

- greeting a staff member before asking for help
- bakery, cafe, or counter-service ordering
- reservation confirmation, check-in, and luggage help
- metro, station, platform, and taxi destination clarification
- card-payment, receipt, and bill-request moments
- repair moments when a reply comes too quickly or the traveler misses a detail

Practical implication:

- The first France pack should optimize for greeting-first politeness, fast repair phrases, and screen-show usefulness.
- The baseline `asking-price` scenario still works, but it should lean toward price confirmation and item choice rather than haggling.
- The baseline `grab-taxi` scenario should stay in place, but France-specific authoring should also acknowledge that station and metro navigation can outrank ride-hailing in traveler stress moments.

## Politeness and register posture

French travel phrasing needs a clearer social-safety layer than several other Latin-script lanes.

What looks safe for the future lane:

- Default to polite everyday service French with `vous`-safe requests.
- Keep greeting-first openings high in the pack. `Bonjour` or `bonsoir` often comes before the real request.
- Keep `merci`, `s'il vous plaît`, `pardon`, and `excusez-moi` central because they reduce friction across cafes, stations, hotels, and shops.
- Treat casual `tu` wording as outside the first pack unless a later lane deliberately adds it for narrow use cases.

What SpeakLocal should do:

- Translate the first wave with short service-safe requests instead of literal English transfers.
- Use source notes to distinguish structural scenario decisions from phrase-level wording risks.
- Keep explicit flags on wording that depends on social tone more than direct dictionary equivalence.

What not to do:

- Do not build the lane around grammar lessons about `tu` versus `vous`.
- Do not translate blunt English scaffolds literally if France-safe service phrasing normally softens them.
- Do not assume greetings are optional filler. In France they are often part of the practical phrase itself.

## Script and pronunciation posture

French is a Latin-script lane, but pronunciation support still matters.

What matters:

- Keep real French spelling, accents, apostrophes, and spacing visible for show-screen trust.
- Many English-speaking travelers will not infer pronunciation reliably from French spelling alone.
- A pronunciation field can help with nasal vowels, silent endings, liaison-adjacent surprises, and high-frequency service phrases, but it should stay compact and forgiving rather than phonetics-heavy.

Product recommendation:

- Keep `target_text` in standard French orthography.
- Keep `pronunciation` as ASCII-friendly support for English-speaking travelers, not as a separate romanization system.
- Use pronunciation help where misreading would likely block understanding, especially on greetings, bill requests, repair phrases, and transport asks.
- Treat audio as important before runtime graduation because spelling alone will not fully solve confident speaking.

## Search and localization implications

French is easier than a non-Latin lane for display, but it still needs an honest retrieval plan.

Recommendation for later implementation:

- Keep English-intent search as the primary retrieval path.
- Preserve full French spelling in authored content and show-screen surfaces.
- Add accent-insensitive matching as a helper only.
- Keep likely traveler aliases visible in planning notes, especially when English speakers may search for `bathroom`, `ticket`, `platform`, `receipt`, `check in`, or `bill`.
- Do not claim runtime search behavior is already solved just because the lane uses Latin script.

High-value retrieval concepts to keep visible in later authoring notes:

- `bonjour`
- `bonsoir`
- `s'il vous plaît`
- `l'addition`
- `carte`
- `ticket`
- `quai`
- `gare`
- `metro`
- `toilettes`

## Repair-layer and likely-reply opportunities

French should ship with a strong repair layer because many travel problems come from fast replies or missing the expected opener.

Future authoring should prioritize:

- I do not understand
- Please speak a little slower
- Please say it again
- Excuse me
- Take me here
- You can stop here
- I have a reservation
- I would like to check in
- Can I pay by card
- The bill please
- Is it near here
- Which platform
- I am lost
- Please call for me
- I need a doctor

This repair layer matters most for:

- hotel front desks
- train and metro navigation
- bakery and cafe counters
- small shops and pharmacies
- taxi rides

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

France-specific value should appear in tip copy, quick-phrase ranking, rewrite notes, and phrase prioritization rather than a new runtime seam.

High-value France emphasis by scenario:

1. Coffee Shop
   - cafe or bakery counter ordering, simple coffee or pastry asks, takeaway, water, and bill-request posture
2. Street Food / Restaurant
   - treat this as cafe, brasserie, takeaway, and casual restaurant language more than literal street-food-only coverage
3. Ride App / Taxi
   - take me here, stop here, station or hotel routing, payment clarity, and destination-screen support
4. Asking the Price
   - how much, which one, item choice, price confirmation, not bargaining
5. Polite Basics
   - hello, thank you, excuse me, sorry, no thank you, goodbye
6. Convenience Store
   - water, bag, receipt, card payment, sunscreen, simple item-finding help
7. Hotel / Hostel
   - reservation, check in, check out, luggage hold, room issue reporting
8. Directions
   - station, metro, platform, near here, walk time, left or right confirmation
9. Simple Problems
   - I do not understand, slower please, I am lost, call for me, doctor escalation
10. Small Talk
   - keep light and secondary; practical travel utility should be authored first

## High-risk review areas

These areas need later native or expert review before runtime graduation:

- `tu` versus `vous` drift on anything more complex than short service-safe requests
- bill, complaint, and room-problem wording that can sound too blunt
- medical and emergency wording
- police, theft, and lost-passport language
- allergy or ingredient-risk wording
- transport wording that may need platform, line, or ticket-specific rewrites instead of literal baseline translations
- pronunciation shortcuts that help English speakers without teaching brittle habits

## First starter-pack recommendation

Recommended first France starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth.
- Put greeting, repair, transport, hotel, payment, and bill-request phrases first, then add cafe and small-talk coverage after the repair layer is solid.

Suggested first-wave family priorities:

- hello
- thank you
- excuse me
- no thank you
- take me here
- you can stop here
- how much is this
- I do not understand
- please speak a little slower
- I have a reservation
- I would like to check in
- can I pay by card
- the bill please
- a bottle of water please
- where are the toilets
- is it near here
- which platform
- I am lost
- please call for me
- I need a doctor

## Open questions for the next lane

- Which baseline coffee rows should be rewritten toward France-first coffee or bakery asks before direct translation?
- Which transport rows should shift from generic `city center` language toward station, line, or platform help?
- How much pronunciation support is enough for nervous English-speaking travelers before audio exists?
- Should a small pharmacy subset outrank some cafe or small-talk rows in the first starter pack?
- Which bill and card-payment source sentences should be rewritten before translation so the lane does not inherit awkward literal English framing?

## Evidence and reasoning inputs

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/PRIORITIES.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - `content-draft/tagalog/README.md`, `content-draft/tagalog/source-notes.md`, and `content-draft/tagalog/scenario-plan.json` as prep-lane shape references required by the task spec
  - `content-draft/viet/README.md` as current live-lane structure context
  - existing Spain and Italy prep-lane artifacts under `research/language-pipeline/spanish/**`, `research/language-pipeline/italian/**`, `content-draft/spanish/**`, and `content-draft/italian/**`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- Stable synthesis inputs:
  - general travel-language knowledge about France-focused service interactions, greeting-first politeness, transport friction, and pronunciation difficulty for English speakers

## Confidence note

- High confidence: keep the shared 10-scenario skeleton, use France-focused polite everyday French, keep real spelling visible, and de-prioritize bargaining.
- Medium confidence: the exact first-wave mix between cafe, station, hotel, payment, and pharmacy or medical coverage.
- Lower confidence until later review: emergency, allergy, complaint, and pronunciation edge cases, plus any line where `tu` versus `vous` could materially change tone.
