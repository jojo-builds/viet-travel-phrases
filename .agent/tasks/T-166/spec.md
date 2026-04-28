# T-166: Fold Saved And Practice Personalization Into Home, Practice, And Offline Data Contracts

## Outcome

Turn Jojo's saved/practice-pool product direction into a durable SpeakLocal source-of-truth contract, then reconcile the newly completed `T-162` practice design packet and `T-164` homepage research packet against that contract.

The desired end state is clear: SpeakLocal should remember what a user saves, practices, recently opens, and misses locally on device, then use that local intent signal to shape Home, Explore shelves, category rows, practice entry, and future SQLite-backed recommendations. This is a product/data synthesis task, not a Swift implementation task.

## Why This Exists

`T-162` completed a strong language-first practice design, but Jojo's late steer did not land before the worker finalized. The missing piece is that practice must be user-selected and phrase-sourced: users add phrase pages or phrase rows to a local practice pool, and the app should bias future surfaces toward those selected/saved/practiced phrases and graph-nearby phrases.

`T-164` completed homepage research, but it treated saved/recent/practice mostly as future shelves. The Home strategy now needs the personalization rule: saved phrases and practice-pool phrases are high-signal user intent, not just another category.

This task should fold those decisions into the planning truth so the next implementation workers do not rediscover or contradict them.

## Success Criteria

- Update `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` so the practice-pool model explicitly includes local user state, saved phrases, practice-selected phrases, recently opened pages, missed items, and graph-nearby personalization.
- Update `docs/design/practice-quiz-concepts/README.md` so the accepted practice concept includes:
  - `Add to practice` from phrase pages and phrase rows;
  - `My practice phrases` as a source/filter;
  - manage/remove selected practice phrases;
  - phrase-sourced prompts where the selected phrase/row/token is always the target;
  - saved/recent/practiced phrase signals as inputs to decks and suggestions.
- Update `docs/design/homepage-research/README.md` so Home V1/VNext distinguishes:
  - no-local-state first launch;
  - saved/recent/practice-pool personalization once local state exists;
  - "Because you practiced..." or equivalent calm recommendation shelves;
  - category/shelf ranking that favors user intent before generic global ordering.
- Add or update a concise source-truth note, if needed, in `docs/DECISIONS.md` or another existing docs file so future workers can find the rule without reading all design packets.
- Produce an implementation-readiness section that separates:
  - bundled read-only phrase graph data;
  - mutable local user state;
  - recommendation/ranking rules;
  - user-facing surfaces that consume those rules.
- Preserve the current positioning that runtime remains offline, private, deterministic, and non-AI.
- Do not implement SwiftUI, SQLite runtime, generated practice decks, or audio generation in this task.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read First

- `AGENTS.md`
- `.agent/README.md`
- `.agent/TASK_PROMPTING.md`
- `.agent/tasks/T-162/result.md`
- `.agent/tasks/T-164/result.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/design/practice-quiz-concepts/README.md`
- `docs/design/homepage-research/README.md`
- `docs/DECISIONS.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/APP_FAMILY_STRUCTURE.md`

## Worker Judgment

- Use GPT-5.5 reasoning to synthesize a product/data contract rather than sprinkling isolated paragraphs into docs.
- Treat saved phrases and practice-selected phrases as the user's strongest explicit intent signals.
- Keep wording user-forward and implementation-ready; avoid internal placeholder terms in user-facing examples.
- Make the contract future-proof for `10,000+` phrase pages without requiring every phrase to be hand-authored into a separate quiz file.
- Prefer a clean model where bundled content is read-only and local user state is mutable/private.
- Do not create vague backlog items. If next tasks are recommended, make them concrete enough for a future orchestrator packet.
- Record concise decisions, evidence, and tradeoffs in `result.md`; do not dump hidden chain-of-thought.

## Scope

- expected worker size: `90` to `180` minutes
- this task should be large enough to justify full review: reconcile two completed design packets, one planning source of truth, and future implementation boundaries.

### Allowed Write Scopes

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/design/practice-quiz-concepts/README.md`
- `docs/design/homepage-research/README.md`
- `docs/DECISIONS.md`
- `docs/APP_FAMILY_STRUCTURE.md` only if a concise local-state/resource-boundary note is needed
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` only for concise mutable-local-state notes; do not rewrite the SQLite architecture
- `.agent/tasks/T-166/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/App/**`
- `native-ios/Resources/**`
- `native-ios/scripts/**`
- `content-draft/viet/**`

