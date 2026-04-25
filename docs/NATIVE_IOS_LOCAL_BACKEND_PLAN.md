# Native iOS Local Backend Plan

Last updated: 2026-04-26
Authority lane: native SwiftUI app data/backend direction

## Current decision

The native app should be built in SwiftUI. It should not depend on a network backend for phrase lookup, phrase-page rendering, audio playback, saved phrases, or related-page navigation.

The app still needs a real local backend:

- bundled phrase-page database
- stable phrase and family IDs
- canonical phrase-page graph for "Wikipedia-style" page-to-page navigation
- audio manifest that maps phrase rows to bundled audio files
- offline search index
- local user state for saved phrases, recents, playback speed, and unlock state

Canonical graph rule:

- every phrase/listing page has one stable canonical page ID
- search, browse, row links, related links, and answer-page variants should all resolve to that canonical page
- do not create duplicate pages for the same phrase, such as a second generated `Chào anh` page under a parent variant list
- route history can remember where the user came from, but content identity is independent of parent/child path

## Source of truth

Authoring truth should stay as versioned repo files, not as a hand-edited runtime database.

Current source lanes:

- `content-draft/` for authored phrase rows, answer-page samples, relation samples, and language prep
- `app/family/` for existing runtime pack and presentation contracts
- `app/assets/audio/manifest.json` and `app/assets/audio/registry.ts` for audio registry truth
- `docs/DECISIONS.md`, `docs/V2_CONTENT_MODEL.md`, and `docs/PHRASE_RELATIONSHIP_MODEL.md` for durable content/model decisions
- `docs/operations/NATIVE_MAC_CUTOVER.md` for native transition state

Recovered Windows worktree lanes now available on the Mac:

- `/Users/jojolim/Developer/products/speaklocal/recovered-worktrees/liquid-glass-native`
- `/Users/jojolim/Developer/products/speaklocal/recovered-worktrees/viet-1000-row-expansion`
- `/Users/jojolim/Developer/products/speaklocal/recovered-worktrees/visual-screen-board`
- `/Users/jojolim/Developer/products/speaklocal/recovered-worktrees/tagalog-v2-expansion`
- `/Users/jojolim/Developer/products/speaklocal/recovered-worktrees/indonesian-expansion-pack`

The recovered worktrees are reference/recovery inputs until their useful changes are intentionally merged into the canonical repo.

## Runtime storage recommendation

Use generated SQLite for read-only bundled app content.

SQLite should contain:

- destination app metadata
- scenario/category rows
- phrase families
- phrase variants
- answer-page sections
- relation edges
- search tokens / FTS index
- audio asset references
- premium/access flags

Use SwiftData or a small local store for user-owned state:

- favorites
- recent pages
- playback speed preference
- downloaded/unlocked state if needed later
- lightweight settings

Do not make SQLite the authoring source. Generate it from repo-owned files during build/export.

## First native milestone

Build the first native proof around:

- home/search entry
- `Xin chao` answer page
- `I need a doctor` answer page
- audio dock with play, save, and speed controls
- related phrase links that open another phrase page

The first proof should consume generated/static content from the repo, not handcoded Swift demo strings.

## Tooling needed

Required before simulator work:

- full Xcode installed in `/Applications/Xcode.app`
- iOS Simulator runtime installed through Xcode
- `xcode-select` pointed at full Xcode
- Xcode license accepted

Required for existing repo tooling:

- Node LTS with `npm`
- Homebrew is optional but recommended for stable Mac setup

Current Mac status on 2026-04-25:

- Command Line Tools: installed
- Swift CLI: installed
- Git: installed
- full Xcode: installed at `/Applications/Xcode.app`
- iOS Simulator / `simctl`: installed and verified with an iPhone 17 Pro simulator
- Homebrew: installed at `/opt/homebrew/bin/brew`
- Node/npm: installed through Homebrew
- First native SwiftUI proof: `native-ios/SpeakLocalNative.xcodeproj`
- First proof page: `Xin chào` listing/answer page
