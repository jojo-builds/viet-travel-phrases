# SpeakLocal Lane Map

Last refreshed manually: 2026-05-16.

Run `../orchestrator/scripts/status.sh` from this project to refresh live truth. This file is a human snapshot, not authority.

## Primary Truth

| Purpose | Path | Branch | Current snapshot |
| --- | --- | --- | --- |
| Live app/main | `/Users/jojolim/Developer/products/speaklocal/app-family` | `main` | Run `./scripts/status.sh` for the current commit. |

## Feature Lanes

| Lane | Path | Branch | Snapshot | Notes |
| --- | --- | --- | --- | --- |
| Browse | `.worktrees/browse-page` | `feature/browse-page` | synced to app commit `8d60df56` before orchestrator docs | Dirty at last refresh; inspect before merging. |
| Practice | `.worktrees/practice-area` | `feature/practice-area` | synced to app commit `8d60df56` before orchestrator docs | Clean new lane for Practice work. |
| Messages | `.worktrees/messages-section` | `feature/messages-section` | `04dd789f` | Legacy/parked unless Jojo reopens Messages. |
| Homepage | `.worktrees/homepage-design` | `feature/homepage-design` | `531874e0` | Stale vs current main at last refresh. |
| Glass/static chrome | `.worktrees/glass-static-area` | `feature/glass-static-area` | `531874e0` | Stale vs current main at last refresh. |
| Search | `.worktrees/search-page` | `feature/search-page` | `531874e0` | Stale vs current main at last refresh. |
| Performance/freeze | `.worktrees/performance-freeze-audit` | `feature/performance-freeze-audit` | `531874e0` | Stale vs current main at last refresh. |
| Native cleanup | `.worktrees/native-ios-only-cleanup` | `feature/native-ios-only-cleanup` | `531874e0` | Stale vs current main at last refresh. |
| Breakdown audit | `.worktrees/breakdown-audit` | `feature/breakdown-audit` | `531874e0` | Stale vs current main at last refresh. |
| Paywall | `.worktrees/paywall` | `feature/paywall` | `641e2b7d` | Exclude by default. |

## Integration Lanes

Old integration worktrees exist under `.worktrees/integration-phone-test-all*`. Treat them as historical test lanes, not source branches, unless Jojo explicitly asks to inspect one.

## Marketing

Marketing is a folder lane, not an app worktree:

```text
/Users/jojolim/Developer/products/speaklocal/app-family/marketing
```

Current known untracked marketing folder on `main`:

```text
marketing/projects/website-design-options/
```

Do not stage or delete it during app merge sweeps unless Jojo asks.
