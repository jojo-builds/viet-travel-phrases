# SpeakLocal Deep Visual QA Goal - 2026-07-05

## Objective

Run a minimum three-hour launch-blocking visual/front-end QA pass on the non-paywall SpeakLocal Vietnam iOS app. Reproduce and fix Jojo-reported defects, explain why the previous eight-hour QA pass missed them, add stronger regression gates, and validate the corrected app before phone handoff.

## User-Reported Defects

1. Practice sheet top header was clipped on physical iPhone, even though previous QA passed.
2. Breakdown page for "not spicy" shows no audio affordance on the `Không cay` card while adjacent cards show audio.
3. Browse/category -> phrase/detail -> back/back can leave a blank white pull-up canvas over the photo backdrop.
4. City pages such as Hoi An do not expose a save/favorite control.
5. City page "Browse by" cards/links do not jump or route as expected.

## Required Root-Cause Work

For every confirmed defect, write a compact Five Whys analysis:

- why the visible bug happens in product code or data
- why existing tests did not catch it
- which prior validation claim is now narrowed or invalidated
- what new automated or screenshot proof closes the gap
- what still needs human visual review

## Visual QA Rules

- Treat green XCTest as insufficient unless it verifies visible layout, navigation state, and screenshots for the exact surface.
- Speaker icons imply playable bundled audio; no missing speaker should remain on visible audio-backed phrase/breakdown cards without an explicit product reason.
- Back/forward/navigation must never leave a blank sheet, blank pull-up, or empty canvas.
- City pages with multiple sections or Browse-by cards must have verified navigation/jump behavior.
- City pages should offer save/favorite where the surrounding app model supports saved trip items.
- Do not remove glass/photo/lifted design to make tests pass.
- Keep paywall excluded.
- Keep signing local; do not write personal signing/device identifiers to repo files or reports.

## Workstreams

1. Main orchestrator: own reproduction, code fixes, integration, final validation, and phone install.
2. Read-only visual audit helper: inspect current code/tests and existing screenshots for coverage gaps and additional likely visual misses.
3. Read-only route/audio audit helper: inspect content/resource/runtime mappings for speaker affordance and section-jump coverage gaps.

Helpers should not edit files unless explicitly re-steered. They should report concise findings with file paths, suspected root cause, and recommended tests.

## Validation Targets

At minimum:

- focused reproduction or failing regression for each confirmed bug
- focused green test after each fix
- screenshot proof for repaired visual surfaces
- full relevant UI test classes for touched areas
- `git diff --check`
- signing-file hygiene check
- physical iPhone build/install/launch after app-code changes land

## Reporting

Update:

- `docs/task-results/deep-visual-qa-2026-07-05/BUG_LEDGER.md`
- `docs/operations/LATEST_VALIDATION.md` only when durable validation truth changes
- `docs/operations/APP_STATUS.md` only when app readiness truth changes

Final status must separate:

- fixed and validated
- reproduced but not yet fixed
- not reproduced
- helper findings still under review
- phone build/install/launch result
