# T-167: Implement Native Home V1 And Local User Intent State

## Outcome

Replace the current native iOS "Home" behavior, which still drops users straight onto the `Xin chào` listing page, with a real SpeakLocal Home V1 that feels native, useful, and alive from the first launch.

Home should become the app's starting surface: a calm Vietnam-focused entry point that exposes search, immediate travel actions, category/relationship exploration, authored Tier 1 phrase entry points, and returning-user personalization from saved/recent/practice intent signals.

At the same time, add the first practical local user-intent state foundation for canonical phrase/page IDs. This is not the full practice system yet; it is the local, private state layer that future Practice, Home, Search, and Explore workers can build on.

## Why This Exists

Recent completed tasks established the planning truth:

- `T-164` researched what Home should do.
- `T-166` locked in that saved phrases, practice-selected phrases, recently opened pages, practiced prompts, and missed items are high-signal local user intent.
- `T-165` proved the bundled SQLite read path in DEBUG, but JSON remains the production runtime for now.

The app still needs the actual native Home implementation. This task should make Home real without forcing a full SQLite runtime switch or a full quiz/practice build.

## Success Criteria

- The app launches to a new native Home screen, not directly to `PhraseListingView(page: .xinChao)`.
- Home has two honest states:
  - first launch / no local state: useful default shelves and starter actions with no fake "recent" or "practice" data;
  - returning user / local state exists: Continue, Saved, and Practice-related sections appear only when backed by real local state.
- Add a local user-intent store for canonical IDs, at minimum:
  - recently opened phrase pages;
  - saved phrase pages or phrase rows where the current UI can support it cleanly;
  - practice-pool page/phrase IDs, if the UI includes an `Add to practice` affordance.
- Keep the store private, offline, deterministic, and local to device. Do not add network or runtime AI.
- Home should expose useful discovery paths:
  - prominent search entry;
  - "use now" or equivalent traveler-first cards;
  - situation/category shelves;
  - relationship/social shelf where relevant;
  - featured authored Tier 1 pages;
  - browse-all entry into the existing catalog/search/listing universe.
- Navigation from Home to phrase pages must preserve the existing article/listing renderer, bottom chrome, back/forward stack behavior, search behavior, and audio controls.
- Use the existing native Liquid Glass visual language; do not create a marketing landing page.
- Add focused tests for local state and any routing/search helpers introduced by the task.
- Run the app on the iPhone 17 Pro simulator and record proof in `result.md`.

## Non-Goals

