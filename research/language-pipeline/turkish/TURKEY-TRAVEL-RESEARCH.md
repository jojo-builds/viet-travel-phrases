# Turkey Travel Research

## Scope

- Prep-only research for a future Turkey / Turkish lane inside the SpeakLocal family repo.
- This document does not promote Turkey into runtime wiring.
- Goal: leave behind durable direction for later phrase authoring, pronunciation design, and search planning.

## Executive recommendation

- Keep the shared 10-scenario traveler skeleton. Turkey does not need a new category model yet.
- Default the lane to everyday standard Turkish with polite service-safe wording instead of clipped command forms.
- Treat Turkish as an easier script lane than Thai or Japanese because it uses a Latin-based alphabet, but do not treat it as search-trivial: dotted and dotless `i`, plus letters such as `c` (English `j` sound), `c-cedilla`, `g-breve`, `o-umlaut`, `s-cedilla`, and `u-umlaut`, still need explicit traveler help and locale-aware matching.
- Bias the first starter pack toward polite openers, price checks, taxi routing, hotel check-in, water and payment, and repair phrases such as "I do not understand" and "Please speak a little slower."
- Keep a small bargaining layer because Turkish travel reality includes bazaars and some price negotiation, but do not let bargaining crowd out higher-frequency everyday service phrases.

## Destination framing

- Destination: Turkey
- Language target: Turkish
- Default spoken baseline for the first lane: everyday standard Turkish appropriate for routine service encounters
- Product framing: traveler-first Turkey support, not a general Turkish-learning curriculum

Why this framing is the safest now:

- The family model stays destination-first, so Turkey remains the product surface and Turkish remains the language layer.
- Standard Turkish is the safest national baseline for travelers moving between Istanbul, airport zones, hotels, cafes, shops, and transport hubs.
- The biggest traveler value is fast, polite utility in common service moments rather than full grammar progression.

## Traveler-use reality

Turkey fits the SpeakLocal model well because many travel interactions are short, practical, and slightly stressful:

- hotel check-in and reservation confirmation
- taxi, airport transfer, and map-show routing
- cafe, bakery, and casual restaurant ordering
- small-shop and bazaar price checks
- convenience-store purchases such as water, tissues, chargers, and receipts
- station, tram, ferry, and landmark directions

Practical implication:

- The first Turkey pack should optimize for speed and confidence, not textbook completeness.
- Travelers will often show the phone screen after trying to speak, so Turkish script should stay visible on every phrase card.
- Payment and transit utility deserve early attention. Istanbul's official `Istanbulkart` surfaces show how central card and QR-based transport/payment flows are in daily movement, which supports keeping payment-confirmation phrases high in the starter pack.

Inference note:

- The exact balance of English availability varies by city, neighborhood, and venue. The repo's traveler-first positioning still points to the same product need: short Turkish phrases help most when a worker is busy, the interaction is fast, or the user wants to sound respectful before switching to gestures or English.

## Politeness and register posture

Turkish does not need the same script or tone training burden as Thai, but polite wording still matters.

What looks safe for the future lane:

- Default to polite everyday phrases rather than bare imperatives.
- Treat `merhaba`, `tesekkur ederim`, `lutfen`, `pardon`, and `affedersiniz` style language as high-value starter material.
- Prefer softer question forms and request wording in translation rather than command-like English-to-Turkish literal transfers.
- Keep the first pack friendly and service-usable instead of overly formal.

What SpeakLocal should do:

- Translate the first wave with polite service-safe wording by default.
- Keep English intent simple while letting the Turkish surface carry the necessary softening.
- Use notes or review flags when a scaffold line could sound too blunt, too formal, or too negotiation-heavy.

What not to do:

- Do not build the lane around etiquette performance or long social formulas.
- Do not overfit to slangy greetings or hyper-formal written Turkish.
- Do not assume that a literal direct translation of every English scaffold line will sound natural in Turkish service contexts.

## Script and pronunciation posture

Turkish has a major prep-lane advantage: it uses a Latin-based alphabet and spelling is relatively phonetic. That should make the speak-first surface more approachable than Thai or Japanese, but the lane still needs explicit pronunciation design.

What matters:

- The Turkish alphabet has 29 letters, officially based on Latin letters.
- English-speaking travelers still need help with `c` (English `j` sound), `c-cedilla`, `g-breve`, `o-umlaut`, `s-cedilla`, `u-umlaut`, and especially dotted vs dotless `i`.
- Turkish spelling is regular enough that a good pronunciation layer can be compact and useful instead of academically dense.

Product recommendation:

- Keep `target_text` in real Turkish orthography with full Turkish characters.
- Keep `pronunciation` as a traveler-friendly ASCII aid rather than trying to flatten the display text itself.
- Add short note guidance for the highest-friction letters:
  - `c` sounds like English `j`
  - `c-cedilla` sounds like English `ch`
  - `s-cedilla` sounds like English `sh`
  - `g-breve` usually lengthens or softens the vowel
  - dotted `i` and dotless `i` are different letters and should not be collapsed casually

Confidence note:

- High confidence: Turkish should keep full Turkish spelling visible and will benefit from a lightweight pronunciation layer.
- Medium confidence: the exact future pronunciation normalization rules for `g`, vowel length, and stress hints.
- Lower confidence until later review: which shortcuts are easiest for English speakers without teaching bad habits.

## Search and localization implications

