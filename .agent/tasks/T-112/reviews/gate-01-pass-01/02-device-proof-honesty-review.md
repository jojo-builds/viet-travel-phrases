Approval: BLOCK

The current packet is close, but it still crosses the evidence boundary in a few places.

1. `docs/operations/APP_STATUS.md` says build `1.0.0 (3)` is ready for physical iPhone install and runtime preflight. That upgrades artifact availability into implied install/device readiness. It should stay at available for attempted install unless there is durable on-device proof.
2. `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md` makes build `1.0.0 (3)` the latest installable preview artifact but does not state in the packet itself that it predates the `2026-04-16` repo snapshot and therefore cannot count as proof for the current snapshot. That boundary is explicit elsewhere and should be explicit here too.
3. `docs/operations/TESTING_RUNBOOK.md` still uses imperative wording like use the fresh internal preview build, build the same repo snapshot again, and run the exact device pass, while the same file later says neither in-flight build is yet proven installable or TestFlight-processed. Gate those steps with explicit readiness conditions so the runbook does not imply current availability.

The mirrored blocker surfaces are otherwise honest: `docs/operations/CURRENT_BLOCKERS.md` and `ops/apps/viet.json` both make the missing install/TestFlight/purchase/device proof explicit.
