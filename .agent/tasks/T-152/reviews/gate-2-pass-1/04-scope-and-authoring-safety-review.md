The visible T-152 work stays inside the allowed content-and-doc scope, keeps the relation and answer-page sidecars additive to `phrase-source.csv` rather than replacing it, and mirrors the note-marker guardrail consistently across the updated durable docs. I do not see a remaining authoring-safety, durability, or scope-regression risk in the files reviewed.

Findings:
- none

Evidence:
- `.agent/tasks/T-152/spec.md` limits writes to the Viet content-draft files plus `docs/V2_CONTENT_MODEL.md` and `docs/PHRASE_RELATIONSHIP_MODEL.md` only when mirrored branch truth changes; the reviewed changes are confined to those allowed content/doc surfaces.
- `.agent/tasks/T-152/reviews/gate-1-pass-2/04-scope-and-authoring-safety-review.md` approved the pass only after the marker rule was clarified to preserve the additive contract and prevent new markers on saturated legacy rows.
- `.agent/tasks/T-152/logs/viet-flagship-answer-hub-deepening-notes.md` records bounded sample growth to `80` answer-page-ready hubs within `99` total clusters, with the note-density rule explicitly restated as no new answer-page markers on legacy rows already carrying `6+` tokens and newly touched rows staying below `8`.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md` and `source-notes.md` both describe the sidecars as additive, keep phrase/family truth in `phrase-source.csv`, and align on the updated counts: `99` clusters, `80` answer-page-ready hubs, `19` relation-only clusters, `7` active phrase classes, `150` answer-marked rows, and `126` support-marked rows.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md` preserves the sidecar model by assigning relation edges/buckets to `relation-sample-v1.json`, compact module content to `answer-page-sample-v1.json`, and only lightweight markers to the `notes` field.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\V2_CONTENT_MODEL.md` and `docs\PHRASE_RELATIONSHIP_MODEL.md` mirror the same additive ownership split and the same guardrail language, including the `6+` legacy-row freeze and `<8` newly touched-row cap, so the durable docs remain aligned with the authored lane truth.

Approval: APPROVE
