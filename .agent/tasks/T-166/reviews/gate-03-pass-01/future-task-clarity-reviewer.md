# Gate 3 Pass 1: Future-Task Clarity Reviewer

Approval: BLOCK

Blocking finding: `docs/design/homepage-research/README.md` "Recommended follow-up tasks" item 4 overlaps two separate practice-plan follow-ups: `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` "Offline Viet practice deck generator" and "Native Practice UI and listing-page entrypoints." The Home packet says "create a practice deck generator and Home practice entry," which could cause a future queue packet to re-own both generator work and practice entry UI. Split/reword it so Home only consumes the accepted generator/UI state, or explicitly references the separate generator/UI tasks.

Home V1, local saved/recent/practice-pool state, and practice validation are otherwise concrete enough and mostly non-overlapping.
