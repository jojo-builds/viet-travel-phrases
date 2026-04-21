# Task Spec: T-125

## Title
Desktop Codex automation pilot, Tagalog v2 direct-pickup promotion packet and runtime-handoff hardening

## Objective
Convert the current Tagalog v2 prep lane from a passive "five direct-pickup rows remain" story into one retrieval-ready promotion packet that says exactly what should advance next, what still stays deferred or later-only, and what a future runtime/content lane can trust without rereading older Tagalog queue history.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `.agent/tasks/T-109/result.md`
- `.agent/tasks/T-114/result.md`
- `.agent/tasks/T-116/result.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/scenario-plan.json`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/relation-sample-v1.json`

## Task type
- Tagalog v2 handoff hardening
- prep-to-runtime promotion packet
- retrieval-ready content contract work

## Scope
### Allowed write scopes
- `.agent/tasks/T-125/**`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` as read-only runtime-shape reference only
- `site/**` as read-only phrasing/reference only

### Must not touch
- `app/**` as a write surface
- `site/**` as a write surface
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated language lanes except read-only comparison

## Source-of-truth notes
- `T-109` established a structured `24`-outcome handoff contract with `16` starter rows, `1` deferred boundary row, `5` direct-pickup rows, and `2` later-only hold rows.
- `T-114` made that same contract retrieval-ready by giving the `24` outcomes explicit row-linked relation metadata.
- `T-116` added one explicit graduation-boundary object so the pickup cluster and later-only holds are no longer spread across prose-only docs.
- The current gap is not more broad planning. The gap is one crisp promotion packet that says which of the five direct-pickup rows should advance into the next runtime-ready slice, what stays out, and how future lanes should use the same contract without re-reading old task results.
- Keep the lane honest: Tagalog is still `prepared-next`, not live, and this task must not pretend runtime wiring or app integration already happened.

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
- `.agent/tasks/T-125/logs/tagalog-runtime-handoff-packet.md`
- `.agent/tasks/T-125/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-125/reviews/` for each required gate

## Concrete requirement
- turn the current `5` direct-pickup rows into one exact ordered promotion packet with row ids, rationale, and an explicit answer for whether each row is `promote now`, `keep prep-only`, `defer for native/expert review`, or `later-only`
- preserve the `1` deferred refusal boundary and the `2` later-only hold rows as explicit non-promoted truth unless repo evidence truly justifies a tighter boundary
- make `README.md`, row-level CSV notes, `scenario-plan.json`, `research-backlog.md`, and `risk-review.md` all tell the same next-lane story
- leave one compact audit explaining what a future Tagalog runtime/content lane can trust immediately, what it still must validate, and what no longer needs to be rediscovered from `T-109`, `T-114`, or `T-116`
- keep the work meaningful and synthesis-heavy, not a thin wording cleanup

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-tagalog-handoff-truth-review.md`
2. `02-promotion-boundary-review.md`
3. `03-retrieval-contract-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify `phrase-source.csv`, `first-wave-priority.csv`, and `tagalog-v2-first-wave.csv` still parse cleanly
- verify `scenario-plan.json` still parses and exposes a single coherent promotion / defer / later-only contract
- verify every required output file physically exists
- verify no `app/**`, `site/**`, `ops/**`, `docs/operations/**`, or unrelated language-lane files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Tagalog has one exact direct-pickup promotion packet instead of a vague next-pass story
- future runtime/content work can trust one current handoff contract without re-reading older queue history
- the deferred refusal row, later-only holds, and any not-yet-promoted pickup rows remain honest and explicit
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no runtime wiring, app-surface edits, or fake live-readiness claims were introduced
