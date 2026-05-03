# TASK-VIET-EDITORIAL-PILOT-IMPORT-001: ChatGPT Editorial Pilot Review and Import Path

## Task Done

The ChatGPT editorial pilot is safely folded into the Viet content workflow: the 20 proposed rows are reviewed against current source, the importer path for approved editorial rows is implemented or specified with blocking detail, the highest-risk validators are added, and only rows explicitly marked `APPROVED_FOR_IMPORT` are imported into authored sources and regenerated resources.

## Context

Source truth:

- `docs/editorial-exports/viet-canonical-pages/latest/`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-pilot-2026-05-03/SpeakLocal_Vietnam_Editorial_Pilot_Patch_v1.json`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-pilot-2026-05-03/SpeakLocal_Codex_Editorial_Implementation_Brief_v1.md`
- `docs/task-results/TASK-VIET-EDITORIAL-EXPORT-001.md`

The ChatGPT pilot is useful human editorial input, not repo source truth. Its rows are currently `READY_FOR_JOJO_REVIEW` and `REVIEW_ONLY`. Do not import review-only rows.

## Worker Judgment

Use GPT-5.5 judgment. Treat this as an editorial workflow task, not another content generator. The goal is to preserve human-edited specificity while keeping repo-owned source files, validation, SQLite generation, and audio queues disciplined.

Before importing anything, show Jojo a compact recommendation: which pilot rows look safe to approve, which need research, and which should be revised. If Jojo approves a subset, record that accepted approval in the result doc and import only that subset.

## Required Outcome

- Review all 20 pilot rows against the current canonical source pages.
- Classify each pilot row as:
  - safe to approve;
  - needs Jojo wording decision;
  - needs factual research;
  - needs source/data model work before import;
  - reject/defer.
- Implement or precisely specify the importer path for approved editorial patch rows:
  - source files remain canonical;
  - stable `page_id`, `phrase_id`, `source_lane`, and source path identity are preserved;
  - only `APPROVED_FOR_IMPORT` rows can change source content;
  - regenerated JSON, SQLite, practice artifacts, and audit outputs come from source files after import.
- Add the highest-risk validators from the brief where practical in this task:
  - wrong breakdown dictionary/context;
  - template mismatch by `pageKind` / `placeKind` / `contentRole`;
  - irrelevant relationship-word sections;
  - clipped route/ticket phrase requiring a speakable full sentence.
- Keep restaurant, dish, place, street, route, ticket, and politeness models distinct. Do not collapse them back into generic place copy.
- Preserve missing-audio discipline: no new audio files; changed rows reuse exact normalized audio only when valid, otherwise enter the planned missing-audio queue.
- Write a result artifact that Jojo can read without opening the patch JSON.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own content source/import scripts, validators, generated Viet resources, audit docs, and task result docs.
- Do not edit `native-ios/App/**`, native UI tests, Xcode signing/project files, or `native-ios/Resources/Audio/**`.
- Do not import rows marked `REVIEW_ONLY`.
- Do not invent factual claims about restaurants, hours, prices, awards, routes, or policies.
- Do not use the Google Sheet as source truth; it is editorial staging only.

## Validation

- Run the editorial importer in dry-run mode before any import.
- If rows are approved and imported, regenerate the relevant Viet catalog/authored pages/SQLite/practice artifacts from source.
- Run validators for city library, SQLite fixture, canonical content audit, page quality, Tier 1 pages, practice deck if touched, and the new validator checks.
- Run broad scans for wrong-template phrases, irrelevant relationship sections, clipped route labels, and known bad breakdown labels from the pilot brief.
- Run `git diff --check`.
- Use one focused read-only peer reviewer for editorial usefulness plus graph/resource integrity.

## Result Contract

Write `docs/task-results/TASK-VIET-EDITORIAL-PILOT-IMPORT-001.md` with:

- status: done or blocked;
- commit hash;
- pilot rows reviewed and classification counts;
- rows approved/imported, if any;
- rows deferred and why;
- validators added or explicitly deferred;
- regenerated resources and validation outcomes;
- audio impact;
- peer review outcome;
- recommended next editorial batch.
