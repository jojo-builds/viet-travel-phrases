# TASK-VIET-DERIVED-PLACE-PHRASE-TEMPLATE-001

## Summary

Fixed derived Viet city/place phrase pages so rows such as `Nhà hàng Nén Đà Nẵng ở đâu?`, `Đi Bà Nà Hills`, and `Đường Nguyễn Văn Linh gần đây không?` render as compact phrase-detail pages instead of full destination pages.

Root cause: the city listing generator routed every phrase with a `placeID` through the normal phrase/destination article pattern. That let destination sections, duplicated "Meaning / Say this" style copy, generic hero imagery, and unrelated relationship-word shelves leak onto child phrase pages.

## Product Behavior

Derived place phrase pages now use:

- compact neutral phrase masthead via `HeroCompactPhraseMasthead`;
- `Practice this phrase` CTA from practice metadata;
- `Break it down`;
- `Related phrases`;
- `Tip`;
- no generic Vietnam hero image;
- no `At a glance`, `Quick say`, `When to use it`, `Explore next`, or `Relationship words` sections.

Restaurant-derived phrase pages prioritize the restaurant page and full practical rows:

- `Nén Đà Nẵng` / `Nén Đà Nẵng`
- `Cho tôi đến nhà hàng Nén Đà Nẵng.` / `Please take me to Nén Đà Nẵng restaurant.`
- `Tôi có đặt bàn ở Nén Đà Nẵng` / `I have a reservation at Nén Đà Nẵng`
- `Cho tôi xem thực đơn được không?` / `Can I see the menu?`

The source row `Đi Nén Đà Nẵng` was replaced with the full driver sentence above. Similar clipped restaurant route/drop-off rows were corrected across the city library.

## Guardrails Added

- Derived place phrase pages are categorized as `derived-place-phrases`.
- City library validation now fails derived pages with destination sections, relationship shelves, internal/editorial wording, too few related rows, or clipped restaurant route/drop-off source rows.
- SQLite validation, canonical audit, and page-quality audit now recognize compact derived phrase pages as their own article contract.
- Search priority now favors actual restaurant/place/street pages over derived child phrase pages.

## Proof

Rendered resource spot checks:

- `viet-family-city-danang-where-nen`: compact derived phrase page; English `Where is Nén Đà Nẵng?`; no relationship section; CTA `Practice this phrase`.
- `viet-family-city-danang-place-nen`: still a full restaurant page; CTA `Practice ordering here`; route row is the full restaurant sentence.
- `viet-family-city-danang-go-ba-na-hills`: compact derived phrase page; no destination hero or relationship-word shelf.
- `viet-family-city-danang-go-dragon-bridge`: compact derived phrase page; no destination hero or relationship-word shelf.
- `viet-family-city-danang-near-nguyen-van-linh-street`: compact derived phrase page; no destination hero or relationship-word shelf.

Broad rendered-resource scan:

- `601` derived place phrase pages checked.
- `0` pages with relationship-word sections.
- `0` pages with forbidden destination/duplicate sections.
- `0` pages with banned user-facing phrases such as `the traveler`, `place name`, `local name`, `use it with`, `when to use it`, `route phrase`, or `where-question`.
- `0` pages missing compact hero metadata.
- `0` pages missing `Practice this phrase` / `phrase_audio_review` practice metadata.

Simulator proof:

- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-DERIVED-PLACE-PHRASE-TEMPLATE-001/nen-where-compact-top-v2.png`

## Validation

Passed:

- `node --check native-ios/scripts/generate-authored-tier-one-pages.js`
- `node --check native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node --check native-ios/scripts/validate-viet-city-library.js`
- `node --check native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node --check native-ios/scripts/audit-viet-canonical-content.js`
- `node --check native-ios/scripts/audit-viet-page-quality.js`
- `node --check native-ios/scripts/repair-viet-breakdown-glosses.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- `git diff --check`

Counts:

- `3,070` canonical pages
- `3,078` source phrases
- `601` derived place phrase pages
- `0` duplicate canonical page groups
- `2,126` planned missing-audio rows

## Suggested Phone Checks

Search and open:

- `Nhà hàng Nén Đà Nẵng ở đâu?`
- `Nén Đà Nẵng`
- `Bà Nà Hills ở đâu?`
- `Đi cầu Rồng`
- `Đường Nguyễn Văn Linh gần đây không?`

Expected: child phrase pages are compact phrase pages; actual restaurant/place/street pages remain fuller pages.
