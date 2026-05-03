# TASK-PRACTICE-LEARNING-LOOP-RD-001: Rethink Practice As Phrase Learning

## Task Done

SpeakLocal has a research-backed Practice direction that explains what the Practice area should teach, how saved/selected phrases feed it, which quiz modes are worth building, what to remove from the current confusing flow, and what the next native implementation should look like for first-time travelers learning real Vietnamese phrases.

## Context

Jojo has tested the current native Practice MVP and does not want to keep using it. The experience feels confusing, the questions do not feel useful enough, and the flow does not clearly help a traveler learn phrases. Practice is likely to become an important part of the app, so this needs product research and design reasoning before more implementation polish.

Existing product direction:

- SpeakLocal is an offline, premium travel phrasebook with Wikipedia-style phrase pages.
- Practice should teach Vietnamese phrases, not generic travel trivia.
- Users can save phrase pages and add phrases to a practice pool.
- Practice should use real canonical phrases, phrase rows, audio, breakdown pieces, pronunciation, context, saved phrases, missed phrases, city/category intent, and onboarding level where useful.
- The app should stay calm, useful, beginner-friendly, and positive. Avoid punitive lives, noisy streak pressure, public leaderboards, generic XP, or game mechanics that distract from speaking locally.
- Mascot/Melo may support Practice as a restrained companion, but Practice cannot depend on mascot art to be useful.

## Worker Judgment

Use GPT-5.5 judgment. This is not an implementation task. Think like a product researcher, learning designer, and premium native iOS product strategist.

Do broad enough research to avoid copying bad quiz patterns. Look at language-learning products, phrasebook apps, spaced-repetition tools, traveler workflows, user complaints/reviews where available, and saved-item practice patterns. Use external sources when useful, including Reddit, app reviews, YouTube/video digests, competitor docs/screenshots, and learning-science references. Prefer evidence over vibes.

## Required Outcome

- Diagnose why the current Practice experience is confusing or weak, using the current app artifacts/screens/results where available.
- Research how strong language apps and phrase tools handle practice, review, saved items, audio recognition, translation choices, recall, mistakes, and progression.
- Identify user pain points with common language-app quiz systems, especially where they feel like trivia, memorization noise, fake gamification, or disconnected from real travel use.
- Define 3 to 5 possible SpeakLocal Practice directions, with tradeoffs:
  - minimal useful MVP;
  - saved-phrase rehearsal;
  - audio-first travel phrase practice;
  - city/category trip prep;
  - onboarding placement/leveling if recommended.
- Recommend one primary direction for the next native implementation pass.
- Define which question types should stay, change, or be removed.
- Explain how Practice should use:
  - saved phrases;
  - add-to-practice phrases;
  - missed phrases;
  - phrase listing pages;
  - audio;
  - breakdown tokens;
  - city/category pages;
  - onboarding level or destination if helpful.
- Propose a first-session flow, returning-session flow, missed-answer flow, and end-of-session flow.
- Provide wording recommendations: whether the app should say `Practice`, `Rehearse`, `Review`, `Trip practice`, or another label, and why.
- Produce a Jojo-readable report with options, recommendation, screenshots/links where useful, and a clear implementation handoff.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own research docs, screenshots, task result docs, and optional local review artifacts.
- Do not edit native Swift app code.
- Do not edit generated content, SQLite resources, audio files, or Xcode project files.
- Do not generate final mascot art.
- Do not create a new practice prototype unless a tiny static diagram or screenshot board is needed to explain the recommendation.

## Validation

- Save research outputs under `docs/research/practice-learning-loop-001/`.
- Include source links and dates for external research.
- Include a fold-in recommendation section that says exactly what should change in the app next.
- Use one focused peer reviewer near the end. Reviewer should check whether the recommendation is grounded in phrase learning, avoids generic quiz/trivia patterns, fits first-time travelers, and gives Native UI enough direction.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-PRACTICE-LEARNING-LOOP-RD-001.md` with:

- status: done or blocked;
- commit hash;
- current Practice diagnosis;
- research sources and artifacts;
- recommended Practice direction;
- rejected or risky quiz patterns;
- proposed question types;
- saved/add-to-practice/missed-phrase flow;
- onboarding/destination/level recommendation;
- native implementation handoff;
- peer review outcome;
- validation commands and outcomes;
- open questions for Jojo.
