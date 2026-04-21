## Summary
- The original Gate 1 language-risk issue is resolved enough to advance.
- The lane now has row-level rewrite guidance, row-level review flags, and a ranked first-wave queue instead of only theme-level notes.
- The main language-risk blocker has been reduced to normal downstream translation risk rather than a planning-gap blocker.

## Checks
- `phrase-source.csv` exists, is non-empty, and now provides a 70-row scaffold with per-row status and review flags.
- `first-wave-priority.csv` exists, is non-empty, and gives the next translation pass a concrete ranked start point.
- `source-notes.md` now binds the France-specific register and rewrite decisions to specific rows, including the sensitive ones.
- `research-backlog.md` shifts from generic prep to concrete next-pass work and later review gates.
- `README.md` now frames the lane as prep-only but authoring-ready.
- `scenario-plan.json` still preserves the shared 10-scenario seam.

## Risks
- Pronunciation coverage is still intentionally blank, so the next pass must apply a consistent helper rule.
- Expert-review rows remain deferred, but they are now clearly marked instead of being hidden in prose.
- `coffee-shop-4` is still a weak-fit row and should stay rewrite-or-retire before translation.

## Approval
- The language-risk concern that blocked Gate 1 pass 01 is resolved well enough to advance.

Approval: APPROVE
