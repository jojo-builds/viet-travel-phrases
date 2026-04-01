# CLAUDE.md — Vietnamese Travel Phrasebook Build Operating Guide

## 1) Mission
Build **only** the V1 iOS app for **Vietnamese Travel Phrasebook** in this repo:
- Repo: `C:/Users/Administrator/.openclaw/workspace/projects/viet-travel-phrases`
- GitHub: <https://github.com/jojo-builds/viet-travel-phrases>
- Build environment: **Windows VPS**, not Mac
- Preview method: **Expo Go tunnel mode** via `npx expo start --tunnel`
- Runtime target: iPhone via Expo Go during development, EAS cloud build for release

Your job is to make steady progress inside the locked V1 scope. Do not invent features, do not redesign the app, and do not ask open-ended product questions unless there is a true blocker.

---

## 2) Non-Negotiable Scope Lock
### Included in V1
- 10 scenario screens with phrase cards
- Audio playback using **pre-generated bundled MP3 files**
- Save / unsave phrases to favorites using **AsyncStorage**
- Favorites screen with offline audio
- Quick Phrases section on home screen with **5 essential phrases**
- Settings screen with privacy policy link
- Fully offline content and audio once app is installed

### Explicitly Out of Scope
If a request would add any of the following, **do not build it**. Note it as out of scope and continue on the approved task.
- Voice recording
- AI transcription
- Runtime AI API calls
- Subscriptions or paid tiers
- User accounts or login
- Gamification, streaks, progress tracking
- Cloud sync
- Push notifications
- More than 10 scenarios
- Any analytics SDK unless explicitly added in a later non-V1 phase
- Any design-system changes unless explicitly approved

Rule: **When in doubt, choose the simpler V1 interpretation.**

---

## 3) Locked Design System
Do not change these values.

### Colors
- Primary: `#FF6B35`
- Primary Dark: `#E55A2B`
- Background: `#FAFAF8`
- Surface: `#FFFFFF`
- Text Primary: `#1A1A2E`
- Text Secondary: `#6B7280`
- Vietnamese text: `#1A1A2E`
- Romanized: `#FF6B35`
- English: `#6B7280`
- Success: `#10B981`
- Border: `#E5E7EB`

### Typography
- Vietnamese phrase: `24px`, bold, `#1A1A2E`
- Romanized guide: `18px`, medium, `#FF6B35`
- English meaning: `14px`, regular, `#6B7280`
- Screen title: `28px`, bold, `#1A1A2E`
- Section header: `18px`, semibold, `#1A1A2E`
- Body: `16px`, regular, `#374151`
- Caption: `12px`, regular, `#9CA3AF`

### Component Rules
- Card radius: `rounded-2xl`
- Button radius: `rounded-xl`
- Card shadow: `shadow-sm` only
- Card spacing: `space-y-3`
- Screen horizontal padding: `px-5`
- Play button: circular `48x48`, orange background, white icon
- Save button: orange heart outline when unsaved, orange filled heart when saved

---

## 4) Required File Structure
Keep the app aligned to this structure:

```text
app/
  (tabs)/
    _layout.tsx
    index.tsx
    saved.tsx
  scenario/
    [id].tsx
  settings.tsx
  _layout.tsx
components/
  PhraseCard.tsx
  ScenarioCard.tsx
  AudioPlayButton.tsx
  SaveButton.tsx
  ui/
    ThemedText.tsx
content/
  scenarios.ts
  types.ts
assets/
  audio/
    registry.ts
    *.mp3
```

You may add **small helper files** only if they are clearly justified and keep files under the line limit. Do not create architecture sprawl.

---

## 5) Technical Constraints You Must Obey
1. **NativeWind only.** Never use `StyleSheet.create()`.
2. **No dynamic `require()`.** Use `assets/audio/registry.ts` with explicit static `require()` entries.
3. In `app/_layout.tsx`, always set:
   - `Audio.setAudioModeAsync({ playsInSilentModeIOS: true })`
4. **TypeScript strict.** No `any`.
5. **Max 150 lines per file.** Split files before crossing that limit.
6. Every screen/component must handle appropriate **loading, error, and empty** states.
7. Use **forward slashes** in scripts and paths because work happens on a Windows VPS.
8. Use **Expo Router file-based routing**. Do not add manual navigation config.
9. Use bundled local data. Do not fetch phrases or audio at runtime.
10. Keep the app stable in offline mode.
11. Prefer predictable, boring code over clever abstractions.

---

## 6) Platform Reality: Windows VPS + Expo
This project is developed from a **Windows VPS**, so act accordingly.

### Use
- PowerShell-compatible commands
- `npx expo start --tunnel` for phone testing
- EAS cloud builds for iOS release

### Do Not Assume
- No Xcode
- No iOS Simulator
- No Mac-only instructions
- No localhost-only LAN preview assumptions

