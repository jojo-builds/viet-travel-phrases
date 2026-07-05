# Visual Layout Worker Report

Timestamp: 2026-07-06 00:18 Asia/Manila local
Worker scope: deep visual layout sweep, read-only except for this report and screenshot proof
Current checkout: `main` at `87d50da00`
Current app-code context: includes `911864b12` (`Rename legacy conversation practice labels`) and `87d50da00` (`Add visible product language audit`)
Simulator: `SpeakLocal Post Fix Visual` (`iPhone 17 Pro`, iOS 26.5)
Build proof: XcodeBuildMCP build/install/launch succeeded for `app.speaklocal.vietnam.native` from `/tmp/speaklocal-visual-layout-derived-1783267600`
Paywall boundary: paywall was not launched, tested, edited, or merged; `feature/paywall` remains isolated.

## Method

- Re-read the current goal file and current operational/source evidence after Jojo's direction update.
- Verified local `HEAD` is `87d50da00`.
- Built and launched the non-paywall native app with XcodeBuildMCP using an isolated DerivedData path because the default build database was locked and the machine had very low free disk.
- Captured current simulator screenshots for Home, Browse root, Browse category, city page, food/drink detail pages, Search, Saved, Practice hub, and Practice match sheet.
- Re-checked current files after the screenshot pass; a parallel source update changed the Browse `Respectful hellos` card to `Respectful greetings`, so that label in `06-browse-root-mid-practice-moments.jpg` is explicitly stale.
- Ran the current visible-language audit:
  - `node native-ios/scripts/audit-visible-product-language.js`
  - Result: passed, no retired visible labels found.

## Screenshot Proof Set

All paths are under `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/visual-layout-screenshots/`.

- `01-home-top.jpg`
- `02-home-mid.jpg`
- `03-home-practice-rail.jpg`
- `04-home-lower-situations.jpg`
- `05-browse-root-top.jpg`
- `06-browse-root-mid-practice-moments.jpg` (stale only for the `Respectful hellos` label; current source now says `Respectful greetings`)
- `07-browse-root-menu-guides.jpg`
- `08-browse-category-food-top.jpg`
- `09-browse-category-food-rows.jpg`
- `10-city-hanoi-top.jpg`
- `11-city-hanoi-mid.jpg`
- `12-city-hanoi-lower-rows.jpg`
- `13-menu-pho-bo-top.jpg`
- `14-menu-pho-bo-mid.jpg`
- `15-drink-ca-phe-launch-attempt.jpg` (valid drink-detail proof despite the cautious filename)
- `16-search-coffee-results-top.jpg`
- `17-search-coffee-results-scrolled.jpg`
- `18-saved-top.jpg`
- `19-saved-rows.jpg`
- `20-practice-hub-top.jpg`
- `21-practice-hub-topic-rows.jpg`
- `22-practice-scenario-food-coffee.jpg`
- `23-practice-hub-start-fixed.jpg`

## Findings

### SAFE_FIX_NOW, RESOLVED IN WORKING TREE: Practice Saved action badge truncated `Start`

Evidence:
- Screenshot: `visual-layout-screenshots/20-practice-hub-top.jpg`
- Fixed proof: `visual-layout-screenshots/23-practice-hub-start-fixed.jpg`
- Source anchor: `native-ios/App/Views/PracticeView.swift:5329-5336`, `native-ios/App/Views/PracticeView.swift:5400-5425`

Pre-repair, the red trailing action badge on the `Practice Saved` card compressed `Start` into `St...`. The card was otherwise attractive and usable, but this was a visible clipped control label in the first Practice viewport.

Fix applied: `PracticeMatchSourceCard` now gives the action capsule a one-line fixed-size text layout, minimum width, and higher layout priority. Fresh current-build simulator proof shows `Start` fully readable.

### SAFE_FIX_NOW: Phở bò backdrop crop hides the dish in the first viewport

Evidence:
- Screenshot: `visual-layout-screenshots/13-menu-pho-bo-top.jpg`
- Asset/source anchor: `native-ios/Resources/Assets.xcassets/BackdropMenuFoodPhoBo.imageset/backdrop-menu-food-pho-bo-720q86.jpg`; `native-ios/App/Models/VietnameseMenuCatalog.swift:118-120`, `native-ios/App/Models/VietnameseMenuCatalog.swift:1259-1261`

The `Phở bò` page uses the intended `BackdropMenuFoodPhoBo` asset, and the full asset does contain the bowl. In the live top viewport, the crop shows mostly herbs and an iced drink, so the first impression reads like a drink/table scene rather than beef noodle soup.

Likely fix surface: adjust backdrop focal positioning/crop for this item or use a tighter hero asset where the bowl remains visible in the top-frame crop.

### ACCEPTED_TEMPORARY_RISK: Static chrome intentionally overlaps passing content during scroll

Evidence:
- Screenshots: `visual-layout-screenshots/11-city-hanoi-mid.jpg`, `visual-layout-screenshots/17-search-coffee-results-scrolled.jpg`, `visual-layout-screenshots/19-saved-rows.jpg`
- Test/source anchor: `native-ios/UITests/AdminChromeUITests.swift:233-263`, `native-ios/UITests/AdminChromeUITests.swift:265-289`, `native-ios/App/Views/AppShellView.swift:1502-1648`

The top and bottom chrome remain visually static while content scrolls underneath. In mid-scroll states, headings/rows can pass under the top fade or bottom search island. I did not find a row or control that became permanently unreachable in the sampled surfaces, and existing Admin Chrome UI tests cover More button placement, speed selector presence, support/legal More-panel links, and bottom chrome hit testing.

Keep this as an accepted visual tradeoff unless Jojo wants less content visible behind chrome.

## Non-Issue Notes

- Current Browse mid-page shows `Practice moments`; the retired `Quick conversations` section title is not present in the current screenshot or source.
- Screenshot `06-browse-root-mid-practice-moments.jpg` was captured before a parallel/current source update changed the Browse card from `Respectful hellos` to `Respectful greetings`; do not treat that screenshot label as current app-source truth unless the app is rebuilt from the latest files.
- Current Practice visible labels are Practice-oriented; retired `Messages`, `Messages thread`, `Back to Messages`, and `Restart conversation` labels are blocked by the visible-language audit.
- Home, Browse category food rows, Hanoi city rows, Search coffee results, Saved rows, and the Practice match sheet were generally readable with no hard clipping found.
- The More panel itself was not manually expanded in this worker screenshot pass because the XcodeBuildMCP runtime snapshot returned no tappable element refs for this app surface. Current source and UI-test evidence cover the panel content and placement; visible More buttons are present in the current screenshots.

## Recommendation

No `HARD_BLOCK` visual layout issue found in this sweep.

Fix before the next visual closeout:
- Phở bò first-viewport crop/focal framing.

No additional current copy-polish issue is being raised from the stale `Respectful hellos` screenshot because current source already moved that label to `Respectful greetings`.
