# Worker Goal: Visible Copy And Legacy-Language Audit

Objective: audit the active native iOS app for visible labels that do not match the current SpeakLocal Practice-first direction.

Scope:

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Treat `native-ios/` as the app surface.
- Keep paywall isolated.
- Default to read-only. Report exact file/line/screenshot/test evidence before suggesting edits.

Audit surfaces:

- Home, Browse, Browse category pages, city pages, Search, Saved, Practice, Practice scenario flows, phrase/detail pages, food/drink menu pages.
- Top, middle, and bottom of long pages.

Look specifically for:

- retired feature labels: `Messages`, `Quick conversations`, unclear `conversation` copy, contact-like labels for Practice cards;
- labels that route to Practice but do not say Practice or scenario;
- old app-internal terms visible to users;
- awkward section titles, repeated headings, generic labels, or labels that do not match the tap destination.

Deliverable:

- Write a report under `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/visible-copy-worker-report.md`.
- Include `HARD_BLOCK`, `SAFE_FIX_NOW`, `FOLLOW_UP`, or `ACCEPTED_TEMPORARY_RISK` for each finding.
- Include exact source paths and suggested replacement copy for safe fixes.

