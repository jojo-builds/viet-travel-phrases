# Task Spec: T-129

## Title
Desktop Codex automation pilot, Viet live-audio orphan disposition and parity packet

## Objective
Replace the blocked `T-099` follow-up-batch story with one honest live-seam packet that resolves or explicitly codifies the remaining orphan MP3 posture, keeps manifest, registry, and physical-file truth aligned, and leaves future audio work with a cleaner post-cleanup baseline.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-099/result.md`
- `.agent/tasks/T-123/result.md`
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md`
- `app/assets/audio/manifest.json`
- `app/assets/audio/registry.ts`
- bounded `app/assets/audio/**` within the current live Viet seam

## Task type
- live audio seam cleanup
- orphan disposition packet
- parity hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-129/**`
- `content-draft/viet/audio-review/**`
- `app/assets/audio/**` within the bounded orphan and parity scope only

### Allowed read scopes
- `docs/**`
- `ops/**` as read-only context only
- `content-draft/viet/**`
- `app/**` within the bounded audio seam only
- `.agent/tasks/T-099/**`
- `.agent/tasks/T-123/**`

### Must not touch
- `site/**`
- `docs/operations/**`
- unrelated language lanes
- release/build/TestFlight files
- broad app-shell or content work outside the Viet audio seam

## Source-of-truth notes
- `T-123` already established the honest live seam as `919` ready rows plus `2` orphan MP3s and converted the stale `342 planned` pool into historical residue.
- `T-099` is blocked because its premise is no longer honest: the sampled allowlist is already live and the spec still pointed at a nonexistent `app/family/packs/viet.json` seam.
- The remaining gap is not a fake new batch. The remaining gap is one explicit disposition and parity contract for the orphan files and any still-ambiguous live-seam wording.
- Keep continuity and release claims conservative. Do not overstate same-speaker proof or broader listening validation.

## Required outputs
Create or update these files:
- `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md`
- `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md`
- `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md`
- `app/assets/audio/manifest.json`
- `app/assets/audio/registry.ts`
- bounded files under `app/assets/audio/**` only if the honest orphan disposition requires it
- `.agent/tasks/T-129/logs/viet-audio-orphan-parity.md`
- `.agent/tasks/T-129/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-129/reviews/` for each required gate

## Concrete requirement
- decide whether `problems-5.mp3` and `problems-7.mp3` should be promoted into the live seam, removed or rehomed, or explicitly preserved as non-shipping orphans
- make physical files, manifest, registry, and audio-review docs tell the same story after the pass
- if deletion or movement is not the honest safe action, leave an explicit non-shipping orphan contract instead of vague orphan wording
- leave one compact audit explaining the final disposition, the resulting parity counts, and what future audio work no longer needs to rediscover

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-audio-parity-review.md`
2. `02-orphan-disposition-review.md`
3. `03-continuity-honesty-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify `app/assets/audio/manifest.json` still parses as JSON
- verify the registry still matches the final manifest and physical-file disposition story
- verify every required output file physically exists
- verify no `site/**`, `docs/operations/**`, or unrelated language-lane files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the post-cleanup Viet audio seam has one explicit orphan disposition story instead of ambiguous residue
- manifest, registry, physical files, and audio-review docs agree
- no fake new follow-up batch or inflated release-confidence claim was introduced
- all 3 mandatory review gates passed with unanimous 4-subagent approval
