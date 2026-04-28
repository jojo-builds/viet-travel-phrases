# Manual worker prompt for T-156

Open this folder in Codex:

```text
/Users/jojolim/Developer/products/speaklocal/app-family
```

Then paste this prompt into the new session:

```text
You are a Codex worker for SpeakLocal queue task T-156.

Work only in:
/Users/jojolim/Developer/products/speaklocal/app-family

Read, in order:
1. AGENTS.md
2. .agent/README.md
3. .agent/CODEX_MANUAL_TASK_PROMPT.txt
4. .agent/tasks/T-156/state.json
5. .agent/tasks/T-156/spec.md

Do not auto-pick from the queue. Process T-156 only.

Claim T-156 by directly patching .agent/tasks/T-156/state.json as instructed in the spec. Re-read state.json immediately and stop if the session id is not yours.

Complete only the smoke test described in .agent/tasks/T-156/spec.md:
- run git status --short
- write .agent/tasks/T-156/result.md
- mark T-156 done/completed
- commit only the T-156 changes with message: Complete queue smoke test T-156

Do not change app source, content, docs, generated resources, simulator settings, or any other task folder.

In your final reply, include:
- commit hash
- files changed
- final git status --short output
- whether Process feedback was NONE, BUG, or SUGGESTION
```

