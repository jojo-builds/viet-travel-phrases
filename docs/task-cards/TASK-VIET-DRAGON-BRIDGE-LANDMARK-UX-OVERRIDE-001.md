# TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001

## Task Done

Import the ChatGPT Dragon Bridge UX/copy override only if it passes agent review and live rendered-page review, then add validator guardrails that prevent internal content-model wording from leaking into landmark pages.

Done means the Dragon Bridge listing page reads like a traveler task page, not a content-system article. Jojo should be able to search `Cầu Rồng` on the phone and see sections organized around what a traveler is trying to do.

## Context

ChatGPT produced a focused REVIEW_ONLY override after Jojo rejected the current Dragon Bridge copy as too internal/model-shaped.

Raw incoming files are committed here:

`docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/incoming-chatgpt/`

The override proposes this landmark page shape:

- `Start here`
- `Say the name`
- `Getting there`
- `At the bridge`
- `Meeting or pickup`
- `What the name means`
- `Good to know`
- `Nearby needs` / `Explore next`

It also proposes validator rules to block user-facing terms such as:

- `place name`
- `anchor`
- `useful moments`
- `where-question`
- `route phrase`
- `connect to`
- `this page`
- `relationship rows`

This task follows the Batch 001 import work:

- `docs/task-results/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001.md`
- commit `78ab7b94`

The Batch 001 import result reported the current runtime/family page ID for Dragon Bridge as `viet-family-city-danang-place-dragon-bridge`, while the patch uses `viet-phrase-city-danang-place-dragon-bridge`. Resolve this alias safely; do not blindly string-match the wrong page.

## Worker Judgment

Treat this as a small surgical override plus durable validator hardening.

The direction is approved: landmark pages should be organized by traveler tasks, not generic phrase-page headings. Still, review the exact patch before import. If a row introduces unresolved canonical links, duplicate pages, weak Vietnamese, or unsupported renderer behavior, skip that row or the page and document why.

Do not broaden this into a full city/place rewrite. If the patch proves the landmark template needs wider support, write a follow-up task recommendation after this page is correct.

## Required Outcome

Preserve the raw override files unchanged. Create task-owned approval/import artifacts under:

`docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/`

Review and, if safe, import the Dragon Bridge override:

- page metadata / template profile;
- exact section copy and ordering;
- phrase row grouping;
- renderer directive if supported;
- validator rules that block internal landmark-page wording.

Expected traveler-facing content direction:

- `Start here`: Dragon Bridge is recognized as `Cầu Rồng`; say or show it when getting there, meeting nearby, asking where it is, or asking for a photo.
- `Say the name`: short name first, map pin if needed.
- `Getting there`: rows such as `Đi cầu Rồng`, `Cầu Rồng ở đâu?`.
- `At the bridge`: photo/help rows.
- `Meeting or pickup`: drop-off, stop, meet nearby rows.
- `What the name means`: `Cầu = bridge`, `Rồng = dragon`.
- `Good to know`: practical meeting/pickup advice, not a database note.
- `Nearby needs`: lower-priority ATM/eat-near rows only after the core landmark actions.

If the patch references new linked phrases such as `ves-drop-near-dragon-bridge` or `city-danang-stop-dragon-bridge`, only import them if they resolve cleanly or are source-owned canonical rows with planned audio. Do not create duplicate phrase pages.

## Boundaries

- Do not ask Jojo to read CSVs or Sheets.
- Do not import REVIEW_ONLY rows blindly.
- Do not rewrite rejected rows yourself.
- Do not regenerate or add audio.
- Do not add or replace images.
- Do not touch signing/provisioning files.
- Avoid `native-ios/App/**` changes unless strictly required to render task-based landmark sections; if touched, justify and validate.
- Do not overwrite old broad editorial exports.
- Do not expand this into all landmarks in this task.

## Validation

Run a dry-run import first. Validation should prove:

- patch schema is valid;
- Dragon Bridge page ID alias resolves to the real canonical/runtime page;
- only agent-approved rows would apply;
- linked phrase rows resolve exactly once or are safely source-owned;
- no duplicate normalized Vietnamese pages are introduced;
- internal terms are blocked from user-facing landmark copy;
- generic landmark section headings like `Use it with` and `When to use it` are absent from the rendered Dragon Bridge page;
- generated resources regenerate from source paths only;
- SQLite validates;
- canonical content/page-quality audits pass;
- relevant city/listing validators pass;
- `git diff --check` passes;
- audio resources, signing/project settings, and unrelated native UI files are unchanged.

Build/run the native simulator and capture live proof screenshots for:

- top of `Cầu Rồng`;
- mid-page showing `Getting there` / `At the bridge`;
- lower page showing `Meeting or pickup`, `What the name means`, and `Good to know`.

Have a read-only reviewer read the rendered page top to bottom and confirm it feels human, practical, first-time-traveler oriented, and free of internal/model wording.

## Result Contract

Write:

`docs/task-results/TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001.md`

Include:

- incoming override paths;
- imported rows and skipped rows;
- any alias resolution details;
- validator-rule changes;
- validation results;
- live screenshot paths;
- reviewer outcome;
- proof that no audio/images/signing settings changed;
- final `git status --short`;
- exact phone search term for Jojo.

Commit only task-owned import/source/validator/generated-resource/proof/result artifacts.
