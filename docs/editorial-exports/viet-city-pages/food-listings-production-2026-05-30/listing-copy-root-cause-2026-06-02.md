# Listing Copy Root Cause - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

## Current Judgment

Do not call the 520 V2.2 city listings production-ready by taste yet.

The current source can pass structure, voice-drift, what/why, render, and SQLite validation while still failing the human product job: make a first-time U.S.-based Vietnam traveler understand the place, feel the appeal, and want to remember or save it.

Validators have been useful for finding broken plumbing and obvious leaks. They have also become the wrong center of gravity. They reward absence of bad language more than presence of a strong listing.

Length is not the enemy. The next production pass should not chase a character ceiling or make pages shorter for its own sake. The gate is whether the copy earns the reader's time: a first-time U.S.-based Vietnam traveler should get orientation, specificity, and a reason to care. Longer copy is acceptable when it creates real travel value and remains readable on the phone.

## Evidence From Current Source

Current inventory: 520 first-class V2.2 city/place source objects in `content-draft/viet/city-library/app-detail-v2-2/`.

Measured from visible source fields:

- visible copy per listing: min 136 words, p10 155, median 171, p90 191, max 231;
- intro body length: min 18 words, p10 22, median 25, p90 30, max 41;
- section count: median 4;
- section body word total: median 84 words;
- 122 pages have high formula-risk vocabulary density around terms such as `stop`, `pause`, `pace`, `room`, `rhythm`, `moment`, `enough`, `simple`, and `practical`.

Examples that validate but are not satisfying enough:

- `city-hanoi-place-vietnam-art-gallery`: repeats small/light/interior/calm across four modules, leaving little reason to care about the gallery itself.
- `city-danang-place-wonderlust`: says iced drink, table, heat break, and bright room, but not enough distinct reason to remember the cafe.
- `city-hanoi-place-hang-da-market`: gives useful market behavior, but stays at the level of "one lap, price question, small buy" instead of making the market feel specific.
- `city-hanoi-place-lam-cafe`: has stronger identity, but still repeats "simple drink / room / short sit" across modules.
- `city-danang-place-reply-1988`: has concrete facts, but the page still reads like a support cafe note instead of a listing someone would save.

## Five Whys

Symptom: listing pages validate and render, but many still feel thin, abstract, and not save-worthy.

1. Why do they feel thin?
   - The current pages often compress the listing into safe, short utility fragments. They remove obvious bad phrasing but do not add enough concrete scene, comparison, story, menu/place detail, or desire.

2. Why did the process keep compressing them?
   - Each new pass used validators and scripts to remove classes of errors: jargon, stiff phrases, missing identity, repeated banned words, render issues. Those checks reduce risk, but they do not create positive editorial value.

3. Why did validators become the production signal?
   - The work needed to cover 500+ pages, so green counts felt like the only scalable proof. The process drifted from "read and author each page" to "make every page pass a growing set of mechanical gates."

4. Why did "handwritten" not stay handwritten?
   - The source path is named `handwritten-copy`, but much of the workflow still projects, imports, validates, audits, and repairs in batches. That can preserve schema shape while eroding page-level taste. A page can be individually present in a JSON file without being individually authored to a high enough bar.

5. Why did this repeat for weeks?
   - The system lacked a hard separation between copywriting and validation. Scripts were allowed to define success, and each screenshot complaint produced another guard instead of a page-by-page editorial recovery queue. The root cause is not one bad phrase; it is a validation-led production model being asked to do a copywriter's job.

Root cause: the workflow made validators the judge of production readiness. For SpeakLocal listings, validators must become only safety checks after page-level authorship.

## Better Production Method

Use an authored-page production line:

1. Pick a small batch, usually 5 pages.
2. Read the specific page object, category, title, phrase cards, related cards, and any existing source notes.
3. Decide the one reason this page belongs in the trip: food, room, route, culture, city shape, ordering ritual, practical break, or comparison value.
4. If the page calls something city-specific, such as "Saigon style," "Hanoi style," or a local market pattern, explain the concrete local reason. Name the rhythm, ingredients, setting, neighborhood role, serving style, trade pattern, or traveler behavior that makes it belong to that city instead of Vietnam broadly.
   - "Saigon style" is not a decoration word. The visible copy must explain what makes the thing feel Saigon or Ho Chi Minh City rather than simply Vietnamese: for example sidewalk or alley seating, night-snack rhythm, small shared shellfish plates, sauces, beer or cold-drink tables, fast ordering by pointing, District/neighborhood setting, southern ingredients, or a social after-work pace. Use only the traits that are true for the page.
   - If the page cannot explain what makes the claim local, remove the city-style label and describe the place or dish more plainly.
5. Handwrite the intro and modules for that page. Do not use a generator, template, category rule, or "fix all pages like this" script.
6. Keep the mobile shape, but do not treat the mobile shape as a word-count cap. Let each module do a different job:
   - first screen: what this is and why it has a place in the trip;
   - phrase cards: real action at the place;
   - sections: what to notice, what to order/do first, how to pace the visit, what to compare or pair nearby;
   - cards: related only when a traveler would actually choose between or pair them.
7. After the prose exists, run validators only to catch breakage.
8. Render the edited batch and review screenshots for taste, not only pass/fail.

