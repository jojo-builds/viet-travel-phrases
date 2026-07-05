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

## Root Cause Reviewer Checklist

For bug hunts, symptom reports, repeated regressions, freezes, jitter, and other
unclear-cause tasks, use `playbooks/root-cause-analysis.md` and ask the reviewer
to challenge:

- whether the symptom was reproduced or backed by concrete evidence;
- whether the Five Whys chain separates evidence from hypothesis;
- whether the fix addresses the named root cause instead of masking the symptom;
- whether a regression test, validator, screenshot proof, trace, or explicit
  blocker exists;
- whether the affected feature and nearby expected behavior still work.

Reviewer prompt add-on:

```text
For this bug-hunt/root-cause review, do not approve a fix that removes, hides,
disables, or narrows existing product behavior unless the task explicitly
authorizes that removal. The done state must prove both: the symptom is gone or
honestly blocked, and the existing feature set still works.
```

## What Counts As Blocker

- The feature is not actually live in the app.
- It reintroduces Messages when the current task is Practice.
- It merges paywall without permission.
- It uses Expo/React Native for app work.
- It removes another finished feature.
- It fixes a symptom by deleting, hiding, disabling, or narrowing product behavior without explicit approval.
- The Five Whys/root-cause chain is speculative or not tied to evidence.
- It causes build/test failure in the touched surface.
- It ships speaker UI with no playable audio unless explicitly marked missing.

## What Is Usually Follow-Up

- Minor copy polish.
- Additional screenshots.
- Extra broad tests when focused tests pass.
- Future content expansion not required by the task.
