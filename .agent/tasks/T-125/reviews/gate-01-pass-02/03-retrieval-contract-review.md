Approval: BLOCK

Findings
- The current repo truth still treats rows `18-22` as one ordered next-pass expansion cluster, so a 3-row promote-now split would change the retrieval contract unless it is layered onto the existing five-row contract.

Required fixes before Gate 1 pass 2 can approve
- Preserve the exact five-row ordered pickup contract.
- Layer per-row readiness on top of that contract.
- Add the compact audit separating immediate trust, still-needs-validation items, and no-longer-needs-rediscovery items.

Notes
- The existing `16 / 1 / 5 / 2` ledger is already syntactically clean; the issue is contract shape.
