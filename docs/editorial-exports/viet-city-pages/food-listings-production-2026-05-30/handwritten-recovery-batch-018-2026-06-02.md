# Handwritten Recovery Batch 018 - 2026-06-02

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Recovered five additional HCMC app-detail listings from first-class V2.2 source:

- `city-hcmc-place-42-nguyen-hue-apartment` - 42 Nguyen Hue Apartment
- `city-hcmc-place-ao-dai-museum` - Ao Dai Museum
- `city-hcmc-place-bach-dang-waterbus-station` - Bach Dang Waterbus Station
- `city-hcmc-place-bach-dang-wharf` - Bach Dang Wharf
- `city-hcmc-place-ben-thanh-metro-station` - Ben Thanh Metro Station

Also repaired one already-counted prior page after live copy review and read-only sub-agent critique:

- `city-hcmc-place-cho-lon-walking-route` - rewrote the page around plain first-time-visitor context: Saigon's historic Chinatown, Bình Tây Market, nearby Chinese-Vietnamese shop streets, Thiên Hậu Temple, and when to walk nearby versus take a ride farther.

## Count

- Previous recovered count: 84 / 520
- New recovered pages in this batch: 5
- Current recovered count: 89 / 520
- Remaining pages: 431

The Chợ Lớn walking-route repair does not increase the count because it was already counted in an earlier recovery batch; it remains part of the production-readiness cleanup trail.

## QA Loop

This batch used the stricter human-readability loop requested during live review:

- Drafted source-first in `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`.
- Asked a read-only copy QA agent to review for U.S. first-time-traveler clarity, undefined terms, and sentence-level naturalness.
- Asked a second read-only QA agent to review save-worthiness: whether the page gives a real reason to keep the listing instead of sounding like generic travel copy.
- Integrated concrete fixes before projection, including removing labels such as "route," "handoff," "durable memory," "pins," and other words that read like internal app/copy system language.
- Repaired the Chợ Lớn walking-route page again after an independent read-only review rated the previous repair as improved but still not fully strong.

## Voice Notes

- The Batch 018 pages now identify the place type before giving advice: an old cafe apartment block, a museum about Vietnam's áo dài, a public waterbus station, the central river wharf, and the downtown metro station.
- The Ao Dai Museum page defines áo dài in American-friendly terms as Vietnam's long tunic worn over trousers, rather than assuming the user already knows the garment.
- The waterbus and metro pages avoid pretending schedule/fare details are stable; they explain what the traveler should remember and where live details belong.
- The Ben Thanh Metro page explains why the name matters for a first-time visitor: market landmark, station exits, ride pickups, and the next District 1 walk.
- The Chợ Lớn page now says why the area is Saigon-specific instead of just calling it a "cluster": Chinese-Vietnamese history, shop signs, herbal-medicine stores, wholesale trade, market stalls, and temples still used for worship.

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

Rendered page:

- `viet-family-city-hcmc-place-ben-thanh-metro-station`

Screenshots:

- Hero proof: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-018-screenshots/ben-thanh-metro-hero.jpg`
- Scrolled sections proof: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-018-screenshots/ben-thanh-metro-sections.jpg`

The Simulator was left open on the Ben Thanh Metro Station body sections so Jojo can read the latest copy direction.

## Phone Build

Ran the SpeakLocal physical-device build helper with:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: blocked because the iPhone was locked
- Repo signing files: clean

Additional signing hygiene checks:

- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean
- signing-secret scan against project files: no matches
- `git diff --check`: PASS

## Sources

No runtime source lookup was added to the app. This batch used the existing repo source notes plus stable, general place facts already represented in the city-library source. Time-sensitive details such as waterbus schedules, metro fares, and exact operating steps were deliberately kept out of the fixed offline copy.

## Status

Batch 018 is validated, rendered on Simulator, and installed on the phone. The overall 520-listing project remains incomplete. Current production-ready recovery count is 89 / 520.
