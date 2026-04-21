Approval: BLOCK

Findings
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` does not yet bind the declared relation-sample identity and size back to the source sample file.
- `site/data/phrase-previews/manifest.json` declares `sampleClusterCount: 29`, but the canonical doc block and validator do not yet pin that source boundary directly.

Rationale
- The export subset contract is strong, but the fail-together contract is still incomplete until the validator asserts both `relationSample.sampleId` and the source `29`-cluster boundary.
