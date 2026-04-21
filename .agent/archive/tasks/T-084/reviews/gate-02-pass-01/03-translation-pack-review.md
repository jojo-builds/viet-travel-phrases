# Gate 2 Pass 1 - Translation Pack Review

Approval: BLOCK

Findings:
- The residual-tail accounting is honest and matches the target state: `70` phrase rows, `69` non-empty `target_text` values, and one `deferred-rewrite-needed` holdout.
- Pack quality was not clean enough to approve because visible German and support fields showed mojibake or encoding corruption.
- The affected examples included `KrÃ¤uter`, `KÃ¶nnen`, `fÃ¼r`, and corrupted emoji sequences.

Pack-shape constraints:
- Keep the lane prep-only with exactly one explicit holdout, `german-coffee-shop-4`.
- Preserve the visible service, transit, and medical caution posture.
- Fix encoding cleanup before rerunning Gate 2.
