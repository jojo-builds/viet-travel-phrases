# TASK-VIET-CHATGPT-EDITORIAL-BATCH-001

## Task Done

Create the first reusable ChatGPT 5.5 Pro editorial batch packet for SpeakLocal Viet canonical pages.

Done means the repo contains a deterministic, Jojo-readable export packet with every current section and enough context for ChatGPT to fill exact editorial patch rows, plus blank patch templates that Codex can later import only after explicit Jojo approval.

This task is not a rewrite/import task. Do not author final page prose in Codex. Build the rails so ChatGPT can fill exact content.

## Context

Jojo wants the final listing pages to feel hand-reasoned for first-time travelers, not generator-shaped. The previous CSV/export was useful as a snapshot, but it did not carry enough structured instructions for:

- section suppression;
- section ordering;
- journey/scenario/category renderer behavior;
- related phrase row promotion/demotion;
- breakdown replacement;
- image/hero directives;
- missing-audio display policy;
- exact validator rules.

That gap caused Codex/content lanes to keep falling back to scripts and broad generated copy. The new workflow should be:

1. Codex exports exact current page state and patch templates.
2. ChatGPT 5.5 Pro fills exact patch rows.
3. Jojo approves selected rows.
4. Codex imports only approved rows and validates.

Relevant existing work:

- `docs/editorial-exports/viet-canonical-pages/latest/`
- Google Sheet review surface from `TASK-VIET-EDITORIAL-EXPORT-001`: `SpeakLocal Viet Canonical Pages Editorial Export 2026-05-03 v2`
- `native-ios/scripts/export-viet-editorial-review.js`
- `native-ios/scripts/import-viet-editorial-pilot.js`
- `docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/`
- `docs/task-results/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.md`
- `docs/task-results/TASK-VIET-EDITORIAL-READY-IMPORT-001.md`
- `docs/task-results/TASK-VIET-EDITORIAL-MODEL-SUPPORT-001.md`

Use the Bà Nà Hills journey patch as the proof pattern for a page-specific contract, not as permission to broadly generate content.

## Worker Judgment

Treat this as content workflow infrastructure and editorial packet design.

Codex should build/export/validate the packet and templates. Codex should not decide the final prose for the selected pages. If the current repo cannot provide a required field cleanly, add it as a blank review column or a `questions_for_jojo` row instead of inventing content.

Before implementation, ask Jojo only product questions that cannot be answered from the repo. If Jojo gives steering during planning, record the accepted steering in the result doc.

## Required Outcome

Create a new packet folder:

`docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/`

Use the existing Google Sheet review surface as the starting point if the connector/export pipeline can safely access it. Do not manually overwrite the old snapshot tabs. Either:

- create a versioned copy for `chatgpt-batch-001`; or
- add clearly versioned `batch_001_*` snapshot and patch tabs beside the existing tabs.

The local CSV/JSON packet must still exist in the repo as the durable source of the batch schema, even if Google Sheets is the working review UI.

Select an initial batch of about `25` high-value pages for ChatGPT editorial review. Prioritize pages where human reasoning matters most:

- high-value places and journey pages;
- restaurants;
- dishes;
- streets / driver-facing pages;
- city pages or city-mode anchors if present;
- airport / hotel / taxi / food allergy / help / emergency / first-day traveler pages;
- pages with known awkward copy, weak breakdowns, missing structure, or muted-audio visibility risk.

Include Bà Nà Hills as a completed reference/example if helpful, but do not spend this task re-importing it.

The packet must include both machine-readable files and a human-readable README. Use CSV where ChatGPT/Google Sheets review is expected, and JSON where preserving nested structure helps. Include all current content for the selected pages, not just summaries.

At minimum, create these source snapshot files:

- `pages.csv` and/or `pages.json`
  - page ID, phrase ID, Vietnamese title, English title, page kind, place kind, content role, city/category tags, difficulty, source path, audio status, audit status, hero image name/license status if available.
- `sections.csv` and/or `sections.json`
  - every current section in render order, section ID, title, body, presentation/type, source path, phrase-row references, breakdown references.
- `phrase_rows.csv` and/or `phrase_rows.json`
  - every visible phrase row, row order, section ID, phrase ID, Vietnamese, English, pronunciation if available, audio status, target page ID, row role/source.
- `breakdowns.csv` and/or `breakdowns.json`
  - every breakdown piece, order, token text, gloss/label, audio status, source section/page.
- `relationships.csv` and/or `relationships.json`
  - related/visible graph links, source page, target page, relationship type, order, display copy, target resolution status.
- `renderer_directives.csv` and/or `renderer_directives.json`
  - current renderer/page-kind/section-presentation behavior, hero behavior, audio-missing behavior, disabled speaker behavior if discoverable, plus blank proposed columns.
- `asset_directives.csv` and/or `asset_directives.json`
  - current hero/image state, current asset/license status if known, desired asset type, blank proposed columns.
- `validator_rules.csv` and/or `validator_rules.json`
  - current known rules plus blank proposed rule columns for ChatGPT to add exact checks.
