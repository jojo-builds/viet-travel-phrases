# TASK-BROWSE-SEARCH-VISUAL-DESIGN-001: Browse And Search Native Screen Design Packet

## Task Done

Jojo has a production-ready visual design packet for the SpeakLocal Browse page
and Search page: the screens make it obvious how Browse and Search differ, both
feel native iOS/Liquid Glass and consistent with the current app, and the packet
is clear enough for the Native UI lane to implement without inventing the UX.

## Context

SpeakLocal has bottom admin chrome with Home, Browse, Saved, and Search. The
Browse and Search icons need real destination screens, not placeholder screens.

The intended product distinction:

- Browse is deliberate exploration: categories, cities, situations, phrase
  families, language levels, saved/practice-informed shelves, and paths into the
  phrase graph.
- Search is intent-led discovery: a search field is present, but the page should
  still be useful before typing. It should show suggested shelves, recent/common
  needs, popular traveler queries, city/category shortcuts, and likely next
  phrases. When the user taps Search from the bottom chrome, land on the Search
  page without forcing the keyboard open; the keyboard should appear only after
  the user taps into the text field.

Source truth to preserve:

- `docs/design/NATIVE_VISUAL_REFERENCE.md`
- current live native screenshots referenced from that file
- current bottom chrome/admin island behavior and Liquid Glass direction
- SpeakLocal principle: offline, calm, premium, first-time-traveler friendly,
  phrase graph / Wikipedia-like exploration, no generic web-page feel

## Worker Judgment

Act as a senior native iOS product designer. Reason from the current app, Apple
search/browse patterns, and SpeakLocal's phrase graph. Do not overbuild a
dashboard. Do not copy the App Store literally. Translate the behavior into
SpeakLocal's language-learning/travel context.

If you need Jojo to choose between materially different directions, ask before
locking the final packet. Otherwise, make a strong recommendation and show why.

## Required Outcome

Produce a Jojo-reviewable design packet under:

```text
docs/design/browse-search/
```

The packet should include:

- high-fidelity visual comps or screenshot-like raster mockups for Browse and
  Search;
- a readable `README.md` explaining the UX model, screen sections, and why Browse
  and Search are different;
- an `index.html` contact sheet or gallery if helpful for visual review;
- a prompt packet if image generation or visual composition prompts are used;
- one focused peer review checking native fit, clarity, visual busyness,
  placeholder copy, and whether the Search page behavior matches Jojo's intent.

Minimum screens to design:

- Browse default page.
- Browse scrolled state if sticky/section behavior matters.
- Search default page after tapping the bottom search icon, with no keyboard.
- Search field focused state with keyboard expectation described or shown.
- Search results state with query text.
- Search empty/no-match recovery state.

Design content should include realistic SpeakLocal examples, not lorem ipsum or
internal labels. Use Vietnam examples such as greetings, airport, hotel,
restaurant, cities, saved/practice phrases, and phrase families when useful.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `docs/design/browse-search/**` and `docs/task-results/TASK-BROWSE-SEARCH-VISUAL-DESIGN-001.md`.
- Do not implement SwiftUI or edit `native-ios/App/**`.
- Do not edit SQLite/content generators.
- Do not create rough HTML/CSS as the final visual quality bar unless it is only
  a gallery for real screenshots/mockups.
- Do not use placeholder text, robotic copy, or generic travel trivia.

## Validation

- Verify image paths or gallery links render locally.
- Run `git diff --check`.
- Run one focused peer review before closeout.
- Confirm the final packet answers:
  - what Browse shows;
  - what Search shows before typing;
  - when the keyboard appears;
  - how users tap through without typing;
  - what Native UI should implement first.

## Result Contract

Write `docs/task-results/TASK-BROWSE-SEARCH-VISUAL-DESIGN-001.md` with:

- status: done or blocked;
- commit hash;
- artifact paths;
- gallery path or URL if available;
- design recommendation;
- any Jojo decisions still needed;
- peer review outcome;
- recommended Native UI implementation task.
