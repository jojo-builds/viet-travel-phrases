# T-024 Search Audit

Date: 2026-04-18
Task: shared search normalization audit and bounded family-shell fix pass

## Scope

- shared search normalization only
- repo truth and bounded local validation only
- no claim of device or simulator proof

## Audit inputs

- `app/lib/searchPhrases.ts`
- `app/family/packs/viet.generated.ts`
- `app/family/packs/tagalog.generated.ts`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/CURRENT_BLOCKERS.md`

## Finding

The shared matcher normalized punctuation into spaces, but it only checked the spaced normalized string.
That meant compact traveler queries could miss phrase families that were indexed only in a spaced or hyphenated form.

Examples from repo truth:

- Viet pack contains `Wi-Fi` and `eSIM` phrase text and aliases.
- Tagalog pack contains `check in`, `reservation`, and `air conditioning` phrase text.

Concrete pre-fix behavior observed during the audit:

- `searchPhrases(vietPack, 'wifi', true)` returned `3` top matches.
- `searchPhrases(vietPack, 'wi-fi', true)` returned `5` top matches.
- `searchPhrases(tagalogPack, 'check-in', false)` returned a result, but compact separator variants depended on exact indexed wording.

## Fix applied

- kept the existing `normalizeSearchText()` pipeline
- added `compactSearchText()` to remove spaces after normalization
- search now matches when either:
  - the spaced normalized text contains the spaced normalized query, or
  - the compact normalized text contains the compact normalized query

File changed:

- `app/lib/searchPhrases.ts`

## Validation

Passed:

- `npx --no-install tsc --noEmit`
- deterministic Node proof of the matching rule for representative repo-real strings:
  - `wifi`: `before=false`, `after=true`, searchable `where can i get airport wi fi`
  - `esim`: `before=true`, `after=true`, searchable `my esim is not working`
  - `checkin`: `before=false`, `after=true`, searchable `i d like to check in`
  - `aircon`: `before=false`, `after=true`, searchable `air conditioning`

Limits:

- a pack-backed `tsx` query probe worked earlier in the audit and exposed the `wifi` vs `wi-fi` mismatch, but rerunning that path after the edit hit sandbox `spawn EPERM` through the `tsx`/`esbuild` child-process path
- no simulator or device walkthrough happened here

## Residual risk

- separator normalization is stronger in repo truth, but real manual search proof for Viet + Tagalog is still missing
- non-Latin runtime promotion still needs a separate UX/localization review before inheriting the same search claims
