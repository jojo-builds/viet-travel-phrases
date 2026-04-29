# TASK-PRACTICE-NATIVE-MVP-001: Native Practice MVP From Real Phrase Data

## Task Done

The native app has a first usable offline Practice MVP that lets a user practice real saved/selected phrase pages with language-relevant question types, local progress, and no generic quiz filler.

## Context

Practice should help users rehearse phrases they actually saved or chose from listing pages. The current product direction is an offline phrase-Wikipedia app: every quiz item should be grounded in canonical phrase/page data, audio, category context, or phrase relationships. Questions should not ask generic situation trivia that can be answered without Vietnamese.

Run this only after the SQLite/data runtime lane is stable enough that practice can consume the canonical graph without duplicating its own mini data model.

## Worker Judgment

Use GPT-5.5 judgment. Design the smallest native MVP that proves the product loop and can scale later. Prefer durable data contracts and local state over hardcoded demo-only screens.

## Required Outcome

- Add a native Practice surface reachable from app chrome or a clear entrypoint.
- Let users add/remove a phrase page to a local practice set.
- Generate practice prompts from real phrase/page/audio data.
- Include several language-relevant question modes, such as listen-and-pick, English-to-Vietnamese, Vietnamese-to-English, missing-word/token, pronunciation recognition by text choice, or relation/pronoun swap when data supports it.
- Store local progress enough to show missed/review candidates.
- Keep mascot/reward hooks as a clean placeholder contract if final mascot art is not present.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own native Practice UI, local practice state, practice data adapter, tests, and docs.
- Do not redesign the listing article template.
- Do not create broad new content copy.
- Do not generate ElevenLabs audio.

## Validation

- Run native tests covering practice item generation and local practice state.
- Build and launch the app.
- Simulator-test add-to-practice from a listing page, practice session flow, answer feedback, and remove/review behavior.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-PRACTICE-NATIVE-MVP-001.md` with:

- status: done or blocked;
- commit hash;
- practice modes implemented;
- data sources used;
- simulator proof screenshots;
- validation commands and outcomes;
- known product/design decisions still needed;
- recommended next task.
