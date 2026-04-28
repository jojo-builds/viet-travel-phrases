Approval: APPROVE

The blocker looks resolved. The scoped artifacts are internally consistent: the 50-hub answer-page sample and 50-cluster relation sample line up one-to-one, and the CSV `notes` membership contract now matches the model the generator writes, including the rerun-added cluster tail that was previously at risk.

- `answer-page-sample-v1.json` declares `hubCount: 50` and actually contains 50 hubs; `relation-sample-v1.json` declares `clusterCount: 50` and actually contains 50 clusters.
- The hub and cluster ID sets match exactly, with the same 50 families covered and no duplicates on either side.
- A full per-hub cross-check found 0 mismatches for `relationClusterId/clusterId`, `familyId`, `scenarioId`, `anchorPhraseId`, `quickSayPhraseId` vs. `shortestFormPhraseId`, optional clearer/more-polite forms, and relation-bucket names.
- The CSV contract is coherent with the generator logic in `t151_generate_viet_answer_expansion.py`: lines 1642-1677 add `relation-sample=` tokens for anchors/variants and `answer-page-sample=...:support:<bucket>` tokens for support rows, while lines 1697-1700 copy the support/new-row counters into both JSON outputs.
- Both JSONs declare `rowMembershipField: "notes"`. The relation sample keeps `relation-sample=<clusterId>:anchor|variant:*` in `sourceOfTruth.membershipTokenFormat`, and support-row tracing is declared separately through `answerPageCoverage.supportMarkerKinds`; the CSV uses that same split.
- The rerun-added tail is present in both JSONs as the same 20 appended IDs from `viet-hotel-reservation` through `viet-service-scan-docs`; their anchor rows in `phrase-source.csv` carry both `relation-sample=...:anchor` and `answer-page-sample=...:anchor`.
- For those 20 rerun-added clusters specifically, the supporting answer-page markers were present with no missing `answer-page-sample=<hubId>:support:<bucket>` note tokens in the CSV.
- The counters agree across artifacts: `supportingRowCount = 94` in both JSONs, `newlyMarkedRowCountThisPass = 82` in both JSONs, and the CSV actually contains 94 support-marked rows and 115 answer-page-marked rows.
