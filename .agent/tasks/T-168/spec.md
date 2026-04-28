# T-168: Wire Viet SQLite Phrase Graph Into Native App And Repair Fixture Tests

## Task Done

The native iOS app has a conflict-safe, simulator-proven SQLite phrase graph read path for every current Vietnamese phrase row in the repo: all current phrase rows resolve into canonical database-backed phrase pages, and Swift can prove Vietnam search, canonical page opening, article section rendering, related-page navigation, and visible audio-key resolution from that graph; the current stale phrase fixture tests are repaired to the new positive article/content standard; and the full native test suite is either green or has only precisely documented external simulator/tooling blockers.

## Outcome

Bring the completed Viet content/data universe into the native app lane and make it testable in Swift without destabilizing the Home work from `T-167`.

This is not a tiny spike. Treat it as the native runtime bridge from the current JSON/content world toward the offline Wikipedia-style SQLite phrase graph Jojo wants. The app may keep JSON as the release default if that is the safer product state, but SQLite must be wired deeply enough that a developer can enable/prove it in DEBUG and validate parity against the bundled database.

## Why This Exists

Completed upstream work now exists:

- `T-167` made Home real and added local saved/recent/practice ID state.
- `T-165` proved an earlier bundled SQLite read-only repository spike.
- The content/data universe worker finished in `/Users/jojolim/Developer/products/speaklocal/app-family-content-data`:
  - `fa9f112 Complete Viet content data universe fixture`
  - `a03834a Record content data universe receipt`
  - receipt: `docs/worker-results/2026-04-29-content-data-universe.md`
- That worker generated a real fixture shape: 18 scenarios, 900 clusters, 919 phrase rows, 911 canonical pages, 928 aliases, 4,515 page sections, 5,019 section items, 720 breakdown tokens, 3,438 relation edges, and 919 search documents.

The app still needs the native Swift side to consume this correctly, and the old `PhrasePageFixtureTests` still assert obsolete content/callout assumptions.

## Success Criteria

- The task branch/worktree contains both the committed Home V1 work and the completed content-data universe fixture.
- All current Vietnamese phrase rows discovered by the generator are mapped into the SQLite fixture and resolve through canonical phrase/page IDs. As of the content-data receipt, the expected floor is 919 source phrase rows and 911 canonical `phrase_page` rows; if the live generator discovers a different count, explain why and prove there are no orphan rows.
- The bundled SQLite fixture is present in the app resource graph and can be opened by Swift tests.
- Swift has a clean repository/read-model path for at least:
  - search documents and canonical result ranking;
  - canonical page lookup by page ID and phrase ID;
  - page section rendering inputs for the article/listing renderer;
  - relation edges for related/Explore navigation;
  - visible audio keys for hero, row, and breakdown-token audio validation.
- Add a safe runtime switch that lets DEBUG/developer builds prove SQLite-backed reads without forcing an irreversible production default. JSON can remain the release fallback until simulator parity is clean.
- Repair stale phrase fixture tests without weakening the quality bar:
  - remove obsolete expectations that every page must use the old expanded pattern;
  - replace obsolete `watch out` / `warningCallout` assumptions with the current positive wording standard such as local tip, good-to-know, caution-free usage guidance, or equivalent product-approved presentation roles;
  - keep strong assertions for canonical uniqueness, no broken links, no duplicate phrase pages, no banned user-facing terms, no unresolved visible audio keys, and search returning the canonical page first.
- Full native test suite should pass. If it cannot pass, the failure must be unrelated to this task and documented with exact failing test names, logs, and a bounded unblock attempt.
- Simulator proof must show a real flow that exercises the new data path: Home/Search -> SQLite-backed result/page -> related page -> back/forward or Home return, while audio buttons still resolve to valid keys.
- Write a compact result receipt that explains what is now live, what remains behind DEBUG, what still uses JSON, and the next sensible task.

## Non-Goals

- Do not generate ElevenLabs audio or add new audio binaries.
- Do not rewrite the Home visual design unless required to connect SQLite-backed navigation cleanly.
- Do not build the full quiz/practice UI in this task.
- Do not create new language packs beyond Viet.
- Do not force SQLite as the release default if simulator/test parity is not proven.
- Do not delete the JSON resources yet; this task should create a bridge, not a cliff.
- Do not touch website/Expo surfaces except where the content-data merge already carries wording cleanup from `fa9f112`.

