## Decision: APPROVE

## Evidence
- [`E:\AI\Viet-Travel-Phrases\.agent\tasks\T-015\logs\seam-audit.md`](E:\AI\Viet-Travel-Phrases\.agent\tasks\T-015\logs\seam-audit.md) reports the reviewed export seam is internally consistent with no bounded repair needed.
- [`E:\AI\Viet-Travel-Phrases\content-draft\viet\website-preview.json`](E:\AI\Viet-Travel-Phrases\content-draft\viet\website-preview.json) defines 7 preview modules, and both manifest surfaces expose the same 7 `moduleId` entries with matching `/data/phrase-previews/*.json` paths.
- [`E:\AI\Viet-Travel-Phrases\site\data\phrase-previews\manifest.json`](E:\AI\Viet-Travel-Phrases\site\data\phrase-previews\manifest.json) and [`E:\AI\Viet-Travel-Phrases\site\public\data\phrase-previews\manifest.json`](E:\AI\Viet-Travel-Phrases\site\public\data\phrase-previews\manifest.json) are mirrored, and both trees contain the same 8 files at matching byte sizes.
- Sampled payloads under [`E:\AI\Viet-Travel-Phrases\site\data\phrase-previews`](E:\AI\Viet-Travel-Phrases\site\data\phrase-previews) include the fields the loader reads in [`E:\AI\Viet-Travel-Phrases\site\scripts\phrase-module-loader.js`](E:\AI\Viet-Travel-Phrases\site\scripts\phrase-module-loader.js): `phrases`, `audioCoverage`, `trust`, `headline`, `summary`, `travelerStage`, `difficulty`, `formality`, `familyCount`, and per-phrase `audioUrl`/text fields.
- The audit explicitly checked the apparent Vietnamese mojibake as a PowerShell read artifact rather than an export seam defect, so there is no remaining evidence of a JSON encoding mismatch blocking the website seam.

## Risks
- Residual risk is limited to out-of-scope runtime concerns the audit did not verify: live browser fetch behavior and actual MP3 asset existence under `/data/phrase-audio/`.
- Those are downstream validation risks, not export seam blockers. I do not see a remaining seam-contract issue that should hold `T-015` finalization.

## Next step
- Finalize `T-015` from the seam-review side and let any remaining check move to runtime/audio validation rather than holding on export integrity.
