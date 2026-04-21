## Decision: APPROVE

## Evidence
- [`.agent/tasks/T-015/spec.md`](E:/AI/Viet-Travel-Phrases/.agent/tasks/T-015/spec.md) keeps the task tightly bounded to the website export seam and explicitly says to keep the website tied to current starter/default-first app truth.
- [`docs/V2_BASELINE.md`](E:/AI/Viet-Travel-Phrases/docs/V2_BASELINE.md) and [`docs/V2_CONTENT_MODEL.md`](E:/AI/Viet-Travel-Phrases/docs/V2_CONTENT_MODEL.md) both say website previews are curated from approved starter slices, not the full runtime or premium library.
- [`content-draft/viet/website-preview.json`](E:/AI/Viet-Travel-Phrases/content-draft/viet/website-preview.json) selects 7 Viet modules, each with 4 phrase IDs, and positions them as a deliberately smaller website preview.
- [`site/data/phrase-previews/manifest.json`](E:/AI/Viet-Travel-Phrases/site/data/phrase-previews/manifest.json) matches that 7-module shape, and the sampled payloads under [`site/data/phrase-previews`](E:/AI/Viet-Travel-Phrases/site/data/phrase-previews) show `accessTier: "starter"` throughout with app-boundary/trust copy intact.

## Risks
- The export seam has a plausible false-positive integrity signal if reviewed only through the terminal, because PowerShell can display mojibake even when the UTF-8 file content is correct. That needs to be called out explicitly so the task does not claim a nonexistent repair.
- A few selected phrases are cross-scenario by source ID (`airport-4` inside the money module), so the audit should verify the exported payload scenario fields stay consistent with the module contract rather than assuming source-ID prefixes are authoritative.

## Next step
- Proceed with the bounded seam audit/closeout, keeping the conclusion tied to starter-only export integrity and preserving the current Viet website-smaller-than-app boundary.
