# T-165: Bundle Viet SQLite Fixture And Add Swift Read-Only Repository Spike

## Outcome

Make the SQLite fixture produced by `T-163` visible to the native iOS app bundle and prove Swift can open it read-only behind a debug-gated repository path, without changing current user-facing runtime behavior.

This is the immediate bridge after `T-163`. It is intentionally narrower than `T-158`: do not migrate all live JSON/audio resources into `LanguagePacks` yet, and do not switch the app runtime from JSON to SQLite.

## Why This Exists

`T-163` generated:

- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`

But `native-ios/project.yml` currently excludes `LanguagePacks`, so Swift cannot reliably open the SQLite fixture through `Bundle.main`. The next safe step is to bundle the language-pack fixture, add a read-only Swift path that can inspect it, and keep JSON as the production source while we compare/parity-check.

## Success Criteria

- `Resources/LanguagePacks/**` is included in the native app bundle through XcodeGen/resource rules.
- The app still excludes or handles broad resource folders intentionally; do not accidentally duplicate thousands of MP3s or break existing `Resources/Audio` bundling.
- Add a debug-gated Swift SQLite read-only repository/service that can:
  - locate `LanguagePacks/viet/speaklocal-viet.sqlite` from `Bundle.main`;
  - open it read-only;
  - run small deterministic sanity queries;
  - map a tiny representative slice back toward existing app concepts without replacing current JSON loaders.
- Add focused tests or a debug validation command proving:
  - the bundled SQLite file is findable;
  - `PRAGMA integrity_check` / equivalent read sanity passes where feasible;
  - a few expected counts or rows match the generated report.
- Current visible app behavior remains unchanged.
- Update docs/results to clearly say SQLite is bundled and readable, but not active runtime.

## Read First

- `AGENTS.md`
- `.agent/README.md`
- `.agent/TASK_PROMPTING.md`
- `.agent/orchestrator/digests/T-160.md`
- `.agent/orchestrator/digests/T-163.md`
- `.agent/tasks/T-163/result.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `native-ios/AGENTS.md`
- `native-ios/project.yml`
- `native-ios/App/Models/GeneratedVietContent.swift`
- `native-ios/App/Models/AuthoredVietListingPages.swift`
- `native-ios/App/Models/AudioAssetManifest.swift`
- `native-ios/App/Models/PhrasePage.swift`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `native-ios/scripts/sqlite/001_initial.sql`
- `native-ios/scripts/generate-viet-sqlite-fixture.js`

## Worker Judgment

- Treat this as a proof spike with production hygiene, not a full runtime migration.
- Keep JSON loaders as default runtime truth.
- Prefer a small, inspectable Swift repository/read service over wiring SQLite into every view.
- If iOS Swift does not have a built-in SQLite API available in this project, choose the smallest safe path:
  - use SQLite through existing system availability if practical;
  - or add a minimal readback script/test outside Swift and document the Swift dependency decision as a blocker/follow-up;
  - do not add a large third-party dependency without a clear justification and review approval.
- Avoid creating a second source of truth. SQLite is still a generated offline read model.
- Record concise decisions/evidence in `result.md`; do not dump hidden reasoning.

## Scope

Expected worker size: `90` to `180` minutes.

### Allowed Write Scopes

- `native-ios/project.yml`
- `native-ios/App/**` only for the debug-gated SQLite read-only path and tightly related tests/hooks
- `native-ios/Tests/**`
- `native-ios/scripts/**` only for focused validation helpers if needed
- `native-ios/Resources/LanguagePacks/viet/**` only if the fixture/report must be regenerated or packaging metadata must be adjusted
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/APP_FAMILY_STRUCTURE.md` only for concise state updates
- `.agent/tasks/T-165/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/App/**`
- `native-ios/Resources/**`
- `native-ios/scripts/**`
- `native-ios/project.yml`
- `content-draft/viet/**`

### Must Not Touch

- Practice quiz design files owned by active `T-162`, especially `docs/design/practice-quiz-concepts/**`.
- Homepage research files owned by active `T-164`, especially `docs/design/homepage-research/**`.
- Broad JSON/audio language-pack migration from `T-158`.
- Listing page copy/content JSON.
- UI styling/layout/navigation unless a tiny debug-only hook is absolutely required.
- Website/Expo code.

## Required Validation

- `python3 .agent/queue_tool.py heartbeat --task-id T-165 --session-id "<session-id>" --phase "post-claim-heartbeat" --lease-minutes 180`
- `cd native-ios && xcodegen generate`
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- Run focused tests added or affected by this task.
- Run `sqlite3 native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite "PRAGMA integrity_check;"` unless unavailable; if unavailable, document the equivalent validation used.
- Validate `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json` with `python3 -m json.tool`.
- `git diff --check`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`

## Review Gates

Use read-only reviewer subagents if available. Reviewers return `Approval: APPROVE` or `Approval: BLOCK` with blocking findings. Save review artifacts under `.agent/tasks/T-165/reviews/`.

Run `3` gates, each with `4` reviewer lanes:

### Gate 1: Resource Packaging

- XcodeGen/resource inclusion reviewer
- bundle-path/readability reviewer
- duplicate/oversized resource risk reviewer
- app-family language-pack direction reviewer

### Gate 2: Swift Read-Only Spike

- Swift API/design reviewer
- SQLite safety/read-only reviewer
- JSON-runtime-preservation reviewer
- tests/query-parity reviewer

### Gate 3: Handoff Readiness

- validation/build reviewer
- docs/source-truth reviewer
- queue/lock/scope reviewer
- next-migration-step reviewer

Repeat a gate if a reviewer blocks. Do not mark done unless all required gates approve or the task is honestly blocked with a precise reason.

## Definition Of Done

- SQLite fixture is bundle-addressable or a precise packaging blocker is documented.
- Swift read-only path exists behind a debug gate or a precise Swift SQLite dependency blocker is documented.
- Current app behavior stays JSON-backed and visually unchanged.
- Validation/build/test evidence is recorded in `.agent/tasks/T-165/result.md`.
- Review gates are recorded and approved, or blockers are explicit.
- Task is marked `done` and committed, or marked `blocked` with recovery notes.

## Result Contract

Before stopping, write `.agent/tasks/T-165/result.md` with:

- status: done or blocked;
- summary of packaging/read-path changes;
- exact files changed;
- validation commands and outcomes;
- whether the SQLite fixture is now bundle-addressable;
- whether Swift can open it read-only;
- whether JSON remains the production runtime;
- review artifact paths;
- remaining risks;
- recommended next tasks;
- `Process feedback` with `NONE`, `BUG`, or `SUGGESTION`.
