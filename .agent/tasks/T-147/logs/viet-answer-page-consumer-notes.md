# T-147 Viet answer-page consumer notes

## Gate 1 revised plan

### Source-of-truth contract

- The preview consumer will treat the Viet content worktree as read-only source context only.
- Real preview pages will map 1:1 to upstream answer-page sample hubs.
- `familyId` will be the canonical preview page identity for search, browse, and deeper navigation.
- The derived fixture will preserve upstream provenance per page:
  - `hubId`
  - `familyId`
  - `relationClusterId`
  - source file paths
  - selected phrase ids used for default / quick / alternate variants

### Derived preview fixture contract

- Generate a preview-local fixture under `app/data/**` so the Liquid Glass worktree can consume bounded runtime-style data without reaching across worktrees at runtime.
- Build these lookup surfaces explicitly:
  - `hubById`
  - `hubByFamilyId`
  - `phraseById`
  - `linkableRelationTargets`
  - `unresolvedRelationTargets`
- Include all 24 answer-page hubs in the derived fixture so the consumer seam scales beyond the minimum proof set.

### Navigation and fallback rules

- Only render `Open page` when a relation target resolves to another sampled hub in the local preview fixture.
- Unresolved relation targets must never appear as fake page opens.
- When a bucket contains unresolved targets, preserve the lane with resolved targets first and render any remaining unresolved items only as non-page guidance copy if needed.
- Search results, browse cards, suggested cards, and linked rows must all resolve through the same `familyId -> page` index.
- Resolver rule: `relation targetFamilyId -> hubByFamilyId[targetFamilyId]` when the target exists in the sampled hub set.

### Proof set for visible multi-class validation

- Keep all 24 hubs available, but make these four hubs clearly discoverable in the preview as the visible proof set:
  - `viet-greeting-thank-you`
  - `viet-medical-pharmacy`
  - `viet-repair-number`
  - `viet-directions-map-pin`
- This proof set spans all 4 authored phrase classes and includes real variant/link coverage.

### UX guardrails

- Preserve the current Liquid Glass shell, collapsing hero, playback dock, and answer-first framing.
- Do not expose raw module ids or schema mechanics to the traveler.
- `Quick say` and the swap lane must be variant-aware:
  - if a hub has a distinct quick phrase or alternates, keep the swap treatment
  - if it does not, collapse or relabel the section instead of showing a no-op `Swap hero`
- `Break it down` must be class-aware and derived only from authored source fields such as phrase text, English, pronunciation, context, and nearby module guidance.

### Module-copy normalization rules

- Normalize module copy before rendering:
  - strip repetitive scaffolding phrases
  - prefer concrete phrase text and context from `phrase-source.csv`
  - use relation reasons only when they improve traveler-facing follow-up labeling
- Preserve distinct module mixes across the four phrase classes with visibly different lower-page card and row groupings.

### Discovery updates

- Replace the old hardcoded medical-only suggested and browse configuration with real sampled hubs across multiple phrase classes.
- Search prompt chips should also reflect real hub language instead of the previous fixed doctor/pharmacy demo set.
- Update `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\docs\phrase-page-blueprint.md` in the same task pass so the documented proof set matches the new multi-class preview shape.
- Keep that truth sync scoped to the preview-local blueprint only; broader operations and onboarding docs remain unchanged.

## Implementation pass

- Added `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\data\viet-answer-page-preview.json` as a bounded preview-only derived fixture with explicit upstream provenance, the full `24` sampled hubs, search/browse prompts, and the `4`-family visible proof set.
- Added `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\lib\vietAnswerPagePreview.ts` to convert the raw fixture into runtime-facing preview surfaces:
  - `previewPhrasePages`
  - `previewPhraseHeroes`
  - `previewSearchBrowseCards`
  - `previewSearchSuggestedPageIds`
  - `previewSearchPromptQueries`
  - `previewStartingPageId`
- Refactored `PhraseProductPrototype.tsx` to consume the derived preview data instead of the earlier hardcoded answer-page copy and medical-only page set.
- Kept the current interaction split intact:
  - same-family quick/alternate phrases still `Swap hero`
  - resolved relation targets still `Open page`
  - unresolved relation targets now stay as preview-only guidance notes instead of fake page opens
- Preserved distinct lower-page shapes by phrase class through class-aware labels, local-reality copy, breakdown guidance, module-card mixes, and lane fallback rules.
- Synced `previewContent.ts` and `phrase-page-blueprint.md` to describe the new structured-Viet consumer rather than the earlier mostly hardcoded concept pass.

## Validation notes

