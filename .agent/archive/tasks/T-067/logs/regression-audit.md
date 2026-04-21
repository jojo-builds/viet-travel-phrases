# T-067 Regression Audit

Date: 2026-04-20
Task: `T-067`
Conclusion: the current Viet website starter export seam is still internally consistent; no export JSON repair was warranted, so this task hardened re-verification with a tighter starter-export checklist in `docs/website/PHRASE_AUDIO_DELIVERY.md`.

## Inputs reviewed
- `content-draft/viet/website-preview.json`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- all exported payloads under `site/data/phrase-previews/`
- all exported payloads under `site/public/data/phrase-previews/`
- `site/scripts/phrase-module-loader.js`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `.agent/tasks/T-015/result.md`

## Verified facts
- `content-draft/viet/website-preview.json` and `site/data/phrase-previews/manifest.json` match on `moduleId` and `scenarioId` for all 7 approved Viet starter modules.
- `site/data/phrase-previews/**` and `site/public/data/phrase-previews/**` contain the same 8 files, and each matched pair is byte-identical.
- For every exported module, manifest `phraseCount` matches payload `phrases.length`.
- For every exported module, manifest `familyCount` matches the payload's unique `familyId` count.
- Every exported phrase row in the website preview seam currently stays `accessTier=starter`.
- Every exported phrase row marked audio-ready currently carries a site-served `audioUrl`.
- The loader contract still reads the manifest/module seam through `moduleId`, `path`, payload `phrases`, `audioCoverage`, and `trust`.

## Guardrail added
- Tightened `docs/website/PHRASE_AUDIO_DELIVERY.md` with a starter-export quick audit checklist for:
  - source-to-manifest `moduleId` and `scenarioId` agreement
  - byte parity between `site/data/phrase-previews/**` and `site/public/data/phrase-previews/**`
  - manifest-to-payload `phraseCount` and `familyCount` agreement
  - starter-only boundary enforcement through `accessTier=starter`
  - ready-audio honesty through required site `audioUrl`
  - explicit instruction to rerun export/validator flow instead of hand-editing generated JSON

## Non-goals / not verified
- browser runtime fetch behavior
- deployed staging/live reachability
- phrase audio asset existence outside the exported ready URLs
- article-page rendering or CTA behavior outside the manifest/payload seam
- app runtime pack behavior outside the website export seam

## Working-output note
- No export content files were changed because the reviewed seam was already clean within task scope.
