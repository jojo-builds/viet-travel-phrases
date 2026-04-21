# Gate 1 Pass 1 Review 03

## Verdict

The current repo truth does not make the surfaced Viet module split easy to validate without reading prose or inspecting HTML. The seven-module export is explicit; the on-hub versus off-hub split is not.

## Risks

Neither `site/data/phrase-previews/manifest.json` nor `site/public/data/phrase-previews/manifest.json` marks module placement, so reviewers have to infer scope from `docs/website/PHRASE_AUDIO_DELIVERY.md`. That is weaker than a manifest-backed contract and leaves the hub subset vulnerable to silent drift.

Approval: BLOCK
