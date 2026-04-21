# Portuguese Source Notes

Current reality:

- This lane is still prep-only and is not wired into the runtime app registry.
- The shared traveler baseline remains the structural starting point, but Portugal-specific prioritization is now documented.
- No `phrase-source.csv` or first-wave shortlist exists yet, so this file should guide the next drafting pass.

## Authoring stance

- Default to Portugal-focused polite everyday European Portuguese for service encounters.
- Keep the lane explicit about Portugal-first wording instead of generic Portuguese that may drift toward Brazil defaults.
- Keep `target_text` in natural Portuguese spelling for show-screen usefulness.
- Use `pronunciation` as compact ASCII-friendly support, not as a substitute for real Portuguese text.
- Keep phrases short, greeting-aware, and service-usable rather than textbook-complete.

## Phrase selection adjustments for Portugal

- Keep the shared 10 scenarios, but bias authoring toward greetings, repair phrases, cafe or pastelaria ordering, train or metro navigation, hotel handling, payment, bathroom help, and bill requests.
- Treat `street-food` as cafe, snack-bar, takeaway, and casual restaurant language rather than literal street-food-only coverage.
- Treat `asking-price` as price confirmation and item choice, not a bargaining-heavy scenario.
- Treat `small-talk` as low priority for the first wave.
- Keep medical, police, lost-passport, and ingredient-risk content behind explicit expert-review flags.

## Structural scenario notes versus phrase-level wording risks

Structural scenario notes:

- Keep the baseline scenario order unless a later authoring task proves a minor Portugal-specific emphasis change worth documenting.
- `grab-taxi` stays in the shared seam, but Portugal drafting should also favor station, airport, hotel, and stop-adjacent routing language inside that travel surface.
- `directions` should skew toward stations, metro, bus stops, and nearby landmarks more than generic city-center wording.

Phrase-level wording risks:

- Portugal versus Brazil vocabulary drift on everyday travel nouns
- thank-you wording where speaker gender may matter
- greeting-first openings that may need source rewrites before direct translation
- bill-request wording that is likely better as a short natural service ask than a literal transfer of `Please let me pay`
- some coffee rows that are too tied to iced customization rather than Portugal-first cafe or bakery reality
- card, ATM, receipt, and bathroom wording that may need Portugal-specific choices before translation

## Scaffold lines likely to need rewriting before direct translation

- bargaining-oriented price lines such as `Can you lower it a little` and `What is your final price`
- bill-request lines such as `Please let me pay`
- direction lines that assume `city center` wording instead of station, stop, airport, or landmark help
- coffee rows that are too tied to iced customization rather than Portugal-first counter ordering
- any line whose safest Portuguese phrasing depends on a softer request shape rather than a literal English transfer

## Pronunciation and search posture notes

- Traveler-facing pronunciation should stay ASCII-friendly and compact.
- Add pronunciation help where Portuguese spelling would likely mislead English speakers in high-pressure moments.
- English-intent retrieval should remain the primary search assumption.
- Future runtime search should accept accent-insensitive lookup only as a helper while keeping full Portuguese spelling visible on cards.
- Keep likely traveler aliases visible in later drafting for `bathroom`, `bill`, `receipt`, `card`, `ATM`, `train`, `platform`, `station`, and `takeaway`.

## Starter-pack posture

- The first Portugal starter pack should prioritize greetings, repair phrases, transport, hotel, payment, bathroom help, bill requests, and a few water or cafe basics.
- Keep small talk and low-value food customization behind the first repair or logistics layer.
- Keep every candidate starter row labeled either `high-confidence-core`, `rewrite-before-translation`, or `expert-review-needed` once the shortlist exists.

## Next content pass should

- create a ranked first-wave shortlist before translation starts
- rewrite the flagged bargaining, bill-request, and directions rows before translating them literally
- add practical pronunciation guides for high-frequency Portugal service phrases
- note which medical, allergy, and complaint lines need later expert review
- decide the honest short-term audio posture before runtime wiring
