# Viet Audio Release Posture Recommendation

Audit date: 2026-04-21

## Recommended Current Posture

Use a conservative but useful description:

- The current Viet family pack is audio-backed for all 919 approved live rows.
- Live mapping and runtime import coverage are complete for the approved seam.
- Technical file metadata is normalized across the shipped seam.
- The stale `autonomous-500` `audio_status=planned` pool is historical source-lane debt, not a live seam gap, and the row notes now say that explicitly.
- Continuity should still be described cautiously because the library spans legacy, `v500-*`, and `v900-*` recording cohorts.

## Suggested Wording

Recommended internal/release-safe wording:

> The current Viet pack is audio-backed for all 919 approved live rows. Mapping and file-level technical coverage are complete for the shipped seam. A bounded follow-up check also confirmed that the historical `autonomous-500` rows still carrying the legacy `planned` token already resolve to live seam coverage, and the row notes now frame that token as historical source-lane residue rather than missing runtime audio. Because the library spans multiple recording cohorts, this audit supports coverage completeness and bounded continuity caution, not a same-speaker or full quality-clearance claim.

## Wording To Avoid

Do not say:

- the Viet pack is same-speaker verified
- the full library is perceptually seamless
- continuity quality is fully cleared
- the two unmapped orphan MP3s count as extra live coverage
- the stale historical `planned` pool implies current missing audio in the live app seam
- the surviving `planned` token in `generated-rows.csv` is a real next-batch worklist

## Orphan-File Language

When the orphan question comes up, use this posture:

> Two unmapped MP3s, `problems-5.mp3` and `problems-7.mp3`, remain outside the live Viet family-pack seam. They should be tracked as cleanup debt and are not part of the current shipped audio coverage count.

## Operational Recommendation

- Safe claim now: `coverage-complete` or `audio-backed` for the current approved Viet family seam
- Required caution now: `continuity benchmarked at seam level only`
- Historical truth-cleanup status: completed for the current packet via row-note reconciliation plus the synced audio-review docs
- Deferred claim: any statement about same-speaker continuity, perceptual uniformity, or broader audio quality approval

## Next Best Follow-Up

If stronger continuity language is needed later, the next task should be a listening-based spot check or speaker-consistency review across representative legacy, `v500-*`, and `v900-*` cohorts. This seam audit does not replace that work.

If the immediate goal is asset cleanup, run a broader dependency sweep on `problems-5.mp3` and `problems-7.mp3` before archiving or deleting them.
