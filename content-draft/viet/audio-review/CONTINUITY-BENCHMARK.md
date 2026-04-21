# Viet Audio Continuity Benchmark

Audit date: 2026-04-21

## Scope

This benchmark is a seam-level audit of the current Viet family pack plus a bounded reconciliation against the `2026-04-20` controlled follow-up batch evidence and the `2026-04-21` historical-lane cleanup pass. It checks source-row coverage, live audio mapping, physical MP3 inventory, and bounded technical metadata. It does not include a listening pass, same-speaker verification, or runtime/audio asset edits.

## Coverage Reconciliation

| Surface | Count | Notes |
| --- | ---: | --- |
| Approved Viet phrase rows with `audio_status=ready` | 919 | `content-draft/viet/phrase-source.csv` |
| Live manifest entries | 919 | `app/assets/audio/manifest.json` |
| Live registry imports | 919 | `app/assets/audio/registry.ts` |
| Physical Viet MP3 files | 921 | Includes 2 unmapped legacy files |

Result: the live Viet family seam is coverage-complete for the current approved rows. There is no mapped-row gap between source truth, manifest truth, and runtime import truth.

## Historical Lane Reconciliation

The `2026-04-20` controlled follow-up reconciliation checked the historical `content-draft/viet/autonomous-500/generated-rows.csv` lane to confirm whether stale `audio_status=planned` rows reflect missing live audio or only stale lane-local truth. The `2026-04-21` cleanup pass kept the legacy `planned` token for lane compatibility, but rewrote the row notes so the file no longer reads like a missing-audio worklist.

| Surface | Count | Notes |
| --- | ---: | --- |
| Historical rows still carrying the legacy `planned` token | 342 | Token preserved for historical-lane compatibility |
| Historical `planned` rows overlapping the live seam | 342 | All rows still exist in the current phrase source |
| Overlapping rows with MP3 coverage | 342 | `app/assets/audio/*.mp3` |
| Overlapping rows with manifest coverage | 342 | `app/assets/audio/manifest.json` |
| Overlapping rows with registry coverage | 342 | `app/assets/audio/registry.ts` |

Interpretation: the historical `planned` pool is stale source-lane truth, not evidence of a live Viet seam gap. The surviving `planned` token in `generated-rows.csv` is now explicitly historical residue, not an instruction to generate or map more live audio. This strengthens the coverage-completeness claim but does not strengthen continuity claims.

## Technical Normalization

- All 919 mapped MP3s report `sample_rate=44100`.
- All 919 mapped MP3s report `mode=3` in `mutagen`.
- Mapped files cluster around `~128 kbps`.
- Duration range across mapped files: `0.679s` to `4.833s`.
- Average mapped duration: `1.899s`.
- Median mapped duration: `1.750s`.

This is enough to support a claim that the shipped seam is technically normalized at the file-metadata level. It is not enough to prove perceptual continuity, accent uniformity, or same-speaker continuity.

## Cohort Mix

| Cohort | Count | Avg duration | Mtime window |
| --- | ---: | ---: | --- |
| Legacy ids | 221 | 1.655s | 2026-04-02 to 2026-04-16 |
| `v500-*` ids | 295 | 1.846s | 2026-04-16 to 2026-04-16 |
| `v900-*` ids | 403 | 2.071s | 2026-04-16 to 2026-04-16 |

Representative midpoint samples:

| Cohort | Phrase id | English | Audio key | Duration |
| --- | --- | --- | --- | ---: |
| Legacy | `hotel-4` | This room is too hot | `hotel-4` | 1.567s |
| `v500-*` | `v500-unde-repa-please-mark-it-here` | Please mark it here | `v500-unde-repa-please-mark-it-here` | 1.672s |
| `v900-*` | `v900-tran-please-avoid-toll-roads` | Please avoid toll roads | `v900-tran-please-avoid-toll-roads` | 2.038s |

The important continuity signal is not that these cohorts sound different; this audit did not listen to them. The important signal is that the shipped library was assembled from multiple recording/provenance batches, so same-speaker continuity should remain unproven until a separate listening or speaker-validation pass happens.

## Benchmark Interpretation

- Safe to claim now:
  - the current Viet live seam is audio-backed for all 919 approved rows
  - the live seam is technically normalized and fully mapped
  - the 342 stale historical `planned` rows already resolve to live seam coverage and should be treated as lane-local truth drift, not missing audio
  - the `generated-rows.csv` notes now mark those rows as historical source-lane records already covered by the live seam
  - continuity risk should still be discussed in terms of mixed recording cohorts, not missing coverage
- Not safe to claim from this audit alone:
  - same-speaker continuity is proven
  - the full library is perceptually seamless
  - the current pack is broadly audio-quality-cleared beyond seam coverage and bounded metadata checks

## Benchmark Posture

Use this benchmark as evidence for coverage completeness and cautious continuity language. Do not use it as a substitute for a listening pass, device playback review, or subjective voice-consistency approval. The controlled follow-up batch evidence and `2026-04-21` row-note cleanup remove ambiguity about the stale historical `planned` rows, but they do not upgrade the continuity posture beyond seam-level caution.
