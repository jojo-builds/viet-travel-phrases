## Summary
The current close-out path is not cleanly bounded to Viet-shell purchase-state scope. The repo truth for the Viet premium copy itself stays narrow and honest, but the surrounding close-out trail is still carrying broader shared-search, website, and release-ops work that belongs to other lanes.

## Checks
- `app/family/presentation/vietPremium.ts` stays within Viet purchase/locked-state copy and does not change pricing, entitlement, or store wiring.
- `app/app/premium.tsx` and `app/app/settings.tsx` keep the real purchase/restore path centered on App Store availability and device-session truth.
- `docs/operations/LATEST_VALIDATION.md` correctly labels the Viet shell-copy audit as bounded, but it also documents website preview exports, staged website publishing, and release-build work that is outside this task's close-out lane.
- `docs/operations/CURRENT_BLOCKERS.md` still carries shared-search device-proof debt and release-ops blockers, so the broader family close-out is not actually finished.
- `docs/PRIORITIES.md` and `docs/V2_BASELINE.md` still separate device proof from repo-side shell copy work, which is the right boundary.

## Risks
- If this gate advances, the task can blur into broader shared-shell or release completion claims even though the evidence only supports a Viet-shell copy audit.
- The presence of website and release-ops material in the ops validation trail makes it easy to overstate close-out completeness.
- Shared-search and TestFlight/device-proof blockers remain open, so advancing now would be semantically wider than the actual Viet purchase-state fix.

## Approval
BLOCK
Approval: BLOCK