If a step depends on Mac tooling, replace it with the Windows VPS + Expo/EAS equivalent.

---

## 7) Content Model Rules
The app is a phrasebook, not a learning platform.

### Data Rules
- Store all phrases in `content/scenarios.ts`
- Store interfaces/types in `content/types.ts`
- Every phrase entry must include enough data to render:
  - stable `id`
  - scenario id
  - Vietnamese text
  - romanized pronunciation guide
  - English meaning
  - audio key / filename reference
- Scenario IDs must be slug-safe and stable
- Favorites must key off stable phrase IDs
- Quick Phrases must be a subset of the main phrase dataset, not a duplicated second source of truth

### Scenario Count
Exactly **10** scenarios in V1. Not 9. Not 11.

---

## 8) Audio Rules
Audio is bundled, offline, and pre-generated.

### Mandatory Rules
- Every playable phrase must map to a static entry in `assets/audio/registry.ts`
- No dynamic path assembly for `require()`
- Audio playback must fail gracefully if a file is missing
- Release audio resources correctly
- Do not build recording, microphone permissions, waveform UI, or transcription flows

### If Audio Files Are Not Present Yet
You may wire the registry structure and playback code around expected filenames, but do not fake successful playback. Surface a safe fallback state.

---

## 9) Persistence Rules
Use AsyncStorage only for local favorites.

### Allowed
- Save favorite phrase IDs
- Read favorite phrase IDs
- Remove favorite phrase IDs

### Not Allowed
- Accounts
- Cloud sync
- Remote profiles
- Hidden persistence for out-of-scope features

Implementation rule: favorites must survive app restarts and work offline.

---

## 10) UX Expectations
The app should feel calm, fast, and simple.

### Home Screen
Must include:
- app title / intro
- Quick Phrases section with 5 essentials
- scenario grid linking to all 10 scenario screens

### Scenario Screen
Must include:
- scenario title
- list of phrase cards
- audio playback per phrase
- favorite toggle per phrase
- empty/error fallback if content is unavailable

### Saved Screen
Must include:
- list of saved phrases
- ability to play audio offline
- empty state when nothing is saved

### Settings Screen
Must include:
- privacy policy link
- simple app information area
- no extra product surfaces

---

## 11) Code Quality Rules
- Keep components small and literal
- Prefer composition over giant files
- Use descriptive names
- Remove dead code immediately
- Keep comments short and useful
- Do not leave TODO clutter unless it marks a real blocker
- If a file approaches 150 lines, split it before finishing the task
- Do not introduce a state library for this app
- Do not introduce unnecessary hooks, contexts, or services

### Recommended Simplicity
For this app, a good solution is usually:
- typed local content
- a small storage helper if needed
- focused presentational components
- light screen logic

---

## 12) Package Discipline
Only add packages that are clearly required for the locked scope.

Expected core packages include:
- Expo / React Native baseline
- Expo Router
- NativeWind v3
- `expo-av`
- `@react-native-async-storage/async-storage`

Do not add large UI kits, state managers, analytics SDKs, auth SDKs, or AI packages.

---

## 13) Session Behavior
Assume each work session starts with limited memory.

At the start of work:
1. Read this file first.
2. Inspect existing repo files before changing architecture.
3. Continue from the current codebase rather than rebuilding completed work.
4. Keep changes narrowly aligned to the current task.

At the end of each task chunk:
- verify the changed files are consistent
- check for scope creep
- make sure no file exceeds 150 lines
- confirm no `StyleSheet.create()` or `any` slipped in

---

## 14) Definition of Done
A task is done only if all of these are true:
- The requested files exist and are wired correctly
- The implementation stays inside V1 scope
- The design system is preserved
- TypeScript remains strict with no `any`
- No file exceeds 150 lines
- No dynamic `require()` was introduced
- The feature has reasonable loading / empty / error handling
- The code is appropriate for Windows VPS + Expo tunnel workflow

---

## 15) Decision Rules for Ambiguity
When something is unclear, use this priority order:
1. Preserve locked V1 scope
2. Preserve locked design system
3. Preserve technical constraints
4. Choose simplest implementation
5. Avoid adding new dependencies

If two options both work, choose the one with:
- fewer files
- less state
- less abstraction
- lower risk of breakage in Expo Go / EAS

---

## 16) Forbidden Mistakes Checklist
Before finishing any session, make sure you did **not**:
- add out-of-scope features
- change colors, typography, spacing, or component shapes
- use `StyleSheet.create()`
- use `any`
- use dynamic `require()`
- exceed 150 lines in any file
- assume Mac tooling
- create duplicate phrase sources
- create more than 10 scenarios
- add runtime network dependencies for core app behavior

---

## 17) Working Principle
This is a small, premium-feeling offline phrasebook. Build it like a disciplined V1, not like a platform.
