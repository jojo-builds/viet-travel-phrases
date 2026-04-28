## Gate 2 Pass 1

- Role: `03-connected-phrase-navigation-review.md`
- Artifact reviewed: current T-144 implementation
- Reviewer: subagent `Godel`

Approval: BLOCK

Findings:
- Back navigation did not restore the previous page to a clean hero/top state, so returning from a linked answer page could land mid-scroll with the hero already collapsed.

Suggested adjustments:
- Reset the reopened page to its top/hero state on back, or restore per-page scroll positions intentionally.
- Keep the current visible split between `Swap hero` and `Open page`; that part already reads clearly.

