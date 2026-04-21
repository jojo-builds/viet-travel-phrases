Findings
- `starterSafe` and `more-polite` are still too coarse for Vietnamese register. Politeness here depends on age, status, pronoun choice, and service context, so a binary safety label can misclassify phrases as broadly polite when they are only safe in a narrow interaction frame.
- `relation_cluster_memberships_json` plus `likely_answer_to` / `reply-candidate` can create misleading reply-link expectations unless the contract explicitly says these links are advisory and context-bound at render time. Without that, one phrase can look like a generic reply even when it only works in a specific service or repair exchange.

Risks
- The plan is directionally sound, but the Vietnamese register model is under-specified.
- The reply graph is workable, but it needs stricter display semantics so the UI does not imply conversational certainty where Vietnamese phrasing is only approximate.

Approval: BLOCK
