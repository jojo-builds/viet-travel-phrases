# Contract Scope Review

The planned rewrite/source-hardening pass can proceed within task scope because the current Tagalog draft files already frame this lane as prep-only and draft-only, not runtime truth.

Decision: APPROVE

Conditions:
- Limit substantive edits to `content-draft/tagalog/README.md`, `content-draft/tagalog/source-notes.md`, `content-draft/tagalog/first-wave-priority.csv`, and the new `content-draft/tagalog/rewrite-notes.md`, plus required task artifacts under `.agent/tasks/T-021/**`.
- Keep every change explicitly prep-only. Do not claim runtime promotion, release readiness, or live-pack graduation.
- Preserve the bounded review surface: holdouts and deferred rewrites must stay visibly non-core unless later evidence is recorded without crossing into runtime truth.
- Keep the CSV schema parseable and mirror any status/confidence changes in the supporting notes.
- Do not touch `app/**`, `site/**`, `ops/**`, `docs/operations/**`, runtime registry wiring, release/build/TestFlight files, audio mapping outside draft notes, or unrelated language lanes.

Evidence required for later completion:
- `rewrite-notes.md` should map each rewritten or hardened row to the source issue, rewrite intent, confidence posture, and remaining review flag.
- The updated draft docs should restate draft-only posture and authoring-ready intent.
- Later gates must show unanimous 4-reviewer approval and task/result artifacts must agree on completion state.
