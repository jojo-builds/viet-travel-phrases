# T-080 Translation Pack Audit

## Scope

- Task: Indonesian second translation pack and unresolved-row reduction
- Write scope used: `content-draft/indonesian/**` and `.agent/tasks/T-080/**`
- Prep-only boundary preserved

## Rows translated in this pass

- `indonesian-coffee-shop-5`
- `indonesian-street-food-6`
- `indonesian-street-food-7`
- `indonesian-grab-taxi-2`
- `indonesian-grab-taxi-4`
- `indonesian-grab-taxi-5`
- `indonesian-grab-taxi-6`
- `indonesian-grab-taxi-7`
- `indonesian-grab-taxi-9`
- `indonesian-asking-price-2`
- `indonesian-asking-price-5`
- `indonesian-asking-price-6`
- `indonesian-asking-price-7`
- `indonesian-polite-basics-1`
- `indonesian-polite-basics-3`
- `indonesian-polite-basics-6`
- `indonesian-polite-basics-7`
- `indonesian-convenience-store-2`
- `indonesian-convenience-store-3`
- `indonesian-convenience-store-5`
- `indonesian-convenience-store-7`
- `indonesian-hotel-hostel-4`
- `indonesian-hotel-hostel-5`
- `indonesian-hotel-hostel-6`
- `indonesian-hotel-hostel-7`
- `indonesian-directions-3`
- `indonesian-simple-problems-4`
- `indonesian-simple-problems-5`
- `indonesian-simple-problems-7`

## Durable file changes expected from this pass

- `content-draft/indonesian/phrase-source.csv`
  - added target text, pronunciation, notes, and `second-pack-translated` status across 29 rows
- `content-draft/indonesian/first-wave-priority.csv`
  - extended ranked outcomes from 30 rows to 59 rows
- `content-draft/indonesian/README.md`
  - updated lane summary and next-step posture after the second pack
- `content-draft/indonesian/source-notes.md`
  - recorded the second translation-pack decisions and remaining holdouts
- `content-draft/indonesian/research-backlog.md`
  - marked the high-value second-pass cluster complete and shifted remaining backlog to lower-fit holdouts plus audio/search work

## Remaining visible holdouts after this pass

- weak coffee baseline rows: `indonesian-coffee-shop-1` through `indonesian-coffee-shop-4`
- lower-fit food or shopping rows: `indonesian-street-food-4`, `indonesian-asking-price-3`, `indonesian-asking-price-4`
- generic or lower-priority directions rows: `indonesian-directions-1`, `indonesian-directions-4` through `indonesian-directions-8`
- lower-priority store row: `indonesian-convenience-store-4`
- small-talk set: `indonesian-small-talk-1` through `indonesian-small-talk-7`
- sensitive medical holdout: `indonesian-simple-problems-6`

## Review posture preserved

- keep `permisi` versus `maaf` review-visible
- keep payment wording review-visible around card cash and QR flows
- keep food and medical risk posture honest
- keep unresolved rewrite-only rows explicit instead of pretending the lane is complete
