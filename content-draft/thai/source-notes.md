# Thai Source Notes

Current reality:

- This lane is prep-only and is not wired into the runtime app registry yet.
- The shared traveler baseline is still the right category skeleton for Thailand.
- The lane now has a reusable `phrase-source.csv` scaffold plus a ranked `first-wave-priority.csv`.
- Thai needs more careful script, tone, and pronunciation handling than the current Latin-script prep lanes.
- Official RTGS romanization is useful for public-sign familiarity, but it should not be the only learner-facing pronunciation layer.
- Traveler romanization in this lane should stay explicitly approximate until audio and native review firm up tone and vowel-length guidance.

## Authoring stance

- Default to polite everyday Thai, not clipped command forms.
- Keep `target_text` in Thai script for show-screen usefulness.
- Use `pronunciation` for approximate traveler guidance only; do not present it as phonetic certainty.
- Treat RTGS as secondary signage familiarity, not the primary learner-facing pronunciation contract.
- Preserve explicit review flags for politeness, food risk, money/payment friction, transport disputes, and medical or police escalation.

## Phrase selection adjustments for Thailand

- Keep the shared 10 scenarios, but bias the first authoring wave toward polite basics, price checks, ride pickup/dropoff, food modifiers, hotel arrival, directions, and repair language.
- Treat bargaining-heavy lines and generic `city center` navigation as likely rewrite candidates before direct translation.
- Add Thai-specific supplemental rows where the baseline is too weak for real traveler use, especially meter, no-ice, station, and police-escalation language.
- Keep a compact repair mini-set inside the ranked shortlist: yes/no, repeat, write it down, show me, point, how many, and how many minutes should be available early.

## Next content pass should

- translate the ranked first wave first
- keep rewrite-before-translation rows explicit instead of forcing literal baseline carry-over
- draft Thai script plus approximate traveler romanization for the highest-value rows
- define the honest audio posture early because Thai tone risk is high
- plan search aliases for English intent, Thai script, and likely traveler romanization inputs
- keep medical, police, allergy, money, and transport-dispute phrases visible for extra review before runtime graduation
