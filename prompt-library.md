# Prompt Library — Vietnamese Travel Phrasebook

Use these prompts exactly for Claude Code ACP sessions. Assume `CLAUDE.md` has already been read. All paths below are Windows VPS paths and should use forward slashes.

---

## Day 1 — Environment, scaffold, Expo Router, NativeWind, first phone preview

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 1 only.

Goal:
Set up the Expo app foundation for the Vietnamese Travel Phrasebook so the repo can run in Expo Go tunnel mode from a Windows VPS.

Do this:
1. Initialize or finish initializing the Expo app in the current repo.
2. Configure TypeScript strict mode.
3. Install and configure Expo Router.
4. Install and configure NativeWind v3.
5. Create the required file structure from `CLAUDE.md`.
6. Add minimal placeholder screens for:
   - `app/_layout.tsx`
   - `app/(tabs)/_layout.tsx`
   - `app/(tabs)/index.tsx`
   - `app/(tabs)/saved.tsx`
   - `app/scenario/[id].tsx`
   - `app/settings.tsx`
7. In `app/_layout.tsx`, set `Audio.setAudioModeAsync({ playsInSilentModeIOS: true })`.
8. Make the initial UI use the locked colors and NativeWind classes only.
9. Add any required Expo Router entry config and Babel/Tailwind config.
10. Verify the repo is ready for `npx expo start --tunnel`.

Success criteria:
- Expo Router is wired correctly.
- NativeWind is working.
- TypeScript strict is enabled.
- The required route files exist.
- `app/_layout.tsx` sets iOS silent-mode audio behavior.
- No file exceeds 150 lines.
- No `StyleSheet.create()`.
- No `any`.

Most likely error:
Expo Router or NativeWind config mismatch causing startup failure.
Handle it by fixing config files directly in this repo for Windows-compatible Expo usage. Do not leave partial config or say “should work.”

Deliverable:
Make the code changes only for Day 1 and summarize exactly which files were created or changed.
```

---

## Day 2 — Data model and full scenario content

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 2 only.

Goal:
Create the typed content layer for the app with exactly 10 scenarios and enough phrase data to power the V1 app.

Do this:
1. Create or complete `content/types.ts` with strict TypeScript interfaces for scenarios and phrases.
2. Create or complete `content/scenarios.ts` as the single source of truth for app content.
3. Add exactly 10 scenario objects.
4. Add phrase entries for each scenario with stable IDs and these fields at minimum:
   - `id`
   - `scenarioId`
   - `vietnamese`
   - `romanized`
   - `english`
   - `audioKey`
5. Add a typed Quick Phrases selection of exactly 5 phrases derived from the main dataset, not duplicated data.
6. Ensure scenario IDs are slug-safe and stable.
7. Keep naming and wording appropriate for a travel phrasebook.

Success criteria:
- `content/types.ts` and `content/scenarios.ts` exist and are strict-typed.
- Exactly 10 scenarios exist.
- Quick Phrases contains exactly 5 items from the main dataset.
- Phrase IDs are stable and suitable for favorites.
- No duplicate content source for quick phrases.
- No file exceeds 150 lines; split logically if needed.
- No `any`.

Most likely error:
Putting too much data into one oversized file or duplicating Quick Phrases data.
Handle it by splitting content into small typed exports if needed, while keeping `content/scenarios.ts` as the main aggregator and source of truth.

Deliverable:
Make the Day 2 content changes and summarize the final scenario list and total phrase count.
```

---

## Day 3 — Audio registry and reusable audio play button

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 3 only.

Goal:
Create the static bundled-audio foundation and reusable playback UI for phrase cards.

Do this:
1. Create or complete `assets/audio/registry.ts`.
2. Build the registry using explicit static `require()` calls only.
3. Create or complete `components/AudioPlayButton.tsx`.
4. Use `expo-av` for playback.
5. Ensure the play button matches the locked design system: circular 48x48, orange background, white icon.
6. Add loading and error handling for playback.
7. Release audio resources correctly.
8. If audio files are not all present yet, keep a safe fallback state without pretending playback succeeded.

Success criteria:
- `assets/audio/registry.ts` exists.
- No dynamic `require()` anywhere.
- `AudioPlayButton.tsx` is reusable and typed.
- Playback errors are handled gracefully.
- No file exceeds 150 lines.
- No `any`.
- No recording or microphone code is introduced.

Most likely error:
Attempting `require()` with a dynamic path or leaking sound instances.
Handle it by switching to explicit registry entries and cleaning up sound objects in component lifecycle code.

