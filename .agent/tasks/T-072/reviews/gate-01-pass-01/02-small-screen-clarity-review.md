## Summary
Repo truth shows the Viet purchase and locked-state copy has already been tightened for compact scanning. I do not see a concrete small-screen clarity defect in the current shell code that should block this bounded rerun.

## Checks
- Reviewed `app/family/presentation/vietPremium.ts` for the current Viet purchase, locked-state, and teaser copy.
- Reviewed `app/app/premium.tsx` for the purchase screen layout, button stack, and fallback messaging.
- Reviewed `app/app/settings.tsx`, `app/app/(tabs)/index.tsx`, `app/components/home/HomeTopSection.tsx`, and `app/app/scenario/[id].tsx` for the other Viet entry points that surface the same locked-state truth.
- Compared the current copy against the prior blocked summary in `.agent/tasks/T-023/result.md`.
- The current copy is shorter, the status labels are brief, and the card sections already break the message into readable chunks instead of one dense block.

## Risks
- This is still repo inspection, not a real small-iPhone rendering pass.
- If the downstream gate wants physical-device proof, that remains outside what the code alone can confirm.

## Approval
Based on the current repo truth, the Viet purchase and locked-state copy/layout is acceptable for this bounded rerun.

Approval: APPROVE
