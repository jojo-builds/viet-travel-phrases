# Gate 1 Authoring Scaffold Review

Close, but not authoring-ready yet. The lane has a usable 16/6/2 split and a parseable source table, but the next translation pass would still have to infer scope across multiple files instead of following one clear pack contract.

Decision: REVISE

Conditions:
- Add an explicit authoring entrypoint in `content-draft/tagalog/README.md`. It currently says the lane is draft-only, but it does not tell the next pass which file to author from or how `README.md`, `source-notes.md`, `first-wave-priority.csv`, and `phrase-source.csv` should be used together.
- Unify first-wave status vocabulary across `content-draft/tagalog/first-wave-priority.csv` and `content-draft/tagalog/phrase-source.csv`. The current split between `promoted-core-draft` / `keep-flagged-review-needed` / `deferred-rewrite-needed` and `first-wave-promoted-core` / `first-wave-flagged-holdout` / `first-wave-deferred-rewrite` is structurally avoidable and forces cross-file interpretation.
- Fix `content-draft/tagalog/scenario-plan.json` so `quickPhraseIds` only reference rows that are actually in the authoring-ready set. It still includes `tagalog-polite-basics-4`, which both source files mark as deferred, and also points at `tagalog-polite-basics-1`, which is still only `drafted`.
- Leave behind one bounded authoring surface for the next pass: either make `phrase-source.csv` the single filterable source-of-truth for the first-wave working set, or document an exact phrase-id contract that removes any need to guess between promoted core, holdouts, deferred rewrites, and the wider drafted backlog.
