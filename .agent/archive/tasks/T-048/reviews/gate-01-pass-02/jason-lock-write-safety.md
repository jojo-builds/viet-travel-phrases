BLOCK

- Revised plan improved artifact enforcement and sequencing.
- Remaining gap: explicitly require injected proof for both original write-failure surfaces:
  - `queue-events.jsonl` append denial
  - `queue-index.json` replace denial
- Production-ready claim should show structured output and recoverable residue handling for those forced failures.

Reviewer note:
- Once injected failure-path proof is required in the plan and artifacts, this gate can pass.
