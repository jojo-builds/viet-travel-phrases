# Photo Backdrop Listing Pages

This note captures the repeatable page treatment used for city place listing pages and city/country hub collection pages.

## Eligible Pages

An authored phrase/listing page is a good candidate when it has:

- a real `heroImageName` asset that can survive a full-screen portrait crop
- a non-compact phrase hero
- bundled audio for the page headline phrase
- phrase sections that stay readable when placed on the light content sheet
- a photo that still reads when the sheet starts around the upper quarter of the screen

The current city-wide rule enables the treatment for non-compact `viet-family-city-*` and `viet-phrase-city-*` pages whose hero asset starts with `HeroCity`. This maps to the 500 current city place listing pages and deliberately excludes the compact generated action pages that use `HeroCompactPhraseMasthead`.

Vietnamese menu item detail pages also use the treatment when the page ID starts with `viet-menu-` and the hero asset starts with `BackdropMenu`. Menu collection rows and section cards keep the square `HeroMenu*` thumbnail system; only item detail pages switch to the portrait backdrop asset.

Phrase/category listing pages use the treatment when the hero asset starts with `HeroCategory` or `BackdropPhrase`. The `BackdropPhrase*` assets are semantic mini-pool photos for phrase pages that need a more specific traveler backdrop than a broad category masthead. These images should keep their primary subject in the upper-middle safe zone, roughly `18%` to `48%` down from the top of the frame, so the photo reads while the content sheet is pulled down and users do not need immersive mode just to understand the image.

Hub and category collection pages use the same interaction when the `BrowseCollectionDescriptor` has `cityHub` content or a `HeroCategory*` masthead. That includes the city guide hubs, the All Vietnam hub, and phrase category pages such as Airport, Hotel, Eating Out, Getting Around, Shopping, Emergency, and Local Greetings.

## Implementation Steps

1. Find the authored page ID or collection route.
2. Confirm the page has a production hero image in `native-ios/Resources/Assets.xcassets`.
3. For city place listing pages, confirm `PhrasePhotoBackdropLayout.supportsCityListingPage(pageID:heroImageName:)` covers the page.
4. For Vietnamese menu item detail pages, confirm `VietnameseMenuItem.menuBackdropImageName` resolves to a production `BackdropMenu*` portrait asset while `menuImageName` remains the `HeroMenu*` thumbnail.
5. For phrase mini-pool pages, confirm `content-draft/viet/phrase-backdrops-v1.json` maps the page to a production `BackdropPhrase*` portrait asset and keeps the audit `HeroCategory*` recommendation as `fallbackAssetName`.
6. For city/country hubs, confirm the descriptor has `cityHub` content and a crop-safe `mastheadImageName`.
7. Keep `supportsHeroImageLightbox` false for photo-backdrop listing pages so the old expand-button/lightbox path does not stack on top of the new interaction.
8. Let the fixed background image fill the whole screen with `.scaledToFill()` and `.ignoresSafeArea()`.
9. Start the content sheet at the `photoBackdropInitialID` position so the page opens with the sheet around the top quarter of the viewport.
10. Preserve the collapsed image position with `metrics.collapsedContentTop`, leaving a visible sheet handle/edge so users can always pull the content back.
11. Allow a tap anywhere on the currently visible image area to toggle immersive mode; users should not need to pull the sheet all the way down first.
12. Restore chrome when the user taps the image again or scrolls/swipes the content upward.
13. Keep the tab/search chrome on a soft content-colored backing in normal mode, avoid opaque rectangular tab-bar bands, and hide the backing in immersive mode.
14. Apply `.statusBarHidden(...)` and `.persistentSystemOverlays(...)` while immersive so native overlays disappear wherever iOS allows it. The physical Dynamic Island/camera cutout remains outside app control.
15. Keep `PhrasePhotoBackdropLayout.bottomReadingClearance` large enough that the final section/card can scroll above the bottom chrome.

## Runtime Wiring

The page behavior lives in `PhraseArticleTemplateView`:

- `usesPhotoBackdropLayout` calls `PhrasePhotoBackdropLayout.supportsListingPage(pageID:heroImageName:)`, which combines the city, menu, category, and phrase mini-pool predicates instead of using a page-ID allowlist.
- `photoBackdropBody` owns the fixed image, scroll sheet, tap-to-immersive behavior, and initial scroll target.
- `photoBackdropContentSheet` renders the normal page header, playback dock, and article sections on the light sheet.
- `PhrasePhotoBackdropLayout.metrics(for:)` controls the starting position, collapsed photo position, visible-image tap region, and scroll-to-restore threshold.
- `PhrasePhotoBackdropLayout.quantizedBackdropOffset(for:)` keeps the bottom backing from invalidating the full page on every pixel of scroll.
- `photoBackdropBottomChromeBackdrop(geometry:metrics:)` paints the content-colored surface behind the system tab/search chrome and clamps it below the rounded sheet edge so the photo does not look cut off in the pulled-down state.

The hub/category behavior lives in `BrowseCollectionPageView`:

- `usesPhotoBackdropLayout` is true when `descriptor.cityHub != nil` or the descriptor masthead starts with `HeroCategory`.
- The sheet reuses `BrowseCollectionHeaderCopy` so the title, subtitle, and morph targets stay consistent with the standard header.
- Background images use the descriptor `mastheadImageName`.

The shell behavior lives in `AppShellView`:

- `PhrasePhotoBackdropImmersiveChromePreferenceKey` hides top/bottom chrome while the photo is immersive.
- The root shell also applies `.statusBarHidden(true)` and `.persistentSystemOverlays(.hidden)` while immersive so status/home-style overlays do not remain on top of the photo.
- `PhrasePhotoBackdropTabBarBackgroundPreferenceKey` asks the shell to keep the tab bar transparent while the page supplies a soft content-colored backing during normal photo-backdrop reading.
- Photo-backdrop preferences are gated by each page's active route so inactive navigation-stack pages do not leak tab bar state.
- `AppShellTabBarAppearanceBridge` applies the native `UITabBarAppearance` background without committing signing or project-setting changes.

## QA Checklist

For each representative page group, test these states on the feature simulator:

- Initial load: content starts high enough to read the headline and the photo still feels present.
- Collapsed photo: scrolling down reveals the full image while leaving enough sheet edge to recover the content.
- Immersive tap: tapping the visible photo area from any sheet position hides page chrome; tapping again or scrolling restores it.
- Bottom content: the final text/card clears the system tab/search chrome.
- Phrase sections: every row/card keeps Vietnamese, English, speaker button, and navigation affordance readable on the moving sheet.
- Bottom chrome: no raw photo shines through behind the tab/search area unless immersive mode is active.

## Current Coverage

- 500 non-compact city place listing pages in the current Viet authored listing resource.
- 355 Vietnamese menu item detail pages, using generated `BackdropMenu*` portrait JPEGs at `720x1556`; the production manifest and review packet live under `docs/editorial-exports/viet-image-assets/menu-backdrop-production-355/`.
- 952 Viet phrase/category listing pages from the 2026-05-29 backdrop audit, using semantic `BackdropPhrase*` mini-pool portrait JPEGs at `720x1556`; the production manifest and layout-guide contact sheet live under `docs/editorial-exports/viet-image-assets/phrase-backdrop-mini-pools-2026-05-30/`.
- City hub collection pages with `BrowseCollectionRoute.city(...)`.
- The All Vietnam hub collection page at `BrowseCollectionRoute.category("city-guides")`.
- Phrase category collection pages with `HeroCategory*` mastheads, stored as lightweight `720x1556` JPEGs in `native-ios/Resources/Assets.xcassets`.
