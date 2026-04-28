# Task Spec: T-150

## Title
Liquid Glass answer-page fidelity recovery closeout and remaining review-gate completion

## Objective
Recover interrupted `T-148` by auditing the already-landed Liquid Glass fidelity work, making only bounded corrective edits if needed, and then finishing the missing Gate 2, Gate 3, and result closeout artifacts cleanly.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-150/brief.md`
- `.agent/tasks/T-148/recovery-notes.md`
- `.agent/tasks/T-148/logs/liquid-glass-fidelity-pass-notes.md`
- `.agent/tasks/T-148/spec.md`
- `app/components/preview/PhraseProductPrototype.tsx`
- `app/components/preview/previewContent.ts`
- `app/docs/phrase-page-blueprint.md`

## Task type
- interrupted meaningful-task recovery
- liquid-glass fidelity closeout
- review-gate completion

## Scope
### Allowed write scopes
- `.agent/tasks/T-150/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`

### Allowed read scopes
- `.agent/tasks/T-148/**`
- `docs/**`
- `app/**`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\**`

### Must not touch
- `.agent/coordination/queue-index.json` except a final best-effort helper rebuild outside this task packet
- Viet content files / worktrees
- visual-board worktree files
- legacy `codex/liquid-glass-preview` implementation lane

## Recovery contract
- treat the current Liquid Glass worktree diff as the salvage surface
- keep the already-landed good work
- only make bounded corrective edits if the current code still needs a small cleanup before review
- finish the task; do not restart the original design pass from zero

## Required outputs
Create or update these files:
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\previewContent.ts`
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md`
- `.agent/tasks/T-150/logs/liquid-glass-fidelity-recovery-closeout.md`
- `.agent/tasks/T-150/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-150/reviews/` for each required gate

## Concrete requirements
- audit the current `T-148` landed implementation against its original objective
- preserve the strongest fidelity improvements already present
- make only bounded corrective edits if needed to satisfy review concerns
- rerun the required checks
- complete Gate 2 using the original visual-fidelity reviewer roles
- complete Gate 3 using the same reviewer roles
- finalize `result.md` only after unanimous Gate 3 approval

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-hero-and-dock-visual-review.md`
2. `02-typography-and-hierarchy-review.md`
3. `03-liquid-glass-native-feel-review.md`
4. `04-scope-and-fidelity-gap-review.md`

Gate 1 is already satisfied historically by `T-148` and should be treated as read-only context for this recovery.
This recovery task must complete:
- Gate 2 after the salvage audit / bounded cleanup pass
- Gate 3 before done

All active gates in this recovery task require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`:
- `npx --no-install tsc --noEmit`
- `npx expo export --platform web --output-dir dist-task-T150-check`

Also verify:
- the answer-page preview still renders
- the data-driven answer-page runtime still works
- the current result remains materially closer to the approved mockup than pre-`T-148`
- the latest pass for each active gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest active gate pass

## Definition of done
- interrupted `T-148` is effectively closed out through this recovery task
- the landed Liquid Glass fidelity work is preserved and, if necessary, lightly corrected
- Gate 2 and Gate 3 both passed unanimously
- `result.md` exists and accurately reflects the recovered task truth

## Blocker rule
- do not reopen the entire design direction debate
- do not block merely because the page could still be polished more in later work
- only report a blocker if the current landed work is unsalvageable or a real external dependency is missing
