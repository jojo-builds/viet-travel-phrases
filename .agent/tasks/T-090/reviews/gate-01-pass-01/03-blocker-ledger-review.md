Reviewer: Codex
Role: blocker ledger
Gate: 01
Pass: 01
Verdict: BLOCKED

The evidence minimum is aligned, but the blocker ledger still has wording drift to fix before advancement. `ops/apps/viet.json` limits the next-human resync to cases where gate state changed, while the docs also require a resync when blocker wording changes. The bounded pass should tighten that next-action wording so the JSON and ops docs agree on the same sync trigger.

Approval: BLOCK
