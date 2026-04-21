Approval: BLOCK

Findings
- `site/data/phrase-previews/manifest.json`, `site/data/phrase-previews/vietnam-money-basics.json`, and `site/data/phrase-previews/vietnam-phone-basics.json` are still plain starter phrase/audio exports. They do not carry explicit bounded relation-packet fields such as `familyRelations`, `possibleTravelerResponses`, `youMayHearSignals`, or a relation-sidecar pointer.
- `content-draft/viet/relation-sample-v1.json` already carries the bounded 29-cluster relation handoff, but that truth is not reflected in the website export payloads.
- The current public export does not leak premium/full-library truth, but it also does not yet satisfy the task’s relation-safe starter boundary.

Rationale
- The website seam is still honest about starter-only scope, but the required bounded relation packet is missing. The risk is omission rather than overexposure, so the pre-edit state cannot advance.
