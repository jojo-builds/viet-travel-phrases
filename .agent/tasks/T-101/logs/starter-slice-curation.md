# T-101 starter-slice curation log

## Summary

- Confirmed the Japanese lane has `0` raw `needs-translation` rows and shifted the unresolved tail into explicit starter-slice buckets instead of one fuzzy post-translation backlog.
- Defined a service-first starter-slice recommendation centered on opener/repair, station and taxi navigation, hotel arrival, convenience-store checkout, and bounded shopping.
- Kept `japanese-simple-problems-6` outside the starter slice because the medical row still requires expert review.

## Tail dispositions

- `later-review`: `japanese-asking-price-2`, `japanese-asking-price-3`, `japanese-small-talk-3`, `japanese-small-talk-5`
- `deferred-after-starter-slice`: `japanese-small-talk-1`, `japanese-small-talk-2`, `japanese-small-talk-4`, `japanese-small-talk-6`
- `deferred-rewrite-needed`: `japanese-street-food-4`, `japanese-grab-taxi-2`, `japanese-asking-price-5`
- `deferred-lower-priority`: `japanese-small-talk-7`

## Starter-slice recommendation

- opener and repair anchor: `japanese-polite-basics-5`, `japanese-polite-basics-2`, `japanese-simple-problems-2`, `japanese-simple-problems-3`
- navigation and show-screen anchor: `japanese-grab-taxi-1`, `japanese-grab-taxi-3`, `japanese-directions-1`, `japanese-directions-2`, `japanese-directions-3`
- arrival and checkout anchor: `japanese-hotel-hostel-1`, `japanese-hotel-hostel-2`, `japanese-hotel-hostel-7`, `japanese-convenience-store-1`, `japanese-convenience-store-2`, `japanese-convenience-store-6`, `japanese-convenience-store-7`
- shopping anchor: `japanese-asking-price-1`, `japanese-asking-price-4`, `japanese-asking-price-6`

## Validation notes

- `content-draft/japanese/phrase-source.csv` parses cleanly with status counts: `21` `first-wave-promoted-core`, `35` `drafted`, `4` `later-review`, `4` `deferred-after-starter-slice`, `3` `deferred-rewrite-needed`, `1` `deferred-lower-priority`, `1` `first-wave-flagged-holdout`, `1` `rewritten-and-drafted`
- `content-draft/japanese/first-wave-priority.csv` parses cleanly with execution-state counts: `33` `drafted-in-phrase-source`, `4` `later-review-after-starter-slice`, `4` `deferred-after-starter-slice`, `3` `deferred-rewrite-needed`, `1` `deferred-lower-priority`, `2` `rewritten-and-drafted`
