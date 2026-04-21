# Spanish Content Draft

This folder is the prep lane for a future Spain / Spanish SpeakLocal app variant.

Use it for:

- scenario review against the shared traveler baseline
- translation and pronunciation drafting
- Spain-specific localization notes
- prep-only authoring artifacts that make the next translation pass faster
- audio planning after source text is stable

Current status:

- prep-only
- not runtime-wired
- pronunciation-normalization posture validated against the current draft set, with one outlier normalized back to the lane's broad traveler rule
- full phrase coverage now stands at `69` drafted or rewritten rows plus `1` explicit medical holdout
- ranked graduation packet now stands at `41` `promote`, `3` `later-only`, `1` `native-review-only`, and `5` `retire` outcomes across the `50` ranked rows in `first-wave-priority.csv`

Current durable lane assets:

- `research/language-pipeline/spanish/SPAIN-TRAVEL-RESEARCH.md`
  - durable travel/use research, Spain-specific localization stance, and search implications
- `content-draft/spanish/first-wave-priority.csv`
  - authoritative ranked graduation-boundary ledger with `final_outcome` truth for all `50` ranked rows
- `content-draft/spanish/phrase-source.csv`
  - full draft source sheet, including residual-row outcome markers for the pharmacy, social-tail, and medical holdout rows
- `content-draft/spanish/source-notes.md`
  - authoring posture, rewrite warnings, and the residual adjudication ledger
- `content-draft/spanish/research-backlog.md`
  - remaining prep work and graduation blockers

Graduation-boundary packet:

- `promote`: `41` ranked rows, including the pharmacy-adjacent pair `spanish-convenience-store-3` and `spanish-convenience-store-4`
- `later-only`: `spanish-convenience-store-5`, `spanish-small-talk-5`, and `spanish-small-talk-7`
- `native-review-only`: `spanish-simple-problems-6`
- `retire`: `spanish-small-talk-1`, `spanish-small-talk-2`, `spanish-small-talk-3`, `spanish-small-talk-4`, and `spanish-small-talk-6`
- `rewrite-needed`: none remain; the earlier rewrite-needed rows were already rewritten and promoted in `T-095`

Authoring posture for the next pass:

- keep the shared 10-scenario seam
- default to standard Spain-focused traveler Spanish not generic all-Spanish-world wording
- keep correct Spanish orthography in `target_text`, including accents and the n-with-tilde character
- use `pronunciation` for lightweight traveler support not as a replacement for real Spanish spelling
- treat bargaining lines as rewrite candidates rather than literal translation targets for Spain
- preserve explicit review flags for medical allergy and other high-risk wording

Immediate next authoring target:

- keep the lane prep-only while applying the validated pronunciation normalization rule to future additions
- do not reopen the residual translation tail unless product scope changes
- treat pronunciation coverage, honest audio posture, search/localization, and validation planning as the next real graduation blockers
- keep `later-only` and `retire` rows outside starter-slice planning unless a later premium/social pack is intentionally reopened
- do not wire this lane into `app/family` yet
