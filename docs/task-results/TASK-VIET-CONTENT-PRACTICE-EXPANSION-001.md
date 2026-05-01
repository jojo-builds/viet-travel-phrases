# TASK-VIET-CONTENT-PRACTICE-EXPANSION-001 Result

Status: complete pending final git commit hash in thread receipt.

## Accepted Jojo Steers

- Use a practice-first expansion instead of a city-only expansion.
- Build a 1,350 authored-candidate buffer so the final deduped page count safely clears 1,250 net-new pages.
- Add a durable source lane that makes phrase rows, page prose, rationale, generated resources, and audio queues understandable for future workers.

## Counts

| Metric | Count |
| --- | ---: |
| Starting canonical pages | 1,688 |
| Final canonical pages | 3,038 |
| Net-new canonical pages | 1,350 |
| Final approved phrase rows | 3,046 |
| Practice-expansion source records | 1,350 |
| Generated practice-expansion listing pages | 1,350 |
| Practice sample deck items | 7,200 |
| Practice question types | 8 |
| Unified planned missing-audio queue rows | 2,100 |

## Artifacts

- Source lane: `content-draft/viet/practice-expansion/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/`
- Source manifest: `content-draft/viet/practice-expansion/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/manifest.json`
- Authoring rationale: `content-draft/viet/practice-expansion/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/audit/ai-authoring-rationale.jsonl`
- Source inventory: `content-draft/viet/practice-expansion/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/audit/source-inventory.csv`
- Content audit: `docs/content-audits/viet-content-practice-expansion-001.md`
- Unified audio queue: `docs/audio-queues/viet-planned-missing-audio.csv`
- Screenshots: `docs/task-results/screenshots/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/`

## Practice Coverage

| Bucket | Pages |
| --- | ---: |
| English to Vietnamese | 1,301 |
| Vietnamese to English | 1,350 |
| Missing token | 1,350 |
| City / destination | 321 |
| Pronoun / social | 90 |
| Polite / register | 221 |
| Likely reply | 343 |
| Distractor families | 1,350 |

Difficulty mix: 925 beginner and 425 intermediate. Advanced was intentionally avoided for this practice-first batch.

Best new practice families: need-item, have-item, price-item, buy-item, direct item requests, nearby/destination checks, take-me/stop-here/where-place routes, likely replies, pronoun-sensitive help, and polite-register requests.

## Audio

No audio files were generated or modified. Exact audio reuse is attempted by the generator; unresolved planned audio is queued in `docs/audio-queues/viet-planned-missing-audio.csv`.

SQLite validation reports:

- Missing audio audit rows: 2,100
- Planned missing audio rows: 2,100
- Release-blocking missing audio rows: 0

## Validation

Passed:

- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js`
- `node native-ios/scripts/validate-viet-practice-expansion.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -derivedDataPath /tmp/speaklocal-viet-expansion-derived build`

Key proof:

- Final canonical pages: 3,038
- Net-new canonical pages: 1,350
- Duplicate normalized canonical Vietnamese page groups: 0
- Resolved phrase rows: 3,046 / 3,046
- Generated page quality audit: 3,038 / 3,038 pass
- Banned/internal user-facing wording matches: 0
- Practice deck: 7,200 items, 18 scenarios, 8 question types

## Reviewer Gate

Outcome: APPROVE after one repair pass.

The focused read-only review checked first-time traveler flow, copy quality, canonical graph integrity, practice usefulness, and audio queue correctness. It initially found awkward task-owned request rows: combined-pronoun slash wording, article-plus-item English, and repeated-object helper phrasing. Those rows were repaired in the authored source lane, regenerated, and revalidated with a new source-quality validator.

## Screenshots

Current-build proof:

- `docs/task-results/screenshots/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/home-current-build.jpg`
- `docs/task-results/screenshots/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001/new-beginner-need-water-current.png`

Additional representative captures in the same folder cover the original flagship page, a city/destination page, a pronoun/social page, and a long-breakdown attempt. Bottom-scroll simulator gesture proof was inconsistent after relaunch, so the closeout relies on SQLite/resource validation plus the successful native build for full-resource proof.

## Remaining Recommendation

Next task: generate or record the unified planned-audio queue in batches, starting with the 1,350 new practice-expansion phrases and the highest-traffic city/practice phrases.