## Repo / Working Surface

- canonical repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- task cwd: `/Users/jojolim/Developer/products/speaklocal/app-family-native-sqlite`
- branch target: `codex/native-sqlite-runtime`
- content-data source worktree: `/Users/jojolim/Developer/products/speaklocal/app-family-content-data`
- content-data source branch: `codex/content-data-universe`

The orchestrator should create the worktree before handoff. If it does not exist, create it from the current app-family HEAD before claiming this task.

Before product edits, bring the content-data universe commit(s) into the task branch. Prefer a clean merge from `codex/content-data-universe` so the task branch contains the actual generated SQLite fixture/report/resource changes. If the merge conflicts, preserve both:

- T-167 Home/local-state native app behavior;
- content-data universe generated fixture/resource truth from `fa9f112`.

Document any conflict resolution in `result.md`.

## Read First

Read these before designing the implementation:

- `AGENTS.md`
- `.agent/README.md`
- `.agent/CODEX_MANUAL_TASK_PROMPT.txt`
- `.agent/TASK_PROMPTING.md`
- `.agent/tasks/T-167/result.md`
- `.agent/tasks/T-165/result.md`
- `.agent/tasks/T-163/result.md`
- `.agent/tasks/T-160/result.md`
- `docs/worker-results/2026-04-29-content-data-universe.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/DECISIONS.md`
- `native-ios/AGENTS.md`
- `native-ios/App/Models/VietSQLiteLanguagePackRepository.swift`
- `native-ios/App/Models/GeneratedVietContent.swift`
- `native-ios/App/Models/PhrasePage.swift`
- `native-ios/App/Models/AuthoredVietListingPages.swift`
- `native-ios/App/Models/AudioAssetManifest.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Views/SearchPageView.swift`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/Tests/PhrasePageFixtureTests.swift`
- `native-ios/scripts/generate-viet-sqlite-fixture.js`
- `native-ios/scripts/validate-viet-sqlite-fixture.js`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`

## Worker Judgment

- Use GPT-5.5 reasoning to choose the safest bridge. Do not treat this as a mechanical file shuffle.
- Keep the app offline-first, deterministic, and fast.
- Prefer a focused SQLite read model that maps into existing app concepts over rewriting the whole article renderer.
- Preserve Jojo's product direction: every phrase should be able to become a canonical page in a Wikipedia-like graph; Tier 1 is not a ceiling, it is just the current high-quality authored layer.
- Do not use negative travel framing in user-facing copy. Avoid labels such as `watch out`, `warning`, `repair`, or placeholder/internal terms unless they are part of code/test names that are not shown to users.
- If tests are stale, modernize them to enforce the new product truth. Do not delete meaningful coverage to make the suite pass.
- Keep `result.md` concise and evidence-based. Do not dump hidden chain-of-thought.

## Scope

- expected worker size: `90` to `240` minutes.
- this is intentionally large enough to justify full review gates and simulator proof.

### Allowed Write Scopes

