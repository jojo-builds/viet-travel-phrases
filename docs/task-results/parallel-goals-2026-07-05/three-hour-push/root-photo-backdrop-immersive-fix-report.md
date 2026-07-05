# Root Photo-Backdrop Immersive Fix Report

Run timestamp: 2026-07-05 22:07 Asia/Manila local
Branch: `main`

## Root Cause

The root Browse, Saved, Practice, and Search pages now render through `AdminPhotoBackdropSurfaceView` and publish root photo-backdrop immersive contexts, but `AppShellPhotoBackdropImmersivePolicy` still only accepted immersive hidden-chrome requests for Home and detail/phrase routes.

That made the visual regression easy to miss in broad flows: the pages could look populated, but the bottom admin/tab chrome stayed visible over root photo-backdrop pages when those roots requested immersive chrome. The broad pre-fix sweep caught this as four failures in `AdminChromeUITests` for Browse, Saved, Practice, and Search root photo-backdrop hidden/restored content.

## Fix

- `AppShellPhotoBackdropImmersivePolicy` now accepts root backdrop contexts for `.browse`, `.saved`, `.practice`, and `.search` only when the context page ID exactly matches the matching `AdminRootPhotoBackdropSurface`.
- `.browseCollection` remains excluded so normal category/collection pages do not unexpectedly hide app chrome.
- Added a unit regression that proves root contexts are accepted and Browse collection routes are still rejected.

## Focused Validation

XcodeBuildMCP focused validation passed:

- `AppChromeTests/testAdminRootBackdropImmersivePolicyAcceptsRootSurfaceContexts`
- `AdminChromeUITests/testHomePhotoBackdropHidesAndRestoresContent`
- `AdminChromeUITests/testBrowseRootPhotoBackdropHidesAndRestoresContent`
- `AdminChromeUITests/testSavedRootPhotoBackdropHidesAndRestoresContent`
- `AdminChromeUITests/testPracticeRootPhotoBackdropHidesAndRestoresContent`
- `AdminChromeUITests/testSearchRootPhotoBackdropHidesAndRestoresContent`

Result: `6` passed, `0` failed.

Receipt:

- Build log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/logs/test_sim_2026-07-05T14-06-14-662Z_pid2504_faf8f8d4.log`
- Result bundle: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T14-06-14-662Z_pid2504_c37990df.xcresult`

## Guard Validation

- `git diff --check` passed
- `node scripts/guard-native-only.js` passed
- `node native-ios/scripts/guard-native-chrome.js` passed

