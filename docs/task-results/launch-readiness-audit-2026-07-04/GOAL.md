# SpeakLocal Launch Readiness Audit - 2026-07-04

## Objective

Run a minimum 3-hour launch-readiness push for the current native iOS `main` app after Jojo's new-phone install succeeded. Act like a real traveler using the app, find launch blockers and high-priority gaps, fix safe issues when ownership is clear, and leave durable evidence for what is ready, what changed, and what remains.

## Context

- Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
- App: native SwiftUI under `native-ios/`
- Phone truth: `main` commit `07a2db5d8` built, installed, and launched on Jojo's replacement/new iPhone on 2026-07-04.
- Current excluded lanes: `feature/paywall` and legacy Messages remain outside `main` unless Jojo explicitly approves merging.
- Jojo noticed possible missing images and inconsistent top admin/menu treatment: Food Menu has the correct top admin feel, while Airport/Hotel/category-style surfaces may not.
- Jojo wants broad autonomous use of compute, subagents, simulator/manual QA, and safe fixes.

## Workstreams

1. Visual/surface QA: Browse, Food Menu, Airport, Hotel, category pages, city/place pages, top admin/header consistency, missing images, obvious polish gaps.
2. Content/media completeness: generated resource validation, image/backdrop references, audio manifest/missing audio posture, listing-page QA, phrase counts versus stale docs.
3. Native runtime validation: simulator build/run, UI traversal, focused tests, screenshots/UI snapshots where possible, crash/log inspection.
4. Paywall readiness read-only pass: inspect `feature/paywall`, identify merge/test gaps, do not merge or build paywall to Jojo's phone without explicit approval.

## Rules

- Keep `main` as the phone truth.
- Do not build feature branches to Jojo's phone.
- Do not merge paywall during this audit without a deliberate orchestrator decision and proof plan.
- Do not edit `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` with personal signing values.
- Workers are not alone in the codebase; they must not revert or overwrite other edits.
- Safe, scoped fixes are allowed when ownership is clear. Bigger feature decisions should be reported with evidence.
- For app-code fixes, use a feature worktree unless the change is a tiny report/doc correction.
- Every material claim needs current evidence: command output, screenshot path, file reference, or simulator/device proof.

## Reporting

Use this folder for receipts:

- `orchestrator-log.md` for timeline, decisions, and integration notes.
- `visual-surface-audit.md` for UI walkthrough findings.
- `media-content-audit.md` for generated content/audio/image findings.
- `runtime-validation.md` for build/test/simulator evidence.
- `paywall-readiness-audit.md` for paywall lane status.

## Completion Bar

The goal is complete only after:

- at least 3 hours of active launch-readiness work have elapsed, unless a true external blocker stops all meaningful progress;
- current `main` has been audited across the major app surfaces above;
- safe fixes are either applied and validated or explicitly deferred with reason;
- operational docs/manifests are updated if readiness truth changes;
- final report separates ready, fixed, deferred, and blocked items.
