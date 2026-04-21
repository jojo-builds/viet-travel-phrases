# Gate 1 Pass 1 Contract And Scope Review

- reviewer: Dirac (`019da7c0-6b60-7271-b302-39ceea33271b`)
Approval: BLOCK
- scope: task-local contract before scaffold creation

## Findings

- The original task spec did not define a concrete `phrase-source.csv` contract beyond existence and non-empty checks, which left authoring-ready quality too subjective.
- The original task spec was ambiguous about review evidence because it said `exactly 4 review artifacts` even though the task requires Gate 1, Gate 2, and Gate 3 latest-pass evidence with 4 files each.
- The original write scope was broader than needed for this task by including general Indonesian research writes even though the task is really a scaffold-completion pass under `content-draft/indonesian/**`.

## Recommended edits

- Predeclare the `phrase-source.csv` contract: exact columns, seam coverage, and a rule that every shortlisted row in `first-wave-priority.csv` must resolve to a matching `phrase-source.csv` row.
- Clarify the review-evidence contract to the stricter reading: exactly 4 files in the latest pass of Gate 1, Gate 2, and Gate 3.
- Narrow the write scope to the Indonesian content-draft lane plus task-local artifacts, keeping research edits only for bounded consistency fixes if absolutely required.
