# SpeakLocal App Family Structure

Last updated: 2026-04-28

This repo is the canonical Mac-first, Codex-only implementation home for the SpeakLocal app family.

## Project Roots

```text
app-family/
  native-ios/                 # shared native SwiftUI app shell
  content-draft/              # authored source content by language
    viet/
    tagalog/
    japanese/
    thai/
    ...
  docs/                       # durable product/process truth
  .agent/                     # repo-local task queue
  site/                       # website/gateway
```

Use these roots in Codex:

- Native SwiftUI/UI/Xcode work: `native-ios/`
- Content, docs, generators, queue, and migration work: repo root
- Reusable skills: `/Users/jojolim/Developer/labs/skill-labs`

`native-ios/` is the only active app product surface. Legacy Expo/React Native code has been removed from the active repo so new sessions do not accidentally polish or test the wrong app.

Do not use `/Users/jojolim/Documents/New project` for app work.

## Native iOS Target Shape

The long-term native app should remain one shared SwiftUI shell with language/app variants supplied by config and bundled language packs:

```text
native-ios/
  App/                         # shared SwiftUI app code
  Config/
    apps/
      vietnam.json
      philippines.json
      japan.json
  Resources/
    LanguagePacks/
      viet/
      tagalog/
      japanese/
```

The target model:

- Same native shell and Liquid Glass UI system.
- Different app name, bundle ID, language pack, audio, content, and App Store metadata.
- One canonical page graph per language pack.
- Runtime remains offline: no AI/network dependency for phrase copy.

## Current Resource Reality

Do not move the live Viet generated files casually. Today the Swift loaders and generators still expect root-level native resources:

```text
native-ios/Resources/viet-phrase-catalog.json
native-ios/Resources/viet-authored-listing-pages.json
native-ios/Resources/viet-audio-manifest.json
native-ios/Resources/viet-authored-audio-audit.json
native-ios/Resources/Audio/
```

`native-ios/Resources/LanguagePacks/` is now the target language-pack folder. The Viet SQLite fixture under `LanguagePacks/viet/` is bundled for a debug-only read-path spike, but the live production runtime still loads the root-level JSON resources above. Moving the JSON/audio runtime into language packs still requires one coordinated task that updates:

- Swift resource loaders
- native generators
- XcodeGen resource rules
- tests
- docs

## App Config Truth

`native-ios/Config/apps/*.json` carries native app-variant planning truth. These files are not runtime-loaded yet; they exist so future variant work has one obvious native config surface.

Active app config status:

- `vietnam.json`: active native proof app
- `philippines.json`: planned next native language pack
- `japan.json`: planning placeholder for a future app

## Queue Rule

Use `.agent/tasks/T-xxx/spec.md` for executable work packets. Tasks may be large enough for a `30` minute to multi-hour worker session when the write scope and heartbeat/recovery path are clear.

The orchestrator should decide whether work belongs in:

- `native-ios/` for app UI/runtime work
- `content-draft/<language>/` plus generators/resources for language-pack work
- `.agent/tasks/T-xxx/` for worker assignments
- `docs/` for durable source-of-truth changes
