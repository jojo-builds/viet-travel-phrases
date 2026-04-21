# Spain Travel Research

## Scope

- Prep-only research for a future Spain / Spanish lane inside the SpeakLocal family repo.
- This document does not promote Spain into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. Spain does not need a new category model yet.
- Default the lane to standard Spain-focused traveler Spanish with polite everyday request wording instead of generic all-Spanish-world phrasing.
- Treat Spanish as a friendly Latin-script lane for search and display, but keep correct orthography with accents and `ñ` visible on every card.
- Bias the first starter pack toward excuse me / thank you / take me here / how much is this / I do not understand / slower please / reservation / check in / can I pay by card / bill request.
- De-emphasize bargaining language. Spain's official tourism guidance says marked prices are not haggled, so price-confirmation and item-selection phrases outrank negotiation lines.

## Destination framing

- Destination: Spain
- Language target: Spanish
- Default spoken baseline for the first lane: standard Spain-focused traveler Spanish for routine service interactions
- Product framing: traveler-first Spain support, not a general Spanish-learning curriculum

Why this framing is the safest now:

- The family model stays destination-first, so Spain remains the product surface and Spanish remains the language layer.
- Spain travel utility is concentrated in bars, cafes, shops, train stations, hotels, taxis, and quick repair moments, which fits the current SpeakLocal structure well.
- Spain-specific wording matters enough that the lane should not pretend neutral "world Spanish" is the same thing as Spain travel phrasing.

## Traveler-use reality

Spain fits the SpeakLocal model because many high-value traveler interactions are short, practical, and slightly rushed:

- hotel check-in and reservation confirmation
- taxis and ride pickups
- cafe or bar counter ordering
- quick purchases and card-payment confirmation
- train and metro navigation
- asking for the bill, directions, or help repeating something

Official tourism guidance from Spain.info makes three lane-shaping points especially relevant:

- Spain's practical-language page highlights the same retrieval intents travelers will reach for first: reservation, taxi, train, bus station, airport, hospital, emergency, menu, price, cash, and credit card.
- Spain.info says card payment is widespread and notes that some machine payments may require a card, which makes `Can I pay by card` a first-wave phrase rather than filler.
- The same money guidance says marked prices are not haggled, which pushes bargaining rows down the queue and turns `asking-price` into a price-confirmation lane instead of a negotiation lane.

Inference from those sources:

- The Spain lane should optimize for payment clarity, directions, hotel check-in, and bill / receipt language.
- A Spain starter pack should not spend early slots on bargain-heavy or tourist-market stereotypes when transport, cafes, and card payment are more frequent and more defensible.

## Politeness and regional/localization posture

Spain does not need the script-heavy guidance of Japanese, but it still needs a clear country stance.

What looks safe for the future lane:

- Default to polite everyday requests instead of stiff textbook phrasing.
- Keep the first wave centered on service-safe words such as `gracias`, `por favor`, and `perdón` / `disculpe`.
- Use Spain-oriented vocabulary when variant choice matters.
- Avoid over-teaching plural forms early. RAE notes that `vosotros` is the informal plural used in most of Spain, but the first travel wave is mostly singular requests, so the lane does not need plural-conjugation complexity up front.

What SpeakLocal should do:

- Translate the first wave with short, courteous, traveler-usable wording.
- Keep English intent simple while letting the Spanish side carry the necessary naturalness.
- Use notes and review flags when a source line feels too Latin-America-generic, too blunt, or too negotiation-heavy for Spain.

What not to do:

- Do not build the lane around grammar explanations.
- Do not overfit to `vosotros` teaching just because it is a Spain marker.
- Do not let the lane drift into "generic Spanish phrases" without checking whether the most natural Spain wording is different.

## Script and pronunciation posture

Spanish is easier than Turkish or Japanese from a character-set standpoint, but the lane still needs explicit authoring guidance.

What matters:

- Spanish orthography is familiar to English-speaking travelers, but accents and `ñ` still matter for show-screen trust and later search quality.
- Travelers can often attempt Spanish from spelling alone, but the pronunciation layer still helps with `j`, rolled `r`, `ll` / `y`, and regionally varying `c` / `z` sounds.
- Spain is still a script-visible lane, not an ASCII-only lane.

Product recommendation:

- Keep `target_text` in full Spanish spelling with accents and `ñ`.
- Keep `pronunciation` as a lightweight traveler-facing support field rather than a replacement for Spanish orthography.
- Keep pronunciation guidance practical. Travelers need something easy to say under pressure, not a full phonetics lesson.
- Avoid overcommitting to a single "correct" regional sound for every Spain variant issue in the prep lane; aim for broadly understandable Spain travel Spanish first.

