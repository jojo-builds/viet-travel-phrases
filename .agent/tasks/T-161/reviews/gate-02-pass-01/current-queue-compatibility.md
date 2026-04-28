Approval: APPROVE

T-161 is active and leased in `.agent/tasks/T-161/state.json`; T-160 remains queued in `.agent/tasks/T-160/state.json` and listed as queued while T-161 is in_progress in `.agent/coordination/queue-index.json`. The claim path checks active write-lock conflicts only, not a global active-worker gate, and T-160's locks do not overlap T-161's locks. Dry-run evidence confirms T-160 remains claimable while T-161 is in_progress.
