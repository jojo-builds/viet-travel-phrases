# T-049 Meaningful-Capable Proof

## Goal

Verify the hardened launch shape still surfaces real meaningful work when the runtime is meaningful-capable.

## Working directory

- `E:\AI\Viet-Travel-Phrases`

## Command

From the alias cwd, defined `Invoke-SpeakLocalQueueTool` exactly as documented in:

- `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `E:\AI\SpeakLocal-App-Family\.agent\QUEUE_START.md`
- `E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md`

Then ran:

```powershell
Invoke-SpeakLocalQueueTool claim-next --session-id "t049-meaningful-alias-dry-02" --label "T-049 meaningful alias dry final" --dry-run
```

## Outcome

- Returned structured JSON with `status: "ok"` and `result: "dry-run-claimable"`
- Surfaced real task `T-030`
- Reported:
  - `claimGroup: "reclaimable"`
  - `taskClass: "meaningful"`
  - `proofTask: false`
  - `statePath: ".agent\\tasks\\T-030\\state.json"`
  - `specPath: ".agent\\tasks\\T-030\\spec.md"`
  - `resultPath: ".agent\\tasks\\T-030\\result.md"`

## Conclusion

The hardened launcher remains selective rather than globally blocking; a meaningful-capable dry run still surfaces real eligible work.
