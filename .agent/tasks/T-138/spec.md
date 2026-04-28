# Task Spec: T-138

## Title
SpeakLocal V2 visual screen board and refreshable screenshot contact-sheet workflow

## Objective
Create a refreshable visual review board that shows current app screens and major preview states in one place so the user can scan what exists, compare progress, and spot UX gaps without having to navigate the Expo preview manually.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-138/brief.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `app/docs/app-preview-wireframes.md`
- `app/lib/designReviewPresets.ts`
- `app/scripts/capture-design-preview.ts`

## Task type
- visual review-system buildout
- screenshot/contact-sheet workflow
- dashboard-preview artifact hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-138/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\capture-design-preview.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\generate-design-board.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\artifacts\design-boards\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\docs\app-preview-wireframes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\package.json` only if a new script command is needed
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\docs\DECISIONS.md` only if durable repo truth changes

### Allowed read scopes
- `docs/**`
- `app/docs/**`
- `app/lib/**`
- `app/scripts/**`
- `app/artifacts/**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- the active Liquid Glass UI files on `codex/liquid-glass-native`
- the Viet content expansion lane
- `ops/**`
- `docs/operations/**` except for read-only grounding

## Source-of-truth notes
- The dashboard/authenticated Expo web lane is the default cheap review loop for UI work.
- The repo already has:
  - hidden `design-preview` routes
  - deterministic `design-live` presets
  - `capture:design`
  - existing screenshot artifacts under `app/artifacts/design-captures/`
- This task should build a reusable visual-review artifact from those seams rather than introducing a separate hand-maintained mock board.
- Figma is a possible later destination, but this task should create immediate value without depending on a Figma seat or Figma MCP setup.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\capture-design-preview.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\scripts\generate-design-board.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\artifacts\design-boards\latest\` with the generated visual board artifact(s)
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\docs\app-preview-wireframes.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app\package.json` only if needed for a new script
- `.agent/tasks/T-138/logs/design-board-workflow-notes.md`
- `.agent/tasks/T-138/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-138/reviews/` for each required gate

## Concrete requirements
- produce a human-reviewable board artifact that shows multiple current screens/states in one place
- the board should be easy to scan and should label each screen/state clearly
- the workflow should use the existing preview/capture infrastructure where possible
- support at least the currently meaningful preview surfaces already grounded in the repo, such as:
  - `design-preview` slides
  - `design-live` presets when available through the current capture seam
- create a refresh workflow so future sessions can regenerate the board as features land
- document how to run the refresh workflow
- keep the output useful immediately, even without Figma
- make the artifact easy to use later as a Figma handoff/input if the team connects Figma MCP

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-screen-coverage-review.md`
2. `02-refresh-workflow-review.md`
3. `03-artifact-clarity-review.md`
4. `04-non-overlap-and-figma-readiness-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\app`:
- `npx --no-install tsc --noEmit`
- any capture/generation command(s) introduced by the task

Also verify:
- the board artifact is actually generated under `app/artifacts/design-boards/latest/`
- the refresh workflow can be followed from the docs without guesswork
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- a current-screen visual board exists and can be scanned without navigating Expo manually
- the artifact is generated by a repeatable workflow, not just hand-assembled once
- the workflow and artifact remain disjoint from the active Liquid Glass shell implementation files
- the result is useful now and leaves a clean path to future Figma adoption
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the board is not perfect or because Figma is not connected yet
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
