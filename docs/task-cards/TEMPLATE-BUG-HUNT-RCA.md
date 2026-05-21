# TEMPLATE-BUG-HUNT-RCA

## Task Done

[Name the user-visible symptom in Jojo's or the user's words, and state the
intended fixed behavior. The done state must prove both that the symptom is gone
or honestly blocked and that the affected feature still exists.]

## Context

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Use `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator/playbooks/root-cause-analysis.md`.
- Use `superpowers:systematic-debugging` for the technical debugging process.
- Symptom:
- Known route/screen/device/simulator:
- Recent related task, branch, or change, if known:

## Worker Judgment

Find the root cause before patching. Reproduce the symptom or capture enough
evidence to explain why direct reproduction is not practical.

Use Five Whys as a compact evidence ladder, not as hidden reasoning. Each why
must be evidence-backed or marked as a hypothesis.

Do not fix the symptom by deleting, hiding, disabling, or narrowing existing
product behavior. If the apparent fix requires removing a feature, route,
control, content surface, audio affordance, animation, navigation path, generated
resource, or test, stop and escalate.

## Required Outcome

- The symptom is fixed or the blocker is documented with evidence.
- The root cause is tied to code, data, state, lifecycle, route, generated
  resource, validation, or workflow.
- Nearby expected behavior still works.
- Existing user-facing features remain available unless Jojo explicitly approved
  their removal.
- A regression guard exists when practical.

## Root Cause Analysis

Write an RCA receipt in the task result with:

- symptom in user-visible language;
- reproduction or evidence;
- Five Whys summary, with each why evidence-backed or marked as hypothesis;
- root cause;
- fix strategy: root-cause fix, mitigation, blocker, or follow-up;
- regression guard;
- validation;
- feature preservation proof;
- follow-ups.

## Boundaries

- Allowed write scope:
- Must not touch:
- Paywall is excluded unless Jojo explicitly includes it.
- Do not change Apple signing or personal project settings.
- Do not overwrite unrelated dirty work or active lanes.

## Validation

- Run `git diff --check`.
- Run focused tests, validators, builds, simulator checks, screenshots, traces, or
  phone checks appropriate to the touched surface.
- For native app changes, prove the affected route/screen behavior in simulator
  or on device when practical.
- Run one read-only root-cause reviewer for meaningful bug hunts.
- Add a feature-preservation reviewer when visible app behavior changed.

## Result Contract

Write `docs/task-results/[TASK-ID].md` with:

- RCA receipt;
- user-visible behavior fixed or blocked;
- files changed;
- validation run;
- reviewer outcome;
- remaining risks or follow-up, if any;
- final `git status --short`.

Commit when done unless the task explicitly says to stop before commit.
