# Traveler Utility Review

## Verdict

- Pass

## What I checked

- whether the Turkish lane now points the next authoring pass at high-pressure travel moments instead of generic even coverage
- whether quick phrases and scenario tips favor the fastest likely traveler needs
- whether the ranked CSV would help a translator start immediately

## Findings

- The first-wave ranking now starts with politeness, price, taxi, hotel, payment, and repair phrases, which matches the repo's traveler-first product model.
- `scenario-plan.json` now shifts quick phrases toward apology, thanks, price, taxi routing, and non-understanding instead of the old generic scaffold defaults.
- Bargaining language is present but intentionally downgraded and flagged as context-limited, which is the right balance for Turkey.

## Follow-up note

- The next translation task should start at the top of `content-draft/turkish/first-wave-priority.csv` and not spread effort evenly across all 70 scaffold rows.
