Approval: BLOCK

Findings
- The current website preview seam is still just a 7-module starter export with no relation-safe fields or relation edges. `content-draft/viet/website-preview.json`, both manifest copies, and `docs/V2_CONTENT_MODEL.md` still describe phrase/audio module metadata only.
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` does not validate relation-safe export contracts, starter-boundary relation fields, or fail-together behavior for relation docs versus payloads.
- The task’s required outputs are not yet satisfied in the pre-edit state: there is no relation export packet log, no relation contract update in the website seam, and no relation fail-together enforcement.

Rationale
- The current truth only proves the older phrase/audio contract. Because the task explicitly requires a relation-safe website export seam and fail-together enforcement, the pre-edit state cannot be approved.
