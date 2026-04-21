status: done

truth changed classification:
- prepared-next
- Korean prep lane upgraded from shortlist-only scaffold truth to a translated first-wave pack with a narrower unresolved queue

changed files:
- `content-draft/korean/phrase-source.csv` - translated the 30 ranked first-wave rows into Hangul with traveler-friendly romanization and explicit sensitive-status handling for the medical line.
- `content-draft/korean/first-wave-priority.csv` - marked all 30 ranked rows as translated or translated-sensitive and recorded row-level disposition notes for the cleared batch.
- `content-draft/korean/README.md` - updated the lane summary so it now reflects a translated first-wave batch instead of a shortlist-only scaffold.
- `content-draft/korean/source-notes.md` - documented the first translated batch plus the remaining service wording transit payment and medical cautions.
- `content-draft/korean/research-backlog.md` - replaced the obsolete top-15 translation plan with post-batch follow-up work and remaining graduation blockers.
- `.agent/tasks/T-076/reviews/gate-01-pass-01/*.md` - recorded the unanimous pre-edit Gate 1 approval set.
- `.agent/tasks/T-076/reviews/gate-02-pass-01/*.md` - recorded the unanimous post-edit Gate 2 approval set.
- `.agent/tasks/T-076/result.md` - drafted the required task closeout while Gate 3 remains pending.

validation performed:
- verified every required Korean output file exists after the main pass
- parsed `content-draft/korean/phrase-source.csv` successfully as CSV
- parsed `content-draft/korean/first-wave-priority.csv` successfully as CSV
- verified `phrase-source.csv` contains 70 rows total and 30 `first-wave-translated*` row outcomes
- verified `first-wave-priority.csv` contains 30 ranked rows and all 30 now show `first-wave-translated*` execution status
- verified the medical row remains explicitly marked `first-wave-translated-sensitive`
- verified Gate 1 review evidence exists with exactly 4 review files and unanimous `Approval: APPROVE`
- verified Gate 2 review evidence exists with exactly 4 review files and unanimous `Approval: APPROVE`
- verified Gate 3 review evidence exists with exactly 4 review files and unanimous `Approval: APPROVE`
- verified work stayed inside `content-draft/korean/**` and `.agent/tasks/T-076/**`

review findings and what was fixed:
- Gate 1 authoring-readiness review flagged that the backlog still described a top-15 pass even though this task required at least 24 row outcomes. The backlog was updated to the real 30-row cleared batch plus next-pass follow-up work.
- Gate 1 otherwise approved the starting scaffold and risk posture. No pre-edit contract issue required a second pass.
- Gate 2 approved the translated batch without requesting row rewrites. The main caution that remained explicit was the medically sensitive `I need a doctor` row.
- Gate 3 approved the drafted closeout without requesting further edits. `result.md` now matches the final reviewed state.

gate status:
- Gate 1: pass 01 approved unanimously by all 4 reviewers
- Gate 2: pass 01 approved unanimously by all 4 reviewers
- Gate 3: pass 01 approved unanimously by all 4 reviewers for final closure

substantive risks or follow-up cautions:
- This lane is still prep-only and is not runtime-ready.
- Service-wording rows such as `Excuse me`, `Take me here`, `Could I pay, please?`, and hotel-desk requests still need later native review for apology-versus-attention posture and softening.
- Transit and payment rows now have usable Korean drafts but should stay visible for later native review before runtime graduation.
- `I need a doctor` remains intentionally translated-sensitive and should not be treated as medically settled wording before expert review.
- Romanization is now present on the cleared batch but it is still helper-only and not a substitute for audio or native validation.

recommended next step:
- continue from the unresolved Korean rows below the cleared top-30 batch, starting with room-problem, convenience-store, directions follow-up, and cafe-adjustment lines while preserving the current risk flags

## Process feedback

- SUGGESTION: future translation-pack tasks should state the expected post-batch backlog rewrite explicitly so the initial scaffold wording does not survive into Gate 1 when the task already requires 24 to 36 row outcomes.
