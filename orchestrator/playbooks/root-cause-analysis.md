# Root Cause Analysis Playbook

Use this for SpeakLocal bug hunts, symptom reports, regressions, freezes, jitter,
repeated failures, weird UX behavior, and "why is this happening?" tasks.

This playbook does not replace `superpowers:systematic-debugging`, native
simulator proof, focused tests, review gates, or phone builds. It is the
SpeakLocal receipt format that keeps root-cause work evidence-backed and prevents
symptom fixes from erasing product behavior.

## Worker Contract

Start from the observed symptom in Jojo's or the user's language. Do not rename
the problem into an implementation guess until evidence supports it.

Before editing code or data:

- reproduce the symptom or capture enough evidence to explain why direct
  reproduction is not practical;
- identify the route, screen, device, simulator, build, task, command, or data
  surface involved;
- check current worktree state and recent relevant changes;
- separate the symptom, proximate cause, root cause, and contributing factors;
- write a compact Five Whys ladder where each why is evidence-backed or clearly
  marked as a hypothesis.

Stop the Five Whys chain when the next why would become speculation. Gather more
evidence instead of inventing a deeper cause.

## Safe Fix Rule

Fix the root cause when it is safe and scoped. If the only apparent fix removes,
hides, disables, or narrows existing product behavior, stop and escalate before
changing it.

Do not "fix" a symptom by deleting or hiding a feature, route, shelf, card,
control, content section, animation, navigation path, audio affordance, test, or
generated resource unless Jojo explicitly approved that removal.

Allowed fixes should be corrective, not subtractive:

- repair the proven source code, state, lifecycle, route, layout, data, or
  generated-resource cause;
- add a narrow guard, cache, invalidation, or fallback that preserves visible
  behavior;
- regenerate resources from current source when generated output is the proven
  issue;
- add or update focused tests so both the bug fix and the preserved feature are
  protected.

Escalate before broad architecture changes, destructive cleanup, paywall changes,
canonical route or page-ID changes, bundled audio/content removal, dirty-lane
ownership conflicts, or a fourth fix attempt after three failed hypotheses.

## RCA Receipt

Every bug-hunt result should include:

```text
Symptom:
- User-visible problem in Jojo's or the user's words.

Reproduction / Evidence:
- Steps, screenshot, failing test, log, trace, simulator proof, phone proof, or
  code/data evidence.
- If not directly reproduced, explain what evidence stands in for repro.

Five Whys:
1. Why did the symptom happen? Evidence-backed or hypothesis.
2. Why did that happen? Evidence-backed or hypothesis.
3. Why did that happen? Evidence-backed or hypothesis.
4. Why did that happen? Evidence-backed or hypothesis.
5. Why did that happen? Evidence-backed or hypothesis.

Root Cause:
- Code, data, state, lifecycle, route, generated resource, validation, or workflow
  failure that best explains the symptom.

Fix Strategy:
- Root-cause fix, mitigation, blocker, or follow-up.
- State what behavior must remain.

Regression Guard:
- Test, validator, screenshot proof, trace, or explicit reason one was not
  practical.

Validation:
- Commands, simulator/device proof, screenshots, or reviewer outcomes.

Feature Preservation:
- Affected feature still exists and nearby expected behavior still works.
- Diff audit confirms no unrelated product behavior was removed.

Follow-ups:
- Separate improvements or unresolved hypotheses, if any.
```

## Reviewer Checklist

A read-only root-cause reviewer should block if:

- the symptom was not reproduced or evidenced;
- the Five Whys chain is mostly speculation;
- the fix masks the symptom instead of addressing the named root cause;
- the fix removes, hides, disables, or narrows existing product behavior without
  explicit approval;
- no regression guard, validation proof, or honest blocker is present.

For visible app changes, add a feature-preservation reviewer when the affected
surface includes Home, Browse, Search, Practice, detail pages, audio, navigation,
or generated content.
