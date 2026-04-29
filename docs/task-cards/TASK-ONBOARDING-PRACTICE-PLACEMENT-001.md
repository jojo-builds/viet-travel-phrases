# TASK-ONBOARDING-PRACTICE-PLACEMENT-001: Onboarding Placement Quiz And Local User Level

## Task Done

SpeakLocal has a native onboarding placement flow that uses a short phrase-based quiz to set a local user level (`beginner`, `intermediate`, or `advanced`), stores that preference privately on device, and uses it to personalize Home, Search, Browse, Practice, and phrase recommendations without changing the app's offline promise.

## Context

Jojo wants onboarding to do real product work. Instead of only explaining the app, onboarding can ask a few language-relevant practice questions and use the result to personalize the experience. A beginner should see safer essential phrases first; an intermediate user can see more situational and relationship/pronoun variants; an advanced user can get more nuanced local phrasing, repair paths, and deeper article rows.

This should be a placement check, not a test that embarrasses the user. Users must be able to change the level later in Settings. The result should guide ranking and defaults, not lock content away.

Privacy/offline stance:

- The level and quiz answers should be stored locally only.
- Do not send placement answers, skill level, practice history, or preferences off device.
- Keep bundled SQLite read-only; store mutable user profile/progress in local app state such as UserDefaults or a separate local writable store.

Apple reference: Apple says app privacy labels concern data collected from the app; "collect" means transmitting data off device in a way the developer or partners can access beyond real-time servicing. Apple also says data processed only on device is not collected and does not need to be disclosed in App Store Connect answers.

## Worker Judgment

Use GPT-5.5 judgment. Design and implement the smallest native onboarding placement loop that proves the concept and can grow later. Use real phrase/practice data from the SQLite-backed phrase graph where practical. Avoid generic travel common-sense questions.

If Practice MVP is not present yet, build the placement flow as a reusable subset that can later feed the Practice prompt engine. If Practice MVP is present, share models and prompt logic instead of creating a second quiz system.

## Required Outcome

- Add a native onboarding placement flow, or document the exact blocker if current app architecture has no onboarding entrypoint.
- Use 3 to 5 language-relevant questions that require Vietnamese phrase recognition or phrase choice.
- Score into `beginner`, `intermediate`, or `advanced` with friendly copy.
- Persist the selected/inferred level locally and privately.
- Add a Settings or debug-accessible way to change/reset the level.
- Use the level in at least one visible ranking/default behavior, such as Home phrase ordering, Practice starter deck, or Search/Browse recommendation order.
- Keep the flow skippable and editable.
- Add tests for local level storage and ranking behavior.
- Capture simulator screenshots of onboarding placement and the resulting personalized surface.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own native onboarding/profile/preference UI, local user profile state, tests, and docs/result artifacts.
- Do not collect or transmit placement data.
- Do not add accounts, analytics, remote config, or networking.
- Do not redesign the whole Practice MVP unless this is intentionally merged with a Practice implementation task.
- Do not generate new audio or images.

## Validation

- Run relevant native tests.
- Build and launch the app.
- Simulator-test first-run onboarding, skip/change/reset level, and one personalized surface.
- Verify no network dependency is introduced.
- Use one read-only reviewer focused on privacy/offline fit, user tone, and whether the level actually affects the experience.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-ONBOARDING-PRACTICE-PLACEMENT-001.md` with:

- status: done or blocked;
- commit hash;
- level model and scoring behavior;
- storage location and privacy/offline explanation;
- personalization behavior implemented;
- screenshots captured;
- validation commands and outcomes;
- peer review outcome;
- recommended next task.
