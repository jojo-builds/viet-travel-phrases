The final corrected pass still reads like real flagship-hub deepening rather than coverage padding. The main greeting/social, urgent-help/medical, repair, transport, money, hotel, and food hubs keep their richer 5/6/7-module shapes, practical traveler bullets, and live next-step or escalation rails after the marker-id normalization.

Findings:
- none

Evidence:
- `.agent/tasks/T-152/logs/viet-flagship-answer-hub-deepening-notes.md` explicitly records `21` existing flagship hubs regenerated, not just new hubs added, alongside the final `80` hubs / `7` phrase classes shape.
- `answer-page-sample-v1.json` keeps greeting/social hubs materially deep: `viet-polite-hello` and `viet-social-how-are-you` each still have 5 modules with practical follow-through into `transport-destination`, `social-recommend`, `directions-how-to-get`, and `repair-understand`.
- `answer-page-sample-v1.json` keeps urgent/help and repair hubs practical, not textbook: `viet-health-pharmacy` and `viet-emergency-manager-now` still have 7-module urgent stacks with bullets about dosage/floor/price, written instructions, map-pin fallback, phone-screen rescue, and police/hospital escalation; `viet-repair-understand` still has 6 modules covering slower repeat, writing, English help, and return-to-task flow.
- `answer-page-sample-v1.json` keeps the transport, money, hotel, and food hubs rich: `viet-transport-destination`, `viet-money-total`, `viet-b2-money-itemized-bill`, `viet-hotel-booking-wrong`, `viet-hotel-no-hot-water`, `viet-food-menu`, `viet-food-not-spicy`, and `viet-food-pay-now` all still carry 7 modules with concrete bullets about fare checks, written numbers, receipts, booking proof, room-change/fix flows, spice/allergy safety, and payment closeout.
- `relation-sample-v1.json` shows those hubs still expose credible rails instead of dead-ending: `viet-greeting-hello`, `viet-social-how-are-you`, `viet-medical-pharmacy`, `viet-repair-understand`, `viet-transport-destination`, `viet-rel-money-total`, `viet-rel-b2-money-itemized-bill`, `viet-rel-hotel-booking-wrong`, `viet-rel-hotel-no-hot-water`, `viet-food-menu`, `viet-food-not-spicy`, `viet-food-pay-now`, and `viet-rel-emergency-manager-now` all remain `answerPageReady: true` with populated `likelyReply`, `repairIfMissed`, `askNext`, and where relevant `escalateTo` / `crossClassExit` targets.
- `content-draft/viet/README.md` still describes the final sidecar as `80` answer-page-ready hubs with dedicated `money-transaction`, `hotel-accommodation`, and `food-drink` seams plus `134` explicit support-marker rows, which matches the deeper flagship-hub behavior seen in the JSON rather than a pure count-only expansion.

Approval: APPROVE
