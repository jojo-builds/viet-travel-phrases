# Viet Canonical Content Audit 001 Repair Ledger

Task: `TASK-VIET-CANONICAL-CONTENT-AUDIT-001`

## Safe Repairs Completed

- Removed the legacy `answers the traveler question...` article pattern from the Tier 1/catalog page generator and regenerated source/resources.
- Added explicit `When to use it` and `Good to know` sections to the Xin chào flagship source and generator-backed flagship page.
- Restored concrete `Explore next` sections across the canonical SQLite graph by converting catalog-built `Nearby phrases` shelves into canonical `Explore next` shelves and adding non-duplicate fallback links when authored Explore rows had already been taught earlier on the same page.
- Replaced the awkward `main thing you need understood` wording in phrase/practice source with clearer listener-facing copy, without changing Vietnamese phrase text or canonical IDs.
- Added `native-ios/scripts/audit-viet-canonical-content.js` to produce a full per-page audit JSONL, CSV, issue summary, and Jojo-review queue.
- Strengthened generated-resource checks so `answers the traveler question` is treated as banned user-facing wording.

## Before / After Examples

### Legacy At a glance wording

Before:

> Nhập cảnh ở đâu? answers the traveler question "Where is immigration" in arrival, immigration, baggage, SIM cards, pickup, and airport services.

After:

> For travelers, Nhập cảnh ở đâu? is the phrase to keep ready for "Where is immigration" in arrival, immigration, baggage, SIM cards, pickup, and airport services.

### Legacy standard-way wording

Before:

> Start with Nhập cảnh ở đâu? when "Where is immigration" is the main thing you need understood.

After:

> Start with Nhập cảnh ở đâu? for "Where is immigration" when you need the listener to catch the point quickly.

### Flagship page contract

`Xin chào` now keeps the existing flagship greeting lesson and also carries explicit `When to use it` and `Good to know` sections so the page satisfies the same canonical article contract as the rest of the database.

## Remaining Authored Content Work

- `1,350` practice-expansion pages still need real page-level authored copy repair. The audit flags the repeated practice-source language such as `short practice phrase`, `keeps the sentence direct`, and `built for quick recognition`; these should not be mass-replaced by another template.
- `744` catalog-built pages now have complete runtime sections and links, but still need durable authored source records before they can be called fully human-authored pages.
- `241` practice-expansion pages need breakdown-label review, mostly for generic labels such as `question ending`.

## Evidence Artifacts

- `per-page-audit.jsonl`
- `per-page-audit.csv`
- `issue-summary.json`
- `jojo-review-queue.csv`
