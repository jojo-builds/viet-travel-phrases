# Portugal Travel Research

## Scope

- Prep-only research for a future Portugal / European Portuguese lane inside the SpeakLocal family repo.
- This document does not promote Portugal into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. Portugal does not need a new category model yet.
- Default the lane to Portugal-focused European Portuguese, not generic Portuguese and not Brazil-first wording.
- Keep the lane traveler-first: greetings, repair phrases, cafe or pastelaria asks, hotel help, transit or taxi routing, card or cash checks, bathroom help, and bill requests should outrank classroom grammar or light small talk.
- Keep real Portuguese spelling in later `target_text` surfaces and treat pronunciation as compact helper support only; audio should stay an explicit graduation blocker because European Portuguese can be hard for English-speaking travelers to infer from spelling alone.
- De-emphasize bargaining and over-customized drink language. Portugal travel reality makes polite openings, transport clarity, simple ordering, and repair language more valuable than negotiation-heavy lines.

## Destination framing

- Destination: Portugal
- Language target: Portuguese
- Default spoken baseline for the first lane: polite everyday European Portuguese for routine travel and service interactions
- Product framing: traveler-first Portugal support, not a general Portuguese-learning curriculum

Why this framing is the safest now:

- The family model stays destination-first, so Portugal remains the product surface and Portuguese remains the language layer.
- Portugal travelers are more likely to need fast retrieval for cafes, bakeries, metro or train stations, taxis, hotels, shops, and pharmacy-adjacent help than broad conversational coverage.
- European Portuguese posture matters enough that the lane should not quietly inherit Brazil-first vocabulary or tone.

## Traveler-use reality

Portugal fits SpeakLocal well because many tourist interactions are short, practical, and mildly formal:

- greeting staff before a request
- ordering at a cafe, bakery, or casual counter
- asking for water, takeaway, or the bill
- confirming a reservation, check-in, or luggage help
- handling train, metro, bus, airport, or taxi routing
- checking whether card payment works and asking for a receipt
- asking for the bathroom, slower speech, repetition, or basic help when lost

Practical implication:

- The first Portugal starter pack should optimize for greeting-first politeness, repair phrases, transit clarity, and screen-show usefulness.
- The baseline `asking-price` scenario still works, but it should lean toward marked-price confirmation and item choice rather than bargaining.
- The baseline `street-food` and `coffee-shop` scenarios still work, but Portugal drafting should skew toward cafe, pastelaria, snack bar, and casual restaurant reality instead of street-market negotiation or heavy iced-drink customization.

## Politeness and register posture

European Portuguese travel phrasing needs an explicitly safe register posture.

What looks safest for the future lane:

- Default to polite everyday service Portuguese, not slang-heavy or classroom-complete sentences.
- Keep greeting-first openings high in the pack. `Bom dia`, `boa tarde`, and `boa noite` are practical utility, not filler.
- Keep `por favor`, `desculpe`, `com licenca`, and thank-you wording central because they reduce friction across cafes, transport, hotels, and shops.
- Keep explicit notes that thank-you wording can vary with speaker gender (`obrigado` / `obrigada`) so the lane does not pretend there is no choice at all.

What SpeakLocal should do:

- Translate the first wave with short service-safe requests rather than literal English transfers.
- Keep explicit review flags on wording where tone, directness, or region-specific vocabulary could matter.
- Preserve Portugal-first wording even when a Brazil-leaning term would be more globally familiar.

What not to do:

- Do not let the lane drift into generic Portuguese with mixed Portugal and Brazil vocabulary.
- Do not over-teach grammar or pronoun systems in the prep layer.
- Do not translate blunt English scaffolds literally if a short softer service phrase is more natural.

## Script and pronunciation posture

Portuguese is a Latin-script lane, but pronunciation support still matters.

What matters:

- Keep real Portuguese spelling visible in later authored content for show-screen trust.
- Many English-speaking travelers will not infer European Portuguese pronunciation reliably from spelling alone.
- European Portuguese can compress or reduce unstressed vowels enough that audio and compact pronunciation support matter more than a traveler may expect from a Latin-script language.

Product recommendation:

- Keep `target_text` in standard Portuguese orthography during later authoring.
- Keep `pronunciation` as ASCII-friendly helper support for English-speaking travelers, not as a substitute for real Portuguese spelling.
- Use pronunciation help where misreading would likely block understanding, especially on greetings, repair phrases, transit asks, bill requests, and bathroom help.
- Treat audio as important before runtime graduation because spelling alone will not fully solve confident speaking.

## Search and localization implications

Portugal should stay English-intent first, but the lane needs Portugal-specific alias planning.

Recommendation for later implementation:

- Keep English-intent search as the primary retrieval path.
- Preserve real Portuguese spelling in authored content and show-screen surfaces.
- Add accent-insensitive matching only as a helper.
- Keep likely traveler aliases visible in planning notes, especially for `bathroom`, `bill`, `receipt`, `card`, `ATM`, `train`, `platform`, `station`, `takeaway`, and `pharmacy`.
- Keep Portugal-first vocabulary visible in later drafting instead of assuming broader Lusophone synonyms will be safe enough.

High-value retrieval concepts to keep visible in later authoring notes:

- `bom dia`
- `boa tarde`
- `obrigado` / `obrigada`
- `por favor`
- `desculpe`
- `com licenca`
- `casa de banho`
- `conta`
- `fatura`
- `cartao`
- `multibanco`
- `comboio`
- `metro`
- `estacao`

## Repair-layer and likely-reply opportunities

Portuguese should ship with a strong repair layer because many travel problems come from a quick reply or from European Portuguese being harder to parse by ear than travelers expect.

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
- Where is the bathroom
- Is it near here
- Which platform
- I am lost
- Please call for me
- I need a doctor

This repair layer matters most for:

- hotel front desks
- train and metro navigation
- cafe or bakery counters
- small shops and pharmacies
- taxi rides

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

Portugal-specific value should appear in tip copy, quick-phrase ranking, rewrite notes, and phrase prioritization rather than a new runtime seam.

High-value Portugal emphasis by scenario:

1. Coffee Shop
   - cafe or pastelaria ordering, water, takeaway, and bill-request posture
2. Street Food / Restaurant
   - treat this as cafe, snack bar, takeaway, and casual restaurant language more than literal street-food-only coverage
3. Ride App / Taxi
   - take me here, stop here, station or hotel routing, payment clarity, and destination-screen support
4. Asking the Price
   - how much, item choice, price confirmation, not bargaining
5. Polite Basics
   - greetings, thank you, excuse me, no thank you, goodbye
6. Convenience Store
   - water, bag, receipt, card payment, simple item-finding help, bathroom-location adjacency where relevant
7. Hotel / Hostel
   - reservation, check in, check out, luggage hold, room issue reporting
8. Directions
   - station, metro, near here, walk time, left or right confirmation, platform or stop clarification
9. Simple Problems
   - I do not understand, slower please, I am lost, call for me, doctor escalation
10. Small Talk
   - keep light and secondary; practical travel utility should be authored first

## High-risk review areas

These areas need later native or expert review before runtime graduation:

- Portugal versus Brazil vocabulary drift
- thank-you wording and any other phrase where speaker-gender posture matters
- bill, complaint, and room-problem wording that can sound too blunt
- medical and emergency wording
- police, theft, and lost-passport language
- allergy or ingredient-risk wording
- transport wording that may need platform, stop, or ticket-specific rewrites instead of literal baseline translations
- pronunciation shortcuts that help English speakers without teaching brittle habits

## First starter-pack recommendation

Recommended first Portugal starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth.
- Put greeting, repair, transport, hotel, payment, bathroom, and bill-request phrases first, then add cafe and small-talk coverage after the repair layer is solid.

Suggested first-wave family priorities:

- hello / good morning
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
- where is the bathroom
- is it near here
- which platform
- I am lost
- please call for me
- I need a doctor

## Open questions for the next lane

- Which baseline coffee rows should be rewritten toward Portugal-first cafe or pastelaria asks before direct translation?
- Which transport rows should shift from generic `city center` language toward station, platform, stop, or airport help?
- How much pronunciation support is enough for nervous English-speaking travelers before audio exists?
- Should pharmacy and bathroom help outrank some convenience-store or small-talk rows in the first starter pass?
- Which bill, receipt, and card-payment source sentences should be rewritten before translation so the lane does not inherit awkward literal English framing?

## Evidence and reasoning inputs

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/PRIORITIES.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - `content-draft/tagalog/README.md`
  - `content-draft/tagalog/source-notes.md`
  - `content-draft/viet/README.md`
  - `content-draft/french/README.md`
  - `content-draft/french/source-notes.md`
  - `content-draft/french/scenario-plan.json`
  - `content-draft/french/research-backlog.md`
  - `research/language-pipeline/french/FRANCE-TRAVEL-RESEARCH.md`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- Stable synthesis inputs:
  - general travel-language knowledge about Portugal-focused service interactions, European Portuguese versus Brazil-first vocabulary drift, and traveler pronunciation difficulty

## Confidence note

- High confidence: keep the shared 10-scenario skeleton, keep the lane prep-only, default to Portugal-focused European Portuguese, and de-prioritize bargaining.
- Medium confidence: the exact first-wave mix between cafe, transit, hotel, pharmacy, and bathroom coverage.
- Lower confidence until later review: emergency, allergy, complaint, and pronunciation edge cases, plus any line where Portugal versus Brazil vocabulary drift could materially change how natural the phrase sounds.
