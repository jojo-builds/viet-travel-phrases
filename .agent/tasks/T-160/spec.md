# T-160: Design Offline SQLite Phrase Graph And Canonical Phrase-Page Model

## Objective

Design the long-term offline data architecture for SpeakLocal so the native app can scale from the current Vietnam catalog to `900+`, then potentially `10,000+`, phrase pages without duplicating pages, drifting copy, or losing audio/search/practice relationships.

The design should make Jojo's desired mental model explicit:

- a phrase is the atomic learner-facing unit;
- every phrase should be capable of opening one canonical phrase page;
- the rich "Different ways to say [phrase] in Vietnam" article/listing pattern is the base page experience for phrase pages, not a special exception;
- old "family" behavior should become a cluster/relation concept, not a competing page identity;
- the runtime app remains fully offline.

This is a design/research task only. Do not implement SQLite runtime code, SwiftUI screens, generated resources, or audio generation in this task.

## Success Criteria

- Create `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` as the durable architecture plan.
- Explain the current model clearly:
  - `900` catalog families;
  - `919` phrase rows;
  - `163` current rich/authored pages;
  - why those are different today;
  - which differences should disappear in the future model.
- Define a SQLite-first offline phrase graph schema that can support:
  - canonical phrase pages;
  - phrase clusters/collections;
  - page sections and section item ordering;
  - phrase-to-phrase relations;
  - categories/scenarios;
  - audio assets, audio usages, exact-text dedupe, and breakdown-token audio;
  - offline search ranking, including exact Vietnamese, accent-insensitive, pronunciation, English, alias, and related-phrase results;
  - practice/quiz decks and progress hooks without requiring a second data model.
- Define how the existing `family` concept maps into the future model:
  - when it becomes a `phrase_cluster`;
  - how primary phrase rows map to canonical phrase pages;
  - how variants like `Cảm ơn nhiều` can have their own page while remaining related to `Cảm ơn`;
  - how duplicate pages such as duplicate `Chào anh`-style pages are prevented.
- Define the phrase-page content contract:
  - every phrase is page-capable;
  - every phrase page uses the article/listing renderer;
  - page richness is a completeness/status field, not permission to have a page;
  - avoid "short page" language that implies some phrases are lower value;
  - use positive traveler-facing section labels such as `Good to know`, `Local tip`, `Travel note`, `Natural choices`, `What you may hear`, and `Practice this`;
  - do not use negative `Watch out` framing in user-facing app copy.
- Include a staged migration plan that keeps the current native app working while introducing SQLite:
  - source-of-truth strategy;
  - build-time database generation;
  - Swift read path;
  - search path;
  - page renderer path;
  - audio manifest migration;
  - validation gates;
  - rollback strategy.
- Include a size/performance model for current resources and rough `10,000` phrase/page growth.
- Include implementation task recommendations after the design is approved.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read First

- `AGENTS.md`
- `.agent/TASK_PROMPTING.md`
- `.agent/README.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/PRIORITIES.md`
- `content-draft/viet/README.md`
- `content-draft/viet/relation-authoring-notes.md`
- `native-ios/Config/apps/vietnam.json`
- `native-ios/App/Models/GeneratedVietContent.swift`
- `native-ios/App/Models/AuthoredVietListingPages.swift`
- `native-ios/App/Models/PhrasePage.swift`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-audio-manifest.json`

## Worker Judgment

- Use GPT-5.5 reasoning to produce an architecture recommendation, not a transcript of Jojo's wording.
- Keep the core model simple. If a concept exists, explain what problem it solves.
- Challenge current over-engineering when it is historical baggage.
- Preserve what already works if it can be cleanly mapped into the new graph.
- Favor a build-time generated bundled SQLite database for offline runtime use unless research finds a stronger native alternative.
- Use concise diagrams/tables where they make the design easier to reason about.
- Record concise decisions, evidence, and tradeoffs in `result.md`; do not dump hidden chain-of-thought.

## Scope

- expected worker size: `90` to `240` minutes

### Allowed Write Scopes

- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md` only for small alignment notes that point to the new plan
- `docs/V2_CONTENT_MODEL.md` only for small alignment notes that point to the new plan
- `.agent/tasks/T-160/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/App/**`
- `native-ios/Config/**`
- `native-ios/Resources/**`
- `native-ios/scripts/**`
- `content-draft/viet/**`
- public documentation/research sources about iOS bundled databases, SQLite/FTS, and app-size/performance constraints

