# T-026 Regression Audit

Date: 2026-04-19
Task: Vietnam website starter export regression guardrail audit

## Scope

- `content-draft/viet/website-preview.json`
- `site/data/phrase-previews/**`
- `site/public/data/phrase-previews/**`
- `site/data/phrase-audio/**`
- `site/public/data/phrase-audio/**`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`

## Why this task exists

T-015 already established that the current Viet website starter export seam did not need repair. This task stayed narrower: confirm the seam is still healthy and leave behind the regression recipe that future export or pack changes should use.

## Evidence checked in this run

- `content-draft/viet/website-preview.json` still defines 7 Viet starter preview modules.
- `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` still mirror the same 7-module export.
- The manifest contract still matches the documented live schemaVersion 3 phrase/audio export seam.
- `docs/website/PHRASE_AUDIO_DELIVERY.md` already documents the current export command, validator command, manifest/module contract, and guardrails.
- No additional export JSON or docs repair was justified inside the allowed write surface.

## Validator run

Command:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1
```

Observed result:

- Route-pair parity passed.
- Internal link integrity passed.
- Preview JSON parity and phrase/audio schema checks passed.
- Preview audio parity passed.
- Overall website artifact validation passed for `E:\AI\SpeakLocal-App-Family\site`.

## Decision

No export JSON or website-export doc changes were warranted in this recovery run. The bounded guardrail already exists and the seam currently validates clean.

## Current guardrail recipe

1. Regenerate with `npm --prefix app run export:website-previews` when the pack or website preview config changes.
2. Run `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`.
3. Treat validator failures as seam drift or stale export truth until proven otherwise.

## Constraint encountered

The task contract requires 3 review gates with exactly 4 Codex subagent review artifacts per gate before `done`. That review path was not available in this subagent runtime, so the task cannot be honestly completed as `done` from this run even though the bounded seam audit passed.
