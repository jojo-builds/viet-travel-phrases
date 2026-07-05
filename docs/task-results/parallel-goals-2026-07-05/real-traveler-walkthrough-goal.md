# SpeakLocal Vietnam Real Traveler Walkthrough QA Goal

## Objective

Run a deep autonomous front-end QA pass as if you are a real first-time Vietnam traveler. Use the app, not just validators. Find and fix high-confidence user-facing bugs, add regression coverage, and produce proof that common traveler jobs work.

Minimum run time target: 3 hours unless genuinely complete sooner with broad evidence.

## Workspace

- Canonical repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Start from current `main` truth.
- Because `main` is dirty and other workers are active, avoid editing shared `main` directly.
- If fixes are needed, create or use an isolated feature lane/worktree for this goal, starting from the safest available `main` baseline. If lane creation is blocked by dirty state, continue read-only and document exact fixes needed.
- Do not touch `feature/paywall`.
- Do not build to Jojo's physical iPhone unless a later explicit instruction says to do so.

## Required Context

Read first:

1. `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator/AGENTS.md`
2. `/Users/jojolim/Developer/products/speaklocal/app-family/AGENTS.md`
3. `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/AGENTS.md`
4. `docs/design/NATIVE_VISUAL_REFERENCE.md`
5. `docs/operations/LATEST_VALIDATION.md`
6. `docs/task-results/deep-visual-qa-2026-07-05/BUG_LEDGER.md`

## Traveler Jobs To Test

Test the app like this person:

- I just landed at the airport and need transport, SIM, ATM, and basic help.
- I am checking into a hotel and something is wrong with the room.
- I am ordering food and drinks, including spice, ice, allergies, payment, and menu item pages.
- I am exploring Hoi An, Da Nang, Saigon, Hanoi, and Hue city pages.
- I search for something I do not know how to say.
- I save trip items and then practice them.
- I use audio controls, speed controls, favorite/save, more menus, back, forward, bottom tabs, and search.

## Required Checks

1. Click through Home, Browse, Search, Saved, and Practice.
2. On Browse, cover:
   - airport
   - hotel
   - eating out / food
   - drink menu
   - food menu
   - everyday needs
   - city pages
3. On detail/listing pages, check:
   - visible top chrome
   - bottom chrome
   - audio buttons
   - speed controls
   - save/favorite
   - related links
   - back and forward behavior
4. Add or strengthen UI tests for every bug fixed.
5. Keep screenshot proof for visual bugs.

## Validation

Run enough focused validation to prove the changed surface:

- `git diff --check`
- focused unit tests for touched models
- focused UI tests for touched surfaces
- broader UI sweep if changes touch shared navigation/chrome

## Output

Write the report at:

- `docs/task-results/parallel-goals-2026-07-05/real-traveler-walkthrough-report.md`

Report must include:

- pages/flows tested
- bugs found
- fixes made or blocked
- tests run with counts
- screenshots/proof paths
- remaining risks
