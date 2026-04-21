# Japan Graduation Packet

## Scope

- Convert the post-`T-101` Japan starter-slice and deferred-tail story into one compact graduation-boundary packet.
- Keep the lane prep-only and avoid reopening a broad translation batch.

## Closure snapshot

- Promoted set: `34` rows
- Later-only set: `4` rows
- Native-review-only set: `1` row
- Rewrite-needed set: `3` rows
- Retire set: `5` rows

## Residual packet

### Later-only

- `japanese-asking-price-2`
- `japanese-asking-price-3`
- `japanese-small-talk-3`
- `japanese-small-talk-5`

Reason:
- Keep these rows visible as drafted reference coverage, but do not let them outrank the service-first promoted set.

### Native-review-only

- `japanese-simple-problems-6`

Reason:
- Medical wording remains too high-risk to promote without expert review.

### Rewrite-needed

- `japanese-street-food-4`
- `japanese-grab-taxi-2`
- `japanese-asking-price-5`

Reason:
- These rows still point at weak Japan-first intents and should not be translated or promoted again until the English source text is rewritten.

### Retire

- `japanese-small-talk-1`
- `japanese-small-talk-2`
- `japanese-small-talk-4`
- `japanese-small-talk-6`
- `japanese-small-talk-7`

Reason:
- The retired set is social filler that does not justify live graduation debt for the current Japan lane.

## Retrieval rule

- Future planning should treat the promoted `34` rows as the effective Japan prep handoff.
- Future planning should treat the `13` residual rows as intentionally unpromoted, not as general translation debt.
- Use this file and `content-draft/japanese/source-notes.md` instead of reopening `T-101`.

## Guardrails

- Do not promote the medical row without expert review.
- Do not reopen the rewrite-needed trio until a stronger Japan-fit English source exists.
- Do not treat later-only rows as starter debt.
- Do not reopen the retired social rows unless product explicitly asks for a hospitality expansion.
