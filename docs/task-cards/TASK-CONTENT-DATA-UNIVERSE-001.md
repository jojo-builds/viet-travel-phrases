# TASK-CONTENT-DATA-UNIVERSE-001: Vietnam Content And Database Universe

## Task Done

Every current Vietnamese phrase in the repo has one canonical database-backed listing-page record, all phrase/page links resolve like a Wikipedia-style graph, and validators prove there are no missing canonical pages, duplicate phrase pages, broken links, banned user-facing terms, or unresolved visible audio keys.

## Worktree

Work only in this clean worktree:

`/Users/jojolim/Developer/products/speaklocal/app-family-content-data`

This worktree exists so the content/data lane can run while `T-167` owns the main native UI worktree.

## Use

- `/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md`
- `docs/content-audits/tier1-listing-pages-audit-002.md`
- `docs/DECISIONS.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `content-draft/viet/**`
- `native-ios/scripts/**`
- `native-ios/Resources/LanguagePacks/viet/**`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`

## Hard Constraints

- Do not touch `native-ios/App/**` in this worktree unless you can prove the `T-167` native UI work is already committed and the integration will not conflict. If uncertain, leave Swift runtime integration as a ready-to-merge handoff.
- Do not generate new audio assets.
- Preserve canonical IDs unless a duplicate/collision makes a rename unavoidable; document any rename with before/after mapping.
- Do not create duplicate pages for the same normalized Vietnamese phrase.
- Keep the final app model offline, deterministic, and local-first.
- Do not stop at an audit. Audit only enough to act.

## Quality Bar

- The full current phrase universe, not just Tier 1, should have canonical listing-page coverage or a clearly justified support-page status.
- Every visible phrase page should feel like a useful SpeakLocal page, not raw database filler.
- Tier 1 quality must stay at `strong 150`.
- Non-Tier-1 pages may use a scalable support-page pattern, but they must avoid placeholder copy, awkward internal wording, broken links, and fake audio.
- Search/linking should behave like a phrase Wikipedia: many surfaces can point to one canonical page, and one canonical page can link out to variants, nearby phrases, category neighbors, and likely next phrases.
- User-facing copy must avoid internal or negative labels such as `Watch out`, `repair phrase`, `Understanding Repair`, `question marker`, `warning-callout`, `watch-out`, and similar implementation language.

## Database Expectations

Reason from the current repo shape and improve it as needed. The desired result is a bundled Vietnam SQLite/read model that can support:

- canonical phrase pages;
- page sections/modules;
- phrase rows and variants;
- breakdown tokens;
- relation edges between pages/phrases;
- categories/scenarios;
- search aliases and normalized lookup;
- visible audio key references;
- validation/reporting for missing links, duplicate pages, and missing audio keys.

If the current SQLite generator already covers some of this, extend it. If it does not, design and implement the smallest durable schema/generator upgrade that gets the phrase universe into a coherent database-backed graph.

## Worker Freedom

Use GPT-5.5 reasoning to choose the implementation path. You may update generators, validators, content sources, resource outputs, docs, and reports as needed to reach Task Done. Prefer durable scripts and validators over one-off manual edits.

If reaching literally every current phrase is too large for one run, do the largest coherent implementation that moves the system to a repeatable generator/validator path, then mark Task Done incomplete with exact counts and blockers. Do not stop early because the task is large.

## Result Receipt

Write a concise receipt to:

`docs/worker-results/2026-04-29-content-data-universe.md`

The receipt is a handoff index, not a second source of truth. The committed repo files are authoritative.

Include:

- commit hash;
- whether Task Done is complete;
- total phrase rows discovered;
- total canonical listing pages produced/resolved;
- Tier 1 final classification counts;
- non-Tier-1 coverage counts;
- database tables/schema changes;
- link/search/audio validation counts;
- files changed;
- validation commands and outcomes;
- remaining blockers, if any;
- recommended next task.

## Stop Only When

- Task Done is true and committed; or
- a real blocker prevents completion, with exact evidence, counts, and the largest safe completed subset committed.

## Before Stopping

- Run relevant generator scripts.
- Run canonical page/link/database validators.
- Search generated sources/resources for banned/internal wording.
- Run audio-key validation or produce a missing-audio queue/report without generating audio.
- Run `git diff --check`.
- Verify `native-ios/App/**` is untouched unless explicitly justified as conflict-safe.
- Commit the work on this branch.
