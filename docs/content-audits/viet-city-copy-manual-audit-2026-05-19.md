# Viet City Copy Manual Audit - 2026-05-19

Status: manual editorial audit and first repair batch. This is not a generator report and not a validator pass.

## Audience Bar

City place pages should read like compact travel-guide copy with playable local language for English-speaking travelers planning Vietnam. The page should make the place, food, street, market, or landmark feel worth recognizing before arrival, then teach the Vietnamese name once the place has a reason to exist.

## Manual Audit Findings

Four read-only reviewers inspected the city handwritten-copy files directly:

- `content-draft/viet/city-library/handwritten-copy/danang.json`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/handwritten-copy/hcmc.json`
- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `content-draft/viet/city-library/handwritten-copy/hue.json`

The common bad pattern is visible scaffold residue, not shortness:

- "works best when the name is tied..."
- "not memorized as an abstract label"
- "the local name is easier to remember..."
- repeated city bundles such as "alongside bridge-and-beach Da Nang"
- interchangeable lists like "local flavor, texture, herbs, sauce, steam"
- venue pages that collapse into "meal should feel like part of the itinerary"

## Pages Judged Good Enough To Leave Alone

These pages read authored and should not be rewritten just because neighboring pages are weak:

- Da Nang: `city-danang-place-dragon-bridge`, `city-danang-place-golden-bridge`, `city-danang-place-hai-van-pass`, `city-danang-place-lady-buddha`, `city-danang-place-marble-mountains`, `city-danang-place-museum`, `city-danang-place-nam-o-fish-sauce-village`, `city-danang-place-3d-art-in-paradise`
- Hanoi: `city-hanoi-place-bia-hoi`, `city-hanoi-place-cho-buoi-market`, `city-hanoi-place-giang-cafe`, `city-hanoi-place-literature-museum`, `city-hanoi-place-nguyen-huu-huan-street`, `city-hanoi-place-the-note-coffee`, `city-hanoi-place-turtle-tower`
- HCMC: `city-hcmc-place-42-nguyen-hue-apartment`, `city-hcmc-place-cafe-apartment-nguyen-hue`
- Hoi An: `city-hoian-place-faifo-coffee`, `city-hoian-place-reach-out-tea-house`
- Hue: no full page was judged clean enough yet, though several openings have usable source material.

## First Repair Batch

Hand-authored updates were made only to the following bad pages:

- Da Nang: `city-danang-place-ba-na-hills`, `city-danang-place-con-market`, `city-danang-place-han-market`, `city-danang-place-linh-ung-pagoda`, `city-danang-place-phap-lam-pagoda`
- Hanoi: `city-hanoi-place-bun-cha`, `city-hanoi-place-egg-coffee`
- HCMC: `city-hcmc-place-banh-mi`, `city-hcmc-place-ben-thanh-market`, `city-hcmc-place-war-remnants-museum`
- Hoi An: `city-hoian-place-an-bang`, `city-hoian-place-ancient-town`, `city-hoian-place-cao-lau-city`
- Hue: `city-hue-place-bun-bo-city`, `city-hue-place-dong-ba`, `city-hue-place-imperial-city`

## Remaining Fix Families

The next repair passes should stay hand-authored and page-specific. Do not run `scripts/rewrite-viet-city-audience-copy.js` for this cleanup.

Highest-value remaining families:

- city-defining food pages in Hanoi, HCMC, Hoi An, and Hue
- main markets and streets in each city
- Hue royal sites and pagodas
- Hoi An heritage buildings, villages, and craft stops
- HCMC museums, markets, and major landmarks
- Da Nang beaches, Son Tra pages, and remaining market/cafe/restaurant pages

After each batch, import handwritten copy into `content-draft/viet/city-library/v1.json`, regenerate the native authored listing resource, and run the city-copy validators as projection and safety checks only.
