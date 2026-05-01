# TASK-ONBOARDING-UTILITY-FIRST-DESIGN-001: Utility-First Trial Onboarding Design

## Task Done

SpeakLocal has a production-quality visual design packet for first-run Vietnam onboarding that shows traveler value before the 7-day trial paywall, supports phrase/practice personalization, and reflects the current native iOS Liquid Glass app direction. The packet is ready for Jojo visual review and later native implementation planning.

## Context

Existing onboarding design exists at `docs/design/onboarding/first-run-vietnam/`, but new research from `docs/research/video-digests/onboarding-flows-1460-001/README.md` changes the design bar:

- onboarding length is less important than reaching first value quickly;
- the app should show real traveler utility before explaining too much;
- personalization questions are worth asking only when they visibly change what the user sees next;
- Practice can appear during onboarding only if it teaches real Vietnamese phrase recognition, not generic travel trivia;
- permissions/account prompts should not appear before trust;
- SpeakLocal should stay calm, premium, native iOS, offline, and travel-first.

Jojo's business direction is **free trial then paid, no ongoing free tier**. The design may show a short pre-trial preview/demo of value, but it must not imply a permanent free tier or "continue limited preview" product mode unless Jojo later approves that.

## Worker Judgment

Use GPT-5.5 judgment. Do not simply redraw the old onboarding packet. Compare the old packet, the Mobbin onboarding digest, and current app screenshots/reference shots, then design the strongest first-run flow for a first-time Vietnam traveler.

Prefer a few high-quality, production-feeling screens over many busy screens. The design should look like it belongs inside the current SpeakLocal native app: scenic Vietnam masthead, white content field, Liquid Glass chrome, warm red/gold accents, and restrained Melo/chameleon use.

## Required Outcome

Create a new design packet under:

`docs/design/onboarding/utility-first-trial-vietnam/`

Include:

- a Jojo-readable `README.md`;
- an `index.html` gallery;
- a `prompt-packet.md` documenting design intent and generation prompts;
- high-resolution PNG storyboard sheets and/or individual screen PNGs;
- a clear recommendation section choosing the best flow.

Design at least two flow options:

1. **Recommended utility-first flow**
   - Welcome/value promise using a real phrase moment.
   - Destination/city focus if it immediately changes recommendations.
   - Tiny phrase/practice placement moment using real Vietnamese, skippable and positive.
   - Personalized preview showing what changed from the user's choices.
   - 7-day free trial paywall, with no free-tier language.

2. **Compact alternate flow**
   - Fewer screens.
   - Still shows phrase/audio/practice value before the trial ask.
   - Still avoids generic feature-tour slides.

For each flow, show:

- screen order;
- what the user does on each screen;
- why the screen earns its place;
- what data is stored locally, if any;
- where the 7-day trial paywall appears;
- how the user can skip placement without feeling punished;
- how Melo appears without becoming childish or cluttering controls.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- This is a design/research artifact task only.
- Do not edit native Swift code.
- Do not edit app resources or generated content.
- Do not create a free-tier design.
- Do not use generic travel trivia in quiz/practice screens.
- Do not add account, analytics, notification, or permission prompts unless the design explicitly explains why they are delayed or absent.

## Validation

- Open the gallery locally and verify all images render.
- Verify every referenced local asset exists.
- Run `git diff --check`.
- Use one focused read-only peer review for:
  - native iOS/Liquid Glass fit;
  - first-time traveler clarity;
  - no free-tier ambiguity;
  - no generic feature tour;
  - Practice/placement relevance to Vietnamese phrases.

## Result Contract

Write `docs/task-results/TASK-ONBOARDING-UTILITY-FIRST-DESIGN-001.md` with:

- status: done or blocked;
- commit hash;
- design packet path;
- gallery URL/path;
- flow recommendation;
- screens included;
- how the flow handles free trial then paid;
- how the flow uses destination/level/practice personalization;
- peer review outcome;
- validation results;
- recommended native implementation task.