## Search and localization implications

Spanish is a lower-risk search lane than Japanese, but it still needs a real plan.

Recommendation for later implementation:

- Keep English-intent search as the primary retrieval path.
- Add accent-insensitive matching as a helper, not as the canonical text surface.
- Preserve Spain-specific retrieval vocabulary when it improves traveler utility.
- Keep the runtime graduation gate honest: Spain is easier than Japanese, but search and localization still need review before runtime wiring.

High-value retrieval concepts to keep visible in authoring notes:

- `tarjeta`
- `billete`
- `estación`
- `metro`
- `baño`
- `para llevar`
- bill-request wording such as `la cuenta`

## Repair-layer and likely-reply opportunities

Spanish should ship with a strong repair layer because many travel problems are not vocabulary gaps so much as fast replies.

Future authoring should prioritize:

- I do not understand
- Please speak a little slower
- Please say it again
- Is it near here
- How long on foot
- Take me here
- Stop here
- Can I pay by card
- Please give me the receipt
- I have a reservation
- Please call for me
- I need a doctor

This repair layer matters most for:

- hotel front desks
- train and metro navigation
- cafe and bar counters
- shops and kiosks
- taxi rides

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

Spain-specific value should appear in tip copy, quick-phrase ranking, and phrase prioritization rather than a new runtime seam.

High-value Spain emphasis by scenario:

1. Coffee Shop
   - bar or cafe counter ordering, takeaway, sugar, water, bill request
2. Street Food / Restaurant
   - treat this as bar / tapas / casual restaurant language, not literal street-food-only coverage
3. Ride App / Taxi
   - take me here, stop here, payment clarity, old-town or hotel drop-off help
4. Asking the Price
   - how much, which one, item choice, not bargaining
5. Polite Basics
   - excuse me, thank you, sorry, no thank you
6. Convenience Store
   - water, bag, receipt, card payment, basic item-finding help
7. Hotel / Hostel
   - reservation, check in, check out, luggage hold, room issue reporting
8. Directions
   - station, metro, near here, walk time, map-supported clarification
9. Simple Problems
   - I do not understand, slower please, I am lost, call for me, doctor escalation
10. Small Talk
   - keep light and optional; practical travel utility should be authored first

## High-risk review areas

These areas need later native or expert review before runtime graduation:

- medical and emergency wording
- police, theft, and lost-passport language
- allergy or ingredient-risk wording
- bill / complaint phrasing that could sound too direct
- directions rows where the English scaffold should be rewritten before translation
- any source line that still looks shaped for non-Spain bargaining behavior

## First starter-pack recommendation

Recommended first Spain starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth.
- Put high-pressure service phrases first, then add lighter restaurant and small-talk coverage after the repair layer is solid.

Suggested first-wave family priorities:

- excuse me / sorry
- thank you
- take me here
- how much is this
- I do not understand
- please speak a little slower
- I have a reservation
- I would like to check in
- can I pay by card
- you can stop here
- is it near here
- how long on foot
- a bottle of water please
- to go
- the bill / let me pay
- please give me the receipt
- I am lost
- please call for me
- I need a doctor

## Open questions for the next lane

- Which bill-request wording should replace `Please let me pay` before translation?
- Which directions rows should become station / metro / platform source sentences before the next pass?
- How much explicit pronunciation support is actually needed for English-speaking travelers before audio is present?
- Does the first starter pack need a small pharmacy / medicine mini-set before runtime graduation?
- Which Spain-specific vocabulary choices should be locked now versus left flexible until native review?

## Sources checked

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/PRIORITIES.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - current Spanish prep files under `content-draft/spanish/`
  - `research/language-pipeline/japanese/JAPAN-TRAVEL-RESEARCH.md`
  - `research/language-pipeline/turkish/TURKEY-TRAVEL-RESEARCH.md`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- External references:
  - Spain.info practical information: https://www.spain.info/en/info/
  - Spain.info language page: https://www.spain.info/en/travel-tips/languages/
  - Spain.info money page: https://www.spain.info/en/travel-tips/coins-banknotes/
  - Renfe stations overview: https://www.renfe.com/es/en/inspirate/estaciones
  - RAE on `vosotros`: https://www.rae.es/dpd/vosotros

## Confidence note

- High confidence: keep the shared 10-scenario skeleton, use standard Spain-focused traveler Spanish, and move bargaining rows down.
- Medium confidence: the final first-wave phrase mix and the exact bill / directions rewrites.
- Lower confidence until later review: emergency, allergy, complaint, and pronunciation edge cases.
