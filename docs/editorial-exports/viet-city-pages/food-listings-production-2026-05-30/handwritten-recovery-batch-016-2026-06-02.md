# Handwritten Recovery Batch 016 - 2026-06-02

## Scope

Batch 016 repaired one previously counted HCMC page and recovered four net-new HCMC pages.

1. `city-hcmc-place-cho-lon-walking-route` / Đi bộ Chợ Lớn - repair after user readability review
2. `city-hcmc-place-le-van-tam-park` / Công viên Lê Văn Tám
3. `city-hcmc-place-municipal-theatre-square` / Quảng trường Nhà hát Thành phố
4. `city-hcmc-place-nephele` / Nephele
5. `city-hcmc-place-opera-a-o-show` / À Ố Show

Count policy: Chợ Lớn was already included in the Batch 015 count but did not meet the human-readable bar after live simulator review. This batch fixes that page and adds four net-new recovered listings. Conservative count after this batch: 79/520 recovered, 441 remaining.

## Editorial Notes

- Chợ Lớn was rewritten away from abstract lines such as "trade texture," "walking suits tight clusters," and "flexible cluster." The page now plainly explains that Chợ Lớn is Saigon's historic Chinatown, names Bình Tây Market and Thiên Hậu Temple, and gives a concrete route rhythm: walk around nearby stops and use a taxi/Grab for farther gaps.
- Lê Văn Tám Park now explains why the park has more than generic shade value: its older life as Mạc Đĩnh Chi Cemetery, plus its current use as a normal central green reset.
- Lam Sơn Square now says what it is in normal terms: the small plaza area in front of Saigon Opera House, useful for meeting, photos, show entry, and orientation in District 1.
- Nephele now explains the restaurant itself: a dinner-only tasting-menu restaurant in Bình Thạnh with a quieter alley setting, set menu, staff guidance, and wine/non-alcoholic pairings.
- À Ố Show now tells first-time U.S. visitors what they are actually buying: a Vietnamese bamboo-circus / physical-theatre show at Saigon Opera House, not an opera in the usual American expectation.

## Voice Repairs From Jojo Feedback

- Removed or avoided: `The details are close to the street`, `trade texture`, `Walking suits tight clusters`, `flexible cluster`, `fixed loop`, `Traffic, heat, and distance can decide`, `place name`, `fits naturally`, `not a`, `this is not`, `better when`, and excess `feel/feels/feeling`.
- Replaced command-like and label-like headings with natural mobile-reading headings such as `What Sets It Apart`, `Market First, Temple After`, `Walk Nearby, Ride Farther`, `Market, Temple, Snack`, and `A Bamboo-Circus Show`.
- Fixed source-order mistake discovered by simulator proof: edits must land in `content-draft/viet/city-library/app-detail-v2-2/hcmc.json` before `project-viet-city-app-detail-v2-2-to-handwritten-copy.js`, because that projection copies app-detail source into `handwritten-copy`.
- Cleaned hidden app-detail fields for the same five pages, including `travelerMoment`, `storySpine`, score reasons, and related-card subtitles/reasons, so stale wording does not leak into summaries or cards.

## Validation

Passed:

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

Key validation results:

- V2.2 city app-detail validation: 520/520 pass.
- City production copy: 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: 826 pages OK.
- SQLite integrity: OK.
- Production QA audit: 0 blockers, 0 majors.

## Render Proof

Simulator:

- Profile: `city-listings-production-ready`
- Project: `native-ios/SpeakLocalNative.xcodeproj`
- Scheme: `SpeakLocalNative`
- Simulator: `SpeakLocal City Listings`
- Launch args: `--detail-page viet-family-city-hcmc-place-cho-lon-walking-route`
- Page left open on the revised Chợ Lớn sections.
- Screenshot: `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_e8e4406d-33f3-4766-bb71-46ebbff2609a.jpg`

Visible revised section text in runtime snapshot:

- `What Sets It Apart`
- `This part of Saigon grew around Chinese-Vietnamese trade. You notice it in wholesale market stalls, herbal-medicine shops, Chinese characters on signs, temple gates, and incense inside active places of worship.`
- `Market First, Temple After`
- `Bình Tây Market is a working wholesale market, with local buying and selling happening around you. Thiên Hậu Temple gives the walk a calmer second piece, with incense coils and a Chinese temple setting far from District 1's hotel streets.`
- `Walk Nearby, Ride Farther`
- `The main stops spread across Chợ Lớn. Short walks around each stop plus a taxi or Grab between farther blocks keeps the visit focused on the district instead of traffic and heat.`
- `Market, Temple, Snack`
- Related card subtitle shown in runtime snapshot: `A working wholesale market inside Chợ Lớn, useful when the walk needs one clear market stop.`

## Phone Build

Built from:

`/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Result:

- Build: succeeded.
- Install: succeeded.
- Launch: blocked because the iPhone was locked.
- Repo signing hygiene: clean. `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` stayed unchanged and no repo-visible personal signing values were found.

## Source Links Checked

- https://en.wikipedia.org/wiki/Ch%E1%BB%A3_L%E1%BB%9Bn,_Ho_Chi_Minh_City
- https://en.wikipedia.org/wiki/B%C3%ACnh_T%C3%A2y_Market
- https://en.wikipedia.org/wiki/Thi%C3%AAn_H%E1%BA%ADu_Temple,_Ho_Chi_Minh_City
- https://en.wikipedia.org/wiki/L%C3%AA_V%C4%83n_T%C3%A1m_Park
- https://en.wikipedia.org/wiki/Municipal_Theatre,_Ho_Chi_Minh_City
- https://www.luneproduction.com/ao-show
- https://guide.michelin.com/vn/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/nephele

## Remaining Risk

This batch reinforces that validator passes are necessary but not sufficient. The source-order mistake also showed why simulator proof must inspect visible copy after projection, not before. The remaining 441 listings still need human review at the same bar: plain-English context, specific reason to remember the listing, and no clever/abstract filler.
