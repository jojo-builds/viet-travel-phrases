# Gate 1 Pass 1 Review 03

## Verdict

BLOCK. The export seam is still starter-only and manifest-driven, but playback is still implicit for any page that mounts a phrase host, rather than being explicitly scoped to a declared phrase surface. That is the boundary risk this gate should stop on.

## Risks

- `site/scripts/phrase-module-loader.js:2-30` hydrates every `[data-phrase-module-id]` host on the document, with no per-surface allowlist or opt-in flag. That makes playback a generic behavior for any future host, not a clearly bounded phrase-page seam.
- `site/scripts/phrase-module-loader.js:92-158` renders `<audio controls>` and playback-speed UI for any module with `audioUrl`, then applies rate changes across all `.phrase-module audio` elements. That is still module-driven, but the behavior is globally active once the loader is present.
- `site/index.html:29-30,243-252`, `site/countries/vietnam.html:29,164-196`, and `site/blog/phrases-tourists-actually-need-in-vietnam.html:34,221-243` all load the same loader and mount phrase hosts. The current contract therefore reads as “any page with a host gets playback,” which is broader than an explicit phrase-page-only boundary.
- The docs say the next step is to wire on-demand playback “only on the phrase pages that actually need it” (`docs/website/PHRASE_AUDIO_DELIVERY.md:183`), but the implementation still depends on implicit host presence rather than an explicit surface declaration.

Approval: BLOCK
