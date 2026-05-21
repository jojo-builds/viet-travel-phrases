# Native Mac Cutover

Last updated: 2026-05-13
Authority lane: native iOS transition and Codex carryover truth

## Use this doc for

- confirming the current Mac/native status
- keeping Codex sessions pointed at the native SwiftUI/Xcode app
- avoiding split-brain state between native app work and historical Expo/React references

## Current target state

- Jojo's MacBook is the only current development machine for the app.
- Xcode and SwiftUI are the only ship-facing app-shell toolchain.
- The current repo remains the single source of truth for:
  - content packs
  - relation data
  - native audio manifest truth
  - premium boundary truth
  - queue/task state
  - durable project decisions
- Expo/React Native is no longer an active app lane.

## Mac status on 2026-04-28

- Canonical Mac repo path: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Native iOS app-session path: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Skill Lab path: `/Users/jojolim/Developer/labs/skill-labs`
- Compatibility symlink path: `/Users/jojolim/Documents/Projects/speaklocal-app-family`
- Archived pre-Mac worktree snapshots, if needed for history only: `/Users/jojolim/Developer/products/speaklocal/recovered-worktrees`
- Command Line Tools, Swift CLI, Git, full Xcode, Homebrew, Node, and npm are installed.
- Xcode is installed at `/Applications/Xcode.app`.
- Xcode 26.5 and iOS 26.5 simulator tooling are installed; an iPhone 17 Pro iOS 26.5 simulator has been build/test-verified.
- Native SwiftUI implementation has started in `native-ios/`.
- The first native proof app is `native-ios/SpeakLocalNative.xcodeproj`.
- The first flagship page running natively is the `Xin chào` listing/answer page.
- The current native lane includes authored Tier 1 listing pages, canonical page graph navigation, bundled offline audio, search, bottom glass chrome, back swipe, forward swipe/history, and deeper phrase pages.
- App-family checkpoint commits:
  - `e53ffcb` `Checkpoint migrated app family state`
  - `42438a2` `Checkpoint native iOS article pages`
- Skill Lab checkpoint commits:
  - `ada6eb3` `Checkpoint migrated skill lab`
  - `bd297c2` `Add SpeakLocal listing page skill`

## Post-cutover posture

- Use the Mac native lane for day-to-day app implementation.
- Treat pre-Mac machine state as archive-only. Do not use it for development.
- Keep portable product truth in the repo:
  - content under `content-draft/`
  - native generated resources under `native-ios/Resources/`
  - durable decisions under `docs/`
  - skill process truth under `/Users/jojolim/Developer/labs/skill-labs`
- Do not preserve or revive Expo as an app implementation lane. Historical mentions remain archive context only.
- New implementation should happen in fresh focused Codex sessions opened at the correct Mac folder.

## What must survive unchanged

