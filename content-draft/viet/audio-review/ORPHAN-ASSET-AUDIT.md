# Viet Orphan Asset Audit

Audit date: 2026-04-18

## Summary

The Viet audio folder contains 921 physical MP3 files, while the live Viet family seam maps 919 of them. The two extra files are:

| File | Duration | Sample rate | Bitrate | Mtime |
| --- | ---: | ---: | ---: | --- |
| `problems-5.mp3` | 1.567s | 44100 | 127997 | 2026-04-02T06:46:26 |
| `problems-7.mp3` | 1.149s | 44100 | 127999 | 2026-04-02T06:46:26 |

## Live-Seam Findings

For both files:

- not present in `content-draft/viet/phrase-source.csv` approved-ready rows
- not present in `app/assets/audio/manifest.json`
- not present in `app/assets/audio/registry.ts`
- not referenced in `app/family/packs/viet.generated.ts`

Under the current family-pack seam, these files do not count as shipped Viet audio coverage.

## Orphan Classification

These are best described as `unmapped physical assets outside the live family seam`, not `delete-ready unused files`.

Why:

- they are outside the live Viet family seam
- this task intentionally stayed inside the allowed live-seam read surfaces
- the live-seam audit alone cannot prove whether any broader compatibility or archival dependency still exists elsewhere in the repo

## Recommendation

Recommended posture now:

1. Keep `problems-5.mp3` and `problems-7.mp3` excluded from live Viet coverage claims.
2. Do not silently remap them into the family pack in this task.
3. Do not delete them as standalone files in this task.

Recommended follow-up:

1. Run a dedicated broader-reference sweep outside this task's bounded read surface before any deletion.
2. If no downstream dependency exists, remove or archive these 2 MP3s together in a follow-up cleanup task.
3. If a compatibility or archival dependency is found later, document that dependency explicitly instead of letting the files remain as unexplained extras.

## Decision

Current best recommendation: treat the two MP3s as bounded cleanup debt outside the live family-pack seam, not as shipped coverage and not as blind-delete candidates until a broader dependency sweep is complete.
