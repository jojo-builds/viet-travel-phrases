# T-142 feature brief

## Source
- Recovery follow-on for interrupted `T-140`
- Shaped by the orchestrator on `2026-04-23`

## Feature
Recover and close out the interrupted Indonesian prep-lane expansion task without rerunning the full authoring packet.

## Intent
- preserve the Indonesian prep work that already landed
- finish the missing Gate 3 and final task closeout in a fresh worker thread
- keep the lane prep-only and avoid duplicate process churn

## Required behavior from the recovery direction
- treat `T-140` as historical interruption truth, not the active task to claim
- start from the already-authored Indonesian branch state and drafted `result.md`
- rerun only the validation and review work needed to confidently close the packet
- repair branch files only if a concrete issue appears during recovery

## Product constraints from orchestrator
- do not redo the full Indonesian authoring pass unless a real repair is required
- keep the lane prep-only
- this still uses the full 3-gate / 4-reviewer contract because the recovery depends on real review judgment, not shallow bookkeeping
