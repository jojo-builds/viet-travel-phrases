Role
Audio risk reviewer

Scope read
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-083\spec.md`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-083\state.json`
- Provided runtime facts for autonomous-500 coverage and current `audio_status`

Findings
- The stated risk is not missing asset coverage. All 342 approved autonomous-500 rows already have matching MP3, manifest, and registry coverage.
- All 342 rows still being marked `audio_status=planned` means the current truth gap is metadata/readiness labeling, not absent audio files.
- Because the live `content-draft/viet/phrase-source.csv` still overlaps all 342 rows, a bounded evidence-backed promotion pass is in scope and does not require broad regeneration.
- The existing continuity posture should remain cautious. Nothing in the supplied facts supports stronger continuity claims, but those same facts also do not justify a full stop.

Approval
Approval: BLOCK

Reason
The safest honest path is not to block the batch outright. The in-scope change should be a controlled promotion of the next allowlisted rows from `audio_status=planned` to the appropriate evidence-backed app-usable state only where live source rows already match existing MP3, manifest, and registry coverage, while leaving continuity language at the current cautious level.
