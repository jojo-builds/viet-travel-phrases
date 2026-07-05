# Orchestrator Launch Gap Matrix

Date: 2026-07-05
Source branch: `main`
Current app-code head: `4f6462906579e1130a78b8ce6976b0eee3ed9024`
Paywall branch: `feature/paywall`

## Current Gaps

| Area | Current State | Risk | Next Action |
| --- | --- | --- | --- |
| Physical phone launch | Current `main` built and installed on Jojo's current iPhone. Launch was blocked because the phone was locked. | Medium: install is proven, but final physical launch proof is still missing. | Unlock phone and rerun launch/phone helper. |
| Paywall / StoreKit | `feature/paywall` has green hosted StoreKit/XCTest proof after commit `453d6f55a`, but it remains isolated and not merged. | High if revenue must ship in first release. Real purchase, restore, relaunch persistence, product state, and gating strategy still need proof/decision. | Keep out of `main` until Jojo explicitly approves and purchase/restore proof is complete. |
| App Store Connect submission | Metadata, launch pack, and Pro Max screenshot proof pack exist. App Store Connect upload/slot choices are not done. | Medium: launch materials are ready for planning, not submission. | Use screenshot pack and launch pack for final ASC choices. |
| Audio quality | Static release audit found no blocker: validators green, no broken manifest refs, no zero-duration files, `Không cay` covered. | Low for missing-audio blockers; medium for quality claims. | Human listen spot-check before claiming pronunciation or same-speaker quality. |
| Visual/function QA | Fresh focused post-fix rerun is green for `9` high-risk Browse/Search/Practice/audio tests. | Lower, but broad full-suite/phone feel pass remains valuable. | Run one final unlocked-phone walkthrough before App Store/TestFlight. |

## Resolved During This Goal

- Blank Browse/Search route evidence was reproduced on older/pre-fix builds and addressed by the stale photo-backdrop route fix.
- City Browse-by reliability now passes focused current-main tests.
- Practice saved-match sheet top-clearance proof passes.
- Row-audio UI stress red was traced to a brittle test path and fixed by tapping the Coffee section rail before stressing the coffee-row audio button.
- App Store screenshot planning pack now exists from a current-main Pro Max simulator.
- Audio release audit found no launch-blocking missing-audio issue.

## Current Working Recommendation

For fastest revenue path:

1. Do one unlocked physical-phone launch/walkthrough of current `main`.
2. Decide whether to ship non-paywall first or finish paywall before release.
3. If paywall ships first, keep working in `feature/paywall` until real purchase/restore/relaunch proof is green.
4. Use the screenshot pack and launch pack for App Store Connect prep while paywall strategy is decided.
