# Task Spec: T-141

## Title
Tagalog substantial expansion recovery closeout and review-gate completion packet

## Objective
Recover the interrupted Tagalog substantial expansion task by auditing the already-landed work, rerunning the required validations, applying only bounded repairs if needed, and finishing the missing review/result closeout in a fresh task.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-141/brief.md`
- `.agent/tasks/T-139/state.json`
- `.agent/tasks/T-139/spec.md`
- `.agent/tasks/T-139/recovery-notes.md`
- `.agent/tasks/T-139/logs/tagalog-substantial-expansion-notes.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/scenario-plan.json`

## Task type
- recovery closeout
- tagalog validation and salvage
- review-gate completion

## Scope
### Allowed write scopes
- `.agent/tasks/T-141/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\content-draft\tagalog\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\packs\tagalog.generated.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\presentation\tagalog.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app\family\presentation\tagalogPremium.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\V2_CONTENT_MODEL.md` only if durable truth changes during repair
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\PHRASE_RELATIONSHIP_MODEL.md` only if durable truth changes during repair
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\DECISIONS.md` only if durable repo truth changes during repair
- `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\docs\PRIORITIES.md` only if durable roadmap truth changes during repair

### Allowed read scopes
- `.agent/tasks/T-139/**`
- `docs/**`
- `content-draft/tagalog/**`
- `app/family/**`
- `app/scripts/**`

### Must not touch
- the Viet expansion lane
- the Indonesian prep lane
- the Liquid Glass UI lanes
- `ops/**`
- `docs/operations/**`
- unrelated future-language lanes

## Source-of-truth notes
- `T-139` is historical interruption truth only; do not try to reopen it as the active task.
- The main Tagalog content pass already landed before interruption and should be preserved if validators still pass.
- This recovery task exists to finish the missing process layer cleanly in a fresh worker thread.

## Required outputs
Create or update these files:
- `.agent/tasks/T-141/logs/tagalog-recovery-closeout.md`
- `.agent/tasks/T-141/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-141/reviews/` for each required gate
- only repair the Tagalog worktree files if a concrete validator failure requires it

## Concrete requirements
- verify the recovered Tagalog branch truth and preserve the already-landed batch whenever possible
- confirm whether the branch still reflects the interrupted-task claims:
  - `63` new families
  - `126` new rows
  - Tagalog phrase-source total at `196`
- if the validators pass, do not redo the authoring pass
- if a validator fails, make the smallest bounded repair needed and revalidate
- write a concise recovery log that distinguishes:
  - what was already landed before recovery
  - what, if anything, needed repair during recovery
- finish the review/result layer in this new task folder instead of trying to backfill `T-139`

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-variant-discipline-review.md`
3. `03-relation-depth-review.md`
4. `04-recovery-salvage-review.md`

Gate 1 before edits, Gate 2 after validation/repair, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\tagalog-v2-expansion\app`:
- `npm run build:tagalog-pack`
- `npm run validate:family`
- `npm run validate:premium-boundary`
- `npm run validate:premium-expansion`

Also verify:
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate
- the recovery did not spill into the Viet, Indonesian, or Liquid Glass lanes

## Definition of done
- the interrupted Tagalog work is either validated as good or repaired in a bounded way
- the final recovered truth is captured in `.agent/tasks/T-141/result.md`
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- the branch is left in a pack-valid state
- the task clearly explains that `T-139` was interrupted and `T-141` is the clean recovery closeout

## Blocker rule
- do not restart the full Tagalog authoring pass just because the original thread died
- only report a blocker if a real external dependency or irreconcilable validator failure remains after bounded repair attempts

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
