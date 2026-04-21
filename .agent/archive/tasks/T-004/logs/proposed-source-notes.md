# Japanese Source Notes

Current reality:

- This lane is still prep-only and is not wired into the runtime app registry.
- The shared traveler baseline remains the structural starting point, but Japan-specific prioritization is now documented.
- `first-wave-priority.csv` is the working queue for the next translation task.

## Authoring stance

- Default to polite everyday service Japanese.
- Prefer safe set phrases and `desu/masu` posture over casual/plain-form translations.
- Keep `target_text` in natural Japanese script for show-screen usefulness.
- Use `pronunciation` as traveler-friendly romaji support, not as a substitute for script.
- When kanji pronunciation could be unclear, preserve kana reading notes during authoring/review until a dedicated reading field exists.

## Phrase selection adjustments for Japan

- Keep the shared 10 scenarios, but bias authoring toward station navigation, convenience-store checkout, hotel desks, cafes, and screen-showable repair phrases.
- Treat `asking-price` as price confirmation and item-selection language, not a bargaining-heavy scenario.
- Treat `small-talk` as low priority for the first wave.
- Keep medical, police, lost-passport, and allergy content behind explicit expert-review flags.

## Scaffold lines likely to need rewriting before direct translation

- bargaining-oriented price lines such as `Can you lower it a little` and `What is your final price`
- direction lines that assume `city center` language rather than station / exit / platform language
- any line that would sound too blunt if translated literally without a polite softener
- any line that needs a stronger show-screen strategy than a spoken-first translation

## Pronunciation / search posture notes

- Traveler-facing romaji should stay ASCII-friendly and broadly Hepburn-like.
- Do not over-promise that romaji alone is enough for accurate speaking.
- English-intent retrieval should remain the primary search assumption.
- Non-Latin runtime search should be treated as a later UX/localization gate, not inherited automatically from Viet + Tagalog.

## Next content pass should

- translate the ranked first wave first
- note which rows need wording changes before translation
- capture kana readings where the natural script could hide pronunciation
- add repair-language support around `I do not understand`, `slower please`, and destination / payment confirmation
- keep high-risk phrases explicitly labeled for later native or expert review
