# Task Spec: T-123

## Title
Desktop Codex automation pilot, Viet historical audio truth cleanup and orphan disposition packet

## Objective
Replace the now-invalid "next batch promotion" story with one honest live-audio packet. Reconcile the stale `autonomous-500` `audio_status=planned` rows against the already-live `919`-row Viet seam, decide and document what should happen with the `2` unmapped legacy MP3s, and leave the audio lane with one durable packet future planning can trust without reopening `T-092` or `T-099`.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-092/result.md`
- `.agent/tasks/T-099/result.md`
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md`
- `content-draft/viet/autonomous-500/generated-rows.csv`
- `content-draft/viet/phrase-source.csv`
- `app/assets/audio/manifest.json`
- `app/assets/audio/registry.ts`

## Task type
- audio truth cleanup
- historical-lane reconciliation
- orphan disposition packet

## Scope
### Allowed write scopes
- `.agent/tasks/T-123/**`
- `content-draft/viet/audio-review/**`
- `content-draft/viet/autonomous-500/generated-rows.csv`

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `app/assets/audio/**`
- `research/**` if a bounded pronunciation or continuity note needs context only

### Must not touch
- `site/**`
- `ops/**`
- `docs/operations/**`
- `app/**` as a write surface unless a concrete live seam defect is proven and documented
- unrelated language lanes
- new MP3 generation or broad audio-regeneration work
- a fake "next runtime batch" story if repo truth shows the coverage already exists

## Source-of-truth notes
- The live Viet seam currently stands at `919` approved rows marked audio-ready, with `919` manifest entries, `919` registry imports, and `921` physical MP3 files including `2` unmapped legacy files.
- `T-092` already proved the stale `autonomous-500` `planned` pool overlaps the live seam rather than exposing a real audio gap.
- `T-099` is blocked because its task story assumes a real follow-up batch promotion is still needed and points at a nonexistent `app/family/packs/viet.json` seam.
- Treat the historical `autonomous-500` `planned` pool as truth to reconcile, not as missing live audio.
- Keep continuity language cautious. This is not same-speaker proof.

## Required outputs
Create or update these files:
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md`
- `content-draft/viet/autonomous-500/generated-rows.csv`
- `.agent/tasks/T-123/logs/audio-truth-cleanup.md`
- `.agent/tasks/T-123/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-123/reviews/` for each required gate

## Concrete requirement
- convert the stale `autonomous-500` `audio_status=planned` story into honest historical truth for the overlapping live-covered rows instead of leaving a fake missing-audio narrative
- make all touched audio docs agree on the live `919 ready / 2 orphan` seam, the stale historical-pool disposition, and the next real work boundary
- leave an explicit disposition for the `2` unmapped legacy MP3s, such as keep-ignored with reason, archive candidate, or bounded follow-up investigation, without overstating confidence
- keep the output meaningful by improving lane-level truth and retrieval, not by doing a tiny sample-only note refresh

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-audio-truth-review.md`
2. `02-continuity-risk-review.md`
3. `03-orphan-disposition-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify `content-draft/viet/autonomous-500/generated-rows.csv` still parses after edits
- verify `content-draft/viet/phrase-source.csv` still shows `919` approved ready rows as a read-only check
- verify `app/assets/audio/manifest.json` and `app/assets/audio/registry.ts` still reconcile to `919` mapped live entries unless a real documented seam defect changes that truth
- verify physical Viet MP3 inventory still reconciles to `921` total files with `2` unmapped legacy files, unless a task-scoped archival decision deliberately changes that number and is documented
- verify every required output file physically exists
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `site/**`, `ops/**`, or `docs/operations/**` files changed
- verify no `app/**` writes occurred unless a concrete seam defect required them and the result documents why

## Definition of done
- no ambiguous Viet audio follow-up batch story remains for the current live seam
- future planning can see, from one compact packet, that live seam coverage is complete while the stale historical lane has been reconciled honestly
- the `2` unmapped legacy MP3s have an explicit bounded disposition
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no fake runtime-audio expansion claim was introduced
