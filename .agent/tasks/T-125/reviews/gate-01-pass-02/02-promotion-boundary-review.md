Approval: BLOCK

Findings
- The proposed selective promote-now split is not yet supported by the current contract surfaces because they still describe all five direct-pickup rows as one review-bound pickup lane.

Required fixes before Gate 1 pass 2 can approve
- Preserve the five-row direct-pickup contract and layer per-row readiness on top of it instead of replacing the cluster boundary.
- If a subset advances now, make the contract files say that explicitly while keeping the lane prep-only.

Notes
- The refusal boundary and the later-only hold boundary are already consistent.
