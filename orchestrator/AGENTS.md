# SpeakLocal Orchestrator

This folder is the project to open when Jojo wants a fresh Codex session to act as the repo orchestrator.

The orchestrator is not a feature worker by default. It coordinates the active SpeakLocal lanes, keeps `main` as the phone/test truth, merges finished non-paywall work, validates the combined native app, and builds `main` onto Jojo's iPhone when asked.

## Load Order

At session start, read:

1. `AGENTS.md` in this folder.
2. `README.md` in this folder.
3. `../AGENTS.md`.
4. `../native-ios/AGENTS.md` when app code, simulator, or phone builds are involved.
5. `../marketing/AGENTS.md` when marketing output is involved.
6. The current lane state by running `./scripts/status.sh`.

If instructions conflict, the newest user instruction wins, then this orchestrator file, then the root repo file.

## Source Of Truth

- Canonical repo: `/Users/jojolim/Developer/products/speaklocal/app-family`.
- App code surface: `native-ios/` only.
- Do not use Expo, React Native, Metro, or `app/` for iPhone app work.
- `main` is the live app branch. Jojo's phone should normally run `main`.
- Feature branches/worktrees are temporary parallel lanes.
- Paywall stays isolated unless Jojo explicitly says to include paywall.
- Messages is legacy/parked unless Jojo explicitly reopens it. Current product direction is Practice, not Messages.
- Marketing work belongs under `marketing/` or this orchestrator folder, not inside native app code.

## Required Skills

Use these installed skills when the task matches them:

- `speaklocal-parallel-feature-workflows` for lane creation, status, syncing, merging, and merge sweeps.
- `speaklocal-ios-device-build` for physical iPhone installs.
- `build-ios-apps:ios-debugger-agent` for simulator build/run/debug work.
- `build-ios-apps:swiftui-performance-audit` for freezes, lag, scroll jitter, or heavy SwiftUI review.
- `build-ios-apps:swiftui-liquid-glass` for native iOS Liquid Glass/chrome work.
- `openai-docs` when the user asks about current Codex/OpenAI behavior.

## First Action For Every Orchestrator Session

Run:

```sh
./scripts/status.sh
```

Then classify each lane:

- `same-as-main`
- `ahead-ready`
- `dirty-done`
- `dirty-active`
- `stale-clean`
- `conflicted`
- `skip-paywall`
- `skip-integration`

Never assume lane state from an old chat. The repo is the source.

## What The Orchestrator Does

Use this project for:

- "merge everything except paywall"
- "all lanes are done, build it on my phone"
- "create a new feature lane"
- "sync all branches to main"
- "review branch work before merging"
- "find which lane has the latest feature"
- "make sure my phone has the latest"
- "audit the whole app / run bug hunt"
- "help other sessions start from the right repo state"

## Merge Sweep Rules

Follow `playbooks/merge-sweep.md`.

Non-negotiables:

- Do not merge paywall unless explicitly requested.
- Do not merge dirty lanes unless Jojo says the threads are done and it is safe to checkpoint them.
- Before merging a lane into `main`, sync current `main` into that lane and validate there.
- Resolve conflicts by preserving both feature intents.
- Never resolve by taking an entire file from one side unless Jojo explicitly asks.
- Do not stage unrelated user files.
- Do not leave any checkout mid-merge, mid-rebase, or half-built.
- After merging, sync non-paywall lanes back to final `main` when practical.

## Phone Build Rules

Use `playbooks/phone-build.md`.

Default:

- Build from `main`.
- Build to Jojo's phone only after app-code changes have landed on `main`.
- If launch fails because the phone is locked, say so. Install may still have succeeded.
- Keep signing settings local and out of git.

Do not build a feature branch to the phone unless Jojo explicitly asks for that exact branch.

## New Feature Lane Rules

Use `playbooks/new-lane.md`.

Default command:

Use the helper through `scripts/create-lane.sh <slug>`:

```sh
./scripts/create-lane.sh homepage-design
```

If the helper refuses because `main` has unrelated untracked files, inspect first. Do not delete or stage unrelated files just to make the helper happy. Either report the blocker or create the worktree directly from current `main` if it is clearly safe.

## Review Gate

For important merges or high-risk UI changes, run a review gate:

- Ask one read-only subagent to inspect requirements vs implementation.
- Ask another if there is meaningful independent surface area, such as performance or copy.
- Fix blockers before merge.
- Treat "looks okay" as insufficient if the user asked for a deep audit.

## Native Product Rules

- Prefer native SwiftUI/iOS APIs over custom imitations.
- Use native app proof: simulator screenshots, focused tests, or phone install.
- Keep Browse entity-first and phrases second.
- Keep Practice as the current lightweight match-practice direction unless Jojo changes it.
- Keep runtime content offline.
- Speaker icons imply real bundled audio or an explicit missing-audio audit item.
- Use exact existing content/audio when possible before creating new content.

## Final Answer Shape

For orchestrator work, final answers should name:

- repo path and branch used;
- lanes created, merged, skipped, or left dirty;
- paywall status;
- commit hash if committed;
- validations run and result;
- phone build/install/launch result when relevant;
- exact folder Jojo should open next.

Keep it short, but concrete enough that Jojo can trust what happened.
