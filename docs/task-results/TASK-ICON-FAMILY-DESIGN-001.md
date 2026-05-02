# TASK-ICON-FAMILY-DESIGN-001 Result

Status: done
Design packet commit: `b7e5f58f2f11c668a30304f8ae41578721660298`

## Review Page

- `docs/design/app-icons/family-v1/index.html`

Open directly:

```text
file:///Users/jojolim/Developer/products/speaklocal/app-family/docs/design/app-icons/family-v1/index.html
```

## Image Artifacts

- Vietnam directions: `docs/design/app-icons/family-v1/assets/vietnam-directions-contact-sheet.png`
- Expanded family system: `docs/design/app-icons/family-v1/assets/family-system-expanded-sheet.png`
- Family system first pass: `docs/design/app-icons/family-v1/assets/family-system-sheet.png`
- Home Screen mock: `docs/design/app-icons/family-v1/assets/home-screen-mock.png`
- App Store header mock: `docs/design/app-icons/family-v1/assets/app-store-header-mock.png`
- Small-size legibility sheet: `docs/design/app-icons/family-v1/assets/small-size-legibility-sheet.png`
- Individual 1024 px candidates: `docs/design/app-icons/family-v1/assets/icons/*.png`
- Prompt packet: `docs/design/app-icons/family-v1/prompt-packet.md`
- Peer review: `docs/design/app-icons/family-v1/peer-review.md`

## Tools Used

- Codex built-in image generation for rendered icon concepts.
- Local bundled Python/Pillow for normalization, contact sheets, Home Screen mock, App Store mock, and small-size sheet.
- Local Node path checker for gallery image references.
- `sips` for pixel-dimension validation.
- `git diff --check` for whitespace validation.

## Context Sent Outside Codex

No private repo screenshots, app code, native resources, or product data were sent to third-party tools.

Public research/reference pages used:

- Apple HIG App Icons
- Apple App Review Guidelines
- App Store Connect Product Page Optimization guidance
- Apple iPhone icon customization support
- Google Translate, Duolingo, Pimsleur, and Drops App Store pages

## Accepted Jojo Decisions

- Old v1 speech-bubble icons are not the target.
- This is a v2 exploration focused on premium iOS fit and stronger recognizability on crowded Home Screens.
- Melo may be used only if it makes the icon stronger.
- Mascot-forward is allowed to compete, but not assumed.
- The system should show how a base SpeakLocal mark can flow into Vietnam, Philippines, Italy, Germany, Japan, and future country apps.

## R&D Fold-In

The latest mascot R&D recommends keeping Melo restrained and avoiding a mascot-first launch icon by default. This packet folds that in by recommending an abstract Melo-derived brand mark rather than the full mascot.

- Recommended: `Direction 5: Melo Hybrid`.
- Conservative fallback: `Direction 1: Brand Travel Mark`.
- Test-only: `Direction 6: Mascot Forward Melo`.

## Recommended Icon Direction

Use `Direction 5: Melo Hybrid` as the lead v2 candidate.

Why:

- It is more ownable than a generic travel/audio mark.
- It reads as speech, route, audio, and Melo without becoming a full character badge.
- It scales into future country apps through a stable base silhouette plus swappable country layers.
- It stands out better than the older v1 icon vocabulary.

Family rule:

- Keep the base abstract Melo route-loop mark stable.
- Swap country palette, route dot, and one restrained local motif.
- Avoid flags, costumes, country caricature, text, and busy landmark seals.

## Peer Review Outcome

Status: PASS with follow-up simplification recommended before production export.

Notes:

- Direction 5 has the strongest recognizability and family scalability.
- Direction 6 is memorable but risks mascot-first positioning.
- Direction 3 is clear but more like a feature icon than a brand icon.
- Final production should simplify tiny route dots and eye detail before App Store submission.

## Validation

- Gallery path check: 11 image references, 0 missing.
- Icon dimensions: all six individual candidates are 1024 x 1024.
- Supporting sheets generated and dimension-checked.
- `git diff --check -- docs/design/app-icons/family-v1` passed before packet commit.
- Staged scope for packet commit was limited to `docs/design/app-icons/family-v1/**`.

## Recommended Next Task

Create `TASK-ICON-FAMILY-PRODUCTION-REFINE-001`:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/design/app-icons/family-v1/README.md and docs/task-results/TASK-ICON-FAMILY-DESIGN-001.md.
Refine Direction 5: Melo Hybrid into production-ready app icon exports. Simplify eye/route-dot detail, create light/dark/tinted icon checks, compare against Direction 1 as no-mascot fallback, and produce App Store-ready 1024 px candidate exports. Do not edit app code or replace native resources yet. Commit when done and write the task result.
```
