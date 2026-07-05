# Worker Goal: Deep Visual Layout Sweep

Objective: inspect the app like a traveler scrolling each page top-to-bottom, focusing on visual clipping, awkward labels, occluded controls, bottom chrome overlap, stale panel styling, and hidden mid-page regressions.

Scope:

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Keep paywall isolated.
- Use simulator screenshots where possible.
- Default to read-only and avoid committing screenshot churn.

Audit surfaces:

- Home scroll states.
- Browse category and city pages, including middle and bottom sections.
- Food/drink menu detail pages.
- Search, Saved, Practice hub, Practice sheet/scenario screens.
- All visible top admin bars, section dropdowns, audio speed controls, more menus, and bottom admin chrome.

Deliverable:

- Write `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/visual-layout-worker-report.md`.
- Include screenshot paths for issues and classify each as `HARD_BLOCK`, `SAFE_FIX_NOW`, `FOLLOW_UP`, or `ACCEPTED_TEMPORARY_RISK`.

