# Task Spec: T-142

## Title
Indonesian prep-lane recovery closeout and final review-gate completion packet

## Objective
Recover the interrupted Indonesian prep-lane expansion task by auditing the already-landed work, rerunning the required validation checks, applying only bounded repairs if needed, and completing the missing Gate 3/result closeout in a fresh task.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-142/brief.md`
- `.agent/tasks/T-140/state.json`
- `.agent/tasks/T-140/spec.md`
- `.agent/tasks/T-140/recovery-notes.md`
- `.agent/tasks/T-140/logs/indonesian-expansion-notes.md`
- `.agent/tasks/T-140/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/LANGUAGE_PREP_WORKFLOW.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/scenario-plan.json`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/research-backlog.md`

## Task type
- recovery closeout
- indonesian prep-lane validation and salvage
- review-gate completion

## Scope
### Allowed write scopes
- `.agent/tasks/T-142/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\content-draft\indonesian\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\docs\LANGUAGE_PREP_WORKFLOW.md` only if durable prep truth changes during repair
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\docs\DECISIONS.md` only if durable repo truth changes during repair
- `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\docs\PRIORITIES.md` only if durable roadmap truth changes during repair

### Allowed read scopes
- `.agent/tasks/T-140/**`
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
- `T-140` is historical interruption truth only; do not reopen it as the active task.
- The substantive Indonesian pass already landed before the worker thread stalled.
- This recovery task exists to finish the missing Gate 3 and final closeout in a fresh worker thread.

## Required outputs
Create or update these files:
- `.agent/tasks/T-142/logs/indonesian-recovery-closeout.md`
- `.agent/tasks/T-142/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-142/reviews/` for each required gate
- only repair Indonesian prep-lane files if a concrete validation or review issue requires it

## Concrete requirements
- verify the recovered Indonesian branch truth and preserve the already-landed packet whenever possible
- confirm whether the branch still reflects the interrupted-task claims:
  - lane total at `115` rows
  - exactly `48` new or newly resolved outcomes
- if the checks pass, do not redo the Indonesian authoring pass
- if a check or review reveals a concrete issue, make the smallest bounded repair needed and revalidate
- write a concise recovery log that distinguishes:
  - what was already landed before recovery
  - what, if anything, needed repair during recovery
- finish the review/result layer in this new task folder instead of trying to backfill `T-140`

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-indonesia-fit-review.md`
3. `03-prioritization-and-handoff-review.md`
4. `04-recovery-salvage-review.md`

Gate 1 before edits, Gate 2 after validation/repair, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\indonesian-expansion-pack\app` when helpful commands exist:
- `npx --no-install tsc --noEmit`

Also verify:
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate
- the recovery stayed prep-only and did not spill into runtime wiring or active app lanes

## Definition of done
- the interrupted Indonesian work is either validated as good or repaired in a bounded way
- the final recovered truth is captured in `.agent/tasks/T-142/result.md`
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- the lane remains prep-only
- the task clearly explains that `T-140` was interrupted and `T-142` is the clean recovery closeout

## Blocker rule
- do not redo the full Indonesian authoring pass just because the original thread died
- only report a blocker if a real external dependency or irreconcilable review/validation issue remains after bounded repair attempts

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
