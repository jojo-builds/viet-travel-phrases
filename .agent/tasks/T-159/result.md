# Result: T-159

## Status
- done

## Truth changed
- prepared-next

## Changed files
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` - expanded the practice/quiz + mascot lane into an implementation-ready product plan.
- `docs/PRIORITIES.md` - pointed near-term roadmap truth at the completed practice plan and clarified validation boundaries.
- `.agent/tasks/T-159/logs/research-notes.md` - captured compact research links, source summaries, and asset inventory commands.
- `.agent/tasks/T-159/reviews/` - captured Gate 1 and Gate 2 latest-pass review artifacts.
- `.agent/tasks/T-159/state.json` - queue lifecycle heartbeat/phase updates for this worker.

## Summary
- Defined the first Practice MVP as offline traveler rehearsal with `Listen And Choose`, `Situation Pick`, `Pronoun Coach`, `Practice This Page`, and `Review Missed`.
- Added a bounded local review scheduler with explicit due intervals and missed-item behavior.
- Corrected source reality: current generated Viet catalog is under `native-ios/Resources/`, and the named `Chào ...` pronoun child pages do not currently exist.
- Added generator handoff requirements for authored page, section, phrase-row, breakdown-token, related-page, and audio validation.
- Scoped mascot work as a later asset/integration lane with serious-context restraint.

## Research sources
- https://www.reddit.com/r/languagelearning/comments/1lze50r/what_are_your_biggest_problems_with_language/
- https://www.reddit.com/r/duolingo/comments/1g3whea/duolingo_repetitive/
- https://www.reddit.com/r/duolingo/comments/1rrsqpz/is_it_just_me_or_does_duolingo_eventually_just/
- https://www.reddit.com/r/languagelearning/comments/1hd7t0e/too_many_apps_rely_on_streaks/
- https://link.springer.com/article/10.1007/s10648-021-09595-9
- https://www.nature.com/articles/s44159-022-00089-1
- https://blog.duolingo.com/spaced-repetition-for-learning/
- https://developer.apple.com/design/human-interface-guidelines/feedback
- https://arxiv.org/abs/2203.16175
- https://arxiv.org/abs/2305.08346

## Validation
- `git diff --check` - passed
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy` - passed
- `python3 -m json.tool .agent/tasks/T-159/state.json >/tmp/t-159-state.json` - passed

## Reviews
- Gate 1 latest pass: `.agent/tasks/T-159/reviews/gate-01-pass-03/` - 4/4 latest-pass artifacts include `Approval: APPROVE`.
- Gate 2 latest pass: `.agent/tasks/T-159/reviews/gate-02-pass-03/` - 4/4 latest-pass artifacts include `Approval: APPROVE`.
- Gate 3 latest pass: `.agent/tasks/T-159/reviews/gate-03-pass-04/` - 4/4 latest-pass artifacts include `Approval: APPROVE`.

## Follow-up tasks
- `T-160` recommendation: generate offline Viet practice deck resources plus practice audio/source validation.
- `T-161` recommendation: build native SwiftUI Practice surfaces and listing-page entrypoints.
- `T-162` recommendation: create mascot art direction and asset integration package.
- `T-163` recommendation: run practice validation, simulator proof, and device-readiness pass.
- Separate content/graph task recommended: repair unresolved authored `detailPageID` links such as `viet-polite-hello` and `viet-family-repair-meaning`.
- Separate source-truth doc task recommended: qualify `docs/PHRASE_RELATIONSHIP_MODEL.md` so its `app/family/packs/viet.generated.ts` runtime-truth line is clearly Expo/reference-lane truth and does not conflict with current native `native-ios/Resources/*.json` truth.

## Blockers
- None for this planning task.

## Process feedback
- SUGGESTION: task specs that name generated resource paths should include a current-path fallback when a resource has recently moved.
- SUGGESTION: listing-page review gates should explicitly ask for unresolved `detailPageID`, row-anchor, and token-anchor checks up front.

## Recommended next step
Review `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`, then queue T-160 as the offline Viet practice deck generator if Jojo accepts the plan direction.
