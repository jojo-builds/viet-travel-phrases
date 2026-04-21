Approval: APPROVE

Rationale: `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` now hard-checks `content-draft/viet/website-preview.json` against the live manifest on module count and `(moduleId, scenarioId)` pairs, and the two manifest copies are identical with matching SHA-256 hashes. That gives a deterministic source-proof seam without any generated JSON churn.
