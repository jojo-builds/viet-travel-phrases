# T-009 Implementation Plan

## Goal

Leave the Tagalog shortlist in a state where the next content pass can start from a clean authoring core instead of re-deciding which rows are usable.

## Settled draft posture for this task

### Register

- Keep only neutral or clearly useful polite forms in the promoted core.
- `Opo` stays in the core only as a respectful yes / acknowledgment with a usage note.
- Rows that still depend on unresolved `po` / `ninyo` / indirect-request choices do not enter the promoted core in this pass.

### Loanwords

- A locally common borrowed term can stay only when it improves traveler recognition and does not force another broad wording decision.
- Reservation, check-in, card, cash, and call-for-me wording remain outside the promoted core in this pass because they still need a normalize-or-review decision.
- Any row with an unresolved loanword or pronunciation note stays outside the promoted core in this pass.
- `Aircon` may stay only in a flagged holdout row when the note says the borrowing is intentional and still needs expert review.

### Pronunciation

- Pronunciation remains helper-only draft truth.
- Touched core rows may get light cleanup for obvious consistency, but this task does not freeze a final romanization contract.
- Rows with mixed-English pronunciation uncertainty stay flagged and out of the promoted core.

## Planned row outcomes for the current top 24

| Rank | Phrase ID | Planned outcome | Why |
| --- | --- | --- | --- |
| 1 | `tagalog-polite-basics-5` | `promoted-core` | High-value neutral opener; keep as apology / attention-getter with a clearer usage note. |
| 2 | `tagalog-polite-basics-2` | `promoted-core` | Clean courtesy anchor with low wording risk. |
| 3 | `tagalog-asking-price-1` | `promoted-core` | Strong high-frequency purchase baseline. |
| 4 | `tagalog-grab-taxi-1` | `promoted-core` | Clear show-screen transport control phrase. |
| 5 | `tagalog-simple-problems-2` | `promoted-core` | Core repair phrase with low ambiguity. |
| 6 | `tagalog-simple-problems-3` | `promoted-core` | Companion repair phrase that strengthens the rescue layer. |
| 7 | `tagalog-hotel-hostel-1` | `keep-flagged-review-needed` | Useful, but `reservation` remains a loanword decision instead of settled core wording. |
| 8 | `tagalog-hotel-hostel-2` | `keep-flagged-review-needed` | Mixed English `check in` wording still needs a normalize-or-review pass. |
| 9 | `tagalog-convenience-store-1` | `promoted-core` | Simple retail win with low phrasing risk. |
| 10 | `tagalog-street-food-3` | `promoted-core` | Strong first-wave food comfort phrase; keep flagged for food review only. |
| 11 | `tagalog-grab-taxi-3` | `promoted-core` | High-utility drop-off control phrase. |
| 12 | `tagalog-convenience-store-6` | `keep-flagged-review-needed` | Card wording is useful but still needs a settled loanword posture. |
| 13 | `tagalog-hotel-hostel-5` | `keep-flagged-review-needed` | High-pain hotel phrase, but the `aircon` borrowing remains an intentional holdout until loanword posture is settled. |
| 14 | `tagalog-simple-problems-6` | `promoted-core` | Safety-critical phrase that belongs in the core with a medical-review warning. |
| 15 | `tagalog-street-food-7` | `promoted-core` | Strong takeaway request with good traveler value. |
| 16 | `tagalog-asking-price-7` | `promoted-core` | Clean purchase-closure phrase. |
| 17 | `tagalog-asking-price-6` | `promoted-core` | Useful comparison-shopping phrase with manageable risk. |
| 18 | `tagalog-directions-2` | `promoted-core` | Compact navigation repair phrase with low localization risk. |
| 19 | `tagalog-directions-3` | `promoted-core` | Useful walking-vs-riding decision phrase. |
| 20 | `tagalog-simple-problems-7` | `keep-flagged-review-needed` | High-value escalation phrase, but pronoun and register choices still need review. |
| 21 | `tagalog-polite-basics-3` | `promoted-core` | Keep as a respectful acknowledgment with a tighter usage note. |
| 22 | `tagalog-polite-basics-4` | `deferred-rewrite-needed` | Current refusal wording is too weak to promote; rewrite and demote. |
| 23 | `tagalog-grab-taxi-7` | `keep-flagged-review-needed` | Cash wording is useful but remains a loanword / payment-normalization holdout. |
| 24 | `tagalog-directions-1` | `deferred-rewrite-needed` | Localized destination proof only; demote out of the generic baseline core. |

## Execution consequences

- All 24 rows will be touched through explicit improve / flag / defer decisions.
- The promoted core for the next pass will be the 16 rows marked `promoted-core`.
- The 6 `keep-flagged-review-needed` rows remain visible in the shortlist but outside the clean promoted core.
- The 2 `deferred-rewrite-needed` rows are demoted and rewritten as holdouts instead of riding forward as false-ready lines.

## File updates this plan expects

- `content-draft/tagalog/phrase-source.csv`
  - stronger wording and notes for the 24 reviewed rows
  - explicit draft posture notes on flagged rows
- `content-draft/tagalog/first-wave-priority.csv`
  - current status and review flags updated to match `promoted-core`, `keep-flagged-review-needed`, or `deferred-rewrite-needed`
- `content-draft/tagalog/source-notes.md`
  - settled draft posture for register, loanwords, and pronunciation
- `content-draft/tagalog/research-backlog.md`
  - next pass starts from the 16-row promoted core, then returns to the 6 flagged holdouts
- `content-draft/tagalog/risk-review.md`
  - risk language aligned to the clean core vs holdout split
