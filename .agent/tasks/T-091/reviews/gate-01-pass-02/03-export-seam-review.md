Reviewer: Codex
Role: export seam
Gate: 01
Pass: 02
Verdict: APPROVED

Findings: The committed JSON seam is internally consistent. `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` match, and `content-draft/viet/website-preview.json` aligns with the 7 approved module/scenario pairs. The only stale repo truth visible here is in `docs/website/PHRASE_AUDIO_DELIVERY.md`, which still names `articleReference` instead of the artifact's `articleUrl`.

Decision: Treating the committed JSON artifacts as the live export seam is contract-safe given the absent source TS file. A doc refresh is the only justified next step from these files; no code or export-JSON change is warranted.

Approval: APPROVE
