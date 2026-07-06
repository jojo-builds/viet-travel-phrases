# App Store Screenshot Capture Report

Commit under test: `4f6462906579e1130a78b8ce6976b0eee3ed9024`

Branch: `main`

Capture date: 2026-07-05 Asia/Manila local time

## Build, Install, And Launch

- Native project: `native-ios/SpeakLocalNative.xcodeproj`
- Scheme: `SpeakLocalNative`
- Bundle: `app.speaklocal.vietnam.native`
- Simulator/profile used: `SpeakLocal App Store Screenshots`, `iPhone 17 Pro Max`, iOS 26.5
- Capture size: `1320x2868` PNGs from the Pro Max simulator
- Build/install/launch result: passed via XcodeBuildMCP `build_run_sim` with simulator signing disabled.
- Paywall status: not included. This run used current `main`; no paywall screen was opened or captured.
- App-code edit status: no app code was intentionally edited for this screenshot run.

Note: a disk-full error occurred during the third capture. I cleared disposable XcodeBuildMCP DerivedData for this repo workspace after the app was already installed, then continued the same simulator capture pass.

## Screenshot Inventory

Screenshots are saved under:

`docs/task-results/parallel-goals-2026-07-05/three-hour-push/app-store-screenshot-proof/`

| File | State | Notes |
| --- | --- | --- |
| `01-home-first-screen.png` | Home first screen | Home hero, Essentials shelf, first-day shelf, and bottom chrome visible. |
| `02-browse-root.png` | Browse root | Browse category grid with airport, hotel, eating out, getting around, and bottom chrome visible. |
| `03-eating-out-food-menu-page.png` | Food/drink menu-style page | Eating Out collection with top admin chrome, section chips, and order-drinks phrase rows visible. |
| `04-city-danang-browse-by.png` | City section UI | Da Nang city collection scrolled to section chips and Landmarks rows with save/audio affordances visible. |
| `05-search-results-food-allergies.png` | Search results | Traveler query `food allergies` showing Browse matches, filter chips, and menu/category results. |
| `06-saved-danang.png` | Saved | Saved page with Da Nang saved city row and saved-practice prompt visible. |
| `07-practice-essentials-round-sheet.png` | Practice round sheet | Essentials match round sheet with progress, phrase cards, answers, audio buttons, hint, and close controls visible. |
| `contact-sheet.png` | Review helper | Contact sheet generated from the seven capture PNGs for quick visual QA. |

## Immediately Useful For App Store Planning

- The proof pack gives current-main raw simulator screenshots for the main app surfaces: Home, Browse, city/place browsing, Search, Saved, and Practice.
- The screenshots are high-resolution Pro Max portrait captures suitable for internal App Store screenshot composition planning and copy/layout selection.
- The set shows the non-paywall app experience and can be used to decide which surfaces deserve polished App Store marketing frames or final device captures.

## Still Requires Jojo / App Store Connect / Manual Approval

- App Store Connect upload, screenshot slot assignment, preview metadata, and final submission remain manual/Apple-side work.
- Final marketing choices still need Jojo approval: which screens to use, whether to crop/status-bar-normalize, and what overlay captions or device frames to add.
- These are simulator captures, not a completed App Store submission and not a replacement for any required physical-device or TestFlight proof.

## Visual Blockers For Marketing Screenshots

No screenshot-blocking visual defect was found in the captured non-paywall states.

Planning caveats:

- `06-saved-danang.png` truthfully shows only one saved item and a `Save 4 more` prompt; use it if the planning story wants saved-trip setup, not a full saved practice inventory.
- `04-city-danang-browse-by.png` is intentionally scrolled to prove section/Browse-by behavior; use a separate hero-position city capture if the App Store story needs the city headline instead.
- Raw simulator captures include live simulator status chrome and should be normalized or framed before final App Store creative use.
