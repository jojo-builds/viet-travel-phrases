# Traveler / Editorial Quality Review

Task: `TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001`

Reviewer: Reviewer A, read-only

Outcome: Initially approved 10 pages for import. After live rendered-page review, `acknowledge-da-chao-anh` was removed from the final import set because one visible relationship-swap row was unrelated. Final approved import set: 8 pages.

## Approved Phrase IDs

- `city-danang-place-dragon-bridge`
- `city-danang-place-bach-dang-street`
- `city-danang-place-nguyen-van-linh-street`
- `city-danang-go-ba-na-hills`
- `city-danang-go-dragon-bridge`
- `city-danang-near-nguyen-van-linh-street`
- `v500-airp-bord-arri-where-is-the-taxi-counter`
- `hotel-9`

## Skips

- `city-hanoi-place-bun-cha-huong-lien`: row-flow mismatch; restaurant page still places destination/route rows inside the in-restaurant flow.
- `city-hanoi-place-pho-bat-dan`: row-flow mismatch; restaurant page mixes go/stop/where/drop-off rows into inside-the-place ordering flow.
- `city-hoian-place-cao-lau-city`: next question; canonical title decision required.
- `city-hue-place-bun-bo-city`: page-kind mismatch; dish page retains place-style ATM/eat-near rows for the dish itself.
- `city-danang-place-ba-na-hills`: reference completed; patch marks page reference only.
- `city-danang-place-marble-mountains`: row topic drift; key phrases include Dragon Bridge route row.
- `city-danang-place-son-tra`: row topic drift; use-it-with includes unrelated Dragon Bridge route row.
- `city-danang-place-vo-nguyen-giap-street`: row topic drift; use-it-with includes Bach Dang Street route row.
- `city-danang-where-ba-na-hills`: order/section mismatch; visible use-it-with rows target a section missing from the proposed section order.
- `city-danang-ticket-marble-mountains`: next question; canonical ticket-counter wording decision required.
- `acknowledge-da-chao-anh`: live rendered-page review; Relationship swaps pointed to "Do you speak English?" instead of a relationship/greeting swap.
- `v900-airp-bord-arri-can-you-help-me-track-my-bag`: next question; native baggage-desk wording decision required.
- `v900-hote-acco-can-you-arrange-a-taxi-for-me`: next question; canonical hotel taxi wording decision required.
- `food-peanut-allergy`: row topic drift; allergy page still surfaces generic food-order rows and weak split-token breakdowns.
- `v500-food-drin-i-am-allergic-to-shellfish`: next question; native shellfish wording decision required.
- `emergency-3`: row topic drift; passport-loss page uses generic injury/hospital rows in local-tip/when-to-use flow.
- `emergency-hospital`: import support blocker; the Tier 1 generated-source lane overwrote the direct source import during regeneration, so this needs generator-level Batch 001 support before durable import.

## Next Questions

- `city-hoian-place-cao-lau-city`: Should the canonical title stay "Cao lầu ở Hội An," or should the page title become "Cao lầu" with Hội An handled as city context?
- `city-danang-ticket-marble-mountains`: For ticket-counter Vietnamese, should the canonical phrase remain "Một vé vào Ngũ Hành Sơn," or should native review add a more polite "Dạ, cho tôi một vé vào Ngũ Hành Sơn"?
- `v900-airp-bord-arri-can-you-help-me-track-my-bag`: For the airport baggage page, should the canonical Vietnamese stay "Bạn có thể giúp tôi theo dõi túi của tôi?" or should native review replace it with a more baggage-desk natural phrase using "hành lý" or "kiểm tra hành lý"?
- `v900-hote-acco-can-you-arrange-a-taxi-for-me`: Should this page keep the formal "Bạn có thể sắp xếp một chiếc taxi cho tôi được không?" or use the shorter hotel-desk phrase "Gọi taxi giúp tôi được không?" as the canonical version?
- `v500-food-drin-i-am-allergic-to-shellfish`: Should "shellfish" be taught as "động vật có vỏ," "hải sản có vỏ," or a different native-validated food-allergy phrase for Vietnam?
