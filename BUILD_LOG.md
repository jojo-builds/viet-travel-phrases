# Viet Travel Phrases — Build Log

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
