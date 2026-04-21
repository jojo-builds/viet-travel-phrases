# German Content Draft

This folder is the prep lane for a future Germany / German SpeakLocal app variant.

Use it for:

- scenario review against the shared traveler baseline
- translation and pronunciation drafting
- Germany-specific localization notes
- prep-only authoring artifacts that make the next translation pass faster
- audio planning after source text is stable

Current status:

- prep-only
- not runtime-wired
- now advanced through a residual-tail cleanup that clears the former 12 `pending-later` rows and converts the last weak cafe row into an explicit native-review handoff
- residual review is now consolidated into one explicit packet: 1 deferred cafe handoff, 1 expert-review runtime blocker, 16 translated rows that stay review-visible before runtime graduation, and 11 translated register checks that are closed for now unless later native review arrives

Current durable lane assets:

- `research/language-pipeline/german/GERMANY-TRAVEL-RESEARCH.md`
  - durable travel-use research, politeness stance, rewrite priorities, and search implications
- `content-draft/german/scenario-plan.json`
  - shared 10-scenario scaffold with Germany-specific prioritization notes plus updated practical-traveler emphasis
- `content-draft/german/phrase-source.csv`
  - full 70-row prep-only source lane with 69 resolved outcomes, pronunciation support on translated rows, and one explicit native-review handoff on `coffee-shop-4`
- `content-draft/german/first-wave-priority.csv`
  - full ranked queue through the cleared first-wave batch, the second practical pack, the residual-tail cleanup pass, and the explicit residual-review packet
- `content-draft/german/source-notes.md`
  - authoring posture, residual-tail completion decisions, grouped residual-review packet, and release-posture rules
- `content-draft/german/research-backlog.md`
  - exact later-review packet, pronunciation follow-ups, and graduation blockers
- `.agent/tasks/T-106/logs/german-residual-review-packet.md`
  - task-local release-posture packet that names every remaining German review surface and its exact disposition

Authoring posture for the next pass:

- keep the shared 10-scenario seam
- default to polite everyday standard German for service encounters
- keep natural German spelling with umlauts and sharp-s in `target_text`
- use `pronunciation` for traveler-friendly support rather than flattening the display text
- preserve explicit review flags for medical, transit, service-wording, and context-sensitive lines
- keep the lane prep-only and out of `app/family`

Immediate next authoring target:

- keep the cleared residual-tail rows closed instead of reopening lightweight social or politeness work
- keep `coffee-shop-4` as an explicit native-review handoff unless a stronger Germany-fit cafe intent is proven later
- treat the translated service, transit, medical, context, and register-sensitive rows as one bounded later-review packet instead of a live rewrite queue
- keep tightening pronunciation help where `Kräuter`, `Wiedersehen`, formal `Ihnen`, and `USA` may still trip up travelers
- preserve the closed-for-now release posture: no new Germany translation work is required unless native or expert review actually arrives



