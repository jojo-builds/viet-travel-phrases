# Contract Scope Review

The explicit pre-edit contract can proceed inside T-021 scope. The added work on `phrase-source.csv` and `scenario-plan.json` stays within `content-draft/tagalog/**`, and the stated boundaries still preserve this as prep-only authoring hardening rather than runtime promotion.

Decision: APPROVE

Conditions:
- Keep substantive edits limited to `content-draft/tagalog/README.md`, `source-notes.md`, `first-wave-priority.csv`, `phrase-source.csv`, `scenario-plan.json`, the new `rewrite-notes.md`, and task artifacts under `.agent/tasks/T-021/**`.
- Use the unified first-wave status contract only to tighten the bounded authoring pack; do not broaden scope into new runtime claims, new release decisions, or unrelated scenario expansion.
- Restrict `quickPhraseIds` cleanup to alignment with the bounded first-wave pack so later gates can verify one coherent prep surface.
- Keep all touched draft files internally consistent so statuses, review flags, and pack membership agree across CSV, notes, and scenario metadata.
- Do not touch `app/**`, `site/**`, `ops/**`, `docs/operations/**`, runtime wiring, release/build/TestFlight files, or unrelated language lanes.

Evidence needed later:
- The rewrite pass should leave a traceable mapping from rewritten rows to source rationale and remaining review posture in `rewrite-notes.md`.
- Later gates should be able to verify that the unified first-wave contract and `quickPhraseIds` list point to the same bounded prep-only authoring set.