### Must Not Touch

- `native-ios/App/**` implementation files.
- `native-ios/project.yml` and SQLite bundling work owned by `T-165`.
- `native-ios/Resources/LanguagePacks/**`.
- Generated JSON resources or generated phrase/audio files.
- Website/Expo code.
- Existing task folders other than `.agent/tasks/T-166/**`.

## Source-Of-Truth Notes

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` is the planning truth for pre-live practice behavior.
- `docs/design/practice-quiz-concepts/README.md` is the design packet from `T-162`; update it to reflect the late product steer, not to restart the concept.
- `docs/design/homepage-research/README.md` is the design packet from `T-164`; update it so Home personalization is not treated as a vague future idea.
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` is the SQLite read-model architecture; use it only to clarify the split between bundled read-only graph and mutable local user state.
- If docs disagree, preserve the newer Jojo decision: saved/practice-selected phrases should strongly influence what the app surfaces next.

## Required Checks

- `python3 .agent/queue_tool.py heartbeat --task-id T-166 --session-id "<session-id>" --phase "post-claim-heartbeat" --lease-minutes 180`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- `git diff --check`
- Markdown/source path sanity check: verify every newly referenced local path exists, or explicitly mark it as a future artifact.
- Review all changed docs once after edits and remove duplicated/conflicting wording.

## Relevant Skills

- `superpowers:receiving-code-review` if reviewer feedback blocks and needs interpretation.
- `superpowers:requesting-code-review` for the required review gates.
- Do not use iOS implementation skills; this task is product/data architecture and handoff documentation.

## Heartbeat And Recovery Contract

- Keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`.
- Heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after spawned subagent waits, and before finish.
- Preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-166 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- If helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`.
- For long synthesis, keep compact task-local notes under `.agent/tasks/T-166/logs/` only if they help recovery.

## Review Gates

Use read-only reviewer subagents if available. Reviewers must not edit repo files. Save review artifacts under `.agent/tasks/T-166/reviews/`.

Run `3` gates, each with exactly `4` reviewer lanes. Repeat a gate if any reviewer blocks.

### Gate 1: Product Contract Fit

- Jojo intent reviewer: checks that saved/practice items are treated as high-signal user intent.
- practice UX reviewer: checks that practice remains phrase-sourced and language-first.
- Home UX reviewer: checks that Home recommendations are useful without feeling like a course dashboard.
- positive-tone reviewer: checks that wording avoids punitive/negative travel framing.

### Gate 2: Data Architecture Fit

- local-state boundary reviewer: checks read-only bundled data versus mutable user state.
- SQLite readiness reviewer: checks compatibility with the `T-160`/`T-163`/`T-165` direction.
- recommendation rules reviewer: checks ranking and graph-nearby rules are deterministic and offline.
- scale reviewer: checks the contract still works for thousands of phrase pages.

### Gate 3: Handoff Readiness

- source-truth consistency reviewer: checks changed docs do not contradict each other.
- future-task clarity reviewer: checks recommended next tasks are concrete and non-overlapping.
- queue/scope reviewer: checks only T-166-owned files are staged.
- implementation-readiness reviewer: checks a future Swift worker could implement from the docs without re-asking core product questions.

Each reviewer response must contain `Approval: APPROVE` or `Approval: BLOCK`. The parent worker writes the review artifacts after collecting responses and closes reviewer agents promptly.

## Definition Of Done

- Saved/practice personalization is documented as a durable product/data rule.
- Practice, Home, and SQLite/local-state docs agree on the same conceptual model.
- No Swift/runtime implementation changes are made.
- `result.md` records what changed, what decisions are now locked in, validation evidence, review artifact paths, and next task recommendations.
- All three review gates pass with unanimous latest-pass approval, or the task is marked blocked with precise recovery notes.
- Task is marked `done` and committed, or marked `blocked` with recovery notes.

## Result Contract

Before stopping, write `.agent/tasks/T-166/result.md` with:

- status: done or blocked;
- summary of the saved/practice personalization contract;
- files changed;
- decisions locked in versus future options;
- validation commands and outcomes;
- review artifact paths;
- remaining risks;
- recommended next tasks;
- `Process feedback` with `NONE`, `BUG`, or `SUGGESTION`.
