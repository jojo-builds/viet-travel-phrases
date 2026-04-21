# Search Rollout Brief

## Canonical session root

- `E:\AI\SpeakLocal-App-Family`

## What is already true

- Viet is the live release-distributed app.
- Tagalog is the current second runtime app candidate through the shared family seam.
- The corrected Tagalog preview build has been installed on device and visually confirmed by the user to launch as Tagalog and match the Viet baseline UI.
- The shared runtime seam already exists through:
  - `currentApp`
  - app registry
  - pack / presentation / audio / storage boundaries
- Spanish, Italian, Japanese, and Turkish still exist as prep-only lanes under `content-draft/` and `ops/apps/`.
- Shared search is now implemented locally across Viet and Tagalog and passes the local validation matrix.

## Default next execution target

- finish the first shared feature rollout by verifying the current device builds, capturing the runtime/manual search smoke in Viet and Tagalog, then capturing the fuller device walkthrough evidence before freezing that as the family baseline

## Execution-process requirement

Use the execution-process skill at every major gate:

1. discovery
2. plan review
3. implementation
4. implementation review
5. validation
6. validation review
7. completion review

Use 4 reviewer lanes at each gate:

1. family architecture / seam safety
2. product UX / localization contract
3. release ops / docs / manifests
4. QA / regression / device validation

## Frozen v1 search decisions

- Search is in-app only, never cross-app.
- Search entry lives at the top of the Learn/Home screen, directly under the greeting/settings row.
- Empty query keeps the current Home unchanged.
- Active query hides quick phrases and scenario cards, and shows only a flat results list on the Learn screen.
- Saved remains separate in v1.
- No new tab, no modal, no persistence, no analytics, no search history.
- All search UI strings must live in per-variant `presentation.search` copy:
  - `placeholder`
  - `resultsTitle`
  - `emptyTitle`
  - `emptyBody`
  - `clearLabel`
- Search reads only the active variant:
  - `currentApp.pack.phrases`
  - `currentApp.pack.scenarioMap`
  - `currentApp.presentation.search`
- Search match fields in v1:
  - `sourceText`
  - `targetText`
  - `pronunciation`
  - `context`
  - scenario name
- Search normalization in v1:
  - trim
  - lowercase
  - whitespace collapse
  - Latin diacritic stripping
  - punctuation folding
- Result ordering in v1:
  - pack/scenario order
  - phrase order within each scenario

## Validation expectations

Run from `E:\AI\SpeakLocal-App-Family\app`:

- `npm run build:tagalog-pack`
- `npm run validate:family`
- `npx --no-install tsc --noEmit`
- `npx expo config --type public --json`
- `npx expo export --platform ios --output-dir .expo-export-viet-check`
- `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx --no-install tsc --noEmit`
- `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx expo config --type public --json`
- `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx expo export --platform ios --output-dir .expo-export-tagalog-check`

Search-specific validation must prove:

- results never cross app boundaries
- English queries work
- target-language queries work
- pronunciation queries work
- scenario-name queries work
- Vietnamese accent-insensitive search works
- punctuation-normalized pronunciation queries work
- audio and favorites still use the active variant's existing IDs/providers
- standalone runtime identity remains correct for both Viet and Tagalog when search is enabled
- browse/results/no-results/clear-to-browse Home state is correct in both variants

## Current rollout state

- Local/shared validation is green:
  - `npm run validate:family`
  - `npx --no-install tsc --noEmit`
  - `npx expo config --type public --json`
  - `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx expo config --type public --json`
  - `npx expo export --platform ios --output-dir .expo-export-viet-check`
  - `$env:EXPO_PUBLIC_APP_VARIANT='tagalog'; npx expo export --platform ios --output-dir .expo-export-tagalog-check`
- The remaining blockers are the device proof gates on both variants:
  - verify or install the current Viet preview target before smoke if needed
  - capture runtime/manual search smoke in both Viet and Tagalog
  - capture the fuller device walkthrough evidence for both variants before freezing the baseline
- Search smoke still must prove:
  - typing a query shows results on Home
  - unmatched query shows the empty state
  - clear returns to browse
  - audio plays from a search result
  - save/unsave works from a search result
  - saved state survives restart
  - search still works offline
- Search-enabled internal preview builds now exist for that smoke step:
  - Viet: `fd48c1f8-3105-4228-9b6d-98a66e9c8299`
  - Tagalog: `d1cfa295-fdad-43ed-b23b-dacb9d914c0d`
  - build root used: `E:\AI\SpeakLocal-EAS-Build`

## After Viet + Tagalog search is proven

- freeze Viet + Tagalog + shared search as the new family baseline only after the smoke and fuller walkthrough evidence are both captured
- keep future languages prep-only until they satisfy the updated baseline contract
- graduate new runtime languages one at a time in this order unless reprioritized later:
  1. Spanish
  2. Italian
  3. Japanese
  4. Turkish
