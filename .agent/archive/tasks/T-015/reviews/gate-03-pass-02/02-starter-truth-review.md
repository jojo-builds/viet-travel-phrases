## Decision: APPROVE

## Evidence
- [`E:\AI\Viet-Travel-Phrases\docs\PRIORITIES.md`](</E:/AI/Viet-Travel-Phrases/docs/PRIORITIES.md>), [`E:\AI\Viet-Travel-Phrases\docs\V2_BASELINE.md`](</E:/AI/Viet-Travel-Phrases/docs/V2_BASELINE.md>), and [`E:\AI\Viet-Travel-Phrases\docs\V2_CONTENT_MODEL.md`](</E:/AI/Viet-Travel-Phrases/docs/V2_CONTENT_MODEL.md>) all keep the website seam explicitly starter/default-first and smaller than the app, not a full-library surface.
- [`E:\AI\Viet-Travel-Phrases\content-draft\viet\website-preview.json`](</E:/AI/Viet-Travel-Phrases/content-draft/viet/website-preview.json>) defines 7 Viet preview modules, and [`E:\AI\Viet-Travel-Phrases\site\data\phrase-previews\manifest.json`](</E:/AI/Viet-Travel-Phrases/site/data/phrase-previews/manifest.json>) exposes the same 7 modules with matching starter-framed trust copy and article routing.
- Sampled payloads under [`E:\AI\Viet-Travel-Phrases\site\data\phrase-previews\`](</E:/AI/Viet-Travel-Phrases/site/data/phrase-previews/>) stay narrowly starter-scoped: 4 phrases, 4 families, and `accessTier: "starter"` throughout the reviewed modules.
- [`E:\AI\Viet-Travel-Phrases\.agent\tasks\T-015\result.md`](</E:/AI/Viet-Travel-Phrases/.agent/tasks/T-015/result.md>) and [`E:\AI\Viet-Travel-Phrases\.agent\tasks\T-015\logs\seam-audit.md`](</E:/AI/Viet-Travel-Phrases/.agent/tasks/T-015/logs/seam-audit.md>) keep the claim seam-local and explicitly leave browser fetch, MP3 reachability, and broader runtime/article behavior out of scope.

## Risks
- This is still not runtime proof; it only supports the static export seam.
- PowerShell mojibake remains a display hazard during manual reads, even though the task evidence treats it as non-defective on-disk data.

## Next step
- Complete the final status sync narrowly: mark `T-015` done only as a Viet website starter export seam audit with no repair required, and keep any runtime/audio follow-up as a separate task.
