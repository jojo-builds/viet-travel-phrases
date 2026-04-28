# Task Spec: T-137

## Title
SpeakLocal V2 grouped listing-card system and lighter lower-section layout for the phrase product page

## Objective
Implement the next phrase-page UX pass for the current Liquid Glass direction: keep the existing hero shell and dedicated search page, but redesign the lower sections of the phrase product page so grouped small listing cards, compact lanes, and lighter content treatments replace the old stacked-card feeling.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-137/brief.md`
- `.agent/tasks/T-135/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `app/docs/phrase-page-blueprint.md`
- `app/components/preview/PhraseProductPrototype.tsx`
- `app/components/preview/previewContent.ts`

## Task type
- liquid-glass phrase-page refinement
- grouped listing-card UX implementation
- lower-content hierarchy hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-137/**`
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
- the Viet content expansion lane
- `ops/**`
- `docs/operations/**`
- the legacy `codex/liquid-glass-preview` implementation lane as a write target
- the separate visual-board lane/worktree

## Source-of-truth notes
- `codex/liquid-glass-native` is the current winning Liquid Glass implementation branch/worktree.
- `T-135` already landed the dedicated App-Store-style search page; this task must preserve that direction rather than re-open it.
- The lower phrase sections should become lighter and more content-led while the shell/control layer remains the strongest Liquid Glass surface.
- A blocker only counts as real if it requires user intervention or a real external dependency; internal layout ambiguity should be resolved inside the task through implementation and review.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `.agent/tasks/T-137/logs/grouped-listing-cards-notes.md`
- `.agent/tasks/T-137/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-137/reviews/` for each required gate

## Concrete requirements
- redesign the lower half of the phrase product page so it no longer reads as a dated stack of large rounded cards
- keep the lower modules clearly separated as:
  - `Quick say`
  - `Break it down`
  - `Other ways`
  - `When to say`
  - `Next`
- use grouped small listing cards, compact tiles, rows, or lane treatments where that makes the sections more scannable
- every non-English item shown in the lower sections must still have English visible underneath
- keep the hero area as the strongest playback surface and do not scatter big competing play buttons throughout the lower sections
- make same-family options feel like in-place hero-update choices or tightly related grouped options
- make `Next` feel like forward navigation to deeper listing pages
- preserve the dedicated search-page flow and the existing Liquid Glass shell entry/exit behavior
- leave a believable fallback path for non-native / web preview environments

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-lower-section-layout-review.md`
2. `02-information-hierarchy-review.md`
3. `03-grouped-listing-card-review.md`
4. `04-shell-compatibility-and-fallback-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`:
- `npx --no-install tsc --noEmit`
- `npx expo export --platform web --output-dir dist-task-T137-check`

Also verify:
- the updated preview route still renders in the dashboard/web lane
- the page reads lighter and more grouped below the hero than before
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the phrase product page lower half feels materially less stacked-card-heavy than before
- grouped small listing-card treatment is visible enough for product review
- English support text remains obvious under non-English content
- the hero still reads as the main playback surface
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because of ordinary layout or motion ambiguity if bounded implementation and review can resolve it
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