## What Must Change In Claims

Do not say "all listings are production-ready" because:

- schema validation passed;
- no hard audit findings remain;
- render screenshots exist;
- the source lives in `handwritten-copy`;
- a page has 3 or 4 sections.

Only say production-ready after every page has a page-level authored review and a rendered read that can answer:

- what is this place, dish, route, shop, market, or cultural object?
- why does it matter in this city or trip?
- what should I picture before I arrive?
- what would I do first?
- why might I save it instead of forgetting it?

## Immediate Recovery Queue

Start with the highest formula-risk pages, because they are the clearest evidence that validation did not equal authorship:

1. `city-hanoi-place-vietnam-art-gallery`
2. `city-danang-place-wonderlust`
3. `city-hanoi-place-lam-cafe`
4. `city-danang-place-reply-1988`
5. `city-hanoi-place-hang-da-market`

These five are not the whole problem. They are the first handwritten recovery batch to prove the new method.

## 2026-06-03 Addendum: Guardrails Became Thinning

New symptom: after Jojo correctly rejected label-language, some revised pages became too sparse. They avoided bad phrases, but the visible copy sometimes turned into neutral lists of actions and objects, such as walking onto a bridge, noticing timber, tiles, benches, and canal water, without enough feeling for why the place is worth remembering.

Five Whys:

1. Why did the copy become sparse?
   - The writer optimized for avoiding banned wording instead of adding the concrete context that makes the place matter.

2. Why did avoidance become the writer's main move?
   - The review gate kept adding negative examples: no label-language, no direct save instructions, no checklist prose, no abstract appreciation instructions. Those are all true, but they are defect checks, not a recipe for good copy.

3. Why did the positive standard not dominate?
   - The workflow did not require a visible positive proof before validation: what a new-to-Vietnam reader now understands, what they can picture, and why this specific page is worth remembering.

4. Why did the validator still pass?
   - Validators can catch banned wording and schema defects. They cannot prove desire, place specificity, cultural orientation, or save-worthiness.

5. Why could this keep recurring?
   - If each complaint creates only another ban, agents will keep writing around the bans. The copy will get cleaner but thinner.

Root cause: negative guardrails were being used as the main authoring method. Production-ready listing copy needs positive authorship first, with validators as cleanup only.

Better solution:

1. Before editing a page, write the page's positive proof in plain language:
   - what this place is;
   - what a first-time U.S. traveler would picture;
   - why it matters in this city or trip;
   - what phrase-card or related-card moment is real;
   - what would make someone remember it without being told to save it.
2. Then write the page from that proof. Do not start from banned-word avoidance.
3. Keep useful substance. If a sentence becomes shorter but less vivid, it is worse.
4. Use validators only after the handwritten page exists. A validator failure is a defect to repair, not an invitation to strip the page down.
5. In receipts, record the positive proof for each page, not just which scripts passed.

## 2026-06-04 Addendum: Why Review Gates Still Passed

New symptom: even with two review gates, batches could still pass with planner/reviewer language in visible copy, such as headings that describe the module job (`Group Table Reality`, `Crowd Expectations`, `Daytime Is Practical`) or sentences that explain why a phrase card belongs instead of speaking to the traveler.

Five Whys:

1. Why did the gates pass those lines?
   - The reviewer read the copy with the source object, receipts, validator output, and intended module role in mind, so internal labels still looked purposeful.

2. Why did purposeful become acceptable?
   - The gate asked for evidence that the page had an owned moment, voice proof, links, and validation. It did not force a cold extraction of only the visible words before the mechanical checks.

3. Why did the second gate not catch what the first missed?
   - Both gates shared the same context and success signal. They were checking whether the page satisfied the production system, not whether a first-time U.S. traveler could read the page without knowing the system.

4. Why did fixes drift thin afterward?
   - Once a reviewer names a bad phrase, the shortest route to green is deletion or safer generic wording. That removes the smell but can also remove the place.

5. Why would this keep wasting compute?
   - Each batch would create another negative rule, then validators and reviewers would chase symptoms. The underlying authoring order stayed the same.

Root cause: the review gates were not cold, independent, or positive-value-led. They were allowing the authoring process to judge itself.

Process correction:

1. Before writing, create a positive proof card for every page:
   - what this is;
   - why it matters here, especially for city-specific food;
   - what the traveler should picture;
   - what the real phrase-card moment is;
   - why each related or Mentioned Here card helps the trip.
2. Write from that proof, not from a banned-phrase list.
3. Before validation, run a cold visible-copy gate: extract intro title/body, every visible heading, first sentence of every section, phrase-card support text, and card subtitles. Classify each as `traveler-facing`, `module-job/rationale`, or `thin-safe`.
4. Run a heading translation pass on every `module-job/rationale` line. Translate internal labels into physical place details, table behavior, traveler actions, route objects, city traits, or sensory anchors.
5. Run an anti-thinning check. A fix cannot pass by deleting useful context, phrase cards, Mentioned Here cards, or related cards unless the receipt names the mismatch and the replacement traveler value.
6. Only then run validators. A validator failure is a safety defect; it is not permission to strip the page down.
7. If the same voice failure appears in two batches or three pages, stop adding examples and run a Five Whys/root-cause note before continuing. Then do a backward pass over recent affected pages.
