# Phrase Page Blueprint

Last updated: 2026-04-21
Scope: Viet phrase-detail experience before broader family rollout

## Core product thesis

SpeakLocal should not try to beat AI products at open-ended translation.

SpeakLocal should win on:

- speed
- trust
- offline usefulness
- curation
- practical next-step guidance for travelers

The phrase page is the core product page, not a generic listing page.

The goal is to make the user feel:

- "I found the right phrase quickly."
- "I understand how to use it."
- "I can say a shorter version if I panic."
- "I can hear better versions."
- "I know what to tap next."

## Current preference shifts

As of 2026-04-21, these refinements are preferred:

- de-emphasize or remove the earlier `Hear back` section for now
- add a phrase breakdown section so the user can understand what parts of the phrase mean
- avoid making every lower section look like another rounded card stack
- every non-English phrase or option should have English visible underneath it
- keep the top shell stable:
  - back arrow
  - rounded search bar
  - hero phrase area
- hero controls should clearly include:
  - play
  - `0.5x`
  - `0.75x`
  - `1.0x`
  - `Save`

## Desired motion model

The app should feel like guided forward motion:

- search or browse into a phrase
- land on a strong hero phrase page
- tap into alternate versions or next likely needs
- open another phrase page with the same shell
- keep exploring card-to-card without having to start over

The interaction model is:

- card to full page
- full page to related card
- related card to another full page

This is effectively a guided phrase graph, not a flat phrase database.

## Navigation model

The current preferred navigation model is:

1. Search is always available near the top.
2. Compact cards on home or filtered views open a full phrase page.
3. Related phrases and alternate phrases also open the same full phrase page template.
4. The user can go many taps deep if they want.
5. Back remains available, but the product should make forward tapping feel more natural than retreat.

## Guardrail against a maze

The nested behavior is good only if the next taps are high-quality.

To avoid turning this into a maze:

- do not show too many competing next options at once
- prefer a few strong "next likely need" phrases over a huge generic related dump
- keep the same page structure every time so the user always knows where to look
- keep labels short and stable
- let the current phrase be the hero every time, even when reached through a chain of taps

## Page shell

Each phrase page should use the same shell:

1. Back arrow
2. Search bar
3. Hero phrase block
4. Short supporting sections in a fixed order
5. Related tappable lanes near the bottom

This repeated shell makes deep tapping feel safe and predictable.

## Liquid Glass integration

- The phrase page should adopt Liquid Glass primarily in the shell and control layer, not the entire content stack.
- Best candidates for glass treatment:
  - back/search top shell
  - hero playback controls
  - floating or grouped primary actions
- Lower informational sections should stay calmer and more content-led:
  - lightweight rows
  - plain text
  - standard material surfaces where needed
- Avoid making `Quick say`, `Break it down`, `Other ways`, `When to say`, and `Next` all feel like equally glossy floating blobs.
- The hero should feel premium and native, but the lower half should stay readable and low-cognitive-load.

## Current preferred section set

The current best working section set is:

- `Quick say`
- `Break it down`
- `Other ways`
- `When to say`
- `Next`

Short labels matter because the product should feel fast and low-cognitive-load.

## Recommended page structure

### 1. Hero phrase

Top section should include:

- target phrase in Vietnamese
- romanized pronunciation
- English meaning
- main play button
- speed controls:
  - `0.5x`
  - `0.75x`
  - `1.0x`
- `Save`

This should occupy the strongest visual weight on the page.

### 2. Quick say

This replaces the earlier "least to get by" idea.

Preferred label:

- `Quick say`

Why:

- shorter
- more intuitive
- lower cognitive load
- feels actionable

Meaning:

- the shortest useful version that still gets understood
- especially helpful under stress

Examples:

- `doctor`
- `pharmacy`

Guardrail:

- this must be content-reviewed carefully so it stays useful and not overly blunt or misleading

### 3. Other ways

Preferred label:

- `Other ways`

This is where alternate variants live:

- more polite
- clearer
- also common
- any other travel-relevant variation

Recommended treatment:

- horizontal mini-card lane
- each item tappable
- each tap opens the same full phrase page shell

The first item in this lane can be the `Quick say` version if it exists, followed by fuller variants.

