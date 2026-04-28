# Task Spec: T-140

## Title
Indonesian substantial prep-lane expansion and future runtime-handoff packet

## Objective
Expand the Indonesian prep lane well beyond its current partial state so the future Indonesia app has a materially stronger practical phrase base, clearer prioritization, and a more useful handoff packet for later runtime consideration.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-140/brief.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/LANGUAGE_PREP_WORKFLOW.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/scenario-plan.json`
- `content-draft/indonesian/source-notes.md`

## Task type
- indonesian prep-lane expansion
- future-language practical coverage growth
- prep-handoff hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-140/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\content-draft\indonesian\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\docs\LANGUAGE_PREP_WORKFLOW.md` only if durable prep truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\docs\DECISIONS.md` only if durable repo truth changes
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\docs\PRIORITIES.md` only if durable roadmap truth changes

### Allowed read scopes
- `docs/**`
- `content-draft/indonesian/**`
- `templates/**`

### Must not touch
- the Viet lane
- the Tagalog lane
- the Liquid Glass UI lanes
- `app/family/**` runtime-wiring surfaces
- `ops/**`
- `docs/operations/**`

## Source-of-truth notes
- Indonesian is prep-only and should remain prep-only in this task.
- The lane already has a translated core and support pack, so the next useful move is a larger practical expansion rather than tiny holdout churn.
- This task exists to make meaningful use of parallel compute on a future app lane while active runtime/design work continues elsewhere.
- Internal ambiguity about exact row mix is not a blocker; the task should resolve that through bounded authoring and review.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\content-draft\indonesian\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\content-draft\indonesian\first-wave-priority.csv`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\content-draft\indonesian\README.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\content-draft\indonesian\source-notes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\content-draft\indonesian\research-backlog.md`
- `.agent/tasks/T-140/logs/indonesian-expansion-notes.md`
- `.agent/tasks/T-140/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-140/reviews/` for each required gate

## Concrete requirements
- land a substantial prep-lane batch of at least `48` new or newly-resolved row outcomes unless the bounded Indonesia-fit set is genuinely smaller
- focus on practical Indonesia-fit traveler moments such as:
  - ride-hailing and pickup friction
  - payment and QR / cash / card clarity
  - port / ferry / island-travel support
  - hotel and room issues
  - food adjustments and common restrictions
  - pharmacy / acute help / simple-problem recovery
- keep the shared 10-scenario seam unless a clearly justified prep-only supplemental grouping improves the lane
- leave the lane better prioritized and more runtime-discussion-ready than before
- keep the lane prep-only and do not wire it into `app/family`
- leave a concise but real packet note explaining what was added and why it matters

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-indonesia-fit-review.md`
3. `03-prioritization-and-handoff-review.md`
4. `04-scope-and-prep-boundary-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\app` when helpful commands exist:
- `npx --no-install tsc --noEmit`

Also verify:
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate
- the task did not spill into runtime wiring or the active app lanes

## Definition of done
- Indonesian prep truth grows materially instead of inching forward
- the lane becomes easier to use later for runtime/product decisions
- the task justifies the heavy review process
- the lane remains prep-only
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the perfect Indonesia roadmap is not settled
- only report a blocker if it requires real user intervention, external service access, or a hard dependency outside the task scope

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
