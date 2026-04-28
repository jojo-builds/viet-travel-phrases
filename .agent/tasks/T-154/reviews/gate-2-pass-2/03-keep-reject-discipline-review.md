Approval: BLOCK
Findings:
- The pass-1 transport and doctor accounting fix is present: the ledger now explicitly records `taxi-1`, `taxi-7`, `transport-premium-wait-here`, and `problems-6`.
- The pass-1 bathroom overlap rows are no longer retained on `viet-bathroom-where`: `v500-dire-navi-where-is-the-nearest-restroom` and `v500-airp-bord-arri-where-are-the-restrooms` do not appear as bathroom-hub sidecar members.
- BLOCKER: the bathroom ledger still omits `v500-bath-pers-need-is-there-a-public-bathroom-nearby`, even though `viet-flagship-cluster-harvest-notes.md` says the hub keeps “public access” and the row is retained in `answer-page-sample-v1.json`, `relation-sample-v1.json`, and `phrase-source.csv`, so the bounded keep set is still not fully auditable.
- The saturated legacy-row note is now honest: it says no further markers were added to the dense legacy anchors while explicitly acknowledging those anchors still remain in the historical sample.

Gate recommendation: Hold Gate 2 until the bathroom ledger explicitly accounts for the retained public-bathroom-nearby keep so the ledger and sidecars match end to end.
