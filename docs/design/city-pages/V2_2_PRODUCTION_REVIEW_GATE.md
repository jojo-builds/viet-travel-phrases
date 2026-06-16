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

2026-06-03 addition: do not replace thin copy with abstract appreciation instructions. Art, museum, temple, market, and walking-route pages must explain what the place is, why this specific place matters, and what a first-time U.S. traveler can expect to see or do. Headings like `Give A Few Works Time` and bodies like `Pick a few works and notice materials, shapes, and space` are a `REVISE`: they sound like writer shorthand, not American travel English, and they do not tell the reader what value the stop provides.

2026-06-03 addition: reject checklist and "object group" prose. Copy must not talk about a `focused group`, `full group`, `object group`, or similar organizing language unless that is the public name of the attraction. A section should not sound like it is telling a reviewer how to classify things on a route. For monuments, museums, temples, markets, and walking areas, write for the person standing there: what am I looking at, why is it here, what should I notice, and why would I remember this instead of the next similar stop?

2026-06-03 addition: reject label-language that sounds like the app explaining its own content model. Visible copy should not lean on phrases such as `the scene is most meaningful`, `the value is`, `the stop`, `this listing`, `useful as`, `helps the page`, `meaningful when`, or similar internal-sounding labels. Preserve useful phrase cards and related-place links; fix the human-facing prose around them instead of deleting affordances to make copy simpler.

2026-06-03 addition: do not tell the reader to save the page. Phrases such as `save it for`, `save this if`, `why save it`, or similar direct saved-list calls are a `REVISE` unless Jojo explicitly asks for visible saved-list language. The page should make a new-to-Vietnam reader want to save it by building context: what this place is, what they will see, why it belongs in this city, and how the phrase cards or related links help in that real moment. If copy gets thinner because the writer is avoiding banned phrases, that is still not production-ready. The fix is not deletion, generic safety, or shorter sections; the fix is specific human-facing context in natural American English.

2026-06-04 addition: review gates must read the visible copy cold before validators run. A gate cannot pass because the source has receipts, story notes, screenshots, or clean validator counts. Before validation, extract the actual traveler-visible intro title/body, section headings, first sentence of each section, phrase-card support text, and Mentioned Here / Related subtitles into a review table. Mark each line `traveler-facing`, `module-job/rationale`, or `thin-safe`. Any `module-job/rationale` or `thin-safe` line is a `REVISE` until rewritten with concrete traveler context. Do not delete useful phrase cards, related cards, or catalog links to make the table easier to pass.

Five Whys for the review-gate failure:

1. Why did two review gates still pass copy with planner/reviewer headings?
   - The gates reviewed the page from inside the authoring context, where headings like `Group Table Reality`, `Crowd Expectations`, or phrase-card rationale still seemed to describe a useful module.

2. Why did that context hide the problem?
   - The reviewer could see the intended structure, source notes, and validator goals, so internal labels felt explanatory instead of visible-reader copy.

3. Why did validation not stop it?
   - Validators are strongest at catching forbidden terms, schema leaks, broken links, overused words, and render failures. They do not prove that a cold U.S. traveler would understand why the page is worth saving.

4. Why did fixes sometimes get thinner?
   - When the process treats validation as the next judge, the fastest fix is to remove risky wording instead of replacing it with richer, more specific context.

5. Why can it recur across batches?
   - The old order lets authoring, review, and validation share the same mental model. The worker is still proving that the page satisfies the production process instead of first proving that the visible copy works without the process.

Root cause: the review gates were not adversarial enough. They relied on receipts and validator-adjacent proof instead of forcing a cold visible-copy read. The process must now run: positive proof, handwritten copy, cold visible-copy gate, heading translation pass, anti-thinning check, then validators.

Five Whys for that failure:

1. Why did the weak section appear?
   - The copy tried to make a compact gallery visit feel useful by telling the reader how to appreciate art.

2. Why did that sound unnatural?
   - The section used abstract art-review nouns (`materials`, `shapes`, `space`) without first grounding the venue in concrete traveler value.

