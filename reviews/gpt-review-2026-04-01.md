# Vietnamese Travel Phrasebook Scaffold Review — 2026-04-01

## Section 1: Critical Issues (must fix before Day 3)

1. **File:** `app/assets/audio/registry.ts`
   **Line/area:** whole file
   **What's wrong:** The registry is empty, so every phrase audio lookup fails. V1 requires bundled offline audio with a static registry pattern. Right now the UI can render a play button, but there is no valid source behind it.
   **Exact fix:** Add explicit static `require()` entries for every bundled MP3 once the audio assets exist, for example:
   ```ts
   export const audioRegistry: Record<string, number> = {
     'coffee-1': require('./coffee-1.mp3'),
   };
   ```
   **Status:** **Not fixable from code alone in this review** because the MP3 assets are not present in the scaffold.

2. **File:** `app/tailwind.config.js`
   **Line/area:** root config
   **What's wrong:** The NativeWind preset was missing. Without it, NativeWind/Tailwind integration is incomplete and does not match the required setup.
   **Exact fix:** Added `presets: [require('nativewind/preset')]`.
   **Status:** Fixed.

3. **File:** `app/metro.config.js`
   **Line/area:** root config
   **What's wrong:** The Metro config passed `./global.css` directly into `withNativeWind`. On Windows + Node 22, NativeWind resolves the input path internally, and raw Windows paths are a plausible trigger for the reported `ERR_UNSUPPORTED_ESM_URL_SCHEME` path handling failure. The config also did not normalize slashes.
   **Exact fix:** Switched to an absolute, slash-normalized CSS path before passing it to `withNativeWind`.
   **Status:** Fixed.

4. **File:** `app/components/AudioPlayButton.tsx`
   **Line/area:** `handlePress`
   **What's wrong:** Audio creation/playback had no `try/catch`. Any failure in `createAsync` or `playAsync` would leave the component in a bad state and could strand the loading indicator.
   **Exact fix:** Wrapped playback flow in `try/catch/finally`, added explicit failure state, and ensured `loading` always resets.
   **Status:** Fixed.

5. **File:** `app/lib/favorites.ts`, `app/components/SaveButton.tsx`
   **Line/area:** AsyncStorage read/write and save toggle flow
   **What's wrong:** Favorites persistence had no storage failure handling. A corrupted payload or AsyncStorage write failure could silently break save/unsave behavior.
   **Exact fix:** Added guarded AsyncStorage parsing/writes in `favorites.ts`, returned operation success metadata, and surfaced failure feedback from `SaveButton`.
   **Status:** Fixed.

6. **File:** `app/package.json`
   **Line/area:** dependency versions
   **What's wrong:** The app is using `nativewind@^4.2.3`, while the review contract explicitly asks whether the setup follows **NativeWind v3** docs exactly. As-is, the answer is no.
   **Exact fix:** Pin NativeWind to the intended major version and align the related setup/docs, then reinstall dependencies. I did not rewrite package versions here because doing so without a clean install/lockfile update would leave the repo half-migrated.
   **Status:** **Unresolved blocker** for exact spec compliance.

## Section 2: Design System Violations

1. **Component:** `app/(tabs)/index.tsx` quick phrase chips
   **What's wrong:** Quick phrase text uses `variant="romanized"` for Vietnamese text and then overrides it with `text-sm`. That violates the locked type scale and color mapping.
   **Correct NativeWind class:** Vietnamese copy should use `text-vietnamese text-2xl font-bold` if shown as the main phrase, or a clearly documented smaller secondary treatment if the product spec intentionally allows compact chips.

2. **Component:** `components/PhraseCard.tsx`
   **What's wrong:** The text stack uses `space-y-2`, not the locked card spacing of `space-y-3`.
   **Correct NativeWind class:** `space-y-3`

3. **Component:** `components/SaveButton.tsx`
   **What's wrong:** The control is a rounded square button (`rounded-xl`) instead of the spec's heart-outline/filled-heart treatment described as the save button state. Shape may be acceptable, but the visual implementation is still too literal/basic for the locked design language.
   **Correct NativeWind class:** Keep `rounded-xl`, but refine the icon/state styling so the unsaved state reads as orange heart outline and saved state as orange filled heart.

4. **Component:** `app/(tabs)/_layout.tsx`
   **What's wrong:** Tab icon uses inline `style` instead of staying fully in the NativeWind styling lane. Not a `StyleSheet.create` violation, but still inconsistent with the project's stated styling discipline.
   **Correct NativeWind class:** Prefer `className="text-base"` and keep only the dynamic color where unavoidable.

