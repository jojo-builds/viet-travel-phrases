# TASK-SQLITE-DEFAULT-RUNTIME-001: Make SQLite The Normal Viet App Runtime

## Task Done

The native SpeakLocal Vietnam app uses the bundled SQLite phrase graph as the normal runtime source for Home, Browse, Search, listing/detail pages, related links, saved/recent/practice IDs, and route aliases, or the worker has produced a precise blocker report proving why a full default switch cannot safely happen yet.

## Context

Jojo's expectation is straightforward: the app is becoming a large offline Wikipedia-like phrase graph, so the database should be the real app source, not a side feature flag. `TASK-SQLITE-PROMOTION-001` proved SQLite can support route/search/detail/local-state behavior behind a flag, but it stopped with Home/Browse still using the JSON/GeneratedVietContent path. That is not the final product shape.

Current result to fold in:

- `docs/task-results/TASK-SQLITE-PROMOTION-001.md`
- commit `166ab03 Harden Viet SQLite promotion path`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`

## Worker Judgment

Use GPT-5.5 judgment. This is a substantial runtime integration task, not a small audit. Find the cleanest path to making SQLite the primary Viet data source while preserving the current user-visible app behavior. If a hybrid adapter is temporarily necessary, make it explicit and narrow, not vague.

Prefer durable runtime architecture over demo toggles. The goal is that Jojo can test the app normally and trust that the content, graph links, aliases, and local state are coming through the database path.

## Required Outcome

- Make the bundled Viet SQLite graph load in normal app runtime, not only DEBUG or launch-flag paths, unless a hard blocker is proven.
- Replace or bridge Home/Browse catalog shelves so they are backed by SQLite-equivalent data without regressing current surfaced content.
- Keep Search, detail navigation, related links, canonical aliases, saved IDs, recent history, and practice-pool IDs resolving through the same canonical identity model.
- Preserve the current `Xin chào` flagship route and canonical page behavior.
- Preserve visible audio behavior and ensure audio key resolution still passes.
- Add or update tests that prove the normal runtime path uses SQLite for the core app surfaces.
- Launch the simulator and capture proof screenshots from normal app launch, Home/Browse/Search, and a listing page opened through SQLite-backed navigation.
- Use one read-only peer reviewer focused on whether SQLite is truly the normal runtime source and whether visible behavior regressed.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own native SQLite runtime/adapters/tests/resource wiring/docs/result files.
- Do not redesign listing-page visuals.
- Do not implement the Practice MVP in this task.
- Do not generate audio or images.
- Do not rewrite phrase copy unless a failing runtime contract makes a tiny source fix necessary.

## Validation

- Run the SQLite fixture generator and validator.
- Run focused native tests for SQLite repository/adapters, search/detail routing, Home/Browse data, aliases, saved/recent/practice ID migration, and audio-key resolution.
- Run a native build.
- Launch the iPhone 17 Pro simulator from a normal app path and capture screenshots.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-SQLITE-DEFAULT-RUNTIME-001.md` with:

- status: done or blocked;
- commit hash;
- what runtime path is now default;
- what still uses JSON, if anything, and why;
- Home/Browse/Search/detail proof;
- validation commands and outcomes;
- simulator screenshot paths;
- peer review outcome;
- remaining blockers, if any;
- recommended next task.
