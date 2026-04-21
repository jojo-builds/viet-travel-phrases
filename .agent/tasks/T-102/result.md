# Result: T-102

## Status
- done

## Truth changed
- live

## Changed files
- `docs/website/PHRASE_AUDIO_DELIVERY.md` - updated the durable website seam doc to name the exact 4-of-7 Vietnam hub subset, the on-hub order, and why the other exported starter modules remain off-hub.
- `site/countries/vietnam.html` - clarified the live Vietnam hub copy so the page now states the surfaced starter order explicitly and names the starter modules that stay off-hub.
- `site/countries/vietnam/index.html` - mirrored the bounded Vietnam hub copy clarification into the routed pair so route-parity truth stayed intact.
- `.agent/tasks/T-102/logs/starter-module-ordering.md` - recorded the export evidence, subset rationale, no-swap decision, and validator result for this pass.
- `.agent/tasks/T-102/reviews/gate-02-pass-01/*.md` - recorded unanimous Gate 2 approval across traveler utility, conversion honesty, export subset, and contract scope.
- `.agent/tasks/T-102/reviews/gate-03-pass-01/*.md` - recorded the first Gate 3 mixed outcome, where two reviewers blocked on expected pre-finalization timing rather than on a content mismatch.
- `.agent/tasks/T-102/reviews/gate-03-pass-02/*.md` - recorded unanimous Gate 3 approval after clarifying that `result.md` must remain `in_review` until the parent writes the current pass and finalizes the task.

## Validation
- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` passed after the copy/doc update.
- Confirmed route-pair parity still holds for `site/countries/vietnam.html` and `site/countries/vietnam/index.html`.
- Confirmed the Vietnam hub still surfaces `vietnam-arrival-basics`, `vietnam-transport-basics`, `vietnam-money-basics`, and `vietnam-phone-basics` in that order.
- Confirmed `content-draft/viet/website-preview.json` and `site/data/phrase-previews/manifest.json` still support the same 7 exported Viet starter modules, with 3 intentionally off-hub.
- Gate 1 review pass 01 with 4 reviewers - passed unanimously.
- Gate 2 review pass 01 with 4 reviewers - passed unanimously.
- Gate 3 review pass 01 with 4 reviewers - not unanimous; two reviewers blocked on expected pre-finalization timing rather than content.
- Gate 3 review pass 02 with 4 reviewers - passed unanimously.

## Notes
- This pass kept the current 4-module subset and order; it did not force a subset swap because the committed export evidence still favored the existing traveler-first conversion slice.
- The bounded page copy now names the on-hub order and the off-hub starter modules so the hub conversion posture is easier to audit.
- No app, ops, export JSON, or unrelated country-route files were edited.

## Blockers
- none

## Reviews
- `.agent/tasks/T-102/reviews/gate-01-pass-01/01-traveler-utility-review.md`
- `.agent/tasks/T-102/reviews/gate-01-pass-01/02-conversion-honesty-review.md`
- `.agent/tasks/T-102/reviews/gate-01-pass-01/03-export-subset-review.md`
- `.agent/tasks/T-102/reviews/gate-01-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-102/reviews/gate-02-pass-01/01-traveler-utility-review.md`
- `.agent/tasks/T-102/reviews/gate-02-pass-01/02-conversion-honesty-review.md`
- `.agent/tasks/T-102/reviews/gate-02-pass-01/03-export-subset-review.md`
- `.agent/tasks/T-102/reviews/gate-02-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-01/01-traveler-utility-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-01/02-conversion-honesty-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-01/03-export-subset-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-02/01-traveler-utility-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-02/02-conversion-honesty-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-02/03-export-subset-review.md`
- `.agent/tasks/T-102/reviews/gate-03-pass-02/04-contract-scope-review.md`

## Logs
- `.agent/tasks/T-102/logs/starter-module-ordering.md`

## Process feedback
- SUGGESTION: future website subset-ordering tasks should name whether flat-route and routed `index.html` copies must both be edited whenever copy changes, because the validator already treats route-pair parity as part of the contract.
- SUGGESTION: when a task is likely to end in an evidence-backed no-swap decision, the spec should say whether a small explanatory copy clarification is preferred over a pure docs-only closeout.
