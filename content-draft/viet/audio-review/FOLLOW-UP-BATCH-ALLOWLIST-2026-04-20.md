# Viet Historical Audio Lane Disposition

Audit date: 2026-04-21

## Scope

This is the durable disposition packet for the historical `content-draft/viet/autonomous-500/generated-rows.csv` lane.

The goal is to record, in one place, that the rows still carrying the legacy `audio_status=planned` token in that historical lane already have app-usable audio coverage in current repo truth and should not be treated as a missing-audio worklist.

This note does not strengthen continuity claims. It only confirms coverage and records the disposition of the stale historical pool.

## Batch-level findings

- Historical lane audited: `autonomous-500`
- Historical rows still carrying the legacy `audio_status=planned` token: `342`
- Historical rows that overlap the current live `content-draft/viet/phrase-source.csv`: `342`
- Historical rows with matching `app/assets/audio/*.mp3` files: `342`
- Historical rows with matching `app/assets/audio/manifest.json` entries: `342`
- Historical rows with matching `app/assets/audio/registry.ts` imports: `342`
- Historical rows whose `notes` now explicitly say live coverage already exists: `342`

Result: the historical `autonomous-500` lane still carries the legacy `planned` token for compatibility, but every row in that lane already resolves to app-usable audio coverage in the current live seam and the row notes now say so directly.

## Sampled proof set

These 24 rows remain the bounded traveler-value proof set because they cover direct repair, money, transport, and hotel recovery phrases that matter when the trip is already going wrong. They are evidence samples, not a new generation batch.

| Phrase id | Scenario | English | Outcome |
| --- | --- | --- | --- |
| `repair-premium-simpler-words` | understanding-repair | Can you use simpler words? | Already live-ready with MP3, manifest, and registry coverage |
| `repair-premium-type-phone` | understanding-repair | Can you type it on your phone? | Already live-ready with MP3, manifest, and registry coverage |
| `repair-premium-text-me` | understanding-repair | Can you text it to me? | Already live-ready with MP3, manifest, and registry coverage |
| `repair-premium-spell-name` | understanding-repair | Can you spell the name for me? | Already live-ready with MP3, manifest, and registry coverage |
| `repair-premium-which-exit` | understanding-repair | Which exit is it? | Already live-ready with MP3, manifest, and registry coverage |
| `repair-premium-time-exact` | understanding-repair | What time exactly? | Already live-ready with MP3, manifest, and registry coverage |
| `money-premium-total-wrong` | money-numbers-prices | This total is wrong. | Already live-ready with MP3, manifest, and registry coverage |
| `money-premium-price-changed` | money-numbers-prices | Why is the price different now? | Already live-ready with MP3, manifest, and registry coverage |
| `money-premium-what-fee` | money-numbers-prices | What is this fee for? | Already live-ready with MP3, manifest, and registry coverage |
| `money-premium-write-total` | money-numbers-prices | Please write the total down. | Already live-ready with MP3, manifest, and registry coverage |
| `money-premium-service-included` | money-numbers-prices | Is service already included? | Already live-ready with MP3, manifest, and registry coverage |
| `money-premium-split-payment` | money-numbers-prices | Can we split the payment? | Already live-ready with MP3, manifest, and registry coverage |
| `transport-premium-wrong-car` | transport | This is not my car. | Already live-ready with MP3, manifest, and registry coverage |
| `transport-premium-wrong-pickup-point` | transport | Is this the right pickup point? | Already live-ready with MP3, manifest, and registry coverage |
| `transport-premium-wait-here` | transport | Please wait here, I am coming. | Already live-ready with MP3, manifest, and registry coverage |
| `transport-premium-route-wrong` | transport | This route is wrong. | Already live-ready with MP3, manifest, and registry coverage |
| `transport-premium-turn-around` | transport | Please turn around. | Already live-ready with MP3, manifest, and registry coverage |
| `transport-premium-luggage-trunk` | transport | My luggage is in the trunk. | Already live-ready with MP3, manifest, and registry coverage |
| `hotel-premium-booking-wrong` | hotel-accommodation | I think there is a problem with my booking. | Already live-ready with MP3, manifest, and registry coverage |
| `hotel-premium-different-room` | hotel-accommodation | I booked a different room. | Already live-ready with MP3, manifest, and registry coverage |
| `hotel-premium-room-not-ready` | hotel-accommodation | The room is not ready yet. | Already live-ready with MP3, manifest, and registry coverage |
| `hotel-premium-no-hot-water` | hotel-accommodation | There is no hot water. | Already live-ready with MP3, manifest, and registry coverage |
| `hotel-premium-too-noisy` | hotel-accommodation | The room is too noisy. | Already live-ready with MP3, manifest, and registry coverage |
| `hotel-premium-late-checkout` | hotel-accommodation | Can I check out later? | Already live-ready with MP3, manifest, and registry coverage |

## Full-pool disposition

- `24` rows were sampled and individually confirmed live-ready in this note.
- `318` additional rows remain under the same legacy historical `planned` token, but the batch-level sweep found no live seam gap for them either.
- The 24 sampled rows do not need to be re-audited unless live seam files change.
- `generated-rows.csv` now uses the `notes` field, not a new `audio_status` token, to mark the full pool as historical source-lane truth already covered by the live seam.
- The remaining 318 rows should be treated as lower-priority historical-lane residue, not missing-runtime-audio work.

Remaining `318` rows by `scenario_id`:

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

## Next-worker instruction

Do not schedule a new Viet runtime-audio generation batch from this ledger.

If someone wants a distinct historical status beyond `planned`, define that contract repo-wide before changing `audio_status`; do not improvise a new token from this file alone.

If the goal is continuity validation, use `CONTINUITY-BENCHMARK.md` and `RELEASE-POSTURE-RECOMMENDATION.md` as the current seam-level baseline and run a listening-based follow-up instead of another stale-row coverage audit.

If the goal is asset cleanup, run a broader dependency sweep for `problems-5.mp3` and `problems-7.mp3` before archiving or deleting them.

## Continuity posture

- Keep the existing seam-level continuity caution from `CONTINUITY-BENCHMARK.md`.
- Do not describe this audit as same-speaker validation.
- Do not describe this audit as a new runtime audio expansion.

## Constraint

The live pack and audio seams already appear complete for this full historical pool, so this packet is a truth-cleanup artifact, not a mapping or asset-generation pass.
