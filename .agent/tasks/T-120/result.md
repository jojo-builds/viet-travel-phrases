# Result: T-120

## Status
- done

## Changed files

- `content-draft/spanish/README.md` - rewrote the lane summary into one explicit graduation-boundary packet with shared counts and residual outcomes.
- `content-draft/spanish/source-notes.md` - added the authoritative residual ledger, explicit outcome counts, and rewrite-resolved notes.
- `content-draft/spanish/first-wave-priority.csv` - added the `final_outcome` column across all `50` ranked rows so the lane has one machine-readable residual-outcome ledger.
- `content-draft/spanish/phrase-source.csv` - marked the pharmacy, social-tail, and medical holdout rows with explicit graduation outcomes.
- `content-draft/spanish/research-backlog.md` - closed the residual-tail decisions into `promote`, `later-only`, and `retire` outcomes and kept downstream blockers visible.
- `.agent/tasks/T-120/logs/spanish-graduation-packet.md` - recorded the graduation packet truth and residual adjudications.
- `.agent/tasks/T-120/reviews/gate-01-pass-01/*.md` - recorded the initial Gate 1 block.
- `.agent/tasks/T-120/reviews/gate-01-pass-02/*.md` - recorded the unanimous Gate 1 approval after the contract fix.
- `.agent/tasks/T-120/reviews/gate-02-pass-01/*.md` - recorded the unanimous Gate 2 approval on the working pass.
- `.agent/tasks/T-120/reviews/gate-03-pass-01/*.md` - recorded the unanimous Gate 3 approval on the closure packet.
- `.agent/tasks/T-120/state.json` - tracked the claim, heartbeats, and gate phases for this run.

## Validation performed

- Imported `content-draft/spanish/phrase-source.csv` successfully and confirmed `70` rows parse as CSV.
- Imported `content-draft/spanish/first-wave-priority.csv` successfully and confirmed `50` ranked rows parse as CSV.
- Counted `first-wave-priority.csv` `final_outcome` values and confirmed `41` `promote`, `3` `later-only`, `1` `native-review-only`, and `5` `retire`.
- Confirmed the required packet files exist, including `.agent/tasks/T-120/logs/spanish-graduation-packet.md`.
- Confirmed Gate 1 latest pass (`gate-01-pass-02`) contains exactly `4` review files and all four approvals are explicit.
- Confirmed Gate 2 pass (`gate-02-pass-01`) contains exactly `4` review files and all four approvals are explicit.
- Confirmed Gate 3 pass (`gate-03-pass-01`) contains exactly `4` review files and all four approvals are explicit.
- Attempted changed-file scope verification via git, but the workspace is not mounted as a git worktree in this runtime.

## Review findings and what was fixed

- Gate 1 pass 01 blocked because the packet still mixed legacy lane labels with the required residual-outcome contract and the lane summary files did not agree on completion posture.
- The fix added one explicit `final_outcome` ledger in `first-wave-priority.csv`, aligned the README and source notes to the same counts, promoted the pharmacy-adjacent pair, pushed the social tail into `later-only` or `retire`, and kept the medical holdout isolated as `native-review-only`.

## Gate summary

- Gate 1: latest pass `gate-01-pass-02` approved unanimously by traveler-utility, Spain-fit, graduation-readiness, and contract-scope reviewers.
- Gate 2: pass `gate-02-pass-01` approved unanimously by traveler-utility, Spain-fit, graduation-readiness, and contract-scope reviewers.
- Gate 3: pass `gate-03-pass-01` approved unanimously by traveler-utility, Spain-fit, graduation-readiness, and contract-scope reviewers.

## Remaining risks / cautions

- `spanish-simple-problems-6` remains the explicit medical holdout and still needs expert review before any runtime discussion.
- The lane is still prep-only and not runtime-wired; pronunciation coverage, audio posture, search/localization planning, and validation planning remain downstream blockers.
- Changed-file scope could not be machine-verified with git in this runtime because the workspace is not mounted as a git worktree.

## Recommended next step

- Keep the Spain residual packet closed and treat pronunciation, audio, search/localization, and validation as the next real graduation blockers rather than reopening small-tail translation work.

## Process feedback

- `SUGGESTION`: Future residual-closeout tasks should specify whether the contract vocabulary belongs in a new authoritative column or should replace existing execution-state labels, so Gate 1 does not spend a pass on taxonomy interpretation.
