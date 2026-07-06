# Worker Goal: Exact-Current Phone And Device Readiness

Run time target: at least 3 hours or until exact-current phone proof is genuinely complete and documented.

## Objective

Prove whether the current `main` app can be built, installed, and launched on Jojo's current iPhone. If the phone is unavailable, narrow the blocker as far as possible without needing Jojo and produce a clean handoff.

## Starting Context

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator`.
- Live app truth is `/Users/jojolim/Developer/products/speaklocal/app-family` branch `main`.
- Current `main` baseline is `b101ed419 Record current launch validation status` unless the repo has advanced.
- Previous exact-current phone proof was pending because device tooling did not find an available paired iPhone.

## Required Reading

Read:

- `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator/playbooks/phone-build.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/operations/IOS_DEVICE_BUILDING.md`
- `/Users/jojolim/.codex/skills/speaklocal-ios-device-build/SKILL.md`

## Work Plan

1. Refresh `./scripts/status.sh`.
2. Verify `main` is clean aside from known untracked proof folders.
3. Check device availability using the existing phone-build playbook/script.
4. If the current iPhone is available, build/install/launch current `main`.
5. If the phone is unavailable, retry at sensible intervals while using the time to:
   - verify local signing hygiene;
   - run a current simulator build as fallback proof;
   - document exact next action Jojo needs to take, without exposing raw IDs.
6. Update operational docs only if live operational truth changes.

## Constraints

- Do not reveal raw device IDs, phone names, Team IDs, provisioning IDs, certificate names, or profile IDs.
- Do not commit personal signing settings.
- Do not build `feature/paywall` or any feature branch to the phone.
- Do not delete unrelated untracked proof artifacts.

## Output

Write a report to:

`/Users/jojolim/Developer/products/speaklocal/app-family/docs/task-results/parallel-goals-2026-07-05/three-hour-push/phone-device-report.md`

Include:

- repo branch and commit tested;
- build/install/launch result;
- commands or scripts used, with sensitive values redacted;
- validation fallback if phone remains unavailable;
- exact blocker and next step.
