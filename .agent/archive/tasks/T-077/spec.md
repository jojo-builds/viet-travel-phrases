# Task Spec: T-077

## Title
Desktop Codex automation pilot, Tagalog v2 starter-core graduation pack and unresolved-row reduction

## Objective
Strengthen the Tagalog v2 prep lane beyond the current 24-row handoff by hardening the 16 starter-core rows into a cleaner graduation-ready pack, reducing the highest-value unresolved rows, and leaving the next runtime/content task with a more implementation-ready source surface.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/V2_CONTENT_MODEL.md`
- `.agent/tasks/T-032/result.md`
- `.agent/tasks/T-069/spec.md`
- `.agent/tasks/T-069/result.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`

## Task type
- translation authoring
- starter-core graduation prep
- unresolved-row reduction

## Scope
### Allowed write scopes
- `.agent/tasks/T-077/**`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
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
- Bias this pass toward real Tagalog progress, not another planning memo.
- Preserve the prep-only boundary. Do not wire Tagalog into runtime in this task.
- Treat the current 16 starter-core rows as the must-harden set, then pull forward the best non-overlapping unresolved rows if they materially improve the handoff.
- Keep starter versus premium and confidence posture honest.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/risk-review.md`
- `.agent/tasks/T-077/logs/pack-hardening.md`
- `.agent/tasks/T-077/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-077/reviews/` for each required gate

## Concrete requirement
- leave behind at least 24 row outcomes that are clearly classified across starter-core, premium-follow-on, or deferred-review
- improve the implementation-readiness of the starter-core slice enough that the next runtime/content task can consume it with less orientation and fewer unresolved wording notes
- reduce at least one real unresolved cluster instead of only reformatting docs

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-pack-graduation-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are read-only except for their assigned review file.
- Keep review-only reads lean: `spec.md`, the claimed `state.json`, the target artifacts, and only the latest relevant prior review artifacts for that role.
- Create the current gate/pass folder on demand.

## Required checks
- verify every required output file physically exists
- verify `content-draft/tagalog/tagalog-v2-first-wave.csv` parses and still carries at least 24 row outcomes with `scenario_id` and `phrase_id` linkage
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- Tagalog v2 starter-core truth is materially more implementation-ready than before
- the unresolved queue is smaller or better bounded than before
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved and runtime wiring remains untouched
- `.agent/tasks/T-077/result.md` states what changed, what was verified, what remains open, and the recommended next step
