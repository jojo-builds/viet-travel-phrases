# Gate 3 Pass 1: Relation Depth Review
Approval: APPROVE
- The final sidecars stay aligned at `58` answer-page-ready hubs: every promoted hub maps 1:1 to an `answerPageReady` relation cluster, and each hub's advertised bucket names and module relation refs match the authored cluster buckets exactly.
- Promoted relation buckets remain sidecar-authored rather than CSV-inferred: every bucket target in the promoted `58`-hub set resolves back to explicit `familyRelations` and/or `possibleTravelerResponses` evidence inside `relation-sample-v1.json`, with no orphaned synthetic targets.
- Parked and deferred families remain visibly non-promoted: the `8` parked candidates and `1` deferred boundary stay out of promoted answer-page buckets even where the wider relation graph still references them as follow-on context.
- `likelyReply` stays honest and bounded: only `24` of the `58` promoted hubs expose it, and each of those hubs has explicit reply-style authored support (`likely_answer_to` and/or `possibleTravelerResponses.kind = likelyReply`) instead of filler reply rails.
