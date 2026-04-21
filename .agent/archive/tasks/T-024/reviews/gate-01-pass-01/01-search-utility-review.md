# Gate 1 Search Utility Review

- Focus: search normalization behavior before edits
- Finding: the shared matcher has a real separator-normalization gap, so compact queries like `wifi` can miss phrase text indexed as `Wi-Fi` or `wi fi`.
- Approval: withheld
- Reason: this is a manual single-agent artifact; the task contract requires a 4-subagent gate before advancement.
