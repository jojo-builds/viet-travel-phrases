# French Content Draft

This folder is the prep lane for a future France / French SpeakLocal app variant.

Use it for:

- scenario review against the shared traveler baseline
- source-phrase drafting and rewrite notes
- France-specific localization notes
- prep-only authoring artifacts that make the next translation pass faster
- pronunciation and audio-planning notes after source text is stable

Current status:

- prep-only
- not runtime-wired
- practical traveler rows through rank `62` are translated with compact pronunciation support
- the residual tail is now one explicit graduation-boundary packet, not a live translation queue:
  - `6` later-only social holds: `french-small-talk-1` through `french-small-talk-6`
  - `1` native-review-only social hold: `french-small-talk-7`
  - `1` retired weak-fit cafe row: `french-coffee-shop-4`

Current durable lane assets:

- `research/language-pipeline/french/FRANCE-TRAVEL-RESEARCH.md`
  - durable travel/use research, France-focused politeness stance, and search implications
- `content-draft/french/source-notes.md`
  - authoring posture, review-risk notes, and the explicit graduation-boundary packet
- `content-draft/french/scenario-plan.json`
  - shared 10-scenario scaffold with France-focused tips and quick phrase candidates
- `content-draft/french/phrase-source.csv`
  - full 70-row prep-only source lane with translated French through the practical block plus named later-only, native-review-only, and retired outcomes for the final tail
- `content-draft/french/first-wave-priority.csv`
  - ranked queue with rows `1` through `62` resolved and rows `63` through `70` converted into explicit later-only, native-review-only, and retired outcomes
- `content-draft/french/research-backlog.md`
  - stable next-owner rules, review gates, and graduation blockers after the residual packet closeout
- `.agent/tasks/T-119/logs/french-residual-packet.md`
  - compact task-local packet naming what is done, what stays out, and what would justify reopening the lane later

Authoring posture after this packet:

- keep the shared 10-scenario seam
- default to France-focused polite everyday French, not casual `tu`-first phrasing or generic classroom sentences
- keep stranger-facing service rows `vous`-safe unless a shorter neutral noun phrase avoids the choice cleanly
- keep correct French spelling visible in `target_text`
- use `pronunciation` as lightweight ASCII-friendly support, not as a replacement for French orthography
- keep the later-only social hold set visible for planning, but do not treat it as near-term translation debt
- keep `french-small-talk-7` outside promotion until native review explicitly says a France-fit version is worth carrying
- keep `french-coffee-shop-4` retired from the current lane unless a future cafe-fit source rewrite explicitly replaces it

Immediate next authoring target:

- keep `french-small-talk-1` through `french-small-talk-6` closed as later-only social coverage unless product asks for a hospitality or friendliness expansion
- keep `french-small-talk-7` as the only native-review-only social hold instead of forcing an English wellness-small-talk translation
- keep `french-coffee-shop-4` out of the lane unless a future source rewrite proves a stronger France-first cafe intent
- keep alias and search notes visible for `bonjour`, `bonsoir`, `l'addition`, `carte`, `gare`, `quai`, `reservation`, `recu`, `bagage`, `a emporter`, and `medecin`
- continue audio-posture, search, and review planning without wiring this lane into `app/family`
