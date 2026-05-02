# TASK-NATIVE-AUDIO-TAP-RELIABILITY-001

## Task Done

Every visible speaker button plays on the first intentional tap, especially speaker buttons inside `Break it down` cards. Repeated taps should feel responsive and predictable, with no dead first tap, no need to tap two or three times, and no silent failure when the audio asset exists.

## Context

Jojo reproduced intermittent missed taps on-device:

- Page: `Cho tôi cà phê đen đá`
- Area: `Break it down`
- Token/card: `Cho tôi`
- Symptom: tapping the speaker/card sometimes does nothing on the first tap. After tapping again, sometimes two or three times, audio finally plays.
- The behavior appears more often in the `Break it down` section than on normal phrase rows.

Because audio eventually plays, treat this first as a native interaction/playback reliability bug rather than a missing-audio/content bug. Still verify the resolved audio key/path as part of root-cause investigation.

## Worker Judgment

Find the root cause before patching. Likely areas include hit testing inside horizontally scrolling breakdown cards, gesture recognizer competition, button disabled/loading state, audio-player debounce/cooldown logic, async audio preparation, repeated-player lifecycle, or an overlay intercepting taps.

Fix the underlying tap/playback path, not just this one phrase.

## Required Outcome

- Speaker buttons in breakdown cards trigger audio on the first tap when audio exists.
- Speaker buttons remain responsive after many repeated taps on the same card.
- Rapid but intentional taps do not leave the audio player stuck in a silent state.
- Missing-audio states still show the disabled/muted state intentionally and do not pretend to play.
- Normal phrase rows, hero play button, browse/search result speaker buttons, and saved/practice speaker buttons still work.
- The fix works for `Cho tôi cà phê đen đá` -> `Cho tôi` and at least two other breakdown-card examples.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Expected write scope: `native-ios/App/**`, native tests, and small task result/screenshot artifacts.
- Do not edit content JSON, generated resources, SQLite, or audio assets unless investigation proves the asset mapping is genuinely wrong.
- Do not change Apple signing/project personal settings.

## Validation

- Reproduce or instrument the missed first tap before fixing, and describe the root cause in the result.
- Add or update focused tests where practical for playback/tap state.
- Build the native app.
- Run targeted app chrome/audio/playback tests.
- Simulator-check or device-check:
  - `Cho tôi cà phê đen đá` page, `Break it down`, tap `Cho tôi` speaker/card repeatedly.
  - One short phrase breakdown page, such as `Xin chào` or `Tạm biệt`.
  - One long phrase breakdown page with horizontal cards.
- Stress tap a breakdown speaker at least 20 times with normal human timing and confirm no unresponsive taps.
- Run `git diff --check`.
- Run one focused read-only peer review for interaction reliability and regression risk.

## Result Contract

Write `docs/task-results/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001.md` with:

- root cause
- user-visible behavior fixed
- files changed
- validation run
- reviewer outcome
- remaining risks or follow-up, if any
- final `git status --short`

Commit when done.
