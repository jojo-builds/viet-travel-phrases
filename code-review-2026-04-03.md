# Code Review — Vietnamese Travel Phrasebook — 2026-04-03

## Summary

Full pre-submission review of all source files under `app/`, `components/`, `content/`, `lib/`, and `assets/audio/`. Reviewed against CLAUDE.md locked V1 scope, design system, and quality rules.

**Files reviewed:** 22 source files
**Issues found:** 4 critical, 3 warning, 5 minor
**Fixes applied:** All critical and warning issues fixed in-place

---

## Critical Issues (FIXED)

### C1 — `openai` package in dependencies
- **File:** `package.json:24`
- **Rule violated:** CLAUDE.md §12 — "Do not add AI packages"
- **What:** The `openai` npm package (`^6.33.0`) was listed in production dependencies. This is an AI SDK explicitly forbidden by the scope lock.
- **Fix applied:** Removed `openai` from dependencies.

### C2 — `dotenv` package in dependencies
- **File:** `package.json:13`
- **Rule violated:** CLAUDE.md §12 — Only add packages clearly required for locked scope
- **What:** `dotenv` (`^17.3.1`) is unnecessary for a fully offline bundled app. It suggests runtime env-var usage which is out of scope.
- **Fix applied:** Removed `dotenv` from dependencies.

### C3 — `tsx` in production dependencies instead of devDependencies
- **File:** `package.json:32`
- **Rule violated:** CLAUDE.md §12 — Package discipline
- **What:** `tsx` is a TypeScript execution tool for scripts, not a runtime dependency. Being in `dependencies` means it ships in the production bundle metadata.
- **Fix applied:** Moved `tsx` to `devDependencies`.

### C4 — Dead code path for removed expo-av API
- **File:** `components/AudioPlayButton.tsx:12-14, 69-72`
- **Rule violated:** CLAUDE.md §11 — "Remove dead code immediately"
- **What:** `AudioModule` type and `createSoundObjectAsync` fallback code referenced an API removed from expo-av years ago. This code path could never execute and added unnecessary type gymnastics.
- **Fix applied:** Removed `AudioModule` type and simplified to direct `Audio.Sound.createAsync()` call.

---

## Warning Issues (FIXED)

### W1 — FeedbackModal.tsx uses heavy inline `style={{}}` objects
- **File:** `components/FeedbackModal.tsx:75-86, 91-97, 100-104`
- **Rule violated:** CLAUDE.md §5.1 — "NativeWind only"
- **What:** TextInput, Pressable, and ThemedText used inline style objects with hardcoded colors, padding, border radius, and font sizes instead of NativeWind classes. While technically not `StyleSheet.create()`, it violates the spirit of the NativeWind-only rule.
- **Fix applied:** Converted all inline styles to NativeWind `className` props. Only `textAlignVertical: 'top'` remains as inline (no NativeWind equivalent on React Native).

### W2 — FeedbackModal inline styles used hardcoded color values
- **File:** `components/FeedbackModal.tsx:77-78, 81, 85, 92, 101`
- **Rule violated:** CLAUDE.md §3 — Locked design system colors
- **What:** Colors like `#E5E7EB`, `#1A1A2E`, `#FAFAF8`, `#FF6B35`, `#9CA3AF` were hardcoded in inline styles instead of using the design system's Tailwind tokens (`border-border`, `text-text-primary`, `bg-background`, `bg-primary`, `text-caption`).
- **Fix applied:** All colors now use NativeWind design system tokens.

### W3 — Conditional styling in FeedbackModal used ternary in style objects
- **File:** `components/FeedbackModal.tsx:92, 101`
- **What:** Button background and text color used ternary expressions inside style objects. Converted to conditional `className` strings which is the NativeWind pattern.
- **Fix applied:** Replaced with conditional `className` using template literals.

---

## Minor Issues (recommendations only — not fixed)

### M1 — `index` prop unused in PhraseCard and ScenarioCard
- **Files:** `components/PhraseCard.tsx:12,15`, `components/ScenarioCard.tsx:6,8`
- **What:** Both components accept an `index` prop but never use it in rendering. Likely intended for future stagger animations.
- **Recommendation:** Remove the `index` prop if stagger animations aren't planned for V1. Keep if they are.

