# Task Spec: T-088

## Title
Desktop Codex automation pilot, Tagalog v2 active follow-on completion and runtime-handoff hardening

## Objective
Continue the Tagalog v2 prep lane after `T-082` by resolving the remaining active follow-on rows, keeping the one deferred refusal row honest, and leaving the lane with a cleaner runtime-handoff-ready source surface instead of a fuzzy premium tail.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/archive/tasks/T-077/result.md`
- `.agent/archive/tasks/T-082/result.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/research-backlog.md`

## Task type
- translation authoring
- follow-on queue reduction
- runtime-handoff hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-088/**`
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
- Start from the narrowed `16 / 5 / 1` active Tagalog v2 handoff left by `T-082`.
- Bias this pass toward real row outcomes, not another planning memo.
- Keep `tagalog-polite-basics-4` as an explicit honesty boundary unless stronger evidence truly clears it.
- If the active worthwhile set is now smaller than `24`, clear the full active meaningful set and document any intentionally parked backlog rows honestly.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/research-backlog.md`
- `.agent/tasks/T-088/logs/follow-on-audit.md`
- `.agent/tasks/T-088/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-088/reviews/` for each required gate

## Concrete requirement
- resolve the remaining active premium-follow-on rows or convert them into explicit later-review decisions with reasons
- leave Tagalog v2 with a materially tighter and more implementation-ready handoff than after `T-082`
- keep confidence, loanword, and sensitive-row posture honest

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-pack-handoff-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify every required output file physically exists
- verify `content-draft/tagalog/phrase-source.csv`, `content-draft/tagalog/first-wave-priority.csv`, and `content-draft/tagalog/tagalog-v2-first-wave.csv` parse after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- Tagalog v2 active follow-on truth is materially tighter and more actionable than before
- the remaining queue is smaller or more honestly isolated
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
