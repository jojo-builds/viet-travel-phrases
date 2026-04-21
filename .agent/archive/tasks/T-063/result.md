status: done

truth changed classification:
- prepared-next
- Korean prep lane upgraded from research-ready to authoring-ready scaffold truth

changed files:
- `.agent/tasks/T-063/spec.md` - fixed the task-local review-artifact wording, narrowed the write scope to the actual scaffold surface, and clarified that `T-063` supersedes the blocked bootstrap predecessor for this lane.
- `content-draft/korean/README.md` - now describes the Korean lane as authoring-ready and points the next pass at the scaffold files instead of future shortlist work.
- `content-draft/korean/source-notes.md` - records the Korea-fit rewrite decisions already made in source truth plus the remaining risk flags.
- `content-draft/korean/phrase-source.csv` - added the full 70-row prep-only source scaffold with Korea-fit English rewrites, per-row notes, and row status markers.
- `content-draft/korean/first-wave-priority.csv` - added the ranked 30-row starter queue with required priority columns and explicit review flags.
- `content-draft/korean/research-backlog.md` - shifted the backlog from shortlist creation toward translation, pronunciation, native review, and graduation blockers.
- `.agent/tasks/T-063/reviews/gate-01-pass-03/*.md` - recorded the unanimous Gate 1 approval set after contract cleanup and live queue-truth confirmation.
- `.agent/tasks/T-063/reviews/gate-02-pass-01/*.md` - recorded the unanimous Gate 2 approval set for the completed scaffold pass.
- `.agent/tasks/T-063/reviews/gate-03-pass-01/*.md` - recorded the unanimous Gate 3 approval set authorizing task closure.
- `.agent/tasks/T-063/result.md` - recorded the final closeout summary required by the task contract.

validation performed:
- claimed `T-063` through the shared queue launcher and canonical helper path with `SPEAKLOCAL_REVIEW_RUNTIME=subagents`
- verified every required Korean output file exists
- verified `content-draft/korean/phrase-source.csv` is non-empty and contains 70 scaffold rows
- verified `content-draft/korean/first-wave-priority.csv` is non-empty and contains 30 ranked rows
- verified every ranked `phrase_id` in `first-wave-priority.csv` resolves to a row in `phrase-source.csv`
- parsed `content-draft/korean/scenario-plan.json` successfully
- verified Gate 1, Gate 2, and Gate 3 review evidence exists under `.agent/tasks/T-063/reviews/`
- verified the latest pass for Gate 1, Gate 2, and Gate 3 each contains exactly 4 review files
- verified all 4 subagents explicitly approved the latest pass of Gate 1, Gate 2, and Gate 3
- verified the changed work for this task stayed inside `content-draft/korean/**` and `.agent/tasks/T-063/**` plus queue-index lifecycle truth
- verified the Korean lane is more authoring-ready than before because the next translation task can now start from the scaffold and ranked shortlist without another orientation pass

review findings and what was fixed:
- Gate 1 initially exposed two contract issues: the task spec said `exactly 4 review artifacts` even though the task required 3 gates with 4 reviewers each, and the older blocked Korean bootstrap task looked like a live ownership collision to one reviewer.
- Those issues were handled by tightening the task-local spec, clarifying that `T-063` is the active scaffold-completion task for the Korean lane, and re-running Gate 1 with live queue-truth evidence from task state, queue index, and queue helper behavior.
- Gate 1 also confirmed the real content gap: the Korean lane still lacked a reusable row-level scaffold and ranked shortlist. That gap was handled by adding `phrase-source.csv`, `first-wave-priority.csv`, and matching doc updates.
- Gate 2 and Gate 3 both approved without requiring further fixes. Remaining risk is intentionally visible in `review_flag` and row status markers instead of being hidden.

gate status:
- Gate 1: pass 03 approved unanimously by all 4 reviewers after task-local contract cleanup and live queue-truth confirmation
- Gate 2: pass 01 approved unanimously by all 4 reviewers after the scaffold and doc updates landed
- Gate 3: pass 01 approved unanimously by all 4 reviewers for final task closure

substantive risks or follow-up cautions:
- This lane is still prep-only and is not runtime-ready.
- Korean politeness wording, apology-versus-attention choices, medical wording, allergy wording, and some payment or transit phrasing still need later native or expert review.
- Pronunciation coverage, honest audio posture, and Hangul-search validation remain later work and should not be implied solved by this scaffold task.
- Historical Korean-lane references tied to blocked `T-018` still exist in older shared queue surfaces and may be worth cleaning up later for human readability, even though the live queue helper uses task state plus queue index as lifecycle truth.

recommended next step:
- run the next Korean translation task against the top-ranked rows in `content-draft/korean/first-wave-priority.csv`, preserving the visible review flags and row status markers while filling `target_text` and `pronunciation`

## Process feedback

- SUGGESTION: the queue helper closeout rules are stricter than the task spec alone, so future scaffold tasks should mention the required heartbeat-after-claim step and the exact `Approval: APPROVE` review-file wording directly in the task template to avoid a last-minute finish retry.
