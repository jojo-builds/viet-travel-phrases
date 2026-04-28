# Task Spec: T-146

## Title
SpeakLocal V2 answer-page visual board refresh and current-state review upgrade

## Objective
Refresh the visual screen-board workflow so it captures and presents the new AI-shaped listing-page states introduced by `T-144`. The result should make it easier to review the current state of the app visually in one place while content/model work proceeds in parallel on the Viet lane.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-146/brief.md`
- `.agent/tasks/T-138/result.md`
- `.agent/tasks/T-144/result.md`
- `docs/DECISIONS.md`
- `app/docs/app-preview-wireframes.md`
- `app/scripts/generate-design-board.ts`
- `app/scripts/capture-design-preview.ts`
- `app/artifacts/design-boards/latest/manifest.json`

## Task type
- visual-review-system refresh
- design-board upgrade
- answer-page state capture

## Scope
### Allowed write scopes
- `.agent/tasks/T-146/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\capture-design-preview.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\generate-design-board.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\artifacts\design-boards\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\docs\app-preview-wireframes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\package.json` only if needed for a new script
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\docs\DECISIONS.md` only if durable repo truth changes

### Allowed read scopes
- `docs/**`
- `app/docs/**`
- `app/lib/**`
- `app/scripts/**`
- `app/artifacts/**`
- `.agent/tasks/T-138/**`
- `.agent/tasks/T-144/**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- the active Liquid Glass implementation files on `codex/liquid-glass-native`
- the Viet content expansion lane
- `ops/**`
- `docs/operations/**`

## Source-of-truth notes
- `T-138` already established the visual-board workflow.
- `T-144` changed the meaningfully important phrase/listing states by turning the page into an AI-shaped answer surface.
- This task should refresh the board so it reflects current review truth rather than the older phrase-page capture set.
- A blocker only counts as real if it requires user intervention or a real external dependency; ordinary capture/labeling issues should be resolved inside the task.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\capture-design-preview.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\generate-design-board.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\artifacts\design-boards\latest\`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\docs\app-preview-wireframes.md`
- `.agent/tasks/T-146/logs/answer-page-board-refresh-notes.md`
- `.agent/tasks/T-146/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-146/reviews/` for each required gate

## Concrete requirements
- refresh the board so it includes the current answer-page states from `T-144`
- make sure the board clearly includes or distinguishes:
  - default answer-page state
  - hero swap / same-page answer variation
  - deeper linked-page open state
  - search-related state if available in the current capture seam
- improve labels or tile metadata so reviewers can tell what each state is proving
- keep the artifact refreshable and rooted in the existing capture workflow
- if useful, add a simple grouping or ordering improvement so the board reads more like:
  - shell/search
  - answer pages
  - deeper linked states
- keep the board honest about source route/state and capture time

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-answer-state-coverage-review.md`
2. `02-board-clarity-review.md`
3. `03-refresh-workflow-review.md`
4. `04-non-overlap-and-utility-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app`:
- the board-generation command(s) needed for this task
- `npx --no-install tsc --noEmit` if the worktree dependency path is available, otherwise document the existing dependency-thin limitation honestly

Also verify:
- the board artifact regenerates under `app/artifacts/design-boards/latest/`
- the refreshed board clearly shows the newer answer-page states
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the visual board reflects the current `T-144` answer-page direction better than before
- the board is more useful as a one-glance review surface
- the workflow stays disjoint from active UI/content implementation lanes
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the board is not perfect or because Figma is not part of the loop yet
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
