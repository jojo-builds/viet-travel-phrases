# Finish prerequisite and result-template usability audit

## Evidence checked
- Read helper finish logic in `.agent/queue_tool.py`, especially `done_prereq_errors()` and `result_has_process_feedback()`.
- Compared round-1 result artifacts:
  - `.agent/tasks/T-026/result.md`
  - `.agent/tasks/T-027/result.md`
  - `.agent/tasks/T-028/result.md`
  - `.agent/tasks/T-029/result.md`
- Re-read current task state after claim and heartbeat to confirm this proof task remained owned by session `queue-burnin-r3-pragmatist-20260419-1004-6b2f1d9a`.

## Findings
1. The repo template is clear about the expected section names and the strict `BUG` / `SUGGESTION` / `NONE` prefix rule for `Process feedback`.
2. The checked round-1 artifacts did not consistently use the template shape. They are still readable, but they mix heading styles such as `status:` prose blocks, ad hoc sections, and non-template labels.
3. That mismatch would matter most for `done` runs, because helper validation requires:
   - the result file to exist
   - a `## Process feedback` heading
   - at least one of `bug`, `suggestion`, or `none` anywhere in the lowered file text
4. The helper check is usable but loose. It does not verify that feedback bullets actually follow the template prefix rule, only that one of those tokens appears somewhere in the file.
5. The helper error wording for result feedback is understandable, but still slightly vague: `result artifact missing usable Process feedback section` does not tell the operator whether the problem was the missing heading, missing token, or malformed bullet format.
6. The helper's `done` prereq check also requires a heartbeat after claim and any `requiredForDone` artifacts. That is a good safety net and should block unattended false-complete runs cleanly.

## Clean / confusing surfaces
- Clean: the template itself is compact and easy to fill.
- Clean: required done artifacts are explicit in task state.
- Confusing: blocked-task results can drift away from the template without immediate enforcement, so operators may think the freer style is acceptable for all tasks.
- Confusing: the feedback validator is weaker than the template wording, so a result can pass helper checks while still not matching the intended bullet discipline.

## Recommendations
- Keep the template as the canonical shape.
- Tighten helper validation if strict bullet-prefix discipline is truly required for unattended runs.
- Improve the finish error text to distinguish `missing heading`, `missing BUG/SUGGESTION/NONE token`, and `missing required artifact`.
- Consider applying the template shape to blocked proof-task results too, so operators learn one stable format.
