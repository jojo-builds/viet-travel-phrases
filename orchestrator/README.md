# SpeakLocal Orchestrator Project

Open this folder in Codex when you want a fresh session to act like the repo orchestrator.

Folder to open:

```text
/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator
```

This project exists because the long-running master chat can get too heavy. A new session opened here should have enough durable instructions to coordinate feature lanes, merge finished work, sync branches, review risky work, and build the latest `main` onto Jojo's iPhone.

## What To Ask Here

Good prompts:

- "All lanes are done. Merge everything except paywall into main and build it on my phone."
- "Create a new branch/worktree for homepage design."
- "Which lanes are ahead of main right now?"
- "Sync all non-paywall lanes to the latest main."
- "Review the browse-page lane before merging."
- "Build the current main on my phone."
- "Run a whole-app bug hunt and fix safe issues."

## Current Model For Work

- `main` is the live app.
- Jojo's phone should run `main`.
- Feature lanes live in `.worktrees/<feature-slug>`.
- Paywall is excluded unless Jojo explicitly includes it.
- Native iOS is the only app product surface.
- Marketing has its own lane under `marketing/`.

## Start Every Session

Run:

```sh
./scripts/status.sh
```

That prints the current branch, dirty files, worktrees, and feature-flow status. Do not trust stale chat memory over this output.

## Useful Scripts

```sh
./scripts/status.sh
./scripts/create-lane.sh practice-area
./scripts/sync-nonpaywall-lanes.sh
./scripts/build-phone.sh
```

The scripts are wrappers around the real repo helpers. They are intentionally thin so the repo remains the source of truth.

## Why This Uses AGENTS.md

OpenAI Codex documentation recommends `AGENTS.md` for project-level instructions and nested overrides for specialized work. This project uses that pattern so a fresh session can load the orchestrator rules without needing this old chat.

Project-scoped `.codex/config.toml` is intentionally not used yet. It can change session behavior, so this project starts with durable instructions and scripts only.
