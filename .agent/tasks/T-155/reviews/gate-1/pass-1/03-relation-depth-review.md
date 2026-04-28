# Gate 1 Pass 1: Relation Depth Review

Approval: BLOCK

- The additive path is sound in principle: `relation-sample-v1.json` already carries family-level relations for all `80` clusters, so promotion can stay sidecar-only without changing scenario/runtime truth.
- The current bucket-derivation plan is not safe if CSV hints are treated as a peer source. In `first-wave-priority.csv`, all `17` packet rows already selected into the answer-page sample have blank `likely_reply_family`, and some `primary_next_family` hints point at parked/non-cluster families rather than the richer JSON graph.
- All `56` currently non-ready clusters lack authored `likely_answer_to` edges in `relation-sample-v1.json`. If the new promoted hubs inherit the current `required likelyReply` pattern, that will force synthetic rails.
- The highest-risk expansion classes before edits are `street-food`, `convenience-store`, and most non-ready `hotel-hostel`, `directions`, and `asking-price` families: they already have honest `next_step_after` / `repair_for` structure, but not honest reply structure.
- Required correction before edits: make `relation-sample-v1.json` the sole source for cross-family `relationBuckets`, use CSV only as secondary guidance, and make `likelyReply` optional for new promoted classes unless a cluster already has an authored `likely_answer_to` edge.
