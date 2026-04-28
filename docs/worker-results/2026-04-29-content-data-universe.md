# Content Data Universe Receipt

Date: 2026-04-29

## Result

- Commit hash: `fa9f112` (`Complete Viet content data universe fixture`).
- Task Done complete: yes for the content/data fixture lane; Swift runtime integration remains intentionally untouched because `native-ios/App/**` is owned by `T-167`.
- Total phrase rows discovered: 919.
- Total canonical listing pages produced/resolved: 911 canonical `phrase_page` rows; 919 source phrase rows resolve through `phrase.canonical_phrase_id`.
- Tier 1 final classification counts: strong 150, thin 0, awkward 0, placeholder-like 0, over-templated 0, negative/frictional 0, missing useful child links 0, needs work 0.
- Non-Tier-1 coverage counts: 761 non-Tier-1 source phrase rows resolve into canonical pages; every canonical page has renderable sections.

## Database

- Schema changes: added `phrase.canonical_phrase_id`; relation/search/audio/page-section tables are now populated/validated in the fixture.
- Generated counts: 18 scenarios, 900 clusters, 919 phrase rows, 911 canonical pages, 928 aliases, 4,515 page sections, 5,019 section items, 720 breakdown tokens, 3,438 relation edges, 919 search documents.
- Duplicate phrase-page handling: 6 exact normalized Vietnamese duplicate groups resolved to canonical pages; unresolved duplicate groups 0.
- Link/search/audio validation: broken relation edges 0, missing search page targets 0, missing audio audit rows 0, audio text mismatches 0, banned user-facing matches 0.

## Files Changed

- `native-ios/scripts/sqlite/001_initial.sql`
- `native-ios/scripts/generate-viet-sqlite-fixture.js`
- `native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `native-ios/scripts/validate-viet-sqlite-fixture.js`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `app/family/packs/viet.generated.ts`
- `app/family/presentation/viet.ts`
- `app/family/presentation/vietPremium.ts`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/website-preview.json`
- `content-draft/viet/listing-pages/**` regenerated Tier 1 source drift
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- `site/**` targeted user-facing wording cleanup and preview artifact lines
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/worker-results/2026-04-29-content-data-universe.md`

## Validation

- `node native-ios/scripts/generate-viet-sqlite-fixture.js`: passed.
- `node native-ios/scripts/generate-viet-sqlite-fixture.test.js`: passed.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`: passed.
- `node native-ios/scripts/validate-tier-one-listing-pages.js`: passed.
- `npm run validate:family`: passed.
- `npm run validate:premium-boundary`: passed.
- Banned wording scan over native resources, Viet content, app-family copy, and site surfaces: passed with no matches.
- `git diff --check`: passed.
- `native-ios/App/**` untouched: verified.

## Remaining Blockers

- None for the content/data fixture lane.
- Ready-to-merge handoff: a later `T-167`-safe native task can wire the Swift runtime/search/page renderer to the SQLite read model after UI work lands.

## Recommended Next Task

Add a conflict-safe native debug read parity task after `T-167`: query the bundled SQLite fixture for search, canonical page open, section rendering, and audio usage, while keeping JSON as the release default until simulator proof is complete.
