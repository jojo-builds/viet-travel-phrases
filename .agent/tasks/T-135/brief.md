# T-135 feature brief

## Source
- Google Doc: `Features for SpeakLocal`
- Imported by orchestrator on `2026-04-22`

## Feature
Build the dedicated Search Page flow for the Liquid Glass phrase experience, inspired by the iOS App Store search behavior.

## Intent
- Tapping the bottom-right magnifier should expand search and move the user into a dedicated search page, not a confusing half-card flow.
- The interaction should feel App Store-like and clearly separate "search mode" from the underlying page.
- The resulting page should support both browse-first behavior and typed search results.

## Required behavior from the source brief
- search starts from the bottom-right magnifier control
- when search expands, the experience becomes a dedicated page
- motion should be noticeable and elegant, not abrupt
- only the originating toolbar icon should remain visible while inside the search page
- top of search page should use:
  - `Search`
  - `Suggested`
  - `Browse`
- `Suggested` should show popular listing-page cards
- `Browse` should show category/scenario cards
- typed search results should show the larger listing cards in relevance order
- tapping the card should open the listing page
- tapping the play affordance should transition into the listing page already playing

## Product constraints from orchestrator
- this belongs on the current Liquid Glass winner branch/worktree, not the legacy preview branch
- content below the shell should stay readable and calmer than the navigation/control layer
- if a blocker does not require user intervention or an external dependency, it should be solved inside the task rather than recorded as a blocker
- this is a meaningful task and should use the full 3-gate / 4-reviewer contract
