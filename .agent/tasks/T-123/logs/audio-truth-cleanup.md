# T-123 Audio Truth Cleanup Log

## Summary

- Reframed the Viet historical `autonomous-500` lane as reconciled historical residue instead of a missing-audio follow-up batch.
- Updated the three audio-review docs to align on the live seam truth: `919` approved ready rows, `919` manifest entries, `919` registry entries, `921` physical MP3s, and `2` unmapped orphan MP3s (`problems-5.mp3`, `problems-7.mp3`).
- Rewrote all `342` rows in `content-draft/viet/autonomous-500/generated-rows.csv` so the historical lane keeps the legacy `audio_status=planned` token for compatibility while the `notes` field now states that the live Viet seam already covers each row.

## Verification

- `content-draft/viet/autonomous-500/generated-rows.csv` parses successfully with `342` rows.
- Historical-lane counts after cleanup:
  - `342` rows still carry `audio_status=planned`
  - `0` rows still say `not live yet promoted live via autonomous-500`
  - `0` rows still start with `autonomous-500 from cleanup:`
  - `342` rows now include `historical source-lane record`
  - `342` rows now include `current live Viet seam already covers this row`
- Live-seam reconciliation checks:
  - `919` approved ready rows in `content-draft/viet/phrase-source.csv`
  - `919` manifest entries in `app/assets/audio/manifest.json`
  - `919` registry entries in `app/assets/audio/registry.ts`
  - `921` physical MP3 files in `app/assets/audio`
  - orphan MP3s remain limited to `problems-5` and `problems-7`

## Disposition

- The live Viet seam is coverage-complete for the current approved rows.
- The historical `autonomous-500` lane remains intentionally compatibility-preserving at the `audio_status` level and now communicates its reconciled status through `notes`.
- The two orphan MP3s remain outside the shipped seam and should only be removed or archived after a broader dependency sweep.
