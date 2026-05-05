# TASK-VIET-RELATIONSHIP-WORDS-LEAK-COPY-001

## Summary

Fixed the Bà Nà Hills child phrase page leak where SQLite generation inserted the Xin Chào relationship-word shelf into `Bà Nà Hills ở đâu?`.

Root cause: the SQLite relationship-word eligibility predicate treated any Vietnamese token matching `anh`, `chị`, `em`, `ông`, `bà`, `chú`, or `cô` as enough to show the relationship-word section. That made proper names like `Bà Nà Hills` eligible, so validators accepted the bad shelf instead of catching it.

## Changes

- Tightened relationship-word eligibility to greeting/social-address pages only.
- Added validator coverage for Bà Nà Hills child pages and non-greeting city-library pages.
- Rewrote the `Bà Nà Hills ở đâu?` source copy from third-person editorial wording to direct traveler-facing copy.
- Added runtime-output checks for `the traveler needs`, `when the traveler needs`, and `the user needs` in phrasebook app resources and practice decks.
- Updated the persistent `speaklocal-listing-pages` skill with reviewer personas:
  - Adult Traveler Voice Reviewer
  - Template Fit Reviewer
  - Runtime Leak Reviewer
  - Row Priority Reviewer
  - No-Slop Validator Reviewer

## Proof

- Relationship-word eligible page count dropped to `25`.
- `Bà Nà` / `ba-na` relationship-word eligibility matches: `0`.
- SQLite query for relationship-word sections on Bà Nà pages returned no rows.
- `Bà Nà Hills ở đâu?` rendered sections now are:
  - `Meaning`: `Ask for the ticket area, cable car, pickup point, or next direction for Bà Nà Hills.`
  - `Say this`
  - `Break it down`
  - `Good to know`
  - `Next phrases`
- Simulator proof screenshots:
  - `native-ios/artifacts/TASK-VIET-RELATIONSHIP-WORDS-LEAK-COPY-001/where-ba-na-hills-top.png`
  - `native-ios/artifacts/TASK-VIET-RELATIONSHIP-WORDS-LEAK-COPY-001/where-ba-na-hills-breakdown.png`

## Validation

- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `git diff --check`
- Native simulator build succeeded on `iPhone 17 Pro`.
- Physical iPhone build/install/launch succeeded with local-only signing overrides; repo signing files stayed clean.

## Notes

The persistent reviewer-persona update lives in `/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md`, outside this repository, so it is not part of the git commit.
