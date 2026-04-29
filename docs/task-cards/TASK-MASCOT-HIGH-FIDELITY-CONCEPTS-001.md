# TASK-MASCOT-HIGH-FIDELITY-CONCEPTS-001: Production-Ready Mascot Images And Native Screen Comps

## Task Done

Jojo has production-ready review images for the SpeakLocal chameleon mascot and its native app integration: the images look like they could belong in the final app, match the current SpeakLocal iOS/Liquid Glass taste, and clearly replace the rejected placeholder mascot board.

## Context

The prior `TASK-MASCOT-VISUAL-SYSTEM-001` output is not accepted as implementation design. It documented some rules, but the visuals were too crude, too flat, and did not look like the native app or final product direction. Do not build from those drawings, and do not create another HTML/CSS/SVG substitute as the final answer.

Jojo needs actual image concepts before coding: polished generated raster images and realistic iPhone screen comps that show how the mascot progresses and how it appears in Practice without making the app childish, busy, or disconnected from the existing app.

Source truth to preserve:

- `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`
- `docs/task-results/TASK-PRACTICE-REWARD-MASCOT-001.md`
- `docs/design/mascot/prompt-packet.md` for prompt starting points only
- `docs/design/NATIVE_VISUAL_REFERENCE.md` for accepted live app screenshots and visual rules
- current native app style: `Xin chào` listing page, native Home, bottom glass chrome, white readable article surfaces, restrained Vietnam accents

## Worker Judgment

Use Codex image generation directly. Load and follow the local `imagegen` skill before generating images. The intended path is built-in image generation, saved back into this repo as raster assets.

Do not use ChatGPT, browser ChatGPT, external image sites, or manual prompt handoff for this task. The point of this task is to prove what Codex can produce by itself.

If Codex image generation is unavailable or cannot produce production-ready images, block the task and explain the exact missing capability. Do not fake completion with CSS drawings, SVG mascot doodles, rough wireframes, or text-only design notes.

The worker should act like an art director. The goal is not a cute mascot in isolation; the goal is a refined app-integrated visual system that could plausibly ship in a premium native iOS app.

## Required Outcome

- Produce at least `8` production-ready raster images:
  - base chameleon traveler mascot;
  - early Vietnam progression;
  - mid Vietnam motif progression;
  - completion/high-progress mascot;
  - Practice hub iPhone screen comp;
  - normal phrase-practice prompt iPhone screen comp;
  - Practice completion iPhone screen comp;
  - listing-page `Add to practice` entry iPhone screen comp.
- Produce optional additional comps if useful:
  - sensitive-context no-mascot state.
- Images should use the current app's design language: native iOS, Liquid Glass feel, white readable surfaces, restrained red/yellow/jade accents, no busy game UI.
- Screen comps should look like screenshots from the current app, not a separate landing page, webpage, children’s game, or generic quiz app.
- Mascot art should feel premium, warm, and travel-companion-like. It can be charming, but it should not feel childish, flat, clip-art-like, or mascot-first at the expense of the language app.
- Include the exact prompts used and any external-tool notes.
- Since this task is Codex-only, record `external context sent: none`.
- Write a concise art-direction verdict: which image direction should be kept, which should be rejected, and what needs another iteration.
- Use one read-only reviewer focused on visual quality, native fit, and whether the images are good enough for Jojo to make a real design decision.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `docs/design/mascot/high-fidelity/**`, `docs/task-results/**`, and imported/generated image assets.
- Do not implement SwiftUI.
- Do not edit SQLite/runtime/content sources.
- Do not reuse the crude placeholder chameleon drawings as final art.
- Do not satisfy this task with HTML/CSS/SVG visuals as final assets. A contact sheet or local review page is allowed only as a viewer for the generated raster images.
- Do not make the mascot resemble known copyrighted characters.

## Validation

- Verify all generated image paths render locally.
- Create a Jojo-readable contact sheet or local review page showing the final images at useful sizes.
- If a review board is created, provide the local URL and server command.
- Run `git diff --check`.
- Peer-review the final image set.

## Result Contract

Write `docs/task-results/TASK-MASCOT-HIGH-FIDELITY-CONCEPTS-001.md` with:

- status: done or blocked;
- commit hash;
- image artifact paths;
- prompt packet path;
- tools used;
- context sent outside Codex, which should be `none`;
- visual verdict and recommended direction;
- peer review outcome;
- recommended next task.
