NOT APPROVED

- The hardened helper still accepted missing `automation.taskClass` / `automation.proofTask` through implicit defaults, so the live claim path could still claim tasks whose meaningful/proof classification was inferred instead of declared.
- That weakened the explicit state contract for meaningful queue work.
