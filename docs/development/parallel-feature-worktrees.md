# Parallel Feature Worktrees

Current baseline:

- `main` is the tested iPhone baseline.
- Create each feature branch from `main`.
- Keep feature branches in `.worktrees/` so the primary checkout stays clean.
- Use feature-specific Simulators for branch QA. Jojo's physical iPhone should run `main` unless he explicitly asks to test a branch on-device.
- Before a finished branch merges into `main`, merge current `main` into the branch first and validate there. Resolve conflicts in the branch, not in `main`.
- Do not resolve conflicts by taking a whole file from one side unless Jojo explicitly asks for that. Preserve both feature intents and rerun the focused tests/screenshots for the touched surface.
- Feature threads can stop once their own branch is committed, validated enough for scope, and summarized. The orchestrator can later sweep completed branches into `main`, review the combined app, and build `main` on Jojo's phone.

Create a feature lane:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh create <feature-slug>
```

Work in that lane:

```sh
cd .worktrees/<feature-slug>
```

Check active lanes:

```sh
git worktree list
```

Sync an existing clean lane before new work:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh sync <feature-slug-or-path>
```

Finish a lane:

```sh
cd .worktrees/<feature-slug>
git status --short
git add -A
git commit -m "Finish <feature> work"

cd /Users/jojolim/Developer/products/speaklocal/app-family
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh finish <feature-slug>
```

If `finish` or `sync` reports conflicts, resolve them inside `.worktrees/<feature-slug>`, preserve the current `main` behavior plus the branch feature, validate, commit the merge resolution, then rerun `finish`.

Build the phone after app changes are merged:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh build-phone main
```

The helper refuses non-`main` phone builds by default so Jojo does not accidentally test a stale branch.

Orchestrator sweep:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh status
```

For each completed clean branch that is not already in `main`, sync/merge it safely:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh finish <feature-slug>
```

Then review the combined app on `main`, run focused checks, and build `main` on the phone. Skip dirty/active lanes unless Jojo explicitly says to checkpoint and include them.

Remove a finished lane after it has been merged or intentionally abandoned:

```sh
git worktree remove .worktrees/<feature-slug>
git worktree prune
```
