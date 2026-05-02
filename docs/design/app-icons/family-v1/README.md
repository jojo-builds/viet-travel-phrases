# SpeakLocal App Icon Family v2 Concepts

Status: high-fidelity image concept packet for `TASK-ICON-FAMILY-DESIGN-001`
Last updated: 2026-05-02

## Local Review

Open directly:

```text
file:///Users/jojolim/Developer/products/speaklocal/app-family/docs/design/app-icons/family-v1/index.html
```

## Recommendation

Use **Direction 5: Melo Hybrid** as the lead v2 icon candidate for SpeakLocal Vietnam.

It is the strongest balance between recognizability and premium iOS fit. The mark reads as a chameleon tail, speech bubble, route loop, and audio cue at once, so it carries the SpeakLocal mascot idea without turning the app into a full mascot badge. It also scales best into a family system because the base silhouette can stay stable while each country swaps only color and motif layers.

Keep **Direction 1: Brand Travel Mark** as the conservative fallback if the team decides the launch icon should avoid any mascot cue. Do not use the full **Direction 6: Mascot Forward** icon as the default launch recommendation yet; it is memorable, but it risks making SpeakLocal feel more character-first than phrasebook-first.

## Accepted Jojo Steering

- Old v1 speech-bubble icons are not the design target.
- This is a v2 exploration focused on premium iOS fit and stronger recognizability on crowded Home Screens.
- Melo may be used, but only if it makes the icon stronger.
- Mascot-forward is allowed to compete, but not assumed.
- The family system needs a base SpeakLocal mark that can flow into Vietnam, Philippines, Italy, Germany, Japan, and future country apps.

## Research Fold-In

- Apple app icon guidance favors simple, memorable, platform-native icons that do not rely on tiny text or screenshots.
- App Store metadata and screenshots should reflect the real product; the icon should not promise a mascot-first app if the shipped product is phrase-first.
- Product Page Optimization can later test icon variants, but this packet should choose a strong design direction first.
- Current iPhone customization and tinted icon modes increase the need for a strong silhouette and readable contrast.
- Mascot R&D recommends not making Melo the app icon centerpiece at launch. This packet adjusts that recommendation: use an abstract Melo-derived mark as a brand cue, not a full mascot takeover.

Primary sources reviewed:

- [Apple HIG App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons/)
- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Product Page Optimization](https://developer-mdn.apple.com/help/app-store-connect/create-product-page-optimization-tests/configure-test-treatments)
- [Apple iPhone icon customization support](https://support.apple.com/en-ie/guide/iphone/iph385473442/ios)
- [Google Translate App Store](https://apps.apple.com/us/app/google-translate/id414706506)
- [Duolingo App Store](https://apps.apple.com/us/app/duolingo-language-chess/id570060128)
- [Pimsleur App Store](https://apps.apple.com/us/app/pimsleur-language-learning/id1405735469)
- [Drops App Store](https://apps.apple.com/us/app/drops-language-learning-games/id939540371)

## Assets

| Artifact | Path | Purpose |
| --- | --- | --- |
| Vietnam directions contact sheet | `assets/vietnam-directions-contact-sheet.png` | Six rendered Vietnam icon directions. |
| Expanded family system | `assets/family-system-expanded-sheet.png` | Base SpeakLocal plus Vietnam, Philippines, Italy, Germany, and Japan. |
| Family system first pass | `assets/family-system-sheet.png` | Earlier four-country family proof. |
| Home Screen mock | `assets/home-screen-mock.png` | Strongest candidates in crowded iPhone context. |
| App Store header mock | `assets/app-store-header-mock.png` | Lead candidate beside SpeakLocal Vietnam positioning. |
| Small-size sheet | `assets/small-size-legibility-sheet.png` | 1024, 180, 120, 60, 40, and 29 px checks. |
| Normalized 1024 icons | `assets/icons/*.png` | Individual candidate exports for review. |
| Source generated images | `assets/source-generated/*.png` | Original generated outputs copied from Codex image generation. |

## Vietnam Icon Directions

| Direction | Verdict | Notes |
| --- | --- | --- |
| 1. Brand Travel Mark | Strong fallback | Premium and simple, but the speech bubble still risks feeling like a chat/translator app. |
| 2. Country Motif | Beautiful but risky | Feels premium and Vietnam-specific, but can become a tourism seal and may be harder to distinguish at tiny sizes. |
| 3. Audio Phrase Utility | Clear utility | Communicates audio/practice well, but feels closer to a feature icon than a memorable app brand. |
| 4. Landmark Memory | Useful alternate | Travel-specific and recognizable for Vietnam, but less scalable across all countries. |
| 5. Melo Hybrid | Recommended | Most ownable: one mark can mean mascot, speech, route, and audio without a full character takeover. |
| 6. Mascot Forward | Test only | Memorable, but too close to mascot-first positioning for the current premium phrasebook strategy. |

## Family System Rule

Use a **stable base mark** and a **swappable country layer**:

- Stable base: abstract Melo route-loop/speech/audio silhouette, gold route dots, premium glass/enamel depth.
- Country layer: palette, one restrained local motif, and one local material cue.
- Do not use flag stickers, costumes, country caricature, or busy landmarks.
- Keep the base mark recognizable even if the country motif is removed.

Current expanded family directions:

| App | Country layer |
| --- | --- |
| SpeakLocal base | Ivory/jade neutral brand layer. |
| SpeakLocal Vietnam | Red, jade, lotus/ceramic/lantern hints. |
| SpeakLocal Philippines | Ocean blue, sun gold, island/wave cue. |
| SpeakLocal Italy | Deep green, ivory, terracotta, arch/cypress cue. |
| SpeakLocal Germany | Graphite/cream, restrained red/gold, rail/old-town/forest cue. |
| SpeakLocal Japan | Indigo/ivory, red sun dot, wave/sakura cue. |

## What To Test Before Finalizing

- Compare Direction 5 against Direction 1 on a real iPhone Home Screen with light, dark, and tinted icon appearances.
- Reduce Detail pass: simplify tiny route dots and eye detail to confirm the mark still reads at 29 px.
- App Store Product Page Optimization: test Direction 5 against a no-mascot fallback once final App Store assets exist.
- Ask five target travelers what the icon suggests before showing the app name. Desired answers: travel, speaking, phrases, language, guide, or helpful companion.

## Avoid For Future Country Icons

- Flags as the main icon design.
- Full mascot costume variants.
- Literal text, letters, or country abbreviations.
- Overloaded landmarks that do not survive tiny sizes.
- Translation arrows or generic chatbot symbols as the core mark.
- Childish game energy, coins, XP, streaks, or badge-collection styling.

## Tools And Context

- Rendered with Codex built-in image generation.
- Review sheets assembled locally with bundled Python/Pillow.
- Public research pages listed above were used.
- No private repo screenshots, app code, or product data were sent to third-party tools.
