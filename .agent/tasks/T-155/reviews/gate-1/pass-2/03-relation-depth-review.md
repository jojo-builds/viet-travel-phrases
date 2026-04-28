# Gate 1 Pass 2: Relation Depth Review

Approval: APPROVE

- The corrected plan fixes the pass-1 blocker: promoted cross-family `relationBuckets` now come only from authored sidecar truth in `relation-sample-v1.json`, not from CSV hints.
- That stays additive and relation-disciplined because parked/deferred targets remain relation metadata only and do not get silently promoted into answer-page rails.
- The reply constraint is now honest: the sidecar has broad authored relation structure, but only a smaller subset has real reply-style edges, so `likelyReply` must stay optional for newly promoted classes/hubs.
- No remaining blocker if `equivalent reply edge` is kept narrow to authored reply semantics only, and the new `8` class/module contracts explicitly require only the buckets each promoted hub actually has authored support for.