- Do not switch production listing/search/runtime reads from generated JSON to SQLite in this task.
- Do not generate or modify audio files.
- Do not regenerate phrase content or authored listing pages.
- Do not build the full Practice quiz UI or quiz-deck generator.
- Do not implement a user account, sync, cloud storage, analytics, or network-dependent personalization.
- Do not touch website, Expo, or non-native app surfaces.
- Do not rename broad app folders or move the monorepo structure.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`
- current branch should be used as-is; do not switch, merge, or rebase branches inside this task.

## Read First

Read these before designing the implementation:

- `AGENTS.md`
- `.agent/README.md`
- `.agent/TASK_PROMPTING.md`
- `.agent/tasks/T-164/result.md`
- `.agent/tasks/T-166/result.md`
- `.agent/tasks/T-165/result.md`
- `docs/design/homepage-research/README.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/DECISIONS.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `native-ios/AGENTS.md`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/App/Views/PhraseDetailView.swift`
- `native-ios/App/Views/SearchPageView.swift`
- `native-ios/App/Models/AppChrome.swift`
- `native-ios/App/Models/GeneratedVietContent.swift`
- `native-ios/App/Models/PhrasePage.swift`
- `native-ios/App/Models/AuthoredVietListingPages.swift`
- `native-ios/App/Models/AudioAssetManifest.swift`
- `native-ios/App/Models/VietSQLiteLanguagePackRepository.swift`

## Worker Judgment

- Treat this as a product implementation task, not a wireframe dump.
- Use GPT-5.5 reasoning to choose a maintainable SwiftUI structure after reading the current app shape.
- Keep Home dense enough to be useful, but not busy. It should feel like an iOS app surface people return to, not a brochure.
- Use user-facing copy that is positive, calm, and travel-helpful. Avoid "watch out" framing and avoid fear-based travel wording.
- Do not invent fake saved/practice/recent data in returning-user shelves. Empty-state defaults are better than dishonest personalization.
- Make the local state model small and evolvable. It should support future SQLite-backed recommendations without needing a rewrite.
- If a clean `Add to practice` affordance fits naturally on phrase/listing pages, implement the local add/remove state only. Do not build a full quiz experience here.
- Keep explanations and recovery notes in `result.md`; do not store hidden chain-of-thought.

## Scope

- expected worker size: `90` to `180` minutes
- this task is intentionally large enough to justify full review gates and simulator proof.

### Allowed Write Scopes

- `native-ios/App/**`
- `native-ios/Tests/**`
- `native-ios/project.yml` only if needed for test/resource wiring
- `docs/design/homepage-research/README.md` only for concise implementation-reality notes
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` only for concise local-state/practice-pool implementation notes
- `docs/DECISIONS.md` only for concise durable decisions from this implementation
- `.agent/tasks/T-167/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/**`
- `content-draft/viet/**`

### Must Not Touch

- Existing task folders other than `.agent/tasks/T-167/**`.
- `native-ios/Resources/LanguagePacks/**` except read-only inspection.
- Generated authored content resources unless a build-system reference requires a harmless project-file update.
- Audio files or audio manifests.
- Website/Expo code.
- Legacy Windows migration artifacts.

## Implementation Guidance

Prefer a small set of reusable primitives rather than one giant view:

- `HomeView` or equivalent root view;
- a local user-intent store/model with clear canonical ID operations;
- home shelf/card/row components that reuse existing glass/button/icon language;
- navigation helpers that resolve canonical phrase IDs once and push the same route type the rest of the app already uses.

Good Home V1 content can include:

- a compact Vietnam identity/header;
- search as the strongest entry;
- "Need this now" cards for starter situations such as greetings, hotel, airport, money, directions, bathroom, help, and food;
- relationship/social forms as a distinct discovery area;
- top authored pages such as `Xin chào`, `Cảm ơn`, `Xin lỗi`, `Cái đó nghĩa là gì?`, `Mấy giờ trả phòng?`, and similar canonical pages available in the current catalog;
- local-state sections once there is real local data.

Do not force every shelf to exist if the backing data is weak. Use the current catalog/search helpers to build robust shelves with canonical IDs that resolve.

## Required Checks

Run these, adapting only if the repo's documented command differs:

- Claim and heartbeat according to `.agent/CODEX_MANUAL_TASK_PROMPT.txt`.
- `python3 .agent/queue_tool.py heartbeat --task-id T-167 --session-id "<session-id>" --phase "post-claim-heartbeat" --lease-minutes 180`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- `git diff --check`
- `cd native-ios && xcodegen generate`
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- Run any existing or newly relevant tests for local state/routing. If no test target is practical, explain exactly why and add the narrowest practical compile-time or unit coverage available.
- Launch the app on the iPhone 17 Pro simulator and record proof in `result.md`, including either a screenshot path or a precise statement of what was visually checked.

## Relevant Skills

- `build-ios-apps:swiftui-liquid-glass` for Liquid Glass SwiftUI UI decisions.
- `build-ios-apps:swiftui-ui-patterns` for native SwiftUI structure.
- `build-ios-apps:ios-debugger-agent` for simulator launch/proof.
- `superpowers:requesting-code-review` for review gates.
- `superpowers:verification-before-completion` before any completion claim.
- `superpowers:receiving-code-review` if review feedback blocks and needs technical interpretation.

## Heartbeat And Recovery Contract

- Keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`.
- Heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after spawned reviewer waits, before long simulator/build runs, and before finish.
- Preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-167 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- If helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`.
- Keep recovery notes under `.agent/tasks/T-167/logs/` only when they help resume interrupted work.

## Review Gates

Use read-only reviewer subagents if available. Reviewers must not edit repo files. Save review artifacts under `.agent/tasks/T-167/reviews/`.

Run `3` gates, each with exactly `4` reviewer lanes. Repeat a gate if any reviewer blocks.

### Gate 1: Home Product And Native UX Fit

- Home usefulness reviewer: checks that first-launch Home helps travelers explore without needing prior state.
- returning-user honesty reviewer: checks saved/recent/practice sections appear only with real local state.
- Liquid Glass/native reviewer: checks the Home surface matches the existing native iOS visual language.
- navigation/chrome reviewer: checks bottom chrome, search, back/forward, and page routing remain coherent.

### Gate 2: Local State And Data Boundary Fit

- canonical ID reviewer: checks saved/recent/practice records use canonical IDs and resolve to one page.
- privacy/offline reviewer: checks user state is local-only and deterministic.
- SQLite-readiness reviewer: checks the state model can later join against SQLite/phrase graph without rewrite.
- tests reviewer: checks coverage proves meaningful local-state/routing behavior.

### Gate 3: Validation And Handoff Readiness

- build/simulator reviewer: checks build and simulator proof are real and documented.
- source-truth reviewer: checks any docs updates are concise and do not contradict T-164/T-166/T-165.
- queue/scope reviewer: checks staged files stay within T-167 write scope.
- next-task reviewer: checks `result.md` clearly says what should be queued next, if anything.

Each reviewer response must contain `Approval: APPROVE` or `Approval: BLOCK`. The parent worker writes the review artifacts after collecting responses and closes reviewer agents promptly.

## Definition Of Done

- Native app launches to a real Home V1.
- Local user-intent state foundation exists and is wired where appropriate.
- Home uses real catalog/authored phrase data and does not fake personalization.
- Existing phrase listing/search/navigation/audio flows still build and work.
- Required checks pass or failures are documented with precise blockers.
- All three review gates pass with unanimous latest-pass approval, or the task is marked blocked with recovery notes.
- `result.md` is written with evidence and next steps.
- Task is marked `done` and committed, or marked `blocked` with recovery notes.

## Result Contract

Before stopping, write `.agent/tasks/T-167/result.md` with:

- status: done or blocked;
- summary of Home V1 behavior implemented;
- summary of local user-intent state implemented;
- files changed;
- decisions locked in versus future options;
- validation commands and outcomes;
- simulator proof path or visual proof statement;
- review artifact paths;
- remaining risks;
- recommended next tasks;
- `Process feedback` with `NONE`, `BUG`, or `SUGGESTION`.
