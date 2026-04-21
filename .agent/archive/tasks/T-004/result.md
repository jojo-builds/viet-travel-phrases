# T-004 Result

- status: done
- truth changed classification: planning

## Changed files

- `content-draft/japanese/README.md` - upgraded the lane summary from baseline scaffold to a concrete authoring-ready prep surface.
- `content-draft/japanese/source-notes.md` - documented the Japanese authoring stance, rewrite risks, and search/pronunciation cautions.
- `content-draft/japanese/scenario-plan.json` - reprioritized quick phrases and scenario tips around Japan-specific traveler utility.
- `content-draft/japanese/first-wave-priority.csv` - added the required ranked first authoring wave with confidence and review flags.
- `content-draft/japanese/research-backlog.md` - added a concrete follow-up item for replacing city-center direction prompts with station/exit/platform wording.
- `.agent/tasks/T-004/reviews/01-traveler-utility-review.md` - traveler-utility review lane output.
- `.agent/tasks/T-004/reviews/02-japanese-language-risk-review.md` - Japanese language-risk review lane output.
- `.agent/tasks/T-004/reviews/03-authoring-scaffold-review.md` - authoring-scaffold review lane output.
- `.agent/tasks/T-004/reviews/04-contract-scope-review.md` - contract/scope review lane output.
- `.agent/tasks/T-004/state.json` - recorded reclaim, phase changes, lease refreshes, and completion state.

## Validation performed

- Verified the required durable files exist:
  - `research/language-pipeline/japanese/JAPAN-TRAVEL-RESEARCH.md`
  - `content-draft/japanese/README.md`
  - `content-draft/japanese/source-notes.md`
  - `content-draft/japanese/scenario-plan.json`
  - `content-draft/japanese/first-wave-priority.csv`
  - `content-draft/japanese/research-backlog.md`
- Parsed `content-draft/japanese/scenario-plan.json` successfully and confirmed `5` quick phrases / `10` scenarios.
- Imported `content-draft/japanese/first-wave-priority.csv` successfully and confirmed `24` ranked rows.
- Verified exactly `4` review files exist under `.agent/tasks/T-004/reviews/`.
- Checked the backing Git root for runtime-registry drift:
  - `app/family/appRegistry.js` and `app/family/currentApp.ts` showed no diff output
  - broader `app/**` had unrelated pre-existing diffs outside this task's write scope

## Review findings and fixes

- Traveler utility review: flagged `city center` and bargaining baseline lines as weak fits for Japan. Fixed by pushing them down in `first-wave-priority.csv`, marking them `rewrite-before-translation`, and documenting the rewrite need in `source-notes.md` and `research-backlog.md`.
- Japanese language-risk review: confirmed polite/default script posture is explicit and that sensitive medical/food items keep review flags rather than pretending they are settled.
- Authoring scaffold review: confirmed the new CSV is concrete enough for the next translation task without a new orientation pass.
- Contract/scope review: confirmed the task stayed inside the prep-only Japanese lane and did not touch runtime wiring.

## Remaining risks / cautions

- Medical, police, allergy, and other sensitive Japanese lines still need later native or expert review before any runtime graduation.
- The current baseline still contains some English source rows that should be rewritten for Japan before direct translation, especially direction and bargaining-oriented slots.
- Non-Latin search behavior remains a later UX/localization gate, not something this prep lane can inherit automatically.

## Recommended next step

- Start the next Japanese translation task from the top 20-30 rows in `content-draft/japanese/first-wave-priority.csv`, rewriting the flagged direction/price rows before translating them literally.
