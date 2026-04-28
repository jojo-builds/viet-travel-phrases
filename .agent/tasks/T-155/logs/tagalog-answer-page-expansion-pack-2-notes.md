# Tagalog Answer-Page Expansion Pack 2 Notes

## Scope

- Expand the Tagalog answer-page sidecar from `24` hubs / `4` classes to `58` hubs / `8` classes without changing runtime schema or scenario ids.
- Keep all existing `24` hubs and deepen them with more specific class/module mixes.
- Promote `45` packet primaries plus `13` retained seed hubs into the bounded answer-page subset.

## Final class split

- `4` `greetings-social`
- `4` `urgent-help-medical`
- `7` `repair-clarification`
- `9` `transport-ride-hailing`
- `8` `directions-navigation`
- `8` `hotel-accommodation`
- `10` `money-transaction`
- `8` `food-drink`

## Relation discipline

- `relation-sample-v1.json` is the sole source for promoted cross-family `relationBuckets`.
- `first-wave-priority.csv` and `tagalog-v2-first-wave.csv` only mirror `answer_page_*` handoff fields for the selected packet families.
- Parked or deferred targets stay visible in relation metadata but do not populate promoted answer-page buckets.
- `likelyReply` is only emitted when the underlying relation cluster already authors a reply-style edge.
- Relation-driven answer-page modules only render when the supporting bucket actually exists for that hub.

## Row coverage

- `103` rows in `phrase-source.csv` now carry `answer-page-sample=...` markers.
- `45` packet primaries in `first-wave-priority.csv` and `tagalog-v2-first-wave.csv` now carry bounded `answer_page_*` fields.
- The widened answer-page set still stops short of promoting all `80` relation clusters.

## Flagship deepening targets

- Existing flagship hubs now split out of the old catch-all `practical-service-navigation` lane into ride-hailing, directions, hotel, money, and food-specific module mixes.
- Existing greeting, urgent-help, and repair hubs now use richer v2 mixes while staying compact.
