# SpeakLocal v2.2 Production Review Gate

Status: reusable `PASS` / `REVISE` / `FAIL` gate for any rendered `speaklocal.place.app-detail.v2.2` city/place page.

Use this after source copy, catalog/audio mapping, generated runtime resources, focused tests, and fresh screenshots exist. This is a review gate, not a writing prompt, bulk generator, template expansion system, or rewrite layer.

Current authority note: production approval starts from first-class `speaklocal.place.app-detail.v2.2` source objects. Legacy city-library fields, generated runtime files, SQLite rows, screenshots, validators, and 500-page story-pass receipts can support review, but they are projection or evidence only. They are not approval authority without a v2.2 source-object gate.

## 5 Whys Root Cause

Symptom: a v2.2 page can pass the source/render contract but still drift into command-like, schema-shaped copy such as `Use It For...`, `Use The Street As...`, or `Trip fixes`.

1. Why did the output drift?
   - The model treated "traveler-use cue" as an imperative/function heading instead of a natural first-screen briefing.

2. Why was that interpretation attractive?
   - The prompt asked for app-detail fields, scores, QA notes, statuses, `displaySubtitle`, `reason`, and verification flags in one pass, so structure pulled attention away from voice.

3. Why did structure bleed into visible copy?
   - Schema and review vocabulary sat beside the prose fields, making the writer think in labels before thinking in one observed traveler moment.

4. Why did examples not fully prevent it?
   - The strongest anchors were named, but the output scaffold was more concrete than the taste instruction. A fresh agent may imitate the scaffold before the examples.

5. Why can it repeat?
   - Legacy city-library fields, V2/V2.1 examples, and runtime projection files still exist. Without a reusable production gate, a fresh session can mistake mechanical compliance for production-ready copy.

Root cause: the process let app-detail structure become the writer's mental model. v2.2 needs the opposite order: evidence, one traveler moment, one truthful story spine, natural first-screen voice, then app-detail fields.

2026-05-27 addition: utility alone is not enough. A production-ready city/place listing also needs a story spine: the small truthful reason this place belongs to Vietnam, this city, this neighborhood, this food habit, this route, this river/street/market pattern, or this cultural memory. Do not add a literal "Story" section by default. Weave the story into the intro or one early module.

## Required Evidence

- Page scope: page ID, city, visible title, source file, generated runtime file, reviewer date, worktree/branch, and commit if available.
- Guidance read: `CURRENT_CITY_PAGE_STANDARD.md`, v2.2 playbook, canonical examples, generation prompt, implementation audit prompt, and screenshot gate.
- Authoring proof: closest canonical anchor, page-specific difference from that anchor, the one traveler moment the page owns, and the truthful story spine the page carries.
- Voice adequacy proof: scene proof, why-here proof, and first-move proof from visible copy, with no database/process/schema wording leaking into the reader experience.
- Source proof: intro, phrase cards, two to four sections, Mentioned Here candidates, related candidates, verification flags, QA notes, and strict score.
- Phrase/audio proof: every rendered phrase has `phraseId`, `audioId`, and `status`; unsupported phrases are hidden or marked `new_phrase_needed`.
- Card/link proof: every rendered Mentioned Here / Related card links to a real openable target, has a user-facing subtitle, and does not render internal `reason`.
- Freshness proof: sources checked for visible factual claims, especially hours, prices, access, payment, transport, tickets, closures, venue operations, pickup points, and schedules.
- Native proof: exact validation/test commands, result counts, screenshot folder, plus top and scrolled screenshot proof for each page.
- Reviewer proof: per-page `PASS` / `REVISE` / `FAIL` table for native render contract, SpeakLocal voice, factual freshness, phrase/audio fit, and card/link correctness.

## Hard Blockers

Classify as `FAIL` when:

- The page is not a v2.2 app-detail page or still uses city-v1/mobile-expanded prose as approval truth.
- The page only has legacy city-library/runtime projection and no first-class v2.2 app-detail source object to approve.
- The writer cannot name the closest canonical anchor, the page-specific difference, and the one owned traveler moment.
- The page has clean utility copy but no story spine tying it to the city, culture, food habit, route, place history, or observed local use.
- The visible copy cannot prove scene, why-here, and first-move in a story-rich human voice.
- Useful Phrases render as prose, lack playable cards, or render unsupported Vietnamese/audio as production copy.
- Intro/body/sections duplicate each other.
- Rendered output drops required phrase cards, Mentioned Here cards, or related cards that source marked `render`.
- Internal QA fields such as `reason`, `check_catalog`, source notes, or relation labels appear in visible UI.
- Cards link to missing, non-openable, wrong-city, wrong-place, or generic fallback targets.
- Bottom chrome or sticky audio controls hide content.
- Visible copy makes unsupported unstable claims about hours, price, payment, ticketing, access, pickup points, closures, or rules.
- The first screen sounds generic, command-like, cynical, or replaceable after one focused revise cycle.
- Required screenshots, test results, or source/runtime provenance are missing.

Classify as `REVISE` when:

- The contract mostly renders, but specific copy, card, freshness, wrapping, subtitle, phrase, or link fixes are needed.
- The page has valid modules but the voice still feels like schema labels instead of an observed traveler moment.
- Freshness is not fatal because risky details are omitted, but the reviewer cannot confirm enough to promote.

Classify as `PASS` only when:

- Native render contract, SpeakLocal voice, factual freshness, phrase/audio fit, and card/link correctness all pass.
- The reviewer can point to exact source/runtime files, exact test results, and fresh screenshots.
- Any unresolved candidates remain internal and do not render.
- The page can lose pilot or `do_not_publish` status language.

## Production Review Table

| Gate | PASS means | REVISE means | FAIL means |
|---|---|---|---|
| Process provenance | Current v2.2 read order, closest anchor, page-specific difference, and owned traveler moment are recorded | One item is thin but recoverable | Writer started from legacy prompts or cannot name the page-specific moment |
| Story spine | The page carries a truthful local/cultural/place story in the intro or an early section | Story is present but too generic, so one focused sentence needs sharpening | Utility-only copy with no reason this place belongs here |
| Voice adequacy | Visible copy proves scene, why-here, and first-move in a story-rich human voice with no database/process wording | One proof is thin or one sentence sounds internal | Reads like a database row, process note, QA receipt, or schema checklist |
| Evidence | Specific facts, place behavior, and freshness risks are known enough for the copy length | Evidence is thin, so copy must shrink or flags must be stronger | Claims exceed evidence or source status is blocking |
| Voice | First screen sounds natural, specific, adult, and useful | Mostly good, but one heading/body sounds command-like or generic | Reads like schema, tourism copy, or interchangeable AI prose |
| Source object | All required v2.2 fields exist with two to four sections and strict score | Small field or note omissions | Missing required fields or legacy-only source |
| Phrase/audio | Phrase cards fit the place and have usable audio status | One phrase needs close-match or native-speaker QA | Unsupported Vietnamese is rendered or phrase cards are prose |
| Catalog links | Natural mentions and route/comparison links are evaluated; only valid targets render | Candidate statuses need cleanup | Internal candidates render or natural mentions are ignored |
| Freshness | Unstable claims are omitted, softened, or flagged | Same-week check remains but does not affect visible copy | Blocking freshness conflict or visible unstable claim |
| Render proof | Screenshots prove phrase cards, sections, Mentioned Here, related cards, and bottom spacing | Screenshot catches a focused fix | No rendered proof, duplicate text, hidden content, or missing required modules |

Final decision:

- `PASS`: every gate is `PASS`.
- `REVISE`: any gate is `REVISE` and none are `FAIL`. Fix only the failing notes, then rerun the gate.
- `FAIL`: any gate is `FAIL`. Do not productionize; restart from evidence and the closest canonical anchor.

## Production Review Receipt

```md
Date:
Reviewer:
Worktree / branch / commit:
Page IDs:
Source files:
Generated runtime files:
Screenshot folder:
Commands run:
Results:
Freshness sources checked:
Closest canonical anchors:
Owned traveler moments:
Story spines:
Voice adequacy proof:
Per-page decision table:
Hard blockers:
Focused fixes required:
Do not change:
Final status: PASS / REVISE / FAIL
Promotion status:
```

## Anti-Overengineering Rule

Do not add a new abstract rule after one weak page. Add or change direction only when the same failure appears across multiple pages or when a failure reached production.

Preferred fix order:

1. Revise the page.
2. Add one example or counterexample.
3. Add one review-gate check.
4. Only then consider a validator or pipeline change.
