Approval: BLOCK

The hub/relation split was structurally in the right place: `50` answer-page hubs, `99` total relation clusters, and `49` relation-only clusters, all attached to the authored relation graph. This pass still blocked because the row-note contract in `phrase-source.csv` had not yet been fully synchronized to the latest JSON truth.

- Blocker: stale `answer-page-sample=...:support:...` tokens remained after relation-bucket changes, including stale support roles on rows such as `emergency-2`, `emergency-hospital`, `taxi-1`, `repair-2`, `repair-understand`, and `service-email-file`.
- Blocker: stale `relation-sample=...:variant:also-common` tokens remained on several CSV rows even though the current generator only rewrote relation membership from anchors, `clearer`, and `more-polite` forms.
- Blocker: the generator was only appending managed note tokens and recomputing counts from the already-mutated `notes` field; it was not clearing and rebuilding the managed marker set first.
- Positive: the structural split itself was coherent, and the relation-only support layer correctly attached the previously orphaned follow-on families to the authored graph.
