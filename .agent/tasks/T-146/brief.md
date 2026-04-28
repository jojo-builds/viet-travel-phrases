# T-146 feature brief

## Source
- Follow-on after completed `T-144`
- Orchestrator recommendation on `2026-04-23`

## Feature
Refresh and upgrade the visual review board so it captures the new AI-shaped listing-page states from `T-144` and makes them easier to scan as a current-state design board.

## Intent
- give the user a better one-glance review surface while `T-145` runs on the Viet content lane
- capture the new answer-page states instead of leaving the board on the older phrase-page shape
- make the board more useful for deciding what needs polish next without opening Expo flows manually

## Required behavior from the source direction
- use the existing visual-board worktree/lane
- include the new listing-page answer states:
  - default hero
  - hero-swapped state
  - deeper linked-page state
  - search entry/result state if available
- keep the artifact refreshable and honest
- improve labels/metadata if needed so the board better communicates what each screen is proving

## Product constraints from orchestrator
- this must stay disjoint from `T-145`
- do not reopen the main UI implementation lane for this task
- this is a meaningful support task because it directly improves visual decision-making during rapid design iteration
- this task should use the full 3-gate / 4-reviewer contract
