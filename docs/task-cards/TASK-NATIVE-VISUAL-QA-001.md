# TASK-NATIVE-VISUAL-QA-001: Native Visual QA And Fast UI Fix Pass

## Task Done

The current `main` native app has a fresh iPhone 17 Pro simulator QA pass covering the core SpeakLocal flow, with either committed low-risk UI fixes or a clear prioritized bug report for anything that should not be fixed inside this pass.

## Context

Main is now the clean trunk. SQLite/runtime work may run separately, so this task should avoid broad data/runtime changes. Jojo wants native iOS/Liquid Glass feel, static glass chrome, smooth page navigation, no clipping, no stale generated-looking copy on visible surfaces, and simulator-ready proof after changes.

## Worker Judgment

Use GPT-5.5 judgment. Inspect the app, run it, test the flows a real user would touch first, and decide whether each issue should be fixed now or reported for a later data/runtime/content lane. Do not turn this into a rewrite.

## Required Outcome

- Launch the current native app on the iPhone 17 Pro simulator from `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`.
- Test Home, Search, Xin chao listing page, one non-greeting listing page, Explore phrase navigation, back/forward behavior, bottom chrome, and Practice/Quiz entrypoint if present.
- Fix only low-risk native UI issues that are clearly in this lane.
- Leave data/runtime/schema/content-generation changes to the SQLite or Content lanes.
- Capture proof screenshots for the key flows.
- Write a concise result report.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Preferred write scope, if fixes are needed: `native-ios/App/**`, `native-ios/Tests/**`, `docs/task-results/**`.
- Do not edit `content-draft/**`, generated language packs, SQLite schema/generator files, or audio assets.
- Do not generate new images or audio.

## Validation

- Build the native app.
- Launch on iPhone 17 Pro simulator.
- Capture screenshots for the tested flows.
- Run focused tests for any code changed.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-NATIVE-VISUAL-QA-001.md` with:

- status: done or blocked;
- commit hash, if changes were committed;
- screenshots captured;
- flows tested;
- fixes made;
- remaining bugs ranked P0/P1/P2;
- validation commands and outcomes;
- recommended next task.