- `npx --no-install tsc --noEmit` passed before export from `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app`.
- `npx expo export --platform web --output-dir dist-task-T147-check` passed and produced the web bundle for preview proof checks.
- Exported bundle grep confirmed the expected answer-page/search proof strings were present, including `Viet answer-page preview`, `Warm starts`, `Urgent help`, `Repair lane`, `Get there`, `Open page`, and `Swap hero`.
- Runtime fixture proof check confirmed:
  - `24` hubs
  - `4` phrase classes
  - `4` visible proof families
  - `4` distinct module mixes across the proof set
- Removed `dist-task-T147-check` after inspection and reran `npx --no-install tsc --noEmit`; the clean worktree compile passed again.

## Gate 2 pass 1 blockers and fixes

- Review pass 1 blocked on two categories:
  - preview identity guards were too trusting around resolved relation targets and `previewStartingPageId`
  - visible traveler copy still leaked preview/sample scaffolding and the local-reality lane was not fully coherent on repair/practical pages
- Fixes landed:
  - filtered resolved relation links against the local `familyId` page set before creating `Open page` rows
  - added a safe fallback for `previewStartingPageId` and a defensive `openPhrasePage` guard for page/hero ids
  - rewrote repair implied-question copy to `get things back on track`
  - added class-aware `localRealityNote` support, switched practical pages to use the authored `local-reality` module, and made the rendered local-reality heading/meta match the page-specific title
  - removed `Preview note` / `current sample` / `No shorter in-place variant` traveler copy in favor of product-facing fallback wording
  - hid `Common follow-ups` and `Explore next` sections when they have no real linked destinations instead of rendering empty prototype-feeling headings
- Post-fix validation rerun:
  - `npx --no-install tsc --noEmit` passed
  - `npx expo export --platform web --output-dir dist-task-T147-check` passed
  - exported bundle grep confirmed the new copy (`Keep moving`, `get things back on track`, `shortest strong version`) and found no matches for the removed blocker strings (`when I need repair`, `Preview note`, `current sample`, `No shorter in-place variant in this sample`)
  - removed `dist-task-T147-check` and reran `npx --no-install tsc --noEmit`; the clean worktree compile passed again

## Gate 2 pass 2 blocker and fix

- Review pass 2 found one remaining traveler-facing coherence issue: `Common follow-ups` and `Explore next` could still surface the same deeper destination on the same page, which made the lower half feel templated instead of curated.
- Fix landed:
  - de-duped `Explore next` against the already-selected `Common follow-ups` page ids inside the shared lane builder so the two discovery lanes stay intentionally distinct
- Post-fix validation rerun:
  - `npx --no-install tsc --noEmit` passed
  - `npx expo export --platform web --output-dir dist-task-T147-check` passed
  - a targeted overlap check over the full preview sample reported `0` common/explore page-id overlaps, including `0` overlaps across the four visible proof families
  - removed `dist-task-T147-check` and reran `npx --no-install tsc --noEmit`; the clean worktree compile passed again

## Gate 2 pass 3 blocker and fix

- Review pass 3 found one more navigation-quality issue in the lane builder: `Explore next` was being de-duped after its lane had already been sliced, so pages that should have backfilled into the now-open explore slot could still be stranded.
- Fix landed:
  - changed the lane builder so `pickLaneContent` returns the full resolved de-duped candidate set for each lane
  - kept the `Common follow-ups` slice at the page level
  - filtered `Explore next` against the already-selected common page ids before its own `slice(0, 2)` so later eligible explore targets can backfill correctly
- Validation refresh after the fix:
  - `npx --no-install tsc --noEmit` passed
  - `npx expo export --platform web --output-dir dist-task-T147-check` passed
  - export grep confirmed the expected preview/runtime strings were still present, including `Open page`, `Swap hero`, `Keep moving`, `get things back on track`, `shortest strong version`, `Viet answer-page preview`, `Warm starts`, `Urgent help`, `Repair lane`, and `Get it done`
  - targeted fixture proof check reported:
  - `24` hubs
  - `4` phrase classes
  - `4` visible proof families
  - `4` distinct proof-set module mixes
  - `0` common/explore overlaps across the full sample
  - `repair-number` specifically retained `common = [transport-destination, service-print]` and `explore = [repair-write-down, repair-repeat]`
  - removed `dist-task-T147-check` and reran `npx --no-install tsc --noEmit`; the clean worktree compile passed again

## Gate 3 pass 1 blocker and fix

- Review pass 1 found no remaining code/runtime blocker. The only block was artifact readiness:
  - `result.md` still said Gate 2 and Gate 3 consensus were pending
  - its review inventory still stopped at Gate 1
- Fix landing:
  - sync `result.md` to the current gate truth, validation proof, and latest review artifact set before rerunning Gate 3

## Gate 3 pass 2 closeout

- No implementation files changed between Gate 3 pass 1 and pass 2.
- After syncing `result.md` and the task notes to the current truth, all four reviewers approved closure.
