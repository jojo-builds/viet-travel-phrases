# Phrase Audio Delivery

Last updated: 2026-04-21
Status: live export shape for Viet starter slices with repeatable regression guardrail

## Recommendation summary

Use a split model:

- phrase/module data = static structured exports committed with the website bundle
- website audio = approved ready clips copied into the site-owned static bundle under `/data/phrase-audio/`
- app audio = stays bundled in the app for now

## Current repo truth

The website preview export now runs through:

- source approval: `content-draft/viet/website-preview.json`
- export command: `npm --prefix app run export:website-previews`
- artifact verifier: `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- current Vietnam hub surface: `site/countries/vietnam.html`, hydrated by `site/scripts/phrase-module-loader.js` and `site/scripts/trust-panel-loader.js`
- output manifests:
  - `site/public/data/phrase-previews/manifest.json`
  - `site/data/phrase-previews/manifest.json`
- output audio:
  - `site/public/data/phrase-audio/vietnam/*.mp3`
  - `site/data/phrase-audio/vietnam/*.mp3`
- output modules:
  - `site/public/data/phrase-previews/vietnam-*.json`
  - `site/data/phrase-previews/vietnam-*.json`

The current live Viet export exposes 7 manifest-driven starter modules mirrored into both trees. These are starter-only, approved Viet slices. They are not the full app library. The current Vietnam hub surfaces 4 of those 7 modules directly on the country page and leaves the remaining starter modules on the phrase/article surfaces.

The manifest now carries a machine-readable `surfaceContract` block plus per-module `surfacePlacement` values so the approved 4-on-hub / 3-off-hub split can be validated directly from export metadata instead of prose alone.

The current hub subset and order are:

- `vietnam-arrival-basics`
- `vietnam-transport-basics`
- `vietnam-money-basics`
- `vietnam-phone-basics`

Those four stay on-hub because they cover the highest-stress first-day traveler moments. The remaining exported starter modules:

- `vietnam-essential-basics`
- `vietnam-understanding-repair`
- `vietnam-food-drink-basics`

still belong on the phrase/article surfaces and the app handoff, so the country hub stays conversion-focused instead of pretending to expose the whole starter layer.

The current playback scope is intentionally narrower than the export scope:

- embedded on-demand playback is opt-in via `data-phrase-audio-mode="playback"` on the Viet phrase/article surfaces that teach the starter blocks in context
- the current allowed playback surfaces are:
  - `site/blog/phrases-tourists-actually-need-in-vietnam.html`
  - `site/blog/vietnam-first-24-hours.html`
  - `site/blog/vietnam-grab-taxi-confusion.html`
  - `site/blog/vietnam-sim-esim-offline-setup.html`
- the matching routed `index.html` copies must stay in parity with those flat routes
- the home page and Vietnam hub may still show export-driven module readiness, but they stay preview-first and do not expose embedded playback controls

## Manifest contract

The manifest is the website-safe entrypoint, not the app runtime pack. The live manifest currently carries:

- `schemaVersion` with a current floor of `3`
- `exportType` = `website-phrase-audio-manifest`
- `exportedAt`
- `generatedFor`
- `moduleCount`
- `surfaceContract`
- `modules[]`

Each manifest module entry must include:

- `moduleId`
- `path`
- `destinationSlug`
- `scenarioId`
- `scenarioName`
- `headline`
- `phraseCount`
- `familyCount`
- `surfacePlacement`
- `articleUrl`

The live `surfaceContract` currently declares:

- `version = 1`
- `destinationSlug = "vietnam"`
- `starterModuleCount = 7`
- `hubModuleCount = 4`
- `offHubModuleCount = 3`
- `approvedHubModuleOrder = ["vietnam-arrival-basics", "vietnam-transport-basics", "vietnam-money-basics", "vietnam-phone-basics"]`
- `approvedOffHubModuleIds = ["vietnam-essential-basics", "vietnam-understanding-repair", "vietnam-food-drink-basics"]`

### Canonical Vietnam surface contract

The validator reads this block back and compares it against the live manifest contract.

<!-- canonical-vietnam-surface-contract:start -->
```json
{
  "version": 1,
  "destinationSlug": "vietnam",
  "moduleCount": 7,
  "hubModuleCount": 4,
  "offHubModuleCount": 3,
  "approvedHubModuleOrder": [
    "vietnam-arrival-basics",
    "vietnam-transport-basics",
    "vietnam-money-basics",
    "vietnam-phone-basics"
  ],
  "approvedOffHubModuleIds": [
    "vietnam-essential-basics",
    "vietnam-understanding-repair",
    "vietnam-food-drink-basics"
  ]
}
```
<!-- canonical-vietnam-surface-contract:end -->

Per-module `surfacePlacement` must stay:

- `country-hub` for the 4 approved Vietnam hub modules
- `off-hub` for the 3 exported starter modules that stay on phrase/article surfaces and the app handoff

## Module contract

Each website phrase module currently carries:

- `schemaVersion`
- `exportType`
- `exportedAt`
- `moduleId`
- `moduleSlug`
- `destinationSlug`
- `destinationName`
- `country`
- `language`
- `languageCode`
- `variant`
- `scenarioId`
- `scenarioSlug`
- `scenarioName`
- `editorialStatus`
- `headline`
- `summary`
- `travelerStage`
- `difficulty`
- `formality`
- `phraseCount`
- `familyCount`
- `cta`
- `articleUrl`
- `trust`
- `audioStatus`
- `websiteAudioStatus`
- `audioDelivery`
- `audioCoverage`
- `audioDurationMs`
- `transcriptChecked`
- `appStatus`
- `phrases[]`

Each phrase item currently carries:

- `id`
- `phraseId`
- `phraseSlug`
- `moduleId`
- `destinationSlug`
- `country`
- `language`
- `languageCode`
- `variant`
- `scenarioId`
- `scenarioSlug`
- `scenarioName`
- `familyId`
- `familySlug`
- `familyTitle`
- `familySummary`
- `accessTier`
- `variantRole`
- `variantLabel`
- `targetText`
- `canonicalTargetText`
- `pronunciation`
- `englishText`
- `sourceText`
- `context`
- `audioStatus`
- `audioDelivery`
- `audioReference`
- `audioUrl`
- `audioDurationMs`
- `transcriptChecked`
- `websiteReferences`

## Guardrails

- Keep website exports starter-only.
- Keep website exports default-first.
- Do not export premium-only intent families to the site.
- Do not treat generated website JSON as app runtime source.
- Keep the direct-serve `/data/phrase-previews/*` path valid inside the staged `site/` bundle.
- Keep ready-phrase audio URLs inside `/data/phrase-audio/*` so staging/live can serve the same exported clips they validate.
- Keep embedded playback opt-in and limited to the approved Viet phrase/article surfaces instead of every module host on the site.
- Do not claim website audio is live until the exported site-owned clips are actually present and reachable on the deployed surface.

## Regression check

Use this when the pack, the website preview config, or the export output changes:

1. Regenerate the website-safe preview exports with `npm --prefix app run export:website-previews`.
2. Run `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`.
3. Treat any validator failure as real seam drift or staleness until proven otherwise; do not hand-edit the generated JSON to make the check pass.

The validator currently covers:

- route-pair parity between flat HTML pages and routed `index.html` copies
- internal site link integrity
- parity between `site/data/phrase-previews/**` and `site/public/data/phrase-previews/**`
- manifest schema and required property checks
- direct Vietnam source-config parity against `content-draft/viet/website-preview.json`, including module count plus approved `(moduleId, scenarioId)` pairs
- explicit Vietnam `surfaceContract` truth, including the 4-module hub order and the 3 exported off-hub starter modules
- per-module `surfacePlacement` truth, so each manifest entry declares whether it belongs on the country hub or remains off-hub
- article parity across manifest entries, module payload `articleReference.secondaryUrl`, module CTA links, and phrase `websiteReferences.articleUrl`
- phrase/audio field integrity, including site-owned `/data/phrase-audio/*` reachability
- starter-boundary enforcement, so exported website phrases stay `accessTier=starter`
- phrase-page playback scope, so only the approved Viet phrase/article surfaces can opt into embedded playback
- parity between `site/data/phrase-audio/**` and `site/public/data/phrase-audio/**`

For a quick starter-export seam audit before reopening any repair work, also confirm:

- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` still passes, because it now directly asserts `content-draft/viet/website-preview.json` parity with `site/data/phrase-previews/manifest.json` on module count and approved `(moduleId, scenarioId)` pairs, then separately enforces the approved `surfaceContract` and per-module `surfacePlacement` truth.
- matching files under `site/data/phrase-previews/**` and `site/public/data/phrase-previews/**` are still pair-complete and byte-identical.
- each exported module payload still matches its manifest entry on `phraseCount`, `familyCount`, and `articleUrl`.
- exported phrase rows in the website preview seam still stay `accessTier=starter`; treat any premium phrase leak as a real boundary regression.
- any phrase exported as audio-ready still carries a site-served `audioUrl`; do not describe the module as ready if the site clip is missing.
- if one of these checks fails, rerun the export/validator path and fix source or generator drift instead of hand-editing generated preview JSON.

## Exact next website step

Keep the export step lightweight, then preserve the current phrase-page-only playback opt-in instead of letting embedded playback drift onto every module host.
