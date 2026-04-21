## Decision: APPROVE

## Evidence
- `docs/V2_BASELINE.md` and `docs/V2_CONTENT_MODEL.md` both define the website seam as a curated starter-only export from the live Viet pack, not a full phrase-library surface.
- `content-draft/viet/website-preview.json` defines 7 preview modules, and `site/data/phrase-previews/manifest.json` exposes the same 7 modules with matching `moduleId`, `scenarioId`, editorial labels, and article routing.
- Direct payload checks on `site/data/phrase-previews/*.json` show each module has 4 phrases, 4 unique families, `nonStarterCount = 0`, and `scenarioMismatchCount = 0`.
- The seam-audit artifact at [seam-audit.md](/E:/AI/Viet-Travel-Phrases/.agent/tasks/T-015/logs/seam-audit.md) is consistent with those spot checks: starter-only exports, scenario-aligned payloads, and no evidence of website/app boundary drift.

## Risks
- I did not verify live browser/runtime fetch behavior, audio asset existence, or front-end rendering.
- Raw PowerShell reads still display mojibake-like text, so encoding presentation remains a residual validation risk even though the audit states UTF-8 parsing is clean on disk.

## Next step
- Advance `T-015` past Gate 2 pass 02 and keep any follow-up focused on runtime/render validation rather than starter-truth repair.
