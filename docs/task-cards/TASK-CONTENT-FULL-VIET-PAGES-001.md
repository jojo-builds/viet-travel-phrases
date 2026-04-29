# TASK-CONTENT-FULL-VIET-PAGES-001: Full Viet Phrase Page Expansion Strategy And First Durable Pass

## Task Done

The repo has a scalable path from the current 150 strong Tier 1 pages toward all current Viet canonical pages feeling like useful "Different ways to say [phrase] in Vietnam" pages, with the largest safe authored/generated pass completed and validators proving the result does not introduce filler, duplicate pages, broken links, or missing visible audio references.

## Context

Jojo's direction is that a phrase is a phrase: each canonical phrase page should be a useful offline article page, not a thin row or generic fallback. The app should feel like an AI answer without runtime AI. Tier 1 is already strong; the next content question is how to raise the rest of the current Viet page universe without creating brittle hand-maintenance or duplicate source truth.

Run this after SQLite promotion if the data/runtime lane is changing generated resources. If run in parallel, stay out of generated native resources and focus on content sources, validators, and an explicit handoff.

## Worker Judgment

Use GPT-5.5 judgment. Do not stop at an audit if you can safely implement. Balance ambition with source-of-truth cleanliness: the result should make the next 900+ pages easier, not create a pile of handcrafted one-offs no one can maintain.

## Required Outcome

- Inspect the current Viet canonical page universe and classify what is already strong, acceptable, thin, duplicated, or missing.
- Improve the authoring/generation model so non-Tier-1 pages can become useful article pages while preserving uniqueness.
- Complete the largest coherent page-quality expansion that is safe in one worker session.
- Keep Tier 1 at the current quality bar.
- Keep all links canonical and Wikipedia-like.
- Keep user-facing language positive and natural; avoid internal labels like `repair`, `watch out`, `question marker`, or implementation terms.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `content-draft/viet/**`, listing-page generators/validators, content audit docs, and generated authored listing resources when not conflicting with SQLite work.
- Do not touch native Swift UI code.
- Do not generate new audio assets.
- Do not create duplicate pages for the same normalized Vietnamese phrase.

## Validation

- Run Tier 1 validator.
- Run full phrase/page/link/copy validator or add one if missing.
- Run generated resource checks if resources changed.
- Search for banned/internal user-facing terms.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-CONTENT-FULL-VIET-PAGES-001.md` with:

- status: done or blocked;
- commit hash;
- page universe counts;
- pages improved or generated;
- quality classification before/after;
- duplicate/link/audio validation counts;
- validation commands and outcomes;
- remaining path to all pages;
- recommended next task.
