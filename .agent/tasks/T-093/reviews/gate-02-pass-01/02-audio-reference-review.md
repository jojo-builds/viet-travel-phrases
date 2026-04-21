Approval: APPROVE

Rationale: The seam still claims only what the repo can prove: the docs describe a starter-only site export, and the validator now checks direct parity against `content-draft/viet/website-preview.json`, manifest/public copy equality, and that every `audioStatus=ready` phrase resolves to a real `/data/phrase-audio/*` asset. `site/scripts/phrase-module-loader.js` remains a thin consumer of that exported truth, so the proof path is preserved without introducing a new unverified audio claim.
