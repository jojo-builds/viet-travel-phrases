# T-163: Build SQLite Schema And Viet Fixture Generator

## Objective

Implement the first SQLite migration step from `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`: generate a deterministic bundled Vietnam SQLite fixture beside the current JSON resources without changing app runtime behavior.

The end state should prove that the current Vietnam phrase catalog, authored listing pages, aliases, page sections, scenario/category data, and initial audio metadata can be compiled into one offline database artifact. The native app must still read the current JSON resources after this task.

## Success Criteria

- Add a schema/migration surface for the initial offline phrase graph database.
- Add a deterministic generator that emits:
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
  - a validation/report artifact for unresolved references, count parity, duplicate/canonical identity warnings, and audio mapping gaps.
- The generated fixture should include at minimum:
  - `language_pack`
  - `scenario`
  - `phrase`
  - `phrase_page`
  - `page_alias`
  - `phrase_cluster`
  - `phrase_cluster_member`
  - `page_section`
  - `page_section_item`
  - initial search rows or search-source rows if full FTS is not yet practical
  - initial audio asset/usage rows or a clear report of what remains for the dedicated audio task.
- Count parity checks must cover:
  - `18` scenarios;
  - `900` source families/clusters;
  - `919` phrase rows;
  - `163` authored pages or explicit canonical aliases for authored/page-compatibility coverage.
- Run SQLite `PRAGMA integrity_check` on the generated database.
- Re-running the generator from a clean checkout state should produce deterministic output or a documented deterministic-report comparison. If byte-for-byte SQLite determinism is not practical because of metadata/page layout, the worker must explain the stable validation method.
- Do not switch the app to SQLite in this task.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read First

- `AGENTS.md`
- `.agent/README.md`
- `.agent/TASK_PROMPTING.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `native-ios/AGENTS.md`
- `native-ios/scripts/generate-viet-catalog.js`
- `native-ios/scripts/generate-authored-tier-one-pages.js`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-audio-manifest.json`
- `native-ios/Resources/LanguagePacks/README.md`
- `native-ios/Resources/LanguagePacks/viet/`

## Worker Judgment

- Use GPT-5.5 reasoning to make the first fixture useful without overbuilding the whole final migration.
- Prefer a clear, testable schema and generator over a huge perfect system.
- Keep source-of-truth authoring in repo files. SQLite is the compiled offline runtime artifact, not a hand-authored database.
- Preserve current app behavior. This task is allowed to generate a fixture, scripts, reports, and focused docs, but it must not update Swift runtime loaders to use SQLite.
- If a planned table cannot be populated cleanly yet, create the table only if the generator can validate honest placeholders or explicit audit rows. Avoid silent fake data.
- Record decisions, limitations, and next steps in `result.md`; do not dump hidden chain-of-thought.

## Scope

- expected worker size: `120` to `240` minutes

### Allowed Write Scopes

- `native-ios/scripts/**`
- `native-ios/Resources/LanguagePacks/viet/**`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` only for small implementation-note corrections if reality differs from the plan
- `.agent/tasks/T-163/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/App/**`
- `native-ios/Config/**`
- `native-ios/Resources/**`
- `native-ios/scripts/**`
- `content-draft/viet/**`
- package/tooling metadata needed to add or use a SQLite generation dependency

### Must Not Touch

- Swift runtime implementation files.
- Existing root Viet JSON generated resources except read-only inspection.
- Audio MP3 files.
- Practice/quiz visual design files owned by `T-162`, including `docs/design/practice-quiz-concepts/**`.
- Existing phrase-page source JSON.
- Existing task folders other than `.agent/tasks/T-163/**`.

## Source-Of-Truth Notes

- T-160 established that a phrase is the atomic learner-facing unit and every phrase should be page-capable.
- `family` should become `phrase_cluster`, not a competing page identity.
- The generated SQLite database is a read model. Authoring remains in existing source files.
- `native-ios/Resources/*.json` remains the active app read path after this task.
- Practice/quiz should eventually reuse phrase graph IDs, but T-162 visual design does not block this fixture generator.

## Required Checks

- `git diff --check`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- Validate edited JSON files, if any, with `python3 -m json.tool <path> >/tmp/<safe-name>.json`
- Run the new SQLite generator twice enough to prove deterministic validation.
- Run SQLite `PRAGMA integrity_check` on `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`.
- Record generated counts for scenarios, clusters/families, phrases, pages, aliases, sections, section items, audio assets/usages or audio audit rows.
- If a new dependency is added for SQLite generation, document why and ensure install/use instructions are committed.

## Relevant Skills

- `superpowers:test-driven-development` if adding fixture tests before generator implementation.
- `superpowers:systematic-debugging` for generator/count/audit failures.
- `build-ios-apps:swiftui-ui-patterns` only if needed to preserve Swift model boundaries; do not implement UI.

## Heartbeat And Recovery Contract

- keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`
- heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after long generator runs, before/after spawned subagent waits, and before finish
- preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-163 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- if helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`

## Review Gate

Review is mandatory. Use 3 gates. Each gate uses exactly 4 read-only Codex subagents and must loop until all 4 explicitly return `Approval: APPROVE`.

Gate 1, schema and identity:

- phrase-as-atomic-schema reviewer;
- family-to-cluster mapping reviewer;
- canonical page/alias reviewer;
- source-of-truth preservation reviewer.

Gate 2, generator and validation:

- generator determinism reviewer;
- count parity reviewer;
- SQLite integrity/schema reviewer;
- unresolved-reference/audit reviewer.

Gate 3, migration readiness:

- app-runtime-safety reviewer;
- future Swift read-path reviewer;
- audio/practice hook reviewer;
- queue/source-scope reviewer.

Review artifacts should be stored under `.agent/tasks/T-163/reviews/gate-XX-pass-YY/`.

## Automation State Contract

This task is a meaningful implementation task:

- `automation.taskClass`: `meaningful`
- `automation.proofTask`: `false`
- `automation.reviewersRequired`: `4`
- `automation.reviewGatesRequired`: `3`
- `automation.reviewGateConsensusRequired`: `4`
- all 3 gates require unanimous approval in the latest pass before the task can finish

## Definition Of Done

- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite` exists.
- The SQLite generator and schema/migration files are committed.
- Current app runtime behavior is unchanged and still JSON-backed.
- Validation proves the fixture can be opened and passes `PRAGMA integrity_check`.
- Validation reports include count parity and unresolved reference/audio/canonical identity findings.
- `result.md` exists and includes:
  - status;
  - summary;
  - files changed;
  - schema/generator decisions;
  - generated counts;
  - validation commands and results;
  - review gates;
  - remaining risks;
  - recommended next task;
  - process feedback.
- All 3 review gates pass with unanimous 4-subagent approval.
- `state.json` is finalized through the helper if run by a worker.
- The worker commits its changes if it owns the task.

## Blocker Rule

Do not block just because the first fixture cannot perfectly model all future SQLite tables. Ship the smallest honest fixture that validates the current data and clearly audits what remains. Block only if the worker cannot generate any valid SQLite fixture or if implementing it would require changing app runtime behavior.

## Token Discipline

Do not paste full JSON resources, full SQL dumps, or long validation logs into `result.md`. Store compact reports under `.agent/tasks/T-163/logs/` if needed and summarize the evidence.
