# Viet Canonical Phrase Pages

This folder is the durable authored source for SpeakLocal Vietnam phrase pages.

Product rule: every canonical phrase page should be a full traveler-facing article page. Do not create "support", "thin", "fallback", or half-depth pages. A phrase page should feel like a thoughtful offline answer to "Different ways to say [phrase] in Vietnam", with clear learner flow, useful related phrases, and positive first-time-traveler guidance.

## Source Lanes

- `tier-one/` contains the original high-value starter family pages and their meaningful child phrase pages. The name describes source origin, not page quality.
- `catalog-promoted/` contains phrase catalog rows promoted into full authored canonical pages. These pages are equal in product status to `tier-one/`.
- `../city-library/` contributes city and place phrase pages into the same canonical graph.

The lane metadata lives in `_source-lanes.json`.

## Editing Rules

- Edit source records here or in the lane-specific source folders, then regenerate.
- Do not hand-edit generated runtime resources under `native-ios/Resources/**`.
- Use the `speaklocal-listing-pages` skill when authoring, reviewing, or repairing phrase pages.
- Preserve canonical phrase IDs unless a validator proves a real duplicate or graph bug.
- Keep `Break it down` captions phrase-specific and learner-friendly. Avoid labels like `word`, `detail`, `question ending`, `first name part`, or other generic placeholders.

## Regeneration

From `native-ios/`:

```sh
node scripts/generate-authored-tier-one-pages.js
node scripts/generate-viet-sqlite-fixture.js
```

The generated app-facing bundle is `native-ios/Resources/viet-authored-listing-pages.json`; the long-term offline runtime bundle is `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`.
