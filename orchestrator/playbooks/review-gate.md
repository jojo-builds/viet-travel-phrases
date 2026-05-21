# Review Gate Playbook

Use this before merging large, risky, or user-sensitive work.

## When To Use

- Native chrome/navigation changes.
- Home/Browse/Search/Practice UI changes.
- Content generation or phrase-audio changes.
- Merge conflicts touching shared files.
- Any task where Jojo says "deep audit", "bug hunt", "make sure", or "review gate".

## Pattern

1. Locally inspect the diff and understand intent.
2. Spawn one read-only reviewer if user explicitly permits subagents or requests a review gate.
3. Give the reviewer a concrete checklist.
4. Fix blockers.
5. Rerun focused validation.
6. Only then merge or build.

## Reviewer Checklist Template

```text
Review this SpeakLocal lane against the user's requested behavior.
Focus on blockers, overwritten features, stale branch regressions, native iOS behavior, and missing tests.
Do not edit files.
Return: Blockers, safe fixes, follow-ups, and ready/not ready.
```

## What Counts As Blocker

- The feature is not actually live in the app.
- It reintroduces Messages when the current task is Practice.
- It merges paywall without permission.
- It uses Expo/React Native for app work.
- It removes another finished feature.
- It causes build/test failure in the touched surface.
- It ships speaker UI with no playable audio unless explicitly marked missing.

## What Is Usually Follow-Up

- Minor copy polish.
- Additional screenshots.
- Extra broad tests when focused tests pass.
- Future content expansion not required by the task.
