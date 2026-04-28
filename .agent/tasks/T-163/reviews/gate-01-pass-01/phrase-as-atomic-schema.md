# Gate 1 Pass 1: Phrase-As-Atomic-Schema Review

Gate: schema and identity
Reviewer lane: phrase-as-atomic-schema
Judgment: the schema and generated DB preserve the catalog phrase as the atomic learner-facing unit.

Evidence:
- `phrase_page.phrase_id` is `NOT NULL UNIQUE` and references `phrase(id)`.
- The generator creates `phraseRows` and `pageRows` directly from `catalog.phrases`.
- SQLite checks confirm `919` phrases and `919` phrase pages.
- There are zero phrases without pages, zero duplicate pages per phrase, and zero pages without phrases.
- Alias rows resolve to canonical phrase pages.

Non-blocking note:
- `3` authored section phrase items are audited as not in catalog and represented as `authored_phrase` section items. This does not break the required one phrase row and one canonical `phrase_page` per catalog phrase.

Approval: APPROVE
