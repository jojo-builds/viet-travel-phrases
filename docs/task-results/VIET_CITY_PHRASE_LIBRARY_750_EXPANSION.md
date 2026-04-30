# Vietnam City Phrase Library 750 Expansion Result

Status: complete pending final commit hash in thread closeout.

## What Changed

- Expanded `content-draft/viet/city-library/v1.json` to 750 approved city pages: 150 each for Saigon/HCMC, Hanoi, Da Nang, Hoi An, and Hue.
- Preserved the existing 125 city page IDs while adding 625 more approved city-specific canonical pages.
- Kept the library beginner-heavy: 638 beginner, 107 intermediate, 5 advanced.
- Regenerated the Viet native catalog, authored listing-page resource, audio audit, missing-audio queue, SQLite fixture, SQLite report, and practice sample decks.
- Updated native Practice so all five cities have visible practice paths, city-specific prompts, and city-scoped distractors.
- Added deterministic simulator launch hooks for city practice paths and article scroll proof.

## Counts

| Metric | Count |
| --- | ---: |
| Approved city source pages | 750 |
| HCMC pages | 150 |
| Hanoi pages | 150 |
| Da Nang pages | 150 |
| Hoi An pages | 150 |
| Hue pages | 150 |
| SQLite phrase_city_tag rows | 750 |
| SQLite canonical pages | 1688 |
| SQLite phrases | 1696 |
| City practice items | 0 |
| Missing city audio queue rows | 749 |
| Duplicate normalized canonical Vietnamese groups | 0 |
| Broken city links | 0 |

## Artifacts

- Audit: `docs/content-audits/viet-city-library-750-expansion.md`
- Missing audio queue: `docs/audio-queues/viet-city-library-v1-missing-audio.csv`
- SQLite report: `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- Screenshots:
  - `docs/task-results/screenshots/viet-city-library-750-expansion/bottom-catalog-shelf-hue.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/current-hue-check.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/danang-new-beginner-page.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/hanoi-new-beginner-page.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/hcmc-new-beginner-page.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/hoian-new-beginner-page.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/hue-new-beginner-page.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/long-breakdown-danang-atm-cathedral.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/practice-city-paths-top.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/practice-hoian-path.png`
  - `docs/task-results/screenshots/viet-city-library-750-expansion/practice-hue-path.png`

## Validation Recorded

- `node native-ios/scripts/generate-viet-catalog.js` -> passed.
- `node native-ios/scripts/generate-authored-tier-one-pages.js` -> passed.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` -> passed.
- `node scripts/practice/generate-viet-practice-deck.js` -> passed.
- `node native-ios/scripts/validate-viet-city-library.js` -> passed.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` -> passed.
- `node native-ios/scripts/validate-tier-one-listing-pages.js` -> passed.
- `node native-ios/scripts/audit-viet-page-quality.js` -> passed.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` -> passed.
- `node --test scripts/practice/generate-viet-practice-deck.test.js` -> passed.
- Focused native tests: `AppChromeTests`, `PracticeNativeMVPTests`, and `SQLiteLanguagePackRepositoryTests` -> passed.
- `git diff --check` -> passed.
- `native-ios/Resources/Audio/**` -> unchanged.

## Review Notes

- Traveler fit: pages are city-specific and tied to place anchors, routes, markets, food/coffee, practical help, or landmarks; generic city-library rows without anchors are rejected by validation.
- Learning flow: every page carries short English intent, pronunciation, reusable chunks, city/place context, positive travel note, and Explore next data.
- System integrity: SQLite validation proves 750 city tags, zero duplicate canonical Vietnamese page groups, and zero broken city links.

## Remaining Work

- Generate or source the queued city audio in a separate audio-production task.
- Expand onboarding city selection and practice weighting beyond the current native city practice paths when product wants that full flow.
