# Task Spec: T-085

## Title
Desktop Codex automation pilot, South Korea residual-tail triage and native-review handoff pack

## Objective
Use the narrowed post-T-079 Korean lane to resolve the last worthwhile unresolved rows, isolate anything that should stay pending for stronger native or expert review, and leave behind a compact handoff-ready prep surface instead of a vague low-value tail.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-079/result.md`
- `content-draft/korean/README.md`
- `content-draft/korean/source-notes.md`
- `content-draft/korean/phrase-source.csv`
- `content-draft/korean/first-wave-priority.csv`
- `content-draft/korean/research-backlog.md`

## Task type
- translation authoring
- residual-tail triage
- prep-lane handoff hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-085/**`
- `content-draft/korean/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**` for boundary reference only
- `app/family/**` for bounded family-shape reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- Start from the `8` unresolved rows left by `T-079`.
- Keep context-sensitive service wording and the medically sensitive line explicitly review-visible.
- If the unresolved tail is genuinely too small or low-value for direct translation, convert that tail into a clear native-review or defer-later handoff instead of forcing filler work.
- Preserve Hangul as display truth and use pronunciation only as helper support.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/korean/README.md`
- `content-draft/korean/source-notes.md`
- `content-draft/korean/phrase-source.csv`
- `content-draft/korean/first-wave-priority.csv`
- `content-draft/korean/research-backlog.md`
- `.agent/tasks/T-085/logs/residual-tail-audit.md`
- `.agent/tasks/T-085/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-085/reviews/` for each required gate

## Concrete requirement
- resolve the remaining meaningful Korean row outcomes or convert them into explicit defer/native-review decisions with reasons
- leave the lane with a clearly documented final residual posture instead of a fuzzy unresolved tail
- keep review flags and pronunciation posture honest on sensitive rows

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-korean-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify required output files exist
- verify `content-draft/korean/phrase-source.csv` parses as CSV after edits
- verify `content-draft/korean/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the South Korea prep lane residual tail is resolved or honestly converted into explicit later-review posture
- risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
