# SpeakLocal Bugs Doc Recheck - 2026-04-30

Status: Complete.

Source reviewed: Google Doc `Speak local bugs Thursday, April 30`
Document ID: `11_ysgbeTxIuITAqJ5QJ5khs542H9a2xmGH-FVYj12Fo`

## What Changed

- Rechecked the 10-item bug list from the doc against current app behavior and generated content.
- Fixed the remaining repeated-row issue across canonical pages by deduping visible phrase targets page-wide during SQLite generation, not only inside `Explore next`.
- Added a second guard for exact visible phrase text, so future authored rows cannot repeat the same phrase on the same canonical page under a different internal id.
- Kept relationship-word shelves contextual while preventing the current page phrase from repeating inside its own relationship shelf.
- Removed awkward `clear/socially clear` wording from the `Chào` authored source, generated catalog, and generated listing resources.
- Regenerated the Viet SQLite pack and native generated resources.

## Doc Bug Checklist

| Bug | Status | Proof |
| --- | --- | --- |
| Search/Home navigation gets trapped | Passed | `AppChromeTests/testRepeatedDetailSearchHomeSearchFlowDoesNotTrapBackNavigation`; screenshot `02-search-expanded.png` |
| Odd `clear/socially clear` wording | Fixed | Source/resource scan has zero matches for the reported wording; screenshot `05-chao-hero.png` |
| Same phrases taught twice on the same page | Fixed | SQLite report: `repeatedVisiblePhraseRowCount: 0`, `repeatedVisiblePhraseTextRowCount: 0` |
| Explore next repeats phrases already taught | Passed | Validator: `Explore next rows that repeat phrases already taught on the page` = 0 |
| Breakdown carousel needs right-side peek | Passed | `AppChromeTests/testBreakdownCarouselKeepsMultiCardPeekWithoutSingleCardOverflow`; screenshots `04-xin-chao-midpage.png`, `08-breakdown-peek.png` |
| Possible compound/two-phrase rows | Passed | Compound audit remains covered by canonical duplicate checks; `duplicateCanonicalPageGroupCount: 0` |
| First speaker tap does not play | Passed | `PhrasePageFixtureTests/testAudioPlaybackServiceConfiguresSessionBeforeFirstPlayback` |
| Relationship words on `I'm from the United States` | Passed | SQL count for `viet-phrase-smalltalk-1` relationship section = 0; screenshot `09-from-us-no-relationship-shelf.png` |
| Quick Say semantics | Passed | `badQuickSayTeachingRowCount: 0`; native `testSQLiteQuickSayRowsUseCanonicalPhraseOrApprovedBeginnerShortcut` |
| Top/bottom liquid glass separation | Passed | Screenshots `01-home.png`, `06-directions-hero-english.png`, `10-home-card-alignment.png`, `11-home-travel-situations.png` |

## Final Counts

- Canonical pages: `938`
- Source phrases: `946`
- Resolved phrases: `946`
- Search documents: `946`
- Duplicate canonical page groups: `0`
- Repeated visible phrase rows: `0`
- Repeated visible phrase text rows: `0`
- Text-only section runs of 3+: `0`
- Broken relation edges: `0`
- Missing audio audit rows: `0`
- User-facing banned/internal wording matches: `0`

## Screenshot Proof

All screenshots are under `docs/task-results/assets/bugs-doc-recheck-2026-04-30/`.

- `01-home.png`
- `02-search-expanded.png`
- `03-xin-chao-hero.png`
- `04-xin-chao-midpage.png`
- `04-xin-chao-relationship.png`
- `05-chao-hero.png`
- `06-directions-hero-english.png`
- `07-bottom-category-shelves.png`
- `08-breakdown-peek.png`
- `09-from-us-no-relationship-shelf.png`
- `10-home-card-alignment.png`
- `11-home-travel-situations.png`

## Validation

- `node native-ios/scripts/generate-viet-sqlite-fixture.js` - passed
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` - passed
- `node native-ios/scripts/audit-viet-page-quality.js` - passed, `938 / 938`
- `node native-ios/scripts/validate-tier-one-listing-pages.js` - passed, `150 strong`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` - passed
- Focused native suite - passed, `24` tests
- `native-ios/Resources/Audio/**` - unchanged
