# Task Spec: T-116

## Title
Desktop Codex automation pilot, Tagalog v2 expansion-cluster pickup and graduation-boundary hardening pass

## Objective
Take the now-explicit Tagalog starter handoff and convert the ordered next-pass expansion cluster into one sharper graduation-ready contract. The goal is not broad new planning, it is to make the direct-pickup set, deferred boundary, and later-only hold story clearer enough that the next runtime-facing Tagalog lane can start from one durable handoff.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-103/result.md`
- `.agent/tasks/T-109/result.md`
- `.agent/tasks/T-114/spec.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`

## Task type
- Tagalog prep-lane deepening
- expansion-cluster pickup
- graduation-boundary hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-116/**`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` for bounded contract reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated language lanes except read-only comparison

## Source-of-truth notes
- Start from the exact five-row next-pass expansion cluster and the two-row later-only hold boundary already recorded by `T-103` and `T-109`.
- Stay prep-only, do not claim Tagalog is live runtime truth.
- Prefer one durable graduation-ready handoff over a tiny translation cleanup.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`
- `.agent/tasks/T-116/logs/tagalog-expansion-cluster-audit.md`
- `.agent/tasks/T-116/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-116/reviews/` for each required gate

## Concrete requirement
- turn the current ordered expansion cluster into one clearer direct-pickup contract with at least `24` meaningful row outcomes still visible across starter, deferred, pickup, and later-only buckets unless bounded repo truth proves the useful set is smaller
- align `phrase-source.csv`, `first-wave-priority.csv`, `tagalog-v2-first-wave.csv`, and `scenario-plan.json` on the same direct-pickup versus later-only story
- leave an explicit graduation boundary showing what would still block runtime-safe promotion after this pass
- record a compact audit that explains why the resulting Tagalog handoff is easier to retrieve than the current split across prior task results

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-graduation-handoff-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/tagalog/scenario-plan.json` still parses as JSON
- verify `content-draft/tagalog/phrase-source.csv`, `first-wave-priority.csv`, and `tagalog-v2-first-wave.csv` still parse after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or `ops/**` files changed

## Definition of done
- Tagalog has one sharper direct-pickup and graduation-boundary handoff than the current multi-result split
- the next runtime-facing Tagalog lane can start from this contract without reopening backlog-shape ambiguity
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
