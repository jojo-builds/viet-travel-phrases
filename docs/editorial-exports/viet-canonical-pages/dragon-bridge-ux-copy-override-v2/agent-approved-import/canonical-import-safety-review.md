# Canonical / Import Safety Review

Task: `TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001`

Reviewer: read-only agent gate

Outcome: APPROVE

Safety evidence:

- Incoming patch schema is importable: `page_patch` 1 row, `section_patch` 11 rows, `phrase_row_patch` 8 rows, `renderer_directives_patch` 1 row, and `validator_rules_patch` 3 rows.
- All incoming rows remain `REVIEW_ONLY` / `REVIEW_ONLY`.
- Patch page ID `viet-phrase-city-danang-place-dragon-bridge` resolves by `phrase_id=city-danang-place-dragon-bridge` to the current generated authored page `viet-family-city-danang-place-dragon-bridge`.
- All visible `target_phrase_id` rows resolve exactly once in the current catalog and authored pages:
  - `city-danang-place-dragon-bridge`
  - `city-danang-go-dragon-bridge`
  - `city-danang-where-dragon-bridge`
  - `ves-drop-near-dragon-bridge`
  - `city-danang-stop-dragon-bridge`
  - `ves-take-photo-for-me`
  - `city-danang-atm-dragon-bridge`
  - `city-danang-eat-near-dragon-bridge`
- No duplicate Vietnamese canonical pages would be created.
- No audio generation, image generation, native UI edit, Xcode project edit, signing edit, or provisioning edit is required.
- Validator guardrails are importable as review rows: `ban_internal_place_copy_terms`, `landmark_page_task_headings`, and `plain_traveler_sentence_test`.

Import requirement: resolve through `phrase_id` and the current canonical family mapping. Do not create a new authored page keyed literally by the stale `viet-phrase-*` patch page ID.
