NOT APPROVED

- `T-034` and `T-035` remained in the active queued backlog without explicit `automation.taskClass: "meaningful"` and `automation.proofTask: false`.
- The rebuilt index still counted them as live queued work while the hardened helper would reject them as contract-invalid, leaving queue-index truth misaligned with claim behavior.
