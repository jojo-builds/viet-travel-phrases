Approval: APPROVE

**Decision:** APPROVE

**Evidence**
- The scoped repo truth already frames this as a website-export guardrail task, not an export-data repair: `docs/website/PHRASE_AUDIO_DELIVERY.md` keeps website exports starter-only and defines a manual regression check.
- `content-draft/viet/website-preview.json` and `site/data/phrase-previews/manifest.json` match on `moduleId` and `scenarioId` for all 7 modules.
- `site/data/phrase-previews/*` and `site/public/data/phrase-previews/*` are pair-complete and byte-identical for 8 files.
- Each manifest module's `phraseCount` and `familyCount` matches its payload, all exported phrases stay `accessTier=starter`, and every ready phrase has an `audioUrl`.
- The task state requires `.agent/tasks/T-067/logs/regression-audit.md`, so a task-local audit log is part of the contract rather than extra churn.

**Risks**
- This remains a procedural guardrail, not a generator change, so future drift still depends on rerunning the documented checks.
- The checklist must stay aligned with the website-export seam rather than implying broader runtime or deployment proof.

**Next step**
- Proceed with the scoped no-churn change: tighten the starter-export manual regression checklist in `docs/website/PHRASE_AUDIO_DELIVERY.md` and add `.agent/tasks/T-067/logs/regression-audit.md`, with no export JSON edits.
