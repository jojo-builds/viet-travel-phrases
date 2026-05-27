# SpeakLocal City Pages Humanizer Gate - 500 Listings

Date: 2026-05-26

Goal: finish all 500 Viet city-library listing pages as v2.2-aligned, humanized app copy for the current city-library runtime.

Scope:

- Da Nang `001-100`
- Hanoi `001-100`
- Ho Chi Minh City `001-100`
- Hoi An `001-100`
- Hue `001-100`

## Final State

Status: BLOCKED after phone review on 2026-05-26. The previous PASS is revoked.

All 500 listings passed the strict humanizer gate, independent integrity review, source import, native city-copy import, runtime regeneration, native/content validators, SQLite validation, focused Node tests, and `git diff --check`.

That proof is import integrity only. It did not catch rendered-phone usability or actual human voice quality.

Final receipt: `reports/humanizer_gate_500_final_review_2026-05-26.md`

Progress log and validator history: `reports/production_ready_500_progress_2026-05-26.md`

Boundary: this is not production-ready. Phone screenshot review of `city-danang-place-da-nang-museum` exposed unacceptable copy voice and top chrome overlap.

## ChatGPT Role

Use the ChatGPT Project `SpeakLocal City Pages v2.2 Copy` for bulk humanizer writing when possible. For this phase, ChatGPT is repairing existing city-library copy, not inventing net-new city pages from scratch.

Recommended scale for this repair pass:

- Net-new or broad humanizer drafts may use 25-listing JSON chunks.
- Voice-cleanup repair prompts should use five targeted listings or fewer.
- Launch only a small wave of cleanup chats at once, then merge one output at a time.
- If two outputs from the same chunk roll back, stop and reprompt one or two entries with tighter source/context instead of continuing stale chunk-level prompts.

ChatGPT output is not production-ready by itself. It must return valid chunk JSON and a short self-gate report. Codex then validates, imports, regenerates, and writes the final receipt.

## Production Roles

Each chunk must pass three roles before import:

1. Humanizer writer
   - rewrites a bounded chunk into the existing city-library source shape
   - preserves page ID, page order, field names, section IDs, stable specifics, and quick-say phrase IDs
   - removes mechanical command headings, app-internal labels, schema/process language, and generic filler
   - avoids unstable hours, prices, current menus, access rules, schedules, and closure claims

2. Writer self-gate
   - catches repeated heading scaffolds inside the chunk
   - checks phrase cards are reusable ready-audio cards, not one-off app bloat
   - marks thin-source pages as careful/blocked instead of padding them with generic props
   - confirms no Reader View or process labels leak into visible copy

3. Independent integrity reviewer
   - checks the writer did not delete substance to make the page sound cleaner
   - checks every page still carries a concrete traveler moment
   - checks quick-say phrase IDs and required sections are preserved
   - rejects visible copy with database/schema/process language

## Hard Floor

`validate-humanizer-chunks.js` is the mechanical floor. It does not approve taste by itself. It blocks import when:

- a chunk is missing
- a page is missing or out of order
- required city-library sections are missing
- source sections are dropped
- phrase IDs changed from source
- visible copy contains known internal/AI wording
- visible copy contains old `best/works best/reads best` drift
- visible body copy turns QA/freshness uncertainty into app prose, such as prices, menus, access, routes, or details that "can change"
- visible copy contains repeated old scaffolds such as `Worth it if`, `What you'll get`, or `Before you go`
- section bodies are duplicated or too thin
- paragraphs exceed the mobile-copy limit

The script also emits voice warnings for repeated chunk-level taste drift. Treat these as production blockers unless a reviewer records why the risk is acceptable:

- repeated heading patterns across one 25-page chunk
- non-playable `quick-say` sections turning into repeated name cards
- freshness/current/checking language appearing in visible headings
- lowercase or malformed headings such as `good for A...`

## Promotion Rule

Do not call the 500 listings production-ready until:

- all 20 chunk files exist
- all 20 writer self-gate reports exist
- independent integrity review is complete
- `validate-humanizer-chunks.js` passes with `entries=500`, `errors=0`, and `warnings=0`
- chunks are imported into `content-draft/viet/city-library/handwritten-copy/{danang,hanoi,hcmc,hoian,hue}.json`
- city-library/runtime resources are regenerated
- native/content validators pass
- final receipt records page count, changed source files, reviewer status, and remaining risks

This rule was incomplete. Add rendered phone/simulator review before production-ready status can be restored.

## Lessons Folded In

- Do not create one-off phrase cards just because a place name exists.
- `Useful Phrases` is reserved for sections with ready-audio phrase IDs.
- If no reusable phrase IDs fit, the `quick-say` section must use a natural title and prose body.
- Keep v2.2 as source of truth; the ChatGPT Project is a writing harness.
- Do not let self-score become approval. Self-score is only a revision loop.
- Do not add broad new style rules after one weak page. Add a gate check only for repeated drift.
- For the remaining 300, the repeated drift is known: `best/works best`, process language, command headings, repeated old section headings, and generic filler props.
- ChatGPT writes stronger prose than Codex for this surface, but ChatGPT self-gates miss literal drift. Codex owns the hard verifier and import integrity.
- A validator pass is not a taste pass. Repeated safe headings, name-card quick-say sections, and freshness notes in visible copy still make the app feel database-like.
- Freshness and uncertainty belong in self-gates or reviewer notes. Visible copy should either omit unstable specifics or describe the stable role of the place.
- Import is strict-only. `import-humanized-chunks.js` now runs `validate-humanizer-chunks.js --strict` before writing source files, so warning-bearing chunks cannot be promoted by accident.
- Targeted ChatGPT cleanup output must self-gate to `pass`, list no remaining risks, and include every targeted replacement entry. Codex rejects partial or risk-bearing handoffs before they can modify chunk files.
- Cleanup merge is target-aware: the returned pageIDs must exactly match the manifest pageIDs for that session, not merely the expected count.
- `safe-merge-voice-cleanup-output.js` is the only merge path for ChatGPT cleanup output. It snapshots chunks, runs the merge, validates, keeps only strict count/warning improvement, and rolls back plus quarantines rejected outputs on any regression.
- After copying a ChatGPT fenced JSON cleanup response, use `capture-voice-cleanup-output.js --from-clipboard` to save it and run the safe merge in one audited step.
- Phrase cards are catalog-gated. Any `quick-say.phraseIDs` must resolve to reusable ready-audio phrases in the native phrase catalog and bundled audio manifest; place/entity-specific one-off phrase IDs are blocked.
- Downstream gates matter even after the chunk validator passes. The final promotion also runs the native city-copy validator, city-library validator, SQLite validator, hero-image validator, practice deck check, fixture test, practice deck test, and `git diff --check`.
- Add newly discovered literal drift to the mechanical gate. This pass added catches for `works because it`, `key word`, and `creamy top` after downstream validators exposed them.
- City-v1 place articles are allowed to use place-detail sections without phrase breakdowns; phrase pages still require breakdown sections. Tests and validators now share that contract.
