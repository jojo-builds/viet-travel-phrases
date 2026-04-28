## T-144 implementation notes

### What changed

- Expanded the preview page model in `PhraseProductPrototype.tsx` so each page now carries:
  - implied-question framing
  - hero scene copy/icon treatment
  - query-adaptive situational labels
  - local-reality copy
  - cultural note
  - separate `commonFollowUps` and `exploreNext` page-open lanes
- Rebuilt the phrase preview into an AI-shaped answer surface with:
  - collapsing hero-image-style header
  - overlapping hero audio dock
  - `At a glance`
  - `Quick say`
  - query-adaptive alternate/situational lane
  - local-reality inset
  - `Break it down`
  - `When to use it`
  - `Common follow-ups`
  - `Cultural note`
  - `Explore next`
- Kept the existing search page, native/fallback shell split, and deeper page-stack navigation model intact.
- Updated `previewContent.ts` and `docs/phrase-page-blueprint.md` to describe the answer-page direction instead of the older grouped-card/detail-page framing.

### Interaction contract used

- `Quick say` and the alternate/situational lane use in-place `Swap hero` behavior.
- `Common follow-ups`, `Explore next`, and search results use deeper `Open page` behavior.
- Lower linked items call the existing preview page-stack opener and now also scroll the new page state back to the top.

### Validation notes

- `npx --no-install tsc --noEmit` passed from a clean worktree state.
- `npx expo export --platform web --output-dir dist-task-T144-check` passed.
- Exported bundle grep confirmed the updated web output carried the new answer-page strings, including:
  - `AI answer page`
  - `At a glance`
  - `Common follow-ups`
  - `Explore next`
  - `How do I ask for a doctor in Vietnam?`
  - `Open page`
- Source inspection confirmed lower linked-item open behavior is wired through `commonFollowUps`, `exploreNext`, `handleOpenNext`, and the page-stack `openPhrasePage` path.

### Fallback / runtime caveat

- The current repo TypeScript setup picks up files under `dist-task-T144-check` on a later `tsc` run because the default include pattern sees the generated bundle.
- That is a workflow/process bug, not a blocker for T-144 itself.
- I cleaned the generated `dist-task-T144-check` folder after validation so the required `tsc` check could pass again from the app cwd.

### Gate 2 pass 2 closeout

- Fixed the two Gate 2 pass 1 blockers:
  - `At a glance` now keeps `Best default` pinned to `defaultHeroId`.
  - back navigation now scrolls the shared page surface back to the top after popping the page stack.
- Re-ran validation in the safe order:
  - clean `dist-task-T144-check`
  - `npx --no-install tsc --noEmit`
  - `npx expo export --platform web --output-dir dist-task-T144-check`
- Exported bundle grep still confirms the answer-page proof strings:
  - `AI-shaped answer page`
  - `At a glance`
  - `Common follow-ups`
  - `Explore next`
  - `How do I ask for a doctor in Vietnam?`
  - `Open page`
  - `Swap hero`
- Gate 2 pass 2 reviewers were unanimous `APPROVE`.

### Gate 3 pass 1 closeout

- Gate 3 pass 1 reviewers were unanimous `APPROVE`.
- `result.md` was created in `in_review` status before the final gate, then finalized to `done` only after the unanimous Gate 3 consensus landed.
- Cleaned `dist-task-T144-check` again after proofing and reran `npx --no-install tsc --noEmit` so the app worktree ends the task in a clean TypeScript state.
