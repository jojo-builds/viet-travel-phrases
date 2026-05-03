# TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001: Scenario-First Practice Rehearsal

## Task Done

The native Practice tab becomes a scenario-first, audio-first travel rehearsal surface: short real-world conversation moments where the app sets the scene, shows what a local person might say, lets the user choose/hear/useful responses, gives calm feedback, shows what they might hear next, and offers a recovery phrase. Missed prompts, Add-to-Practice phrases, saved/recent pages, and trip/city/category content should feed these scenarios instead of becoming a school-style recall quiz.

## Context

Source truth:

- `docs/research/practice-learning-loop-001/README.md`
- `docs/task-results/TASK-PRACTICE-LEARNING-LOOP-RD-001.md`
- existing native Practice MVP and polish result docs

Product direction:

- Practice should not feel like school, flashcards, or generic travel trivia.
- The experience should feel like: "You are walking into this situation. Can you handle the next 30 seconds?"
- The core loop is `Scene -> Prompt -> Response -> Feedback -> What they might say next -> Recovery / next step`.
- Every answer choice should be a useful Vietnamese phrase, not a random wrong filler answer.
- Let users hear and rehearse before they feel tested.
- The strongest product phrase is `Scenario Mode`, but keep the bottom tab label `Practice` unless Jojo explicitly approves a bottom-chrome rename. In-flow language can use `Scenario Mode`, `Travel rehearsal`, `Review missed`, `Rehearse saved phrases`, and `Trip practice`.

## Worker Judgment

Use GPT-5.5 judgment. Preserve the useful native Practice foundations, but change the product flow so practice feels like guided travel conversation, not a test. Keep the implementation native, offline, source-anchored, and calm.

Do not copy Duolingo-style pressure mechanics. This app should feel like a premium travel phrasebook helping the user get ready, not a game demanding streaks, XP, hearts, lives, or leaderboards.

Before implementation, show Jojo a compact plan and ask only the clarifying questions needed to lock the first Scenario Mode v1. If Jojo steers naming, flow, or scenario priority after seeing the plan, record the accepted change in the result doc before final closeout.

## Required Outcome

- Reframe the Practice hub around scenario rehearsal while preserving this source priority:
  1. missed prompts due for review;
  2. phrases explicitly added to Practice;
  3. saved or recent phrase pages;
  4. trip/city/category practice fallback.
- Make each session short and useful: usually 3-5 scenario steps.
- Create a native v1 scenario card flow with:
  - where the user is;
  - what a local person says;
  - what the user can say;
  - audio and slow audio when available;
  - save/add-to-practice where appropriate;
  - gentle feedback;
  - `what they might say next`;
  - a recovery phrase if things go sideways;
  - a clear next step in the scenario.
- Include at least three practical starter scenarios, using current content where possible:
  - Grab/taxi pickup or wrong drop-off;
  - local restaurant ordering/payment;
  - hotel/Airbnb check-in or help;
  - optionally Bà Nà Hills day, street-name practice, pharmacy/help, or emergency if the current data supports a good v1.
- Prefer audio-first prompt sequencing when a phrase has audio.
- Keep only question interactions that fit scenario rehearsal:
  - listening choice inside a real moment;
  - choose what you want to say;
  - understand what they said back;
  - phrase rebuild only after exposure and only with useful authored breakdown tokens.
- Remove or reframe interactions that feel like bare school quizzes, generic common-sense travel questions, or arbitrary wrong-answer tests.
- Remove or reframe `Bucket List` as a main learning label.
- Make missed answers feel helpful, not punitive:
  - show the correct Vietnamese phrase;
  - replay audio when available;
  - explain the fit briefly;
  - offer a simpler or more polite version when useful;
  - link back to the source page;
  - save calmly for review.
- Make completion summarize scenario readiness, practiced phrases, and prompts saved for review.
- Keep Melo restrained as a calm travel companion only where it supports confidence. No cartoon celebration overload.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own native Practice UI, Practice state/ranking, prompt selection/sequencing, Practice tests, screenshots, and result docs.
- Do not add runtime AI, network calls, accounts, analytics, streaks, XP, hearts/lives, leaderboards, or scored pronunciation.
- Do not generate audio.
- Do not redesign unrelated Home/Browse/Search chrome except where Practice navigation requires a small integration fix.
- Do not rewrite broad phrase content.
- Do not rename the bottom tab from `Practice` without Jojo approval.

## Validation

- Run focused native tests for Practice model/state behavior and App chrome impacts.
- Add or update tests proving:
  - missed prompts outrank added/saved/fallback scenario candidates;
  - Add-to-Practice phrases produce scenario/rehearsal candidates;
  - saved/recent pages can feed Practice without generic trivia or school-quiz framing;
  - trip practice remains available as fallback;
  - wrong-answer continuation works reliably;
  - scenario steps can advance after a missed or alternate response;
  - no answer subtitle leak returns.
- Build and launch the app.
- Capture screenshots or simulator proof for the main Practice / Scenario Mode states.
- Use one focused read-only peer reviewer before commit. Reviewer should check that Practice now teaches real Vietnamese phrase readiness through real situations, feels understandable to a first-time traveler, avoids pressure-game mechanics, uses useful answer choices, includes what-they-might-say-next/recovery value, and stays native/offline.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001.md` with:

- status: done or blocked;
- commit hash;
- what changed in the Practice / Scenario Mode user flow;
- the starter scenarios implemented and why;
- how missed, added, saved/recent, and trip fallback queues now feed scenarios;
- question/interactions kept, changed, rejected, or deferred;
- naming decision: bottom tab label and in-flow labels;
- screenshots/proof paths;
- validation commands and outcomes;
- peer review outcome;
- open product questions for Jojo;
- recommended next task.
