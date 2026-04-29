# TASK-VIET-2000-FULL-LISTING-PAGES-001: Build The Full Viet Listing Page Universe

## Task Done

The Viet app gains at least `2,000` new canonical phrase listing pages in this run, and every visible phrase in the app opens exactly one canonical full article page that feels like a flagship `Xin chào`-quality "Different ways to say [phrase] in Vietnam" answer.

Done means all of these are true:

- all existing phrases in the entire app, including the current roughly `911` canonical pages, are fully built out as flagship-depth listing pages;
- all new phrases introduced while building those pages also become canonical listing pages;
- all listing pages use the full flagship article template and have phrase-specific, human-written learner copy;
- all phrase rows on listing pages point to canonical phrase pages, and those target pages also have full Tier 1-quality article content;
- the run creates at least `2,000` net-new canonical phrase pages beyond the current checked-in universe, unless the repo has fewer than `2,000` real travel-useful phrase candidates and the worker blocks with evidence;
- every current and new canonical page is a full article page with written copy;
- every page is reviewed through a one-by-one audit for template completeness, copy quality, canonical links, and traveler usefulness;
- the app has no thin pages, no baseline pages, no support-depth pages, no generic fallback pages, no duplicate canonical pages for the same Vietnamese phrase, and no phrase rows that look tappable but fail to open a real listing page.

## Context

Jojo's rule is now explicit: there is no separate thin page class for user-visible phrases. A phrase is a phrase. If it appears in the app, tapping it should move the learner into a useful, full, offline article page.

Remove the product vocabulary and validator escape hatches around `support article`, `baseline article`, `thin page`, or similar lower-depth categories for user-visible phrase pages. Internal implementation may still need migration labels while work is in progress, but the finished app and finished audit must treat all canonical phrase pages as flagship-depth article pages.

Use the accepted `Xin chào` page as the concrete quality bar, not as greeting-specific copy to clone. The article rhythm should feel the same:

- hero phrase and playable main audio;
- `At a glance`;
- standard / quick way;
- real `Break it down`;
- useful variations, follow-ups, replies, or nearby forms;
- `When to use it`;
- positive `Good to know`, `Local tip`, or cultural/travel note;
- canonical `Explore next` links.

The labels can change by phrase. For example, a gratitude page should explain `Cảm ơn`, `Cảm ơn nhiều`, `Cảm ơn bạn`, likely replies like `Không có gì`, and what to say after help. A greeting relationship page should explain pronouns and who the phrase fits. A clarification page should explain what question form to use and when.

Known failures that this task must close:

- `Cảm ơn` currently exists but does not feel as fully built out as `Xin chào`.
- Rows such as `Bạn khỏe không?`, `Đi đâu đấy?`, `Rất vui được gặp bạn`, `Chào anh`, `Chào chị`, `Chào em`, `Chào ông`, `Chào bà`, `Chào chú`, and `Chào cô` must open their own full article pages.
- Any phrase row inside any article must be treated the same way: if it is a phrase, it needs one canonical page.
- Previous tasks passed structural validators while still allowing support/baseline pages to feel less complete. That bar is no longer acceptable.
- The bottom listing-page browse/explore area appears to have regressed from the richer category-shelf design. The worker must preserve or restore the accepted category-shelf experience while expanding content.

Current repo facts from recent audits may be stale but useful starting points: the app recently had about `919` source phrase rows and `911` canonical pages. Those existing pages must be upgraded to flagship depth too. They are not grandfathered in, and they are not allowed to remain support/baseline pages. Building them out should naturally introduce useful variant/reply/follow-up/related phrases; at least `2,000` of those new phrases should become new canonical full article pages in this run.

## Worker Judgment

Use GPT-5.5 reasoning to reach Task Done. Do not ask for a smaller batch. Do not stop at an audit. Do not make a tiny repair. Do not preserve a thin-page tier for user-visible phrases.

Before locking the implementation plan, ask Jojo any clarifying questions needed about scope, copy depth, recursion, review expectations, or what should count as a real new phrase page. Show Jojo a compact plan for approval/steering. If Jojo changes the plan in the worker thread, record the accepted change in the result artifact or amend this task card before final closeout.

You may decide the best implementation path after inspecting the repo. The likely durable path is to upgrade the Viet content sources, generators, validators, SQLite fixture/resource generation, and authored resources together so the app runtime, search, browse, and listing pages agree.

Write good traveler-facing copy. Avoid mechanical page filling. Each page should answer the learner's likely question: "Different ways to say [English intent] in Vietnam." The copy should feel like a concise AI-style answer written into an offline app, not a database row expanded with filler.

Where a phrase is simple, keep it concise but still useful: add real usage, variations, likely replies, next phrases, and cultural/tone guidance. The page does not need greeting-specific sections, but it must feel complete.

This is recursive graph work. When building a listing page introduces a useful new phrase row, that phrase needs its own canonical listing page too. That new page should point back to prior pages when relevant and point onward to other phrase pages when useful. The result should feel like a Wikipedia-style phrase graph: connected, searchable, offline, and canonical.

## Required Outcome