### 3.5. Break it down

Preferred label:

- `Break it down`

Purpose:

- help the traveler understand the main phrase in smaller memorable pieces
- show what parts roughly mean without turning the page into a grammar lesson

Example for `Tôi cần bác sĩ`:

- `Tôi` - `I / me`
- `cần` - `need`
- `bác sĩ` - `doctor`

Guardrail:

- this is a memory aid and comprehension aid, not a strict linguistic claim
- one-to-one glosses will not always be perfectly literal across languages

Recommended treatment:

- light list rows or inline segmented items
- keep English visible under every non-English item
- do not over-card this area

### 4. When to say

Preferred label:

- `When to say`

This should be:

- plain text
- not inside a decorative card
- short
- practical

Purpose:

- explain the real-world usage moment without looking like a lesson block

### 5. Next phrases

Preferred label:

- `Next`

This is the strongest differentiator.

Instead of generic "related" content, this should bias toward:

- what a traveler likely needs next in the same moment
- phrases that naturally continue the situation

Example for `I need a doctor`:

- `Where is the nearest pharmacy?`
- `Call an ambulance`
- `It hurts here`
- `I am allergic to...`
- `Please write it down`

Recommended treatment:

- horizontal lane of tappable cards
- each opens the same full phrase page shell

## Section labels should stay short

Short labels reduce cognitive load and fit the product direction.

Current preferred label set:

- `Quick say`
- `Break it down`
- `Other ways`
- `When to say`
- `Next`

Avoid longer educational labels unless testing proves they are needed.

## What not to do

- do not turn the page into a long article
- do not show giant educational walls above the fold
- do not make every section look equally important
- do not scatter play buttons across every lower card at first
- do not let related content become a random database dump

## Audio treatment guidance

Current preferred approach:

- main hero phrase gets the strong central play interaction
- lower lanes should prioritize tapping into the next phrase or updating the hero, not raw playback everywhere

Why:

- cleaner visual hierarchy
- clearer navigation model
- less UI noise
- reinforces that each item is a richer phrase page, not just a static row

## Interaction model for lower items

Not every lower item should behave the same way.

Current preferred direction:

- hero phrase:
  - strong play treatment
  - full controls
- `Quick say` and `Other ways` items in the same phrase family:
  - should update the hero phrase area in place
  - may optionally autoplay when selected
  - should not always push a brand new page
- `Next` items:
  - should open a new full phrase page
  - this is where the forward motion and deeper journey lives

This split keeps the product from becoming overly nested too quickly.

## Mini-player idea

The Apple Music-style mini-player idea is interesting, but it should be treated as a later experiment, not a core first design requirement.

Why:

- it adds meaningful complexity
- it risks making the phrase experience feel more like media playback than guided communication
- it may create confusion if the currently playing phrase keeps replacing the visible hero state

Safer first step:

- let the hero phrase own playback
- let same-family selections update the hero cleanly
- let `Next` phrases navigate deeper

If the core phrase page becomes strong, a lightweight persistent playback strip can be tested later.

## Surface treatment guidance

The lower half of the page should not feel like a stack of dated rounded cards.

Prefer a mixed system:

- one strong hero surface at the top
- lightweight rows
- inline chips
- clean horizontal lanes
- plain text for explanatory copy
- soft separators instead of repeated boxed cards everywhere

## Why this can beat AI for travelers

AI products are flexible, but that flexibility creates friction:

- the user must invent what to ask
- the user must judge the answer
- the experience is less curated under stress

This phrase page direction stands out by doing the opposite:

- show the phrase
- show the shorter version
- break the phrase down
- show better versions
- show the likely next thing
- keep the user moving

That is not "smarter AI."
That is a better travel flow.

## Open design questions

- exact visual treatment of `Quick say`
- whether `Hear back` needs a lane style or plain text treatment
- whether deeper chains need a lightweight path cue or whether the standard back behavior is enough
- whether any lower-lane items should eventually show a subtle audio affordance

## Current best first proof

Design and validate one page first:

- `Tôi cần bác sĩ`

That page should prove:

- hero playback
- `Quick say`
- `Break it down`
- alternate versions
- `When to say`
- `Next`

If that page feels great, the rest of the phrase system can inherit the same template.