Deliverable:
Implement only the Day 3 audio foundation and summarize how missing audio files are handled.
```

---

## Day 4 — Favorites persistence and save button

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 4 only.

Goal:
Implement local favorites persistence using AsyncStorage and a reusable save button.

Do this:
1. Install or wire `@react-native-async-storage/async-storage` if not already done.
2. Create any small helper needed for favorites storage, keeping files under 150 lines.
3. Create or complete `components/SaveButton.tsx`.
4. Support save, unsave, and read favorite phrase IDs.
5. Use stable phrase IDs from `content/scenarios.ts`.
6. Match the locked visual rule: orange heart outline when unsaved, orange filled heart when saved.
7. Include loading/error handling where appropriate.

Success criteria:
- Favorites persist across app restarts.
- SaveButton is reusable and typed.
- Only local AsyncStorage is used.
- No auth, cloud sync, account logic, or extra persistence is added.
- No file exceeds 150 lines.
- No `any`.

Most likely error:
Saving whole phrase objects instead of stable IDs, causing drift and duplication.
Handle it by storing only phrase IDs and resolving phrase data from the main content dataset.

Deliverable:
Implement Day 4 persistence only and summarize the storage shape used.
```

---

## Day 5 — Reusable text and card components

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 5 only.

Goal:
Build the shared UI components that enforce the locked design system across the app.

Do this:
1. Create or complete `components/ui/ThemedText.tsx` with variants for:
   - screen title
   - section header
   - body
   - caption
   - Vietnamese phrase
   - romanized text
   - English meaning
2. Create or complete `components/ScenarioCard.tsx`.
3. Create or complete `components/PhraseCard.tsx`.
4. Wire `PhraseCard.tsx` to display phrase content plus `AudioPlayButton` and `SaveButton`.
5. Use NativeWind classes only.
6. Add empty or fallback rendering states where appropriate.

Success criteria:
- Shared text styles are centralized in `ThemedText.tsx`.
- ScenarioCard and PhraseCard match the locked design system.
- PhraseCard is reusable for scenario and saved screens.
- No file exceeds 150 lines.
- No `StyleSheet.create()`.
- No `any`.

Most likely error:
Letting PhraseCard become too large or mixing too much state into presentational components.
Handle it by splitting tiny helper components if needed and keeping data/state logic out of purely visual text helpers.

Deliverable:
Implement Day 5 shared UI components only and summarize component responsibilities.
```

---

## Day 6 — Home screen with Quick Phrases and scenario grid

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 6 only.

Goal:
Build the real home screen in `app/(tabs)/index.tsx` using the shared content and components.

Do this:
1. Replace placeholders in `app/(tabs)/index.tsx`.
2. Render the app title / intro.
3. Render the Quick Phrases section using exactly 5 phrases from the main dataset.
4. Render the grid/list of all 10 scenarios using `ScenarioCard.tsx`.
5. Link scenario cards to `app/scenario/[id].tsx` using Expo Router.
6. Use the locked design system.
7. Add loading/empty/error-safe rendering as appropriate for local content.

Success criteria:
- Home screen shows title, Quick Phrases, and all 10 scenarios.
- Quick Phrases uses the shared main dataset, not duplicated hardcoded copies.
- Navigation to scenario detail is wired.
- No file exceeds 150 lines.
- No `any`.

Most likely error:
Hardcoding navigation or duplicating phrase data directly in the home screen.
Handle it by importing typed shared content and using Expo Router links only.

Deliverable:
Implement the Day 6 home screen only and summarize how Quick Phrases is sourced.
```

---

## Day 7 — Scenario detail screen

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 7 only.

Goal:
Build the scenario detail route in `app/scenario/[id].tsx`.

Do this:
1. Read the route param safely with Expo Router.
2. Resolve the scenario from the typed dataset.
3. Render the scenario title and its phrase list.
4. Use `PhraseCard.tsx` for each phrase.
5. Add proper empty and error states for:
   - invalid scenario ID
   - missing scenario
   - scenario with no phrases
6. Keep the screen inside the design and scope rules.

Success criteria:
- Visiting a valid scenario ID shows the correct phrase list.
- Invalid or missing IDs render a clear fallback state.
- Phrase audio and save actions are available through PhraseCard.
- No file exceeds 150 lines.
- No `any`.

Most likely error:
Assuming the route param is always valid and crashing on undefined content.
Handle it by validating the param and rendering a safe fallback screen instead of throwing.

Deliverable:
Implement Day 7 scenario routing only and summarize the invalid-ID behavior.
```

---

## Day 8 — Saved screen wired to AsyncStorage

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 8 only.

Goal:
Build the saved/favorites screen in `app/(tabs)/saved.tsx`.

Do this:
1. Read favorite phrase IDs from AsyncStorage.
2. Resolve them against the main phrase dataset.
3. Render saved phrases using `PhraseCard.tsx`.
4. Support unsaving from this screen.
5. Add a strong empty state when no phrases are saved.
6. Add loading and error states.
7. Ensure offline behavior works because all content and audio are bundled locally.

Success criteria:
- Saved screen shows persisted favorites.
- Unsave works from the saved screen.
- Empty, loading, and error states are implemented.
- Phrase audio still works through the shared card UI.
- No file exceeds 150 lines.
- No `any`.

Most likely error:
The saved screen not refreshing after a save/unsave change.
Handle it by using a simple refresh strategy tied to screen focus or local state updates, without adding heavy state management.

Deliverable:
Implement Day 8 saved-screen behavior only and summarize how refresh is handled.
```

