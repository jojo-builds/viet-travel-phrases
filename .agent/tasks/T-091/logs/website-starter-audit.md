# Vietnam Website Starter Audit

Date: 2026-04-20
Task: T-091

## Summary

The current Vietnam website starter seam is honest against the committed export artifacts. No bounded route or manifest source edit was justified in this repo snapshot because the named `site/src/**` source files are absent and the static artifact already matches the export truth.

## Files reviewed

- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `site/scripts/phrase-module-loader.js`
- `site/scripts/trust-panel-loader.js`
- `site/data/trust-panels.json`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `site/data/phrase-previews/vietnam-arrival-basics.json`
- `site/data/phrase-previews/vietnam-transport-basics.json`
- `site/data/phrase-previews/vietnam-money-basics.json`
- `site/data/phrase-previews/vietnam-phone-basics.json`
- `content-draft/viet/website-preview.json`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`

## Findings

- The Vietnam hub is a static artifact at `site/countries/vietnam.html`, not the `site/src/routes/(marketing)/vietnamese/+page.svelte` source path named in the task spec.
- The hub loads phrase modules from `/data/phrase-previews/manifest.json` via `site/scripts/phrase-module-loader.js`.
- The hub loads trust copy from `/data/trust-panels.json` via `site/scripts/trust-panel-loader.js`.
- The hub explicitly surfaces 4 starter modules:
  - `vietnam-arrival-basics`
  - `vietnam-transport-basics`
  - `vietnam-money-basics`
  - `vietnam-phone-basics`
- The committed manifest exposes 7 approved Viet starter modules total, so the hub is showing a bounded subset rather than overclaiming full coverage.
- `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` are byte-identical in practice and both align with `content-draft/viet/website-preview.json` on the same 7 `moduleId`/`scenarioId` pairs.
- All 16 audio URLs referenced by the 4 surfaced hub modules resolve to existing files in both trees:
  - verified count: 16 of 16 present in `site/data/phrase-audio/vietnam/**`
  - verified count: 16 of 16 present in `site/public/data/phrase-audio/vietnam/**`
- The hub copy stays bounded to selected starter previews, module-level site audio where ready, and deeper backup in the app. No overclaim was found relative to the export data.
- The only stale durable doc truth found was the field name `articleReference`; the current module artifacts use `articleUrl`.

## Outcome

- No route edit made.
- No manifest or export JSON edit made.
- Updated `docs/website/PHRASE_AUDIO_DELIVERY.md` to match the current static-artifact seam and `articleUrl` field name.
