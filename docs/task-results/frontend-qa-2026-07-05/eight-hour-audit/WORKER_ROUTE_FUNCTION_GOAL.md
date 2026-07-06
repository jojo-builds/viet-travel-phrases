# Worker Goal: Route And Button Function Audit

Objective: exercise active user flows across the native iOS app and find buttons, cards, tabs, section pills, back/forward paths, saves, audio controls, and Practice launches that do not behave as the label implies.

Scope:

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Keep paywall isolated.
- Prefer simulator/UI proof and source tracing.
- Default to read-only unless the orchestrator explicitly asks for an implementation handoff.

Audit surfaces:

- Home shelves and cards.
- Browse root, menu guides, category pages, city pages, city Browse-by links, scenario/practice rails.
- Search field, search results, result chips, category/city handoffs.
- Saved save/unsave loops.
- Practice topic entry, saved practice, scenario practice, close/back behavior.
- Phrase/detail pages, audio speed, more menu, speaker buttons.

Deliverable:

- Write `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/route-function-worker-report.md`.
- For each issue, include exact reproduction steps, expected behavior, actual behavior, severity, and suggested focused test.

