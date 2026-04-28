# Gate 2 Pass 1: Audio Dedupe And Asset Mapping Reviewer

Read-only review completed; no files edited.

Findings:

- `audio_asset` / `audio_usage` / `audio_text_dedupe` are mostly specified, and breakdown-token audio is covered through `audio_usage.target_kind` plus the `breakdown_token` table.
- Blocker: missing-audio audit is referenced but not specified as a concrete table/report contract. It needs fields like `target_kind`, `target_id`, `expected_text`, `source_path`, `reason`, and severity/blocking behavior.
- Blocker: speaker-icon honesty is ambiguous. The plan says speaker controls require bundled audio "or" a missing-audio audit entry, but missing audio should hide/disable the speaker icon while creating an audit row. It should also explicitly validate `audio_usage.normalized_expected_text == audio_asset.normalized_spoken_text` before a speaker icon is renderable.

Approval: BLOCK