- Create at least `2,000` net-new canonical Viet phrase pages using real travel-useful phrases, not duplicate padding.
- Upgrade every pre-existing canonical Viet phrase page to the same full article quality bar.
- Ensure every visible phrase row in every listing page has a canonical `detailPageID` or equivalent route to its own page.
- Ensure every canonical page has full article content at the flagship visual/content bar.
- Upgrade generated pages so no baseline/support/fallback page remains.
- Remove or rename lower-depth classifications from finished user-facing/audit language. The completed audit should not tell Jojo that some pages are merely `support`, `baseline`, `thin`, or `fallback`.
- Preserve canonical identity:
  - one normalized Vietnamese phrase should resolve to one canonical page unless there is a real separate sense that is documented;
  - aliases such as legacy family IDs, search IDs, browse IDs, and row IDs should resolve to the canonical page.
- Keep the graph Wikipedia-like:
  - pages link to related phrase pages;
  - related phrase pages link onward;
  - no dead-end placeholder pages.
- Make `Break it down` correct across the full universe:
  - meaningful reusable chunks plus full phrase;
  - no identical one-card chunk that simply repeats the full phrase;
  - no internal labels like `key word`, `phrase ending`, `question marker`, `repair`, or grammar placeholder copy.
- Keep wording positive and travel-friendly:
  - no negative/friction-first section names;
  - no robotic filler;
  - no internal implementation language.
- Produce Jojo-readable proof showing every page was checked.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- This is for the `Content + Listing Pages` lane.
- Own Viet content sources, generated Viet content resources, content generators, SQLite fixture/resource generators, validators, tests, docs, and result/audit artifacts required to complete the content universe.
- Do not redesign the SwiftUI visual system unless a small runtime/rendering fix is required to make the full pages and accepted bottom explore/category shelf visible.
- Do not generate new ElevenLabs audio in this task. Reuse existing audio keys and produce a missing-audio queue/audit for any new phrases or breakdown tokens that need audio later.
- Do not hand-edit generated files without updating the durable source/generator.
- Do not create fake phrases, duplicate phrases, or nonsense filler just to hit `2,000`.

## Validation

Add or update validators so Task Done is mechanically enforceable:

- canonical page count increased by at least `2,000` net-new pages from the pre-task baseline;
- every phrase row in all listing/article sections resolves to a canonical page;
- every canonical page has the full article contract:
  - hero phrase/audio reference;
  - non-empty `At a glance`;
  - standard/quick phrase section;
  - valid `Break it down`;
  - at least one phrase comparison/variant/follow-up/reply/nearby section;
  - `When to use it`;
  - positive local/travel note;
  - `Explore next`;
- no current or new canonical page is classified as support, baseline, thin, filler, generic fallback, or missing useful links;
- no duplicate canonical Vietnamese phrase pages;
- no banned/internal user-facing wording;
- all visible audio keys resolve or are listed in a deduped missing-audio audit;
- search exact Vietnamese and English queries return the canonical page first for representative old and new pages;
- app browse/listing relation shelves do not contain untappable phrase rows.
- the accepted listing-page bottom explore/category shelf is present for representative pages after the data expansion.

Run the relevant generators and tests, including the existing Tier 1 validator, full Viet page quality audit, SQLite fixture generation/validation, and native tests when app resources or runtime behavior change.

Use peer review before closeout from these three angles:

- first-time traveler UX: click through representative page chains and judge whether the graph feels congruent, natural, useful, and exploratory for learning phrases;
- copy quality and learning flow: check that page copy teaches the phrase, feels human-friendly, uplifting, positive, and informative, does not sound robotic or internally generated, and flows top-to-bottom in a natural learning order;
- technical efficiency: check that the content/data/code path is not over-engineered, stays lightweight and fast for an offline app, and uses the database cleanly without unnecessary duplication.

The review must check Task Done directly, including the one-by-one page audit. This cannot be a sample-only review. Keep the review practical: one reviewer may cover multiple angles if thorough, but the result must explicitly report all three angles.

For the copy/learning-flow review, the reviewer must read representative pages from top to bottom and confirm the sequence feels like a lesson: what the phrase means, why it matters, how it breaks down, when to use it, useful variants/replies, local/travel note, then where to explore next. If the order feels scrambled or repetitive, the task is not done.

Capture screenshots or simulator proof for representative pages:

- `Xin chào`;
- `Cảm ơn`;
- one of `Bạn khỏe không?` / `Đi đâu đấy?`;
- one relationship greeting such as `Chào anh`;
- one new phrase created in this expansion;
- one long phrase with a multi-card breakdown.
- one page scrolled to the bottom explore/category shelf.

## Result Contract

Write `docs/task-results/TASK-VIET-2000-FULL-LISTING-PAGES-001.md` with:

- status: done or blocked;
- commit hash;
- final canonical page count;
- final phrase row count;
- number of new pages created;
- number of pages upgraded from lower-depth or generated fallback behavior to full flagship article quality;
- audit artifact paths;
- duplicate/canonical/link/audio validation counts;
- missing audio queue count and path, if any;
- validator/test commands and outcomes;
- screenshot paths;
- peer review outcomes for first-time traveler UX, copy quality/learning flow, and technical efficiency;
- accepted Jojo steers or plan changes made during the worker-thread planning conversation;
- any blocker that prevents reaching at least `2,000` full pages.
