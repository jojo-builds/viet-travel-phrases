# Viet Content Practice Expansion Audit 001

Task: `TASK-VIET-CONTENT-PRACTICE-EXPANSION-001`

## Summary

- Starting canonical pages: 1,688
- Final canonical pages: 3038
- Net-new canonical pages: 1350
- Approved practice-expansion source records: 1350
- Generated practice-expansion listing pages: 1350
- Final source phrase rows: 3046
- Practice sample deck items: 7200
- Practice question types: 8
- Unified planned missing-audio queue rows: 2100

## Practice Bucket Coverage

| Bucket | Pages |
| --- | --- |
| city-destination | 321 |
| distractor | 1350 |
| english-to-vietnamese | 1301 |
| likely-reply | 343 |
| missing-token | 1350 |
| polite-register | 221 |
| pronoun-social | 90 |
| vietnamese-to-english | 1350 |

## Difficulty Coverage

| Difficulty | Pages |
| --- | --- |
| beginner | 925 |
| intermediate | 425 |

## Scenario Coverage

| Scenario | Pages |
| --- | --- |
| airport-border-arrival | 44 |
| bathroom-personal-needs | 30 |
| directions-navigation | 47 |
| emergency-safety | 9 |
| food-drink | 291 |
| health-pharmacy | 93 |
| hotel-accommodation | 66 |
| local-services-everyday-tasks | 52 |
| money-numbers-prices | 190 |
| phone-internet-power | 81 |
| polite-basics | 5 |
| problems-help | 2 |
| shopping | 179 |
| sightseeing-activities | 50 |
| time-dates-booking | 33 |
| transport | 173 |
| getting-unstuck | 5 |

## Expansion Families

| Family | Pages |
| --- | --- |
| buy-item | 135 |
| food-has | 29 |
| food-less | 30 |
| food-without | 31 |
| have-item | 130 |
| health-symptom | 24 |
| help-action | 79 |
| likely-replies | 49 |
| near-place | 82 |
| need-item | 131 |
| one-item-please | 114 |
| polite-request | 52 |
| price-item | 135 |
| pronoun-help | 90 |
| stop-at-place | 82 |
| take-me-place | 82 |
| where-place | 75 |

## Canonical And Audio Status

- Duplicate normalized canonical Vietnamese page groups: 0 after SQLite validation.
- Release-blocking missing audio rows: 0.
- Planned missing audio rows are deduped by normalized expected text in `docs/audio-queues/viet-planned-missing-audio.csv`.
- No new audio files were generated.

## Review Notes

The lane is practice-first and beginner-heavy: short availability questions, need/buy/price frames, destination checks, likely replies, pronoun/social help phrases, polite-register requests, and missing-token-friendly chunks. Closeout review found and repaired awkward request rows before validation: combined-pronoun slash wording, awkward article-plus-item English, and repeated-object helper wording were removed from task-owned learner-facing source rows. The source inventory at `content-draft/viet/practice-expansion/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/audit/source-inventory.csv` is the row-level audit surface for all 1,350 new records.
