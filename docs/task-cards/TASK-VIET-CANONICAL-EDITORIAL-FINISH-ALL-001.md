# TASK-VIET-CANONICAL-EDITORIAL-FINISH-ALL-001

Task Done

Every live Viet canonical page in the app is traveler-first, human, page-type-correct, beginner-friendly, and useful in the real situation it represents. No page should read like AI slop, database architecture, validator filler, generic generated copy, editor notes, or a forced phrase-page template.

This task is not done until every current Viet canonical page is either:

- `APPROVED_LIVE`: source-owned, generated into runtime resources/SQLite, and reviewed against the traveler-first page standard; or
- `HARD_BLOCK`: blocked by a real product/legal/licensing/native-language/canonical identity issue that cannot be responsibly solved by agents.

`FOLLOW_UP` visual/audio polish is allowed, but it must not keep weak copy live. A page with safe approved copy and a missing better hero image should ship the copy and record the image as a follow-up.

Context

Jojo's actual goal is not another one-off Dragon Bridge or Bà Nà Hills fix. The goal is all app content being correct and optimized for first-time travelers.

Recent content work proved the current process is not enough:

- prior audits reported all pages passing, but live pages still showed architecture/generator language;
- landmark/place pages were forced through phrase-page structures;
- page copy sometimes optimized for content modeling instead of a tired traveler trying to do something;
- review gates overblocked safe improvements because of separable visual/audio dependencies;
- validators caught structure but did not prove human usefulness.

Use the current `speaklocal-listing-pages` skill and the 2026-05-05 agent review process hardening as the quality bar:

- `/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md`
- `docs/task-results/AGENT_REVIEW_PROCESS_HARDENING_2026-05-05.md`

Relevant prior work:

