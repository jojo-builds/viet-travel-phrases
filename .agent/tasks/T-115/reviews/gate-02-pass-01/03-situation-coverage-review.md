# Gate 02 Pass 01: Situation Coverage Review

## Verdict
The updated Vietnam country path does better at surfacing the highest-stress starter situations first. The hero and starter preview now center arrival, transport, money, and phone as the primary on-web lanes, while repair, essentials, and food are consistently positioned as deeper or off-hub support.

## Evidence
- `site/countries/vietnam.html` and `site/countries/vietnam/index.html` are byte-identical, so the route pair stayed in sync.
- The hero copy explicitly says the hub covers "four live pressure points first," naming arrival handoff, ride trouble, totals or ATM confusion, and getting back online.
- The starter preview section says "Essentials, repair, and food stay off-hub on purpose," which preserves the intended support-lane boundary.
- `content-draft/viet/website-preview.json` keeps the approved starter modules aligned to arrival, transport, money, and phone, while `vietnam-understanding-repair` and `vietnam-food-drink-basics` remain separate preview-ready support modules.
- The audit log confirms the copy reframes app depth as app depth, not web scope, and that the install pitch is now positioned as deeper backup after the preview runs out.

## Risks
- The later cluster grid still surfaces repair and food as visible cards, so the supporting topics are present enough that a quick scan could still treat them as co-equal with the starter lanes.
- The page is more explicit than before, but it still relies on several repeated "go deeper" and "backup" statements to maintain the hierarchy.

## Recommendation
Approve the update. The path is now meaningfully more situation-first, and the supporting topics are still kept in the right lane rather than promoted into the starter core.

Approval: APPROVE