5. **Component:** `app/_layout.tsx`
   **What's wrong:** `contentStyle` is set inline on the stack instead of using a class-driven screen wrapper pattern. Again, not forbidden by the written rules, but inconsistent with the “NativeWind only” intent.
   **Correct NativeWind class:** Prefer screen wrappers with `bg-background` rather than relying on inline stack content styling.

## Section 3: Architecture Issues

1. **File:** `app/content/scenarios.ts`
   **Issue:** The contract says phrase content lives in `content/scenarios.ts`, but the scaffold split scenario content across `content/scenarioData/*.ts`. This is not inherently bad, but it does diverge from the exact contract.
   **Fix:** Either consolidate back into `content/scenarios.ts` or update the operating contract if the split is now intentional.

2. **File:** `app/assets/audio/registry.ts`
   **Issue:** Required registry pattern exists, but it is non-functional because it contains no explicit `require()` mappings.
   **Fix:** Add real static entries once the MP3 files are committed.

3. **File:** `app/package.json`
   **Issue:** NativeWind major version does not match the spec under review.
   **Fix:** Align dependency major version with the intended NativeWind docs and reinstall.

4. **File:** `app/app/(tabs)/saved.tsx`
   **Issue:** `useFocusEffect(refresh)` works only because `refresh` is memoized, but the safer Expo Router pattern is `useFocusEffect(useCallback(() => { void refresh(); }, [refresh]))` so the callback shape is explicit and future cleanup behavior is less ambiguous.
   **Fix:** Wrap the focus callback explicitly.

## Section 4: Metro Bug Fix

### Diagnosis
The reported failure was `ERR_UNSUPPORTED_ESM_URL_SCHEME` on Node 22 / Windows / Metro / NativeWind. The most suspicious point in this scaffold was `metro.config.js`, where `withNativeWind` received `input: './global.css'` directly.

NativeWind resolves the CSS input internally with `path.resolve(...)`. On Windows that becomes a path like `C:\Users\...\global.css`. In Node 22, several ESM-path flows are stricter, and Windows absolute paths can misbehave when they are consumed by code expecting URL-safe or slash-normalized input.

The existing file was already CommonJS, so this did **not** look like a `module.exports` vs ESM syntax problem. The more likely fault line was Windows path normalization for the NativeWind CSS input.

### Exact file change made
**Before:**
```js
const { getDefaultConfig } = require('expo/metro-config');
const { withNativeWind } = require('nativewind/metro');

const config = getDefaultConfig(__dirname);

module.exports = withNativeWind(config, { input: './global.css' });
```

**After:**
```js
const path = require('path');
const { getDefaultConfig } = require('expo/metro-config');
const { withNativeWind } = require('nativewind/metro');

const config = getDefaultConfig(__dirname);
const input = path.resolve(__dirname, 'global.css').replace(/\\/g, '/');

module.exports = withNativeWind(config, { input });
```

### Why this fix makes sense
- It keeps Metro in CommonJS, which Expo expects here.
- It preserves the same NativeWind integration point.
- It removes relative-path ambiguity.
- It avoids passing raw backslash-heavy Windows paths downstream.
- It directly targets the Windows/Node 22 failure mode the scaffold agent described.

I cannot runtime-verify Expo on this VPS, but this is a sound config hardening change and the most plausible direct fix in the file under review.

## Section 5: Scorecard

- **NativeWind config correctness:** 2/5
- **Design system compliance:** 3/5
- **TypeScript quality:** 4/5
- **Component architecture:** 3/5
- **Content/data integrity:** 4/5
- **Scope compliance:** 5/5

**Overall score:** 3.5/5

**Recommendation:** **HOLD** before Day 3.

### Why hold
This scaffold is directionally good, but not production-ready for a real iPhone test cycle yet because:
- the audio registry is effectively unimplemented,
- NativeWind is not aligned exactly to the requested v3 setup,
- the Metro bug needed a direct config correction,
- and there are still design-system inconsistencies in the home screen and some component details.

## Section 6: Changes Made

1. **`app/metro.config.js`**
   - Normalized the NativeWind CSS input path for Windows/Node 22.
   - Preserved CommonJS export style.

2. **`app/tailwind.config.js`**
   - Added the NativeWind preset.

3. **`app/components/AudioPlayButton.tsx`**
   - Added playback error handling.
   - Ensured loading state always clears.
   - Added explicit visual fallback for loading/failure.

4. **`app/lib/favorites.ts`**
   - Added guarded AsyncStorage read/write handling.
   - Returned success metadata from toggle operations.

5. **`app/components/SaveButton.tsx`**
   - Integrated the safer favorites API.
   - Added user feedback when persistence fails.

## Bottom line
The scaffold is a decent Day 1-2 base, but it is **not ship-ready** yet. The biggest remaining blocker is real offline audio wiring via a populated static registry and committed MP3 assets.
