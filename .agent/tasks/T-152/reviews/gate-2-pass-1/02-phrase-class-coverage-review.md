The underlying sample now clears the substantive coverage bar: it really reaches `80` hubs across `7` active phrase classes, the added `money-transaction`, `hotel-accommodation`, and `food-drink` classes are coherent and traveler-justified, and module-mix usage is consistent across the updated hubs. I’m blocking only because the core sample metadata is still internally inconsistent on the stated coverage metrics, so Gate 2 does not yet have one clean story for support-row / answer-page totals.

Findings:
- `answer-page-sample-v1.json` still declares `sourceOfTruth.supportingRowCount: 95`, while the actual CSV audit, `relation-sample-v1.json`, `source-notes.md`, and the task log all point to `126` support-marked rows; `relation-sample-v1.json` also still says the sample is “across 50 answer-page-ready Viet hubs” in `purpose`, which is stale against the actual `80`-hub sample.

Evidence:
- `answer-page-sample-v1.json` contains `hubCount: 80` and `phraseClassCount: 7`; actual hub-class counts are `greetings-social 7`, `urgent-help-medical 15`, `repair-clarification 15`, `practical-service-navigation 17`, `money-transaction 7`, `hotel-accommodation 14`, `food-drink 5`.
- The three added practical classes are coherent in the authored sample: `food-drink` covers `menu / not spicy / bottled water / table / pay`, `money-transaction` covers `how much / final price / total price / total / fee / service included / itemized bill`, and `hotel-accommodation` covers `reservation / check-in / room issues / deposit / room change / late checkout`.
- `answer-page-sample-v1.json` module audit found `0` module-mix mismatches: every hub’s `moduleMixId` matches its `phraseClass`, and every hub carries the expected module types and required relation buckets for its mix.
- `relation-sample-v1.json` contains `clusterCount: 99`, `answerPageCoverage.hubCount: 80`, and `relationOnlyClusterCount: 19`; actual cluster audit matches `80` answer-page-ready clusters plus `19` relation-only clusters.
- `phrase-source.csv` contains `150` answer-page-marked rows and `126` support-marked rows; this matches `source-notes.md` and `.agent/tasks/T-152/logs/viet-flagship-answer-hub-deepening-notes.md`, but not `answer-page-sample-v1.json`’s stale `95` support-row declaration.

Approval: BLOCK
