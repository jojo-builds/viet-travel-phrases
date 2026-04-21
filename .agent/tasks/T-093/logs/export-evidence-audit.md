# Export Evidence Audit

Date: 2026-04-20
Task: T-093
Session: task-queue-20-20260420T192112733Z

## Scope

Audit the Vietnam website starter export seam and improve deterministic repo proof without churning generated preview JSON unless a concrete defect appears.

## Commands run

1. `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
2. SHA-256 comparison of:
   - `site/data/phrase-previews/manifest.json`
   - `site/public/data/phrase-previews/manifest.json`
3. Direct parity check between:
   - `content-draft/viet/website-preview.json`
   - `site/data/phrase-previews/manifest.json`
4. Module payload audit across `site/data/phrase-previews/vietnam-*.json`

## Repo evidence

- Validator status: PASS
- Route pair parity: PASS
- Internal link integrity: PASS
- Preview JSON parity and phrase/audio schema checks: PASS
- Preview audio parity: PASS
- Manifest hash (`site/data`): `F3CEA267F1D55053423684D3B09BFEE3B71F34DCDB867C123B9DD08CC28AC811`
- Manifest hash (`site/public/data`): `F3CEA267F1D55053423684D3B09BFEE3B71F34DCDB867C123B9DD08CC28AC811`
- Manifest copy parity: `True`
- Manifest module count: `7`
- Viet source config module count: `7`
- Manifest/source `(moduleId, scenarioId)` parity: `True`

## Approved module/scenario pairs

- `vietnam-arrival-basics | airport-border-arrival`
- `vietnam-essential-basics | polite-basics`
- `vietnam-food-drink-basics | food-drink`
- `vietnam-money-basics | money-numbers-prices`
- `vietnam-phone-basics | phone-internet-power`
- `vietnam-transport-basics | transport`
- `vietnam-understanding-repair | understanding-repair`

## Module payload checks

- `vietnam-essential-basics`: `phraseCount` aligned across manifest/module/payload array; `familyCount=4`; `accessTier=starter`; `readyAudio=4`
- `vietnam-arrival-basics`: `phraseCount` aligned across manifest/module/payload array; `familyCount=4`; `accessTier=starter`; `readyAudio=4`
- `vietnam-transport-basics`: `phraseCount` aligned across manifest/module/payload array; `familyCount=4`; `accessTier=starter`; `readyAudio=4`
- `vietnam-money-basics`: `phraseCount` aligned across manifest/module/payload array; `familyCount=4`; `accessTier=starter`; `readyAudio=4`
- `vietnam-phone-basics`: `phraseCount` aligned across manifest/module/payload array; `familyCount=4`; `accessTier=starter`; `readyAudio=4`
- `vietnam-understanding-repair`: `phraseCount` aligned across manifest/module/payload array; `familyCount=4`; `accessTier=starter`; `readyAudio=4`
- `vietnam-food-drink-basics`: `phraseCount` aligned across manifest/module/payload array; `familyCount=4`; `accessTier=starter`; `readyAudio=4`

## Changes made

- Hardened `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` to assert direct parity between `content-draft/viet/website-preview.json` and the live manifest on module count and exact `(moduleId, scenarioId)` pairs.
- Updated `docs/website/PHRASE_AUDIO_DELIVERY.md` so the documented regression contract matches the hardened validator behavior.
- Left `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` unchanged because repo evidence showed no export defect.
