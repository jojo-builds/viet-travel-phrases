Approval: HOLD

Findings
- The Thai lane is not authoring-ready yet because `content-draft/thai/phrase-source.csv` and `content-draft/thai/first-wave-priority.csv` do not exist.
- The current Thai files are still orientation-level rather than row-level authoring assets.
- `content-draft/thai/scenario-plan.json` is a valid scaffold, but it does not replace the missing source and priority CSVs.

Required changes before proceed
- Create `phrase-source.csv` with stable row identity and translation slots.
- Create `first-wave-priority.csv` with ranked starter rows and the contract columns required by the task.
- Make the first-wave list operational enough that the next translation task can start immediately without redoing orientation.
