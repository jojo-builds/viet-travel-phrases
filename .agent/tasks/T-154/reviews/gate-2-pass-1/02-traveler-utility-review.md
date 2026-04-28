CHANGES_REQUESTED

- `viet-rel-service-card` / `viet-service-card` use `Is there a card fee?` as `likelyReply`, but that is a traveler follow-up ask rather than the first thing the traveler is likely to hear.
- `viet-rel-bathroom-where` / `viet-bathroom-where` do the same with `Can I use the bathroom?` and the bathroom fee row, which makes those rails better as `askNext` than `likelyReply`.
- `viet-money-how-much` and `viet-health-doctor` repeat the pattern by treating `What is this fee for?` and `How long is the clinic wait?` as `likelyReply` instead of follow-up action branches.

Gate recommendation: move the flagged rows out of `likelyReply`, keep them as `askNext` support, and recheck the targeted hubs.
