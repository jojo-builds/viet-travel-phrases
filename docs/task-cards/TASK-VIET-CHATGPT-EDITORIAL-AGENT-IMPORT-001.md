# TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001

## Task Done

Import a completed ChatGPT 5.5 Pro editorial patch batch into the Viet canonical listing pages only after agent review proves the copy is human, traveler-first, beginner-friendly, and safe to render in the app.

Done means:

- ChatGPT's returned patch files are preserved as raw input;
- no Jojo CSV/Sheet review is required;
- two read-only review gates approve the patch before import;
- only agent-approved exact patch rows are imported;
- generated resources are regenerated and validated;
- selected updated pages are opened in the native app/simulator and read as live rendered pages;
- a final result doc lists example pages Jojo should search on the phone after the orchestrator installs the build.

If no completed ChatGPT patch files are present, stop and write the exact expected file/drop location instead of inventing or rewriting content.

## Context

This follows:

- `docs/task-cards/TASK-VIET-CHATGPT-EDITORIAL-BATCH-001.md`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/`
- `docs/task-results/TASK-VIET-CHATGPT-EDITORIAL-BATCH-001.md`

Jojo does not want to review CSVs or Google Sheets manually. The review surface for Jojo is the app itself. The workflow is now:

1. ChatGPT fills exact patch files from `chatgpt-batch-001`.
2. Codex agents review the proposed patch content.
3. Codex imports only rows that pass review.
4. Codex builds/renders pages and agents review the live pages.
5. Jojo tests example pages on the phone.

The Google Sheet may remain useful as a viewing surface, but it is not required for ChatGPT to write. Patch files are the durable handoff.

## Worker Judgment

Treat this as a controlled import and quality-gate task, not a content-authoring task.

Codex may adapt importer/validator plumbing, but final listing prose must come from ChatGPT patch rows, not from Codex-generated rewrite logic. If a ChatGPT row is vague, generic, internally worded, too blog-like, factually risky, or not importable, exclude it and document why.

Because Jojo approved skipping manual CSV review, create a task-owned approval overlay after reviewer approval. Do not mutate the raw ChatGPT patch files to make them look Jojo-approved.

## Required Outcome

Use this incoming folder for ChatGPT-returned files:

`docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/incoming-chatgpt/`

Preserve raw incoming files there. Normalize/import-ready copies may be written under:

`docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/`

Expected patch filenames are the batch templates:

- `page_patch.csv` or `.json`
- `section_patch.csv` or `.json`
- `phrase_row_patch.csv` or `.json`
- `breakdown_patch.csv` or `.json`
- `relationship_reorder_patch.csv` or `.json`
- `renderer_directives_patch.csv` or `.json`
- `asset_directives_patch.csv` or `.json`
- `validator_rules_patch.csv` or `.json`
- `questions_for_jojo.csv` or `.json`

If ChatGPT returns code blocks instead of files, save them verbatim into `incoming-chatgpt/` before normalization.

Run a pre-import review gate with two read-only reviewers:

- Reviewer A: traveler/editorial quality.
  - Read proposed user-facing copy.
  - Reject generic, stiff, AI-slop, meta/editorial, blog/Yelp, volatile-fact, or non-beginner-friendly rows.
  - Confirm the page reads for a first-time traveler trying to handle the next real situation.
- Reviewer B: canonical/import safety.
  - Check IDs, linked rows, page-kind fit, duplicate risk, renderer directives, audio/image policy, and validator coverage.
  - Confirm rows are deterministic enough to import.

Create an approval overlay only for rows both reviewers approve. Use a clear status such as `AGENT_APPROVED_FOR_IMPORT`, and map it to the existing importer approval mechanism without claiming Jojo read the rows.

Import only approved exact rows. Do not import unresolved questions, vague suggestions, or rows that require Jojo/product decisions.

After import, regenerate the necessary Viet authored resources, catalog, SQLite fixture, audits, and practice resources through the existing source/generator paths.

Then run a live-page review pass:

- Build the native app for simulator.
- Open a representative set of updated pages, including at least:
  - one restaurant;
  - one dish;
  - one journey/place page;
  - one street/driver page;
  - one airport/hotel/help or safety page.
- Capture proof screenshots or artifacts.
- Have a read-only reviewer read the rendered/live page output and approve that it feels human, helpful, first-time-traveler oriented, ordered from top to bottom, and free of placeholder/internal copy.

The final result must list example pages/search terms for Jojo to test on the phone.

## Boundaries

- Do not ask Jojo to read CSVs or Sheets for approval.
- Do not import all ChatGPT rows blindly.
- Do not rewrite rejected rows yourself.
- Do not create new canonical pages unless an approved patch row explicitly defines the source-owned target and validation proves no duplicate.
- Do not generate audio.
- Do not generate or add images unless explicitly included as approved metadata only; image creation/replacement is a separate task.
- Do not touch signing/provisioning settings.
- Avoid `native-ios/App/**` changes unless strictly required for import/render support; if touched, justify and validate.
- Do not overwrite the existing broad `latest/` editorial export just to quiet stale checks.

## Validation

Run a dry-run import before applying anything. Validation should include:

- incoming patch schema check;
- agent approval overlay check;
- import dry-run proving only approved rows would apply;
- generated Viet catalog/listing generation;
- SQLite fixture generation and validation;
- canonical content audit;
- page quality audit;
- Tier 1/listing validator;
- relevant editorial/import validators;
- practice deck check/tests if generated practice resources are affected;
- broad scan for internal/meta/placeholder wording;
- native simulator build;
- live-page proof screenshots/artifacts for representative updated pages;
- `git diff --check`;
- proof that `native-ios/Resources/Audio/**` and signing/project settings are unchanged.

Run one final read-only reviewer gate after live-page proof.

## Result Contract

Write:

`docs/task-results/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001.md`

Include:

- incoming ChatGPT artifact paths;
- raw patch row counts;
- rejected row counts and reasons;
- agent-approved row counts;
- imported page list;
- pages intentionally skipped and why;
- reviewer outcomes;
- live-page screenshot/artifact paths;
- validation results;
- proof that Jojo did not need CSV/Sheet review;
- proof of forbidden-path safety;
- final `git status --short`;
- example pages/search terms Jojo should test on the phone after device build.

Commit only approved source/import/validator/generated-resource/result artifacts.
