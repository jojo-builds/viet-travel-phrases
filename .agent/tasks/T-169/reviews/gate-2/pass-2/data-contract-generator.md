# Gate 2 Pass 2 - Data Contract And Generator

Reviewer: Locke  
Lane: data contract and generator

Findings:

- Blocking: the generated deck no longer contains `hero` and all 70 current items resolve to authored sections, but `validatePracticeCore()` and `--check` still do not validate `source.pageID#source.sectionID` against `viet-authored-listing-pages.json`. The reviewer confirmed a mutated built item with `sectionID = "hero"` still returned no validator errors. The separate unit test catches this now, but the exported validator/generator check can still pass the original regression.
- Current state verified: `practice-deck.sample.json` has 70 items, 0 unresolved section IDs, with `standard-way`, `natural-variations`, and `breakdown` only.
- `node scripts/practice/generate-viet-practice-deck.test.js` and `node scripts/practice/generate-viet-practice-deck.js --check` both passed before this validator hardening fix.

Approval: BLOCK

