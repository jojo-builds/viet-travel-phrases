# Task Spec: T-008

## Title
Desktop Codex automation pilot, Tagalog v2 first-wave authoring scaffold and risk review

## Objective
Make the Tagalog lane materially more build-ready for a real v2 expansion pass, not just more discussed.
This task should strengthen the existing Tagalog draft lane by producing:
- a concrete ranked first-wave authoring scaffold for the next Tagalog expansion pass
- a clearer view of which drafted phrases are highest-value, which are risky, and which need stronger review before promotion
- a tighter next-step plan for turning the current seed proof surface into a real Tagalog v2 pack

This task must stay inside prep and draft truth. Do not wire new Tagalog runtime behavior or edit `app/**`.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/AUTOMATION.md`
- `.agent/coordination/locks.yaml`
- `docs/LANGUAGE_PREP_WORKFLOW.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRIORITIES.md`
- `docs/TAGALOG_COMPLETION_BRIEF.md`
- `templates/FAMILY_TRAVELER_BASELINE.json`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/viet/phrase-source.csv`
- `research/exec-summary.md`

## Task type
- audit
- prioritization
- prep-only authoring scaffold

## Scope
### Allowed write scopes
- `.agent/tasks/T-008/**`
- `.agent/coordination/locks.yaml`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/thai/**`
- `content-draft/japanese/**`
- `app/family/**` for bounded reference only if needed to understand current pack shape

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring such as `app/family/appRegistry.js` or `app/family/currentApp.ts`
- audio asset generation or mapping files outside the draft-lane notes
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- The current Tagalog lane is a seed proof set and is not yet a release-grade v2 pack.
- This task is successful only if the next Tagalog authoring pass becomes easier and safer.
- Do not just restate that Tagalog needs work. Leave behind the concrete scaffold for what to work on next.
- Favor high-value traveler phrases and honest risk flags over fake completeness.

## Required outputs
Create or update these files:
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`
- `.agent/tasks/T-008/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-008/reviews/`

## Concrete authoring scaffold requirement
This task is not done unless it leaves one practical next-authoring artifact behind.
For this task, that artifact is:
- `content-draft/tagalog/first-wave-priority.csv`

That CSV must rank the first authoring wave and include at minimum:
- `rank`
- `scenario_id`
- `phrase_id`
- `english_text`
- `current_status`
- `priority_reason`
- `confidence`
- `review_flag`

It should make the next Tagalog content task immediately actionable.

## What the task must decide
- which drafted Tagalog phrases are strongest candidates for the first serious v2 pass
- which scenarios deserve the earliest expansion beyond the seed proof set
- where the current phrasing, pronunciation, or localization may be weak or overconfident
- which risks should be reviewed before runtime graduation
- what the next concrete authoring task should do first

## Mandatory 4-subagent review gate
Before finalizing, use exactly 4 Codex subagents and save their outputs under `.agent/tasks/T-008/reviews/`.
Use these exact subagent review artifact names:
1. `01-traveler-utility-review.md` - challenge whether the shortlist helps real Philippines travel moments fast.
2. `02-tagalog-language-risk-review.md` - challenge localization, phrasing, pronunciation, and confidence risks.
3. `03-authoring-scaffold-review.md` - challenge whether `first-wave-priority.csv` is concrete enough for the next content task.
4. `04-contract-scope-review.md` - challenge whether the task stayed in prep-only scope and actually met the definition of done.

If a subagent review finds a substantive issue, fix it before calling the task done, or clearly surface the unresolved issue in result.md only after exhausting the strongest in-scope reasoning path.
If the open issue is a high-level question or judgment call, use the 4 subagents to converge on the best answer rather than stopping early.
If exactly 4 Codex subagent reviews do not happen and exactly 4 review artifacts do not exist, the task must not be marked done.

## Required checks
- verify every required output file physically exists
- verify `content-draft/tagalog/first-wave-priority.csv` exists and is non-empty
- verify exactly 4 review files exist under `.agent/tasks/T-008/reviews/`
- verify no `app/**` or runtime-wiring files were changed
- verify the lane is more authoring-ready than before by checking that the next Tagalog content task could start from the new scaffold without redoing the whole orientation pass

## Definition of done
The task is done only if all of these are true:
- Tagalog prep truth is materially stronger than before
- the first-wave shortlist is concrete, ranked, and useful
- the risk review is specific enough to prevent obvious bad promotions
- `first-wave-priority.csv` is good enough that the next task can start authoring from it immediately
- exactly 4 subagent review artifacts exist and substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- `.agent/tasks/T-008/result.md` states what changed, what was verified, what remains open, and whether the objective was fully met

## Blocker rule
- do not stop at the first uncertainty
- if a question remains open, still complete the strongest bounded scaffold you can
- if the issue is a high-level question, ambiguity, or judgment call that could still be resolved inside scope, use the mandatory 4-subagent pass to reason it through before calling the task partial or blocked
- only mark the task blocked if a real external dependency or true out-of-scope constraint prevents meaningful progress after that reasoning pass
- if the objective is only partly achieved even after the reasoning and review pass, say so plainly in `result.md` instead of calling it done

## Token discipline
- use this spec as the primary contract
- do not paste full CSVs or large dumps into `result.md`
- put the real scaffold and risk notes in the required durable files
- keep `result.md` compact, evidence-based, and honest about partial completion if needed

## Required result contract
Before stopping, write `.agent/tasks/T-008/result.md` with:
- status: `done`, `partial`, or `blocked`
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is `partial` or `blocked`, explain why the remaining gap survived the full reasoning plus 4-subagent review pass
- substantive risks or follow-up cautions
- recommended next step



