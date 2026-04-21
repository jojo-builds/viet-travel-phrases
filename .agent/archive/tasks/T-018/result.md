status: blocked

truth changed classification:
- planning
- new prep-only South Korea / Korean research and draft-lane truth only

changed files:
- `research/language-pipeline/korean/SOUTH-KOREA-TRAVEL-RESEARCH.md` - added durable South Korea / Korean synthesis covering traveler-use reality, politeness, script posture, romanization posture, scenario emphasis, search risk, and starter-pack direction.
- `content-draft/korean/README.md` - defined the Korean lane as prep-only and non-runtime.
- `content-draft/korean/source-notes.md` - recorded the authoring stance, rewrite warnings, and review-risk notes for the next Korean pass.
- `content-draft/korean/scenario-plan.json` - added the shared 10-scenario Korean scaffold with South Korea-specific tips and no scenario-ID drift.
- `content-draft/korean/research-backlog.md` - captured concrete follow-up work before runtime graduation.
- `.agent/tasks/T-018/state.json` - tracked claim, drafting, validation, blocker, and closeout state.
- `.agent/coordination/queue-index.json` - moved `T-018` through queue lifecycle state.
- `.agent/coordination/locks.yaml` - synced the shared lock surface with the task lifecycle state.
- `.agent/tasks/T-018/result.md` - recorded the final status and validation summary required by the task contract.

validation performed:
- verified the required Korean research and draft-lane files exist
- parsed `content-draft/korean/scenario-plan.json` successfully with `ConvertFrom-Json`
- confirmed the Korean scenario order stays aligned with `templates/FAMILY_TRAVELER_BASELINE.json`
- confirmed the files touched by this run are limited to `.agent/**`, `research/language-pipeline/korean/**`, and `content-draft/korean/**`
- self-reviewed the outputs against the spec: prep-only boundary preserved, no runtime wiring, Hangul and search risk stated explicitly

review findings and what was fixed:
- The initial draft used placeholder text labels instead of actual emoji values in `content-draft/korean/scenario-plan.json`.
- That consistency issue was fixed so the Korean scenario scaffold now matches the existing prep-lane shape more closely.
- The remaining blocker is not a content defect in the Korean lane artifacts; it is the missing mandatory 3-gate review evidence required by the task contract.

why blocked:
- The task contract requires 3 review gates, each with exactly 4 Codex subagent review artifacts and unanimous approval.
- This automation turn could not run that review workflow honestly because the current session policy does not allow spawning subagents unless the user explicitly asks for delegation.
- The Korean prep artifacts are materially useful, but the task cannot be marked `done` without those missing review gates.

gate status:
- Gate 1: not run; blocked by subagent-delegation policy in this session
- Gate 2: not run; blocked by subagent-delegation policy in this session
- Gate 3: not run; blocked by subagent-delegation policy in this session

substantive risks or follow-up cautions:
- This lane is still prep-only and not runtime-ready.
- Korean romanization normalization, emergency wording, allergy wording, and payment-repair language still need later native or expert review.
- A later content task should create a ranked first-wave shortlist before broad translation coverage starts.
- This task remains blocked until the mandatory review-gate evidence is generated or the contract is revised.

recommended next step:
- rerun `T-018` in a session that explicitly authorizes subagent delegation so the required 3-gate review workflow can be completed and the task can move from blocked to done
