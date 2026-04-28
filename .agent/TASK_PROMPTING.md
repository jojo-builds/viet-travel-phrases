# SpeakLocal Queue Task Prompting Standard

Last updated: 2026-04-28

This is the source of truth for how orchestrator-created `.agent/tasks/T-xxx/spec.md` files should be written for GPT-5.5-powered Codex workers.

Official references checked on 2026-04-28:

- OpenAI GPT-5.5 prompt guidance: `https://developers.openai.com/api/docs/guides/prompt-guidance?model=gpt-5.5`
- OpenAI latest model guide: `https://developers.openai.com/api/docs/guides/latest-model.md`
- Codex subagents: `https://developers.openai.com/codex/subagents`

## Core Principle

Write task specs as outcome contracts, not step-by-step scripts.

## Pinned Orchestrator Rule

The pinned Codex thread is the orchestration lane. Its default job is to keep Jojo's ideas moving, shape work into queue-ready tasks, preserve source-of-truth decisions, and keep the repo/queue clean.

By default, the orchestrator should not take on long-running worker execution inside the pinned thread. Package the work for a worker instead when it involves:

- research that should run longer than a short pass
- app implementation or broad refactors
- simulator/device proof
- multi-file content generation or copy review
- audio generation/audit work
- tasks likely to take more than about `10` to `15` minutes
- tasks that would block Jojo from continuing to brainstorm or redirect the roadmap

It is acceptable for the orchestrator to make small direct edits when the edit is itself queue/source-of-truth housekeeping, for example:

- writing or repairing `.agent/tasks/T-xxx` task specs and state
- updating roadmap or decision docs so workers receive correct context
- running quick queue health checks
- committing orchestration-only changes

If Jojo explicitly asks the pinned thread to execute a task here, it may do so. Otherwise, prefer: clarify outcome, create/update the task packet, commit the queue/doc change, and hand off a short worker prompt.

The worker should understand:

- what must be true when the task is done
- what context matters
- what constraints must not be violated
- how to validate the outcome
- how to recover or stop honestly if the task is interrupted or blocked

Then the worker should use GPT-5.5 reasoning to choose the implementation path.

## Default Spec Shape

Every real worker task should make these sections concrete:

```text
Outcome
Success criteria
Context and source-of-truth files
Allowed write scope
Must not touch
Required validation
Review/subagent gates
Heartbeat and recovery contract
Definition of done
```

Prefer this style:

```text
Deliver a reusable native resource-loader migration so Vietnam content can live under
Resources/LanguagePacks/viet without changing visible app behavior.
```

Avoid this style:

```text
Open file A, change line B, then open file C, add function D, then run command E.
```

Step lists are allowed only when the order is a real safety requirement, such as claiming a task before editing, running a migration before a build, or preserving a user-facing release gate.

## Outcome-Driven Prompt Rules

- Lead with the desired product/process state.
- Give the model room to inspect, reason, and choose the path.
- State hard constraints separately from useful suggestions.
- Use examples to clarify taste or quality, not to force a brittle implementation.
- Make validation evidence explicit.
- Make stopping conditions explicit.
- Ask for concise rationale and evidence in `result.md`, not hidden chain-of-thought.
- Keep launch prompts tiny. The task file is the real prompt.

## What To Include

Include enough context for the worker to make good decisions:

- canonical repo and cwd
- specific source-of-truth docs
- relevant skills to use if the task matches them
- current branch/worktree expectations
- known prior decisions that should not be relitigated
- exact validation commands when known
- user-facing taste constraints, especially for listing pages and native Liquid Glass UI

For skills, name the minimum useful set:

- `speaklocal-listing-pages` for Vietnam phrase listing/detail content
- `build-ios-apps:ios-debugger-agent` for native simulator/build work
- `build-ios-apps:swiftui-liquid-glass` for Liquid Glass SwiftUI UI
- `openai-docs` for OpenAI model/API/prompt guidance
- relevant `superpowers` skills only when the task explicitly needs planning, review, debugging, or branch finishing

Do not ask a worker to load every broad doc or every skill just in case.

## What To Avoid

- Do not make a task a vague backlog item.
- Do not over-prescribe line-by-line implementation unless the path itself is the requirement.
- Do not bury the actual outcome inside long context.
- Do not ask for tiny conservative batches when the task is supposed to occupy a meaningful worker session.
- Do not let a task weaken its own validation with phrases like "if possible" when the check is required.
- Do not let meaningful tasks skip review gates.
- Do not let reviewer subagents edit files; they return judgment only.
- Do not request or store hidden reasoning traces. Store decisions, evidence, and tradeoffs.

## Subagent Review Standard

Meaningful tasks should use read-only reviewer subagents after implementation and before finalization.

The task spec should define reviewer lanes by outcome risk, not generic titles. Examples:

- visual/template parity reviewer
- content/culture reviewer
- canonical graph/audio reviewer
- tests/search/navigation reviewer
- resource-loader reviewer
- generator/scripts reviewer

Each reviewer returns:

```text
Approval: APPROVE
```

or:

```text
Approval: BLOCK
Blocking findings:
- ...
```

The parent worker writes review artifacts under the task folder, resolves blockers, repeats the gate if needed, and closes harvested reviewer agents.

## Parallel Work Standard

Parallel workers are allowed when their write scopes do not overlap.

The orchestrator should create separate tasks when:

- two outcomes can be completed independently
- file ownership can be separated clearly
- validation can run independently
- failure in one task should not block the other

The orchestrator should keep work in one task when:

- the files are tightly coupled
- the validation has to prove one integrated behavior
- splitting would create merge conflicts or duplicate decisions

## Result Standard

`result.md` should be evidence-based and compact:

- what changed
- what validation ran
- what review gates passed or blocked
- what tradeoffs were chosen
- what remains
- process feedback

Do not paste full diffs, full logs, or long reasoning transcripts into `result.md`.
