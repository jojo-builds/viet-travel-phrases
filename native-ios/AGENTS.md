# SpeakLocal Native iOS

This is the active Mac app folder for SpeakLocal Vietnam native iOS work.

Open this folder in Codex for:

- SwiftUI UI implementation
- Liquid Glass-style native chrome
- simulator build/run/debug work
- native navigation, search, audio, and listing-page rendering

Open the repo root instead for:

- authored content under `content-draft/`
- native resource generation scripts
- durable docs and migration/source-of-truth updates

Do not open or edit a React Native/Expo app for product work. `native-ios/` is the only active app product surface.

Read these before meaningful changes:

- `../AGENTS.md`
- `README.md`
- `../docs/PHRASE_RELATIONSHIP_MODEL.md`
- `../docs/V2_CONTENT_MODEL.md`
- `../content-draft/viet/README.md`

Native project rules:

- `project.yml` is the reproducible XcodeGen source.
- `SpeakLocalNative.xcodeproj` is generated from `project.yml`.
- If project files, sources, tests, or resources move, update `project.yml` and regenerate with `xcodegen generate`.
- Use `App/` for Swift source and `Resources/` for bundled generated data and assets.
- Generated JSON resources in `Resources/` should usually be regenerated from source instead of hand-edited.
- Do not move content truth into Swift just because it is easier in the moment.

Current native source map:

- `App/SpeakLocalNativeApp.swift` starts the app.
- `App/Views/AppShellView.swift` owns app chrome, search presentation, detail route stack, back/forward history, and swipe navigation.
- `App/Views/PhraseListingView.swift` owns the flagship `Xin chào` page and shared listing/article components.
- `App/Views/PhraseDetailView.swift` renders authored listing/detail article pages.
- `App/Views/SearchPageView.swift` owns dedicated search.
- `App/Views/AudioControls.swift` owns playback controls.
- `App/Design/NativeGlass.swift` owns native glass styling and layout constants.
- `App/Models/PhrasePage.swift` owns phrase, detail, article, search, category, and catalog models.
- `App/Models/GeneratedVietContent.swift` loads `Resources/viet-phrase-catalog.json`.
- `App/Models/AuthoredVietListingPages.swift` loads `Resources/viet-authored-listing-pages.json`.
- `App/Models/AudioAssetManifest.swift` loads `Resources/viet-audio-manifest.json` and handles playback lookup.

Content and listing-page rules:

- `Xin chào` is the flagship visual/content rhythm.
- Tier 1 pages should feel like thoughtful offline answers to "Different ways to say [phrase] in Vietnam."
- Use the installed `speaklocal-listing-pages` skill when authoring, reviewing, or refactoring listing/detail pages.
- Runtime copy remains offline; do not add runtime AI/network dependency for phrase content.
- One phrase gets one canonical page ID. Search, browse, variants, Explore shelves, and row arrows should all route to that page.
- Speaker icons imply playable bundled audio or a missing-audio audit item.
- Reuse exact normalized audio before generating a new ElevenLabs file.
- Breakdown tokens do not automatically need pages, but meaningful phrase rows can.

Design rules Jojo has locked in:

- Native iOS feel is the product direction.
- Back/search/bottom chrome should be glassy and visually static while content moves beneath it.
- Search should feel like the bottom search island morphing into the search field.
- Swipe back and swipe forward should feel like browser history; forward history clears after opening a new route.
- The bottom toolbar and search island should stay compact and close enough to feel like one native control area without touching the device edge.
- Long subtitles should wrap or use a detail page, not clip important meaning.
- Horizontal Explore shelves should show category-style groups and speaker icons for audio playback.
- Homepage phrase shelves should be friendly labels over existing Browse routes, not duplicate category IDs:
  - `Use now` -> `.category("essentials")`
  - `First hour in Vietnam` -> `.category("first-day")`
  - `Eating Out` -> `.category("food")`
  - `When you don't understand` -> `.category("polite-repair")`
  - `Taxi & getting around` -> `.category("getting-around")`
  - `Hotel basics` -> `.category("hotel")`
  - `Money & shopping` -> `.category("shopping")`
  - `Tiny conversations` -> Messages/Practice surface, not a normal Browse category page
- Break-it-down should be a horizontal strip/carousel with one idea per card, plus signs between tokens, and an equals sign before the full phrase.
- Avoid internal UI labels such as `repair`; use traveler language like "When You Don't Understand."

Verification expectations:

- After visible UI changes, build and launch the simulator so Jojo can test it.
- For code changes, run the relevant Xcode build/test command when practical:
  - `xcodegen generate`
  - `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' build`
- For content/resource changes, regenerate the relevant resource and inspect the diff before committing.
