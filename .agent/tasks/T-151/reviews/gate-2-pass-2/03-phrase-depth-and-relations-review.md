Approval: BLOCK

The support-row plumbing was much stronger than the last shallow sample, but this pass still blocked because the relation/navigation layer was not deep enough yet. The packet had real support traces and clean marker bookkeeping, but too many outward links still left the 50-hub graph and landed on thin non-hub families, so several “next” or “escalate” paths still read like dead-end leaves rather than durable phrase hubs.

- Support-marker coherence was good: the cross-check of `phrase-source.csv` against `answer-page-sample-v1.json` and `relation-sample-v1.json` found no missing anchors, no bucket-count mismatches, and the top-level claim of `94` unique support rows / `82` newly marked rows matched the relation sample metadata.
- Blocker: `75` relation-bucket edges pointed to `49` families outside the current 50-hub / 50-cluster sample; all `49` of those targets had no `relation-sample` anchor and no `answer-page-sample` anchor, and `43` of them were single-row families in `phrase-source.csv`.
- Blocker: the hotel recovery path relied on thin leaves such as `v500-hote-acco-can-someone-come-fix-it`, `v500-hote-acco-can-i-change-rooms`, `hotel-no-hot-water`, and `help-call-hotel`, so the room-problem branches still behaved like dead-end leaves.
- Blocker: bucket semantics were not staying distinct in a few important hubs, including `viet-greeting-acknowledge`, `viet-repair-english-help`, and `viet-medical-trouble-breathing`.
- Phrase/support depth was otherwise promising, with real approved support rows and a much healthier average support-row count per hub.
