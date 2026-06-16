# Handwritten Recovery Batch 029

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Recovered five HCMC V2.2 source listings:

- `viet-family-city-hcmc-place-independence-palace`
- `viet-family-city-hcmc-place-jade-emperor-pagoda`
- `viet-family-city-hcmc-place-japan-town`
- `viet-family-city-hcmc-place-landmark-81`
- `viet-family-city-hcmc-place-le-thanh-ton-street`

Progress after this batch: 144 / 520 recovered, 376 remaining.

## Human Rewrite Notes

- Independence Palace now explains the Reunification Palace naming, the 1960s modernist building, ceremonial rooms, basement command areas, and the April 30, 1975 tank story without turning into a long war-history lecture.
- Jade Emperor Pagoda now explains that it is an active Taoist-Buddhist temple also known as Phước Hải Tự, with incense coils, altar rooms, carved figures, worshippers, courtyard movement, and a turtle pond.
- Japan Town now reads as a District 1 Japanese dining cluster around Lê Thánh Tôn, Thái Văn Lung, and nearby alleys. The phrase cards were corrected from ticket/showtime phrases to food phrases.
- Landmark 81 now explains why it matters beyond height: Vietnam’s tallest building, Saigon River / Bình Thạnh setting, Vinhomes Central Park, mall floors, hotel/residence skyline context, and weather-sensitive high-view planning.
- Lê Thánh Tôn Street now has a clear street-navigation role distinct from Japan Town: taxi routes, hotel pickups, restaurant addresses, Japan Town edge, signs, numbers, and doorway-finding at night.

## Review Loop

Two sub-agent reviews were used:

- Factual/source-risk QA: `019e8a59-1596-7990-a705-c2e6f932807e`
- Human-readability QA: `019e8a5e-4923-7662-ba91-dbabe9f5d090`

Reviewer-driven fixes applied:

- Added Independence Palace / Reunification Palace context and removed vague `political past` framing.
- Added Jade Emperor Pagoda temple-type and local-name context.
- Replaced Japan Town ticket/showtime phrase cards with audio-backed food phrase cards.
- Replaced Landmark 81 walking-oriented phrase cards with directions, entrance, and photo permission.
- Removed label-like headings such as `Rooms, Basement, History`, `A District 1 Street To Recognize`, and `Useful For Addresses`.
- Removed local `feel/feels/feeling` usage that pushed the voice audit over its cap.

## Validation

Command chain passed:

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

Result:

- V2.2 strict production validation: PASS
- Voice audit failures: none
- City copy validation: PASS
- City library validation: PASS
- SQLite fixture validation: PASS
- Production QA audit: 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator build/run succeeded on `SpeakLocal City Listings` with launch arg:

```sh
--detail-page viet-family-city-hcmc-place-le-thanh-ton-street
```

Screenshot:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-029-screenshots/001-hcmc-le-thanh-ton-street-top.jpg`

The Simulator was left open on the revised Lê Thánh Tôn Street listing for Jojo review.

## Phone Build

Physical iPhone build and install were run via the SpeakLocal device-build helper with `SPEAKLOCAL_REPO_ROOT` pointed at this worktree.

Result:

- Build: PASS
- Install: PASS
- Launch: blocked because the phone was locked
- Signing hygiene: repo project files stayed clean
