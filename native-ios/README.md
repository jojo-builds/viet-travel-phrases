# SpeakLocal Native iOS

This is the folder to open in Codex for native SpeakLocal Vietnam app work on the Mac:

`/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`

The full repo root is still:

`/Users/jojolim/Developer/products/speaklocal/app-family`

Use the root when the task is about docs, content authoring, resource generation, migration cleanup, or shared app-family logic.

## Current Status

- Native SwiftUI/Xcode is now the active ship-facing app lane.
- This folder is the shared native app shell for future SpeakLocal app variants.
- The app target is `SpeakLocalNative`.
- The project is generated from `project.yml`.
- The flagship flow is the Liquid Glass-style `Xin chào` listing page plus canonical deeper phrase pages, search, audio, and back/forward navigation.
- The 150 Tier 1 Vietnam listing pages are authored offline article pages sourced from `../content-draft/viet/listing-pages/**`.
- Runtime phrase content stays bundled/offline.
- App-variant planning config lives in `Config/apps/*.json`.
- `Resources/LanguagePacks/<language>/` is reserved for the future per-language bundle layout. Current Viet resources still load from root-level `Resources/*.json` and `Resources/Audio/`.

## Build And Run

Regenerate the Xcode project when `project.yml`, source folders, tests, or resource wiring change:

```sh
xcodegen generate
```

Build from this folder:

```sh
xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

For local physical-device testing, keep personal signing out of repo files. Pass the developer team only as a local command-line override:

```sh
xcodebuild -project SpeakLocalNative.xcodeproj \
  -scheme SpeakLocalNative \
  -destination 'id=<DEVICE_ID>' \
  -configuration Debug \
  -allowProvisioningUpdates \
  DEVELOPMENT_TEAM=<LOCAL_TEAM_ID> \
  CODE_SIGN_STYLE=Automatic \
  build
```

Do not add `DEVELOPMENT_TEAM`, provisioning profile IDs, certificate fingerprints, or phone-specific signing details to `project.yml` or the generated `.xcodeproj`.

Run tests from this folder:

```sh
xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

After visible UI changes, launch the app in the iOS simulator for Jojo to test.

## Important Files

- `project.yml` - XcodeGen project source
- `Config/apps/*.json` - native app-variant planning/config surface
- `App/SpeakLocalNativeApp.swift` - app entrypoint
- `App/Views/AppShellView.swift` - shell chrome, route stack, search presentation, back/forward gestures
- `App/Views/PhraseListingView.swift` - flagship listing page and shared listing/article components
- `App/Views/PhraseDetailView.swift` - authored detail/article page rendering
- `App/Views/SearchPageView.swift` - dedicated search page
- `App/Design/NativeGlass.swift` - glass styling and layout constants
- `App/Models/PhrasePage.swift` - phrase/detail/article/search models
- `App/Models/GeneratedVietContent.swift` - native catalog loader
- `App/Models/AuthoredVietListingPages.swift` - authored listing-page resource loader
- `App/Models/AudioAssetManifest.swift` - audio manifest and playback lookup
- `Resources/viet-phrase-catalog.json` - generated native phrase catalog
- `Resources/viet-authored-listing-pages.json` - generated authored Tier 1 listing pages
- `Resources/viet-audio-manifest.json` - generated audio manifest
- `Resources/viet-authored-audio-audit.json` - generated authored-page audio audit
- `Resources/LanguagePacks/` - reserved target folder for future per-language native resource bundles

## Generation

Run native catalog generation from this folder:

```sh
node scripts/generate-viet-catalog.js
```

Run authored Tier 1 listing-page generation from this folder:

```sh
node scripts/generate-authored-tier-one-pages.js
```

Use the authored source under `../content-draft/viet/listing-pages/**` for content edits; avoid hand-editing generated native JSON.

## Product Direction

- `Xin chào` is the visual/content pattern to preserve.
- Listing pages should answer "Different ways to say [phrase] in Vietnam" with thoughtful offline article sections, useful variants, local/tone guidance, follow-ups, and canonical Explore links.
- Search, browse, row arrows, and Explore shelves should point to one canonical page per phrase.
- Speaker icons should play bundled audio or be captured by the missing-audio audit.
- Glass chrome should feel native and stable while page content animates underneath.
