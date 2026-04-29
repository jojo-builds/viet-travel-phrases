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
