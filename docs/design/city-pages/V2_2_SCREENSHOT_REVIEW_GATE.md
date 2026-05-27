# SpeakLocal v2.2 Screenshot Review Gate

Status: thin review gate for rendered v2.2 city/place app-detail pages

Use this after a page has a complete `speaklocal.place.app-detail.v2.2` source object and fresh rendered screenshots. This gate is not a rewrite prompt and not a new style system. It decides whether the rendered page proves the app-detail contract and still feels like SpeakLocal.

This is a screenshot/render gate, not the full production gate. Final production readiness is decided by `V2_2_PRODUCTION_REVIEW_GATE.md`, which also checks provenance, evidence, phrase/audio, catalog mapping, freshness, and independent review.

## Decision Options

- `PASS`: contract is clean, copy feels SpeakLocal, only freshness/native QA remains.
- `REVISE`: page is close but needs specific fixes.
- `FAIL`: page does not prove the v2.2 contract or feels like old/generic listing copy.

## Mechanical Contract Check

- Useful Phrases appear immediately after intro.
- Useful Phrases are playable phrase cards, not prose.
- No duplicate body text or duplicate sections.
- Mentioned Here cards render when useful `render` candidates exist.
- Related Places cards render when useful `render` candidates exist.
- Visible card subtitles are user-facing `displaySubtitle`, not internal `reason`.
- Bottom chrome and sticky audio controls do not hide content.
- Long phrase rows wrap cleanly.
- Phrase/audio status is known.
- Natural catalog mentions are evaluated, not silently ignored.

## SpeakLocal Voice Check

- The page appears to start from one observed traveler moment, not from the schema.
- The first heading reveals the role of the place.
- The copy is specific enough that it could not fit many similar places.
- The page teaches a decision, behavior, or expectation.
- The tone is honest without becoming cynical.
- The page gives at least one reason the place is still worth doing.
- Mentioned Here and Related links feel natural, not forced.
- Phrases are task-tied to this place.

## Voice Drift Rule

Traveler-use cue does not mean command language. Headings and first sentences should reveal the role of the place in natural English, not sound like software instructions.

Avoid overusing:

- Use it for...
- Buy the...
- The trip needs...
- Trip fixes...
- Heat-and-rain basics...

Prefer natural traveler briefing language:

- The easy indoor reset
- Good before the taxi
- Hàn for texture, Lotte for ease
- Start with one local dish
- More theme park than viewpoint
- A quieter stop on Sơn Trà

The test: would a well-traveled friend actually say this sentence out loud? If not, revise.

## Final Production Review

After source, regenerated native resources, tests, and native screenshots exist, run one read-only pass. Classify each page as `PASS`, `REVISE`, or `FAIL` for native render contract, SpeakLocal voice, factual freshness, phrase/audio fit, and card/link correctness. Any `REVISE` or `FAIL` starts a focused fix-and-recapture cycle before the page is called production-ready.

## Reviewer Output

```text
Decision:
Score:
Contract notes:
Voice notes:
Top fixes:
Do not change:
Production blockers:
```

Do not create new listings. Do not generate bulk copy. Do not rewrite the whole page unless the decision is `FAIL`. Do not add new abstract rules; improve by comparison to the best examples.
