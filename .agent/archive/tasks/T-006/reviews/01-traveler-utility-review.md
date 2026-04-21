# Traveler Utility Review

## Focus

- Challenge whether the ranked Spain first wave solves real traveler problems quickly.

## Findings

- Payment, reservation, repair, and taxi phrases are correctly front-loaded for Spain travel reality.
- Bargaining language was originally a baseline risk for this lane, but the final scaffold now pushes those rows down and marks them `rewrite-before-translation`.
- The scaffold still lacks a dedicated pharmacy mini-set, but that is a later source-row gap rather than a blocker for this prep task.

## Required fixes

- Keep `Please let me pay` explicitly flagged for rewrite into a natural bill-request source sentence before translation.
- Keep directions rows flagged where the current English assumes generic `city center` wording instead of station / metro navigation.

## Gate decision

- Pass with fixes incorporated in `first-wave-priority.csv`, `source-notes.md`, and `research-backlog.md`.