- `/Users/jojolim/Developer/products/speaklocal/app-family` is the canonical repo truth on the Mac.
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios` is the native app folder to open for SwiftUI work in Codex.
- `.agent\` remains the canonical queue/task-state lane.
- `.codex\` in the repo remains the project-local Codex workflow lane.
- `content-draft\` remains the authored content source of truth.
- `content-draft/viet/canonical-pages/**` remains the authored canonical phrase-page source for native article pages.
- Native resources under `native-ios/Resources/` now own bundled runtime truth for the app.
- `native-ios/project.yml` remains the reproducible native project source.
- `docs/APP_FAMILY_STRUCTURE.md` now owns the monorepo/native-language-pack structure.
- `native-ios/Config/apps/*.json` is the native app-variant planning/config surface.
- `native-ios/Resources/LanguagePacks/<language>/` is reserved for per-language generated bundles.
- `native-ios/Resources/viet-phrase-catalog.json`, `native-ios/Resources/viet-authored-listing-pages.json`, and `native-ios/Resources/viet-audio-manifest.json` remain generated native resource outputs.
  - Current Viet resources stay at root-level `native-ios/Resources/*.json` plus `native-ios/Resources/Audio/`.
  - Do not move them into `LanguagePacks/viet/` until Swift loaders, generators, XcodeGen resource rules, tests, and docs are updated together.

## Historical Carryover Note

Primary continuity now comes from the repo itself, not from old machine state or a single live thread.

Carry these first:

- the repo clone
- `.agent\`
- `.codex\`
- `docs\`

Old Codex-home carryover is historical only:

- old source: `C:\Users\Administrator\.codex\`
- Mac target: `~/.codex/`

Highest-value carryover inside Codex home:

- `skills\`
- `automations\`
- config files
- optional `sessions\` / `archived_sessions\` only if the historical transcripts are actually worth preserving

Do not treat app logs as project memory. The durable continuity source is the repo plus selected Codex-home state.

## New Mac session checklist

1. Open app coding sessions in Codex at:
   - `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
2. Open content/docs/generator sessions at:
   - `/Users/jojolim/Developer/products/speaklocal/app-family`
3. Read, in this order:
   - `native-ios/AGENTS.md` for active native app rules
   - root `AGENTS.md` for repo-wide rules
   - `docs/PHRASE_RELATIONSHIP_MODEL.md` for canonical page graph behavior
   - `docs/V2_CONTENT_MODEL.md` for content/source model truth
   - `content-draft/viet/README.md` for Viet authored source surfaces
4. Validate the shared tooling from the repo root when touching shared content:
   - `node script/build_and_run.js doctor`
5. Validate native generated content/resources from the repo root or `native-ios/` as appropriate:
   - `node native-ios/scripts/generate-viet-catalog.js`
   - `node native-ios/scripts/generate-authored-tier-one-pages.js`
   - `node native-ios/scripts/validate-viet-sqlite-fixture.js`
6. Validate the native lane from `native-ios/` when touching SwiftUI/native resources:
   - `xcodegen generate`
   - `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' build`
7. After visible native UI changes, launch the app in the simulator so Jojo can test the exact result.

## Codex workflow continuity on the Mac

- Start fresh focused threads on the Mac instead of trying to preserve old machine threads as the only memory source.
- The same workflow should continue:
  - pinned orchestrator thread for direction and review
  - fresh worker threads for meaningful implementation tasks
  - `.agent\tasks\T-xxx\state.json` remains lifecycle truth
  - `docs/DECISIONS.md` and `docs/PRIORITIES.md` remain durable direction truth
- If the Codex app shows stuck-state behavior on the Mac, use the same recovery posture:
  - check approvals
  - run a basic terminal command
  - start a new focused thread
  - restart the app only after active work is settled

## Cross-platform run-command rule

The preferred Codex/project-local run-command path is now:

- `node script/build_and_run.js run`
- `node script/build_and_run.js web`
- `node script/build_and_run.js doctor`

Legacy wrappers remain for compatibility:

- `script/build_and_run.cmd`
- `script/build_and_run.sh`

Codex run actions should prefer the native Node wrapper from this Mac repo.

## Native first milestone

The first native SwiftUI milestone is underway and should continue proving one reusable family shell with:

- home
- dedicated search
- listing/answer page

Flagship answer pages for the first native proof:

- `Xin chào`
- `I need a doctor`
- representative Tier 1 support pages such as `What does that mean?`, `Nice to meet you`, `What time is check-out?`, and `Can I have a quiet room?`

Those screens should consume the same repo-owned content truth rather than a second manually maintained native-only content layer.

Use `docs/NATIVE_IOS_LOCAL_BACKEND_PLAN.md` for the native app's local content/backend storage direction.

Current implementation lane:

- `native-ios/project.yml` is the reproducible XcodeGen source for the native project.
- `native-ios/SpeakLocalNative.xcodeproj` is generated from that file for Xcode/simulator work.
- `native-ios/App/Models/PhrasePage.swift` defines phrase, detail, article, search, category, and catalog models.
- `native-ios/App/Models/AuthoredVietListingPages.swift` loads the bundled authored listing-page resource and still carries selected hand-authored anchors.
- `native-ios/App/Models/GeneratedVietContent.swift` loads the generated native catalog.
- `native-ios/App/Views/AppShellView.swift` owns the native shell, static glass chrome, search presentation, and back/forward navigation history.
- `native-ios/App/Views/PhraseListingView.swift` owns the flagship `Xin chào` page and shared article/listing rendering components.
- `native-ios/App/Views/PhraseDetailView.swift` owns detail/article pages for authored listing resources and child phrase pages.
- `native-ios/App/Views/SearchPageView.swift` owns the dedicated search page.
- `native-ios/scripts/generate-viet-catalog.js` projects repo content into the native phrase catalog.
- `native-ios/scripts/generate-authored-tier-one-pages.js` projects `content-draft/viet/canonical-pages/**` into `native-ios/Resources/viet-authored-listing-pages.json` and `native-ios/Resources/viet-authored-audio-audit.json`.
- The next native-resource architecture step is a coordinated language-pack migration from root-level Viet resources into `native-ios/Resources/LanguagePacks/viet/`.

## Native product/design continuity

- `Xin chào` is the visual and content rhythm reference for listing pages.
- Listing pages should feel like offline AI-style answers to "Different ways to say [phrase] in Vietnam."
- The runtime remains fully offline. No app runtime AI or network dependency should be introduced for phrase copy.
- Back/search/bottom chrome should feel native and glassy while staying readable. The chrome should stay static while page content animates under it.
- Search should feel like the bottom search island morphing into the search field.
- Swipe back and swipe forward should behave like browser-style navigation history. Forward history is cleared when the user opens a new route after going back.
- Speaker icons should play bundled audio; if a visible icon has no audio, audit and generate/reuse the missing asset instead of silently removing the affordance.
- Arrows mean navigation to one canonical page ID. Do not create duplicate pages for the same phrase.
- Explore sections should keep the user moving forward through useful phrase/category shelves, not behave like dead-end lists.

## Skill Lab continuity

- The Mac skill lab lives at `/Users/jojolim/Developer/labs/skill-labs`.
- The installed SpeakLocal listing-page skill lives at `~/.codex/skills/speaklocal-listing-pages/SKILL.md`.
- Use that skill whenever authoring, reviewing, or refactoring SpeakLocal phrase listing/detail pages.
- The skill captures Jojo's current listing-page preference: thoughtful Gemini/LLM-style answer pages with phrase-specific sections, cultural/tone guidance, real variants, canonical links, and offline audio discipline.
