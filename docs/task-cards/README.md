# SpeakLocal Task Cards

This folder is the default handoff surface for pinned specialist Codex threads.

## Current Rule

Do not use Codex Desktop automations for normal SpeakLocal work. They are paused until Jojo explicitly says to resume them.

Use:

- lightweight task cards here for normal worker handoffs;
- full `.agent/tasks/T-xxx` queue packets only for risky shared-runtime work, recovery/claim-state needs, or already-running queue tasks.

## Card Shape

Keep cards short and goal-driven:

```text
Task Done
Context
Worker Judgment
Required Outcome
Boundaries
Validation
Result Contract
```

## Handoff Shape

The orchestrator must give Jojo:

1. exact Codex project folder to open;
2. suggested pinned thread name;
3. tiny worker prompt.

Example:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family-practice-core.
Execute docs/task-cards/TASK-PRACTICE-CORE-001.md.
Commit when done and write the requested result.
```

The task card carries the real assignment. The chat prompt stays tiny.
