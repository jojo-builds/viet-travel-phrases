# T-015 Seam Audit Evidence

Date: 2026-04-18
Task: `T-015`
Conclusion: current Viet website starter export seam is internally consistent; no bounded content repair was required in the reviewed export surfaces.

## Inputs reviewed
- `content-draft/viet/website-preview.json`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- all exported payloads under `site/data/phrase-previews/`
- all exported payloads under `site/public/data/phrase-previews/`
- `site/scripts/phrase-module-loader.js`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/V2_CONTENT_MODEL.md`

## Verified facts
- `website-preview.json` defines 7 Viet starter preview modules.
- Both manifest surfaces expose the same 7 `moduleId` entries.
- `site/data/phrase-previews/**` and `site/public/data/phrase-previews/**` contain the same 8 files.
- Matching files across `site/data` and `site/public` are byte-identical by SHA-256.
- Every manifest `path` resolves to a real payload file.
- Every payload parses as JSON.
- For every module, manifest and payload agree on:
  - `moduleId`
  - `scenarioId`
  - `headline`
  - `summary`
  - `travelerStage`
  - `difficulty`
  - `formality`
  - `phraseCount`
  - `familyCount`
- Payload `phrases.length` matches declared `phraseCount` for all 7 modules.
- Payload unique `familyId` count matches declared `familyCount` for all 7 modules.
- Exported payload fields required by `site/scripts/phrase-module-loader.js` are present.
- The apparent mojibake seen in one PowerShell read was not an export defect:
  - direct UTF-8 JSON parsing preserved Vietnamese text correctly
  - `Select-String` confirmed on-disk strings such as `Xin chào`, `Cảm ơn`, `Không, cảm ơn`, and `Xin lỗi`
- Cross-scenario-looking source IDs do not break the module contract:
  - exported phrase `scenarioId` values still match their containing payload `scenarioId`

## Non-goals / not verified
- downstream MP3 asset existence under `/data/phrase-audio/`
- live browser fetch/runtime execution
- linked article page correctness beyond manifest URL strings
- broader website or app runtime behavior outside the export seam

## Working-output note
- No export file changes were made because the reviewed seam was already clean within task scope.
