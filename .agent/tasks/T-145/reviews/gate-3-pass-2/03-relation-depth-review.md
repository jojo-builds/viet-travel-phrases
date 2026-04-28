# Gate 3 Pass 2: Relation Depth Review

Approval: APPROVE

## Summary

The current packet preserves meaningful relation depth for the 24 enriched Viet hubs. The answer-page sample keeps distinct class-specific module layouts, the relation sample still drives real phrase-to-phrase handoffs instead of ornamental linking, and the CSV notes keep the enriched anchors traceable back to phrase-source truth.

## Findings

- `answer-page-sample-v1.json` still carries `24` hubs across `4` phrase classes with `4` distinct module mixes; the urgent/help hubs retain the heavier escalation-ready shape, while greetings, repair, and service/navigation keep materially different module sequences rather than collapsing into one reusable template.
- `relation-sample-v1.json` still provides meaningful routing depth for those hubs: `askNext` fans into `25` unique target families, `likelyReply` into `18`, and the urgent/help class keeps a dedicated `escalateTo` rail alongside repair and next-step branches, which preserves action-forward flow for the highest-stakes hubs.
- The packet stays source-grounded and operationally usable: all `24` answer-page anchors are marked in `phrase-source.csv`, each reviewed hub resolves to a live relation cluster, and the lighter social hubs still hand off into concrete next tasks like transport, directions, or recommendations instead of ending as dead-end phrase cards.

## Suggested adjustments

- Optional: diversify a few repeated `crossClassExit` pivots, especially the heavier reuse of `transport-destination` and `directions-how-to-get`, if a later polish pass wants even broader route variety.
- Optional: add a small amount of extra variant depth to selected urgent/service hubs where only the anchor/default/quick-say path carries the load today, but this is not required for approval.
