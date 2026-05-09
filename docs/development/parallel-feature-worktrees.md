# Parallel Feature Worktrees

Current baseline:

- `main` is the tested iPhone baseline.
- Create each feature branch from `main`.
- Keep feature branches in `.worktrees/` so the primary checkout stays clean.

Create a feature lane:

```sh
git worktree add .worktrees/<feature-slug> -b feature/<feature-slug> main
```

Work in that lane:

```sh
cd .worktrees/<feature-slug>
```

Check active lanes:

```sh
git worktree list
```

Remove a finished lane after it has been merged or intentionally abandoned:

```sh
git worktree remove .worktrees/<feature-slug>
git worktree prune
```
