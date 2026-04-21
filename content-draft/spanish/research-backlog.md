# Spanish Research Backlog

## Next authoring moves

- [x] Translate the top 20-30 rows from `first-wave-priority.csv` before touching low-value scaffold rows.
- [x] Replace `Please let me pay` with a natural Spain bill-request source sentence before translation.
- [x] Rewrite bargaining-oriented source rows so the Spain lane does not inherit a fake haggling posture.
- [x] Replace city-center direction prompts with station / metro / platform / old-town wording where the Spain lane needs a better source sentence.
- [x] Add a compact repair mini-set for station help card payment receipt and reservation follow-through.
- [x] Decide the traveler-facing pronunciation normalization rule in enough detail for consistent `pronunciation` authoring.
- [x] Resolve the remaining low-fit restaurant scaffold rows honestly instead of translating them by inertia.
- [x] Decide whether the unresolved taxi city-center row should stay or be rewritten toward station or old-town drop-off help.
- [x] Choose which low-priority small-talk rows are actually worth carrying before runtime consideration.
- [x] Validate the pronunciation-normalization posture against the current drafted Spain lane and normalize any obvious outlier.
- [x] Replace the open-ended social-tail discussion with explicit `next`, `later-review`, and `deferred` buckets.
- [x] Review the pharmacy-adjacent pair and classify both as `promote`: `spanish-convenience-store-3` and `spanish-convenience-store-4`.
- [x] Freeze the `later-only` bucket outside starter planning: `spanish-convenience-store-5`, `spanish-small-talk-5`, and `spanish-small-talk-7`.
- [x] Retire the deferred social-tail rows from graduation planning unless premium/social scope changes: `spanish-small-talk-1`, `spanish-small-talk-2`, `spanish-small-talk-3`, `spanish-small-talk-4`, and `spanish-small-talk-6`.

## Review gates needed later

- [ ] Native or expert review for medical, police, lost-passport, and other emergency wording.
- [ ] Native or expert review for allergy / dietary-risk phrases.
- [ ] UX/localization review for accent-insensitive search, English aliases, and Spain-specific vocabulary choices.
- [ ] Localization review for bill, takeaway, and directions phrasing that may differ from non-Spain Spanish defaults.
- [x] Confirm the pharmacy-adjacent pair outranks the later social rows and keep that decision closed for this graduation packet.

## Graduation blockers to clear before runtime wiring

- [x] Real translation coverage in `phrase-source.csv`
  - the current Spain lane now carries explicit outcomes across all `70` rows, with `69` ordinary drafted or rewritten rows plus one medical holdout
- [x] Graduation-boundary packet
  - ranked `50`-row packet now carries explicit `final_outcome` truth: `41` `promote`, `3` `later-only`, `1` `native-review-only`, `0` `rewrite-needed`, `5` `retire`
- [ ] Pronunciation coverage
- [ ] Honest audio posture
- [ ] Search/localization plan for accents and Spain-specific retrieval vocabulary
- [ ] Validation plan for show-screen behavior, directions help, and payment/bill language
