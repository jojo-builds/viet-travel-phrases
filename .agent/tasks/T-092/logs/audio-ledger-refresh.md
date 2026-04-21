# T-092 Audio Ledger Refresh Log

Audit date: 2026-04-20

## Objective

Refresh the Viet continuity benchmark, follow-up allowlist, and release-posture guidance so they agree on current repo evidence after the controlled follow-up batch.

## Evidence checked

### Live seam counts

| Surface | Count |
| --- | ---: |
| Approved Viet rows with `audio_status=ready` | 919 |
| Manifest entries | 919 |
| Registry imports | 919 |
| Physical MP3 files | 921 |
| Unmapped orphan MP3 files | 2 |

### Historical stale-planned pool

| Surface | Count |
| --- | ---: |
| `autonomous-500` rows still marked `planned` | 342 |
| Those rows overlapping the live phrase source | 342 |
| Overlapping rows missing MP3 coverage | 0 |
| Overlapping rows missing manifest coverage | 0 |
| Overlapping rows missing registry coverage | 0 |

### Sample spot checks

| Phrase id | Cohort / purpose | Verified surfaces |
| --- | --- | --- |
| `hotel-4` | legacy continuity sample | phrase source, manifest, registry |
| `v500-unde-repa-please-mark-it-here` | `v500-*` continuity sample | phrase source, manifest, registry |
| `v900-tran-please-avoid-toll-roads` | `v900-*` continuity sample | phrase source, manifest, registry |
| `repair-premium-simpler-words` | allowlist proof row | phrase source, manifest, registry |
| `money-premium-total-wrong` | allowlist proof row | phrase source, manifest, registry |
| `transport-premium-route-wrong` | allowlist proof row | phrase source, manifest, registry |

### Remaining stale-planned pool by `scenario_id`

| Scenario | Count |
| --- | ---: |
| `airport-border-arrival` | 24 |
| `bathroom-personal-needs` | 6 |
| `directions-navigation` | 17 |
| `emergency-safety` | 22 |
| `food-drink` | 20 |
| `health-pharmacy` | 16 |
| `hotel-accommodation` | 20 |
| `local-services-everyday-tasks` | 11 |
| `money-numbers-prices` | 21 |
| `phone-internet-power` | 23 |
| `polite-basics` | 6 |
| `problems-help` | 30 |
| `shopping` | 11 |
| `sightseeing-activities` | 7 |
| `social-small-talk` | 8 |
| `time-dates-booking` | 20 |
| `transport` | 25 |
| `understanding-repair` | 31 |

## Outcome

- Updated `CONTINUITY-BENCHMARK.md` to reflect the `2026-04-20` reconciliation and state clearly that the stale `planned` pool is historical-lane debt, not a live seam gap.
- Hardened `FOLLOW-UP-BATCH-ALLOWLIST-2026-04-20.md` with a full-pool disposition, remaining-pool counts, and explicit next-worker instructions.
- Updated `RELEASE-POSTURE-RECOMMENDATION.md` so release-safe wording matches the refreshed ledger truth.
- No mapping-truth defect was found, so no runtime pack or asset files were changed.
