# TASK-VIET-CONTENT-PRACTICE-EXPANSION-001: Expand The Viet Page Graph And Practice-Ready Phrase Coverage

## Task Done

The Viet content universe grows from the current SQLite-backed `1,688` canonical pages toward the full flagship page graph, with at least `1,250` net-new real travel-useful canonical pages added in this run, every new and touched page using the flagship listing-page standard, and Practice gaining enough phrase coverage to build meaningful phrase-first quizzes without generic travel trivia.

Done means:

- final canonical page count is at least `2,938`, unless blocked with evidence that the repo lacks enough real travel-useful candidates;
- all newly added pages use the full "Different ways to say [phrase] in Vietnam" article standard, not support/baseline/thin/fallback copy;
- all pre-existing pages touched by the expansion remain or become flagship-quality article pages;
- new phrase rows introduced by pages resolve to one canonical page each;
- no duplicate canonical Vietnamese phrase pages are introduced;
- Practice-relevant source coverage is meaningfully expanded for listen-and-pick, English-to-Vietnamese, Vietnamese-to-English, missing-token, city/destination, pronoun/social, polite/register, and likely-reply drills;
- all missing audio needs are collected into one deduped queue, with no ElevenLabs generation in this task;
- the result includes a Jojo-readable audit of what changed, what Practice can now use, and what remains.

## Context

Jojo wants SpeakLocal to feel like a Wikipedia-style offline phrase graph. A phrase is a phrase: if a user sees it and taps it, it should open a useful canonical listing page. No visible phrase should feel like a half page.

The current repo state after the city expansion is approximately:

- `1,688` canonical Viet pages;
- `1,696` phrases;
- `750` missing audio audit rows, mostly city-library audio;
- SQLite is the default native runtime;
- Practice MVP exists and uses phrase/page/audio/city data from the bundled SQLite graph;
- city coverage now includes HCMC, Hanoi, Da Nang, Hoi An, and Hue.

This task is the next content push after `TASK-VIET-2000-FULL-LISTING-PAGES-001`, `TASK-VIET-PAGE-QUALITY-RECOVERY-001`, `VIET_CITY_PHRASE_LIBRARY_750_EXPANSION`, and `TASK-PRACTICE-NATIVE-MVP-001`.

## Worker Judgment

Use GPT-5.5 reasoning. This is intentionally a large Content + Listing Pages task. Do not shrink it to a tiny batch unless you hit a real blocker.

Before implementing, ask Jojo any clarifying questions needed and show a compact plan. If Jojo steers the plan in the worker thread, record the accepted steer in the result artifact before final closeout.

Choose the expansion strategy after inspecting the repo. Good candidates may include practice-heavy phrase families, likely replies, distractor-friendly near-neighbor phrases, destination/city phrases, pronoun variants, polite/register variants, clarification phrases, follow-up questions, and short beginner phrases that make Practice feel useful.

Keep the content human and traveler-forward. The app copy should feel like a thoughtful offline answer to "Different ways to say [phrase] in Vietnam," not a generated database filler page.

## Required Outcome

- Add at least `1,250` net-new canonical phrase pages.
- Raise the app closer to a full flagship page graph, with no new lower-depth page class.
- Expand phrase families that make Practice better, especially:
  - short beginner phrases that are easy to hear and choose;
  - phrase pairs with useful distractors;
  - likely replies and follow-ups;
  - pronoun and relationship variants;
  - city/destination phrases;
  - polite/register variants;
  - missing-token-friendly phrases with clear reusable chunks.
- Keep `Break it down` correct and useful across new pages:
  - meaningful chunks;
  - no identical one-card repeat of the full phrase;
  - no internal labels like `question marker`, `key word`, `phrase ending`, `repair`, `support`, `baseline`, or `fallback`.
- Preserve the accepted listing-page visual/content rhythm:
  - hero phrase and playable main phrase when audio exists;
  - At a glance;
  - quick/standard phrase section;
  - Break it down;
  - variants, replies, follow-ups, or nearby forms;
  - When to use it;
  - positive local/travel note;
  - Explore next and bottom browse/category shelf.
- Ensure Practice has a clear handoff:
  - what new pages/phrases are best for quiz prompts;
  - what needs audio before it can become listen-and-pick;
  - what should be used as distractors;
  - what city/pronoun/register buckets were improved.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- This is for the `Content + Listing Pages` lane.
- Own Viet content sources, generated Viet resources, content generators, validators, SQLite fixture/resource generation, practice deck source outputs when needed, tests, audits, and result docs.
- Do not redesign SwiftUI UI.
- Do not generate new ElevenLabs audio.
- Do not hand-edit generated files without updating durable sources/generators.
- Do not create fake phrase padding just to hit the count.

## Validation

Run or add validation proving:

- final canonical page count and net-new count;
- every new/touched canonical page has the flagship article contract;
- every visible phrase row resolves to a canonical page;
- no duplicate canonical normalized Vietnamese phrase pages;
- no banned/internal user-facing wording;
- `Break it down` sections are useful and do not collapse into repeated full phrases;
- all visible audio keys resolve or are listed in one deduped missing-audio queue;
- representative exact Vietnamese and English search targets resolve to canonical pages;
- Practice deck/sample generation still passes, if practice sources are touched;
- SQLite fixture generation and validation pass;
- Tier 1 validation still passes;
- `git diff --check` passes.

Use one focused peer reviewer near the end. The reviewer must check:

- first-time traveler learning flow;
- copy quality and positive tone;
- canonical graph / Practice usefulness / audio queue integrity.

Use a second reviewer only if the first review surfaces a separate technical risk.

Capture or reference screenshots for representative pages if simulator/runtime resources changed:

- one original flagship page;
- one newly added beginner phrase;
- one city/destination phrase;
- one pronoun/social phrase;
- one Practice-useful phrase with likely distractors;
- one long phrase with a multi-card breakdown;
- one bottom browse/category shelf.

## Result Contract

Write `docs/task-results/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001.md` with:

- status: done or blocked;
- commit hash;
- starting and final canonical page counts;
- number of net-new pages;
- number of pages upgraded or touched;
- what practice-ready coverage was added;
- best new phrase families for Practice;
- missing audio queue path and count;
- duplicate/link/copy/breakdown validation counts;
- validator/test commands and outcomes;
- screenshot paths or reason screenshots were not needed;
- peer review outcome;
- accepted Jojo steers from the worker-thread planning conversation;
- recommended next task.
