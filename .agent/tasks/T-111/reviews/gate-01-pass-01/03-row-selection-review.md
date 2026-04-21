# Gate 1 Pass 1 Review 03

## Summary

The proposed residual-tail cut is right. Translating `street-food-4` plus `small-talk-1`, `small-talk-2`, `small-talk-4`, `small-talk-5`, `small-talk-6`, and `small-talk-7` clears the last low-risk utility tail without reopening weak Italy-fit intents, and keeping `coffee-shop-4` plus `asking-price-4` deferred preserves the earlier rewrite judgment.

## Risks

- The only real risk is ordering, not scope.
- If any rerank is needed, `italian-street-food-4` should stay ahead of the small-talk fillers because it is a practical food-order row.
- The two deferred rows should remain explicitly marked as rewrite-needed rather than drifting back into the active batch.

## Recommendation

Proceed with the 7-row cleanup batch as planned. No broader tail expansion is warranted, and no status changes are needed for the deferred pair beyond keeping them clearly deferred.

Approval: APPROVE
