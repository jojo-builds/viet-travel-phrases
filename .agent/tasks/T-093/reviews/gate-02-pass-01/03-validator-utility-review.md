Approval: APPROVE

Rationale: The Gate 1 blocker is fixed. `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` now reads `content-draft/viet/website-preview.json` directly and asserts both module count and exact `(moduleId, scenarioId)` parity against the live manifest; the audit log also shows the check passing with 7 matching modules and pairs.
