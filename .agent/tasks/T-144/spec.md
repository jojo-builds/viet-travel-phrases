# Task Spec: T-144

## Title
SpeakLocal V2 AI-shaped listing page implementation and connected phrase-answer workflow

## Objective
Implement the first substantial listing-page workflow that expresses SpeakLocal's confirmed product principle: each listing page should feel like a native iOS, Liquid-Glass answer surface for an implied travel-language query, not a flat phrase-detail record. The result should materially upgrade the preview route so it feels closer to "curated AI guidance inside a real app" while staying fully database-backed and audio-led.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-144/brief.md`
- `.agent/tasks/T-135/result.md`
- `.agent/tasks/T-137/result.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `app/docs/phrase-page-blueprint.md`
- `app/components/preview/PhraseProductPrototype.tsx`
- `app/components/preview/previewContent.ts`

## Task type
- liquid-glass listing-page implementation
- ai-shaped answer workflow
- connected phrase/product-page navigation

## Scope
### Allowed write scopes
- `.agent/tasks/T-144/**`
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
- `E:\AI\SpeakLocal-App-Family-worktrees\visual-screen-board\**`
- the legacy `codex/liquid-glass-preview` implementation lane as a write target

## Source-of-truth notes
- `codex/liquid-glass-native` is the current winning Liquid Glass implementation branch/worktree.
- `T-135` already landed the dedicated search page and `T-137` already lightened the lower section card system; this task should build on those wins, not reopen them.
- The confirmed product principle is now:
  - listing pages are AI-shaped answer pages, not simple phrase detail pages
  - the page should answer an implied prompt such as `Different ways to say hello in Vietnam`
- A blocker only counts as real if it requires user intervention or a real external dependency; missing bespoke assets are not blockers for this pass.

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `.agent/tasks/T-144/logs/ai-shaped-listing-page-notes.md`
- `.agent/tasks/T-144/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-144/reviews/` for each required gate

## Concrete requirements
- implement a materially richer preview listing page that communicates the "AI-shaped answer page" experience
- preserve the current Liquid Glass shell direction:
  - floating back button
  - hero/player area
  - bottom floating toolbar
- add or refine a hero image header so it behaves like a scrollable/collapsing header instead of a fixed wallpaper
- keep the phrase hero highly legible with:
  - phrase title
  - English translation
  - pronunciation
  - audio dock with favorite + play + 0.5x / 0.75x / 1.0x
- implement lower sections that clearly answer the implied user query:
  - `At a glance`
  - `Quick say`
  - `Situational greetings` or equivalent alternate/situational cluster
  - `How locals actually greet` or equivalent local-reality section
  - `Break it down`
  - `When to use it`
  - `Common follow-ups`
  - `Cultural note`
  - `Explore next`
- some lower cards or linked rows must navigate to another listing page state in preview
- the page should feel interconnected like tappable knowledge, not like a long static article
- the lower sections should stay lighter than the hero and must not regress into oversized stacked-card heaviness
- every non-English item shown must still have English support visible underneath or beside it
- the preview should make it obvious that the app is not "chatting", but is delivering an AI-style structured answer using curated phrase data and audio
- leave a believable fallback path for non-native / web preview environments

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-ai-answer-structure-review.md`
2. `02-liquid-glass-ios-feel-review.md`
3. `03-connected-phrase-navigation-review.md`
4. `04-scope-fallback-and-roi-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`:
- `npx --no-install tsc --noEmit`
- `npx expo export --platform web --output-dir dist-task-T144-check`

Also verify:
- the updated preview route still renders in the dashboard/web lane
- the page now reads more like an answer workflow than a flat phrase-detail screen
- at least one lower linked phrase/card opens another listing-page state in preview
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the preview listing page materially reflects the confirmed "AI-shaped answer page" principle
- the hero image/header, audio dock, and bottom toolbar feel aligned with the locked native iOS Liquid Glass direction
- the lower sections feel more like a useful guided answer than a database dump
- connected phrase navigation is visible in the preview
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- repo truth/docs stay aligned where they genuinely changed

## Blocker rule
- do not stop because of ordinary layout, copy, or section-structure ambiguity if bounded implementation and review can resolve it
- do not block on custom imagery or mascot polish; use an acceptable placeholder or existing local art treatment when needed
- only report a blocker if it requires real user input, external service access, or a hard technical limitation not solvable inside the task

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
