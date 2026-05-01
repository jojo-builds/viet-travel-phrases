# TASK-VIET-CANONICAL-CONTENT-AUDIT-001 Result

Status: blocked after largest safe validated subset. The runtime graph and structural content contract are repaired, but the stricter page-level human-quality audit still identifies pages that need authored repair before this can honestly be called complete.

Commit hash: pending final commit; the exact commit hash is recorded in the thread receipt.

## Accepted Jojo Steers

- Do not treat generator-pattern repair as sufficient.
- Audit every canonical page with page-level reasoning.
- Repair safely at source when the traveler-friendly meaning is clear.
- Do not guess on high-stakes Vietnamese phrasing; preserve uncertain Vietnamese and queue it for Jojo/native review with evidence.
- A page passes only when it feels useful for a real first-time traveler, not merely because it has the right section IDs.

## Counts

| Metric | Count |
| --- | ---: |
| Starting canonical pages | 3,038 |
| Final canonical pages | 3,038 |
| Source phrase rows | 3,046 |
| Duplicate normalized canonical Vietnamese groups | 0 |
| Pages with required sections present | 3,038 |
| Pages with `Explore next` present | 3,038 |
| Release-blocking missing audio rows | 0 |
| Planned missing audio rows | 2,100 |

## Audit Outcome

Strict canonical audit artifacts live under `docs/content-audits/viet-canonical-content-audit-001/`.

| Verdict | Pages |
| --- | ---: |
| PASS | 944 |
| NEEDS_AUTHORED_REPAIR | 1,350 |
| NEEDS_REVIEW | 744 |

Remaining issue counts:

| Issue | Pages |
| --- | ---: |
| `pattern_heavy_copy` | 1,350 |
| `catalog_built_no_authored_source` | 744 |
| `weak_breakdown_label` | 241 |

The Jojo/native review queue contains 2,094 page rows at `docs/content-audits/viet-canonical-content-audit-001/jojo-review-queue.csv`.

## Safe Repairs Completed

- Removed the old `answers the traveler question...` copy pattern from Tier 1/generated article copy and regenerated source/resources.
- Repaired awkward `main thing you need understood` wording in phrase/practice source without changing Vietnamese text or canonical IDs.
- Added explicit `When to use it` and `Good to know` coverage for the Xin chào flagship page.
- Restored `Explore next` sections for every canonical page, using non-duplicate canonical fallback links where authored rows had already been taught earlier on the page.
- Added `native-ios/scripts/audit-viet-canonical-content.js` for repeatable full-universe audit artifacts.
- Strengthened generated-resource validation for the removed `answers the traveler question` wording.

## Validation

Passed:

- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-viet-practice-expansion.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- broad banned/internal wording scan for hard-banned phrases
- `git diff --check`

Proof:

- `native-ios/App/**` changed files: 0
- `native-ios/Resources/Audio/**` changed files: 0

## Reviewer Gate

Reviewer 1, traveler UX and copy quality: BLOCK OVERALL / APPROVE SAFE SUBSET. The repaired Tier 1 examples read more naturally and every page now has a navigable learning path, but the practice-expansion lane still has 1,350 pattern-heavy pages that should be rewritten page-by-page before being called fully authored-quality.

Reviewer 2, canonical graph and runtime integrity: APPROVE SAFE SUBSET. SQLite has 3,038 canonical pages, 3,046 resolved phrase rows, zero duplicate normalized canonical Vietnamese groups, zero hero translation mismatches, all pages have `Explore next`, and missing audio remains planned/deduped with zero release-blocking rows.

## Remaining Work

Recommended next task: `TASK-VIET-PRACTICE-EXPANSION-AUTHORED-REPAIR-001`.

Scope:

- Rewrite the 1,350 practice-expansion pages from the source shards page-by-page.
- Replace repeated practice prose such as `short practice phrase`, `keeps the sentence direct`, and `built for quick recognition`.
- Review and improve the 241 weak breakdown labels.
- Promote or author durable source records for the 744 catalog-built pages, or explicitly accept a lighter long-tail standard for that lane.
