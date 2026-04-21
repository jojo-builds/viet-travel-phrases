# Viet Relation Export Packet Audit

Date: 2026-04-21
Task: `T-124`
Session: `task-queue-41-aa5af3ba-69e6-4412-bb54-0485090d3240`

## Scope

- reclaim and finish the existing Viet relation-safe website export packet
- keep the live public export bounded at the already-shipped `14` covered clusters across `6` modules
- harden fail-together enforcement so the source `29`-cluster relation sample, canonical doc block, and website validator cannot drift silently

## Files changed this run

- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- `.agent/tasks/T-124/reviews/gate-1/pass-2/*.md`
- `.agent/tasks/T-124/reviews/gate-2/pass-2/*.md`
- `.agent/tasks/T-124/logs/viet-relation-export-packet.md`
- `.agent/tasks/T-124/result.md`

## Contract hardening

- added `sampleClusterCount: 29` to the canonical Viet website relation export block in `docs/PHRASE_RELATIONSHIP_MODEL.md`
- clarified in `docs/V2_CONTENT_MODEL.md` that the website `relationExport` contract now carries the source sample identity and current sidecar boundary
- extended `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` so relation export checks now:
  - require `relationExport.sampleClusterCount`
  - compare `sampleClusterCount` between manifest and canonical doc block
  - compare `sampleId` between manifest and `content-draft/viet/relation-sample-v1.json`
  - verify `relation-sample-v1.json` `clusterCount` matches the actual clusters array length
  - compare manifest/doc `sampleClusterCount` against the source relation sample `clusterCount`

## Validation

- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
  - passed
- manifest JSON parse
  - `site/data/phrase-previews/manifest.json` passed
  - `site/public/data/phrase-previews/manifest.json` passed
- touched Viet module JSON parse
  - `vietnam-arrival-basics.json`
  - `vietnam-essential-basics.json`
  - `vietnam-food-drink-basics.json`
  - `vietnam-money-basics.json`
  - `vietnam-phone-basics.json`
  - `vietnam-transport-basics.json`
  - `vietnam-understanding-repair.json`
- review state
  - Gate 1 pass 2: `3 APPROVE / 1 BLOCK`, correctly forcing the source-boundary fix
  - Gate 2 pass 2: unanimous `APPROVE`

## Scope notes

- the website export payloads and both manifest copies already carried the bounded `14`-cluster relation subset before this reclaim; this run did not widen the public export surface
- the repo had a large pre-existing dirty worktree in unrelated `app/**`, `docs/operations/**`, and `site/countries/**` paths; this run stayed inside the allowed task scope and did not require touching those areas

## Residual risk

- the current live website seam is still a bounded starter-safe subset rather than the full `29`-cluster source sample; future website lanes still need deliberate coverage expansion instead of inferring that the whole source sample is live
