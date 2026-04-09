# Viet Travel Phrases — Build Log

---
## ⚠️ ASSET CAPTURE RULE (permanent)
When Jojo sends screenshots, images, or files in Discord:
1. Ask Jojo to also upload them to GitHub repo (`jojo-builds/viet-travel-phrases`) under `assets/screenshots/` OR to the project Google Drive
2. OR Jay must immediately save them via the Discord attachment URL to `projects/viet-travel-phrases/app/assets/screenshots/` and commit
3. NEVER rely on chat-only delivery for project assets — they will be lost on session reset

Day 8 status: Jojo confirmed screenshots and app icon were done in a prior session.
Screenshots current location: UNKNOWN — not in workspace. Jojo to re-share or confirm GitHub location.
---

**App:** Vietnamese Travel Phrasebook (iOS)  
**GitHub:** https://github.com/jojo-builds/viet-travel-phrases  
**Tracker:** https://docs.google.com/spreadsheets/d/1xn37ov4nd5HlSETDFuDHXFeqVmrYNT4uOmSBu5xNKP4  
**Discord:** #viet-phrases-app (id: 1488661654047686676)  
**Started:** 2026-04-01 (Pre-build setup)  
**Target launch:** 2026-04-24 (Day 17)

---

## Plan

- **V1 scope:** 10 scenarios, ~60 phrases, native audio, save favorites, offline, App Store ready
- **Stack:** Expo SDK latest, TypeScript, Expo Router, NativeWind, expo-av, AsyncStorage
- **Build method:** EAS Build (cloud) — runs from VPS, no Mac needed
- **Preview method:** Expo Go tunnel mode (`npx expo start --tunnel`) — works from Da Nang to VPS over internet
- **Orchestrator:** Jay (this workspace)
- **Build agent:** Claude Code via ACP sessions

---

## Working day schedule (skipping weekends)

| Day | Date | Focus |
|-----|------|-------|
| Pre | Apr 1 | Setup (Apple Dev account, Expo Go, accounts) |
| 1 | Apr 2 | Environment + Scaffold + Expo running on iPhone |
| 2 | Apr 3 | Content: all 10 scenarios + phrases |
| 3 | Apr 4 | Audio generation + playback |
| 4 | Apr 7 | Favorites + offline + settings |
| 5 | Apr 8 | Polish + field test |
| 6 | Apr 9 | Second review + Quick Phrases + haptics |
| 7 | Apr 10 | Animations + edge cases |
| 8 | Apr 11 | App icon + screenshots + App Store copy |
| 9 | Apr 14 | Legal + landing page + EAS build |
| 10 | Apr 15 | Test marathon |
| 11 | Apr 16 | Friends alpha |
| 12 | Apr 17 | App Store submission |
| 13 | Apr 18 | Handle rejection + analytics |
| 14 | Apr 21 | Ops setup + await approval |
| 15 | Apr 22 | V1.5 planning |
| 16 | Apr 23 | Monetization planning |
| 17 | Apr 24 | LAUNCH |
| 18 | Apr 25 | First user data |
| 19 | Apr 28 | Data-driven iteration |
| 20 | Apr 29 | Retrospective |

---

## VPS Adaptations (vs Mac plan)

| Mac plan says | VPS reality |
|---------------|-------------|
| Same WiFi for Expo Go | Tunnel mode: `npx expo start --tunnel` |
| Xcode + iOS Simulator | EAS cloud builds only |
| Mac terminal | Windows PowerShell on VPS |
| Run `claude` in terminal | Claude Code via ACP sessions (sessions_spawn) |

---

## Phase 0 Completed (2026-03-31)

- [x] Google Calendar: 21 events created (Pre-build through Day 20)
- [x] Google Sheet tracker: 77 rows, all tasks with status
- [x] GitHub repo created: https://github.com/jojo-builds/viet-travel-phrases
- [x] Discord channel created: #viet-phrases-app
- [x] EAS CLI installed: eas-cli/18.4.0
- [x] Claude Code: confirmed installed (v2.1.78)
- [x] BUILD_LOG.md created
- [ ] PENDING (Jojo): Apple Developer Account applied/confirmed
- [ ] PENDING (Jojo): Expo Go installed on iPhone
- [ ] PENDING (Jojo): Expo account created at expo.dev
- [ ] PENDING (Jojo): OpenAI API key saved

---

## Daily Build Notes

### 2026-03-31 — Phase 0
- Phase 0 infrastructure complete
- Waiting on Jojo to confirm Apple Developer Account before Day 1 can start
- Build will proceed April 2 (Day 1) assuming account is active

### 2026-04-01 — Day 1 + Day 2 complete
- Expo app scaffold created in `app/` with Expo Router route structure, TypeScript strict mode, NativeWind config files, and the locked color system.
- Built shared UI primitives: `ThemedText`, `ScenarioCard`, `PhraseCard`, `AudioPlayButton`, and `SaveButton`.
- Wired full content model with all 10 scenarios from `content-draft/scenarios-draft.json`, preserved Vietnamese diacritics, and added 5 quick phrases derived from the main dataset.
- Added AsyncStorage favorites persistence plus saved-phrases screen refresh behavior.
- Added scenario detail route, home scenario navigation, and minimal settings screen with privacy link.
- Audio registry is scaffolded for bundled MP3s and fails safely when files are not present yet.
- Issue encountered: Expo/NativeWind Metro startup currently throws `ERR_UNSUPPORTED_ESM_URL_SCHEME` on this Windows Node 22 VPS when loading `metro.config.js`. TypeScript passes, but Expo start needs a follow-up compatibility fix or Node/runtime workaround before phone preview.
- Ready for Day 3: add bundled MP3 files to `assets/audio/`, populate `assets/audio/registry.ts`, and finish true playback verification once the Metro/runtime issue is resolved.

