# Handwritten Recovery Batch 017 - 2026-06-02

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Recovered five additional HCMC app-detail listings from first-class V2.2 source:

- `city-hcmc-place-opera-house` - Saigon Opera House
- `city-hcmc-place-pasteur-street` - Pasteur Street
- `city-hcmc-place-pha-lau` - Pha lau
- `city-hcmc-place-pham-ngu-lao-street` - Pham Ngu Lao Street
- `city-hcmc-place-pho-hoa-pasteur` - Pho Hoa Pasteur

Also repaired one prior recovered page after live voice review:

- `city-hcmc-place-cho-lon-walking-route` - replaced abstract route language with plain first-time-visitor context: Saigon's historic Chinatown, Bình Tây Market, nearby shop streets, Thiên Hậu Temple, and why rides help between farther blocks.

## Count

- Previous recovered count: 79 / 520
- New recovered pages in this batch: 5
- Current recovered count: 84 / 520
- Remaining pages: 436

The Chợ Lớn walking-route repair does not increase the count because it was already counted in Batch 015/016 recovery; it remains part of the production-readiness cleanup trail.

## Voice Notes

- Removed or avoided abstract phrases such as "trade texture," "walking suits tight clusters," "flexible cluster," "fixed loop," and other content-model language.
- The Chợ Lớn page now explains the place before giving route advice: it is Saigon's historic Chinatown, west of the District 1 hotel core.
- The page names concrete stops and why they matter: Bình Tây Market for the working market side, Thiên Hậu Temple for worship and architecture, and rides for longer gaps across the district.
- During validation, the importer/voice gates caught `anchor`, `not only`, and `works best`; each was replaced with plainer language.
- During Simulator proof for `city-hcmc-place-pho-hoa-pasteur`, the sentence "The draw is convenience..." was replaced with a concrete central-address explanation under `The Pasteur Address`.

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
- Voice audit: PASS
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

Rendered pages:

- `viet-family-city-hcmc-place-pho-hoa-pasteur`
- `viet-family-city-hcmc-place-cho-lon-walking-route`

Screenshots:

- Top proof for Chợ Lớn walking route: `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_38fff52b-5eae-468e-937c-1f26254657e8.jpg`
- Scrolled proof for repaired Chợ Lớn sections: `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_77657c32-aa82-4181-ac6f-73ff2b9cf281.jpg`

The Simulator was left open on the repaired Chợ Lớn walking-route sections.

## Phone Build

Ran the SpeakLocal physical-device build helper with:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: PASS
- Repo signing files: clean

Additional signing hygiene checks:

- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean
- signing-secret scan against project files: no matches
- `git diff --check`: PASS

## Freshness Sources Checked

- Saigon Opera House / Municipal Theatre: https://en.wikipedia.org/wiki/Municipal_Theatre,_Ho_Chi_Minh_City
- Pham Ngu Lao Street: https://en.wikipedia.org/wiki/Ph%E1%BA%A1m_Ng%C5%A9_L%C3%A3o_Street
- Bui Vien Street: https://en.wikipedia.org/wiki/B%C3%B9i_Vi%E1%BB%87n_Street
- Pho Hoa Pasteur address cross-check: https://www.viet-biz.com/en/ph%E1%BB%9F-h%C3%B2a-pasteur-0862-695-588
- Chợ Lớn context: https://www.nomadotravel.app/en/places/cholon
- Chợ Lớn context: https://travelsaigon.org/place/chinatown/

## Status

Batch 017 is validated and phone-installed, but the overall 520-listing project remains incomplete. Current production-ready recovery count is 84 / 520.