### Must Not Touch

- Swift runtime implementation files outside read-only inspection.
- Generated native resources.
- Audio files.
- Existing phrase-page JSON content.
- Practice/quiz implementation files.
- Unrelated language prep lanes.
- Automation config unless Jojo explicitly asks after this task is queued.

## Source-Of-Truth Notes

- The current live native Vietnam resource truth is under `native-ios/Resources/*.json`.
- The current authored source lane is under `content-draft/viet/**`.
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` is newly completed planning truth for practice/quiz/mascot; this SQLite plan should reference it as a downstream consumer of phrase graph data, not replace it.
- The installed `speaklocal-listing-pages` skill now prefers positive traveler guidance over `Watch out`/negative framing. Align the database/content plan with that tone.
- "Tier" should be treated as search/quality/completeness priority, not as a reason to deny a phrase a canonical page.
- The app remains offline at runtime. Do not introduce runtime AI or network dependency.

## Required Checks

- `git diff --check`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- If JSON files are edited, validate each with `python3 -m json.tool <path> >/tmp/<safe-name>.json`
- If web research is used, cite links in `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` and `result.md`.

## Relevant Skills

- `superpowers:brainstorming` for architecture exploration.
- `speaklocal-listing-pages` for the desired phrase-page product pattern and tone.
- `build-ios-apps:swiftui-ui-patterns` only if needed to reason about native app data consumption boundaries; do not implement SwiftUI.

## Heartbeat And Recovery Contract

- keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`
- heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after long research passes, before/after spawned subagent waits, and before finish
- preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-160 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- if helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`
- keep compact research/source notes under `.agent/tasks/T-160/logs/` if they become too large for `result.md`

## Review Gate

Review is mandatory. Use 3 gates. Each gate uses exactly 4 read-only Codex subagents and must loop until all 4 explicitly return `Approval: APPROVE`.

Gate 1, model reality and simplification:

- current data model reviewer;
- phrase-as-atomic-unit reviewer;
- canonical graph/duplicate-prevention reviewer;
- positive phrase-page content contract reviewer.

Gate 2, offline SQLite architecture:

- SQLite schema and migration reviewer;
- iOS offline performance/search reviewer;
- audio dedupe and asset mapping reviewer;
- practice/quiz data reuse reviewer.

Gate 3, implementation readiness:

- phased rollout/rollback reviewer;
- source-of-truth consistency reviewer;
- validation/testability reviewer;
- queue follow-up task reviewer.

Review artifacts should be stored under `.agent/tasks/T-160/reviews/gate-XX-pass-YY/`.

## Automation State Contract

This task is a meaningful design/architecture task:

- `automation.taskClass`: `meaningful`
- `automation.proofTask`: `false`
- `automation.reviewersRequired`: `4`
- `automation.reviewGatesRequired`: `3`
- `automation.reviewGateConsensusRequired`: `4`
- all 3 gates require unanimous approval in the latest pass before the task can finish

## Definition Of Done

- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` exists and is clear enough for Jojo to review without needing this chat context.
- The plan clearly answers why `family`, `phrase row`, and current `authored page` diverged, and how the future SQLite graph simplifies that.
- The plan explicitly says every phrase is page-capable and the article/listing page pattern is the base page system.
- The plan avoids negative user-facing framing and replaces `Watch out` language with positive traveler notes.
- The plan includes a practical schema, migration path, search/audio/practice strategy, app-size/performance considerations, and follow-up implementation tasks.
- `result.md` exists and includes:
  - status;
  - summary;
  - files changed;
  - research sources;
  - verification;
  - follow-up tasks;
  - process feedback.
- All 3 review gates pass with unanimous 4-subagent approval.
- `state.json` is finalized through the helper if run by a worker.
- The worker commits its changes if it owns the task.

## Blocker Rule

Do not block just because the current repo model is messy. The task's purpose is to explain the mess and design the cleaner future. If exact runtime constraints need later implementation proof, mark them as assumptions and create follow-up tasks.

## Token Discipline

Do not paste large JSON, full Swift files, or long research excerpts into the plan. Use compact tables, diagrams, paths, and source links.
