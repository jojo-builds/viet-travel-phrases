# SpeakLocal Task Cards

This folder is the default handoff surface for pinned specialist Codex threads.

## Current Rule

Do not use Codex Desktop automations for normal SpeakLocal work. They are paused until Jojo explicitly says to resume them.

Use:

- lightweight task cards here for normal worker handoffs;
- full `.agent/tasks/T-xxx` queue packets only for risky shared-runtime work, recovery/claim-state needs, or already-running queue tasks.

## Trunk-First Thread Setup

Default every pinned specialist thread to the same Codex project folder:

```text
/Users/jojolim/Developer/products/speaklocal/app-family
```

Use `main` as the shared trunk for normal work. Pinned threads are conversation lanes, not permanent branches or permanent worktrees.

Recommended pinned lanes:

- `Orchestrator`
- `Native UI / Simulator`
- `Content + Listing Pages`
- `SQLite / Data Runtime`
- `Practice / Quiz`
- `Tester / QA`
- `Research / Product Strategy`

Archive or unpin old worker threads that were tied to deleted side folders such as `app-family-native-sqlite`, `app-family-practice-core`, or `app-family-content-data`. If their chat history is useful, keep them archived as history, but start replacement lanes from `app-family` on `main`.

Create a branch or separate worktree only when isolation has real value:

- risky native runtime or Xcode project migration;
- long experiment that may be thrown away;
- two live worker threads would edit the same files;
- release/signing/App Store packaging;
- work that should not disturb the main simulator lane.

When a branch/worktree is used, the task card must state the merge-back condition. Do not let finished side branches accumulate.

Lightweight means low ceremony, not low ambition. A card here can be an hour-plus task. The point is that the worker gets a clear outcome and safe boundaries without the orchestrator doing the implementation thinking first.

The orchestrator should route and synthesize:

- decide the lane/thread;
- write a sharp Task Done;
- name the exact project folder;
- protect write scope;
- fold the completed result back into the roadmap.

The orchestrator should not read every implementation file before assignment unless that is needed to route safely.

## Brain Dump Intake

When Jojo gives a speech-to-text brain dump, the orchestrator should route it into durable work:

- lock decisions into the relevant source-of-truth doc;
- turn actionable work into a task card;
- prepare a tiny prompt for the right pinned lane when the task is ready;
- hold blocked ideas explicitly instead of relying on chat memory.

Important ideas should not require Jojo to ask "what about this?" later.

## Peer Review Default

Meaningful task cards should ask for one focused read-only peer reviewer near the end. The reviewer checks Task Done, boundaries, validation, and obvious missed issues.

Use two reviewers at most when the task has two truly different risk surfaces. Use three-gate review only for rare high-risk work such as release/signing, broad runtime migrations, destructive cleanup, or cross-lane changes. Docs-only or orchestration-only edits can use a self-review checklist instead.

## Pre-Jojo Visual QA Gate

Before Jojo is asked to visually test a user-facing change, send it through `Tester / QA` when practical.

The tester should act like a first-time traveler, not a developer:

- inspect screenshots and simulator/browser behavior;
- look for placeholder text, internal labels, robotic copy, awkward wording, clipped text, overcrowded UI, broken audio affordances, and confusing navigation;
- try to break the changed flow;
- report what must be fixed before Jojo spends attention on manual visual testing.

This gate should stay lightweight: one tester pass with screenshots is enough unless the feature is high-risk.

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
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Execute docs/task-cards/TASK-PRACTICE-CORE-001.md.
Commit when done and write the requested result.
```

The task card carries the real assignment. The chat prompt stays tiny.
