# T-021 Result

## Status

- completion: done
- task: `T-021`
- title: `Desktop Codex automation pilot, Tagalog v2 shortlist rewrite and authoring-ready source pass`

## What changed

- turned the Tagalog lane into one explicit prep-only source pack instead of a loosely interpreted shortlist
- made `content-draft/tagalog/phrase-source.csv` the row-level filter surface for the next pass
- aligned `content-draft/tagalog/first-wave-priority.csv` to the same `16 / 6 / 2` first-wave contract:
  - `16` `first-wave-core`
  - `6` `first-wave-holdout`
  - `2` `first-wave-deferred`
- rewrote or tightened weak English source lines for the bounded first wave, including ride control, directions, takeaway, comparison shopping, polite opener, respectful acknowledgment, reservation wording, payment wording, and escalation wording
- updated `content-draft/tagalog/README.md` to state the file-role contract for the next translation pass
- updated `content-draft/tagalog/source-notes.md` to state the ordered authoring-ready set, holdouts, deferred rows, and prep-only posture
- updated `content-draft/tagalog/scenario-plan.json` so `quickPhraseIds` now point only at current core rows
- added `content-draft/tagalog/rewrite-notes.md` with row-level rewrite rationale and remaining caution posture

## Verification

- `phrase-source.csv` parses with `70` rows and status counts of `46 drafted / 16 first-wave-core / 6 first-wave-holdout / 2 first-wave-deferred`
- `first-wave-priority.csv` parses with `24` rows and status counts of `16 first-wave-core / 6 first-wave-holdout / 2 first-wave-deferred`
- verified that the `16` core phrase ids in `first-wave-priority.csv` exactly match the `16` `first-wave-core` rows in `phrase-source.csv`
- verified that every `quickPhraseIds` entry in `scenario-plan.json` is inside the current `first-wave-core` set
- Gate 1 latest pass: `gate-01-pass-02` with exactly `4` reviewer artifacts and unanimous approval
- Gate 2 latest pass: `gate-02-pass-01` with exactly `4` reviewer artifacts and unanimous approval
- Gate 3 latest pass: `gate-03-pass-01` with exactly `4` reviewer artifacts and unanimous approval

## Remaining

- keep `first-wave-holdout` rows out of the direct authoring pack until their loanword/register/payment reviews land
- keep `first-wave-deferred` rows out of promotion until the refusal-tone and destination-slot patterns are reviewed
- pronunciation remains helper-only draft guidance
- repo `git status` could not be used in this run because Git reported a `safe.directory` ownership guard on `E:/AI/Viet-Travel-Phrases`
