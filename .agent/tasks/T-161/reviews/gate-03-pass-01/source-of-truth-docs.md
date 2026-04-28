Approval: APPROVE

No blocking source-of-truth doc issues found. The updated docs consistently make `state.json` lifecycle truth, `queue-index.json` advisory, `locks.write` the parallel ownership boundary, and `claim-next` the preferred parallel-safe claim surface while preserving direct patching only as a fallback with the same conflict rule.
