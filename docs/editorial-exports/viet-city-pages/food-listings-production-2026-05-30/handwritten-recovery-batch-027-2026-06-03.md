# Handwritten Recovery Batch 027 - 2026-06-03

Status: COMPLETE_FOR_BATCH

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch: `feature/city-listings-production-ready`

## Scope

Previous recovered count: 129 / 520

Batch size: 5

Current recovered count: 134 / 520

Remaining: 386

Recovered source entries:

- `viet-family-city-hcmc-place-dong-khoi-street`
- `viet-family-city-hcmc-place-fine-arts-museum`
- `viet-family-city-hcmc-place-fito-museum`
- `viet-family-city-hcmc-place-gia-dinh-park`
- `viet-family-city-hcmc-place-goi-cuon`

## Copy Recovery Notes

- Đồng Khởi Street now explains how the street differs from the landmark-walk page: it is the District 1 corridor of old hotel facades, storefronts, cafés, scooters, and river direction, with Bùi Viện as a clear nightlife-street contrast.
- Ho Chi Minh City Museum of Fine Arts now gives a concrete save reason: art plus the yellow-and-white colonial-era building, tiled floors, stairways, courtyard movement, and a central heat/rain switch.
- FITO Museum now reads as a narrow traditional-medicine collection rather than a generic indoor museum: wooden rooms, herb drawers, old tools, medicine texts, portraits, and healing history.
- Gia Định Park now frames the place as a near-airport local green break, useful when already nearby, without implying it is an airport facility or a cross-city destination.
- Gỏi cuốn now plainly explains the dish for U.S. readers: fresh spring rolls, not fried egg rolls; rice paper, herbs, noodles, shrimp or pork, and usually peanut-style sauce in the south.

## QA Loop

Two read-only sub-agents reviewed the exact five-page scope:

- Factual/source-risk QA checked current support and fragile claims.
- Human-readability/save-worthiness QA checked the revised copy against Jojo's U.S. first-time traveler lens.

Concrete QA fixes integrated:

- Removed weak or app-like phrases including `riverward movement`, `one look-before-sitting`, `useful because`, `not a`, `lands best`, `the reason to save it`, `Come For...`, and command-like museum headings.
- Softened Đồng Khởi sequence language so the route remains flexible rather than claiming one definitive path.
- Replaced Fine Arts Museum's vague `slower room of Saigon history` with building-and-art specifics.
- Avoided citing or relying on the potentially compromised FITO official domain.
- Adjusted gỏi cuốn sauce language toward southern peanut-style sauce, with fish sauce as a possible option.
- Removed `pause` and `belongs` from this batch after the global voice audit pushed those crutch counts over the limit.

## Freshness Sources Checked

- VietnamOnline Đồng Khởi Street: https://www.vietnamonline.com/maps/ho-chi-minh-city/dong-khoi-street.html
- Visit HCMC museum list / Fine Arts Museum: https://visithcmc.vn/en/tin-tuc/top-13-bao-tang-noi-tieng-nhat-o-hcm-danh-cho-nguoi-yeu-nghe-thuat_en
- Lonely Planet Fine Arts Museum: https://www.lonelyplanet.com/points-of-interest/fine-arts-museum/403172
- Vietnam Pictorial / VNA FITO Museum article: https://vietnam.vnanet.vn/english/english/tin-tuc/vietnams-traditional-medicine-museum-82636.html
- VOV English Gia Định Park context: https://english.vov.vn/en/places/the-green-forests-in-the-heart-of-saigon-293300.vov
- Local Vietnam gỏi cuốn guide: https://localvietnam.com/culture/cuisine/goi-cuon/

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

Result: PASS

Notes:

- Final V2.2 strict validation passed for all 520 entries.
- Voice audit reported `failures: []`.
- City copy, city library, SQLite fixture, production QA, and `git diff --check` all passed.
- Production QA reported 0 blockers and 0 majors.

## Render Proof

Simulator profile: `city-listings-production-ready`

Simulator: `SpeakLocal City Listings`

Rendered page left open for review: `viet-family-city-hcmc-place-goi-cuon`

Proof screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-027-screenshots/001-hcmc-goi-cuon-top.jpg`

Render proof result: PASS, app built and launched on simulator with the revised page open.

## Phone Build

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: BLOCKED because the physical iPhone was locked
- Repo signing files: clean
- Repo signing scan: no matches

## Overall

Batch 027 is complete. The overall recovery goal remains active at 134 / 520 recovered.
