# SpeakLocal Paywall Production Goal - 2026-07-07

## Objective

Work for a minimum of 3 hours on the SpeakLocal Vietnam paywall lane, advancing it toward production readiness across product strategy, offer/copy, visual design, native implementation, StoreKit validation, App Store Connect readiness, and launch handoff. Do not stop after a shallow pass. Iterate, review, validate, and leave durable artifacts.

## Product Direction

- Paywall day one is non-negotiable.
- Current preferred offer: 7-day free trial, then $4.99/month.
- Treat that price/trial as the working decision, but record any evidence-backed concern or better alternative in the final report.
- SpeakLocal is a curated Vietnam travel companion, not a generic AI translator or school language course.
- Do not invent features. Ground every claim in the current native app or mark it as `NEEDS_APP_PROOF` / `FUTURE / DO NOT PUBLISH`.

## Work Location

- Canonical repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Paywall worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/paywall`
- Branch: `feature/paywall`
- Output folder for this goal: `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07`

Start by reading:

- `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/AGENTS.md`
- Existing paywall artifacts under `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-design-options-2026-07-06`

Before editing the paywall worktree, run:

```sh
/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh start paywall
```

If the paywall worktree is dirty, inspect it first. Do not overwrite or discard work. Checkpoint only work you understand and own.

## Required Workstreams

1. Offer and positioning audit
   - Review current paywall copy/design.
   - Validate the copy against the actual product value: food/menu depth, places/cities, phrase pages, playable audio, search, saved, practice, offline curated trip support where true.
   - Produce one recommended paywall narrative and 1-2 fallback variants.

2. Native UI implementation
   - Improve or finish the paywall screen inside `feature/paywall`.
   - Match the current app visual language: native iOS, Liquid Glass-style chrome, premium but readable, no cheap generic subscription template.
   - Ensure text fits on small and large iPhones.
   - Include restore purchase, terms/privacy links, trial language, and clear subscription disclosure.

3. StoreKit readiness
   - Inspect local StoreKit config, product IDs, subscription group expectations, entitlement gating, restore behavior, and cancellation/sandbox notes.
   - Add or repair focused tests where practical.
   - Do not make paid App Store Connect changes or submit anything. Document exact remaining clicks Jojo or the orchestrator must do.

4. Paywall gating audit
   - Verify which surfaces are gated and which preview surfaces remain accessible before subscription.
   - Recommend the production gate policy: what users can see before trial, what starts the trial/paywall, and why.
   - If safe, implement a coherent current policy in the paywall branch.

5. Visual proof
   - Generate screenshots or a local visual contact sheet of the paywall variants/current implementation.
   - Put visual artifacts in the output folder.
   - The final report must include absolute paths to visible artifacts.

6. Review gate
   - Run a self-review from at least these lenses: marketer, iOS developer, App Store reviewer, skeptical traveler.
   - Use subagents if available for independent critique.
   - Fix blockers found by the review instead of only reporting them.

## Validation

Run the strongest practical subset and record exact commands/results:

- `git status --short`
- Swift/Xcode build or focused tests for the paywall lane where practical.
- StoreKit-focused unit tests if present.
- Any paywall UI screenshot/simulator proof you can produce.
- Any lint/script checks relevant to paywall copy or app claims.

If simulator or StoreKit validation is blocked, document the blocker and create a fallback proof artifact rather than stopping silently.

## Stop Conditions

Continue for at least 3 hours unless truly blocked by credentials, unavailable Apple services, signing, payment, or repeated validation failure after a concrete fix attempt.

Do not merge `feature/paywall` into `main`.
Do not submit to App Store Connect.
Do not save payment, banking, credentials, or irreversible account settings.

## Reporting Contract

Post compact progress back to the thread using:

- `**Status Update**` every meaningful phase or roughly every 30 minutes.
- `**Decision Needed**` only for a real product/account/payment/legal choice that cannot be resolved by evidence.
- `**Jojo Test Request**` when a phone/simulator/manual test would be useful.

Final report must include:

- Branch/worktree used.
- What changed.
- Visual artifact paths.
- Validations run and results.
- Remaining blockers before production.
- Exact next steps for App Store Connect and sandbox/TestFlight proof.
