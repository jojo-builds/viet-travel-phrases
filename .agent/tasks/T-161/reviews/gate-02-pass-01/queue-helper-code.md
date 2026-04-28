Approval: BLOCK

Blocking finding:
- `.agent/queue_tool.py` mutates the candidate state object that is already stored in the in-memory `states` map before `write_json_atomic` succeeds. If the write hits the handled write-block path, the loop continues with a phantom in-memory `in_progress` task and can falsely skip later candidates as active write-lock conflicts.
