# Indonesian Content Draft

This folder is the prep lane for a future Indonesia / Indonesian SpeakLocal variant.

Use it for:

- scenario review against the shared traveler baseline
- translation and pronunciation drafting
- Indonesian-specific localization and search notes
- prep-only authoring artifacts that make the next translation pass faster
- audio planning after source text is stable

Current status:

- prep-only
- not runtime-wired
- now holds a translated first-wave core plus a second translated support pack, a six-row holdout-reduction pass, and a two-row practical remainder cleanup instead of stopping at scaffold-only truth

Current durable lane assets:

- `research/language-pipeline/indonesian/INDONESIA-TRAVEL-RESEARCH.md`
  - durable Indonesia travel synthesis covering destination framing, politeness, script posture, payment context, ride-hailing reality, and review risks
- `content-draft/indonesian/phrase-source.csv`
  - `82`-row source scaffold covering the shared 10-scenario seam plus Indonesia-specific supplementals for ride-hailing, payment, toilet, repair, and island-travel support, with a translated `67`-row core-plus-support-plus-holdout batch and pronunciation on the cleared high-value set
- `content-draft/indonesian/first-wave-priority.csv`
  - ranked `67`-row working queue now carrying explicit outcomes across the cleared core, second translation pack, the narrowed holdout-reduction pass, and the last practical remainder rows, with review flags still visible on politeness, food, transport, and payment-sensitive rows
- `content-draft/indonesian/source-notes.md`
  - authoring stance, rewrite warnings, completed first-wave plus follow-on translation notes, pronunciation and search posture, and the explicit residual-holdout posture
- `content-draft/indonesian/research-backlog.md`
  - remaining low-fit holdouts, search, audio, and graduation blockers after the practical remainder cleanup

Authoring posture for the next pass:

- keep the shared 10-scenario seam
- default to neutral polite standard Indonesian, not clipped commands and not classroom-formal wording
- treat `phrase-source.csv` as the source-of-truth row scaffold and `first-wave-priority.csv` as the working queue
- continue from the remaining unresolved holdouts instead of reopening the cleared top `67` queue
- keep `target_text` in standard Indonesian spelling and use `pronunciation` only as a light helper for likely traveler misreads
- preserve explicit review flags for politeness choices, QR or scan payment wording, food-risk language, medical language, and address-term questions

Immediate next authoring target:

- decide whether the remaining bargaining, generic directions, duplicate card-payment, and small-talk rows should be rewritten into stronger Indonesia-fit intents or stay late optional coverage
- keep lightweight pronunciation help honest where schwa `e`, `ng`, and `ny` still need clearer traveler support on any future promoted rows
- keep colloquial Indonesian limited to later alias or note handling unless a row is explicitly promoted
- review whether the newer sunscreen and port wording, earlier payment rows, and the practical cafe or ride follow-through wording need any later expert tightening before runtime discussion
- keep `simple-problems-6` and other sensitive wording review-visible instead of treating nearby translated support rows as blanket clearance
- decide the honest short-term audio posture before any runtime graduation discussion
- do not wire this lane into `app/family` yet
