# T-159: Research And Design Pre-Live Practice/Quiz + Mascot Lane

## Objective

Create a research-backed, implementation-ready product spec for SpeakLocal's pre-live Practice/Quiz area and mascot lane. The outcome should let Jojo and future Codex workers understand what to build, why it matters, how it should feel inside the native app, and what tasks should follow.

This task is planning/design only. Do not implement SwiftUI screens, generate mascot art, or modify app runtime resources in this task.

## Success Criteria

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` is checked and improved as the durable product lane.
- Research notes summarize real language-learning quiz pain points from Reddit/user-discussion sources plus learning-science or product-design sources.
- The spec defines SpeakLocal-specific practice principles, not a Duolingo clone.
- The spec audits the current repo assets available for practice:
  - catalog scenarios/categories;
  - authored pages;
  - phrase rows;
  - breakdown tokens;
  - audio audit status;
  - mascot asset presence or absence.
- The spec defines MVP practice modes, entrypoints, data model direction, mascot usage, and go-live tasks.
- The result creates or updates follow-up task recommendations for implementation work without starting implementation.
- Required review gates pass if this task is promoted to a meaningful automated worker run.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read First

- `AGENTS.md`
- `.agent/TASK_PROMPTING.md`
- `docs/PRIORITIES.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `native-ios/AGENTS.md`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- `content-draft/viet/viet-phrase-catalog.json`

## Worker Judgment

- Use GPT-5.5 reasoning to turn the desired outcome into a practical native-app direction.
- Think like a product designer and launch owner, not only a document editor.
- Keep the practice system travel-useful, offline, audio-forward, and native-feeling.
- Record concise decisions, evidence, and tradeoffs in `result.md`; do not dump hidden chain-of-thought.

## Scope

- expected worker size: `60` to `180` minutes

### Allowed Write Scopes

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-159/**`
- optionally create follow-up draft task folders `.agent/tasks/T-160/**` through `.agent/tasks/T-163/**` if the worker judges the queue should be pre-seeded
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/App/**`
- `native-ios/Resources/**`
- `content-draft/viet/**`
- public web research sources

### Must Not Touch

- Native Swift source implementation files.
- Generated app bundles/resources outside the allowed planning scope.
- Audio files.
- Mascot/image generation files.
- Existing unrelated tasks other than queue-index repair.

## Source-Of-Truth Notes

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` is the planning source for practice/quiz and mascot until an implementation spec supersedes it.
- `docs/PRIORITIES.md` remains the near-term roadmap authority.
- Runtime phrase/content truth remains in the Viet catalog, authored listing pages, audio manifest/audit, and generated native resources.
- Practice must remain offline at runtime. Do not introduce runtime AI or network dependencies.
- Mascot is desired before go-live, but no real native mascot asset exists yet.

## Required Checks

- `git diff --check`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- Any JSON file edited must pass `python3 -m json.tool <path> >/tmp/<safe-name>.json`
- If web research is used, include links in the planning doc and result.

## Relevant Skills

- `superpowers:brainstorming` for product/design exploration.
- `speaklocal-listing-pages` for how practice should connect to listing-page learning patterns.
- `build-ios-apps:swiftui-ui-patterns` only for native UX pattern review; do not implement UI in this task.

## Heartbeat And Recovery Contract

- keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`
- heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after long research passes, before/after spawned subagent waits, and before finish
- preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-159 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- if helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`
- keep compact research notes or source lists under `.agent/tasks/T-159/logs/` if they become too large for `result.md`

## Review Gate

Review is mandatory if this task is promoted from draft to queued as a meaningful worker run.

Use 3 gates. Each gate uses exactly 4 read-only Codex subagents and must loop until all 4 explicitly return `Approval: APPROVE`.

Gate 1, research and asset reality:

- traveler utility / pain-point reviewer
- learning science / retrieval practice reviewer
- current asset inventory reviewer
- launch-scope reviewer

Gate 2, product design:

- native iOS practice UX reviewer
- listing-page integration reviewer
- mascot usage reviewer
- offline data/progress reviewer

Gate 3, handoff readiness:

- implementation task breakdown reviewer
- source-of-truth consistency reviewer
- queue/automation suitability reviewer
- risk and blocker reviewer

Review artifacts should be stored under `.agent/tasks/T-159/reviews/gate-XX-pass-YY/`.

## Automation State Contract

This task is a meaningful planning/design task:

- `automation.taskClass`: `meaningful`
- `automation.proofTask`: `false`
- `automation.reviewersRequired`: `4`
- `automation.reviewGatesRequired`: `3`
- `automation.reviewGateConsensusRequired`: `4`
- all 3 gates require unanimous approval in the latest pass before the task can finish

## Definition Of Done

- The practice/quiz + mascot plan is clear enough for Jojo to review without needing this chat context.
- The plan says what should be built first, what should wait, and why.
- The plan includes a go-live to-do list that includes practice, mascot, audio validation, simulator proof, and device proof.
- Any seeded follow-up tasks are draft unless explicitly safe to queue after `T-157`.
- `result.md` exists and includes:
  - status;
  - summary;
  - files changed;
  - research sources;
  - verification;
  - follow-up tasks;
  - process feedback.
- `state.json` is finalized through the helper if run by a worker.
- The worker commits its changes if it owns the task.

## Blocker Rule

Do not stop just because research sources are imperfect. Use available evidence, clearly label Reddit anecdotes as anecdotal, and separate research signals from product decisions.

## Token Discipline

Do not paste long Reddit threads or full research articles into `result.md`. Use short summaries, links, and task-relevant conclusions.

