# Task Spec: T-006

## Title
Desktop Codex automation pilot, Spain research plus first authoring scaffold

## Objective
Make the Spanish prep lane materially more authoring-ready for a Spain-focused pack, not just more documented.
This task should turn the existing Spain / Spanish scaffold into a stronger next-step lane by producing:
- a durable Spain / Spanish travel research synthesis
- a clear regional/localization stance for traveler-safe Spain usage
- a ranked first-wave starter shortlist
- one concrete authoring scaffold that the next translation task can start from immediately

This is prep-only work. Do not wire Spanish into the runtime app.

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
- `templates/FAMILY_TRAVELER_BASELINE.json`
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/scenario-plan.json`
- `content-draft/spanish/phrase-source.csv`
- `research/exec-summary.md`
- `research/competitor-pain-analysis-2026-04-01.md`

## Task type
- research
- planning
- prep-only authoring scaffold

## Scope
### Allowed write scopes
- `.agent/tasks/T-006/**`
- `.agent/coordination/locks.yaml`
- `research/language-pipeline/spanish/**`
- `content-draft/spanish/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/thai/**`
- `content-draft/tagalog/**`
- `content-draft/viet/**`
- `content-draft/japanese/**`
- `content-draft/turkish/**`
- `content-draft/italian/**`
- `app/family/**` for bounded reference only if needed to understand pack shape

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring such as `app/family/appRegistry.js` or `app/family/currentApp.ts`
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- This task is successful only if Spanish is left more authoring-ready than it was before.
- Keep the destination-first SpeakLocal model: Spain is the destination, Spanish is the language layer.
- Keep the shared 10-scenario seam unless research finds a strong reason to adjust scenario tips or quick-phrase emphasis.
- Favor short, socially safe, service-usable phrases over textbook-complete phrasing.
- Keep the pack scoped to Spain rather than generic all-Spanish-world coverage.

## Required outputs
Create or update these files:
- `research/language-pipeline/spanish/SPAIN-TRAVEL-RESEARCH.md`
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/scenario-plan.json` only if research justifies better Spain-specific tips or quick-phrase priorities
- `content-draft/spanish/first-wave-priority.csv`
- `content-draft/spanish/research-backlog.md`
- `.agent/tasks/T-006/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-006/reviews/`

## Concrete authoring scaffold requirement
This task is not done unless it leaves one practical next-authoring artifact behind.
For this task, that artifact is:
- `content-draft/spanish/first-wave-priority.csv`

That CSV must rank the first authoring wave and include at minimum:
- `rank`
- `scenario_id`
- `phrase_id` or source slot reference
- `english_text`
- `priority_reason`
- `confidence`
- `review_flag`

## What the research must cover
- destination framing: Spain / Spanish
- traveler-use reality, not classroom sequencing
- regional/localization stance for Spain traveler usage
- pronunciation posture for English-speaking travelers
- repair-layer and likely-reply opportunities
- high-risk phrases that need later expert review
- recommendation for what the first Spain starter pack should prioritize
- search/localization implications relevant to Spain-targeted traveler retrieval

## Mandatory 4-subagent review gate
Before finalizing, use exactly 4 Codex subagents and save their outputs under `.agent/tasks/T-006/reviews/`.
Use these exact subagent review artifact names:
1. `01-traveler-utility-review.md`
2. `02-language-risk-review.md`
3. `03-authoring-scaffold-review.md`
4. `04-contract-scope-review.md`

If a subagent review finds a substantive issue, fix it before calling the task done, or clearly surface the unresolved issue in result.md only after exhausting the strongest in-scope reasoning path.
If the open issue is a high-level question or judgment call, use the 4 subagents to converge on the best answer rather than stopping early.
If exactly 4 Codex subagent reviews do not happen and exactly 4 review artifacts do not exist, the task must not be marked done.

## Required checks
- verify every required output file physically exists
- verify `content-draft/spanish/first-wave-priority.csv` exists and is non-empty
- verify `content-draft/spanish/scenario-plan.json` parses if touched
- verify exactly 4 review files exist under `.agent/tasks/T-006/reviews/`
- verify no `app/**` or runtime-wiring files were changed
- verify the lane is more authoring-ready than before by checking that the next translation task could start from the new scaffold without redoing the orientation pass

## Definition of done
The task is done only if all of these are true:
- Spanish prep truth is materially stronger than before
- the research synthesis is durable and specific
- the first-wave shortlist is concrete, ranked, and useful
- `first-wave-priority.csv` is good enough that the next task can start authoring from it immediately
- exactly 4 subagent review artifacts exist and substantive findings were handled
- prep-only boundary is preserved and runtime wiring is untouched
- `.agent/tasks/T-006/result.md` states what changed, what was verified, what remains open, and whether the objective was fully met

## Blocker rule
- do not stop at the first uncertainty
- if a question remains open, still complete the strongest bounded scaffold you can
- if the issue is a high-level question, ambiguity, or judgment call that could still be resolved inside scope, use the mandatory 4-subagent pass to reason it through before calling the task partial or blocked
- only mark the task blocked if a real external dependency or true out-of-scope constraint prevents meaningful progress after that reasoning pass
- if the objective is only partly achieved even after the reasoning and review pass, say so plainly in `result.md` instead of calling it done

## Token discipline
- use this spec as the primary contract
- do not paste full research dumps into `result.md`
- put real synthesis in the required durable files
- keep `result.md` compact, evidence-based, and honest about partial completion if needed

## Required result contract
Before stopping, write `.agent/tasks/T-006/result.md` with:
- status: `done`, `partial`, or `blocked`
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- if status is `partial` or `blocked`, explain why the remaining gap survived the full reasoning plus 4-subagent review pass
- substantive risks or follow-up cautions
- recommended next step



