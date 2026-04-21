# Task Spec: T-096

## Title
Desktop Codex automation pilot, Tagalog v2 starter-core promotion pack and deferred-row recheck

## Objective
Strengthen the Tagalog v2 lane for the next real runtime/content handoff by rechecking the promoted starter-core contract, resolving the lone deferred refusal row honestly, and converting the parked later-review backlog into an explicit ordered handoff instead of a fuzzy future bucket.

This is still prep-only work. Do not wire Tagalog into runtime truth from this task.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-021/result.md`
- `.agent/tasks/T-077/result.md`
- `.agent/tasks/T-082/result.md`
- `.agent/tasks/T-088/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/rewrite-notes.md`

## Task type
- prep-lane hardening
- starter-core handoff tightening
- deferred and backlog triage

## Scope
### Allowed write scopes
- `.agent/tasks/T-096/**`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` for bounded family-shape reference only

### Must not touch
- `app/**`
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- Start from the current `16` promoted core rows, the `1` deferred refusal row, and the `7` parked later-review rows.
- The main win is a cleaner next handoff, not fake runtime promotion.
- Preserve explicit caution around refusal tone, respectful acknowledgement, hotel-arrival wording, payment wording, and pronunciation uncertainty.
- If a parked row still does not deserve to re-enter the active handoff, leave it parked with a sharper reason instead of forcing promotion.
- The bounded set here is the current `24` row decision surface, so cover that whole surface rather than doing a tiny partial pass.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`
- `.agent/tasks/T-096/logs/tagalog-handoff-audit.md`
- `.agent/tasks/T-096/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-096/reviews/` for each required gate

## Concrete requirement
- re-verify the current `16` starter-core rows as the real promotion-ready prep set
- make an explicit keep-deferred or promote decision on `tagalog-polite-basics-4`
- reclassify the `7` parked backlog rows into an ordered next-pass contract with honest reasons
- leave one crisp handoff that tells the next Tagalog runtime/content worker exactly what is in scope now, what is deferred, and what stays later-review

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-tagalog-core-handoff-review.md`
2. `02-register-and-risk-review.md`
3. `03-backlog-triage-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify the changed Tagalog CSV surfaces still parse cleanly
- verify the final handoff still preserves prep-only truth and does not claim runtime promotion
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Tagalog lane has a clearer next-runtime/content prep handoff than before
- the promoted core, deferred row, and parked backlog now form one explicit contract
- every changed surface stays inside `content-draft/tagalog/**` plus task artifacts
- all 3 mandatory review gates passed with unanimous 4-subagent approval