### 2026-04-01 — Day 3 audio infrastructure in place, generation blocked by invalid key
- Added `scripts/generate-audio.ts` to read the phrase dataset and generate bundled MP3s with OpenAI TTS (`gpt-4o-mini-tts`, voice `nova`) into `assets/audio/`.
- Added `scripts/generate-audio-registry.ts` to build a static `assets/audio/registry.ts` file for React Native explicit requires.
- Rebuilt `components/AudioPlayButton.tsx` with `expo-av`, light haptics, singleton playback control, graceful missing-file fallback, and pulse/stop playback state.
- Updated `components/PhraseCard.tsx` to use the real audio button and `app/_layout.tsx` to enable silent-mode iOS playback with inactive background audio.
- Installed required script deps: `openai`, `dotenv`, and `tsx`. `expo-av` was already present in the app.
- Verification: `npx tsc --noEmit` passes.
- TTS generation attempt failed immediately with OpenAI 401 `invalid_api_key` using the only `OPENAI_API_KEY` available in environment (`OPENAI_API_KEY` matched `OPENROUTER_API_KEY`).
- Current artifact counts: `0/70` audio files generated, registry entry count `0`, AudioPlayButton code complete but not fully verified with real MP3 assets yet.
- Note: the live phrase dataset currently contains **70** phrases, not 60.

---

## Design System (locked, do not change)

```
Primary:    #FF6B35 (warm orange)
Background: #FAFAF8 (warm off-white)
Surface:    #FFFFFF
Text:       #1A1A2E
Secondary:  #6B7280
Success:    #10B981
Border:     #E5E7EB
```

**Typography:**
- Vietnamese: 24px bold #1A1A2E
- Romanized: 18px medium #FF6B35
- English: 14px regular #6B7280

**Components:**
- Card radius: rounded-2xl (16px)
- Button radius: rounded-xl (12px)
- Card shadow: shadow-sm
- Card gap: 12px
- Screen padding: 20px horizontal

---

## Open Questions

- Apple Developer Account: Jojo to confirm status
- App name: decide before Day 8 (max 30 chars)
- OpenAI API key: Jojo must provide before Day 3

DAYS 4-5 COMPLETE: Favorites/Settings/animations/edge cases done, committed to GitHub

### 2026-04-01 — Code review fixes (Jay)
- Fixed PhraseCard spacing: `space-y-2` → `space-y-3` per design system
- Fixed Quick Phrases: Vietnamese text was using `romanized` variant, now uses `vietnamese` variant with English subtitle
- Updated Quick Phrases header: "Essential Phrases" + "Tap to hear" per plan spec
- Fixed app.json: added `bundleIdentifier: com.jojobuilds.viettravelphrases`, `buildNumber: 1`, splash `backgroundColor: #FAFAF8`, portrait lock, iOS status bar config
- Replaced text-character tab icons with proper Ionicons (home/home-outline, heart/heart-outline) per plan
- Installed `@expo/vector-icons` (Expo default package)
- Verified Metro starts successfully — `ERR_UNSUPPORTED_ESM_URL_SCHEME` bug is FIXED (GPT's path normalization fix in metro.config.js worked)
- TypeScript passes clean (`npx tsc --noEmit` — no errors)
- NativeWind v4.2.3 config verified correct: metro.config.js, tailwind.config.js, babel.config.js, global.css, nativewind-env.d.ts all aligned
- Remaining blockers: audio files (need OpenAI API key), Expo/EAS login, Apple Developer Account

### 2026-04-09 - TestFlight handoff advanced
- Confirmed finished EAS iOS builds:
  - Internal preview build `6467e106-a6d6-4973-9de7-b8e381f0aec6`
  - Store build `0db6c21a-703a-433b-a10f-626ef4fc9507`
- Created the App Store Connect app record for bundle ID `com.jojobuilds.viettravelphrases`
  - Apple app ID: `6761904350`
- Updated `app/eas.json` so the submit profile now includes `ascAppId: 6761904350`
- Ran interactive `eas submit` for store build `0db6c21a-703a-433b-a10f-626ef4fc9507`
- Upload succeeded and Apple is now processing build `1.0.0 (2)` for TestFlight
- Immediate next Apple-side step:
  - wait for processing to finish in TestFlight
  - confirm internal tester access
  - install on iPhone and run the phone validation checklist
- Follow-up status:
  - App Privacy has been published in App Store Connect
  - Privacy Policy URL is set to the live public policy
  - the TestFlight build is installed on iPhone
  - Formspree endpoint verification from the VPS returned `{"next":"/thanks","ok":true}`
  - App Store screenshots were converted to App Store-safe formats and uploaded successfully
  - App version `1.0.0 (2)` has been submitted to Apple App Review
  - Current review status: `Waiting for Review`
