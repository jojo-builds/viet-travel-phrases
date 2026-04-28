# T-154 feature brief

## Source
- Follow-on after completed `T-152`
- Orchestrator-approved next move on `2026-04-23`

## Feature
Harvest and retain the real flagship Viet phrase clusters behind the most important traveler intents so the listing-page system stops depending on one thin default phrase where the actual answer is a richer cluster.

## Intent
- use AI-assisted reasoning as a candidate generator, not as disposable output
- save the genuinely useful alternate phrasings, confirmation forms, likely replies, repair branches, and next-step phrases for the top traveler intents
- push the Viet listing-page system closer to real product completeness by deepening the pages users are most likely to open first
- leave an auditable keep/reject trail so the repo captures why retained rows were promoted into durable truth

## Locked product principle
- Major traveler-intent pages should preserve the real phrase cluster, not just one visible phrase.
- AI-generated candidate rows are inputs to triage, not automatic truth.
- Saved rows should be useful enough that they deserve future audio coverage.

## Required behavior from the source direction
- focus on flagship pages where the user most expects the app to feel smart and complete
- add real row truth to `phrase-source.csv` when the candidate introduces meaningful traveler utility
- strengthen relation buckets and answer-page modules to match the retained rows
- keep the page-level answer experience practical rather than bloated or repetitive

## Product constraints from orchestrator
- this belongs on the Viet content branch/worktree, not the UI branch
- this should be a meaningful overnight content/database task, not note-taking
- this is a meaningful task and must use the full 3-gate / 4-reviewer contract
