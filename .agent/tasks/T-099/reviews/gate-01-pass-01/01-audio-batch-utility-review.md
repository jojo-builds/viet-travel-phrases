Approval: BLOCK

# Gate 1 Pass 1: Audio Batch Utility Review

## Findings

- The task objective still says to turn the current Viet audio allowlist into one real bounded follow-up batch, and the spec says it must be a meaningful batch rather than a tiny proof nibble.
- The current allowlist ledger says the 24 rows are evidence samples, not a new generation batch, and explicitly says not to schedule a new Viet runtime-audio generation batch from that ledger.
- Parent verification confirmed the sampled ids already exist in `content-draft/viet/phrase-source.csv`, `app/assets/audio/manifest.json`, `app/assets/audio/registry.ts`, and `app/family/packs/viet.generated.ts`, so there is no real sampled batch left to promote.
- The continuity benchmark also says the stale historical `planned` rows already resolve to live seam coverage instead of a missing audio gap.
- The spec still names `app/family/packs/viet.json`, but the repo only exposes `app/family/packs/viet.ts` and `app/family/packs/viet.generated.ts`.

## Recommended Gate Decision

Block T-099 as a promotion task. Re-scope it as truth cleanup only, or open the separate scope-widened task for the historical `autonomous-500/generated-rows.csv` lane.
