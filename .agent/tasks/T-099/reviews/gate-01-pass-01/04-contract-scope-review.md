Approval: BLOCK

# Gate 1 Pass 1: Contract Scope Review

## Findings

- The repo evidence supports the statement that no sampled runtime seam promotion is needed because the sampled 24 phrases already resolve to live coverage.
- The task contract still requires a live seam update and explicitly names `app/family/packs/viet.json` as a required output even though that file does not exist in current repo truth.
- The current pack seam is `app/family/packs/viet.ts` re-exporting `viet.generated.ts`, so the written contract does not align with the repo.

## Recommended Gate Decision

Block unless the task contract is revised to accept evidence-only closure with the current `viet.ts` and `viet.generated.ts` seam instead of requiring a `viet.json` artifact and a live seam promotion.
