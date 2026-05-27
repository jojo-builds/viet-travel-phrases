# Humanizer Repair Brief

Date: 2026-05-26

Use this brief when repairing one humanized chunk after validator or integrity review.

## Goal

Make the assigned chunk safe for import into production-candidate source without hollowing out the copy.

The final copy should read like a compact travel note on an iPhone: observed, calm, useful, and specific to the listing.

## Non-Negotiables

- Touch only your assigned chunk file and its matching report file.
- Do not revert or overwrite work from other chunks.
- Preserve every source page ID, page order, top-level field, and section ID.
- If the source entry has `when-to-use`, the repaired entry must have a humanized `when-to-use`.
- Do not copy old mechanical `when-to-use` wording such as `works best when the name is tied to the reason for going`.
- Do not invent phrase cards. If the source quick-say section had no `phraseIDs`, remove `phraseIDs` from the repaired quick-say section.
- If the source quick-say section did have `phraseIDs`, preserve the exact same IDs in the same order. Keep title `Useful Phrases` and body empty.
- Remove all visible/importable QA language: no `freshness check`, `needs review`, `same-week`, `before import`, `current review`, `copy should`, `copy stays`, `source evidence is thin`, or similar reviewer notes.
- If a fact is unstable, write a traveler-facing caution instead: `Check the show time before crossing town`, not `schedule needs same-week verification before import`.
- Keep every visible field and non-quick-say section body under 45 words.
- Avoid command-like headings beginning with `Use`, `Keep`, `Choose`, `Ask`, `Confirm`, `Leave`, `Start`, or `Let`.
- Avoid visible sentences that begin with `Use ...`.

## Verification

Run:

```bash
node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true
```

Your assigned chunk must show `status: pass` in:

```text
docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/humanizer_chunk_validation.json
```

It is OK if other chunks still fail while parallel workers are running.
