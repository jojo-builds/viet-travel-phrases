# Handwritten Recovery Batch 019 - 2026-06-03

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Recovered five additional HCMC app-detail listings from first-class V2.2 source:

- `city-hcmc-place-akuna` - Akuna
- `city-hcmc-place-an-dong-market` - An Dong Market
- `city-hcmc-place-anan-saigon` - Anan Saigon
- `city-hcmc-place-banh-mi` - Banh mi
- `city-hcmc-place-banh-mi-huynh-hoa` - Banh Mi Huynh Hoa

## Count

- Previous recovered count: 89 / 520
- New recovered pages in this batch: 5
- Current recovered count: 94 / 520
- Remaining pages: 426

## QA Loop

This batch used the stricter human-readability loop:

- Drafted source-first in `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`.
- Read the five entries on their own, outside the validator output.
- Asked one read-only QA agent to review natural English, undefined terms, abstract phrasing, command-like phrasing, and whether a U.S. first-time Vietnam traveler could picture the place or food.
- Asked a second read-only QA agent to review save-worthiness and factual risk.
- Integrated QA fixes before projection and validation.

Specific QA corrections:

- Akuna and Anan now say `Michelin-recognized` instead of hard-coding `Michelin-starred` in visible copy, reducing annual-award brittleness while still signaling the current guide context.
- Akuna now frames the page as a long tasting-menu dinner at Le Méridien Saigon, with Vietnamese ingredients, an open kitchen, and a slower reservation-night rhythm.
- An Dong now describes a District 5 shopping market for fabric, clothes, accessories, and wholesale-style browsing without turning Ben Thanh into a broad value judgment.
- Anan now explains the market-street contrast: old Tôn Thất Đạm market area outside, composed modern Vietnamese dishes inside.
- The general bánh mì page and Huỳnh Hoa page define bánh mì for first-time U.S. readers and make the chili/filling/line/takeaway decisions concrete.
- Huỳnh Hoa now gives a clearer why-this-counter reason: a well-known Saigon counter for a richer, heavier named version, not just a generic famous shop.

## Validation

Ran:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
git diff --check
```

Results:

- V2.2 strict production validation: PASS, 520 entries
- Voice audit: PASS, 0 failures
- City production copy validation: PASS
- City library validation: PASS, 826 pages
- SQLite fixture validation: PASS
- Production QA audit: PASS, 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator profile:

- Project: `native-ios/SpeakLocalNative.xcodeproj`
- Scheme: `SpeakLocalNative`
- Simulator: `SpeakLocal City Listings`

Rendered page:

- `viet-family-city-hcmc-place-banh-mi-huynh-hoa`

Screenshots:

- Hero proof: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-019-screenshots/banh-mi-huynh-hoa-hero.jpg`
- Scrolled sections proof: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-019-screenshots/banh-mi-huynh-hoa-sections.jpg`

The Simulator was left open on the Banh Mi Huynh Hoa body sections so Jojo can read the latest copy direction.

## Phone Build

Ran the SpeakLocal physical-device build helper with:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: FAIL - iOS refused launch with a code-signing / profile-trust style security error
- Repo signing files: clean

Additional signing hygiene checks:

- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean
- signing-secret scan against project files: no matches
- `git diff --check`: PASS

## Freshness Sources Checked

- Akuna Michelin profile: https://guide.michelin.com/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/akuna
- Anan Saigon Michelin profile: https://guide.michelin.com/is/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/anan-saigon
- Vietnam tourism bánh mì background: https://vietnamtourism.gov.vn/en/post/21542
- Vietnam Airlines Banh Mi Huynh Hoa guide context: https://www.vietnamairlines.com/mm/en/plan-book/travel/travel-guide/best-banh-mi-ho-chi-minh
- An Dong market background: https://travelsaigon.org/place/an-dong-plaza/

Visible copy avoids unstable hours, prices, exact menu availability, and current service details.

## Status

Batch 019 is validated, rendered on Simulator, and installed on the phone. Phone launch is not proven because iOS refused launch for a signing/profile-trust security reason. The overall 520-listing project remains incomplete. Current production-ready recovery count is 94 / 520.
