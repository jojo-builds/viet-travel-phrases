# Viet Canonical Content Audit 001 Repair Ledger

Task: `TASK-VIET-CANONICAL-CONTENT-AUDIT-001`

## Safe Repairs Completed

- Removed a legacy meta-description article pattern from the Tier 1/catalog page generator and regenerated source/resources.
- Added explicit `When to use it` and `Good to know` sections to the Xin chào flagship source and generator-backed flagship page.
- Restored concrete `Explore next` sections across the canonical SQLite graph by converting catalog-built `Nearby phrases` shelves into canonical `Explore next` shelves and adding non-duplicate fallback links when authored Explore rows had already been taught earlier on the same page.
- Replaced awkward listener-goal wording in phrase/practice source with clearer traveler-facing copy, without changing Vietnamese phrase text or canonical IDs.
- Added `native-ios/scripts/audit-viet-canonical-content.js` to produce a full per-page audit JSONL, CSV, issue summary, and Jojo-review queue.
- Strengthened generated-resource checks so meta-description wording is treated as banned user-facing copy.

## Before / After Examples

### Legacy At a glance wording

Before: the page described the internal article formula instead of teaching the travel moment.

After:

> For travelers, Nhập cảnh ở đâu? is the phrase to keep ready for "Where is immigration" in arrival, immigration, baggage, SIM cards, pickup, and airport services.

### Legacy standard-way wording

Before: the page used awkward internal wording to describe the listener goal.

After:

> Use Nhập cảnh ở đâu? as your first sentence for "Where is immigration."

### Flagship page contract

`Xin chào` now keeps the existing flagship greeting lesson and also carries explicit `When to use it` and `Good to know` sections so the page satisfies the same canonical article contract as the rest of the database.

## Final Repair Pass

- Rewrote the `1,350` practice-expansion source pages so each page now teaches a phrase-specific travel moment, likely response shape, and next phrase path.
- Promoted the `744` catalog-built pages into durable full-universe authored source records with rationale entries.
- Repaired all `241` weak breakdown-label cases.
- Preserved canonical page IDs and regenerated the native authored resource and SQLite graph from source.

## Reviewer-Gate Repair Pass

- Removed remaining template markers from the `744` full-universe pages, including generic handling/setup language and vague show-the-object instructions.
- Replaced vague full-universe breakdown glosses with traveler-facing labels tied to request shape, place, item, action, time, confirmation, or the exact reusable Vietnamese cue.
- Repaired malformed practice-expansion response copy so likely replies read as real travel answers instead of pasted prompt fragments.
- Rewrote repetitive shopping/practical-item setup copy so pages reference the actual counter, shelf, menu, map, booking, route, or service moment instead of a generic object formula.
- Strengthened the canonical audit and SQLite validator so these reviewer-found patterns fail future checks.

## Final Reviewer-Gate Repair Pass

- Repaired Tier 1 generator wording that reused generic document/problem/place, proof/photo/map, and broken-item response patterns across unrelated pages.
- Split shared problem/report teaching into more specific booking, document, emergency, lost-item, baggage, phone/map, hotel-room, movement-limit, and health flows.
- Fixed the `Hãy` breakdown gloss so the exact accented token resolves to `please / soft command`, not the unaccented `hay` meaning `or`.
- Replaced vague fallback breakdown labels with beginner-facing glosses.
- Added the reviewer-found patterns and weak labels to hard validator checks across the canonical audit, SQLite validator, and page-quality audit.

## Evidence Artifacts

- `per-page-audit.jsonl`
- `per-page-audit.csv`
- `issue-summary.json`
- `jojo-review-queue.csv`
