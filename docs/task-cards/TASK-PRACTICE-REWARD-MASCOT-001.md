# TASK-PRACTICE-REWARD-MASCOT-001: Practice Rewards And Chameleon Mascot Loop

## Task Done

SpeakLocal has a concrete Practice reward and mascot design that can be implemented natively: it motivates users to rehearse real phrase knowledge, uses the chameleon mascot tastefully, avoids negative gamification, and produces either a clickable prototype update or native-ready design assets/contracts.

## Context

Jojo's direction: the mascot is a chameleon traveler. The chameleon moves through countries, learns to speak local, and camouflages into each country's motif. For Vietnam, progress can gradually add tasteful Vietnam-coded details to the mascot or practice experience. This should feel warm and useful, not childish, punitive, or like a generic mobile game.

Practice should reward real communication readiness:

- recognizing audio;
- choosing the right Vietnamese phrase;
- knowing when a pronoun/social form fits;
- remembering phrases the user saved or added to practice;
- reviewing missed phrases calmly.

Avoid naked XP loops, public leaderboards, punitive lives, streak anxiety, and quiz questions that can be answered without Vietnamese.

## Worker Judgment

Use GPT-5.5 judgment. Think like a product designer and native iOS designer. Keep the reward loop small enough for the first native MVP, but specific enough that implementation workers know what to build.

## Required Outcome

- Define the first Practice reward loop: what the user earns, when they earn it, what it unlocks visually, and how it stays tied to phrase learning.
- Define mascot usage rules: where the chameleon appears, where it should stay absent or subdued, and how it adapts for Vietnam.
- Define completion, missed-answer, and return-to-practice moments.
- Define how saved/practice-selected phrases influence rewards and suggested practice.
- Update the browser prototype or create native-ready mock screenshots if that is the fastest useful artifact.
- Produce a short implementation handoff for the `Practice / Quiz` lane.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own practice design docs, prototype files, task-result docs, and non-runtime placeholder assets/contracts if needed.
- Do not wire broad native Swift runtime changes unless this task is explicitly merged into `TASK-PRACTICE-NATIVE-MVP-001`.
- Do not generate final mascot art unless Jojo explicitly asks for image generation.
- Do not create rewards that depend on accounts, network calls, paid currency, public rankings, or runtime AI.

## Validation

- Test the prototype or mock flow locally if one is produced.
- Use one read-only peer reviewer focused on whether the reward/mascot loop supports language learning instead of distracting from it.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-PRACTICE-REWARD-MASCOT-001.md` with:

- status: done or blocked;
- commit hash;
- reward loop summary;
- mascot usage rules;
- prototype/mock artifact paths;
- implementation handoff;
- peer review outcome;
- validation commands and outcomes;
- recommended next task.
