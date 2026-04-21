status: done

truth changed classification:
- prepared-next
- Korean prep lane now has an explicit residual-tail handoff instead of a vague `8`-row unresolved queue

## Objective outcome

- Yes. The Korean lane keeps its `62` resolved practical rows, converts the `small-talk` tail into explicit later-social versus native-review posture, and leaves `asking-price-3` as the lone deferred rewrite row.

## Changed files

- `content-draft/korean/phrase-source.csv` - converted the residual `small-talk` rows into explicit `pending-next-pass` or `deferred-native-review` outcomes without touching the `62` resolved rows.
- `content-draft/korean/first-wave-priority.csv` - extended the ranked lane from `62` rows to the full `70` rows so the residual tail is explicit.
- `content-draft/korean/README.md` - rewrote the lane summary around a closed practical queue plus explicit residual handoff.
- `content-draft/korean/source-notes.md` - documented the final residual-tail decisions while preserving the service, transit, room-problem, and medical cautions.
- `content-draft/korean/research-backlog.md` - replaced the vague unresolved list with explicit later-social, native-review, and deferred-rewrite categories.
- `.agent/tasks/T-085/logs/residual-tail-audit.md` - recorded the residual-tail decisions, file-level changes, and expected status counts.
- `.agent/tasks/T-085/reviews/gate-01-pass-01/*` through `gate-01-pass-04/*` - recorded the Gate 1 review history, including the pre-edit review-process reruns and the eventual unanimous planning approval.
- `.agent/tasks/T-085/reviews/gate-02-pass-01/*` - recorded unanimous Gate 2 approval for the edited Korean residual-hand-off state.
- `.agent/tasks/T-085/reviews/gate-03-pass-01/*` - recorded unanimous Gate 3 approval for final closure.
- `.agent/tasks/T-085/result.md` - carried the live closeout summary through Gate 2 and Gate 3 until final approval.

## Validation performed

- Parsed `content-draft/korean/phrase-source.csv` successfully and confirmed `70` rows load.
- Parsed `content-draft/korean/first-wave-priority.csv` successfully and confirmed `70` ranked rows load.
- Confirmed `phrase-source.csv` status counts now read: `29` `first-wave-translated`, `1` `first-wave-translated-sensitive`, `29` `second-pass-translated`, `1` `second-pass-translated-contextual-only`, `2` `second-pass-translated-needs-localization-check`, `6` `pending-next-pass`, `1` `deferred-native-review`, and `1` `deferred-rewrite-needed`.
- Confirmed `korean-small-talk-1` through `korean-small-talk-6` now carry explicit later-social notes and `pending-next-pass`.
- Confirmed `korean-small-talk-7` now carries `deferred-native-review`.
- Confirmed `first-wave-priority.csv` now surfaces the full residual tail as ranks `63` through `70`.
- Confirmed Gate 1 latest pass exists under `.agent/tasks/T-085/reviews/gate-01-pass-04/` with exactly `4` review files and unanimous approval.
- Confirmed Gate 2 latest pass exists under `.agent/tasks/T-085/reviews/gate-02-pass-01/` with exactly `4` review files and unanimous approval.
- Confirmed Gate 3 latest pass exists under `.agent/tasks/T-085/reviews/gate-03-pass-01/` with exactly `4` review files and unanimous approval.

## Review findings and what was fixed

- Gate 1 pass 01 blocked because the Korean lane still described the social tail as generic unresolved work and the ranked ledger still stopped at the last resolved row.
- Gate 1 pass 02 blocked for the same content gap after the reviewer prompts still anchored too heavily on the current pre-edit files.
- Gate 1 pass 03 blocked only on a process mismatch where some reviewers treated the required audit and result artifacts as if they had to pre-exist a pre-edit planning gate.
- Fixed that by rerunning Gate 1 with explicit instructions to judge the proposed target state, not the current pre-edit absence of outputs that are guaranteed in the same work pass.
- Gate 1 pass 04 then approved unanimously.
- Gate 2 pass 01 approved unanimously after the edited Korean lane, audit log, and drafted result all aligned on the explicit `6 / 1 / 1` residual handoff.
- Gate 3 pass 01 approved unanimously and confirmed that the final Korean prep artifacts and `result.md` agree on the residual-tail handoff.

## Gate outcomes

- Gate 1 pass 01: `APPROVE x2`, `BLOCK x2` on the still-vague residual social tail
- Gate 1 pass 02: `APPROVE x2`, `BLOCK x2` on the still-unedited tail posture and missing full residual ledger
- Gate 1 pass 03: `APPROVE x2`, `BLOCK x2` on treating future audit/result outputs as pre-edit blockers
- Gate 1 pass 04: `APPROVE x4`
- Gate 2 pass 01: `APPROVE x4`
- Gate 3 pass 01: `APPROVE x4`

## Remaining risks / cautions

- `korean-small-talk-7` remains a native-review holdout because direct stranger or service-style `How are you` wording is culturally and register-sensitive in Korean.
- `asking-price-3` remains consciously deferred until there is a stronger South Korea-fit price-reaction rewrite.
- The existing service-wording, transit, room-problem, goodbye, and medical cautions remain active and should stay review-visible.

## Recommended next step

- Treat the Korean translation backlog as functionally closed for now and reopen it only if a later native-review pass wants to resolve `small-talk-7` or a stronger South Korea-fit rewrite for `asking-price-3`.

## Process feedback

- BUG: Gate 1 reviewer prompts need an explicit reminder that pre-edit planning approval should judge the sufficiency of the proposed target state, not block on the temporary absence of required outputs that are guaranteed in the same work pass.
