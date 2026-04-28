1. The Gate 1 plan now proves the traveler-utility corrections at the plan stage. It explicitly commits to promoting both bathroom and card into guaranteed new full hubs in both sidecars, and it rewires `viet-polite-acknowledge` around acknowledgment/acceptance utility rather than reassurance, which directly closes the pass 2 concerns without requiring the live JSON/CSV to already be edited.

2. Findings: none

3. Evidence:
- [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:21) promotes `viet-bathroom-where` and `viet-service-card` as guaranteed new full hubs into both sidecars, with bounded sample count increases.
- [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:37) defines concrete new hub skeletons for `viet-bathroom-where` and `viet-service-card`, proving intended hub-level promotion rather than inventory-only retention.
- [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:71) gives bathroom-specific allowed slots and reject/demote boundaries, then [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:216) maps the bathroom hub to concrete kept rows covering location, access, public nearby, fee, urgency, and follow-ons.
- [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:57) gives card-specific allowed slots and reject/demote boundaries, then [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:232) maps the card hub to concrete kept rows covering acceptance, fee, decline, retry, cash fallback, reader issue, and bounded cross-context exits.
- [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:87) rewires acknowledge around respectful acknowledgment, plain yes, okay/accept, repair-exit acknowledgment, and commitment/purchase acceptance while explicitly rejecting `that's okay` / `that's fine`; [gate-1-plan.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\logs\gate-1-plan.md:121) carries that into the concrete `viet-polite-acknowledge` slot map.
- [02-traveler-utility-review.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\reviews\gate-1-pass-2\02-traveler-utility-review.md:4) identified the exact prior gaps, and the updated plan addresses each one directly.
- [spec.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\spec.md:89) requires bathroom and card in the flagship mix, while [spec.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-154\spec.md:93) requires real traveler utility and confirmation-vs-agreement distinction; the revised plan now concretely operationalizes those requirements.

Approval: APPROVE
