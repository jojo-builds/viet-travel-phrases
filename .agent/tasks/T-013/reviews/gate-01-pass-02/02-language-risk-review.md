# Language Risk Review

## Scope checked

- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-013\spec.md`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-013\state.json`
- `E:\AI\SpeakLocal-App-Family\content-draft\spanish\README.md`
- `E:\AI\SpeakLocal-App-Family\content-draft\spanish\source-notes.md`
- `E:\AI\SpeakLocal-App-Family\content-draft\spanish\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family\content-draft\spanish\first-wave-priority.csv`
- `E:\AI\SpeakLocal-App-Family\content-draft\spanish\research-backlog.md`

## Findings

- The revised plan stays inside the prep-only `content-draft/spanish/**` boundary and matches the task contract.
- Synchronizing rewritten `english_text` across both CSVs for ranks 26-28 materially reduces language-risk drift by preventing later literal translation of the weaker city-center and bargaining source lines.
- Translating ranks 26-30 is acceptable if the rewritten rank 26-28 intents are the actual source of truth, the new notes/status fields keep lower-utility rows from being overstated, and rank 21 remains explicitly flagged as sensitive in both lane files and supporting docs.

## Approval

Approval: APPROVE
