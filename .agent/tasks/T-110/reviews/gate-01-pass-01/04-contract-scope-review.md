# Gate 1 Pass 1 Review 04

## Verdict

BLOCK. The implementation is still broader than the stated contract if the intent is “on-demand playback only on the phrase pages that actually need it.”

## Risks

- `site/scripts/phrase-module-loader.js:98` and `site/scripts/phrase-module-loader.js:145` render playback UI whenever a loaded module has `audioUrl`; there is no surface allowlist in the loader itself.
- `site/index.html:243`, `site/countries/vietnam.html:164`, `site/blog/phrases-tourists-actually-need-in-vietnam.html:221`, `site/blog/vietnam-first-24-hours.html:141`, `site/blog/vietnam-grab-taxi-confusion.html:141`, and `site/blog/vietnam-sim-esim-offline-setup.html:141` all use the same loader-driven pattern. That means on-demand playback can surface outside a narrow phrase-page-only contract.
- The current validator in `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` checks parity, links, and audio integrity, but not which HTML surfaces are allowed to expose playback. If the contract is meant to stay bounded, the validator needs an explicit surface-scope assertion.

Approval: BLOCK
