# Gate 2 Pass 1 - Data Contract And Generator

Reviewer: Hilbert  
Lane: data contract and generator

Findings:

- Blocking: `scripts/practice/generate-viet-practice-deck.js` defaults `source.sectionID` to `hero`, and the generated deck uses that for 60 non-chunk items. The authored page schema has real sections such as `at-glance`, `breakdown`, and `standard-way`; there is no `hero` section. This makes most source section fields non-resolvable and the validator/test suite did not catch it.
- Non-blocking notes: answer/distractor/audio/feedback/tags/progress fields otherwise look complete, counts pass, both deck copies match, and `node scripts/practice/generate-viet-practice-deck.test.js`, `node scripts/practice/generate-viet-practice-deck.js --check`, and `git diff --check` passed.

Approval: BLOCK

