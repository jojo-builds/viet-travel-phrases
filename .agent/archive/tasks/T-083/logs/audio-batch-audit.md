# Audio Batch Audit

Audit date: 2026-04-20

## Summary

T-083 audited the historical Viet `autonomous-500` lane against current live source and audio seam truth.

## Evidence

- `content-draft/viet/autonomous-500/generated-rows.csv` contains `342` approved rows and all `342` still read as `audio_status=planned`.
- All `342` historical rows overlap the current live `content-draft/viet/phrase-source.csv`.
- All `342` historical rows have matching MP3 assets under `app/assets/audio/`.
- All `342` historical rows have matching entries in `app/assets/audio/manifest.json`.
- All `342` historical rows have matching imports in `app/assets/audio/registry.ts`.
- The controlled allowlist note under `content-draft/viet/audio-review/FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md` records `24` high-value repair, money, transport, and hotel outcomes.

## Interpretation

- The repo already contains app-usable audio coverage for the audited historical row set.
- No missing in-scope audio mapping or live pack promotion gap was found in `app/assets/audio/**` or `app/family/packs/**`.
- The stale `planned` state that motivated the task lives in `content-draft/viet/autonomous-500/generated-rows.csv`, which is outside T-083's allowed writes.
- Existing continuity posture should remain unchanged and cautious.

## Recommended disposition

- Treat T-083 as blocked on scope if the task requires correcting the stale historical `planned` flags directly.
- Use this audit as the evidence packet for any follow-up task that widens writes to `content-draft/viet/autonomous-500/**`.
