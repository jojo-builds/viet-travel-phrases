# TASK-VIET-CANONICAL-CONTENT-AUDIT-001: Full Viet Canonical Page Quality Audit And Repair

## Task Done

Every current Viet canonical phrase page has been audited from top to bottom for
traveler usefulness, beginner-friendliness, human copy quality, page-flow order,
phrase selection, canonical linking, and flagship-depth completeness. Safe
content/source repairs are implemented and regenerated; any pages that still
need Jojo judgment are listed with evidence and recommended action.

## Context

SpeakLocal Vietnam has grown quickly. The current canonical page universe is now
around `3,038` pages, but the worker must discover the live count from the repo
instead of trusting this number.

Jojo's standard for all phrase pages:

- every phrase page should feel like a thoughtful offline answer to
  "Different ways to say [PHRASE] in Vietnam";
- all canonical pages should have flagship depth, not "support article" or
  thin filler treatment;
- copy should be first-time-traveler friendly, beginner-friendly, warm, positive,
  and practical;
- no robotic, placeholder, internal, professional-jargon, or overly AI-sounding
  wording;
- page sections should flow in a learning order from setup to phrase usage to
  variants, breakdown, local nuance, and next exploration;
- phrase rows should make sense together and link to canonical phrase pages when
  they teach something useful;
- generated copy should not quietly degrade accepted flagship pages such as
  `Xin chào`.

Source truth to preserve:

- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/research/R_AND_D_LANE.md` only for evidence/reporting discipline
- `docs/content-audits/`
- `docs/task-results/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001.md`
- `content-draft/viet/**`
- `native-ios/scripts/*viet*`
- `scripts/practice/generate-viet-practice-deck.js`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/viet-authored-listing-pages.json`

Use the local `speaklocal-listing-pages` skill as the content quality standard.

## Worker Judgment

This is a large reasoning task. Do not shrink it into a sample audit. Audit every
current canonical page.

Use GPT-5.5 judgment to decide what is safe to repair directly versus what needs
Jojo review. The goal is not to rewrite everything for the sake of rewriting; the
goal is to catch pages that feel thin, incoherent, generic, awkward, robotic,
wrongly ordered, not travel-forward, not beginner-friendly, or not useful as a
learning page.

Per-page reasoning should be saved as structured artifacts, not pasted into one
huge Markdown wall. A JSONL or CSV audit table is appropriate if it includes
enough detail for another agent to inspect page-level decisions.

## Required Outcome

Produce a durable audit and repair lane under:

```text
docs/content-audits/viet-canonical-content-audit-001/
```

The audit must include:

- live canonical page count and source of truth used;
- per-page quality verdict for every canonical page;
- per-page issue flags for at least:
  - thin/incomplete page;
  - robotic or placeholder-like copy;
  - not first-time-traveler friendly;
  - not beginner-friendly;
  - awkward or overly professional wording;
  - poor top-to-bottom learning flow;
  - bad or unhelpful breakdown;
  - phrase rows that do not belong together;
  - missing or weak canonical links;
  - duplicate/alias/canonical collision risk;
  - accepted flagship page regression risk;
- safe repair pass for task-owned content/source issues;
- regenerated app resources and SQLite/practice artifacts when source changes
  require it;
- final audit after repair showing pass/fail counts;
- a short human-readable summary of the most important patterns found;
- a remaining-review list for anything not safe to auto-fix.

Safe repairs may include:

- rewriting awkward or robotic page copy;
- improving section order when the page learning flow is clearly wrong;
- replacing internal labels or overly technical copy with traveler language;
- repairing weak breakdown labels and phrase-row subtitles;
- improving explore-next/related phrase choices when the canonical graph makes a
  better option obvious;
- fixing duplicate canonical collisions in source data when the intended
  canonical page is clear.

Do not treat validator pass as proof of content quality. The worker must read and
reason about the page content itself.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `content-draft/viet/**`, content/practice generator scripts only when
  needed for durable fixes, generated Viet resources, `docs/content-audits/**`,
  and `docs/task-results/TASK-VIET-CANONICAL-CONTENT-AUDIT-001.md`.
- Do not edit `native-ios/App/**`.
- Do not edit Xcode project files or signing settings.
- Do not generate or modify audio files.
- Do not implement UI changes.
- Do not create a second page for an already-canonical Vietnamese phrase.
- Do not replace source-authored pages with shallow generic template output.

## Validation

Run the relevant generators and validators after repairs. At minimum, validation
should cover:

- Viet catalog generation;
- authored listing page generation;
- Viet SQLite fixture generation;
- practice deck generation when practice-facing data changes;
- canonical duplicate checks;
- page-quality audit;
- banned/internal wording scans across source and generated app resources;
- SQLite fixture tests;
- practice deck tests if practice data changed;
- `git diff --check`.

Use two focused read-only reviewers near the end:

- reviewer 1: first-time traveler UX, beginner learning flow, human copy quality,
  positive tone;
- reviewer 2: canonical graph integrity, generated artifact consistency,
  offline-app efficiency, and no unnecessary over-engineering.

Reviewers should inspect both the summary and representative page-level audit
records. Repair any clear findings before closeout.

## Result Contract

Write `docs/task-results/TASK-VIET-CANONICAL-CONTENT-AUDIT-001.md` with:

- status: done or blocked;
- commit hash;
- starting and final canonical page count;
- audit artifact paths;
- repaired page count;
- pages still needing Jojo review, grouped by reason;
- examples of before/after copy improvements;
- validation commands and outcomes;
- peer review outcomes;
- recommended next task.
