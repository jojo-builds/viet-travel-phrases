# T-073 Search Audit

## Scope

- Task: `T-073`
- Date: `2026-04-20`
- Allowed code write surface used in this run:
  - `app/family/presentation/tagalog.ts`
  - `docs/operations/LATEST_VALIDATION.md`
  - `docs/operations/CURRENT_BLOCKERS.md`
  - `.agent/tasks/T-073/**`
- Shared matcher sources were read-only in this run:
  - `app/lib/searchPhrases.ts`
  - `app/lib/homeSearchState.ts`

## Audit findings

1. The shared normalization behavior already includes the earlier compact-separator fix in `app/lib/searchPhrases.ts`.
2. The live task scope for `T-073` did not permit `app/lib/**` edits, so this rerun could not make or claim any matcher change.
3. The visible bounded family-shell gap was in Tagalog search copy:
   - the placeholder was generic (`Search English, Tagalog, or pronunciation`)
   - the results and empty-state labels were less aligned with the situation-first Viet guidance
   - the clear action label was shorter and less explicit than the Viet surface

## Deterministic repo-side normalization proof

Captured with a plain `node` snippet that reproduced the current normalization and compaction rules from `app/lib/searchPhrases.ts`:

| sample | normalized | compact |
| --- | --- | --- |
| `Wi-Fi` | `wi fi` | `wifi` |
| `wi fi` | `wi fi` | `wifi` |
| `wifi` | `wifi` | `wifi` |
| `check-in` | `check in` | `checkin` |
| `check in` | `check in` | `checkin` |
| `checkin` | `checkin` | `checkin` |
| `eSIM` | `esim` | `esim` |
| `e-sim` | `e sim` | `esim` |
| `esim` | `esim` | `esim` |

## Validation

- Passed:
  - `npx --no-install tsc --noEmit`
- Blocked by sandbox:
  - `npm run validate:family`
  - inline `tsx` search probes
- Sandbox failure mode:
  - `tsx` / `esbuild` child-process spawn failed with `spawn EPERM`

## Change made

- Tightened Tagalog search copy in `app/family/presentation/tagalog.ts` only:
  - placeholder now gives travel-real examples
  - results title now matches the shared `Results` wording
  - empty state now uses the same plain-language pattern as Viet
  - clear action now reads `Clear search`

## Honest limits

- No matcher behavior changed in this rerun.
- No pack-backed interactive query proof was added in this rerun.
- No simulator, device, or manual runtime search smoke was captured in this rerun.
- Shared Viet + Tagalog search baseline remains blocked on durable runtime/manual proof.
