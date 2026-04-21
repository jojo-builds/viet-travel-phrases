# Reclaim breadcrumb audit

## Scope
Compared reclaim breadcrumbs for T-026, T-027, T-028, and T-029 against each task's current `state.json` and the evidence explicitly named inside the recovery notes.

## Evidence by task

### T-026
- `state.json` shows reclaimed attempt 2, `status: blocked`, `execution.reclaimReason: lease-expired`, and label `queue-burnin-r1-pragmatist`.
- Recovery note names one concrete prior artifact, absence of `reviews/`, absence of `result.md`, a specific resume checkpoint, the resumed next step, and the carried review-contract uncertainty.
- Breadcrumb quality: strong. It gives the next worker enough context to resume decisively.

### T-027
- `state.json` shows reclaimed attempt 2, `status: blocked`, `execution.reclaimReason: lease-expired`, and label `queue-burnin-r1-recovery-observability`.
- Recovery note clearly states that task-local artifacts were effectively absent except `spec.md` and `state.json`, names the strongest checkpoint as the prior lane truth from `T-011`, gives a concrete resume plan, and preserves the runtime-review uncertainty.
- Breadcrumb quality: usable, but slightly weaker than T-026 because the checkpoint depends on another task id rather than a task-local artifact path.

### T-028
- `state.json` shows reclaimed attempt 2, `status: blocked`, `execution.reclaimReason: lease-expired`, and label `queue-burnin-r1-edgehunter`.
- Recovery note records the artifact inventory, chosen checkpoint, next action taken, and uncertainty about the runtime-review path versus repo-level gate.
- Breadcrumb quality: strong for a stop-early reclaim. The mismatch note is especially useful.

### T-029
- `state.json` shows reclaimed attempt 2, `status: blocked`, `execution.reclaimReason: lease-expired`, and label `queue-burnin-r1-contract-enforcer`.
- Recovery note records the artifact inventory, strongest checkpoint, planned resume path, and runtime-review uncertainty.
- Breadcrumb quality: strong. It is explicit that there was no durable implementation checkpoint to resume.

## Cross-task judgment
The checked reclaimed tasks now leave enough breadcrumbs for a later worker to avoid rediscovering the basic situation. All four notes include:
- what artifacts were found or missing
- what checkpoint was chosen
- what should happen next or what action was actually resumed
- what uncertainty remained

## Minimum breadcrumb fields that should always exist
1. reclaim trigger and prior run identity (`execution.reclaimReason`, prior session/label, or equivalent)
2. artifact inventory at reclaim time, including explicit missing artifacts when absent
3. strongest checkpoint chosen, with exact task-local path references when possible
4. next action resumed or the precise reason resume stopped immediately
5. carried uncertainty or contract risk that the next worker must preserve

## Improvement recommendations
- Add the prior run label/session directly into every recovery note body, not only `state.json`, so the note still stands alone when copied or reviewed out of context.
- Prefer exact path references over indirect phrases like "lane truth left by T-011" when a checkpoint depends on another artifact.
- When a reclaimed run stops immediately, phrase the note as "resume decision made" rather than "planned resume path" so the note reflects what actually happened.

## Clean-surface verdict
No blocking breadcrumb-completeness defect was found in this sample. The remaining improvements are quality upgrades, not evidence of unsafe reclaim ambiguity.
