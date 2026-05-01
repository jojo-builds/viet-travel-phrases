# TASK-VIET-CANONICAL-CONTENT-AUDIT-001 Result

Status: complete for the Viet canonical content universe.

Final commit: recorded in the thread receipt after this result is committed.

## Accepted Jojo Steers

- Treat every canonical page as a real traveler-facing phrase article, not a generated resource that passes because sections exist.
- Preserve canonical page IDs and avoid duplicate normalized Vietnamese pages.
- Keep final copy positive, beginner-friendly, travel-forward, and useful for a first-time traveler in Vietnam.
- Use source-owned repairs and generators; do not hand-edit generated resources as the durable source.
- Do not generate audio; reuse exact audio where available, otherwise keep planned missing audio queued and non-blocking.

## Final Counts

| Metric | Count |
| --- | ---: |
| Canonical pages | 3,038 |
| Source phrase rows | 3,046 |
| Passing canonical pages | 3,038 |
| Pages needing authored repair | 0 |
| Pages needing Jojo/native review | 0 |
| Weak breakdown labels | 0 |
| Duplicate normalized canonical Vietnamese groups | 0 |
| Broken visible phrase-row destinations | 0 |
| Missing audio queue rows | 2,094 |
| Release-blocking missing audio rows | 0 |
| Missing audio rows with exact reusable assets | 0 |
| Missing audio rows with exact target usages | 0 |

## Repairs Completed

- Rewrote the 1,350 practice-expansion source pages so their article sections are phrase-specific, traveler-facing, and beginner-first instead of pattern-based.
- Promoted 744 catalog-built pages into durable authored source under `content-draft/viet/full-listing-pages/**`, with rationale records and canonical IDs preserved.
- Repaired weak breakdown labels and final breakdown cards so labels teach useful Vietnamese pieces instead of vague grammar placeholders.
- Repaired reviewer-found copy patterns in Tier 1/generated article profiles, including generic document/problem/place prose, broken-item prose leaking into baggage/map pages, and the `Hãy` breakdown gloss regression.
- Strengthened validators to fail on pattern-heavy prose, weak breakdown labels, duplicate canonical groups, unresolved visible links, and missing-audio queue rows that already have exact reusable audio.
- Updated SQLite audio reuse so exact normalized audio assets are used before any planned missing-audio queue row is emitted.
- Regenerated the Viet phrase catalog, authored listing pages resource, SQLite language pack, SQLite report, and practice deck from source.

## Validation

Passed:

- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-viet-practice-expansion.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- broad banned/internal/pattern-heavy wording scan
- `git diff --check`
- `xcodebuild build -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'generic/platform=iOS Simulator'`

Latest machine proof:

- Canonical audit: `3,038/3,038` pages `PASS`; `issueCounts: {}`; duplicate canonical groups `0`.
- SQLite validation: `3,046` source phrases, `3,038` canonical pages, `27,834` relations, `bannedFileMatches: 0`.
- Page-quality audit: `3,038` pass, `0` catalog-built pages.
- Tier 1 audit: `150` strong, `0` thin/awkward/placeholder-like/over-templated/negative/missing-link/needs-work pages.
- Practice expansion: `1,350` approved/generated pages with all required practice buckets covered.
- Missing audio: `2,094` planned rows, all non-release-blocking, all deduped, no exact reusable asset or exact target usage left unclaimed.

Latest audit artifacts:

- `docs/content-audits/viet-canonical-content-audit-001/README.md`
- `docs/content-audits/viet-canonical-content-audit-001/per-page-audit.csv`
- `docs/content-audits/viet-canonical-content-audit-001/per-page-audit.jsonl`
- `docs/content-audits/viet-canonical-content-audit-001/issue-summary.json`
- `docs/content-audits/viet-canonical-content-audit-001/jojo-review-queue.csv`
- `docs/content-audits/viet-canonical-content-audit-001/repair-ledger.md`

## Review Gate

- Traveler/copy reviewer: APPROVE after checking positive first-time-traveler usefulness, beginner learning flow, pattern-heavy copy, weak labels, and previously bad pages.
- Technical reviewer: APPROVE after checking canonical graph integrity, generated artifact consistency, missing-audio queue correctness, validator coverage, and scope.

## Scope Proof

- Canonical content/resource changes were regenerated through source and scripts.
- No audio files were generated or changed.
- `native-ios/App/**`, `native-ios/Resources/Audio/**`, `native-ios/SpeakLocalNative.xcodeproj`, `native-ios/Tests/**`, and `native-ios/UITests/**` have no diffs for this task.
