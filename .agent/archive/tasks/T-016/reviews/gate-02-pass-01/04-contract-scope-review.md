# Contract Scope Review

Decision: WITHHOLD

## Assessment

The draft pack materially improves the Viet audio posture and is close to the T-016 objective. `content-draft/viet/audio-review/CONTINUITY-BENCHMARK.md` and `content-draft/viet/audio-review/RELEASE-POSTURE-RECOMMENDATION.md` stay inside the contract well: they sharpen the seam-level evidence, keep continuity claims bounded, and do not imply runtime mapping changes or subjective quality clearance. The orphan recommendation is also directionally right in that it keeps `problems-5.mp3` and `problems-7.mp3` out of live coverage claims and avoids silent remap/delete behavior in this task.

Gate 2 should still withhold advance because `content-draft/viet/audio-review/ORPHAN-ASSET-AUDIT.md` goes beyond the task's allowed evidence surface. Its `Legacy-Surface Findings` and downstream classification/recommendation language rely on `app/content/**` findings, but T-016 only allows reads from `docs/**`, `content-draft/viet/**`, `app/assets/audio/**`, and `app/family/packs/**`. As written, the output does not fully satisfy the contract requirement to keep this audit bounded to the current Viet family seam and its explicitly allowed verification surfaces.

## Required changes before advance

- Rewrite `ORPHAN-ASSET-AUDIT.md` so every factual claim is supported only by T-016's allowed read surfaces.
- Remove or reframe the `Legacy-Surface Findings` section and any conclusions that depend on `app/content/**` evidence.
- Keep the orphan recommendation bounded to what the in-scope evidence proves: the two MP3s are outside approved-ready source truth and outside the live family-pack seam, they should not count toward shipped coverage, and any delete/archive decision belongs to a separate follow-up cleanup task.

## Contract checks

- Required drafted outputs exist at the required paths: pass.
- The benchmark and release-posture documents materially improve the Viet audio posture with sharper, more honest seam-level language: pass.
- The orphan recommendation is directionally bounded and avoids silent runtime/audio changes in this task: pass.
- The current orphan audit does not stay fully inside the T-016 allowed evidence scope because it cites and reasons from `app/content/**`: fail.
- Gate 2 should not advance to completion review until the orphan audit is revised to remove that out-of-scope dependency while preserving the bounded live-seam recommendation.
