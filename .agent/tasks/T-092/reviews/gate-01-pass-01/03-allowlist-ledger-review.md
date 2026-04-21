# Gate 01 Pass 01 - Allowlist Ledger Review

Approval: BLOCK

## Findings
- The current 24-row list functions as a sampled proof set, not a true next-batch worklist, because all 342 stale historical `planned` rows already resolve to live seam coverage.
- The current note does not give an explicit disposition for the remaining 318 rows.
- The current follow-up language is not concrete enough for the next worker and still contains a stale `T-083` reference.

## Required hardening before advancement
- Add a full-pool disposition summary for all 342 rows, including the 24 sampled rows and the remaining 318 rows.
- Add grouped counts or backlog framing so the next worker can choose the next bounded action without rebuilding context.
- Replace the stale task reference and state clearly that fixing historical `planned` truth requires a separate task with write scope in `content-draft/viet/autonomous-500/generated-rows.csv`.