Turkish is Latin-script, but it still needs a real localization/search plan.

Recommendation for later implementation:

- Keep English-intent search as the primary retrieval path.
- Preserve real Turkish spelling in authored content and show-screen surfaces.
- Add stripped-diacritic aliases only as helpers, not as the canonical phrase text.
- Treat dotted/dotless `i` as a real matching risk. W3C and Unicode guidance both call out Turkic case-mapping differences, so future search or normalization work must not assume English-style case folding.

What this means for the prep lane:

- Translation can start without a runtime search implementation.
- The backlog should explicitly keep a Turkish casing and alias review item before graduation.
- Authoring notes should flag phrases whose usefulness depends on destination names or proper nouns that could be searched with the wrong `i` variant.

## Repair-layer and likely-reply opportunities

Turkish should ship with a strong repair layer because many traveler problems are not about missing a noun; they are about managing a fast reply.

Future authoring should prioritize:

- I do not understand
- Please speak a little slower
- Please say it again
- Here / this one / that one
- Card or cash confirmation
- Stop here
- Is it near here
- How long on foot
- Please call for me
- Doctor / pharmacy escalation

This repair layer matters most for:

- taxi and transfer confusion
- shop and restaurant payment
- directions near tram, metro, and ferry links
- hotel desk troubleshooting
- everyday service interactions when the traveler is tired or flustered

## Scenario skeleton recommendation

Recommendation: keep the shared 10-scenario baseline unchanged in structure.

Turkey-specific value should appear in tip copy, quick-phrase ranking, and phrase prioritization rather than a new runtime seam.

High-value Turkey emphasis by scenario:

1. Coffee Shop
   - Turkish tea or coffee orders, sugar, takeaway, quick payment
2. Street Food / Restaurant
   - one portion, takeaway, bottled water, spice caution, simple ordering
3. Ride App / Taxi
   - take me here, stop here, route confirmation, payment method, later meter-focused additions
4. Asking the Price
   - how much, final price, compare options, light bargaining only where normal
5. Polite Basics
   - hello, thank you, excuse me, sorry, no thank you
6. Convenience Store
   - water, bag, tissues, charger, receipt, card-or-cash confirmation
7. Hotel / Hostel
   - reservation, check-in, checkout time, AC problems, luggage hold
8. Directions
   - near here, walk time, landmark or station routing, map-supported clarification
9. Simple Problems
   - I do not understand, slower please, I am lost, call for me, doctor escalation
10. Small Talk
   - keep light and secondary; compliments and first-visit chat are enough for the first wave

## High-risk review areas

These areas need later native or expert review before runtime graduation:

- medical and emergency wording
- police, theft, and lost-passport language
- allergy or ingredient-risk wording
- taxi, fare, or bargaining disputes
- phrase softening where English scaffold lines are too direct
- pronunciation shortcuts for dotted/dotless `i` and `g`

## First starter-pack recommendation

Recommended first Turkish starter pack shape:

- Keep the family 10-scenario structure.
- Start with roughly 60-90 high-confidence families rather than trying to match Viet depth.
- Put high-pressure service phrases first, then add lighter food and small-talk coverage after the repair layer is solid.

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
- a bottle of water please
- not spicy please
- no sugar please
- to go
- what time is check out
- what is your final price
- is it near here
- how long on foot
- I am lost
- please call for me
- I need a doctor

## Open questions for the next lane

- Which scaffold lines should be rewritten before translation to sound more natural in Turkish service contexts?
- How explicit should the future pronunciation layer be about `g`, stress, and vowel quality without overwhelming the user?
- Which bargaining phrases are genuinely worth starter-pack space versus being better handled later?
- Should the first repair mini-set add Turkey-specific transit phrases such as "Which stop?" or "Which platform?" before runtime graduation?
- What is the safest minimal allergy and medical subset for the first Turkish pack?

## Sources checked

- Repo sources:
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/PRIORITIES.md`
  - `templates/FAMILY_TRAVELER_BASELINE.json`
  - current Turkish prep files under `content-draft/turkish/`
  - `research/language-pipeline/thai/THAI-TRAVEL-RESEARCH.md`
  - `research/language-pipeline/japanese/JAPAN-TRAVEL-RESEARCH.md`
  - `research/exec-summary.md`
  - `research/competitor-pain-analysis-2026-04-01.md`
- External references:
  - Turkish Language Association (TDK): `Ses, Harf ve Alfabe` - https://tdk.gov.tr/icerik/yazim-kurallari/ses-harf-ve-alfabe/
  - W3C Character Model, Turkic case-folding examples - https://www.w3.org/TR/charmod-norm/
  - Unicode FAQ on Turkish case mappings - https://www.unicode.org/faq/casemap_charprop.html
  - GoTurkiye greeting guide - https://goturkiye.com/blog/10-ways-to-say-hello-goodbye-in-the-most-hospitable-country-in-the-world
  - Istanbulkart official product and mobile surfaces - https://www.istanbulkart.istanbul/ourcards/ and https://www.istanbulkart.istanbul/istanbulkartMobile/

## Confidence note

- High confidence: keep the shared 10-scenario skeleton, use everyday polite standard Turkish, and treat Turkish orthography plus pronunciation as a manageable but real product surface.
- Medium confidence: the final first-wave phrase mix and the exact pronunciation normalization choices.
- Lower confidence until later review: emergency, allergy, bargaining-dispute, and pronunciation edge cases.
