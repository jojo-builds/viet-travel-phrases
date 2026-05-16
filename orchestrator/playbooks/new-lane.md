# New Lane Playbook

Use when Jojo wants a new parallel project/branch/worktree.

## Naming

Use short lowercase slugs:

- `homepage-design`
- `browse-page`
- `practice-area`
- `glass-static-area`
- `search-page`
- `paywall`

Branch will be:

```text
feature/<slug>
```

Folder will be:

```text
/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/<slug>
```

## Create

From this orchestrator project:

```sh
./scripts/create-lane.sh <slug>
```

The helper should create the branch and worktree from current local `main`.

## If Main Is Dirty

If `main` has unrelated untracked files, do not delete or stage them automatically.

Safe choices:

1. If the dirty files are unrelated to the new lane, create the worktree directly from current `main` after explaining why.
2. If the dirty files may affect the new lane, stop and ask Jojo whether to commit, move, or ignore them.

Direct safe fallback:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
git worktree add -b feature/<slug> .worktrees/<slug> main
```

## What To Tell Jojo

Give the folder link:

```text
/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/<slug>
```

Tell him to open that folder as a new Codex project/session.

## What The New Lane Session Must Do

At start:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh start <slug-or-path>
```

Before handoff:

- commit all intentional work;
- remove local build junk;
- run focused validation;
- summarize changed files, tests, and risks.