- `.agent/tasks/T-168/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only
- `native-ios/App/**`
- `native-ios/Tests/**`
- `native-ios/project.yml`
- `native-ios/scripts/**`
- `native-ios/Resources/LanguagePacks/viet/**`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- `content-draft/viet/**` only as carried by the content-data universe merge or if required to regenerate/validate the SQLite fixture
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/DECISIONS.md`
- `docs/worker-results/**`

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/**`
- `content-draft/viet/**`
- `app/family/**`
- `site/**` only as needed to understand or preserve content-data merge changes

### Must Not Touch

- Existing task folders other than `.agent/tasks/T-168/**`
- `native-ios/Resources/Audio/**`
- `.env`, secrets, API keys, or machine-local credentials
- Legacy Windows worktree metadata except through normal git worktree cleanup commands if explicitly necessary
- Other language packs beyond references needed for shared tests

## Required Checks

Run these unless blocked by a real external tool/simulator failure. If blocked, document the blocker and the bounded investigation.

- Claim and heartbeat according to `.agent/CODEX_MANUAL_TASK_PROMPT.txt`.
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `cd native-ios && xcodegen generate`
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- `cd native-ios && xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`
- `git diff --check`
- Launch the app on iPhone 17 Pro simulator and record proof in `result.md`.

For the simulator proof, exercise a concrete path and name it in `result.md`, for example:

- open Home;
- search for `hello` or `cảm ơn`;
- open a canonical result;
- open one related phrase from that page;
- go back/forward or return Home;
- confirm visible audio controls do not point at missing keys.

## Relevant Skills

- `build-ios-apps:ios-debugger-agent` for build/run/simulator proof.
- `build-ios-apps:swiftui-ui-patterns` for clean native integration if views need small adapters.
- `build-ios-apps:swiftui-performance-audit` if SQLite reads touch scrolling/search responsiveness.
- `superpowers:requesting-code-review` for the review gates.
- `superpowers:verification-before-completion` before claiming completion.
- `superpowers:receiving-code-review` if reviewer feedback blocks.

## Heartbeat And Recovery Contract

- Keep `session.owner` as `codex-desktop-automation`; put `manual-t-168-native-sqlite` or `automation-t-168-native-sqlite` in `session.label`.
- Heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after spawned reviewer waits, before long build/test/simulator runs, and before finish.
- Preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-168 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- If helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`.
- Keep recovery notes under `.agent/tasks/T-168/logs/` only when useful.

## Review Gates

Use read-only reviewer subagents if available. Reviewers must not edit repo files. Save review artifacts under `.agent/tasks/T-168/reviews/`.

Run `3` gates, each with exactly `4` reviewer lanes. Repeat a gate if any reviewer blocks. Each reviewer response must contain `Approval: APPROVE` or `Approval: BLOCK`.

### Gate 1: Data Merge And Source Truth

- merge/source-truth reviewer: verifies T-167 and content-data universe truth both survived.
- canonical graph reviewer: verifies phrase/page/link canonicalization is coherent and no duplicate canonical pages were reintroduced.
- stale-test reviewer: verifies old fixture failures are repaired by modernized assertions, not weakened/deleted coverage.
- scope reviewer: verifies staged files stay inside T-168 write scope.

### Gate 2: Native Runtime And App Behavior

- SQLite repository reviewer: verifies Swift read-model code is clear, deterministic, and safely maps database rows into app concepts.
- search/navigation reviewer: verifies search/page/related navigation behavior can use SQLite-backed data without route stack regressions.
- audio reviewer: verifies visible audio keys resolve and audio assets are not regenerated or duplicated.
- performance/offline reviewer: verifies queries are bounded enough for offline app use and do not add network/runtime AI.

### Gate 3: Validation And Handoff Readiness

- build/test reviewer: verifies required commands ran and failures are real blockers if any remain.
- simulator reviewer: verifies simulator proof exercises the SQLite path, not just JSON Home.
- product wording reviewer: verifies no negative or placeholder user-facing terms were introduced.
- next-task reviewer: verifies `result.md` gives Jojo a useful next-step digest, not a vague recap.

The parent worker writes the review artifacts after collecting responses and closes reviewer agents promptly.

## Definition Of Done

- T-168 task is claimed, heartbeated, reviewed, and marked done or blocked.
- The worker branch/worktree contains Home V1 plus the content-data universe fixture.
- Every current Vietnamese phrase row is represented in the SQLite fixture and resolves to one canonical openable page, with no orphan phrases, duplicate canonical pages, or broken relation/search targets.
- SQLite phrase graph data is readable by Swift and test-proven for search, canonical page open, sections, relations, and audio references.
- Stale phrase fixture tests are repaired to the current positive article standard.
- Full native test suite passes, or any failure is precisely bounded and unrelated to this task.
- Simulator proof shows a real SQLite-backed user flow.
- `result.md` is written with the exact commit hash, files changed, validation outcomes, live-vs-debug state, known risks, and recommended next task.
- Latest pass of all three review gates has unanimous approval, unless the task is honestly marked blocked.
- The final work is committed with a clear message.

## Result Contract

Before stopping, write `.agent/tasks/T-168/result.md` with:

- status: done or blocked;
- commit hash;
- what changed in the database resource path;
- what changed in Swift runtime/read models;
- what changed in tests and why the old fixture assertions were stale;
- live versus DEBUG/fallback behavior;
- validation commands and outcomes;
- simulator proof path or visual proof statement;
- review artifact paths;
- remaining risks;
- recommended next task;
- `Process feedback` bullets starting with exactly `NONE`, `BUG`, or `SUGGESTION`.
