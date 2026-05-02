# TASK-ICON-FAMILY-DESIGN-001: SpeakLocal App Icon Family Concepts

## Task Done

Jojo can review production-ready image concepts for the SpeakLocal app icon family: Vietnam has several strong icon directions, and the family system shows how future country apps can feel related while still being distinct.

## Context

SpeakLocal will become a family of destination/language apps. The Vietnam app needs a better icon before launch, and the icon strategy should scale to future countries without becoming generic flag stickers or childish mascot badges.

The chameleon mascot may be part of the icon, but it is not automatically the answer. Compare:

- mascot-led icon;
- clean premium language/travel mark;
- hybrid icon with subtle chameleon cue;
- country-motif system that can scale across the app family.

Use current SpeakLocal source truth:

- `docs/design/NATIVE_VISUAL_REFERENCE.md`
- `docs/design/mascot/README.md`
- `docs/design/mascot/high-fidelity/README.md`
- `docs/design/onboarding/first-run-vietnam/README.md`
- `docs/design/onboarding/utility-first-trial-vietnam/README.md`
- any completed mascot-role research if available.

## Worker Judgment

Act like a brand designer and App Store conversion designer. The output must be actual rendered image concepts, not prose-only direction. Use the best available visual method in Codex; if production-ready image generation is unavailable, block honestly and provide a prompt packet that Jojo can run in ChatGPT image generation.

The icon should feel premium, native, memorable, and travel-relevant. It should not feel like a kids' app, a generic translation app, a flag sticker, a clip-art animal, or a busy badge.

## Required Outcome

Create:

```text
docs/design/app-icons/family-v1/README.md
docs/design/app-icons/family-v1/index.html
docs/task-results/TASK-ICON-FAMILY-DESIGN-001.md
```

Include rendered image assets for:

- at least `5` Vietnam icon directions;
- one family-system sheet showing Vietnam plus at least `3` future country variants;
- iPhone Home Screen mock with the strongest Vietnam candidates;
- App Store product-page mock or screenshot header showing how the icon sits with SpeakLocal branding;
- small-size legibility sheet.

The README should explain:

- which direction is strongest and why;
- whether the mascot belongs in the icon;
- what should be tested before finalizing;
- what to avoid for future country icons.

Use one focused peer reviewer for visual quality, native/premium fit, small-size legibility, and family scalability.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `docs/design/app-icons/family-v1/**` and `docs/task-results/TASK-ICON-FAMILY-DESIGN-001.md`.
- Do not edit native app code.
- Do not edit App Store metadata outside this icon design packet.
- Do not use copyrighted character references or make the mascot resemble known IP.
- Do not send private repo screenshots/context to external tools unless Jojo explicitly approves the specific transfer.

## Validation

- All image paths render from the local review page.
- Contact sheet/review page is usable in the Codex in-app browser.
- `git diff --check` passes.
- Peer review is summarized in the task result.

## Result Contract

Write `docs/task-results/TASK-ICON-FAMILY-DESIGN-001.md` with:

- status: done or blocked;
- commit hash;
- review page path;
- image artifact paths;
- tools used;
- context sent outside Codex, if any;
- recommended icon direction;
- peer review outcome;
- recommended next task.
