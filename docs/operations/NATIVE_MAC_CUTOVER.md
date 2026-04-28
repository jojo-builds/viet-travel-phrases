# Native Mac Cutover

Last updated: 2026-04-23  
Authority lane: native iOS transition and Codex carryover truth

## Use this doc for

- provisioning the new Mac server
- deciding what stays on Windows during the overlap period
- moving Codex over without losing workflow continuity
- keeping the native SwiftUI/Xcode transition grounded in the current shared repo instead of creating split-brain state

## Target state

- The Mac becomes the primary native iOS development machine.
- Xcode and SwiftUI become the primary ship-facing app-shell toolchain.
- The current repo remains the single source of truth for:
  - app-family registry
  - content packs
  - answer-page exports
  - relation data
  - audio registry/manifest truth
  - premium boundary truth
  - queue/task state
  - durable project decisions
- Expo remains the bridge/reference lane during the transition, not the final UX destination.

## Mac status on 2026-04-25

- Canonical Mac repo path: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Compatibility symlink path: `/Users/jojolim/Documents/Projects/speaklocal-app-family`
- Recovered Windows worktree snapshots: `/Users/jojolim/Developer/products/speaklocal/recovered-worktrees`
- Command Line Tools, Swift CLI, Git, full Xcode, Homebrew, Node, and npm are installed.
- Xcode is installed at `/Applications/Xcode.app`.
- iOS 26.4 simulator tooling is installed and an iPhone 17 Pro simulator has been boot-verified.
- Native SwiftUI implementation has started in `native-ios/`.
- The first native proof app is `native-ios/SpeakLocalNative.xcodeproj`.
- The first flagship page running natively is the `Xin chào` listing/answer page.

## Current overlap plan

- Keep the current Windows server active as the main orchestration/content lane for its remaining term.
- Use that remaining Windows time to:
  - keep Viet and Tagalog content moving
  - keep answer-page exports and relation data clean
  - preserve the current dashboard/design-preview lane as a fast visual reference surface
  - avoid overinvesting in final Expo-only shell polish once the native direction is clear
- Do not start real Swift/Xcode implementation before the Mac server is commissioned. The overlap period is the trigger for native implementation, not the architectural decision by itself.
- Bring the Mac up in parallel rather than doing a cold cutover.

## What must survive unchanged

- `E:\AI\SpeakLocal-App-Family` remains the canonical repo truth today.
- `.agent\` remains the canonical queue/task-state lane.
- `.codex\` in the repo remains the project-local Codex workflow lane.
- `content-draft\` remains the authored content source of truth.
- `app\family\` remains the shared runtime/content contract source until the native shell fully owns those runtime reads.

## What to carry from Windows to the Mac

Primary continuity should come from the repo itself, not from a single live thread.

Carry these first:

- the repo clone
- `.agent\`
- `.codex\`
- `docs\`

Selective Codex-home carryover is recommended when useful:

- Windows source: `C:\Users\Administrator\.codex\`
- Mac target: `~/.codex/`

Highest-value carryover inside Codex home:

- `skills\`
- `automations\`
- config files
- optional `sessions\` / `archived_sessions\` only if the historical transcripts are actually worth preserving

Do not treat app logs as project memory. The durable continuity source is the repo plus selected Codex-home state.

## Mac bootstrap checklist

1. Provision the Mac server in the closest acceptable region.
2. Install:
   - Xcode 26.x
   - Xcode Command Line Tools
   - git
   - Node LTS
   - Homebrew
   - Codex app
3. Reauthenticate:
   - Codex app
   - Apple Developer / App Store Connect as needed
   - Git hosting as needed
4. Clone the repo.
5. Restore selected `~/.codex/` state from Windows if desired.
6. Open the repo in Codex.
7. Validate the shared tooling from the repo root:
   - `node script/build_and_run.js doctor`
8. Validate the content/runtime lane from `app\`:
   - `npm run build:viet-pack`
   - `npm run validate:family`
   - `npm run validate:premium-boundary`
   - `npm run validate:premium-expansion`

## Codex workflow continuity on the Mac

- Start a fresh orchestrator thread on the Mac instead of trying to preserve one old live Windows thread as the only memory source.
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

Codex run actions should prefer the Node wrapper so the same project-local actions work on both Windows and macOS with less workflow redo.

## Native first milestone

The first native SwiftUI milestone should prove one reusable family shell with:

- home
- dedicated search
- listing/answer page

Flagship answer pages for the first native proof:

- `Xin chào`
- `I need a doctor`

Those screens should consume the same repo-owned content truth rather than a second manually maintained native-only content layer.

Use `docs/NATIVE_IOS_LOCAL_BACKEND_PLAN.md` for the native app's local content/backend storage direction.

Current implementation lane:

- `native-ios/project.yml` is the reproducible XcodeGen source for the native project.
- `native-ios/SpeakLocalNative.xcodeproj` is generated from that file for Xcode/simulator work.
- `native-ios/App/Models/PhrasePage.swift` holds the first static fixture while the generated SQLite/content export is not wired yet.
- `native-ios/App/Views/PhraseListingView.swift` is the first SwiftUI listing/answer page implementation.

## When the Mac can become primary

The Mac can become the primary day-to-day machine once all of these are true:

- Codex is installed and authenticated
- the repo opens cleanly in Codex
- the shared validation commands pass
- the first native app workspace builds in Xcode
- one flagship flow is running natively
- the queue/docs workflow feels stable enough that shutting down the Windows server does not strand project memory
