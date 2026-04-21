Approval: BLOCK

Findings
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` never asserts `site/data/phrase-previews/manifest.json` `relationExport.sampleClusterCount: 29` against `content-draft/viet/relation-sample-v1.json` `clusterCount: 29`.
- `docs/PHRASE_RELATIONSHIP_MODEL.md` omits that source-boundary count from the canonical website relation export block, so the 29-cluster sample can drift without tripping the validator.

Rationale
The current export/doc/manifest state is coherent for the covered 14-cluster starter subset, but the task explicitly requires fail-together enforcement with the source relation sample. Until the validator binds the 29-cluster source boundary as well as the downstream covered-cluster counts, this gate is not contract-tight enough to approve.
