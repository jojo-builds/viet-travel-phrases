# T-144 feature brief

## Source
- Orchestrator-approved locked visual direction on `2026-04-23`
- Follow-on after completed phrase-page shell/search/lower-section passes (`T-135`, `T-137`)

## Feature
Implement the first substantial "AI-shaped listing page" experience for SpeakLocal on the winning Liquid Glass branch.

## Intent
- turn the phrase listing page into a structured answer surface rather than a flat phrase detail screen
- make the user feel like they asked an AI a travel-language question and received a curated native-iOS answer page
- keep the experience fully app-native and database-backed, not an actual chat UI
- preserve the current premium Liquid Glass direction while making the page meaningfully more useful and connected

## Locked product principle
- Listing pages are AI-shaped answer pages, not simple phrase detail pages.
- The page should answer prompts like:
  - `Different ways to say hello in Vietnam`
  - `Different ways to say I need a doctor in Vietnam`
- The page should present:
  - best default phrase
  - quick say
  - alternate/situational variants
  - how locals actually say it
  - breakdown
  - when to use it
  - follow-ups
  - cultural note
  - connected next phrases
- Linked cards/phrases should feel like Wikipedia-style connected knowledge surfaces that open other listing pages.

## Locked visual direction for this pass
- highly native iOS
- strong Liquid Glass control layer
- white / very light gray content base
- restrained Vietnam red/yellow accents only
- hero image header above the phrase content
- floating Liquid Glass back button
- large phrase title, English translation, pronunciation
- main audio dock with favorite, play, and 0.5x / 0.75x / 1.0x controls
- bottom floating toolbar with:
  - `Home`
  - `Browse`
  - `Saved`
  - `Search`

## Required behavior from the source direction
- the hero image should behave like a scrollable/collapsing header, not a fixed wallpaper
- the back button should remain floating above content
- the bottom toolbar should remain a separate floating control layer
- the content below the hero should feel like a curated AI-style answer, not stacked database cards
- some lower cards/rows/phrases must be tappable and open their own listing pages in preview
- audio should remain prominent for the main phrase and for important linked items where appropriate

## Product constraints from orchestrator
- this belongs on the current winning Liquid Glass branch/worktree
- do not reduce this into tiny prep tasks or documentation-only work
- the task should produce a clearly reviewable upgraded listing-page workflow in the preview
- missing custom assets are not blockers; use placeholders or existing local imagery if needed
- this is a meaningful task and must use the full 3-gate / 4-reviewer contract
