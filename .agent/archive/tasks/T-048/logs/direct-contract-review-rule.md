# Direct-Contract Review Rule

## Why this file exists
T-048 used more than two passes in Gate 2. That is intentional and contract-valid for this task, but the reason needs to be explicit in the evidence pack.

## Queue-run rule
- `.agent/AUTOMATION.md` limits a meaningful queue run to at most two passes per review gate during one queue run.
- That rule is written for ordinary repo-local queue automation runs claimed and finished through the helper.

## T-048 contract
- T-048 was started under `session.owner = "codex-direct-task-contract"` and `automation.mode = "direct-task-contract"` in `.agent/tasks/T-048/state.json`.
- The task was not executed under the queue-run prompt contract; the user explicitly said this was a direct task-contract execution, not a queue-run prompt.
- The user also explicitly required: use exactly four Codex subagents per gate, and if a review gate fails, fix what was found and rerun that gate until all four approve or a real blocker remains.

## Consequence
- Gate 2 pass count was governed by the direct task contract above, not by the queue-run cap intended for ordinary helper-claimed queue tasks.
- `gate-02-pass-07/` therefore reflects repeated fix-and-rerun work explicitly ordered for this direct contract, not an accidental breach of the queue automation policy.

## Scope note
- This is not a blanket waiver for repo-local queue runs.
- The ordinary two-pass cap still applies to meaningful tasks executed under the queue automation contract in `.agent/AUTOMATION.md`.
