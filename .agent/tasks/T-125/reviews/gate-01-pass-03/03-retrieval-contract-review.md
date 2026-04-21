Approval: BLOCK

Findings
- The compact audit and the exact per-row outcome layer are still missing as explicit retrievable surfaces.

Required fixes before Gate 1 pass 3 can approve
- Add an explicit row-level advance/defer/prep-only split for rows `18-22`.
- Add a distinct audit surface for immediate trust, still-needs-validation, and no-longer-needs-rediscovery guidance.

Notes
- The lane remaining prep-only is not the blocker.
