Approval: BLOCK

Findings
- `content-draft/viet/relation-sample-v1.json` already defines starter-safe relation rails at the cluster level, including `possibleTravelerResponses`, `familyRelations`, and `youMayHearSignals` across 29 clusters.
- `content-draft/viet/website-preview.json`, `site/data/phrase-previews/manifest.json`, `site/data/phrase-previews/vietnam-transport-basics.json`, and `site/data/phrase-previews/vietnam-understanding-repair.json` still export phrase/audio/article metadata only; they do not project the relation-safe reply or next-step fields into the website seam.
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` validates preview parity, audio, and scope, but it does not cover relation-safe field export, so the current seam can still drift silently on the very contract T-124 is meant to harden.

Rationale
- The pre-edit state is honest about starter-only phrase/audio delivery, but it has not yet carried the bounded relation packet into the website manifest/modules. Approving now would overstate what the website currently exposes.
