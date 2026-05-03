# TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001: Personal Phrase Rehearsal Practice

## Task Done

The native Practice tab is rebuilt around personal phrase rehearsal: missed prompts first, then Add-to-Practice phrases, then saved/recent phrase pages, with audio-first trip practice as the fallback when the user has no personal queue.

## Context

Source truth:

- `docs/research/practice-learning-loop-001/README.md`
- `docs/task-results/TASK-PRACTICE-LEARNING-LOOP-RD-001.md`
- existing native Practice MVP and polish result docs

The research direction is clear: Practice should not feel like generic quiz/travel trivia. It should help a first-time traveler rehearse real Vietnamese phrases they saved, missed, heard, or intentionally added from phrase pages.

Keep the bottom tab label `Practice`, but use clearer in-flow language such as `Review missed`, `Rehearse saved phrases`, and `Trip practice`.

## Worker Judgment

Use GPT-5.5 judgment. Preserve the useful native Practice foundations, but change the product flow so the user's own phrases are the center. Keep the implementation native, offline, source-anchored, and calm.

Do not copy Duolingo-style pressure mechanics. This app should feel like a premium travel phrasebook helping the user get ready, not a game demanding streaks, XP, hearts, lives, or leaderboards.

If Jojo steers naming or flow after seeing the plan, record the accepted change in the result doc before final closeout.

## Required Outcome

- Reorder the Practice hub around this priority:
  1. missed prompts due for review;
  2. phrases explicitly added to Practice;
  3. saved or recent phrase pages;
  4. trip/city/category practice fallback.
- Make the first personal session short and useful: usually 3-5 prompts.
- Prefer audio-first prompt sequencing when a phrase has audio.
- Keep valid language-relevant question types:
  - listening choice;
  - English-to-Vietnamese;
  - Vietnamese-to-English;
  - missing-token / phrase rebuild only after exposure and only with useful authored breakdown tokens.
- Remove or reframe `Bucket List` as a main learning label.
- Make missed answers feel helpful:
  - show the correct Vietnamese phrase;
  - replay audio when available;
  - explain the fit briefly;
  - link back to the source page;
  - save calmly for review.
- Make completion summarize phrase readiness, practiced phrases, and prompts saved for review.
- Keep Melo restrained as a Practice companion only where it supports the phrase rehearsal loop.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own native Practice UI, Practice state/ranking, prompt selection/sequencing, Practice tests, screenshots, and result docs.
- Do not add runtime AI, network calls, accounts, analytics, streaks, XP, hearts/lives, leaderboards, or scored pronunciation.
- Do not generate audio.
- Do not redesign unrelated Home/Browse/Search chrome except where Practice navigation requires a small integration fix.
- Do not rewrite broad phrase content.

## Validation

- Run focused native tests for Practice model/state behavior and App chrome impacts.
- Add or update tests proving:
  - missed prompts outrank added/saved/fallback prompts;
  - Add-to-Practice phrases produce personal rehearsal candidates;
  - saved/recent pages can feed Practice without generic trivia;
  - trip practice remains available as fallback;
  - wrong-answer continuation works reliably;
  - no answer subtitle leak returns.
- Build and launch the app.
- Capture screenshots or simulator proof for the main Practice states.
- Use one focused read-only peer reviewer before commit. Reviewer should check that Practice now teaches real Vietnamese phrase readiness, feels understandable to a first-time traveler, avoids pressure-game mechanics, and stays native/offline.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001.md` with:

- status: done or blocked;
- commit hash;
- what changed in the Practice user flow;
- how missed, added, saved/recent, and trip fallback queues now work;
- question types kept, changed, rejected, or deferred;
- screenshots/proof paths;
- validation commands and outcomes;
- peer review outcome;
- open product questions for Jojo;
- recommended next task.
