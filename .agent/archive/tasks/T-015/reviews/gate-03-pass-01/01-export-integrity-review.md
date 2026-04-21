## Decision: APPROVE

## Evidence
- [`result.md`](E:/AI/Viet-Travel-Phrases/.agent/tasks/T-015/result.md) and [`logs/seam-audit.md`](E:/AI/Viet-Travel-Phrases/.agent/tasks/T-015/logs/seam-audit.md) stay scoped to the export seam and explicitly treat broader runtime/audio checks as out of scope.
- Both manifest surfaces at [`site/data/phrase-previews/manifest.json`](E:/AI/Viet-Travel-Phrases/site/data/phrase-previews/manifest.json) and [`site/public/data/phrase-previews/manifest.json`](E:/AI/Viet-Travel-Phrases/site/public/data/phrase-previews/manifest.json) expose the same 7 modules, and both trees contain the same 8 files with matching sizes.
- [`content-draft/viet/website-preview.json`](E:/AI/Viet-Travel-Phrases/content-draft/viet/website-preview.json) defines the same 7 module IDs used by the manifests.
- The payload contract matches [`site/scripts/phrase-module-loader.js`](E:/AI/Viet-Travel-Phrases/site/scripts/phrase-module-loader.js): manifest entries provide `moduleId` and `path`, and payloads provide the fields the loader reads (`phrases`, `audioCoverage`, `trust`, `headline`, `summary`, `travelerStage`, `difficulty`, `formality`, `familyCount`).
- Direct UTF-8 byte decoding of [`vietnam-essential-basics.json`](E:/AI/Viet-Travel-Phrases/site/data/phrase-previews/vietnam-essential-basics.json) shows correct stored Vietnamese text (`Xin chào`), while PowerShell JSON/console output re-emits mojibake. That means the encoding concern is a tooling/display artifact, not an export-seam defect.

## Risks
- This does not prove browser fetch/render behavior, article page correctness, or MP3 asset existence under `/data/phrase-audio/`.
- PowerShell remains a bad source of truth for judging these UTF-8 strings after parsing; future reviewers should rely on byte-level or browser-level checks instead.

## Next step
- Complete Gate 3 with the conclusion phrased narrowly: the reviewed Viet website starter export seam is internally consistent, no bounded repair was required, and any remaining concerns belong to a separate runtime/audio validation task.
