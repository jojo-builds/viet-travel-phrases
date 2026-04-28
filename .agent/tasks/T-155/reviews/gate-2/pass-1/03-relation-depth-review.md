# Gate 2 Pass 1: Relation Depth Review

Approval: APPROVE

- The implemented pass holds the Gate 1 correction line: promoted answer-page `relationBuckets` are sourced from authored `familyRelations` and `possibleTravelerResponses` in `relation-sample-v1.json`, not from CSV inference.
- Parked and deferred targets remain out of promoted answer-page buckets, and `likelyReply` stays optional unless the authored relation shape genuinely supports it. That keeps the expansion additive and relation-disciplined even at `58` hubs.
- All promoted relation target family ids resolve, and the module mixes only require the bucket types that the authored sidecar can actually support.
- One small cleanup note remains: the top-level `purpose` prose in `relation-sample-v1.json` should say `58 answer-page-ready hubs` instead of the older `24` count. That is a consistency fix, not a blocker.
