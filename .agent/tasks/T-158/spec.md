# Task Spec: T-158

## Title
Migrate native Viet resources into `LanguagePacks/viet`.

## Objective
Move the current live Viet native generated resources into the reserved language-pack structure so the native app can support multiple destination apps through one shared SwiftUI shell plus per-app config and language packs.

This is the coordinated implementation task for the structure introduced in `docs/APP_FAMILY_STRUCTURE.md`. Do not run it until `T-157` has proved the Mac queue claim/heartbeat/finish/commit workflow.

## Success Criteria
- Vietnam phrase catalog, authored listing pages, audio manifest, audio audit, and audio assets load from one coherent Viet language-pack contract or documented compatibility shim.
- Swift loaders, generator scripts, XcodeGen resource rules, tests, and docs all agree on the same resource path model.
- Visible app behavior stays unchanged after the migration.
- The old root-level resource shape is either removed or clearly documented as a temporary compatibility bridge.
- Required build/resource checks pass, or a real blocker is documented after bounded investigation.
- All mandatory review gates pass before the task is marked done.

## Repo / Working Surface
- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read first
- `AGENTS.md`
- `.agent/TASK_PROMPTING.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `native-ios/README.md`
- `native-ios/Config/README.md`
- `native-ios/project.yml`
- `.agent/tasks/T-158/state.json`
- `.agent/tasks/T-158/spec.md`

Do not auto-pick another queued task. Process `T-158` only after it has been explicitly promoted from `draft` to `queued`.

## Scope
- expected worker size: `60` to `180` minutes
- this is a meaningful migration task, not a small docs tweak
- keep the app fully offline
- preserve existing native app behavior while changing resource layout

## Worker Judgment
- Treat this spec as an outcome contract, not a brittle step list.
- Choose the safest migration path after inspecting current loaders, scripts, project resources, and tests.
- If a compatibility shim is safer than a full move in one pass, justify it in `result.md` and make the remaining work explicit.
- Record concise decisions, evidence, and tradeoffs; do not dump hidden chain-of-thought.

### Allowed write scopes
- `native-ios/project.yml`
- `native-ios/App/**` only where resource loading paths or strongly related tests require it
- `native-ios/scripts/**`
- `native-ios/Resources/LanguagePacks/viet/**`
- `native-ios/Resources/viet-*.json` only as part of removing or redirecting the old root-level generated resource layout
- `native-ios/Resources/Audio/**` only if moving audio into the Viet language pack
- `native-ios/Tests/**`
- `docs/APP_FAMILY_STRUCTURE.md`
- `native-ios/README.md`
- `docs/operations/NATIVE_MAC_CUTOVER.md`
- `.agent/tasks/T-158/**`

### Allowed read scopes
- `content-draft/viet/**`
- `app/family/appRegistry.js`
- `docs/DECISIONS.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- relevant native Swift files under `native-ios/App/**`

### Must not touch
- UI styling, layout, navigation animation, listing copy, or authored phrase content unless a path hardcode directly blocks the migration
- unrelated language drafts outside generated pack path setup
- website/app Expo runtime code unless you discover a documented coupling and record it as a blocker first
- `T-157` files

## Source-of-truth notes
- Current live Viet native resources are still root-level files under `native-ios/Resources/` plus `native-ios/Resources/Audio/`.
- Target structure is `native-ios/Resources/LanguagePacks/viet/`.
- `native-ios/Config/apps/vietnam.json` is planning/config truth for the app variant.
- The migration is not complete unless Swift loaders, scripts, XcodeGen resource rules, tests, and docs all agree on the same resource location.
- Generated resources should still be regenerated from source, not hand-edited as content.

## Required checks
- `python3 .agent/queue_tool.py heartbeat --task-id T-158 --session-id "<session-id>" --phase "post-claim-heartbeat" --lease-minutes 180`
- `cd native-ios && xcodegen generate`
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- Run any existing native resource/catalog tests if present.
- Run or add a focused check proving:
  - the phrase catalog loads from the Viet language pack
  - authored listing pages load from the Viet language pack
  - the audio manifest loads from the Viet language pack
  - bundled audio paths resolve after the move

## Relevant skills
- `build-ios-apps:ios-debugger-agent` for native build/simulator verification
- `build-ios-apps:swiftui-ui-patterns` only if loader changes require minimal SwiftUI/runtime inspection
- `superpowers:verification-before-completion` before claiming completion

## Heartbeat and recovery contract
- keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`
- heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after builds, before/after spawned subagent waits, and before finish
- preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-158 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- keep compact progress notes under `.agent/tasks/T-158/logs/progress.md` if the task runs long
- if helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`

## Review gate
Mandatory. This task uses the full meaningful review contract.

Run exactly `3` gates. Each gate uses `4` read-only Codex subagents:
- resource-loader reviewer: checks Swift loaders, bundle paths, XcodeGen resource inclusion, and offline runtime behavior
- generator/scripts reviewer: checks scripts regenerate resources into the new location without stale root-level assumptions
- app-family architecture reviewer: checks the result matches shared shell plus language-pack direction and does not accidentally make Viet special forever
- test/operations reviewer: checks validation coverage, docs, and queue/result state

Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`. The parent worker writes review artifacts under `.agent/tasks/T-158/reviews/gate-XX-pass-YY/`.

If any reviewer blocks, resolve notes and repeat that gate. Do not mark this task done unless all `3` gates pass unanimously.

## Definition of done
- `T-158` is no longer blocked by `T-157` and was explicitly claimed by the worker.
- Viet native generated JSON resources and audio path contract are under `native-ios/Resources/LanguagePacks/viet/` or the result explains a deliberate partial migration blocker.
- Swift loaders, generator scripts, XcodeGen, docs, and tests agree with the same target structure.
- Old root-level generated resource assumptions are removed or intentionally left as compatibility shims with documented sunset conditions.
- Required checks pass or a real blocker is documented after bounded investigation.
- All `3` review gates pass with unanimous `4`-reviewer approval.
- `.agent/tasks/T-158/result.md` exists and agrees with final `state.json`.
- Task changes are committed.

## Required result contract
Before stopping, write `.agent/tasks/T-158/result.md` using the repo template shape.

The result must include:
- summary of actual files moved or left as compatibility shims
- validation commands and outcomes
- review artifact paths
- any old root-level references intentionally retained
- `Process feedback` with at least one bullet starting exactly with `BUG`, `SUGGESTION`, or `NONE`
