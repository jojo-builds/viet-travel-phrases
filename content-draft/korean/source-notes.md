# Korean Source Notes

Current reality:

- This lane is prep-only and is not wired into the runtime app registry yet.
- `phrase-source.csv` now carries `62` resolved rows across two translation passes.
- The first pass cleared the original top 30 batch.
- The second pass cleared the remaining practical utility rows across hotel room problems convenience-store follow-ups directions cafe adjustments and other day-to-day service phrases.
- The lane now has `62` resolved rows plus an explicit `8`-row residual handoff: `6` low-priority social rows parked as `pending-next-pass`, `korean-small-talk-7` parked as `deferred-native-review`, and `asking-price-3` kept as `deferred-rewrite-needed`.

## Authoring stance

- Default to polite everyday Korean.
- Prefer safe service phrases and `-yo` style requests over casual dictionary-form translations.
- Keep `target_text` in natural Hangul for show-screen usefulness.
- Use `pronunciation` as traveler-friendly romanization support not as a substitute for script.
- Keep phrases short and screen-usable rather than textbook-complete.
- When a phrase depends on softened endings omitted subjects or service-register choices keep the uncertainty visible in notes instead of pretending the wording is settled.

## Phrase selection adjustments for South Korea

- Keep the shared 10 scenarios but bias authoring toward coffee shops convenience stores hotel desks subway exits taxi routing and repair phrases.
- Treat `asking-price` as price confirmation and item-selection language not a bargaining-heavy scenario.
- Treat `small-talk` as low priority once the practical utility rows are covered.
- Keep medical police lost-passport and allergy content behind explicit expert-review flags.

## Rewrite decisions already made in the source scaffold

- `coffee-shop-1`, `coffee-shop-2`, `coffee-shop-3`, and `coffee-shop-5` now use Korea-fit cafe ordering and drink-adjustment English instead of the generic coffee carryover baseline.
- `street-food-1`, `street-food-2`, `street-food-4`, and `street-food-6` now use broader Korea-fit ordering banchan and utensil wording instead of bowl-specific or garnish-only carryover language.
- `grab-taxi-2`, `grab-taxi-4`, and `grab-taxi-7` now point to station travel route confirmation and card-payment wording instead of generic city-center or cash-default carryover.
- `asking-price-2`, `asking-price-4`, and `asking-price-5` now use per-item comparison and total-price wording instead of bargaining-heavy glosses.
- `convenience-store-4` now uses a charger request instead of sunscreen carryover language.
- `directions-1`, `directions-4`, `directions-5`, and `directions-6` now use exit line and route-confirmation wording instead of generic city-center carryover.
- `polite-basics-3`, `small-talk-5`, and `small-talk-6` now carry cleaner English source wording for later translation.

## Current resolved coverage

- The lane now covers the entire first practical utility surface: greetings thanks decline and apology repair basics hotel arrival and room-problem follow-ups ride and route control payment confirmation convenience-store asks cafe adjustments and core dining modifiers.
- Newly resolved rows in the second pass include hot and latte cafe orders less-ice and less-sweet requests bag charger receipt and packaging help rows AC and room-heat complaints extra towels subway-line and exit follow-ups and forgotten-item plus Wi-Fi repair lines.
- The practical queue is now functionally closed; the remaining tail is explicit handoff material rather than a vague unresolved middle.

## Rows that still carry explicit risk or caution

- Any row marked in the execution ledger for service wording review should stay sensitive to apology-versus-attention posture polite request endings and show-screen-friendly sentence shape.
- `korean-polite-basics-7` remains context-sensitive because Korean goodbye wording changes depending on who is leaving.
- `korean-grab-taxi-4`, `korean-grab-taxi-6`, `korean-directions-4`, `korean-directions-5`, and `korean-directions-6` are now translated but should stay visible for later native review because route and driver wording is context-dependent.
- `korean-convenience-store-2` and `korean-convenience-store-7` now use natural request wording instead of literal stock questions and should stay review-visible for service posture.
- `korean-hotel-hostel-4` and `korean-hotel-hostel-5` are now translated but still need native review on complaint softening and desk-friendly phrasing.
- `simple-problems-6` remains translated-sensitive and still needs expert medical review before any runtime graduation discussion.
- `korean-small-talk-7` stays deliberately unfilled because a direct English-style `How are you` small-talk line is culturally and register-sensitive in Korean and should not be forced without native guidance.
- `asking-price-3` stays deliberately deferred because price-reaction language remains a weaker South Korea fit than confirmation and item-selection language.
- `korean-small-talk-1` through `korean-small-talk-6` stay parked as optional later social coverage rather than missing traveler-core utility.

## Pronunciation and search posture notes

- Traveler-facing romanization should stay ASCII-friendly and easy to say under pressure.
- Add pronunciation help where `eo`, `eu`, tense-versus-plain consonants or compressed polite endings could trip up English-speaking travelers.
- Do not over-promise that romanization alone is enough for accurate speaking.
- English-intent retrieval should remain the primary search assumption.
- Hangul runtime search should be treated as a later UX/localization gate not inherited automatically from Viet + Tagalog.

## Next content pass should

- review the flagged service route room-problem and goodbye rows with native or expert eyes before treating them as settled draft truth
- keep `small-talk-1` through `small-talk-6` parked unless the lane deliberately reopens low-pressure social coverage
- leave `small-talk-7` for native review before any direct translation attempt
- keep `asking-price-3` deferred until a Korea-fit rewrite is actually useful
- decide the honest short-term audio posture before runtime wiring
