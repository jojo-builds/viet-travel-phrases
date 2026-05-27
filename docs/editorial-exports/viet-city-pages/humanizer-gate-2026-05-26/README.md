# SpeakLocal City Pages Humanizer Gate - 200 Listings

Date: 2026-05-26

Goal: promote 200 city-library listings to production-candidate copy without Jojo reading every page manually.

Scope:

- Da Nang `001-100`
- Hanoi `001-100`

## Gate Shape

Each page must pass two roles before import:

1. Humanizer writer
   - rewrites one bounded chunk into city-library source shape
   - preserves page ID, place role, stable specifics, and quick-say phrase IDs
   - removes mechanical command headings, app-internal labels, and generic filler
   - avoids unstable hours, prices, current menus, access rules, schedules, and closure claims

2. Integrity reviewer
   - checks that the writer did not delete substance to make the page sound cleaner
   - checks that the page still carries a concrete traveler moment
   - checks that quick-say phrase IDs and required sections are preserved
   - rejects visible copy with database/schema/process language

## Hard Floor

`validate-humanizer-chunks.js` is the mechanical floor. It does not approve taste by itself. It blocks import when:

- a chunk is missing
- a page is missing or out of order
- required city-library sections are missing
- phrase IDs changed from source
- visible copy contains known internal/AI wording
- section bodies are duplicated or too thin
- paragraph length exceeds the mobile-copy limit

## Promotion Rule

This earlier 200-listing gate is now import-candidate evidence only. Do not call the 200 listings production-ready until:

- all 8 chunk files exist
- all 8 humanizer reports exist
- independent integrity review is complete
- `validate-humanizer-chunks.js` passes
- chunks are imported into `content-draft/viet/city-library/handwritten-copy/{danang,hanoi}.json`
- city-library/runtime resources are regenerated
- native/content validators pass
- representative rendered phone/simulator pages pass voice, section readability, and chrome-overlap review
- final receipt records page count, changed source files, reviewer status, and remaining risks

2026-05-26 note: a later 500-listing pass included this batch and failed rendered phone review. Treat this folder as process/import evidence, not production-ready approval.
