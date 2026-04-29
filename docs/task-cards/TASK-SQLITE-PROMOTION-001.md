Task Done
The Viet SQLite phrase graph is ready to be promoted from DEBUG experiment toward the normal app data path: the worker has either implemented the safe promotion pieces or documented the exact blocker, with route-level proof that Home, Search, listing pages, related links, audio references, saved/practice state, and back/forward navigation behave correctly against SQLite-backed data.

Context
T-168 completed the first DEBUG SQLite graph runtime in this worktree. It proved the current catalog fixture has 18 scenarios, 900 clusters, 919 source phrase rows, 911 canonical pages, 919 search docs, and 3,438 relation edges. The live/default app still uses JSON. Jojo wants the long-term app to behave like an offline Wikipedia-style phrase graph, so this lane should harden the SQLite runtime instead of treating it as a side experiment.

Source Truth
- `.agent/tasks/T-168/result.md`
- `docs/DATABASE_ARCHITECTURE.md` if present
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- current Swift and tests under `native-ios/`

Worker Judgment
Use GPT-5.5-level judgment. Inspect the current implementation, choose the safest path, and avoid micromanaged ceremony. If switching the default runtime is premature, do not force it; leave a clean feature flag or readiness gate with evidence.

Required Outcome
- Add the missing database/runtime hardening needed before SQLite can become the primary Viet data source.
- Add relation lookup/index improvements if current graph traversal would become weak at larger scale.
- Add route-level tests or simulator-proofable checks for SQLite-backed Home/Search/detail navigation.
- Ensure visible audio keys, canonical page IDs, aliases, related links, saved IDs, and practice-pool IDs all resolve cleanly through SQLite-backed data.
- Produce a short result note explaining whether SQLite is ready to become default now, and if not, what exact blocker remains.

Boundaries
- Work in `/Users/jojolim/Developer/products/speaklocal/app-family-native-sqlite`.
- Own the SQLite/runtime/test/docs lane.
- Do not redesign listing-page visuals.
- Do not generate ElevenLabs audio.
- Do not rewrite authored phrase copy unless a failing validation proves the data contract requires it.
- Do not touch unrelated queue tasks.

Validation
- Run the relevant SQLite fixture generator/validator.
- Run focused native tests for SQLite/search/navigation/local-state behavior.
- Run a native build.
- If practical, launch one simulator flow with SQLite enabled and capture proof.
- Run `git diff --check`.

Result Contract
Write `docs/task-results/TASK-SQLITE-PROMOTION-001.md` with:
- status: done or blocked
- commit hash
- what changed
- whether SQLite is now default-ready
- remaining blockers, if any
- validation commands and outcomes
- simulator proof path, if captured
