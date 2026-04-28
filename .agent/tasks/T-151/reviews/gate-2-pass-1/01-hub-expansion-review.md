Approval: BLOCK

The 50-hub answer-page expansion itself is coherent, but Gate 2 should block because the relation seam is internally inconsistent: the 7 rerun-added clusters are present in `relation-sample-v1.json` and documented as part of the 50-cluster relation sample, yet their source rows in `phrase-source.csv` never received the required `relation-sample=` membership markers. That means the bounded relation sample cannot be reconstructed from the declared row-level contract.

- `content-draft/viet/relation-sample-v1.json` declares `notes` plus `relation-sample=` as the relation membership seam, and the missing-marker clusters are the 7 rerun additions: `viet-greeting-goodbye`, `viet-repair-meaning`, `viet-repair-show-me`, `viet-repair-spell-name`, `viet-urgent-passport-missing`, `viet-urgent-police-report`, and `viet-service-scan-docs`.
- Their CSV rows only carry `answer-page-sample=` tokens, not `relation-sample=` tokens.
- That drift is contradicted by the docs that describe CSV note markers as the bounded relation and answer-page participation contract.
- The rest of the structure looks ready: all 50 hubs have valid `answer-page-sample` anchors, every hub maps cleanly to a matching relation cluster, and the answer-page support token kinds are valid.
- Gate 2 should pass only after the missing `relation-sample=` anchor and variant tokens are added for those 7 clusters, or the documented contract is explicitly narrowed.