### M2 — `visited` feature in HomeScreen not in V1 scope list
- **File:** `app/(tabs)/index.tsx:12-23`
- **What:** The home screen tracks which scenarios have been visited via AsyncStorage and shows a green dot indicator on ScenarioCard. This is not explicitly listed in V1 scope but is a very minor visual indicator, not gamification/progress tracking.
- **Recommendation:** Acceptable to keep as a subtle UX cue. Not a scope violation per se, but note it for scope awareness.

### M3 — Tabs layout uses inline style objects for tab bar
- **File:** `app/(tabs)/_layout.tsx:12-16`
- **What:** `tabBarLabelStyle` and `tabBarStyle` use inline style objects. This is unavoidable — Expo Router's `Tabs` component doesn't support `className` for these configuration options.
- **Recommendation:** No action needed. This is a framework limitation.

### M4 — AudioPlayButton inline styles for dynamic size
- **File:** `components/AudioPlayButton.tsx:108,110`
- **What:** `style={{ height: size, width: size }}` and `style={{ fontSize: iconSize }}` use inline styles for dynamic prop-based sizing. NativeWind doesn't support dynamic values from props in className.
- **Recommendation:** Acceptable. Dynamic inline styles are the correct pattern when values come from props.

### M5 — `jimp` in devDependencies
- **File:** `package.json` devDependencies
- **What:** `jimp` is an image processing library. Likely used for asset generation scripts. Acceptable in devDependencies but worth confirming it's still needed.
- **Recommendation:** Verify if `jimp` is used by any scripts. Remove if unused.

---

## Checks Passed

| Check | Status |
|-------|--------|
| No `StyleSheet.create()` usage | PASS |
| No `any` types | PASS |
| No dynamic `require()` | PASS |
| All files under 150 lines | PASS |
| Exactly 10 scenarios | PASS |
| Audio registry covers all 70 phrases | PASS |
| TypeScript strict mode enabled | PASS |
| Quick phrases are subset of main data | PASS |
| Favorites use AsyncStorage only | PASS |
| All screens have error/empty states | PASS |
| No Mac-only tooling assumptions | PASS |
| Design system colors match CLAUDE.md | PASS |
| Expo Router file-based routing | PASS |
| No accounts/cloud sync/push notifications | PASS |
| playsInSilentModeIOS set in root layout | PASS |
| Audio resources released on finish/error | PASS |

---

## File Line Counts

| File | Lines | Status |
|------|-------|--------|
| app/_layout.tsx | 23 | OK |
| app/(tabs)/_layout.tsx | 40 | OK |
| app/(tabs)/index.tsx | 73 | OK |
| app/(tabs)/saved.tsx | 48 | OK |
| app/scenario/[id].tsx | 98 | OK |
| app/settings.tsx | 66 | OK |
| app/privacy.tsx | 71 | OK |
| app/terms.tsx | 76 | OK |
| components/AudioPlayButton.tsx | ~118 | OK |
| components/FeedbackModal.tsx | ~93 | OK |
| components/PhraseCard.tsx | 38 | OK |
| components/SaveButton.tsx | 55 | OK |
| components/ScenarioCard.tsx | 30 | OK |
| components/ui/ThemedText.tsx | 27 | OK |
| content/types.ts | 19 | OK |
| content/scenarios.ts | 41 | OK |
| lib/favorites.ts | 65 | OK |
| assets/audio/registry.ts | 75 | OK |

All files under the 150-line limit.

---

## Conclusion

The codebase is in good shape for submission. The critical fixes were:
1. Removing forbidden AI/unnecessary packages (`openai`, `dotenv`)
2. Moving dev tooling (`tsx`) to devDependencies
3. Removing dead code in AudioPlayButton
4. Converting FeedbackModal to use NativeWind classes consistently

No architectural issues, no scope violations beyond the minor observations noted, and all quality rules are met after fixes.
