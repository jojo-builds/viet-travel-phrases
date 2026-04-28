# SpeakLocal Orchestrator Layer

This folder is the pinned-session operating layer for turning worker output into product direction.

The queue answers:

- what task is queued, claimed, blocked, or done;
- who owns it;
- what files it may write;
- whether it passed validation.

The orchestrator layer answers:

- what the task taught us;
- what product/system decisions are now clearer;
- what feedback Jojo gave while reviewing the work;
- what still feels wrong or risky;
- which next tasks should be queued.

## Completion Digest Rule

After any meaningful worker finishes, the pinned orchestrator should create or update one digest under:

```text
.agent/orchestrator/digests/T-xxx.md
```

The digest should be short enough to read, but concrete enough to guide the next session. It must include:

- task outcome;
- files/source-of-truth changed;
- product/system meaning;
- metrics or counts when relevant;
- review feedback and blockers found;
- decisions locked in;
- open questions or risks;
- recommended next tasks;
- how this folds into the current roadmap.

The digest is not lifecycle truth. `state.json` remains lifecycle truth. The digest is strategic truth for Jojo and future orchestrator sessions.

## Active Digest Index

- `T-160`: SQLite phrase graph architecture completed; next active implementation lane is `T-163`.
- `T-162`: in progress; practice quiz visual/prototype lane.
- `T-163`: in progress; first SQLite Viet fixture generator lane.
