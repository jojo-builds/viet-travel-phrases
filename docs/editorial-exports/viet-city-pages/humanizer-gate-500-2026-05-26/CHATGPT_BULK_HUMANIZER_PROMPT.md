# ChatGPT Bulk Humanizer Prompt

Use inside the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`.

You are repairing existing SpeakLocal Viet city-library source copy into humanized v2.2 production-candidate copy. You are not creating a new schema, not writing a travel article, and not adding new one-off phrase cards.

Read the project source pack first. V2.2 repo docs remain the source of truth.

## Your Job

Rewrite the provided JSON chunk while preserving the exact object shape:

- same `cityID`
- same `range`
- same number of `entries`
- same page order
- same `pageID` values
- same top-level entry field names
- same section IDs
- preserve all source sections, including `when-to-use` if present
- preserve exact `phraseIDs` arrays when they already exist
- do not add new phrase IDs

The output must be valid JSON for the chunk file. Also include a compact self-gate report after the JSON.

## Voice

Shorter. Sharper. More observed. Adult. Calm. Useful.

The page should feel like a well-traveled friend quietly pointing out how this place fits into the day.

Before rewriting each page, silently choose the one traveler moment it owns: a pause, crossing, pickup, bowl, upstairs choice, market browse, indoor reset, station move, rain plan, ticket moment, route pairing, or similar concrete situation.

Let that moment shape the copy. Then map it back into the existing fields.

## Remove Known Drift

Do not use these visible patterns:

- `best for`, `best as`, `best when`, `works best`, `reads best`
- `traveler`, `travelers`, `helps travelers`
- `anchor` as a generic planning noun
- `Worth it if`
- `What you'll get`
- `Before you go`
- `Why go`
- `Say it locally`
- `useful because`
- `useful moment`
- `the page`
- `the entry`
- `this listing`
- `city library`
- `visible copy`
- `freshness check`
- `source evidence`
- `copy should`
- `copy stays`
- `check_catalog`
- `render`
- `not_run`
- `production-ready`
- `current details`
- `current menu`
- `current stalls`
- `current businesses`
- `claims`
- `need checking`
- `needs checking`
- `until checked`
- `freshness`
- `the page`
- `database`
- `schema`
- `entry` as a process label
- `promises`
- `fresh/current/details/checking` language in visible headings when it reads like QA or status

Avoid headings that start with command verbs such as `Use`, `Keep`, `Choose`, `Ask`, `Confirm`, `Leave`, `Start`, `Let`, or `Check`.

Avoid visible sentences beginning with `Use ...`.

Freshness notes belong in the self-gate, not visible copy. In visible fields, either omit unstable specifics or describe the stable role of the place. Do not title a section around fresh/current/details/checking language.

Do not turn QA uncertainty into prose. Lines like `prices can change`, `menus can shift`, `access needs checking`, `details need a current look`, or `availability needs a fresh check` belong in the self-gate, not the app.

For `quick-say` without phrase IDs, do not default to a name lesson. Use a name/pronunciation card only when that is the reader's real next action; otherwise make it ordering, route, pickup, ticket, or recognition help from the page's owned moment.

Before final output, scan the chunk as one shelf. If more than three pages share the same heading pattern, revise the headings before returning JSON.

## Phrase Cards

If the source `quick-say` section has `phraseIDs`:

- keep the exact IDs in the same order
- title must stay `Useful Phrases`
- body must stay empty

If the source `quick-say` section has no `phraseIDs`:

- do not use the title `Useful Phrases`
- do not add phrase IDs
- write a natural title and a short body that helps pronunciation, naming, ordering, route, or recognition

## Substance Preservation

Do not delete the actual place to sound cleaner.

Preserve stable specifics from the source: neighborhood, building role, market role, food/drink role, river/beach/station/airport/bridge context, old building details, craft village context, or stable route pairing.

If source evidence is thin, narrow the claim. Do not pad with generic props like signs, benches, awnings, bags, shopfronts, or `local texture` unless the source specifically supports them.

Do not invent hours, prices, current menus, ticket rules, access rules, closures, schedules, rankings, awards, or live operations.

## Mobile Limits

- Keep `summary`, `context`, `tip`, `rationale`, and every non-empty section body under 45 words.
- Keep `summary` at least 130 characters so it survives the importer floor.
- Keep every section doing a different job.
- No duplicate body lines.

## Output

First output the complete JSON chunk in one fenced `json` block.

Then output:

```markdown
## Writer self-gate

- `chunk_file: ...`
- `entries: ...`
- `self_gate_status: pass/revise`
- `heading_cadence_risks: ...`
- `phrase_card_risks: ...`
- `thin_source_pages: ...`
- `pages_requiring_codex_integrity_review: ...`
- `notes_for_codex: ...`
```

If you cannot safely finish the whole chunk, output `BLOCKED_STUB` and explain why. Do not return a partial chunk as if it is final.
