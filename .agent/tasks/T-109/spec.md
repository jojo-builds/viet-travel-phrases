# Task Spec: T-109

## Title
Desktop Codex automation pilot, Tagalog v2 starter handoff clustering and retrieval-ready contract pass

## Objective
Strengthen the Tagalog v2 prep lane without pretending it is runtime-ready. Rework the current 16-core-plus-parked-backlog handoff into one sharper starter contract, one explicit next-pass expansion cluster, and one cleaner later-only hold boundary that downstream runtime or content work can pick up without rereading the whole lane.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-096/result.md`
- `.agent/tasks/T-103/result.md`
- `docs/PRIORITIES.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`

## Task type
- prep-lane restructuring
- starter-to-expansion contract hardening
- retrieval-ready handoff cleanup

## Scope
### Allowed write scopes
- `.agent/tasks/T-109/**`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` for bounded runtime-shape reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- Stay prep-only. Do not imply the current Tagalog lane is promoted into runtime truth.
- Use the current `16` starter-core rows, `1` deferred refusal row, and `7` parked rows as the live lane truth to reorganize, not the older active-follow-on story.
- Prefer a stronger reusable handoff contract over a tiny row-by-row cleanup pass.
- Make downstream pickup easier by clarifying scenario grouping, reopen order, and starter versus later-only boundary in one pass.

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
- `.agent/tasks/T-109/logs/tagalog-starter-contract.md`
- `.agent/tasks/T-109/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-109/reviews/` for each required gate

## Concrete requirement
- audit the full current Tagalog first-wave plus parked-backlog surface, not just the five-row pickup note
- leave one explicit starter handoff contract, one explicit next-pass expansion cluster, and one explicit later-only hold boundary
- ensure the reworked contract covers at least `24` row outcomes across starter, deferred, pickup, and later-only rows unless bounded verification proves the current high-value set is smaller
- use `scenario-plan.json` and the narrative docs to make the next runtime or content pickup path easier to retrieve and reuse

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-handoff-structure-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify required output files exist
- verify `content-draft/tagalog/phrase-source.csv`, `content-draft/tagalog/first-wave-priority.csv`, and `content-draft/tagalog/tagalog-v2-first-wave.csv` still parse cleanly after edits
- verify `scenario-plan.json` stays valid JSON
- verify no `app/**`, `site/**`, `ops/**`, or runtime-wiring files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Tagalog v2 lane has a sharper retrieval-ready starter contract and a cleaner honest expansion boundary
- downstream pickup no longer depends on rereading multiple older task results to understand what is active versus parked
- all 3 mandatory review gates passed with unanimous 4-subagent approval
