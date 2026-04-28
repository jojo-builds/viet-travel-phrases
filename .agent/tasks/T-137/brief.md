# T-137 feature brief

## Source
- Google Doc: `Features for SpeakLocal`
- Follow-on orchestrator recommendation after `T-135`

## Feature
Implement grouped small listing cards / grouped variants for the phrase product page so the lower half of the experience feels lighter, more modern, and less like a dated stack of oversized cards.

## Intent
- move the lower phrase sections away from the old heavy card stack
- keep the hero as the main playback surface
- make same-family options feel like grouped supporting choices, not separate competing product pages
- keep `Next` feeling like deeper forward motion

## Required behavior from the source direction
- preserve the current dedicated search-page shell behavior from `T-135`
- focus on the phrase page below the hero controls
- use lighter grouped surfaces for:
  - `Quick say`
  - `Break it down`
  - `Other ways`
  - `When to say`
  - `Next`
- every non-English row still needs English visible underneath
- lower items should feel more compact and scannable
- the page should feel calmer and more iOS-native, not card-stacked and dated

## Product constraints from orchestrator
- this belongs on the current winning Liquid Glass branch/worktree
- do not touch the separate visual-board lane
- keep the strongest Liquid Glass treatment in the shell/control layer, not the lower content layer
- this is a meaningful task and should use the full 3-gate / 4-reviewer contract
