# Task Spec: T-128

## Title
Desktop Codex automation pilot, shared search normalization replay and bounded matcher-shell packet

## Objective
Turn the blocked `T-073` findings into one clean successor that either lands a genuinely bounded shared-search fix or proves the current matcher and shell are already correct, while leaving a replayable smoke packet future queue workers can rerun without reopening the whole search-history thread.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-073/result.md`
- `app/lib/searchPhrases.ts`
- bounded shared-search files under `app/family/**`
- `content-draft/viet/**` as read-only query/wording reference
- `content-draft/tagalog/**` as read-only query/wording reference

## Task type
- shared-search runtime hardening
- bounded matcher and shell packet
- replayable smoke contract

## Scope
### Allowed write scopes
- `.agent/tasks/T-128/**`
- `app/lib/searchPhrases.ts`
- `app/family/**` within the bounded shared-search scope only

### Allowed read scopes
- `docs/**`
- `ops/**` as read-only context only
- `.agent/tasks/T-073/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `app/**` within search-related surfaces only

### Must not touch
- `site/**`
- `docs/operations/**`
- unrelated language lanes outside read-only wording comparison
- release/build/TestFlight files
- broad family-shell work outside shared search

## Source-of-truth notes
- `T-073` already proved the prior rerun closed as a bounded audit-plus-copy pass and then deadlocked on the Gate 3 review-loop paradox, not on a fresh repo defect.
- The remaining honest gap is a reusable replay packet plus any truly bounded matcher or shell correction that repo evidence still justifies.
- Do not invent device proof. This task is repo-local only.
- If current matcher behavior is already right for the tested edge cases, leave a stronger smoke packet and do not force fake code churn.
- If a real fix is needed, keep it tightly scoped to search normalization and shared-search guidance for traveler-query variants like `Wi-Fi` / `wifi` / `wi fi`, `check-in` / `check in` / `checkin`, and `eSIM` / `e-sim` / `esim`.

## Required outputs
Create or update these files:
- `app/lib/searchPhrases.ts` if a real bounded matcher fix is justified
- bounded shared-search surfaces under `app/family/**` only if a real shell or wording fix is justified
- `.agent/tasks/T-128/logs/shared-search-smoke-packet.md`
- `.agent/tasks/T-128/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-128/reviews/` for each required gate

## Concrete requirement
- exercise representative Viet and Tagalog traveler-query variants against current matcher truth and document the observed behavior clearly
- either land one bounded matcher or shell fix, or explain why no fix is the honest outcome
- leave one replayable smoke packet that a future queue worker can rerun quickly without reopening `T-073`
- keep the final packet explicit that device-side search proof still remains out of scope

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-search-normalization-review.md`
2. `02-viet-tagalog-query-coverage-review.md`
3. `03-bounded-runtime-scope-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- run the smallest relevant validation for touched search surfaces, including `npx --no-install tsc --noEmit` from `E:\AI\SpeakLocal-App-Family\app` if any TypeScript source changed
- capture the bounded query replay evidence in the task log
- verify every required output file physically exists
- verify no `site/**`, `docs/operations/**`, or unrelated language-lane files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- shared-search truth is either improved in a bounded way or more sharply proven as already-correct repo truth
- future queue workers have one replayable smoke packet instead of a fuzzy search-history dependency
- no fake device-proof or broad shell refactor was introduced
- all 3 mandatory review gates passed with unanimous 4-subagent approval
