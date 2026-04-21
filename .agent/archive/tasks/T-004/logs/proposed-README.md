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
- now upgraded from baseline scaffold to an authoring-ready first-wave lane

Current durable lane assets:

- `research/language-pipeline/japanese/JAPAN-TRAVEL-RESEARCH.md`
  - durable travel/use research, script posture, politeness stance, and search implications
- `content-draft/japanese/first-wave-priority.csv`
  - ranked first translation wave for the next authoring task
- `content-draft/japanese/source-notes.md`
  - authoring posture, rewrite warnings, and review-risk notes
- `content-draft/japanese/research-backlog.md`
  - remaining prep work and graduation blockers

Authoring posture for the next pass:

- keep the shared 10-scenario seam
- default to polite everyday Japanese, not casual/plain forms
- keep natural Japanese script in `target_text`
- use `pronunciation` for traveler-friendly romaji support, not as the only display layer
- treat bargaining lines as low priority or rewrite candidates for Japan
- preserve explicit review flags for emergency, medical, and other high-risk wording

Immediate next authoring target:

- start with the top rows in `first-wave-priority.csv`
- translate only the ranked first wave first
- keep notes on phrases that need Japan-specific rewriting instead of literal translation
- do not wire this lane into `app/family` yet
