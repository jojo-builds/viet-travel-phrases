# Gate 1 Pass 1 Review 01

## Verdict

The current Viet starter export contract is too implicit for the task goal. The repo cleanly proves the seven-module export surface, but it does not encode the exact four-module hub subset versus the three intentionally off-hub modules in machine-readable export metadata.

## Risks

`content-draft/viet/website-preview.json` and the two manifest copies can stay perfectly aligned on seven exported modules while the Vietnam hub subset still drifts silently. `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` currently validates export parity and playback scope, not the explicit surfaced split this task is meant to protect.

Approval: BLOCK
