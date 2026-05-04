# SpeakLocal Viet ChatGPT Editorial Batch 001 Prompt

You are filling an editorial patch packet for SpeakLocal Vietnam canonical listing pages.

## Job

- Read the `batch_001_*` snapshot tabs and fill exact patch rows only.
- Do not rewrite outside the patch templates.
- Do not use vague notes where a structured patch row is possible.
- Do not write `consider`, `maybe`, or `could` in patch rows. Propose exact content or ask Jojo a direct question.
- Keep every user-facing line for first-time travelers, beginners, offline use, and real travel confidence.
- Keep the phrase/action as the hero, not blog copy, review copy, or Yelp-style venue prose.

## Content Rules

- Do not mention AI, ChatGPT, editorial process, validators, generators, source lanes, page models, or internal terminology in user-facing copy.
- Do not invent volatile facts: prices, hours, schedules, wait times, current awards, current policies, rankings, or `best` claims.
- Use stable facts only when the source packet gives enough confidence. Otherwise write a row in `questions_for_jojo`.
- Preserve canonical `page_id` and `phrase_id` unless proposing an explicit new source-owned canonical row in the appropriate patch sheet.
- Proper names should not receive fake literal breakdowns. Use `name recognition` or a precise sourced meaning.
- No new audio is generated. Use `audio_policy` to mark exact reuse or planned missing audio.
- Default all proposed rows to `REVIEW_ONLY` until Jojo approves them.

## What To Fill

- Use `page_patch` for page-level metadata or hero/summary proposals.
- Use `section_patch` for section title/body/presentation proposals.
- Use `phrase_row_patch` for visible row additions, removals, replacements, promotion, or demotion.
- Use `breakdown_patch` for token/gloss replacement.
- Use `relationship_reorder_patch` for Explore next and graph-order changes.
- Use `renderer_directives_patch`, `asset_directives_patch`, and `validator_rules_patch` only when the page needs behavior, asset, or validation instructions.
- Use `questions_for_jojo` for product, factual, canonical-title, or native-language uncertainty.

## Reference Model

Bà Nà Hills is included as a completed journey-page reference. Read it as a model for page depth and section flow; do not re-import it unless Jojo explicitly asks.

## Import Contract

Future Codex import may import only rows where `import_approval` exactly equals `APPROVED_FOR_IMPORT`.
All other rows must remain staging-only.
