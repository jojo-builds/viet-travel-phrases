# Language Risk Review

## Verdict

- Pass with flagged risk areas preserved

## What I checked

- whether the research document is honest about uncertainty
- whether high-risk phrase areas were incorrectly treated as translation-ready
- whether pronunciation and search risks were surfaced clearly enough for later review

## Findings

- The research doc correctly leaves medical, police, allergy, bargaining-dispute, and pronunciation edge cases for later expert review instead of pretending they are settled.
- The CSV keeps `I need a doctor` explicitly flagged as `expert-review-medical`, and keeps several travel-context phrases marked for localization review or rewrite.
- The Turkish dotted/dotless `i` risk is now explicitly documented in both the research doc and backlog, which prevents this lane from silently inheriting English-style case assumptions later.

## Follow-up note

- Before runtime graduation, this lane needs native review on polite request wording plus a concrete pronunciation rule for `g-breve` and the main non-English vowels.
