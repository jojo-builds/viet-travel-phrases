# TASK-NATIVE-SWIPE-TRANSITION-POLISH-001

## Task Done

Native swipe back and swipe forward feel like one continuous iOS-style interactive transition: both visible content layers stay vertically locked during the gesture, the underneath page does not jump/pad down then snap up, and the top page does not perform a second autonomous swipe after the user's finger reaches the end.

Bottom chrome search morph also feels like one directional Liquid Glass transition: when the user taps the magnifying glass from Home/Browse/Saved/Practice, the current tab icon moves/morphs into the left-of-search position from its real origin while the search pill expands from the search button. Icons must not drift the wrong direction, dip vertically, appear from the opposite side, overlap awkwardly, or wobble left-right-left.

## Context

Jojo reproduced this on-device while moving between pages with edge swipes:

- Swiping from the left reveals the underneath content slightly padded down; once the top page clears, the underneath content jumps back up.
- Near the end of the gesture, the top page appears to swipe again without the finger, creating a double-swipe effect.
- The same family of bugs appears when swiping from the right/forward: incoming or underneath content picks up top padding during the gesture, then another completion animation fires after the hand-driven part visually finishes.
- Jojo also reproduced a bottom-chrome morph bug from Browse: tapping the magnifying glass makes the Browse icon move right/down first, then later appear as if it is coming from the left into its final left-of-search position. The expected feel is that the Browse icon travels from its actual Browse tab location toward the left search accessory position, while the search button/pill expands coherently from the right.

This must feel native and Liquid Glass-adjacent: one controlled sheet-like motion, not two layers fighting each other.

## Worker Judgment

Find the root cause before patching. This is likely transition state, scroll offset, safe-area/top-chrome inset, or gesture-completion animation coupling. Fix the transition model, not one screen.

## Required Outcome

- Interactive back and forward swipes keep both visible pages vertically fixed while two pages are on screen.
- Completing the gesture continues from the current finger-driven position without a visible second slide.
- Canceling or partially releasing the gesture returns smoothly without vertical content drift.
- The static bottom chrome/glass layer remains stable during the swipe.
- Search morph from Home, Browse, Saved, and Practice uses the correct previous tab icon on the left and animates from the real tab position toward the search field. Direction should match physical movement: Browse should not move right/down first or appear from the left when it should come from the admin bar.
- Search pill and tab accessory heights/sizes should feel matched enough that the morph reads as one piece of glass changing shape, not two unrelated controls crossing over each other.
- Back button, forward button, bottom-tab taps, search/browse/home navigation, and phrase detail navigation still work.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Expected write scope: `native-ios/App/**`, native tests, and small supporting docs/results.
- Do not touch content JSON, SQLite resources, generated phrase resources, or audio assets unless the bug investigation proves a direct native-runtime dependency.
- Do not change Apple signing/project personal settings.

## Validation

- Reproduce before fixing and describe the root cause in the result.
- Add or update focused native tests where practical for transition/navigation state.
- Build the native app.
- Run targeted tests for app chrome/navigation.
- Simulator-check at least:
  - home -> saved/detail -> edge-swipe back
  - forward swipe after a back swipe
  - browse/search/home bottom chrome transitions after swipe navigation
  - Browse -> tap magnifying glass -> search morph, checking that the Browse icon moves in the correct direction and the search pill expands without overlap/wobble
  - Home/Saved/Practice -> tap magnifying glass, checking the selected icon is preserved and morphs from the correct side
- Capture screenshot or short screen-recording evidence if practical.
- Run `git diff --check`.
- Run a read-only peer review focused on whether Task Done was actually met and whether the fix introduces navigation regressions.

## Result Contract

Write `docs/task-results/TASK-NATIVE-SWIPE-TRANSITION-POLISH-001.md` with:

- root cause
- user-visible behavior fixed
- files changed
- validation run
- reviewer outcome
- remaining risks or follow-up, if any
- final `git status --short`

Commit when done.
