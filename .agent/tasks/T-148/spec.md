# Task Spec: T-148

## Title
SpeakLocal V2 Liquid Glass answer-page visual fidelity pass toward approved mockup

## Objective
Implement the next major frontend pass on the winning Liquid Glass branch so the coded answer-page experience looks materially closer to the approved design direction. This task should focus on visible frontend fidelity, not on introducing new content concepts or reopening the answer-page data model.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-148/brief.md`
- `.agent/tasks/T-144/result.md`
- `.agent/tasks/T-147/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `app/docs/phrase-page-blueprint.md`
- `app/components/preview/PhraseProductPrototype.tsx`
- `app/components/preview/previewContent.ts`
- `app/lib/vietAnswerPagePreview.ts`
- `app/data/viet-answer-page-preview.json`

## Task type
- liquid-glass frontend fidelity pass
- answer-page visual refinement
- preview-lane visual upgrade

## Scope
### Allowed write scopes
- `.agent/tasks/T-148/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\lib\vietAnswerPagePreview.ts` only if small presentation mapping changes are needed
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\data\viet-answer-page-preview.json` only if a bounded preview presentation field is required
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\docs\DECISIONS.md` only if durable branch truth changes

### Allowed read scopes
- `docs/**`
- `app/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\docs\**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- the Viet content worktree as a write target
- `ops/**`
- `docs/operations/**`
- the visual-board worktree as a write target
- the legacy `codex/liquid-glass-preview` implementation lane as a write target

## Source-of-truth notes
- `T-147` already proved the data-driven answer-page runtime consumer.
- The next problem is visible fidelity, not structure.
- The page should continue to behave like an AI-shaped answer page, but visually move closer to the approved mockup direction:
  - destination hero image
  - premium typography
  - central glass audio dock
  - calmer, more refined section styling
  - more intentional bottom toolbar
- A blocker only counts as real if it requires user intervention or a real external dependency; ordinary visual ambiguity should be resolved inside the task.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `.agent/tasks/T-148/logs/liquid-glass-fidelity-pass-notes.md`
- `.agent/tasks/T-148/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-148/reviews/` for each required gate

## Concrete requirements
- materially improve the top portion of the answer page to better match the approved mockup direction
- upgrade the hero image area so it feels more atmospheric, premium, and destination-led
- improve the back button treatment so it feels more like a premium floating Liquid Glass control
- improve typography hierarchy for:
  - country/app label
  - Vietnamese hero phrase
  - English translation
  - pronunciation
- refine the audio dock so the favorite, play, and speed controls feel more like one premium centered control surface
- refine lower section styling so the answer modules feel more elegant and intentional
- refine the bottom toolbar so it feels native and visually cohesive with the page
- preserve all core runtime behavior from `T-147`
- do not remove the data-driven answer-page consumer
- the result should be something the user can open in preview and immediately recognize as meaningfully closer to the approved design

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-hero-and-dock-visual-review.md`
2. `02-typography-and-hierarchy-review.md`
3. `03-liquid-glass-native-feel-review.md`
4. `04-scope-and-fidelity-gap-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`:
- `npx --no-install tsc --noEmit`
- `npx expo export --platform web --output-dir dist-task-T148-check`

Also verify:
- the updated preview route still renders in the dashboard/web lane
- the page still behaves as a data-driven answer page
- the visual result is materially closer to the approved mockup direction than before
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the answer-page preview looks materially closer to the approved target design
- the hero image, audio dock, typography, and toolbar all feel upgraded
- the data-driven answer-page runtime stays intact
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the page is not pixel-perfect or because bespoke image assets are still placeholders
- do not reopen content-model or relation-work unless a tiny presentation-safe fix is strictly required
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
