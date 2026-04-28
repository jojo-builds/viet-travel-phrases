The corrected pass still reads as safely inside T-152’s allowed content/doc scope, preserves the additive sidecar model instead of replacing `phrase-source.csv` truth, and now carries the note-marker guardrail consistently through the implementation notes and mirrored durable docs. I do not see a remaining visible scope, authoring-safety, durability, or repo-truth regression in the reviewed files.

Findings:
- none

Evidence:
- `.agent/tasks/T-152/spec.md` limits writes to the T-152 task artifacts, the Viet content-draft sidecars/notes, and mirrored durable docs only; every reviewed changed surface sits inside that allowed scope, while `ops/**`, `docs/operations/**`, UI shell files, and unrelated lanes remain out of scope.
- `.agent/tasks/T-152/reviews/gate-2-pass-1/04-scope-and-authoring-safety-review.md` centers approval on preserving the additive contract and avoiding new answer-page markers on saturated legacy rows; the current reviewed docs now reflect that same rule set.
- `.agent/tasks/T-152/logs/viet-flagship-answer-hub-deepening-notes.md` keeps the work bounded to `80` answer-page-ready hubs inside a `99`-cluster sample, and restates the marker guardrail as no new answer-page markers on legacy rows already carrying `6+` answer-page tokens, with newly touched rows kept below the `8`-token cap.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md` explicitly says the sidecars remain additive and do not replace the existing scenario -> family -> phrase-row model, while assigning phrase/family truth to `phrase-source.csv`.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md` and `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md` keep `notes` usage lightweight (`relation-sample=` / `answer-page-sample=` markers only), with relation edges/buckets owned by `relation-sample-v1.json` and compact answer modules owned by `answer-page-sample-v1.json`.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\V2_CONTENT_MODEL.md` and `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` mirror the same additive ownership split and the same marker-density guardrail, so the durable docs stay aligned with the reviewed authored-lane truth.
- The reviewed repo-truth docs and notes are internally consistent on the current bounded sample counts: `99` relation clusters, `80` answer-page-ready hubs, `19` relation-only clusters, `7` active phrase classes, `159` answer-page-marked rows, and `135` explicit support-marked rows.

Approval: APPROVE
