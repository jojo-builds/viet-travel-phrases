# Independent Integrity Review - 500 City Listings

Date: 2026-05-26

Scope: 500 Viet city-library listing chunks in `humanizer-gate-500-2026-05-26`.

Status: PASS for current city-library humanized import.

This pass is not a migration to the future `speaklocal.place.app-detail.v2.2` source schema. It approves the current ship-facing city-library source shape after v2.2 voice cleanup, phrase/audio integrity checks, and blocker repair.

## Evidence

- `validate-humanizer-chunks.js --strict`: passed with `entries=500`, `errors=0`, `warnings=0`.
- All 20 chunk files exist across Da Nang, Hanoi, HCMC, Hoi An, and Hue.
- Page order, page IDs, section IDs/order, `sourceMode`, and existing `quick-say.phraseIDs` are preserved by the validator.
- Phrase cards are catalog-gated: every preserved `quick-say.phraseIDs` value resolves to ready bundled audio and is blocked if place/entity-specific.
- Independent read-only reviewers found visible process-language blockers after the first green validator pass; those blockers were patched and then added to the validator/grep sweep.
- Native/runtime gates passed after source import and regeneration: city-copy validator, city-library validator, SQLite validator, hero-image validator, practice deck check, native-only guard, fixture test, practice deck test, and `git diff --check`.

## Repaired Review Findings

- Removed visible process/database language such as `city set`, `restaurant page`, `stable reason`, `durable reason`, `source image`, `evidence is narrow`, `visit logistics`, `planning logistics`, `saved value`, and `reference points`.
- Replaced leftover non-playable quick-say name cards such as `Market Name`, `Station Name`, `Local Dish Name`, `Airport Name`, and `Local Temple Name`.
- Fixed AI-ish or broken phrasing called out by reviewers, including `with an stop area`, `It reference points`, and visible source/reviewer caveats.
- Repaired final downstream gate catches: playable phrase-card source mode, meal/cafe sensory texture, leftover `row`/`surface`, `works because it`, `key word`, and ranking-like `top` wording.

## Remaining Non-Blocking Risk

Most listings use non-playable quick-say prose instead of playable phrase cards because the current source shape preserves existing phrase IDs and blocks one-off phrase bloat. This is acceptable for the current city-library import. The future app-detail v2.2 migration should map phrase cards explicitly with `mapped`, `close_match`, `new_phrase_needed`, or `hide_until_audio` statuses.
