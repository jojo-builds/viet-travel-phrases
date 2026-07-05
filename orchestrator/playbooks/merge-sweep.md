# Merge Sweep Playbook

Use when Jojo says all lanes are done, merge everything, build latest on phone, or sync branches to main.

## 1. Inspect

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family/orchestrator
./scripts/status.sh
```

Classify lanes:

- `same-as-main`: already at current `main`.
- `ahead-ready`: clean and has commits not in `main`.
- `dirty-done`: dirty, but Jojo explicitly said threads are done and the diff looks intentional.
- `dirty-active`: dirty and not safe to checkpoint.
- `stale-clean`: clean but behind `main`; sync before future work.
- `conflicted`: mid-merge/rebase or unresolved conflicts.
- `skip-paywall`: always skip unless explicitly included.
- `skip-integration`: old integration lanes are not source branches.

## 2. Checkpoint Safe Dirty Lanes

Only if Jojo says work is done:

```sh
git -C <lane-path> status --short
git -C <lane-path> diff --stat
git -C <lane-path> add <intentional-files>
git -C <lane-path> commit -m "Checkpoint <lane> work"
```

Never stage build junk, unrelated user files, signing files, or broad generated outputs unless they are part of the lane's intentional work.

## 3. Pre-Merge Review Gate

Before calling the merge helper for any non-trivial `ahead-ready` or `dirty-done` lane, review the source lane against current `main`.

Treat the review, merge, and post-merge validation as separate gates. The pre-merge review must produce:

1. What changed.
2. User-facing behavior changes.
3. Possible regressions.
4. Risky files, generated resources, or state/navigation logic.
5. Missing tests or missing proof.
6. Manual QA checklist for this lane after merge.
7. Recommendation: `merge`, `fix first`, or `needs human decision`.

If the recommendation is `fix first`, fix the blocker inside the feature lane, rerun its focused validation, and update the review before merging. If the recommendation is `needs human decision`, stop and ask Jojo.

Trivial exceptions are allowed only for lanes that are already `same-as-main`, clean sync-only lanes, or docs/metadata-only changes with no runtime, operational, or product behavior effect. Say why the formal review was skipped.

For high-risk UI, navigation, performance, generated-resource, content-quality, or payment/subscription work, add at least one read-only review agent before merge. Add a second reviewer when there is a meaningful independent surface such as performance, copy, or data generation.

## 4. Finish Each Safe Non-Paywall Lane

Use the helper from the repo root:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh finish <lane-slug-or-path>
```

If conflicts happen, resolve them inside the feature lane first. Preserve both feature intents.

## 5. Validate Combined Main

Minimum checks after app-code merges:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
git status --short --branch
git diff --check
node scripts/guard-native-only.js
```

Then choose focused tests for touched areas. Common native checks:

```sh
cd native-ios
xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' build
```

Run focused XCTest suites when relevant.

Post-merge validation must explicitly check:

1. The app builds, when app code changed.
2. Existing key flows touched by the merge still work.
3. The new feature still works after merge.
4. No unrelated files changed unexpectedly.
5. No visual, admin, navigation, content, or generated-resource regression appears in the touched surface.

If anything fails, stop and report the issue before attempting broad refactors.

## 6. Prove Paywall Exclusion

If paywall exists and was skipped:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
git cherry -v main feature/paywall
```

The exact output can vary. The point is to confirm paywall commits were not merged into `main`.

## 7. Sync Non-Paywall Lanes

After `main` is final:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh sync-nonpaywall-lanes
```

If a lane is dirty, do not overwrite it. Report it.

## 8. Build Main On Phone

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family/orchestrator
./scripts/build-phone.sh
```

Report install and launch separately. A locked phone can block launch even when install succeeded.
