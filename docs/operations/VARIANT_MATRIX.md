# Variant Matrix

Last updated: 2026-04-16
Authority lane: live app operational truth

## Current matrix

| Variant | Operational role | Runtime content status | Export/build status | Release status | Audio status | Authority note |
|---|---|---|---|---|---|---|
| `viet` | live shipping app | live 900-family v2 pack with 18 categories and `150 starter / 750 premium / 900 total` visible-entry depth | validated locally from canonical path; fresh native preview build still pending for the current `2026-04-16` pack | published / App Store accepted | `919` approved rows ready and `0` planned; the app seam now maps all 919 current-pack clips, while `problems-5.mp3` and `problems-7.mp3` remain as ignored legacy extras on disk; sampled QA plus the `2026-04-16` controlled benchmark support current-use continuity with caution, not a same-speaker-perfect pass | repo now includes real iOS one-time purchase / restore plumbing, site-static website preview audio on staging, a live 900-family pack, complete app-side Viet audio artifacts, and a repo-side situation-first pre-build UI pass, but App Store Connect and current-pack device proof are still pending |
| `tagalog` | second-app candidate | older thin 10-scenario / 70-phrase pack on the shared schema/builder path | validated locally from canonical path | not released | `70` bundled rows ready and `0` planned | inherits the shared premium plumbing and `$4.99` pricing surface automatically, but still needs a real v2 content pass and later variant-specific store proof |

## Operational takeaway

- Viet now proves the real v2 content model, the website-preview export path, the repo-side StoreKit seam, and a live 900-family premium boundary in source and runtime truth.
- Viet also now has a repo-side situation-first home/premium/search posture for the next preview-build test, without changing the underlying runtime schema or premium seam.
- Viet's sampled audio QA plus the controlled continuity benchmark now support a proceed-with-conditions stance for the current mixed lane, not a clean same-speaker pass against the older bundled audio.
- Tagalog inherits the schema, builder, export tooling, and premium plumbing automatically, but not the authored Viet content or Viet App Store Connect setup.
- Shared search device-proof debt is still unresolved for both variants.
