# SpeakLocal City Pages v2.2 Productionizer Pass

Status: pre-import editorial gate for captured ChatGPT Project drafts

This pass turns draft output into a Jojo-review candidate or a focused rewrite request. It does not make copy production-ready by itself.

## Decisions

Use one label per page:

- `ready_for_jojo_voice_review`
- `revise_before_review`
- `blocked_missing_source`

## Gate

Check each page for:

- one owned traveler moment that shows in the first screen
- app-visible copy free of export labels such as `Reader View`, `Sections`, `Phrase cards`, `Mentioned Here`, `QA`, `render`, `check_catalog`, scores, source/freshness labels, and readiness status
- headings that feel observed, not a repeated command scaffold
- phrase cards that are reusable traveler actions with ready audio
- repeated phrase-card sets that are justified or varied
- thin-source rows that stay narrow or are blocked instead of filled with generic props
- implementation notes that keep source, freshness, phrase/audio, Mentioned Here, and related-card decisions separate from visible copy

## Agent Mode Test

Agent mode is not the default copy workflow. Use it only when it can do bounded evidence work better than a normal Project chat: current official pages, venue status, access rules, ticket rules, or stale source checks.

If Agent mode is unavailable inside the Project, use normal Project `Pro`/`Thinking` for the productionizer pass and keep Agent mode out of the critical path.

## Output

For each page, output:

- decision label
- visible-copy issues found
- phrase/audio/card risks
- source/freshness risks
- revised Reader View only if needed
- next Codex action
