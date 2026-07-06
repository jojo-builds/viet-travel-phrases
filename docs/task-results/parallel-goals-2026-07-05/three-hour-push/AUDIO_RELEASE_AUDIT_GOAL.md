# Audio Release Audit Goal

## Objective

Run an offline release audit of SpeakLocal Vietnam audio/content readiness on current `main`, focusing on what could still embarrass us in the App Store build: missing audio, orphaned audio, broken manifest references, suspicious durations, placeholder text, and visible speaker affordances without playable bundled audio.

## Success Criteria

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family` on current `main`.
- Confirm the exact commit audited at the top of the report.
- Run the existing audio/content validators before inventing new checks:
  - `node native-ios/scripts/sync-viet-audio.js`
  - `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `node native-ios/scripts/validate-tier-one-listing-pages.js`
  - `node native-ios/scripts/validate-vietnamese-menu-copy.js`
- Inspect generated/resource data for:
  - missing audio references;
  - placeholders/TODO/TBD/coming-soon visible copy;
  - orphaned audio files not referenced by the manifest where the repo has a reasonable way to detect them;
  - suspiciously tiny or zero-duration audio files where standard macOS tools can inspect duration;
  - known high-risk examples from Jojo's review, especially `Không cay` / not spicy.
- Write `docs/task-results/parallel-goals-2026-07-05/three-hour-push/audio-release-audit-report.md` with:
  - command receipts;
  - blocker/non-blocker classification;
  - exact follow-up list if anything remains;
  - recommendation for whether audio is a launch blocker.

## Constraints

- Do not call ElevenLabs or any paid generation service.
- Do not edit app code or generated resources unless the fix is a tiny, obviously safe report-only correction; prefer reporting.
- Do not claim pronunciation quality is perfect from static checks alone.
- Keep paywall isolated and out of scope.
