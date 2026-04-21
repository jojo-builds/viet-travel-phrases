# Viet Purchase-Surface Audit

Date: 2026-04-20
Task: T-072

## Scope

- Reviewed the Viet purchase and locked-state presentation seam required by `T-072`.
- Re-read the prior blocked rerun context from `T-023` to confirm whether a new bounded Viet-shell fix was still needed.
- Stayed inside repo-side shell truth only; no device, TestFlight, or real App Store proof was claimed.

## Files reviewed

- `app/family/presentation/vietPremium.ts`
- `app/app/premium.tsx`
- `app/app/settings.tsx`
- `app/app/(tabs)/index.tsx`
- `app/app/scenario/[id].tsx`
- `app/components/home/HomeTopSection.tsx`
- `app/lib/premiumStoreMessages.ts`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`

## Findings

- The bounded Viet-only copy tightening from the earlier `2026-04-18` purchase-surface audit is already present in `app/family/presentation/vietPremium.ts`.
- Current repo truth still reads honestly about App Store dependence, restore availability, and the live `150 / 750 / 900` Viet boundary.
- I did not find a new `app/family/**` issue that justified another Viet-only code edit in this rerun.
- Some purchase-state wording remains shared-screen copy in `app/app/premium.tsx`, `app/app/settings.tsx`, and `app/lib/premiumStoreMessages.ts`, but this rerun stayed scoped to Viet-specific shell truth rather than a broader shared-surface rewrite.

## Decision

- No additional `app/family/**` edit applied in `T-072`.
- Recorded this rerun as validation-only evidence that the repo already contains the bounded Viet-shell clarity pass and that no new Viet-specific fix was required from repo inspection.

## Provenance

- `T-023` is treated only as predecessor context for why this rerun exists.
- `T-072` owns its own audit log, review gates, result artifact, and final queue closeout.
- The wider history already present elsewhere in `docs/operations/LATEST_VALIDATION.md` is legacy operational context, not part of this task's claim set unless explicitly repeated in the Viet purchase-surface subsection.

## Validation

- Passed `npx --no-install tsc --noEmit` from `E:\AI\SpeakLocal-App-Family\app`.

## Honesty limits

- This audit does not prove physical-device readability on a small iPhone.
- This audit does not prove purchase, restore, or restart persistence on hardware.
- This audit does not prove that the current in-flight App Store/TestFlight builds are installable or purchase-ready.
