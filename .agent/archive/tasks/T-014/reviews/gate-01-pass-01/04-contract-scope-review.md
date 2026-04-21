Decision: APPROVE

Rationale:
- The task contract is scoped tightly to prep-only Italian lane authoring and explicitly forbids runtime wiring, app changes, ops changes, and unrelated language edits.
- Required outputs, review-gate obligations, and completion checks are concrete enough to guide execution without broad repo expansion.
- The planned path is valid if execution stays centered on the top first-wave rows, improves weak English source before translation where needed, and records explicit deferrals instead of stretching uncertain rows into false completeness.

Concrete risks:
- Scope drift into runtime or shared app surfaces if the worker treats "prepared-next" as a signal to wire Italian into the app.
- Contract failure if the pass updates translation content but does not leave all required artifacts, especially refreshed first-wave priority decisions, research backlog updates, result.md, and the full 3-gate / 4-reviewer evidence trail.
- Quality drift if weak baseline English rows are translated literally instead of being rewritten first, which would violate the source-of-truth notes even if CSV coverage increases.
- Completion overclaim if fewer than the top 20 first-wave rows are translated or consciously deferred with explicit reasons.

Concrete adjustments:
- Keep the main pass bounded to the top first-wave rows first; use the top 24 as the control set so the "20 explicitly handled" requirement is easy to verify.
- Treat any weak-fit English source as a rewrite-or-defer decision before translation, and mirror that decision in both phrase-source.csv and first-wave-priority.csv.
- Preserve prep-only boundaries by limiting writes to content-draft/italian/** plus the task-local review/result artifacts, with no runtime registry or app-shell edits.
- Before advancing beyond Gate 1, make the intended output checklist explicit: phrase-source.csv, first-wave-priority.csv, source-notes.md, research-backlog.md, result.md, and unanimous 4-reviewer approval for each of Gates 1-3.
