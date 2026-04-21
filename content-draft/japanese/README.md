# Japanese Content Draft

This folder is the prep lane for a future Japan / Japanese SpeakLocal app variant.

Use it for:

- scenario review against the shared traveler baseline
- translation and pronunciation drafting
- Japan-specific localization notes
- prep-only authoring artifacts that make the next translation pass faster
- audio planning after source text is stable

Current status:

- prep-only
- not runtime-wired
- translation-complete for the current prep scope, with the lane now closed into one explicit graduation-boundary packet
- authoritative graduation ledger in `content-draft/japanese/first-wave-priority.csv`:
  - `34` `promote`
  - `4` `later-only`
  - `1` `native-review-only`
  - `3` `rewrite-needed`
  - `5` `retire`

Current durable lane assets:

- `research/language-pipeline/japanese/JAPAN-TRAVEL-RESEARCH.md`
  - durable travel/use research, script posture, politeness stance, and search implications
- `content-draft/japanese/first-wave-priority.csv`
  - ranked queue plus the authoritative `final_outcome` ledger for the graduation packet
- `content-draft/japanese/source-notes.md`
  - authoring posture, packet reasons, and explicit keep-out rules
- `content-draft/japanese/research-backlog.md`
  - stable reopen rules, later review gates, and runtime blockers after packet closeout
- `.agent/tasks/T-122/logs/japan-graduation-packet.md`
  - compact closeout packet for future planning without reopening `T-101`

Authoring posture after this packet:

- keep the shared 10-scenario seam
- default to polite everyday Japanese, not casual or plain-form phrasing
- keep natural Japanese script in `target_text`
- use `pronunciation` for traveler-friendly romaji support, not as a replacement for script
- treat bargaining rows as either rewrite-needed or later-only, not starter debt
- keep medical and other high-risk wording outside promotion until the named review exists
- treat the promoted set as the honest Japan prep handoff; do not let social filler expand it by implication

Immediate next authoring target:

- use the `34` promoted rows as the current Japan starter and graduation reference set
- keep `japanese-simple-problems-6` as the only `native-review-only` hold until expert medical review lands
- keep `japanese-asking-price-2`, `japanese-asking-price-3`, `japanese-small-talk-3`, and `japanese-small-talk-5` visible as `later-only` rows and nothing more
- keep `japanese-street-food-4`, `japanese-grab-taxi-2`, and `japanese-asking-price-5` closed as `rewrite-needed` until stronger Japan-fit English source text exists
- keep `japanese-small-talk-1`, `japanese-small-talk-2`, `japanese-small-talk-4`, `japanese-small-talk-6`, and `japanese-small-talk-7` retired from graduation planning unless product explicitly reopens social coverage
- do not wire this lane into `app/family` yet
