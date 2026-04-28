# Task Spec: T-147

## Title
Viet answer-page runtime consumer and data-driven listing-page integration

## Objective
Implement the first meaningful preview/runtime consumer for the Viet answer-page content seam. The Liquid Glass listing-page prototype should stop behaving like a mostly hardcoded demo and start rendering real answer-page sections from structured Viet sample data, while preserving the current AI-shaped answer workflow and connected phrase navigation.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-147/brief.md`
- `.agent/tasks/T-144/result.md`
- `.agent/tasks/T-145/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `app/docs/phrase-page-blueprint.md`
- `app/components/preview/PhraseProductPrototype.tsx`
- `app/components/preview/previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\answer-page-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\relation-sample-v1.json`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\phrase-source.csv`

## Task type
- liquid-glass listing-page integration
- viet answer-page consumer
- preview/runtime data wiring

## Scope
### Allowed write scopes
- `.agent/tasks/T-147/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\lib\**` if a small helper or local preview fixture is needed
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\data\**` if a copied/derived preview fixture is needed
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\docs\DECISIONS.md` only if durable branch truth changes

### Allowed read scopes
- `docs/**`
- `app/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\docs\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion\content-draft\viet\**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- the Viet content worktree as a write target
- `ops/**`
- `docs/operations/**`
- the visual-board worktree as a write target
- the legacy `codex/liquid-glass-preview` implementation lane as a write target

## Source-of-truth notes
- `T-144` proved the UI/workflow for AI-shaped listing pages.
- `T-145` proved the Viet answer-page content seam with `24` enriched hubs across `4` phrase classes.
- This task should bridge those two wins by consuming the Viet answer-page sample in the preview lane.
- The content lane is read-only source context here. If a preview-local derived data file is needed, create it in the Liquid Glass worktree and document its provenance.
- A blocker only counts as real if it requires user intervention or a real external dependency; content/section wiring ambiguity should be resolved inside the task.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\data\viet-answer-page-preview.json` if needed as a derived preview fixture
- `.agent/tasks/T-147/logs/viet-answer-page-consumer-notes.md`
- `.agent/tasks/T-147/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-147/reviews/` for each required gate

## Concrete requirements
- render answer-page sections from structured Viet sample data instead of hardcoded answer copy wherever practical
- support at least `4` real proof hubs from the Viet answer-page sample, spanning at least `3` phrase classes
- preserve the current interaction split:
  - `Swap hero` for same-page answer variation
  - `Open page` for deeper linked-page destinations
- prove that different phrase classes can render different module mixes without forcing one repeated section template
- preserve the current Liquid Glass shell and hero/control treatment
- keep the page readable and product-like; do not expose raw schema mechanics to the user
- if a local derived preview data file is introduced, it must clearly note its upstream source and stay bounded to preview/demo use
- make the preview meaningfully closer to what the real app should do, not just a static design concept

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-data-consumer-review.md`
2. `02-answer-page-ux-review.md`
3. `03-navigation-and-module-mix-review.md`
4. `04-scope-fallback-and-provenance-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`:
- `npx --no-install tsc --noEmit`
- `npx expo export --platform web --output-dir dist-task-T147-check`

Also verify:
- the updated preview route still renders in the dashboard/web lane
- at least `4` real Viet answer hubs are being rendered from structured data
- at least `3` phrase classes prove distinct module mixes in the preview behavior
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the listing-page preview is materially data-driven from the Viet answer-page sample
- the UI and content/model wins are now bridged into one visible proof
- different phrase classes render meaningfully different answer shapes
- the current Liquid Glass interaction model stays intact
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because the preview consumer is not a full production data pipeline yet
- do not block on perfect asset parity or mascot polish
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
