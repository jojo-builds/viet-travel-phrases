Approval: BLOCK

Rationale: `docs/website/PHRASE_AUDIO_DELIVERY.md:156-163` gives a usable manual audit recipe, but `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1:199-216` still only infers source truth by unioning `moduleId`s across every `content-draft/*/website-preview.json`. It does not directly prove the Viet source config against the manifest on the exact `(moduleId, scenarioId)` pairs that the task spec calls for, so the future-worker audit path is not fully deterministic from repo evidence alone.

Bounded hardening change: make the validator read `content-draft/viet/website-preview.json` explicitly and assert a 1:1 match with `site/data/phrase-previews/manifest.json` on module count plus `(moduleId, scenarioId)` pairs, while leaving the existing parity and audio checks unchanged.