3. Why was the value unclear?
   - The page already knew the real value: a compact art center dedicated to Lê Bá Đảng, a Vietnamese artist born near Huế who worked in France. The weak section drifted away from that evidence.

4. Why did review miss it?
   - Existing gates checked for schema leakage, factual risk, and repeated formulas, but did not explicitly reject appreciation-instruction copy that sounds polished yet confusing.

5. Why could it recur?
   - Museums, galleries, temples, and neighborhoods invite vague language unless the reviewer forces the copy to answer: what is this place, what will I actually encounter, and why this one instead of a generic stop?

Root cause: the section was optimized for sounding editorial instead of translating the place into concrete, first-time-traveler value. The fix is not shorter copy; the fix is more specific copy in natural American English.

2026-06-03 addition: named people, Vietnamese terms, awards, rituals, dishes, neighborhoods, dynasties, and cultural references must be introduced for a U.S.-based first-time Vietnam traveler. A page cannot assume the reader knows who an artist is, what `chay` means, why a royal rite matters, what a Michelin/Bib Gourmand label means, or why a local name is important. The first visible mention must give enough plain-English context for the reader to understand why the reference matters. If the copy names a person or Vietnamese term, the same sentence or the next sentence must answer: who or what is this, why is it connected to Vietnam or this city, and why should someone new to Vietnam care?

Five Whys for the named-reference gap:

1. Why did the weak section appear?
   - The copy used `one Vietnamese artist` as if nationality plus category were enough context.

2. Why did that fail the reader?
   - A first-time U.S. visitor does not know Lê Bá Đảng, the Vietnamese art context, or why a memory space around him should be meaningful.

3. Why did the page feel generic?
   - The sentence talked around the evidence (`contemporary art`, `designed building`, `garden-like grounds`) instead of explaining the person and the reason the site exists.

4. Why did review miss it?
   - The gate checked for abstract art language but did not require first-mention context for named people and Vietnamese cultural terms.

5. Why could it recur?
   - Many Vietnam listings include names, foods, rituals, awards, and local terms that are familiar to the writer or source material but unfamiliar to the app reader.

Root cause: the copy assumed background knowledge the target audience does not have. The fix is to introduce the reference in plain English before using it as a reason to care.

## Required Evidence

