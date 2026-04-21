# Spanish Source Notes

Current reality:

- This lane is still prep-only and is not wired into the runtime app registry.
- The shared traveler baseline remains the structural starting point, but Spain-specific prioritization is now documented.
- `first-wave-priority.csv` is now the ranked graduation-boundary ledger for the lane.
- `phrase-source.csv` carries the full draft coverage plus residual-row outcome markers where later planning needs them.

## Authoring stance

- Default to standard Spain-focused traveler Spanish.
- Prefer polite everyday requests over stiff textbook phrasing or region-neutral filler.
- Keep `target_text` in correct Spanish spelling with accents and the n-with-tilde character for show-screen usefulness.
- Use `pronunciation` as a traveler-friendly support layer, not as a substitute for Spanish orthography.
- Do not force plural forms or `vosotros` patterns into the first wave unless the English source truly needs them.

## Phrase selection adjustments for Spain

- Keep the shared 10 scenarios, but bias authoring toward cafes/bars, hotel desks, train and metro navigation, shops, pharmacies, and repair phrases.
- Treat `street-food` as bar / cafe / casual restaurant utility rather than literal street-food-only language.
- Treat `asking-price` as price confirmation and item selection, not a bargaining-heavy scenario.
- Treat `small-talk` as low priority for the first wave.
- Keep medical, police, lost-passport, and allergy content behind explicit expert-review flags.

## Scaffold lines likely to need rewriting before direct translation

- bargaining-oriented price lines such as `Can you lower it a little` and `What is your final price`
- bill-request lines such as `Please let me pay`, which were rewritten in the first wave toward a Spain-natural `la cuenta por favor` style request
- direction lines that assume `city center` wording instead of station / metro / platform / old-town navigation
- restaurant lines that assume non-Spain defaults, especially rows like `A spoon and chopsticks please`

## Pronunciation / search posture notes

- English-intent retrieval should remain the primary search assumption.
- Future runtime search should accept accentless lookup as a helper, but keep full Spanish spelling visible on cards.
- Spain-specific retrieval vocabulary will matter in later passes: examples include `tarjeta`, `billete`, `bano/bano with tilde`, `estacion`, `metro`, and `para llevar`.
- Pronunciation help should stay light and practical for English-speaking travelers; do not overbuild regional pronunciation theory into the first pass.
- Use broad traveler romanization with simple syllable breaks and one stressed syllable in caps; keep it readable and consistent rather than pretending to be phonetics-perfect.
- Keep pronunciation support broad rather than region-perfect: preserve Spain-fit wording in `target_text`, but do not force Castilian-only details such as `th` spell-outs into `pronunciation` when a simpler traveler rendering is clearer.
- This validation pass normalized `spanish-small-talk-3` from `behth` to `behs` so the lane stays aligned with the broad traveler rule already used elsewhere.

## Second-pass translation notes

- All `50` ranked rows in `first-wave-priority.csv` now carry explicit `final_outcome` truth, and the lane still keeps full draft coverage in `phrase-source.csv`.
- The second-pass work established the cafe follow-through, shopping, hotel checkout, directions, and repair clusters that now anchor the lane.
- `spanish-directions-1` was rewritten from city-center wording to `Excuse me how do I get to the metro station` before translation.
- `spanish-asking-price-4` and `spanish-asking-price-5` were rewritten away from bargaining into cheaper-option and total-cost checks that fit Spain better.
- The lane now carries `69` ordinary drafted or rewritten rows plus the explicit medical holdout.
- The medical row still remains an `expert-review-medical` holdout and should not be treated as runtime-ready.

## Graduation-boundary packet

- The ranked `50`-row packet now uses one explicit outcome contract in `first-wave-priority.csv`: `promote`, `later-only`, `native-review-only`, `rewrite-needed`, or `retire`.
- Outcome counts are now fixed at `41` `promote`, `3` `later-only`, `1` `native-review-only`, `0` `rewrite-needed`, and `5` `retire`.
- This closes the old `next` / `later-review` / `deferred` ambiguity and leaves one compact graduation-boundary packet for future planning.

## Rewrite-resolved notes

- `spanish-grab-taxi-2` was rewritten from `Go to the city center` to `Take me to the train station` before translation.
- `spanish-street-food-2` was rewritten from bowl-specific wording to `I'll have this one` for Spain-fit casual ordering.
- `spanish-street-food-6` was rewritten from `A spoon and chopsticks please` to `A fork please` for Spain-fit utensil coverage.
- The lane now carries explicit outcomes for all `70` rows: `69` ordinary drafted or rewritten rows plus the medical holdout.
- No row remains in a live `rewrite-needed` state for the current graduation packet.

## Residual ledger after this pass

- `promote`: `spanish-convenience-store-3` and `spanish-convenience-store-4` stay in the graduation packet because they add practical kiosk/pharmacy utility without crossing into medical-risk wording.
- `later-only`: `spanish-convenience-store-5`, `spanish-small-talk-5`, and `spanish-small-talk-7` stay drafted but remain outside honest starter planning unless a later social or packaging-help pass is intentionally reopened.
- `retire`: `spanish-small-talk-1`, `spanish-small-talk-2`, `spanish-small-talk-3`, `spanish-small-talk-4`, and `spanish-small-talk-6` remain as drafted reference rows but are retired from graduation-boundary discussion unless product scope changes.
- `native-review-only`: `spanish-simple-problems-6` remains the explicit medical holdout and must stay outside runtime discussion until expert review exists.

## Next content pass should

- keep the promoted pharmacy pair in place and do not reopen the old residual-tail debate
- keep the `later-only` and `retire` buckets stable unless product scope changes
- keep high-risk phrases explicitly labeled for later native or expert review
- decide the honest short-term audio posture before runtime wiring
- validate the new pronunciation normalization rule against any future additions before broader lane expansion
