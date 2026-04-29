# TASK-TESTER-QA-GATE-001: Pre-Jojo User QA Gate

## Task Done

The latest user-facing SpeakLocal change has been tested from a first-time traveler perspective, with screenshots, obvious visual/copy/flow issues found before Jojo is asked to manually test it.

## Context

Jojo does visual testing. If the app has placeholder text, robotic copy, crowded UI, clipped labels, broken audio affordances, or confusing navigation, that wastes his attention and derails the test. This lane exists to catch those issues first.

The tester should behave like a regular user trying to learn useful travel phrases, not like a developer validating implementation details.

## Worker Judgment

Use GPT-5.5 judgment. Inspect the task result or latest changed surfaces, then choose the most relevant simulator/browser flows to test. Fix only tiny low-risk issues if they are obviously in scope; otherwise write a clear bug list for the owning lane.

## Required Outcome

- Identify the changed user-facing surfaces from the task/result being tested.
- Run or inspect the relevant app/prototype.
- Capture screenshots of key states.
- Check for placeholders, internal labels, robotic copy, awkward first-time-traveler wording, visual clutter, text clipping, overlapping chrome, broken links/buttons, and audio controls that imply playback but do not work.
- Try the main happy path and at least one edge/back/exit path.
- Produce a go/no-go recommendation for Jojo's manual testing.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own QA screenshots/reports and tiny obvious fixes only.
- Do not perform broad implementation, content generation, data migrations, or redesign work.
- Do not generate new audio or final mascot art.

## Validation

- Capture screenshots for the tested states.
- Run focused build/prototype checks needed for the tested surface.
- Use one read-only peer reviewer only if the QA pass is for a large or visually sensitive feature; otherwise self-review is enough.
- Run `git diff --check` if any files changed.

## Result Contract

Write `docs/task-results/TASK-TESTER-QA-GATE-001.md` with:

- status: pass, pass-with-notes, or block-before-Jojo;
- surface tested;
- source task/result reviewed;
- screenshots captured;
- issues found, ranked P0/P1/P2;
- tiny fixes made, if any;
- validation commands and outcomes;
- recommendation for whether Jojo should test now;
- owning lane for each remaining issue.
