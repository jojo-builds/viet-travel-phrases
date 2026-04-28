The corrected T-152 pass stays inside the task’s allowed content-and-doc scope, keeps the Viet relation and answer-page work explicitly additive to `phrase-source.csv` rather than replacing base truth, and now carries the note-marker density guardrail consistently across the implementation notes and mirrored durable docs. I do not see a remaining visible authoring-safety, durability, or scope-regression issue in the reviewed files.

Findings:
- none

Evidence:
- `.agent/tasks/T-152/spec.md` limits writes to the task folder, the Viet content-draft sidecars/notes, and mirrored worktree docs only; every reviewed changed surface is inside that allowed scope, while `ops/**`, `docs/operations/**`, UI shell files, and unrelated lanes remain out of scope.
- `.agent/tasks/T-152/logs/viet-flagship-answer-hub-deepening-notes.md` keeps the work bounded to `80` answer-page-ready hubs inside a `99`-cluster sample, describes additive support-pool rotation, and restates the guardrail as no new answer-page markers on legacy rows already carrying `6+` answer-page tokens, with newly touched rows kept below the `8`-token cap.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\README.md` says the sidecars remain additive and do not replace the scenario -> family -> phrase-row model, while `phrase-source.csv` remains phrase/family source truth.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\source-notes.md` and `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-authoring-notes.md` keep `notes` usage to lightweight `relation-sample=` / `answer-page-sample=` markers only, with relation edges owned by `relation-sample-v1.json` and compact answer modules owned by `answer-page-sample-v1.json`.
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\V2_CONTENT_MODEL.md` and `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` mirror the same ownership split and the same marker-density rule, so the durable docs stay aligned with the authored-lane truth reviewed here.
- The current reviewed notes/docs are internally aligned on the bounded sample counts and class expansion: `99` relation clusters, `80` answer-page-ready hubs, `19` relation-only clusters, `7` active phrase classes, `158` answer-page-marked rows, and `134` explicit support-marked rows.

Approval: APPROVE