- Page scope: page ID, city, visible title, source file, generated runtime file, reviewer date, worktree/branch, and commit if available.
- Guidance read: `CURRENT_CITY_PAGE_STANDARD.md`, v2.2 playbook, canonical examples, generation prompt, implementation audit prompt, and screenshot gate.
- Authoring proof: closest canonical anchor, page-specific difference from that anchor, the one traveler moment the page owns, and the truthful story spine the page carries.
- Positive proof card before writing: what this place/dish/route is, why it matters here, what a first-time U.S. traveler should picture, what the real phrase-card moment is, and why the related cards help in the trip.
- Cold visible-copy proof before validation: intro title/body, all visible headings, first sentence of each section, phrase-card support text, and Mentioned Here / Related subtitles are extracted and classified as `traveler-facing`, `module-job/rationale`, or `thin-safe`.
- Heading translation proof: visible headings and lead sentences have been translated from internal module jobs into concrete traveler-facing nouns, actions, city traits, place details, table behavior, route objects, or sensory anchors.
- Anti-thinning proof: any removed phrase, section, phrase card, Mentioned Here card, related card, or contextual detail is replaced with equal or better traveler value, or the receipt states the specific mismatch that required removal.
- Voice adequacy proof: scene proof, why-here proof, and first-move proof from visible copy, with no database/process/schema wording leaking into the reader experience.
- First-mention proof: named people, Vietnamese terms, awards, dishes, rituals, dynasties, neighborhoods, and cultural references are introduced in plain English before the copy relies on them for meaning.
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
- The page has no positive proof card before writing, or the visible copy does not deliver the proof without relying on source notes.
- The cold visible-copy table contains any `module-job/rationale` or `thin-safe` line after one focused revise cycle.
- The visible copy cannot prove scene, why-here, and first-move in a story-rich human voice.
- A visible heading or lead sentence names the module job instead of the traveler moment, such as `planning`, `pairing`, `contrast`, `context`, `expectations`, `reality`, `scope`, `value`, `meaningful`, `useful`, `reason`, `works well`, or similar review-language.
- Useful Phrases render as prose, lack playable cards, or render unsupported Vietnamese/audio as production copy.
- Intro/body/sections duplicate each other.
- Rendered output drops required phrase cards, Mentioned Here cards, or related cards that source marked `render`.
- Internal QA fields such as `reason`, `check_catalog`, source notes, or relation labels appear in visible UI.
- Cards link to missing, non-openable, wrong-city, wrong-place, or generic fallback targets.
- Fixed chrome or sticky audio controls prevent a reader from reading, tapping, or reaching required content after normal scrolling.
- Normal native iOS scroll-under behavior, where content can faintly pass behind translucent top/back/bottom chrome while the active reading area remains clear, is not a blocker and must not be "fixed" by making top chrome opaque.
- Visible copy makes unsupported unstable claims about hours, price, payment, ticketing, access, pickup points, closures, or rules.
- Visible copy names a person, Vietnamese term, award, dish, ritual, dynasty, neighborhood, or cultural reference without first explaining what it is and why it matters to someone new to Vietnam.
- Visible copy uses a cultural shorthand such as `one Vietnamese artist`, `royal`, `traditional`, `local`, `heritage`, or a Vietnamese proper noun as if the label itself creates value. The copy must translate the label into a concrete reason to visit or remember the place.
- A fix makes the page shorter by deleting context, phrase-card value, Mentioned Here candidates, or related cards without replacing the deleted material with equal or better traveler-facing context.
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
| Positive proof | The page states what it is, why here, what to picture, and how phrase/related cards support the trip before visible copy is written | One proof answer is thin but recoverable before validation | Copy begins from schema fields, validator avoidance, or banned-phrase repair |
| Cold visible-copy gate | Extracted visible lines read as traveler-facing without source notes or validator context | One line is module-like or too thin and needs rewrite before validation | Review passes from receipts, source notes, or validator output instead of visible copy |
| Heading translation | Headings and lead sentences are concrete traveler-facing nouns/actions/details | One heading is close but still reviewer-ish | Headings name module jobs, planning roles, comparison logic, or phrase-card rationale |
| Anti-thinning | Fixes preserve or improve context, phrase cards, Mentioned Here, and related links | One section needs more specificity after cleanup | The page passes by deleting substance or useful cards |
| Story spine | The page carries a truthful local/cultural/place story in the intro or an early section | Story is present but too generic, so one focused sentence needs sharpening | Utility-only copy with no reason this place belongs here |
| Voice adequacy | Visible copy proves scene, why-here, and first-move in a story-rich human voice with no database/process wording | One proof is thin or one sentence sounds internal | Reads like a database row, process note, QA receipt, or schema checklist |
| Evidence | Specific facts, place behavior, and freshness risks are known enough for the copy length | Evidence is thin, so copy must shrink or flags must be stronger | Claims exceed evidence or source status is blocking |
| Voice | First screen sounds natural, specific, adult, and useful | Mostly good, but one heading/body sounds command-like or generic | Reads like schema, tourism copy, or interchangeable AI prose |
| Source object | All required v2.2 fields exist with two to four sections and strict score | Small field or note omissions | Missing required fields or legacy-only source |
| Phrase/audio | Phrase cards fit the place and have usable audio status | One phrase needs close-match or native-speaker QA | Unsupported Vietnamese is rendered or phrase cards are prose |
| Catalog links | Natural mentions and route/comparison links are evaluated; only valid targets render | Candidate statuses need cleanup | Internal candidates render or natural mentions are ignored |
| Freshness | Unstable claims are omitted, softened, or flagged | Same-week check remains but does not affect visible copy | Blocking freshness conflict or visible unstable claim |
| Render proof | Screenshots prove phrase cards, sections, Mentioned Here, related cards, bottom spacing, and no solid opaque top shield | Screenshot catches a focused fix | No rendered proof, duplicate text, unreachable or unreadable required content, missing required modules, or a solid opaque top shield introduced as a workaround |

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
