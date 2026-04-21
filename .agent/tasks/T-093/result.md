# T-093 Result

Status: done
Task: Desktop Codex automation pilot, Vietnam website starter export evidence ledger and validator hardening
Session: task-queue-20-20260420T192112733Z

## Summary

Hardened the website artifact validator so the Vietnam starter export is now checked directly against `content-draft/viet/website-preview.json` on module count and exact `(moduleId, scenarioId)` pairs. Updated the website delivery doc to match that stronger proof contract and wrote a task-local audit ledger with the evidence from this run.

## What changed

- Updated `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` to read `content-draft/viet/website-preview.json` explicitly and fail if the live manifest drifts on module count or approved `(moduleId, scenarioId)` pairs.
- Updated `docs/website/PHRASE_AUDIO_DELIVERY.md` so the documented regression check matches the hardened validator behavior.
- Added `.agent/tasks/T-093/logs/export-evidence-audit.md` with manifest hashes, config parity, module payload checks, and validator results from this run.
- Left `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` unchanged because repo evidence showed no export defect.

## Verification

- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` passed after the validator hardening change.
- `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` remain byte-identical with SHA-256 `F3CEA267F1D55053423684D3B09BFEE3B71F34DCDB867C123B9DD08CC28AC811`.
- `content-draft/viet/website-preview.json` and the live manifest now have verified parity on all 7 approved `(moduleId, scenarioId)` pairs.
- All 7 exported Viet module payloads still show aligned phrase counts, `familyCount=4`, `accessTier=starter`, and 4 ready site-audio phrases each.

## Review status

- Gate 1: pass 1 identified the direct Viet parity gap; fix applied in the main working pass
- Gate 2: pass 1 unanimous APPROVE
- Gate 3: pass 1 blocked on pre-finalization status interpretation; pass 2 unanimous APPROVE for immediate finalization

## Process feedback

- SUGGESTION: keep future export-seam tasks anchored to one source config at a time when the manifest is destination-specific; cross-variant unions are weaker evidence than direct source/manifest parity.
