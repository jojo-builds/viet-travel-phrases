# TASK-MASCOT-RD-ROLE-001: Research The SpeakLocal Mascot Role

## Task Done

Jojo has an evidence-backed recommendation for whether SpeakLocal should keep, reduce, or remove the chameleon mascot, plus clear guidance for where the mascot belongs in onboarding, Practice, progress, app icon/brand, empty states, and where it should stay out of the way.

## Context

SpeakLocal is a premium native iOS travel phrasebook, not a cartoon-first language game. The mascot idea is a chameleon travel companion that adapts to each country as the user learns. Jojo likes the metaphor, but the current app usage can feel like the mascot was added after the fact. We need a grounded product decision before more mascot implementation.

Use current SpeakLocal source truth:

- `docs/design/NATIVE_VISUAL_REFERENCE.md`
- `docs/design/mascot/README.md`
- `docs/design/mascot/high-fidelity/README.md`
- `docs/design/mascot/practice-flow-storyboard/README.md`
- `docs/design/onboarding/first-run-vietnam/README.md`
- `docs/design/onboarding/utility-first-trial-vietnam/README.md`
- `docs/research/RESEARCH_LANE_NOTES.md`
- `docs/research/video-digests/**` if relevant
- `docs/task-results/**` for completed Practice/onboarding/mascot work

Jojo's current lean: keep the chameleon only if it feels like a premium guide, not a childish layer. The phrase is the hero, the audio is the action, and the mascot is optional warmth.

## Worker Judgment

Use R&D judgment, not implementation momentum. Research how mascots work in successful apps, language apps, learning apps, premium utility apps, and iOS-native products. Use public evidence from app screenshots, App Store pages, reviews, product blogs, academic/product research, Reddit/X when useful, and YouTube videos.

Use the repo's video digest workflow when a YouTube video is a useful source. Pick a small number of high-value videos rather than collecting noise. If a video is digested, store transcript/frame/report artifacts under `docs/research/video-digests/`.

This is a research and product-strategy task. Do not code the app. Do not create mascot art unless a small annotated visual reference is necessary to explain a recommendation.

## Required Outcome

Create a Jojo-readable report under:

```text
docs/research/mascot-role-001/README.md
docs/task-results/TASK-MASCOT-RD-ROLE-001.md
```

The report must answer:

- Should SpeakLocal keep the mascot, reduce it, or remove it?
- If kept, what exact role should it have in onboarding, Practice, progress/rewards, empty states, paywall/trial, app icon, App Store screenshots, and phrase pages?
- Which iOS-native product patterns argue for restraint?
- Which language/learning/product patterns argue for a mascot?
- What are the risks: childish tone, clutter, animation/accessibility, cultural cliché, conversion harm, performance, design debt?
- What mascot animation moments are worth exploring, and which should be avoided?
- What should be tested before we commit to mascot-heavy design?
- Which existing SpeakLocal mascot assets/docs should be kept, revised, or discarded?

Include a `Fold-In Recommendation` section:

- adopt now;
- design next;
- test later;
- remove/avoid;
- needs Jojo decision.

Use one focused peer reviewer to check evidence quality, iOS taste, and whether the recommendations are actionable.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `docs/research/mascot-role-001/**`, optional new `docs/research/video-digests/**` artifacts, and `docs/task-results/TASK-MASCOT-RD-ROLE-001.md`.
- Do not edit `native-ios/**`.
- Do not edit `content-draft/**`, generated SQLite/resources, audio, or app code.
- Do not send private repo screenshots/context to external ChatGPT/Deep Research unless Jojo explicitly approves the specific transfer.
- Cite public sources with links and dates.

## Validation

- Report cites sources and marks confidence levels.
- Any video digest artifacts include transcript/frame/source metadata.
- `git diff --check` passes.
- Peer review is summarized in the task result.

## Result Contract

Write `docs/task-results/TASK-MASCOT-RD-ROLE-001.md` with:

- status: done or blocked;
- commit hash;
- report path;
- source count and source categories;
- video digest artifact paths, if any;
- top recommendation;
- top 5 fold-in changes;
- what needs Jojo decision;
- peer review outcome;
- recommended next prompt or task.