- `review_notes.csv` and/or `review_notes.json`
  - current audit flags, Jojo notes if available, screenshot/artifact pointers if available, and unresolved questions.

Create these blank patch templates for ChatGPT to fill:

- `page_patch.csv`
- `section_patch.csv`
- `phrase_row_patch.csv`
- `breakdown_patch.csv`
- `relationship_reorder_patch.csv`
- `renderer_directives_patch.csv`
- `asset_directives_patch.csv`
- `validator_rules_patch.csv`
- `questions_for_jojo.csv`

If using Google Sheets, mirror these as versioned tabs such as:

- `batch_001_page_patch`
- `batch_001_section_patch`
- `batch_001_phrase_row_patch`
- `batch_001_breakdown_patch`
- `batch_001_relationship_reorder`
- `batch_001_renderer_directives`
- `batch_001_asset_directives`
- `batch_001_validator_rules`
- `batch_001_questions_for_jojo`

Patch templates must support exact deterministic imports later. Include columns such as:

- `patch_id`
- `page_id`
- `phrase_id`
- `review_status`
- `import_approval`
- `operation`
- `target_id`
- `target_order`
- `current_value`
- `proposed_value`
- `reason_for_change`
- `new_linked_phrase_required`
- `canonical_target_id`
- `audio_policy`
- `asset_policy`
- `validator_rule`
- `jojo_question`

Default every patch row to `REVIEW_ONLY` / not importable.

Create `CHATGPT_PROMPT.md` in the packet folder. It must tell ChatGPT 5.5 Pro:

- Fill exact patch rows only.
- Do not write vague notes where a structured patch row is possible.
- Do not say "consider", "maybe", or "could" in patch rows; either propose exact content or ask a question.
- Write for first-time travelers, beginners, offline use, and real travel confidence.
- Keep the phrase/action as the hero, not blog copy or Yelp-style reviews.
- Do not mention AI, editorial process, validators, generators, page models, or internal terminology in user-facing copy.
- Do not invent volatile facts such as prices, hours, schedules, wait times, current awards, current policies, or "best" claims.
- Preserve canonical IDs unless proposing explicit new source-owned canonical rows in the appropriate patch sheet.
- Flag unresolved factual/product questions in `questions_for_jojo.csv`.
- Default all proposed rows to `REVIEW_ONLY` until Jojo approves them.

Create `IMPORT_README.md` explaining the intended later import flow:

1. Jojo sends packet to ChatGPT.
2. ChatGPT returns completed patch files.
3. If ChatGPT edits the Google Sheet, Codex exports the versioned `batch_001_*` tabs back to the repo packet.
4. Codex runs a dry-run import against only explicit approvals.
5. Codex validates no unresolved targets, no duplicate canonical pages, no internal/meta copy, no wrong template leakage, no unapproved import rows.
6. Codex commits only approved source/import/validator/generated-resource changes.

If practical, add or extend a validator script so this packet can be checked for completeness before commit.

## Boundaries

- Do not import any new ChatGPT/content rows in this task.
- Do not rewrite canonical listing page prose in this task except instructional examples in `CHATGPT_PROMPT.md` or schema docs.
- Do not create new canonical pages.
- Do not generate or add audio.
- Do not generate or add images.
- Do not touch `native-ios/App/**`.
- Do not touch `native-ios/Resources/Audio/**`.
- Do not touch signing, provisioning, or project settings.
- Do not run a broad content generator to "improve" page copy.
- The repo remains source of truth; the packet is a staging/review contract.

## Validation

Run the existing editorial export check if still available:

```bash
node native-ios/scripts/export-viet-editorial-review.js --check
```

Add and run a focused packet validation if needed. It should prove:

- every selected page has its current sections exported;
- every exported section has its phrase rows and breakdown rows exported when present;
- every visible relationship row has a resolved or explicitly unresolved target status;
- patch templates contain required columns;
- patch templates default to `REVIEW_ONLY`;
- no generated resources were rewritten by this task;
- the Google Sheet copy/tabs, if created, match the local repo packet;
- `native-ios/App/**` is unchanged;
- `native-ios/Resources/Audio/**` is unchanged.

Also run:

```bash
git diff --check
```

Run one focused read-only peer review for:

- whether the packet gives ChatGPT enough context to fill exact content;
- whether the templates are deterministic enough for a later Codex import;
- whether the workflow prevents generator slop;
- whether the initial 25-page batch is a sensible first review set.

## Result Contract

Write:

`docs/task-results/TASK-VIET-CHATGPT-EDITORIAL-BATCH-001.md`

Include:

- selected page list and why each was selected;
- packet folder path;
- files created;
- schema summary;
- `CHATGPT_PROMPT.md` path;
- `IMPORT_README.md` path;
- validation results;
- reviewer outcome;
- proof that no content import happened;
- proof that `native-ios/App/**` and `native-ios/Resources/Audio/**` were unchanged;
- final `git status --short`;
- recommended next step for Jojo.

Commit only task-owned export/script/docs artifacts.
