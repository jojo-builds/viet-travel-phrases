- status: done
- truth changed classification: prepared-next

## Changed files

- `content-draft/spanish/phrase-source.csv` - cleared the residual `needs-translation` tail, added Spain-fit rewrites for the low-fit taxi and restaurant scaffolds, and left the medical row explicitly flagged.
- `content-draft/spanish/first-wave-priority.csv` - extended the ranked queue from `30` to `47` rows so the resolved residual tail is tracked explicitly.
- `content-draft/spanish/source-notes.md` - documented the pronunciation normalization rule, residual-tail cleanup, and reconciled current lane totals.
- `content-draft/spanish/research-backlog.md` - marked the residual-tail cleanup items complete and narrowed the open prep-only blockers.
- `content-draft/spanish/README.md` - updated the lane summary to reflect near-complete draft coverage and the remaining prep-only decisions.
- `.agent/tasks/T-081/logs/translation-pack-audit.md` - recorded baseline counts, rewritten rows, and final status totals for this pass.
- `.agent/tasks/T-081/reviews/gate-01-pass-01/*.md` - Gate 1 unanimous approvals before edits.
- `.agent/tasks/T-081/reviews/gate-02-pass-01/*.md` - Gate 2 first pass with one coherence block due stale counts in `source-notes.md`.
- `.agent/tasks/T-081/reviews/gate-02-pass-02/*.md` - Gate 2 rerun with unanimous approval after the stale-count fix.
- `.agent/tasks/T-081/reviews/gate-03-pass-01/*.md` - Gate 3 first pass with one closeout block due orthography-note mojibake in Spain lane docs.
- `.agent/tasks/T-081/reviews/gate-03-pass-02/*.md` - Gate 3 rerun with unanimous approval after the orthography-note fix.
- `.agent/tasks/T-081/state.json` - recorded claim, heartbeats, and review-phase progress for this run.
- `.agent/tasks/T-081/result.md` - finalized closure record for the Spain prep-lane pass.

## Validation performed

- Imported `content-draft/spanish/phrase-source.csv` successfully and confirmed `70` rows parse as CSV.
- Confirmed `content-draft/spanish/phrase-source.csv` now has `0` `needs-translation` rows and `0` blank `target_text` cells.
- Confirmed `content-draft/spanish/phrase-source.csv` status totals are `39` `drafted`, `24` `first-wave-promoted-core`, `6` `rewritten-and-drafted`, and `1` `first-wave-flagged-holdout`.
- Imported `content-draft/spanish/first-wave-priority.csv` successfully and confirmed `47` ranked rows parse as CSV.
- Confirmed `content-draft/spanish/first-wave-priority.csv` now has `41` `drafted-in-phrase-source` rows and `6` `rewritten-and-drafted` rows.
- Confirmed the relevant Spain lane files no longer contain the stale `52 everyday drafted rows` or `28 additional row outcomes` text that blocked Gate 2 pass 01.
- Confirmed the relevant Spain lane files do not contain obvious `Ã` or `Â` mojibake sequences.
- Confirmed Gate 1 latest pass (`gate-01-pass-01`) contains exactly `4` review files and all four approvals are explicit.
- Confirmed Gate 2 latest pass (`gate-02-pass-02`) contains exactly `4` review files and all four approvals are explicit.
- Confirmed Gate 3 latest pass (`gate-03-pass-02`) contains exactly `4` review files and all four approvals are explicit.
- Runtime-surface verification was handled by scope discipline in this run: all edits stayed inside `content-draft/spanish/**` and `.agent/tasks/T-081/**`; no `app/**`, `site/**`, `ops/**`, or runtime-wiring files were edited.
- `git status` could not be used for repo-wide diff verification because Git reported a safe-directory / dubious-ownership error against the compatibility-root repo path on this machine.

## Review findings and what was fixed

- Gate 1 traveler utility: approved the baseline as already strong enough to extend, with the remaining unresolved set genuinely smaller and no need for another broad planning loop.
- Gate 1 language risk: approved the rewrite-first posture and explicit medical holdout handling.
- Gate 1 translation pack: approved the baseline artifacts as coherent enough to proceed.
- Gate 1 contract/scope: approved the prep-only task surface and allowed write scope.
- Gate 2 traveler utility pass 01: approved the cleanup work as materially shrinking the unresolved queue.
- Gate 2 language risk pass 01: approved the Spain-fit rewrites and bounded pronunciation rule.
- Gate 2 translation pack pass 01: blocked because `content-draft/spanish/source-notes.md` still carried stale counts from the previous pass.
- Gate 2 contract/scope pass 01: approved the task as still prep-only and inside scope.
- Gate 2 pass 02: all four reviewers approved after the stale counts in `content-draft/spanish/source-notes.md` were reconciled.
- Gate 3 pass 01: contract/scope review blocked final closeout until mojibake-like orthography notes in `README.md` and `source-notes.md` were fixed.
- Gate 3 pass 02: all four reviewers approved after the orthography-note fix and explicit confirmation that the visible shell mojibake was display noise rather than file-content drift.

## Gate summary

- Gate 1: pass 01 approved unanimously by traveler utility, Spanish language risk, translation pack, and contract/scope reviewers.
- Gate 2: pass 01 blocked on translation-pack coherence due stale counts; pass 02 approved unanimously after the supporting doc fix.
- Gate 3: pass 01 blocked on orthography-note cleanup; pass 02 approved unanimously after the fix.

## Remaining risks / cautions

- `spanish-simple-problems-6` remains an explicit `expert-review-medical` holdout and should not be treated as runtime-ready.
- The new pronunciation normalization rule is documented, but still needs future consistency validation as the lane grows.
- The small-talk tail is now drafted, but it still needs a later product decision on whether it belongs in any future starter slice.
- Audio posture, accent-insensitive search behavior, and broader runtime-graduation evidence remain future prep-only work.

## Recommended next step

- Keep Spain prep-only, leave the medical row behind expert review, and use the next bounded pass for pharmacy / medicine coverage or starter-slice pruning rather than another generic cleanup loop.

## Process feedback

- `SUGGESTION`: The task contract works better when narrative docs carry explicit cumulative totals, because Gate 2 can otherwise fail on stale pass-to-pass accounting even when the CSV truth is already correct.
