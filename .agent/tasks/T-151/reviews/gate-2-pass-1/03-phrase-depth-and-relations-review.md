Approval: APPROVE

This packet clears Gate 2 for the depth and integrity question. The support-row model is now explicit in the authored notes, and the implemented relation graph shows real typed reply, repair, next-step, escalation, and cross-class depth with CSV-traced support rows, so there is no blocker-level depth or support-row integrity issue in the implemented graph itself.

- `content-draft/viet/relation-authoring-notes.md` and `content-draft/viet/source-notes.md` now define concrete `answer-page-sample=<hubId>:support:<kind>` semantics, including `likelyReply`, `repairIfMissed`, `askNext`, `crossClassExit`, and `escalateTo`.
- `content-draft/viet/relation-sample-v1.json` gives every answer-page-ready cluster 4 to 5 typed relation buckets, and sampled promoted/new hubs are scenario-specific rather than count padding.
- `content-draft/viet/phrase-source.csv` carries the claimed support depth in authored truth: `115` answer-marked rows total and `94` rows with explicit support tokens, with support rows distributed across the typed bucket kinds rather than just anchor and variant promotion.
- The packet still needs the missing `relation-sample=` markers for the seven rerun-added clusters fixed to satisfy the row-level relation-membership contract, but beyond that contract bug the relation and support-row depth is ready.
