# Day 9 Overnight Results

## Task 1 — App Icon
Status: done
Details: Resized app-icon-variant-1.png from ~1000x1000 to exactly 1024x1024 using sharp-cli. Saved to app/assets/images/icon.png and app/assets/images/adaptive-icon.png. Updated app.json: `icon` now points to `./assets/images/icon.png`, `android.adaptiveIcon.foregroundImage` points to `./assets/images/adaptive-icon.png`.

## Task 2 — Privacy/Terms URLs
Status: done
Changes: Updated app.json `extra.privacyPolicyUrl` from `https://jojo-builds.github.io/viet-travel-phrases/privacy.html` to `https://speaklocal.app/privacy`. Updated `extra.termsOfUseUrl` from `https://jojo-builds.github.io/viet-travel-phrases/terms.html` to `https://speaklocal.app/terms`. No other files contained old GitHub Pages URLs — settings.tsx uses in-app Expo Router navigation to `/privacy` and `/terms` screens (no external URLs).

## Task 3 — App Store Listing
Status: done
Encoding issues found: no
Changes: File was already clean with proper Unicode Vietnamese characters (Cà phê sữa đá, phở, etc.) and correct emoji rendering. No rewrite needed. Structure already matches required format: name (23 chars), subtitle (29 chars), promo text, description, keywords, category, rating.

## Task 4 — TypeScript
Status: clean
Errors fixed: none — `npx tsc --noEmit` passed with zero errors.

## Task 5 — EAS Build
Status: failed — credentials not configured
Build URL/ID: n/a
Message: `Failed to set up credentials. You're in non-interactive mode. EAS CLI couldn't find any credentials suitable for internal distribution. Run this command again in interactive mode.` Needs interactive `eas build` to set up iOS distribution credentials (Apple Developer account login + provisioning profile).

## Task 6 — Commit
Hash: 035cc7c

## Blockers for Jojo (needs human action)
- [ ] Run `npx eas build --platform ios --profile preview` interactively to set up iOS credentials (Apple Developer account 2FA required)
- [ ] Verify speaklocal.app/privacy and speaklocal.app/terms are live and serving correct content
- [ ] Review app icon (variant 1) at app/assets/images/icon.png before App Store submission
