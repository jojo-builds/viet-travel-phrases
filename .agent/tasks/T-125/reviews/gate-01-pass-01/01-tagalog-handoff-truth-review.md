Approval: BLOCK

Findings
- `content-draft/tagalog/README.md`, `content-draft/tagalog/source-notes.md`, `content-draft/tagalog/research-backlog.md`, and `content-draft/tagalog/risk-review.md` still describe `tagalog-directions-1`, `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, `tagalog-hotel-hostel-5`, and `tagalog-convenience-store-6` as one ordered pickup cluster, not as one exact promotion packet with row-by-row outcomes.
- `content-draft/tagalog/tagalog-v2-first-wave.csv` rows `18-22` and `content-draft/tagalog/scenario-plan.json` `handoffContract.directPickupContract.rowDetails` still keep those rows under one shared `recommended-next-pass-pickup` / `ordered-pickup-*` shape instead of separating promote-now from non-promoted outcomes.

Required fixes before Gate 1 can approve
- Add an explicit row-by-row decision for each of the five direct-pickup rows using the task vocabulary.
- Update `scenario-plan.json` so the direct-pickup contract separates the promote-now subset from rows that stay non-promoted.
- Mirror the same packet in the Tagalog prep docs.

Notes
- `tagalog-polite-basics-4`, `tagalog-simple-problems-7`, and `tagalog-grab-taxi-7` are already explicit and consistent as non-promoted boundaries.
