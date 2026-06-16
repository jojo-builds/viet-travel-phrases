# Handwritten Recovery Batch 049 - 2026-06-03

Status: PASS for authored copy import, native resource generation, validator guardrails, and Simulator render proof. Physical iPhone build passed, but install hung in `devicectl` and was terminated after the device install step did not complete.

Progress after this batch: 244 / 520 recovered. Remaining: 276.

## Scope

- `viet-family-city-hue-place-le-ba-dang-memory-space` - Không gian lưu niệm Lê Bá Đảng / Le Ba Dang Memory Space
- `viet-family-city-hue-place-le-loi-street` - Đường Lê Lợi / Le Loi Street
- `viet-family-city-hue-place-les-jardins` - Les Jardins de la Carambole / Les Jardins de la Carambole
- `viet-family-city-hue-place-lien-hoa-vegetarian` - Nhà hàng chay Liên Hoa / Lien Hoa Vegetarian Restaurant
- `viet-family-city-hue-place-long-an-palace` - Điện Long An / Long An Palace

## Authored Fixes

- Le Ba Dang Memory Space now names the Kim Sơn / Thủy Bằng site and explains the galleries, contemporary art, concrete/glass architecture, garden-like grounds, and Lê Bá Đảng focus without abstract art-appreciation instructions.
- Le Loi Street now reads as a central riverside street name useful for addresses, traffic routes, crossings, bridges, French-era buildings, and south-bank orientation, with softer claims around hotels and cafes.
- Les Jardins de la Carambole now avoids unstable menu-item specifics and presents the restaurant as a French-Vietnamese garden restaurant near the Citadel for a seated lunch or dinner after heritage walking.
- Lien Hoa now explains `chay` plainly for U.S.-based first-time visitors: Vietnamese vegetarian food shaped by Buddhist practice, with tofu, vegetables, mushrooms, herbs, and shared plates. It also adds a strict vegetarian/vegan check for fish sauce, egg, or dairy.
- Long An Palace now clarifies venue identity: the main historic hall tied to the Hue Royal Antiquities Museum, with royal objects inside a Nguyễn-era wooden building. The misleading Royal Antiquities Museum related card was replaced with Thai Hoa Palace as a non-duplicate royal-hall comparison.

## Sub-Agent QA

- Source-risk QA: `019e8bef-ad55-7511-bb6f-aa390ea78784`
  - Flagged Le Ba Dang Memory Space identity: Kim Sơn / Thủy Bằng site, not a generic downtown gallery.
  - Flagged Le Loi source softness around hotels/cafes/traffic; copy was softened to central riverside/address-route utility.
  - Flagged Les Jardins menu specifics; copy now avoids volatile dish claims.
  - Flagged Lien Hoa `chay` explanation gap; intro now defines it plainly.
  - Flagged Long An Palace identity and duplicate related card risk; intro and related card were corrected.
- U.S.-traveler readability QA: `019e8bf0-0fb5-7f52-91a8-c83cb317fcdf`
  - Flagged Le Ba Dang Memory Space repetition and unnatural `right picture` phrasing.
  - Flagged Long An Palace abstract `close looking` / `safer memory` phrasing.
  - Both patterns were removed before validation.

## Validation

Command chain:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-authored-tier-one-pages.js &&
node native-ios/scripts/generate-viet-sqlite-fixture.js &&
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production &&
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js &&
node native-ios/scripts/validate-viet-city-copy.js &&
node native-ios/scripts/validate-viet-city-library.js &&
node native-ios/scripts/validate-viet-sqlite-fixture.js &&
node native-ios/scripts/audit-viet-listing-production-qa.js &&
git diff --check
```

Result: PASS.

Key results:

- v2.2 projection: 520 entries
- strict production validation: 520 pass, 0 revise, 0 fail
- voice audit: 0 failures
- city production copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes
- city library validation: 826 pages
- SQLite validation: ok
- production QA: 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator profile: `city-listings-production-ready`

Rendered page left open on Simulator:

- `viet-family-city-hue-place-le-ba-dang-memory-space`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-049-screenshots/001-hue-le-ba-dang-memory-space-top.jpg`

Simulator build/run result: PASS.

## Phone Build

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS.
- Install: FAIL / unresolved. The install step hung inside `devicectl device install app` after acquiring the device connection and usage assertion.
- Launch: not attempted because install did not complete.

The stuck install process was terminated after several minutes so no background install session remained open.

Signing hygiene:

- Repo signing scan: PASS.
- No repo-visible personal signing was detected in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Carry Forward

Batch 049 reinforces the new review rule from Batch 048: art and museum pages must avoid abstract appreciation instructions. The better pattern is venue identity first, then what the visitor will actually encounter, then why this specific place matters in a first Vietnam trip.

Future Long An-style pages should also check for duplicate or misleading related cards when the related target is part of the same institution rather than a separate next stop.
