# City Hero Image Production 505 Review Gate

Task done means all 505 scoped city images are realistic, accurate, imported, wired into the app, reviewed, validated, and running on the simulator for Jojo to test.

## Scope

- 500 approved city noun/detail pages from `content-draft/viet/city-library/v1.json`.
- 5 city hub mastheads: Hanoi, HCMC/Saigon, Da Nang, Hoi An, Hue.
- No merge to `main`; keep all work on the current feature branch.

## Image Standard

- App-owned generated or otherwise documented app-owned source only.
- Realistic travel/editorial image quality.
- No readable generated text, fake signs, logos, watermarks, or people as the main subject.
- No wrong-city visual cues or generic Vietnam fallback imagery.
- Subject must be recognizable in the iOS masthead crop: upper third, center 70% width.
- Committed asset catalog image size: `853 x 1844`.
- Prefer PNG for city hero asset compatibility with tracker tooling.

## Production Flow

1. Build/update the manifest with `native-ios/scripts/build-viet-city-hero-image-manifest.js`.
2. Generate the 10-image style gate first.
3. Review and self-fix style-gate failures before large batches.
4. Generate/import in batches.
5. Import only approved images with `native-ios/scripts/import-viet-city-hero-assets.js`.
6. Regenerate authored listing pages and SQLite after imports.
7. Run validation after every batch.

## Final Review Gate

- Dispatch at least two fresh read-only subagents.
- Each subagent must review every one of the 505 images, not samples.
- Each image receives `PASS`, `FIX_NOW`, or `BLOCK`.
- Review criteria:
  - realistic and high quality;
  - correct city/place/dish/experience;
  - unique where required;
  - no fake readable text, logos, watermarks, or wrong-city cues;
  - crop-safe in the app masthead;
  - wired to the correct page/hub in the app.
- If either subagent marks any image `FIX_NOW` or `BLOCK`, self-fix or regenerate it and rerun the review gate.
- Closeout is allowed only when both subagents return `505 PASS`, `0 FIX_NOW`, `0 BLOCK`.

## Final Validation

- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/validate-viet-hero-image-assets.js --require-unique-city-place-assets`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- focused native tests for city pages and hero lightbox
- `git diff --check`
- Launch on the simulator at the end and leave it ready for user testing.
