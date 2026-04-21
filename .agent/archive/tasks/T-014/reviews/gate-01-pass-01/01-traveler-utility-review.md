Decision: APPROVE

Rationale:
The planned approach is aligned with traveler utility and with the prep-only contract. The ranked first wave is correctly centered on polite basics, repair language, hotel check-in, transport, payment, and a few fast purchase phrases. The lane notes also already enforce the right discipline: keep runtime wiring untouched, rewrite weak Italy-fit source before literal translation, and keep pronunciation as support rather than replacing real Italian text.

Concrete risks:
- `Excuse me sorry` is a top-row utility phrase, but it merges two intents that may not want one Italian rendering.
- `To go` and `One portion please` can be useful, but they are less universal in Italy than the hotel / transport / repair rows around them and should not get more polish than those rows.
- `I need a doctor` is worth keeping in wave one, but traveler utility drops if the pass hides uncertainty instead of preserving the expert-review flag.

Concrete adjustments:
- Treat ambiguous top rows as rewrite-sensitive even if they are not already marked `rewrite-before-translation`; at minimum scrutinize `Excuse me sorry`, `Take me here`, and `To go` before settling on literal English-to-Italian mappings.
- Finish the highest-pressure utility cluster first inside the top 20: polite basics, `I do not understand`, `Can you speak a little slower`, hotel check-in/reservation, card payment, and taxi stop/drop-off language.
- Keep pronunciation compact and honest for the early rows; add help where stress or consonant clusters matter, but do not invent false precision.
