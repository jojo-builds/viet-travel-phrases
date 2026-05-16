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

## 3. Finish Each Safe Non-Paywall Lane

Use the helper from the repo root:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh finish <lane-slug-or-path>
```

If conflicts happen, resolve them inside the feature lane first. Preserve both feature intents.

## 4. Validate Combined Main

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

## 5. Prove Paywall Exclusion

If paywall exists and was skipped:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
git cherry -v main feature/paywall
```

The exact output can vary. The point is to confirm paywall commits were not merged into `main`.

## 6. Sync Non-Paywall Lanes

After `main` is final:

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh sync-nonpaywall-lanes
```

If a lane is dirty, do not overwrite it. Report it.

## 7. Build Main On Phone

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family/orchestrator
./scripts/build-phone.sh
```

Report install and launch separately. A locked phone can block launch even when install succeeded.
