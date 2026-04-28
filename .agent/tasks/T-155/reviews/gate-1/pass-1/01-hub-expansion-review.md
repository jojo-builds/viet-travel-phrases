# Gate 1 Pass 1: Hub Expansion Review

Approval: APPROVE

- The class split looks strong and non-arbitrary: it breaks the overloaded `practical-service-navigation` lane into real traveler-facing hubs (`transport`, `directions`, `hotel`, `money`, `food`) while keeping `greetings`, `repair`, and `urgent help` intact.
- The `58`-hub target still feels bounded for a prepared-next sidecar because it stays additive, reuses the existing relation graph, avoids new scenario/schema surface, and does not try to promote all `80` clusters.
- Coverage density looks good for the spec's expansion goal: ride-hailing, hotel, directions, money, and food each become large enough to feel like serious flagship lanes instead of scattered one-offs.
- The clearest non-blocking omission is `tagalog-asking-price-9` (`Do you accept cash?`), which reads like a very flagship money/payment hub if a later rebalance is needed.
- Secondary non-blocking watchlist: `tagalog-hotel-hostel-12` (`Can you change my room?`) and `tagalog-directions-10` (`Which stop do I get off?`) are the strongest omitted recovery/navigation candidates if any selected hub starts feeling less essential.
