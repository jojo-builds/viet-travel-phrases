# T-166 Result: Saved And Practice Personalization Contract

Status: done

## Summary

Folded the saved/practice-pool product steer into durable planning truth. The contract now says SpeakLocal should treat saved phrases, practice-selected phrases, recently opened pages, practiced prompts, and missed items as local private user-state signals that personalize Home, Explore/category rows, and Practice through deterministic offline ranking over the bundled phrase graph.

## Files Changed

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/design/practice-quiz-concepts/README.md`
- `docs/design/homepage-research/README.md`
- `docs/DECISIONS.md`
- `.agent/tasks/T-166/state.json`
- `.agent/tasks/T-166/result.md`
- `.agent/tasks/T-166/reviews/**`

## Decisions Locked In

- Practice is phrase-sourced: `Add to practice` belongs on phrase pages and eligible phrase rows, and `My practice phrases` is a first-class Practice source/filter.
- The selected phrase, row, relation target, or breakdown token is always the correct-answer target; graph-nearby phrases are distractors or recommendations, not replacement targets.
- Bundled phrase graph data stays read-only. Saved, recent, practice-pool, practiced, missed, due, and filter state belongs in mutable local app-container state.
- Home has two honest states: first launch uses curated essentials; returning-user Home can rank from saved/practice-selected items, missed/due review, recent pages, graph-nearby suggestions, then curated fallbacks.
- Runtime remains offline, private, deterministic, and non-AI.

## Future Options

- Cloud sync, accounts, remote analytics, speech recognition, typed-answer parsing, and public gamification remain deferred.
- Home-facing practice entry should land only after separate practice generator and native Practice UI tasks produce accepted deck/local-state outputs.

## Validation

- `python3 .agent/queue_tool.py heartbeat --task-id T-166 --session-id "codex-automation-20260428T202738Z-77149" --phase "post-claim-heartbeat" --lease-minutes 180`: pass.
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`: pass.
- `git diff --check`: pass after removing trailing whitespace.
- Markdown/source path sanity check: pass for T-166-owned changed docs; no new local artifact paths were introduced.
- Changed-doc review pass: completed; the Gate 3 pass-1 clarity blocker was fixed by separating Home practice-entry ownership from practice generator/native Practice UI ownership.

## Review Artifacts

- Gate 1 latest approved pass: `.agent/tasks/T-166/reviews/gate-01-pass-01/`
- Gate 2 latest approved pass: `.agent/tasks/T-166/reviews/gate-02-pass-01/`
- Gate 3 blocked pass retained for traceability: `.agent/tasks/T-166/reviews/gate-03-pass-01/`
- Gate 3 latest approved pass: `.agent/tasks/T-166/reviews/gate-03-pass-02/`

Latest-pass approvals include `Approval: APPROVE` for all required reviewer lanes.

## Remaining Risks

- Concurrent T-165 work is active in the same worktree. The T-166 commit must stage only T-166 docs and task files, leaving T-165/native files and mixed queue-index changes unstaged.
- The docs are implementation-ready, but no SwiftUI, SQLite runtime, generated practice deck, or local persistence implementation was included in this task.

## Recommended Next Tasks

1. Add local recent/saved/practice-pool page and phrase ID persistence with canonical ID storage and no dead empty shelves.
2. Implement native `HomeView` V1 with first-launch essentials and returning-user shelves backed only by real state.
3. Generate deterministic practice decks from phrase/page/audio IDs, then implement the native Practice UI and page/row `Add to practice` entrypoints as separate scoped tasks.
4. Add the Home-facing practice entry only after generator and Practice UI outputs exist.

## Process Feedback

- SUGGESTION: Keep Home-facing practice entry, practice deck generation, and native Practice UI as separate queue packets so future workers do not re-own overlapping generator/UI surfaces.
