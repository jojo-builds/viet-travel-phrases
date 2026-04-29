# TASK-PRACTICE-NATIVE-MVP-001: Native Practice MVP From Real Phrase Data

## Task Done

The native app has a first usable offline Practice MVP that lets a user practice real saved/selected phrase pages with language-relevant question types, local progress, a light reward loop, and mascot-ready moments without generic quiz filler.

## Context

Practice should help users rehearse phrases they actually saved or chose from listing pages. The current product direction is an offline phrase-Wikipedia app: every quiz item should be grounded in canonical phrase/page data, audio, category context, or phrase relationships. Questions should not ask generic situation trivia that can be answered without Vietnamese.

Practice also needs a warm SpeakLocal identity. Jojo's mascot direction is a chameleon traveler that gradually camouflages into the country being learned; for Vietnam, rewards should feel like the chameleon becoming more Vietnam-coded through tasteful red/yellow/Vietnam travel motifs. Avoid punitive lives, pressure streaks, leaderboards, or noisy XP mechanics.

Run this only after the SQLite/data runtime lane is stable enough that practice can consume the canonical graph without duplicating its own mini data model.

The browser prototype is only a scratchpad. The real product proof is native SwiftUI in the simulator, using the same chrome, Liquid Glass language, app navigation, phrase data, audio behavior, and saved/practice state as the rest of the app.

## Worker Judgment

Use GPT-5.5 judgment. Design the smallest native MVP that proves the product loop and can scale later. Prefer durable data contracts and local state over hardcoded demo-only screens.

If the current browser prototype feels busy, do not port that busyness. Simplify the native UI aggressively: one clear prompt, one clear action area, calmer feedback, fewer decorative panels, and Liquid Glass surfaces that feel native rather than web-card-heavy.

## Required Outcome

- Add a native Practice surface reachable from app chrome or a clear entrypoint.
- Let users add/remove a phrase page to a local practice set.
- Generate practice prompts from real phrase/page/audio data.
- Include several language-relevant question modes, such as listen-and-pick, English-to-Vietnamese, Vietnamese-to-English, missing-word/token, pronunciation recognition by text choice, or relation/pronoun swap when data supports it.
- Store local progress enough to show missed/review candidates.
- Add a light reward/progress loop that celebrates useful practice without becoming the point of the app.
- Add mascot integration hooks and at least one visible mascot-ready moment if final mascot art is available; otherwise create a clean placeholder contract for future art.
- Lean on native Liquid Glass UI and simplify the visual hierarchy compared with the current browser prototype.
- Capture simulator screenshots of the worker's own implementation before peer review.

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
- Capture screenshots of the key native Practice states before review.
- Use one read-only peer reviewer focused on screenshots plus behavior: whether the quiz tests real Vietnamese phrase knowledge, whether local practice state is coherent, whether the UI is too busy, and whether the result feels native/Liquid Glass enough.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-PRACTICE-NATIVE-MVP-001.md` with:

- status: done or blocked;
- commit hash;
- practice modes implemented;
- reward/mascot behavior implemented or explicitly deferred with hook details;
- data sources used;
- simulator proof screenshots;
- validation commands and outcomes;
- peer review outcome;
- known product/design decisions still needed;
- recommended next task.
