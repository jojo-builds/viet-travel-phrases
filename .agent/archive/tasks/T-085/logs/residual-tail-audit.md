# Korean Residual Tail Audit

## Summary

- Kept all `62` previously resolved Korean rows unchanged.
- Converted the remaining `small-talk` tail into explicit row-level handoff decisions instead of leaving a vague unresolved queue.
- Kept `asking-price-3` as the lone deferred rewrite row because the price-reaction intent still looks weak for South Korea travel use.

## Residual posture after this pass

- `6` rows are now explicitly parked as `pending-next-pass` low-priority social coverage:
  - `korean-small-talk-1`
  - `korean-small-talk-2`
  - `korean-small-talk-3`
  - `korean-small-talk-4`
  - `korean-small-talk-5`
  - `korean-small-talk-6`
- `1` row is now explicitly parked as `deferred-native-review`:
  - `korean-small-talk-7`
- `1` row remains `deferred-rewrite-needed`:
  - `korean-asking-price-3`

## File-level decisions

- `content-draft/korean/phrase-source.csv`
  - rewrote the `small-talk` row notes so each row now says whether it is optional later social coverage or a native-review holdout
  - changed `korean-small-talk-7` from generic unresolved status to `deferred-native-review`
- `content-draft/korean/first-wave-priority.csv`
  - extended the ranked ledger from `62` rows to the full `70` rows so the residual posture is explicit instead of hidden
- `content-draft/korean/README.md`
  - rewrote the lane summary around a closed practical queue plus explicit residual handoff
- `content-draft/korean/source-notes.md`
  - documented the final residual-tail decisions and preserved the existing service and medical caution
- `content-draft/korean/research-backlog.md`
  - replaced the vague unresolved list with an explicit later-social / native-review / deferred-rewrite handoff

## Expected status counts after edits

- `29` `first-wave-translated`
- `1` `first-wave-translated-sensitive`
- `29` `second-pass-translated`
- `1` `second-pass-translated-contextual-only`
- `2` `second-pass-translated-needs-localization-check`
- `6` `pending-next-pass`
- `1` `deferred-native-review`
- `1` `deferred-rewrite-needed`

## Notes for later review

- Keep the current Korean service-wording, transit, room-problem, goodbye, and medical cautions untouched during this tail-handoff pass.
- Treat `small-talk-7` as a native-review question, not as missing translation throughput.
