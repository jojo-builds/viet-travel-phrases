status: done
truth changed classification: prepared-next

Changed files:

- `content-draft/german/phrase-source.csv`
  - added a full 70-row prep-only source scaffold for the shared 10-scenario seam, with Germany-fit English rewrites, row-level notes, and status markers
- `content-draft/german/first-wave-priority.csv`
  - added a ranked 30-row first-wave shortlist so the next translation task has an explicit starting queue
- `content-draft/german/README.md`
  - updated the lane status from research-only to authoring-ready and pointed the next pass at the new scaffold files
- `content-draft/german/source-notes.md`
  - recorded the rewrite decisions already made, the remaining risk flags, and the next translation-pass rules
- `content-draft/german/research-backlog.md`
  - replaced the old shortlist-creation backlog with translation, review, pronunciation, and graduation follow-up work
- `content-draft/german/scenario-plan.json`
  - updated quick-phrase emphasis and lane notes to match the new first-wave contract

Validation performed:

- verified every required German output file exists
- verified `content-draft/german/phrase-source.csv` exists and has 70 data rows
- verified `content-draft/german/first-wave-priority.csv` exists and has 30 ranked rows
- verified every shortlisted `phrase_id` exists in `phrase-source.csv`
- verified `content-draft/german/scenario-plan.json` parses
- verified Gate 1, Gate 2, and Gate 3 review evidence exists with 4 review files per latest pass
- verified the working pass stayed inside `content-draft/german/**` plus task-local review artifacts

Review findings and what was fixed:

- Gate 1 required a stricter scaffold contract before edits:
  - fixed by predeclaring the exact `phrase-source.csv` schema, full 70-row coverage, and the rule that every shortlisted row must exist in the source scaffold
- Gate 1 required the language-risk surface to stay visible in metadata:
  - fixed by carrying forward service-wording, transit, and medical review debt in row notes, statuses, and shortlist flags instead of only in prose docs
- Gate 1 required Germany-fit rewrites to be chosen before translation:
  - fixed by rewriting the weak coffee, station, price, and route-confirmation English rows in the source scaffold
- Gate 2 found no blocking issues after the main working pass

Gate summary:

- Gate 1 latest pass: approved by all 4 reviewers
- Gate 2 latest pass: approved by all 4 reviewers
- Gate 3 latest pass: approved by all 4 reviewers

Objective status:

- Fully met for this prep-only task. Germany now has a reusable row-level source scaffold plus a ranked first-wave queue, so the next German translation task can start immediately without recreating orientation or rewrite triage.

Remaining risks or cautions:

- first-wave service-heavy rows still need native or expert review for polite everyday standard German and pronoun-light request wording
- `simple-problems-6` remains a medical holdout and should not be treated as linguistically settled before expert review
- pronunciation, audio posture, and search-helper rules are still future graduation work and were not solved in this scaffold pass

Recommended next step:

- start the next German translation task by translating the top 15 rows from `content-draft/german/first-wave-priority.csv` directly into `content-draft/german/phrase-source.csv`, preserving the existing notes and risk markers

## Process feedback

- SUGGESTION: the T-062 closeout loop became awkward because Gate 3 was reviewing the administrative result summary at the same time that the result summary needed Gate 3 to already be complete; future specs should either exclude `result.md` from Gate 3 review or require a separate final bookkeeping update after the gate closes.