- `docs/task-results/TASK-VIET-CANONICAL-CONTENT-AUDIT-001.md`
- `docs/task-results/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001.md`
- `docs/task-results/TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001.md`
- `docs/task-results/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.md`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/`

Worker Judgment

This is a full editorial completion task, not a generator-polish task.

The worker should use frontier-model reasoning, focused review agents, exact patch/import machinery, validators, and rendered-page proof to finish the content universe. Do not ask Jojo to read CSVs, Sheets, patch files, or raw JSON. Jojo's review surface is the app on the phone after agents have done the first-pass quality work.

Do not use broad script-generated prose as final app copy. Scripts may export, rank, import exact patches, validate links, scan wording, and regenerate resources. Final user-facing prose must be source-owned and page-specific: either exact ChatGPT 5.5 Pro patch rows, exact agent-authored page-by-page edits, or existing source copy that passes the traveler-first review.

If the full universe is too large for one uninterrupted worker session, the worker must still create and maintain the master tracker, finish the largest coherent batch, commit it, and mark the result `PARTIAL_NOT_DONE` with the exact remaining queue and continuation prompt. Do not claim the whole content universe is done unless every page is `APPROVED_LIVE` or a true `HARD_BLOCK`.

Required Outcome

Create a durable master editorial tracker under:

```text
docs/content-audits/viet-canonical-editorial-finish-all-001/
```

The tracker must include every current Viet canonical page discovered from the live generated/SQLite source. For each page, record at least:

- page ID;
- phrase ID;
- Vietnamese title;
- English title;
- page kind / place kind / content role;
- source path;
- current rendered section order;
- current top related rows;
- issue flags;
- review status;
- reviewer/agent status;
- import/source status;
- final status: `APPROVED_LIVE`, `SAFE_FIX_NOW`, `FOLLOW_UP`, `ACCEPTED_TEMPORARY_RISK`, or `HARD_BLOCK`;
- continuation notes, if any.

Every page must be checked against a page-type contract:

- single phrase: phrase meaning, when to use it, breakdown, variants/replies/follow-ups, tone/social nuance, good-to-know, explore next;
- landmark/attraction: start here, say the name, getting there, at the place, meeting/pickup, what the name means when useful, good-to-know, nearby needs;
- restaurant: walk in, order, drinks/menu, diet/allergy when relevant, pay, get back, good-to-know;
- dish: order it, what it is, ask what is inside, make it easier, where it fits, good-to-know;
- street/driver page: tell the driver, say the street, confirm the street, get dropped off, wrong place/recovery, show-driver style rows;
- city/category hub: start here, what are you doing now, quick say, today flows, places/situations, nearby needs.

The worker must repair or reject pages with:

- internal/model words such as `place name`, `anchor`, `useful moments`, `route phrase`, `where-question`, `connect to`, `this page`, `relationship rows`, `content role`, or `page kind`;
- generic section labels on the wrong page type, such as `Use it with` on landmarks;
- placeholder breakdowns like `full phrase`, `key word`, `first name part`, `question ending`, or literal proper-name nonsense;
- rows that are technically linked but not the most useful traveler actions;
- blog/Yelp/travel-guide copy where the app should guide a real interaction;
- volatile claims such as prices, hours, schedules, wait times, current awards, current policies, or "best" claims without a stable approved source;
- repeated, robotic, or over-professional phrasing;
- visible phrase rows that do not resolve to exactly one canonical page;
- disabled/misleading audio affordances not queued or handled by current audio policy.

Use batches only as execution units. Each batch must preserve the all-pages tracker and update the final status for every page it touches.

Review Requirements

Use focused agents or reviewer passes instead of pushing review back to Jojo.

At minimum:

1. Traveler/editorial reviewer:
   - reads the page as a first-time traveler;
   - checks human wording, usefulness, section order, tone, and page-type fit;
   - classifies findings as `HARD_BLOCK`, `SAFE_FIX_NOW`, `FOLLOW_UP`, or `ACCEPTED_TEMPORARY_RISK`.

2. Canonical/import safety reviewer:
   - checks IDs, duplicate risk, linked rows, generated resources, SQLite, practice impact, audio queue, and no unapproved source drift.

3. Live/rendered page reviewer:
   - reads rendered pages or extracted rendered-page text after import/generation;
   - checks that the app surface no longer exposes internal/editorial/generator copy.

For final `APPROVED_LIVE`, a page must pass content/source review and generated/runtime review. Representative simulator screenshots are acceptable for proof, but the tracker must prove every page was reviewed at the content/runtime text level. A sample-only review is not enough for final completion.

Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own Viet content sources, editorial import/export scripts, validators, generated Viet resources, SQLite fixture/resources, practice resources if affected, audit/result artifacts, and task-specific docs.
- Do not add runtime AI/network content generation.
- Do not use broad generated prose as the final copy.
- Do not ask Jojo to manually review CSVs/Sheets/raw patches.
- Do not generate or edit audio files in this task; update missing-audio queues only.
- Do not add or replace image assets unless the task explicitly expands to a visual asset subtask. Missing better hero assets are `FOLLOW_UP`, not a reason to keep bad copy.
- Do not edit signing/provisioning settings.
- Do not create duplicate canonical pages for the same normalized Vietnamese phrase.
- Do not claim completion based only on validators, pass counts, or sample screenshots.

Validation

Run the required generators and validators after each committed import/repair batch:

- Viet catalog generation;
- authored listing page generation;
- SQLite fixture/resource generation;
- practice deck generation/check when affected;
- city library validator;
- SQLite validator;
- canonical content audit;
- page quality audit;
- Tier 1/listing validator;
- relevant editorial import/export validators;
- Node tests for touched scripts;
- broad scans for internal/model/placeholder/banned wording across source and generated app resources;
- duplicate canonical page checks;
- visible phrase-row target resolution checks;
- `git diff --check`.

When native resources or rendered app behavior changes, build the native simulator and capture representative proof across page types.

Result Contract

Write:

```text
docs/task-results/TASK-VIET-CANONICAL-EDITORIAL-FINISH-ALL-001.md
```

Include:

- status: `DONE`, `PARTIAL_NOT_DONE`, or `HARD_BLOCKED`;
- commit hash;
- live starting canonical page count;
- final canonical page count;
- tracker path;
- number of pages reviewed;
- number of pages imported/repaired;
- number of pages `APPROVED_LIVE`;
- number of pages still `SAFE_FIX_NOW`, `FOLLOW_UP`, `ACCEPTED_TEMPORARY_RISK`, or `HARD_BLOCK`;
- issue breakdown by page type;
- before/after examples from multiple page types;
- proof that Jojo did not need to review raw CSVs/Sheets;
- validation outcomes;
- reviewer outcomes;
- simulator/rendered proof paths;
- example search terms Jojo should test on the phone;
- exact continuation prompt if status is not `DONE`.

Commit the result. If status is `PARTIAL_NOT_DONE`, do not frame it as final content completion.
