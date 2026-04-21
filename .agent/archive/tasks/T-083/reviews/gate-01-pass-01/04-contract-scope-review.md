Role
- Gate 1 reviewer: contract scope

Scope read
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-083\spec.md`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-083\state.json`
- Runtime facts provided in prompt: autonomous-500 has 342 approved rows; all 342 still show `audio_status=planned`; all 342 overlap the live phrase source; all 342 already have matching MP3, manifest, and registry coverage.

Findings
- The only concrete stale condition described is in `content-draft/viet/autonomous-500/**`, where 342 approved rows still show `audio_status=planned`.
- That path is readable under the spec, but it is not inside the allowed write scopes for T-083.
- The allowed write scopes do cover `.agent/tasks/T-083/**`, `app/assets/audio/**`, `app/family/packs/**`, `content-draft/viet/audio-review/**`, and `docs/operations/**`, but the prompt’s runtime facts say the 342 rows already have matching MP3, manifest, and registry coverage there.
- On the stated facts, the remaining stale source problem is a draft-source status correction outside contract scope, not an in-scope runtime seam gap.

Approval
Approval: APPROVE

Reason
- A blocked conclusion is contract-correct if the worker determines the required row-state repair lives in `content-draft/viet/autonomous-500/**`. The task can document the blocker in allowed T-083 artifacts, but it cannot truthfully claim row-status promotion by editing only the allowed write surfaces when those runtime surfaces are already aligned and the stale source rows remain out of scope.
