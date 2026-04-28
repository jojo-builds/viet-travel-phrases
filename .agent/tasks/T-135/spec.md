# Task Spec: T-135

## Title
SpeakLocal V2 search page, App Store-style dedicated search flow and Liquid Glass shell integration

## Objective
Implement the next major search interaction pass for the current Liquid Glass direction: when the user taps the bottom-right magnifier, the app should transition into a dedicated Search Page with App Store-inspired structure and toolbar behavior, while preserving the current listing-page/product-page direction and the calmer readable content layer underneath the shell.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-135/brief.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `app/docs/phrase-page-blueprint.md`
- `app/components/preview/PhraseProductPrototype.tsx`
- `app/components/preview/previewContent.ts`

## Task type
- liquid-glass app shell expansion
- dedicated search-page UX implementation
- preview-lane interaction hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-135/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\docs\DECISIONS.md` only if durable repo truth changes

### Allowed read scopes
- `docs/**`
- `app/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\docs\**`

### Must not touch
- `.agent/coordination/queue-index.json` after claim unless this task explicitly needs a final best-effort sync note
- unrelated content-draft authoring surfaces
- `ops/**`
- `docs/operations/**`
- unrelated release/TestFlight files
- the legacy `codex/liquid-glass-preview` implementation lane as a write target

## Source-of-truth notes
- `codex/liquid-glass-native` is the current winning Liquid Glass implementation branch/worktree.
- The authenticated dashboard Expo web lane remains the default cheap review loop.
- Paid iPhone builds are milestone validation only and are not the completion bar for this task.
- A blocker only counts as a real blocker if it requires user intervention or a real external dependency; internal uncertainty should be resolved inside the task.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `.agent/tasks/T-135/logs/search-page-implementation-notes.md`
- `.agent/tasks/T-135/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-135/reviews/` for each required gate

## Concrete requirements
- replace the confusing partial search-overlay behavior with a dedicated search-page flow in the preview prototype
- keep the bottom-right magnifier trigger as the shell entry point
- inside the dedicated search page, show App Store-inspired structure for:
  - `Search`
  - `Suggested`
  - `Browse`
- make toolbar behavior honest and simple:
  - only the originating toolbar icon should remain visible while inside search mode
- typed results should use the larger listing cards in a one-column relevance-ordered lane
- tapping the card should open the listing page
- tapping the play affordance should transition into the listing page already playing
- keep the Liquid Glass treatment strongest in the shell/control layer, not as a full-page glass wash
- preserve a believable fallback path for non-native / web preview environments

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-search-flow-review.md`
2. `02-liquid-glass-shell-review.md`
3. `03-phrase-card-transition-review.md`
4. `04-scope-and-fallback-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`:
- `npx --no-install tsc --noEmit`
- `npx expo export --platform web --output-dir dist-task-T135-check`

Also verify:
- the updated preview route still renders in the dashboard/web lane
- the task leaves a dedicated search-page flow rather than a muddled partial overlay
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the preview prototype has a clearer dedicated search-page flow that matches the approved product direction better than the prior overlay behavior
- the shell and toolbar behavior feel intentionally App Store-inspired without turning into a literal copy exercise
- the larger listing cards and play-to-detail transition are represented clearly enough for product review
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because of internal ambiguity about layout or motion if bounded implementation and review can resolve it
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
