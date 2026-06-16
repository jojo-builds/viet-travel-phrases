# Viet Launch Readiness Bug Hunt

Date: 2026-06-16
Owner: goal worker launched from the SpeakLocal orchestrator
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/launch-readiness-bug-hunt-20260616`
Branch: `feature/launch-readiness-bug-hunt-20260616`
Baseline main commit: `90a9f6437`

## Objective

Run a deep launch-readiness walkthrough for the current native SpeakLocal Vietnam app as if you are a real traveler preparing for and using the app. Find performance, usability, layout, navigation, audio, and content-rendering problems that would make a real user lose trust. Fix safe issues immediately in this feature lane, validate the fixes, and leave a clean release-risk report.

Keep working until the bug hunt is genuinely complete, safely fixed, or blocked by a real external condition such as a locked physical iPhone, signing secrets, Apple-side StoreKit state, language/legal/product decisions, or repeated validation failure after a concrete fix attempt.

## Starting Instructions

1. Read the active instructions before work:
   - `AGENTS.md`
   - `orchestrator/AGENTS.md`
   - `native-ios/AGENTS.md`
   - `docs/operations/README.md`
   - `docs/operations/APP_STATUS.md`
   - `docs/operations/CURRENT_BLOCKERS.md`
   - `docs/operations/TESTING_RUNBOOK.md`
   - `docs/operations/LATEST_VALIDATION.md`
   - `docs/design/NATIVE_VISUAL_REFERENCE.md`
2. Run the feature-lane start gate before edits:
   - `/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh start /Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/launch-readiness-bug-hunt-20260616`
3. Use the native iOS app only. Do not use Expo, React Native, Metro, EAS, or an `app/` shell.
4. Keep paywall excluded unless Jojo explicitly reopens it. Treat Messages as legacy/parked unless a bug blocks a current visible route.
5. Use a dedicated simulator for launched UI/manual QA, preferably `SpeakLocal Launch Bug Hunt` with an iPhone 17 Pro runtime.
6. Do not install this feature branch on Jojo's physical iPhone unless Jojo explicitly asks. If physical-device proof is needed, report that orchestrator should build final `main` after merge.

## Walkthrough Scope

Exercise the app like a traveler, not like a smoke test.

- Home:
  - first launch, visible hierarchy, bottom chrome, hero/backdrop readability, shelf routes, quick actions
  - long labels, clipped subtitles, tap targets, scrolling, repeated launch state
- Browse:
  - category routes, city/place routes, entity-first rows, phrase rows, deep links, return paths
  - noun-first surfaces for food, markets, places, everyday objects
- Search:
  - search island/open transition, keyboard behavior, empty states, result taps, back/forward history
  - common traveler searches such as food, hotel, taxi, airport, market, allergy, restroom, card, cash, Danang, Hanoi, HCMC
- Listing/detail pages:
  - tier-one article pages, catalog-promoted phrase pages, city/place pages, derived place-phrase pages, menu item pages
  - hero title wrapping, pronunciation, audio dock, section spacing, related phrase rows, tip/at-glance/breakdown order
- City/place pages:
  - validate current `speaklocal.place.app-detail.v2.2` behavior, not legacy city models
  - inspect dense city rows for clipping, stale copy, duplicate-looking routes, missing visible affordances
- Practice:
  - Home quick access, Browse collection entry, Saved entry, topic picker, retries, completed rounds, dismiss/return behavior
  - ensure completion and reiteration copy makes sense as a user
- Saved:
  - save/unsave from likely surfaces, start-practicing path, persistence across relaunch if feasible
- Settings:
  - visible settings, audio/variant/about surfaces, layout, safe-area behavior
- Audio:
  - speaker icons play bundled audio when present or clearly expose known missing-audio behavior
  - playback does not overlap incoherently, hang, or leave stale state
- Navigation and chrome:
  - back and forward feel browser-like
  - bottom chrome stays visually static while page content animates beneath it
  - no opaque top-white shield regression
  - no content hidden under bottom tab/search chrome

## Performance And Efficiency Scope

Look for anything that would make users think the app is laggy, hot, or unstable.

- slow launches or route transitions
- search input lag or expensive result recomputation
- janky scrolling on long listing/city/search pages
- repeated audio playback causing stuck state, overlap, high CPU, or UI stalls
- memory growth during repeated route/search/practice loops
- heavy SwiftUI layout patterns on dense pages
- repeated generated-resource loading or decoding on hot paths

Use appropriate native proof:

- XcodeBuildMCP simulator build/run/test tools when available
- `xcodebuild` only when the MCP path is not available or a command-line proof is clearer
- targeted Instruments/ETTrace or lightweight sampling when a specific lag/freeze symptom appears
- screenshots and UI snapshots for visual/layout bugs

If a performance issue is suspected, reproduce it before fixing and rerun the same path after the fix.

## Subagent Policy

Use parallel subagents when there is independent surface area. Good splits:

- UI/manual walkthrough and screenshot inspection
- performance/hot-path audit
- content/render/audio anomaly audit
- validation/test sweep

If launching separate Codex worker threads as subagents, use the `launch-goal-worker` skill: put each subgoal in a short durable Markdown file and launch each with a short `/goal` prompt. If using in-thread subagents, keep prompts tightly scoped and ask for evidence, not vibes.

Subagents may inspect and report freely. Only one agent should make source edits in this feature lane at a time; coordinate before applying patches.

## Safe Fix Policy

Fix safe issues immediately when ownership is clear:

- layout clipping, safe-area overlap, truncated text, incorrect row spacing
- obvious navigation bugs
- obviously stale/generated-resource wiring when the generator path is clear
- clear performance problems with localized fixes
- missing tests/guards for bugs you fix

Do not make product/legal/language decisions without evidence. For language naturalness concerns, classify them and make a follow-up unless the repo already has a clear source-authority fix.

Generated resources must be regenerated from source. Do not hand-edit generated JSON except for narrow emergency inspection.

Do not stage unrelated user files. Do not leave the lane mid-merge, mid-rebase, or half-built.

## Validation Minimum

Run validation that matches touched surfaces. For a broad bug hunt, aim for:

- `git diff --check`
- `node scripts/guard-native-only.js`
- `node native-ios/scripts/guard-native-chrome.js`
- relevant resource validators if generated/content files changed
- relevant focused Xcode tests for touched native surfaces
- simulator build/run proof
- screenshot or UI-snapshot proof for fixed visible issues

If no source changes are needed, still run enough native proof to support the release-risk report.

## Reporting And Artifacts

Create or update a durable report before finishing:

- preferred report path: `docs/operations/launch-readiness-bug-hunt-2026-06-16.md`
- include tested commit/branch, simulator/device, exact flows covered, findings, fixes, screenshots/log paths, validation commands/results, remaining risks, and ship recommendation

Update operational truth only when it actually changes:

- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `ops/apps/viet.json`

Commit intentional changes with a clear message before declaring the goal complete.

Send compact dashboard messages back to orchestrator:

- `**Status Update**`: progress, current surface, bugs found/fixed, validation running
- `**Decision Needed**`: only for real blockers that cannot be resolved from repo evidence
- `**Jojo Test Request**`: only when Jojo should manually try something
- `**Final Report**`: commit hash, files changed, validations, screenshots/logs, remaining risks, recommendation

## Completion Criteria

The goal is complete when:

- all walkthrough areas above have been covered or explicitly marked not applicable with reason
- safe bugs discovered during the hunt are fixed or filed as follow-up risks
- performance/lag/heat concerns have at least targeted reproduction or a clear "not observed in tested paths" statement
- validation has passed or failures are explained as genuine blockers
- the durable report exists
- the feature lane is clean and committed
- paywall remains excluded unless Jojo explicitly changed scope