---

## Day 9 — Settings screen and privacy policy link

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 9 only.

Goal:
Build the minimal V1 settings screen in `app/settings.tsx`.

Do this:
1. Create or complete `app/settings.tsx`.
2. Include a simple app information section.
3. Include a privacy policy link using the appropriate React Native / Expo linking approach.
4. Keep the screen minimal and inside scope.
5. Do not add analytics, notifications, accounts, or advanced settings.
6. Add safe handling for link open failure.

Success criteria:
- Settings screen exists and is reachable.
- Privacy policy link is present.
- Failure to open the link is handled gracefully.
- No extra settings surfaces are added.
- No file exceeds 150 lines.
- No `any`.

Most likely error:
Turning settings into a catch-all page with out-of-scope options.
Handle it by keeping only app info and privacy policy functionality.

Deliverable:
Implement Day 9 settings only and summarize exactly what appears on the screen.
```

---

## Day 10 — Navigation polish, empty states, and consistency pass

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 10 only.

Goal:
Do a focused UX consistency pass across all current screens without adding new features.

Do this:
1. Review these files and tighten consistency:
   - `app/_layout.tsx`
   - `app/(tabs)/_layout.tsx`
   - `app/(tabs)/index.tsx`
   - `app/(tabs)/saved.tsx`
   - `app/scenario/[id].tsx`
   - `app/settings.tsx`
   - relevant components under `components/`
2. Ensure titles, spacing, colors, and fallback states all match the locked design system.
3. Ensure tab/navigation labels are clean and minimal.
4. Fix any missing loading, error, or empty state.
5. Remove dead code and unnecessary placeholders.
6. Do not add new V1 scope items.

Success criteria:
- All current screens feel visually consistent.
- Every screen has appropriate fallback handling.
- No scope creep was introduced.
- No file exceeds 150 lines.
- No `StyleSheet.create()`.
- No `any`.

Most likely error:
Accidentally adding “nice-to-have” features during polish.
Handle it by limiting Day 10 to consistency, cleanup, and existing-scope quality only.

Deliverable:
Make Day 10 cleanup changes only and summarize the consistency fixes made.
```

---

## Day 11 — Offline confidence pass and missing-audio resilience

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 11 only.

Goal:
Harden the app for offline-first behavior and failure-safe local asset handling.

Do this:
1. Review the audio path from `content/scenarios.ts` through `assets/audio/registry.ts` to `components/AudioPlayButton.tsx`.
2. Verify local content rendering does not depend on network access.
3. Improve user-facing handling for missing audio registry entries or playback failures.
4. Ensure saved phrases still resolve correctly from local content.
5. Add or tighten small helper guards where needed.
6. Do not add online sync, remote fetches, or analytics.

Success criteria:
- Core app content is local and offline-safe.
- Missing audio fails gracefully.
- Saved phrases resolve locally from shared data.
- No new dependencies are added unless strictly necessary.
- No file exceeds 150 lines.
- No `any`.

Most likely error:
Assuming every audio key exists and crashing when one does not.
Handle it by checking registry presence before playback and showing a safe disabled or error state.

Deliverable:
Implement Day 11 resilience improvements only and summarize the offline guarantees now in place.
```

---

## Day 12 — Final V1 code audit for handoff to build/release phase

```text
You are working in `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`.

Read `CLAUDE.md` and then complete Day 12 only.

Goal:
Run a final code audit and fix pass on the V1 app before moving to build/release operations.

Do this:
1. Audit the repo against `CLAUDE.md`.
2. Check especially for:
   - out-of-scope features
   - design-system drift
   - `StyleSheet.create()` usage
   - `any` usage
   - files over 150 lines
   - dynamic `require()` usage
   - broken route/file alignment for Expo Router
3. Fix any violations you find.
4. Keep fixes narrow and concrete.
5. Do not start release, App Store, icon, screenshot, or legal tasks yet.

Success criteria:
- The codebase matches the locked V1 scope.
- No forbidden patterns remain.
- The repo is ready for the next non-coding phase.
- A concise audit summary is produced listing what was checked and what was fixed.

Most likely error:
Turning the audit into a new feature pass.
Handle it by fixing only violations, regressions, and inconsistencies already inside the existing app.

Deliverable:
Make Day 12 audit fixes only and return a concise checklist of findings and fixes.
```

---

## Notes for the operator
- Days 13–20 are intentionally omitted here because they are ops / launch phase, not coding-phase prompts.
- If Claude Code finishes a day early, do not automatically pull in the next day unless explicitly instructed.
- If the repo state differs from the plan, Claude should preserve `CLAUDE.md` rules and adapt narrowly rather than re-architecting.
