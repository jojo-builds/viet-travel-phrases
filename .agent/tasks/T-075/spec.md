# Task Spec: T-075

## Title
Desktop Codex automation pilot, Indonesia first-wave translation pack and prep-ready expansion pass

## Objective
Turn the Indonesia lane from a newly authoring-ready scaffold into a real first-wave translation pack with materially stronger row coverage.
This task should clear the highest-value Indonesian rows first, then continue through the next coherent bounded batch so the lane leaves behind usable translation truth instead of another shortlist-only step.

This is still prep-only work. Do not wire Indonesian into the runtime app.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/LANGUAGE_PREP_WORKFLOW.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRIORITIES.md`
- `templates/FAMILY_TRAVELER_BASELINE.json`
- `.agent/tasks/T-064/result.md`
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/research-backlog.md`
- `research/language-pipeline/indonesian/**`

## Task type
- translation
- prep-only authoring
- bounded first-wave execution

## Scope
### Allowed write scopes
- `.agent/tasks/T-075/**`
- `content-draft/indonesian/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `content-draft/thai/**`
- `content-draft/japanese/**`
- `content-draft/turkish/**`
- `content-draft/spanish/**`
- `content-draft/italian/**`
- `content-draft/korean/**`
- `content-draft/german/**`
- `app/family/**` for bounded reference only if needed to understand pack shape

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring such as `app/family/appRegistry.js` or `app/family/currentApp.ts`
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- `T-064` already produced the Indonesia lane scaffold, the ranked first-wave shortlist, and the rewrite notes needed to start real translation work.
- Start from the current ranked shortlist instead of redoing scaffold planning.
- Rewrite weak English source where needed before literal translation.
- Keep register, politeness, and confidence posture honest where Indonesian traveler fit or sensitive wording still needs expert review.
- This task changes prep-only authoring truth, not runtime truth.

## Required outputs
Create or update these files:
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/research-backlog.md`
- `.agent/tasks/T-075/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-075/reviews/` for each required gate

## Concrete execution requirement
This task is not done unless it leaves visible large-batch progress behind.
For this task, that means:
- clear the top-ranked unresolved Indonesian first-wave rows before expanding into lower-priority work
- then continue into the next highest-value traveler rows from `content-draft/indonesian/phrase-source.csv` until at least `24` row outcomes total were translated, materially improved, or consciously deferred with explicit reasons
- if quality is holding and the bounded batch remains coherent, prefer finishing closer to `24-36` row outcomes rather than stopping at the floor
- `phrase-source.csv` has materially stronger `target_text`, `pronunciation`, `notes`, and `status` coverage than it had after `T-064`
- `first-wave-priority.csv` reflects which high-value rows were cleared, which remain blocked, and what the next Indonesian pass should target

## What the task must decide
- which top-ranked Indonesian rows are strong enough to clear now
- which next-highest-value rows should be pulled forward once the first unresolved set is exhausted
- which rows still need rewrite, expert review, or later localization decisions
- how pronunciation guidance should be handled honestly for the translated rows
- what the immediate next Indonesian pass should do after this larger batch

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-indonesian-language-risk-review.md`
3. `03-authoring-readiness-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are read-only except for their assigned review file.
- Keep review-only reads lean: `spec.md`, the claimed `state.json`, the target artifacts, and only the latest relevant prior review artifacts for that role.
- Create the current gate/pass folder on demand.

## Required checks
- verify every required output file physically exists
- verify `content-draft/indonesian/phrase-source.csv` still parses as CSV after edits
- verify `content-draft/indonesian/first-wave-priority.csv` still exists and remains non-empty
- verify review evidence exists for Gate 1, Gate 2, and Gate 3 under `.agent/tasks/T-075/reviews/`
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**` or runtime-wiring files were changed
- verify at least `24` total row outcomes were explicitly translated, materially improved, or consciously deferred with updated reasons unless the bounded high-value candidate set was fully exhausted and that exhaustion is proven in `result.md`
- verify the Indonesia lane is more implementation-ready than before and no longer stops at scaffold-only truth

## Definition of done
- the Indonesia lane has materially stronger first-wave translation coverage than before
- unresolved high-value Indonesian rows were cleared or consciously reclassified with explicit reasons
- the lane advanced by at least `24` row outcomes or proved that the bounded high-value candidate set was fully exhausted
- the next Indonesia pass can start from a meaningfully smaller unresolved set without another broad orientation loop
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved and runtime wiring is untouched
- `.agent/tasks/T-075/result.md` states what changed, what was verified, what remains open, and whether the objective was fully met

## Required result contract
Before stopping, write `.agent/tasks/T-075/result.md` with:
- status: `in_review`, `done`, `partial`, or `blocked`
- truth changed classification
- changed files with one-line reasons
- validation performed
- review findings and what was fixed
- create this result artifact before Gate 3 and keep it at `in_review` until the latest Gate 3 pass is unanimously approved
- if status is partial or blocked, explain why the remaining gap survived the full reasoning plus the 3-gate 4-subagent consensus loop
- summarize the final pass outcome for Gate 1, Gate 2, and Gate 3
- substantive risks or follow-up cautions
- recommended next step
