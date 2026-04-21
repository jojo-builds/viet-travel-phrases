## Summary
The rerun now stays cleanly bounded to Viet-shell purchase-state scope. The new provenance notes explicitly separate this task's claim set from the broader historical ops material, and the audit remains validation-only with no new shell or release work added.

## Checks
- `app/family/presentation/vietPremium.ts` remains the only Viet shell surface touched for copy honesty, and it stays inside purchase/locked-state framing.
- `app/app/premium.tsx` and `app/app/settings.tsx` still present shared purchase-state UI, but this rerun did not expand their scope or change logic.
- `.agent/tasks/T-072/logs/shell-audit.md` now states the rerun is repo-side shell truth only and does not claim device, TestFlight, or App Store proof.
- `.agent/tasks/T-072/result.md` keeps the task-local closeout bounded to validation-only evidence and records the provenance distinction from `T-023`.
- `docs/operations/LATEST_VALIDATION.md` now adds an explicit note that only the Viet purchase-surface subsection belongs to this rerun's claim set; the rest is legacy operational context.

## Risks
- The operational doc still contains broader website and release history, so future readers could overread it without the new provenance fence.
- Shared purchase-state UI remains present in `app/app/premium.tsx` and `app/app/settings.tsx`, but the rerun does not drift into broader shell redesign.
- Physical-device purchase, restore, and restart proof are still open elsewhere, but they are correctly outside this rerun's scope.

## Approval
APPROVE
Approval: APPROVE
