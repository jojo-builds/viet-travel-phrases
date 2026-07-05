# Humanizer Gate 500 Final Review

Date: 2026-05-26

Status: REVOKED - rendered phone review failed

Scope: 500 Vietnam city listing pages in the current city-library runtime source shape.

## Review Result

The 500-listing humanizer gate passed import/validator integrity but is not production-ready after rendered phone review. It was imported into:

- `content-draft/viet/city-library/handwritten-copy/danang.json`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `content-draft/viet/city-library/handwritten-copy/hcmc.json`
- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `content-draft/viet/city-library/handwritten-copy/hue.json`

## Required Proof

- All 20 chunk files present.
- Full validator strict pass: `entries=500`, `errors=0`, `warnings=0`.
- Independent integrity review complete and passing.
- Visible process-language blockers repaired after independent review.
- Phrase/audio references catalog-gated and ready-audio-only.
- ChatGPT/worker output was not trusted directly; Codex validator, independent review, and targeted blocker repair decided promotion.
- Source import completed into `content-draft/viet/city-library/handwritten-copy/{danang,hanoi,hcmc,hoian,hue}.json`.
- Native city copy import completed from handwritten source.
- Runtime resources regenerated from source, including the authored listing pages JSON and Viet SQLite fixture.

## Final Validation

Passed on 2026-05-26:

- `node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/validate-humanizer-chunks.js --strict`
- `node scripts/guard-native-only.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `git diff --check`

Final counts:

- City production copy: `5` hubs, `500` city noun pages, `500` unique target heroes.
- City library: `806` pages, `706` beginner, `95` intermediate, `5` advanced.
- SQLite: `1758` pages, `500` city places, `806` city phrase tags, `680` planned missing-audio rows, `0` release-blocking missing-audio rows.

## Final Repair Notes

Downstream validators caught and repaired the final drift after the first strict humanizer pass:

- `city-hcmc-place-lusine-thao-dien` needed `sourceMode: "expanded-detail"` because it has a playable `Useful Phrases` section.
- `city-hoian-place-banh-mi-phuong` needed a clearer restaurant/meal cue.
- `city-hoian-place-sa-huynh-culture-museum` and `city-hue-place-nine-dynastic-urns` had leftover `surface`/`row` wording.
- `city-hcmc-place-little-hanoi-egg-coffee` had `top` wording that tripped the city-library ranking/style gate.
- `city-hcmc-place-fine-arts-museum` and `city-hue-place-lien-hoa-vegetarian` had process-like phrasing caught by the SQLite banned-word scan.
- `city-hcmc-place-cafe-apartment-nguyen-hue` needed stronger cafe/table/counter texture in rendered copy.
- The SQLite fixture test was updated to match the runtime validator: phrase pages still require breakdown sections; handwritten city-v1 place articles use place-detail sections.

## Revoked Boundary

The previous production-ready claim is revoked. This gate proved data shape, import integrity, audio mapping, and banned-word checks; it did not prove rendered-phone usability or actual human editorial taste. Phone screenshot review on 2026-05-26 exposed unacceptable copy voice and top chrome overlap on `city-danang-place-da-nang-museum`.

Next gate requirement: no 500-listing production-ready claim until representative rendered phone/simulator review passes for copy voice, top chrome overlap, bottom chrome overlap, and section readability.
