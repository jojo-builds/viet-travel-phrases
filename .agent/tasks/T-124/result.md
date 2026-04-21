# Result: T-124

## Status
- done

## Truth changed
- live

## Changed files
- `docs/PHRASE_RELATIONSHIP_MODEL.md` - added `sampleClusterCount: 29` to the canonical Viet website relation export block and made the source-boundary contract explicit in prose.
- `docs/V2_CONTENT_MODEL.md` - aligned the website relation-export description with the source sample identity plus the current `29`-cluster sidecar boundary.
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` - hardened relation-export validation so manifest, canonical doc block, and `content-draft/viet/relation-sample-v1.json` fail together on `sampleId`, `sampleClusterCount`, and the source cluster-array count.
- `.agent/tasks/T-124/logs/viet-relation-export-packet.md` - captured the reclaim scope, validation evidence, and residual risk.
- `.agent/tasks/T-124/reviews/gate-1/pass-2/*.md` - recorded the non-unanimous Gate 1 pass that forced the missing source-boundary fix.
- `.agent/tasks/T-124/reviews/gate-2/pass-2/*.md` - recorded unanimous approval after the contract-hardening pass.
- `.agent/tasks/T-124/reviews/gate-3/pass-1/*.md` - recorded unanimous final approval on the full artifact set before closure.

## Validation
- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` passed.
- Both manifest copies still parse as JSON.
- All 7 touched Viet module payloads still parse as JSON.
- Gate 1 review pass 2 with 4 reviewers: not unanimous; contract-scope blocked on the missing source-boundary binding.
- Gate 2 review pass 2 with 4 reviewers: unanimous `Approval: APPROVE`.
- Gate 3 review pass 1 with 4 reviewers: unanimous `Approval: APPROVE`.

## Notes
- This reclaim did not widen the public relation subset. The live website seam remains the same bounded `14`-cluster / `6`-module starter-safe packet.
- The substantive fix in this run is fail-together enforcement: the exported manifest can no longer claim `viet-relation-sample-v1` or `29` source clusters unless the source sidecar, canonical doc block, and validator agree.
- The repo had unrelated pre-existing dirty changes in forbidden scopes; this task stayed within the allowed write scope and did not need to modify those areas.

## Blockers
- none

## Reviews
- `.agent/tasks/T-124/reviews/gate-1/pass-2/*.md`
- `.agent/tasks/T-124/reviews/gate-2/pass-2/*.md`
- `.agent/tasks/T-124/reviews/gate-3/pass-1/*.md`

## Process feedback
- BUG: meaningful reclaim tasks can leave partially good work behind; Gate 1 needs to review the true current state, not assume the original pre-edit defect is still the one that matters.
