# Viet Purchase-Surface Shell Audit

Date: 2026-04-18
Task: T-023

## Scope reviewed

- `app/family/presentation/vietPremium.ts`
- `app/app/premium.tsx`
- `app/app/settings.tsx`
- `app/app/(tabs)/index.tsx`
- `app/components/home/HomeTopSection.tsx`
- `app/app/scenario/[id].tsx`
- `app/lib/premiumStoreMessages.ts`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/operations/CURRENT_BLOCKERS.md`

## Verified facts

- Viet still targets a one-time `$4.99` App Store unlock, not a subscription.
- Current live repo truth remains `150` starter / `750` premium / `900` total visible phrase groups.
- Current blockers still say real purchase, restore, restart persistence, and device walkthrough proof are missing.
- The premium logic already surfaces honest App Store dependency messaging when store access is unavailable.

## Audit findings

1. The Viet locked-state badge copy was too vague at a glance.
   - `Full Trip Pack` and `Unlocked` did not read as a clean state pair in the home pill, compact header, and settings card.
2. Several Viet premium copy blocks were denser than needed for small phones.
   - The home teaser title, premium screen body, scenario preview body, and settings/manage body all carried the right truth but with avoidable length.
3. No logic defect was found in the current purchase-state handling.
   - `app/lib/premiumStoreMessages.ts` and the premium/settings screens already keep the App Store dependency explicit enough to avoid false purchase-proof claims.

## Bounded fixes applied

- tightened the Viet teaser title/body for quicker scanning
- changed the Viet state labels to `Trip Pack locked` / `Trip Pack unlocked`
- shortened the Viet premium screen body and manage body
- shortened the Viet scenario-preview copy
- made the Viet store-unavailable placeholder more explicit that buy/restore wait on the App Store item
- kept pricing, unlock model, product logic, and store wiring unchanged

## Validation notes

- `npx --no-install tsc --noEmit` from `app/` passed
- `npm run validate:family` from `app/` failed in this runtime because `tsx/esbuild` hit `spawn EPERM`

## Explicitly deferred

- no device-proof claim
- no purchase or restore logic change
- no shared-family shell rewrite
- no shared-search work
