# SpeakLocal-App-Family

Read these first for broad manual repo sessions:
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md` for the current roadmap and near-term next steps
- `docs/operations/README.md` when the question touches live build, validation, release, or blocker truth
- `docs/V2_BASELINE.md` when the question touches shared app/product shape or the product blueprint
- `docs/V2_CONTENT_MODEL.md` when the question touches content schema, export seams, premium boundaries, or blueprint details
- `docs/LANGUAGE_PREP_WORKFLOW.md` when the task is future-language prep

For repo-local queue automation runs, do this instead:
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- for prompt-only desktop queue runs, read `.agent/coordination/queue-index.json`, then claim by patching the chosen task's live `state.json` directly and re-reading it immediately to confirm ownership
- treat `.agent/tasks/T-xxx/state.json` as lifecycle truth and `.agent/coordination/queue-index.json` as a fast-selection aid only
- best-effort queue-index or event-log updates may be helpful, but they must never block claim or finish for desktop prompt-only runs

Rules:
- This is the canonical implementation home for the SpeakLocal app family.
- Start new family-app sessions here:
  - `E:\AI\SpeakLocal-App-Family`
  - `C:\Users\Administrator\.openclaw\workspace\projects\speaklocal-app-family`
- Treat these as compatibility aliases only, not preferred roots:
  - `E:\AI\Viet-Travel-Phrases`
  - `C:\Users\Administrator\.openclaw\workspace\projects\viet-travel-phrases`
- Stay scoped to shared app-family implementation, current Viet/Tagalog dual-variant work, and future reusable feature rollout.
- Keep the existing Expo app shell under `app\` intact unless there is a concrete blocker.
- `app\family\appRegistry.js` owns runtime/build app identity truth.
- `app\family\*` owns shared runtime truth.
- `docs\operations\*` owns live operational truth for build, validation, release, and blocker questions.
- `ops\apps\*.json` owns operator-facing app readiness truth for dashboard and onboarding visibility.
- `docs\*` owns durable explanation only when it remains a real source of truth. Do not keep duplicate startup or next-step docs alive once they stop being maintained.
- Before answering current operational questions, prefer:
  - `docs/operations/README.md`
  - `docs/operations/APP_STATUS.md`
  - `docs/operations/VARIANT_MATRIX.md`
  - `docs/operations/TESTING_RUNBOOK.md`
  - `docs/operations/LATEST_VALIDATION.md`
  - `docs/operations/CURRENT_BLOCKERS.md`
- After meaningful changes, update only the matching durable docs when repo truth actually changed:
  - `docs/DECISIONS.md`
  - `docs/PRIORITIES.md`
  - `docs/V2_BASELINE.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/LANGUAGE_PREP_WORKFLOW.md`
  - `docs/project-meta.yaml`
- After meaningful changes affecting live operational truth, update the matching operational doc in the same task before closure:
  - `docs/operations/APP_STATUS.md`
  - `docs/operations/VARIANT_MATRIX.md`
  - `docs/operations/TESTING_RUNBOOK.md`
  - `docs/operations/LATEST_VALIDATION.md`
  - `docs/operations/CURRENT_BLOCKERS.md`
- After meaningful changes affecting app onboarding visibility, update:
  - `ops/apps/viet.json`
  - `ops/apps/tagalog.json`
- Keep the root docs lean:
  - do not log routine task churn
  - do not mirror the task registry into project docs
  - do not duplicate sub-area docs into the root docs
  - do not maintain separate generic `START_*`, `CURRENT_STATE`, or `NEXT_STEPS` docs for this repo unless a new owner and real upkeep loop exist
  - if compatibility pointer docs exist at `docs/START_SESSION.md`, `docs/CURRENT_STATE.md`, or `docs/NEXT_STEPS.md`, keep them as redirect-only stubs and do not let them regain workflow authority
  - prefer updating existing sections over adding duplicate headings
