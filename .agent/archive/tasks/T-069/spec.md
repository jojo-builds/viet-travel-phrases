# Task Spec: T-069

## Title
Desktop Codex automation pilot, Tagalog v2 first-wave translation pack and starter-premium boundary pass

## Objective
Turn the current Tagalog v2 first-wave shortlist into a real authoring-ready translation pack that the runtime/content lane can build from next, while keeping starter vs premium boundaries honest and preserving the prep-only boundary.

This task should convert the current 24-row first-wave set into a stronger Tagalog output surface instead of reopening broad planning.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/V2_CONTENT_MODEL.md`
- `.agent/tasks/T-021/result.md`
- `.agent/tasks/T-032/result.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/scenario-plan.json`

## Task type
- translation authoring
- first-wave pack hardening
- starter-premium boundary prep

## Scope
### Allowed write scopes
- `.agent/tasks/T-069/**`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` for bounded reference only if needed to confirm family shape

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- `T-021` already produced the ordered 24-row first-wave contract. Start from that truth instead of redoing prioritization.
- The goal is real Tagalog v2 content progress, not another planning memo.
- Keep pronunciation and confidence posture honest where Tagalog register, loanword choice, or destination fit is still sensitive.
- Preserve the prep-only boundary. Do not wire Tagalog into runtime in this task.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `.agent/tasks/T-069/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-069/reviews/` for each required gate

## Concrete pack requirement
This task is not done unless it leaves behind a usable first-wave translation pack covering the currently prioritized Tagalog set.

That pack must:
- include at least the current 24 ranked first-wave outcomes from `first-wave-priority.csv`
- keep row-level linkage back to `scenario_id` and `phrase_id`
- distinguish starter-safe rows from premium-follow-on rows honestly
- mark confidence and review flags clearly enough that the next runtime/content pass can consume the work without another orientation step

## What the task must cover
- produce a Tagalog first-wave translation file for the current 24-row set
- tighten source notes and rewrite notes wherever translation choices expose register or ambiguity risk
- keep the current core / holdout / deferred split honest rather than flattening uncertainty
- clarify which rows are strong enough for next-step pack building and which still need expert follow-up
- keep starter-vs-premium boundary reasoning visible at the family level where the first-wave set touches both

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-first-wave-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are read-only except for their assigned review file.
- Keep review-only reads lean: `spec.md`, the claimed `state.json`, the target artifacts, and only the latest relevant prior review artifacts for that role.
- Create the current gate/pass folder on demand.

## Required checks
- verify every required output file physically exists
- verify `content-draft/tagalog/tagalog-v2-first-wave.csv` exists, parses, and covers at least 24 row outcomes
- verify the translation pack preserves `scenario_id` and `phrase_id` linkage
- verify latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed
- verify the Tagalog lane is more implementation-ready than before and no longer stops at shortlist-only truth

## Definition of done
- Tagalog v2 has a real first-wave translation pack for the current prioritized set
- starter-premium boundary posture is clearer and still honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved and runtime wiring remains untouched
- `.agent/tasks/T-069/result.md` states what changed, what was verified, what remains open, and the recommended next step

## Required result contract
Before stopping, write `.agent/tasks/T-069/result.md` with:
- status: `in_review`, `done`, `partial`, or `blocked`
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- create this result artifact before Gate 3 and keep it at `in_review` until the latest Gate 3 pass is unanimously approved
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step
