# Handwritten Recovery Batch 050 - 2026-06-03

Status: PASS for authored copy import, native resource generation, validator guardrails, voice audit, and Simulator render proof. Physical iPhone build passed, but install hung in `devicectl` and was terminated after the device install step did not complete.

Progress after this batch: 249 / 520 recovered. Remaining: 271.

## Scope

- `viet-family-city-hue-place-mandarin-coffee-restaurant` - Mandarin Coffee & Restaurant
- `viet-family-city-hue-place-me-xung` - Mè xửng ở Huế / Me xung sesame candy
- `viet-family-city-hue-place-minh-mang-tomb` - Lăng Minh Mạng / Tomb of Minh Mang
- `viet-family-city-hue-place-museum-commissioned-porcelains` - Bảo tàng Đồ sứ ký kiểu thời Nguyễn / Museum of Nguyen Dynasty Commissioned Porcelains
- `viet-family-city-hue-place-nam-giao-esplanade` - Đàn Nam Giao / Nam Giao Esplanade

## Carried-Forward Fix

- `viet-family-city-hue-place-le-ba-dang-memory-space` was also revised after Jojo flagged that the page assumed readers already knew Lê Bá Đảng. The intro now explains him as a Vietnamese modern artist born near Hue who built much of his career in France, and the page explains why that matters before using the artist as the reason to care.

## Authored Fixes

- Mandarin Coffee & Restaurant now reads as a Hue cafe-restaurant with coffee, juices, Hue-style dishes, greenery, and a restored wooden-house feel, rather than a vague place to pause.
- Mè xửng now defines the sweet plainly: chewy Hue sesame candy made with sesame, peanuts, and malt sweetness, often eaten with tea or bought as a small gift.
- Minh Mang Tomb now emphasizes the royal landscape: lakes, gates, pavilions, paths, and a formal route outside the central city.
- Museum of Nguyen Dynasty Commissioned Porcelains now explains the object focus in human terms: bowls, plates, blue-and-white decoration, poems, motifs, tea items, betel objects, and court life at table scale.
- Nam Giao Esplanade now defines the Nguyễn emperors as rulers from Vietnam's last royal dynasty and explains the open terraces as a ceremony site for Heaven-and-Earth rituals.

## Review-Gate Update

Jojo flagged a recurring production-readiness gap: the copy was naming people, Vietnamese terms, awards, foods, rituals, and cultural references as if U.S.-based first-time Vietnam travelers already knew them.

Five Whys:

1. Why did the weak section appear?
   - The copy used `one Vietnamese artist` as if nationality plus category were enough context.

2. Why did that fail the reader?
   - A first-time U.S. visitor does not know Lê Bá Đảng, the Vietnamese art context, or why a memory space around him should be meaningful.

3. Why did the page feel generic?
   - The sentence talked around the evidence (`contemporary art`, `designed building`, `garden-like grounds`) instead of explaining the person and the reason the site exists.

4. Why did review miss it?
   - The gate checked for abstract art language but did not require first-mention context for named people and Vietnamese cultural terms.

5. Why could it recur?
   - Many Vietnam listings include names, foods, rituals, awards, and local terms that are familiar to the writer or source material but unfamiliar to the app reader.

Root cause: the copy assumed background knowledge the target audience does not have. The production review gate now requires first-mention proof for named people, Vietnamese terms, awards, dishes, rituals, dynasties, neighborhoods, and cultural references.

## Sub-Agent QA

- Source-risk QA: `019e8c05-7a3e-74a1-9c4d-02e1a2342a88`
  - Flagged Mandarin identity drift; copy now avoids older photographer-cafe framing and stays with the current cafe-restaurant/green-space evidence.
  - Flagged the porcelain museum as too abstract; copy now explains commissioned porcelain objects and old-house museum scale.
  - Flagged Nam Giao ticket/access risk; phrase cards were softened to entrance, taxi destination, and photo permission.
- U.S.-traveler readability QA: `019e8c05-d09e-7aa3-bd0f-dfece74dcc84`
  - Flagged abstract museum language, internal-sounding reasons, and places where copy did not explain why a reference matters.
  - The named-reference rule from Jojo's Le Ba Dang critique was added to the review gate before validation.

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

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-050-screenshots/001-hue-le-ba-dang-memory-space-top.jpg`

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

The stuck install process was terminated so no background install session remained open.

Signing hygiene:

- Repo signing scan: PASS.
- No repo-visible personal signing was detected in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Carry Forward

The review gate now blocks copy that assumes prior knowledge. Future pages must explain first mentions of named people, Vietnamese terms, awards, rituals, foods, dynasties, neighborhoods, and cultural references before relying on them as reasons to care.

Do not solve this by stripping copy down. The fix is fuller, plainer context: who/what it is, why it matters in Vietnam, and what a first-time U.S. traveler can expect to see, order, say, or understand.
