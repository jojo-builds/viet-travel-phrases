# Italian Content Draft

This folder is the prep lane for a future Italy / Italian SpeakLocal app variant.

Use it for:

- scenario review against the shared traveler baseline
- translation and pronunciation drafting
- Italy-specific localization notes
- prep-only authoring artifacts that make the next translation pass faster
- audio planning after source text is stable

Current status:

- prep-only
- not runtime-wired
- effectively translation-complete for the current prep scope: `68` resolved rows plus `1` later-only bargaining hold and `1` rewrite-needed cafe-fit hold
- graduation-boundary review is now explicit: `1` expert-review medical row and `7` translated small-talk rows remain visible but non-promotable until later review

Current durable lane assets:

- `research/language-pipeline/italian/ITALY-TRAVEL-RESEARCH.md`
  - durable travel/use research, politeness stance, rewrite priorities, and search implications
- `content-draft/italian/first-wave-priority.csv`
  - ranked Italy lane through the first wave, the second practical pack, the residual-tail cleanup pass, and the explicit 2-row holdout packet
- `content-draft/italian/phrase-source.csv`
  - full 70-row prep-only source lane with 68 resolved outcomes and 2 explicit deferred holdouts
- `content-draft/italian/source-notes.md`
  - authoring posture, rewrite warnings, residual-tail decisions, and review-risk notes
- `content-draft/italian/research-backlog.md`
  - remaining review packet, pronunciation follow-ups, and graduation blockers
- `.agent/tasks/T-118/logs/italian-graduation-packet.md`
  - compact graduation-boundary packet covering what is done, what remains blocked, and what must not be promoted yet

Authoring posture for the next pass:

- keep the shared 10-scenario seam
- default to polite everyday standard Italian for service encounters
- keep natural Italian spelling in `target_text`
- use `pronunciation` for traveler-friendly support rather than flattening the display text
- de-emphasize bargaining language and several iced-drink scaffold lines that fit Italy poorly
- preserve explicit review flags for medical, emergency, ingredient, and dispute wording

Immediate next authoring target:

- keep `italian-asking-price-4` parked as a later-only bargaining hold unless product plus localization review later proves that an Italy-market negotiation row belongs
- keep `italian-coffee-shop-4` parked as the one rewrite-needed cafe-fit hold until a stronger cold-drink or cafe-customization intent exists
- keep `italian-simple-problems-6` and `italian-small-talk-1` through `italian-small-talk-7` visible as non-promotable review items
- keep tightening pronunciation help, audio posture, and search/localization planning before any runtime discussion
- do not wire this lane into `app/family` yet
