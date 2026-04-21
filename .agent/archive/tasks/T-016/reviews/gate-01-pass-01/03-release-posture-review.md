Decision: APPROVE

## Assessment

The planned release-facing posture is useful and conservative if it stays anchored to the current approved-row seam instead of turning seam evidence into broader quality claims. Repo truth already supports describing Viet audio as artifact-complete or audio-backed for the current live scope: `docs/PRIORITIES.md` says to treat Viet audio as artifact-complete for the current 900-family pack while reserving continuity benchmarking and orphan cleanup for follow-up, and `docs/V2_BASELINE.md` plus `docs/V2_CONTENT_MODEL.md` keep the live posture at `919 approved rows` with `919` marked audio-ready. The current generated pack also shows `919` `audioStatus: "ready"` entries.

The same repo truth also explicitly warns against stronger release language. `docs/PRIORITIES.md` says not to pretend the current Viet pass is broader audio-quality-cleared, and `docs/V2_BASELINE.md` says continuity should be benchmarked before any stronger same-speaker quality claim. That caution is reinforced by the live audio-key mix: approved rows currently span legacy short keys, `v500-*`, `v900-*`, and other cohorts, so the seam proves coverage but not single-speaker continuity.

The orphan issue is also bounded enough for release posture planning. `app/assets/audio/problems-5.mp3` and `app/assets/audio/problems-7.mp3` still exist physically, but they have no live references in `app/family/packs/viet.generated.ts`. They should therefore be surfaced as legacy unmapped assets with a cleanup recommendation, not treated as coverage evidence and not silently ignored.

## Required changes before advance

None.

## Release-language guardrails

- Okay to say the current Viet pack is artifact-complete or audio-backed for the current approved live rows.
- Okay to say the present seam shows `919` approved rows mapped with ready audio in the current pack.
- Do not say or imply the pack is same-speaker continuous, uniformly voiced, studio-cleared, or broadly quality-cleared from seam evidence alone.
- Do not use orphan assets as evidence of extra live coverage; call out `problems-5.mp3` and `problems-7.mp3` as legacy unmapped files outside the live mapping.
- Keep the orphan recommendation bounded: either quarantine/remove them after confirming no downstream references, or retain them temporarily as explicit cleanup debt pending a follow-up asset audit.
