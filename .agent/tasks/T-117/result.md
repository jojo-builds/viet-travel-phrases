# Result: T-117

## Status
- done

## Truth changed
- live

## Changed files
- `docs/website/PHRASE_AUDIO_DELIVERY.md` - documented the machine-checkable Viet starter surface contract, including the canonical fenced JSON block that the validator reads back.
- `site/data/phrase-previews/manifest.json` - added explicit `surfaceContract` metadata plus per-module `surfacePlacement` for the approved 4-on-hub / 3-off-hub Viet split.
- `site/public/data/phrase-previews/manifest.json` - mirrored the same explicit `surfaceContract` and `surfacePlacement` metadata in the public-copy manifest.
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` - hardened validation around manifest `moduleCount`, canonical doc-contract parity, hub/off-hub uniqueness, manifest/module/article parity, and starter-only export enforcement.
- `.agent/tasks/T-117/logs/viet-starter-export-contract.md` - captured the audit, manifest hashes, and validator outcome for this pass.
- `.agent/tasks/T-117/reviews/gate-01-pass-01/*.md` - recorded unanimous Gate 1 BLOCK on the missing machine-readable hub/off-hub contract.
- `.agent/tasks/T-117/reviews/gate-02-pass-01/*.md` - recorded the first mixed Gate 2 outcome after the initial hardening pass.
- `.agent/tasks/T-117/reviews/gate-02-pass-02/*.md` - recorded the second mixed Gate 2 outcome after doc-linkage remediation but before uniqueness/version hardening.
- `.agent/tasks/T-117/reviews/gate-02-pass-03/*.md` - recorded unanimous Gate 2 APPROVE after the final contract consistency pass.

## Validation
- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` passed after the final hardening pass.
- Confirmed both manifest copies still parse as JSON and remain byte-identical.
- Confirmed the live export still exposes 7 approved Viet starter modules with the same approved four-module hub order and three off-hub starter modules.
- Confirmed the validator now machine-checks the canonical doc contract block against the live manifest contract.
- Gate 1 review pass 1 with 4 reviewers - blocked unanimously and identified the missing machine-readable hub/off-hub contract.
- Gate 2 review pass 1 with 4 reviewers - not unanimous; reviewers blocked on missing `manifest.moduleCount` enforcement and prose-only doc linkage.
- Gate 2 review pass 2 with 4 reviewers - not unanimous; one reviewer blocked on uniqueness/disjointness checks plus missing `surfaceContract.version` in the canonical doc block.
- Gate 2 review pass 3 with 4 reviewers - passed unanimously.
- Gate 3 review pass 1 with 4 reviewers - not unanimous; one reviewer blocked on expected pre-finalization timing while the pass artifacts had not been written yet.
- Gate 3 review pass 2 with 4 reviewers - passed unanimously and cleared finalization.

## Notes
- This task kept the approved 4-module Vietnam hub subset intact rather than widening or reordering it.
- The hardening stays inside the export seam: no app runtime, ops docs, or unrelated country-page copy was edited.
- The remaining residual risk is rendered-country-page composition. The validator now proves contract truth, not every possible visual hub-layout drift.

## Blockers
- none

## Reviews
- `.agent/tasks/T-117/reviews/gate-01-pass-01/01-website-export-review.md`
- `.agent/tasks/T-117/reviews/gate-01-pass-01/02-conversion-honesty-review.md`
- `.agent/tasks/T-117/reviews/gate-01-pass-01/03-viet-surface-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-01-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-01/01-website-export-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-01/02-conversion-honesty-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-01/03-viet-surface-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-02/01-website-export-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-02/02-conversion-honesty-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-02/03-viet-surface-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-02/04-contract-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-03/01-website-export-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-03/02-conversion-honesty-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-03/03-viet-surface-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-02-pass-03/04-contract-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-01/01-website-export-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-01/02-conversion-honesty-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-01/03-viet-surface-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-02/01-website-export-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-02/02-conversion-honesty-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-02/03-viet-surface-scope-review.md`
- `.agent/tasks/T-117/reviews/gate-03-pass-02/04-contract-scope-review.md`

## Logs
- `.agent/tasks/T-117/logs/viet-starter-export-contract.md`

## Process feedback
- SUGGESTION: future export-contract tasks should say up front whether a canonical machine-checked doc block is required, because that decision materially changes how the validator should be wired.
