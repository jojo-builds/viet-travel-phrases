# Offline SQLite Phrase Graph Plan

Status: proposed architecture plan
Owner lane: SpeakLocal native app-family planning
Last updated: 2026-04-29
Scope: offline phrase graph, canonical phrase pages, search, audio mapping, and practice-ready data

## Decision

Move SpeakLocal toward a build-time generated, bundled SQLite database for each language pack. The database should be the native app's offline read model for phrase pages, phrase clusters, search, audio usages, and practice deck seeds.

The source of truth stays authored and reviewable in repo files such as `content-draft/viet/phrase-source.csv`, `content-draft/viet/listing-pages/**`, relation sidecars, and future language-pack source folders. SQLite is not the authoring surface. It is the compiled offline runtime artifact, similar to how the current native JSON resources are generated today.

The core model should be:

- `phrase`: the atomic learner-facing unit.
- `phrase_page`: the canonical page for one phrase.
- `phrase_cluster`: the old `family` idea recast as a collection/relation hub, not a competing page identity.
- `page_section` and `page_section_item`: the article/listing renderer content contract.
- `phrase_relation`: graph edges between phrases and clusters.
- `audio_asset` and `audio_usage`: exact normalized text dedupe plus contextual playback.
- `search_document`: ranked offline search over exact Vietnamese, accent-insensitive Vietnamese, pronunciation, English, aliases, categories, and related phrases.
- `practice_deck` / `practice_item`: practice-ready hooks that reuse phrase graph IDs rather than creating a second content model.

Runtime remains fully offline. No runtime AI or network dependency is introduced.

## Current Model Reality

The current live Viet native resources are still JSON files under `native-ios/Resources/`, not `LanguagePacks/viet/`.

| Surface | Current count / size | Current job |
| --- | ---: | --- |
| `viet-phrase-catalog.json` | `900` families, `919` phrase rows, `18` scenarios, `1.29 MB` | Generated catalog/search/browse fallback truth |
| `viet-authored-listing-pages.json` | `163` rich pages, `1.27 MB` | Generated article/listing pages for Tier 1 plus child pages |
| `viet-audio-manifest.json` | `3,756` manifest entries, `0.56 MB` | Audio key to file/text lookup |
| `native-ios/Resources/Audio/` | `2,427` files, about `65 MB` | Bundled offline MP3 assets |

The phrase catalog currently has `900` `say-first` rows plus `19` variants:

| Variant role | Count |
| --- | ---: |
| `say-first` | `900` |
| `also-common` | `11` |
| `clearer` | `5` |
| `more-polite` | `3` |

There are `157` starter rows and `762` premium rows. All `919` catalog rows are currently `audioStatus=ready`.

The authored listing resource is richer than the catalog because it contains article sections, phrase rows inside sections, and breakdown tokens:

| Authored page field | Count |
| --- | ---: |
| Pages | `163` |
| Tier 1 family count in metadata | `150` |
| Resource main pages | `148` |
| Child pages | `15` |
| Phrase rows inside sections | `1,363` |
| Breakdown tokens | `720` |

The `150` Tier 1 count is the authored inventory target. The generated native resource currently reports `148` resource main pages plus `15` child pages because a small number of Tier 1 routes are still supplied by hand-coded/root page coverage or compatibility mapping rather than one generated main-page record per inventory row.

Those counts intentionally differ today:

- A **family** is the current visible catalog hub. It is close to a traveler intent, but it is not the atomic phrase.
- A **phrase row** is one playable wording inside a family. Most families have exactly one row today, but richer families may have variants.
- An **authored page** is a rich article/listing surface. Only Tier 1 and some child/detail pages have this treatment today.

Those differences should mostly disappear in the future runtime model. Every phrase should be capable of opening one canonical phrase page. Page richness becomes a completeness/status field, not permission to have a page.

## Why SQLite

SQLite fits the product shape because SpeakLocal needs a local graph, ranked search, and many small joins across phrases, pages, audio, categories, and practice state. Keeping this in large JSON files would keep pushing complexity into Swift loaders and in-memory indexes.

Relevant platform facts:

- Apple bundle docs describe app bundles as the place for code and resources needed by the app, and `Bundle`/`NSBundle` APIs locate resources shipped with the app ([Apple Bundle Programming Guide](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/AboutBundles/AboutBundles.html), [Accessing a Bundle's Contents](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/AccessingaBundlesContents/AccessingaBundlesContents.html)).
- iOS app bundles use a relatively flat resource structure, and resource files can include data files and sounds ([Apple Bundle Structures](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html)).
- SQLite databases are normally a single main database file, which is a clean fit for one bundled language-pack artifact ([SQLite file format](https://www.sqlite.org/fileformat.html)).
- SQLite FTS5 supports built-in tokenizers including `unicode61`; its diacritic-removal behavior is directly relevant for Vietnamese accent-insensitive search ([SQLite FTS5](https://www.sqlite.org/fts5.html)).
- Apple's App Store Connect limit for iOS/iPadOS app builds is `4 GB` uncompressed for iOS 9 and later, but app-size discipline still matters for download and install experience ([Maximum build file sizes](https://developer.apple.com/help/app-store-connect/reference/app-uploads/maximum-build-file-sizes), [App thinning overview](https://help.apple.com/xcode/mac/current/en.lproj/devbbdc5ce4f.html)).

Use a bundled read-only content database plus a separate app-container database for mutable local progress. Do not write into the bundled database at runtime.

## Core Identity Rules

### Phrase

A phrase is one learner-facing wording with stable identity. It owns:

- Vietnamese text and normalized text;
- English meaning;
- pronunciation;
- language/destination;
- access tier;
- audio status;
- authoring/source metadata;
- one canonical phrase page.

The same spoken phrase can appear in multiple scenarios. That should usually be represented as one phrase with multiple scenario/category links, not duplicate pages.

If the same Vietnamese spelling truly carries different meanings, the source should split it with an explicit `sense_key` and reviewer note. Exact text duplicates should be treated as audit items until an author chooses "same phrase, multiple contexts" or "different phrase sense."

### Phrase Page

Every phrase has exactly one canonical phrase page.

`phrase_page` is not only for flagship content. It always exists, but its `completeness_status` tells the renderer how much authored depth is available:

- `baseline`: dependable page assembled from phrase, context, category, audio, and simple positive notes;
- `support`: authored or generated-from-authored sections with real related phrases and useful distinctions;
- `deep`: flagship article/listing page with rich variants, breakdown, local/travel notes, and relation rails.

Avoid "short page" or "thin page" language in source fields intended to influence UI copy. The page is still valuable; it is just at an earlier completeness level.

### Phrase Cluster

`phrase_cluster` replaces current `family` as the collection concept. A cluster groups phrases that share a traveler intent, social function, or useful comparison:

- `Cảm ơn` cluster: `Cảm ơn`, `Cảm ơn nhiều`, `Cảm ơn anh/chị`, etc.
- `hello by relationship` cluster: `Chào anh`, `Chào chị`, `Chào em`, etc.
- `repair / understanding` cluster: "I don't understand", "Please repeat", "Please write it down", etc.

A cluster may have a `primary_phrase_id` and browse title. Opening a cluster from browse should route to the primary phrase page unless a future cluster overview is intentionally authored. The phrase page remains canonical.

### Canonical Routing

Use stable route IDs and aliases:

- `phrase_page.id` is the canonical route.
- `page_alias` maps legacy family page IDs and old hand-coded IDs to canonical pages.
- `phrase_page.phrase_id` is unique.
- `page_alias.alias_id` is unique and must point at exactly one canonical page.
- exact normalized text duplicates are audited before release.

This prevents duplicate `Chào anh`-style pages. If `Chào anh` appears in search, a relationship-greeting page, a local small-talk section, and a practice prompt, all roads open the same canonical page ID.

## Proposed SQLite Schema

This is a runtime/read-model schema, not a hand-authored schema. Names can change during implementation, but the boundaries should stay stable.

```sql
CREATE TABLE language_pack (
  id TEXT PRIMARY KEY,
  app_id TEXT NOT NULL,
  language_code TEXT NOT NULL,
  display_name TEXT NOT NULL,
  content_version TEXT NOT NULL,
  generated_at TEXT NOT NULL
);

CREATE TABLE scenario (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  title TEXT NOT NULL,
  traveler_label TEXT NOT NULL,
  symbol_name TEXT NOT NULL,
  tint_name TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);

CREATE TABLE phrase (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  canonical_phrase_key TEXT NOT NULL,
  canonical_phrase_id TEXT NOT NULL REFERENCES phrase(id) DEFERRABLE INITIALLY DEFERRED,
  target_text TEXT NOT NULL,
  normalized_target_text TEXT NOT NULL,
  accentless_target_text TEXT NOT NULL,
  english_text TEXT NOT NULL,
  pronunciation TEXT NOT NULL,
  access_tier TEXT NOT NULL,
  completeness_status TEXT NOT NULL,
  audio_status TEXT NOT NULL,
  source_path TEXT NOT NULL,
  source_row_id TEXT,
  sense_key TEXT,
  UNIQUE(language_pack_id, canonical_phrase_key)
);

CREATE TABLE phrase_page (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  phrase_id TEXT NOT NULL UNIQUE REFERENCES phrase(id),
  title TEXT NOT NULL,
  english_title TEXT NOT NULL,
  summary TEXT NOT NULL,
  icon_name TEXT NOT NULL,
  tint_name TEXT NOT NULL,
  page_renderer TEXT NOT NULL DEFAULT 'article-listing',
  completeness_status TEXT NOT NULL,
  is_authored INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE page_alias (
  alias_id TEXT PRIMARY KEY,
  canonical_page_id TEXT NOT NULL REFERENCES phrase_page(id),
  alias_kind TEXT NOT NULL,
  source_path TEXT NOT NULL
);
```

Use ordinary rowid tables until implementation profiling says otherwise. For narrow lookup tables with text primary keys and no integer row identity needs, `WITHOUT ROWID` can be considered because SQLite documents potential space/performance benefits for non-integer primary keys, but it should be adopted selectively and tested on the actual bundled database ([SQLite WITHOUT ROWID](https://www.sqlite.org/withoutrowid.html)).

### Clusters And Membership

```sql
CREATE TABLE phrase_cluster (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  cluster_kind TEXT NOT NULL,
  title TEXT NOT NULL,
  summary TEXT NOT NULL,
  primary_phrase_id TEXT NOT NULL REFERENCES phrase(id),
  source_family_id TEXT,
  source_path TEXT NOT NULL
);

CREATE TABLE phrase_cluster_member (
  cluster_id TEXT NOT NULL REFERENCES phrase_cluster(id),
  phrase_id TEXT NOT NULL REFERENCES phrase(id),
  role TEXT NOT NULL,
  sort_order INTEGER NOT NULL,
  note TEXT,
  PRIMARY KEY(cluster_id, phrase_id)
);
```

Current `family_id` maps to `phrase_cluster.source_family_id`. Current `variantRole` maps to cluster membership `role`, while each variant still becomes a first-class `phrase` with a page.

### Categories And Scenarios

```sql
CREATE TABLE phrase_scenario (
  phrase_id TEXT NOT NULL REFERENCES phrase(id),
  scenario_id TEXT NOT NULL REFERENCES scenario(id),
  relevance TEXT NOT NULL DEFAULT 'primary',
  sort_order INTEGER NOT NULL,
  PRIMARY KEY(phrase_id, scenario_id)
);

CREATE TABLE cluster_scenario (
  cluster_id TEXT NOT NULL REFERENCES phrase_cluster(id),
  scenario_id TEXT NOT NULL REFERENCES scenario(id),
  relevance TEXT NOT NULL DEFAULT 'primary',
  PRIMARY KEY(cluster_id, scenario_id)
);
```

This lets `Nhà vệ sinh ở đâu?` be one phrase with multiple browse contexts instead of separate bathroom/airport pages.

### Page Sections And Ordering

```sql
CREATE TABLE page_section (
  id TEXT PRIMARY KEY,
  page_id TEXT NOT NULL REFERENCES phrase_page(id),
  section_key TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  presentation TEXT NOT NULL,
  sort_order INTEGER NOT NULL,
  source_path TEXT NOT NULL,
  UNIQUE(page_id, section_key)
);

CREATE TABLE page_section_item (
  id TEXT PRIMARY KEY,
  section_id TEXT NOT NULL REFERENCES page_section(id),
  item_kind TEXT NOT NULL,
  target_id TEXT NOT NULL,
  title_override TEXT,
  subtitle_override TEXT,
  note TEXT,
  sort_order INTEGER NOT NULL
);
```

`item_kind` can point to `phrase`, `breakdown_token`, `phrase_relation`, `practice_action`, or future renderer-safe item types. The renderer should not infer ordering from JSON array position after migration; `sort_order` owns it.

### Breakdown Tokens

```sql
CREATE TABLE breakdown_token (
  id TEXT PRIMARY KEY,
  phrase_id TEXT NOT NULL REFERENCES phrase(id),
  token_text TEXT NOT NULL,
  normalized_token_text TEXT NOT NULL,
  english_gloss TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);
```

Breakdown tokens are teaching atoms, not separate phrase pages by default. A token can still have audio and can later link to a phrase if it becomes page-worthy.

### Relations

```sql
CREATE TABLE phrase_relation (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  source_kind TEXT NOT NULL,
  source_id TEXT NOT NULL,
  target_kind TEXT NOT NULL,
  target_id TEXT NOT NULL,
  relation_type TEXT NOT NULL,
  reason TEXT NOT NULL,
  display_label TEXT,
  sort_order INTEGER NOT NULL,
  source_path TEXT NOT NULL
);
```

Initial relation types should include:

- `shorter_than`
- `clearer_than`
- `more_polite_than`
- `also_common_with`
- `reply_to`
- `likely_answer_to`
- `next_step_after`
- `repair_for`
- `escalation_for`
- `same_need_alt_context`
- `see_also`

Relations are advisory navigation and practice/search signals. They must not claim that another speaker will always reply in a specific way.

### Audio

```sql
CREATE TABLE audio_asset (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  file_name TEXT NOT NULL,
  voice_id TEXT,
  duration_ms INTEGER,
  normalized_spoken_text TEXT NOT NULL,
  source_manifest_key TEXT NOT NULL,
  UNIQUE(language_pack_id, file_name)
);

CREATE TABLE audio_usage (
  id TEXT PRIMARY KEY,
  audio_asset_id TEXT NOT NULL REFERENCES audio_asset(id),
  usage_kind TEXT NOT NULL,
  target_kind TEXT NOT NULL,
  target_id TEXT NOT NULL,
  expected_text TEXT NOT NULL,
  normalized_expected_text TEXT NOT NULL,
  is_primary INTEGER NOT NULL DEFAULT 0,
  source_path TEXT NOT NULL
);

CREATE TABLE audio_text_dedupe (
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  normalized_text TEXT NOT NULL,
  preferred_audio_asset_id TEXT NOT NULL REFERENCES audio_asset(id),
  duplicate_count INTEGER NOT NULL,
  PRIMARY KEY(language_pack_id, normalized_text)
);

CREATE TABLE missing_audio_audit (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  target_kind TEXT NOT NULL,
  target_id TEXT NOT NULL,
  expected_text TEXT NOT NULL,
  normalized_expected_text TEXT NOT NULL,
  source_path TEXT NOT NULL,
  reason TEXT NOT NULL,
  severity TEXT NOT NULL,
  release_blocking INTEGER NOT NULL,
  suggested_audio_key TEXT,
  created_at TEXT NOT NULL
);
```

The dedupe rule is exact normalized spoken text first. The current manifest already shows why this matters: `3,756` manifest entries map to `2,419` unique non-empty text values, with many repeated breakdown pieces such as `Tôi`, `Bạn`, and `một`. Reusing exact audio keeps speaker icons honest and prevents audio growth from outpacing phrase growth.

Speaker-icon honesty is stricter than audit visibility:

- A speaker icon is renderable only when an `audio_usage` row resolves to an `audio_asset` row and `audio_usage.normalized_expected_text == audio_asset.normalized_spoken_text`.
- If audio is missing or the normalized expected/spoken text does not match, the generator writes a `missing_audio_audit` row and the runtime hides or disables the speaker control for that target.
- `release_blocking=1` should be used for hero phrases, visible phrase rows, breakdown tokens, and practice prompts that would otherwise show speaker controls in the release surface.
- `release_blocking=0` is acceptable only for parked/future rows that are not reachable in the current app surface.
- Missing-audio audit output should be exported as a report file during generation so content/audio work can fix the source without requiring SQLite inspection.

### Search

```sql
CREATE TABLE search_document (
  rowid INTEGER PRIMARY KEY,
  id TEXT NOT NULL UNIQUE,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  target_kind TEXT NOT NULL,
  target_id TEXT NOT NULL,
  title_text TEXT NOT NULL,
  target_text TEXT NOT NULL,
  accentless_target_text TEXT NOT NULL,
  pronunciation_text TEXT NOT NULL,
  english_text TEXT NOT NULL,
  alias_text TEXT NOT NULL,
  category_text TEXT NOT NULL,
  related_text TEXT NOT NULL,
  priority_tier INTEGER NOT NULL,
  is_canonical_page INTEGER NOT NULL
);

CREATE VIRTUAL TABLE search_document_fts USING fts5(
  title_text,
  target_text,
  accentless_target_text,
  pronunciation_text,
  english_text,
  alias_text,
  category_text,
  related_text,
  content='search_document',
  content_rowid='rowid',
  tokenize='unicode61 remove_diacritics 2'
);
```

Search ranking should combine:

- exact Vietnamese target match;
- exact normalized/accentless Vietnamese match;
- pronunciation match;
- English title/meaning match;
- alias match;
- scenario/category match;
- related phrase/cluster match;
- completeness and access priority;
- recency/saved/progress boosts later from the local progress store.

The current Swift search has useful behavior worth preserving: exact title and English matches beat broad haystack matches, authored/Tier 1 pages receive a boost, and search aliases are part of the phrase row. SQLite should move that scoring into one tested repository layer instead of scattering it across JSON loaders.

### Practice Hooks

Practice should reuse the phrase graph instead of inventing a second content model.

```sql
CREATE TABLE practice_deck (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  deck_kind TEXT NOT NULL,
  title TEXT NOT NULL,
  source_kind TEXT NOT NULL,
  source_id TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);

CREATE TABLE practice_item (
  id TEXT PRIMARY KEY,
  deck_id TEXT NOT NULL REFERENCES practice_deck(id),
  prompt_kind TEXT NOT NULL,
  phrase_id TEXT NOT NULL REFERENCES phrase(id),
  source_page_id TEXT REFERENCES phrase_page(id),
  source_section_id TEXT REFERENCES page_section(id),
  audio_usage_id TEXT REFERENCES audio_usage(id),
  relation_id TEXT REFERENCES phrase_relation(id),
  difficulty TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);
```

Local mutable progress belongs in an app-container database keyed by `practice_item.id` and `phrase_id`, with fields such as `seenCount`, `correctStreak`, `missedCount`, `lastSeenAt`, `nextDueAt`, and `lastResult`. That follows `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` while keeping bundled content read-only.

## Mapping Existing `family` To The Future Model

| Current concept | Future concept | Migration rule |
| --- | --- | --- |
| `family` | `phrase_cluster` | Keep the old ID as `source_family_id`; make it a grouping/relation unit. |
| `family.pageID` | `page_alias` or primary phrase `phrase_page.id` | Preserve route compatibility, but resolve to one canonical phrase page. |
| `primaryPhraseID` / `say-first` | primary `phrase` and primary `phrase_page` | Opening the old family routes to this page. |
| `variantRole` rows | first-class `phrase` plus cluster membership role | Variants can own pages and stay related to the primary phrase. |
| authored Tier 1 page | `phrase_page` with `completeness_status='deep'` or `support` | Keep article/listing sections as page-section rows. |
| generated fallback detail page | `phrase_page` with `completeness_status='baseline'` | Same renderer, lighter content, no lower-value UI language. |

Examples:

- `Cảm ơn` remains a phrase and page. `Cảm ơn nhiều` becomes a phrase and page if it carries a distinct teaching moment, while remaining a member of the gratitude cluster and related to `Cảm ơn`.
- Every saved phrase row, including `Cảm ơn nhiều` if it exists as an approved row, still receives a canonical phrase page. The "distinct teaching moment" decision only determines whether it gets richer authored sections or stays baseline/support at first.
- `Xin lỗi` should not become separate excuse-me and sorry pages unless the authored source explicitly creates separate sense keys. Otherwise, it is one phrase with multiple usage contexts.
- `Chào anh` has one canonical phrase page. Parent greeting pages, relationship pages, search rows, and practice prompts link to that page, not generated siblings with the same title.

## Phrase-Page Content Contract

The article/listing page pattern is the base page system for every phrase page.

Required page contract:

- every phrase is page-capable;
- every phrase page uses the article/listing renderer;
- completeness controls depth, not whether a page exists;
- renderable speaker controls require matching bundled audio; missing or mismatched audio belongs in the audit and should not render as playable;
- linked rows resolve to canonical page IDs;
- page sections are positive, traveler-facing, and action-oriented.

Preferred section labels:

- `At a glance`
- `Quick say`
- `Break it down`
- `Natural choices`
- `What you may hear`
- `Good to know`
- `Local tip`
- `Travel note`
- `Practice this`
- `Explore next`

Do not use negative `Watch out` framing in user-facing app copy. If an internal source still needs a caution flag, map it to positive labels such as `Good to know`, `Travel note`, or `Local tip` during generation. Keep safety and medical notes direct, but still frame them as helpful guidance.

## Staged Migration Plan

### Stage 0: Keep Current JSON Working

- Keep `native-ios/Resources/viet-phrase-catalog.json`, `viet-authored-listing-pages.json`, and `viet-audio-manifest.json` as the live native read path.
- Add the SQLite plan and follow-up tasks only. No runtime behavior changes.
- Add validators that compare current JSON counts against generated SQLite counts before any app loader changes.

### Stage 1: Generate A SQLite Fixture Beside JSON

Implementation note: T-163 created the first deterministic Viet fixture generator at `native-ios/scripts/generate-viet-sqlite-fixture.js`, the schema migration at `native-ios/scripts/sqlite/001_initial.sql`, and the generated outputs at `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite` plus `speaklocal-viet-report.json`. T-165 then added XcodeGen resource wiring so `Resources/LanguagePacks/` is copied as a folder resource and added a debug-only Swift read path that opens the Viet fixture read-only from `Bundle.main`. The app runtime still reads the root-level JSON resources.

Implementation note: the content-data universe pass on `2026-04-29` upgraded the fixture from one page per source row to canonical page resolution. The current generator keeps `919` source phrase rows, resolves them through `phrase.canonical_phrase_id` to `911` canonical `phrase_page` rows, aliases the `6` exact normalized duplicate Vietnamese groups, creates baseline/support sections for every canonical page, and populates `3,438` phrase-page relation edges from authored links, same-cluster variants, and generated category neighbors. `native-ios/scripts/validate-viet-sqlite-fixture.js` is now the direct validator for duplicate pages, broken graph links, sectionless pages, search targets, visible audio mismatches, and banned user-facing wording in generated/source listing JSON.

- Add a build-time script, probably under `native-ios/scripts/`, that reads the same source inputs as the JSON generators.
- Emit `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite` as a fixture, but do not ship it as the active runtime source yet.
- Create a schema migration folder with `001_initial.sql` and deterministic build output.
- Validate:
  - phrase count equals `919`;
  - source family count maps to `900` clusters;
  - all current authored pages map to canonical phrase pages or explicit aliases;
  - all `detailPageID` references resolve;
  - all speaker-visible rows resolve through `audio_usage`;
  - all `audio_usage` rows used for renderable speaker controls have matching normalized expected/spoken text;
  - every missing or mismatched speaker-target row appears in `missing_audio_audit` with target, source, reason, severity, and release-blocking status;
  - exact-text duplicate groups have decisions or audit entries.

### Stage 2: Swift Read Repository

Implementation note: T-165 added `VietSQLiteLanguagePackRepository` as a `#if DEBUG` proof path. It locates `LanguagePacks/viet/speaklocal-viet.sqlite` through `Bundle.main`, opens it with SQLite read-only flags, runs deterministic sanity queries, and maps a representative phrase row toward `PhraseCatalogItem` and `PhraseSearchResult`. This is validation/prototype infrastructure only; it does not replace the JSON loaders.

- Add a small read-only repository layer that opens the bundled SQLite database.
- Keep existing Swift models as the UI contract where possible: `PhraseDetailPage`, `PhraseArticlePage`, `PhraseCatalogItem`, `PhraseSearchResult`.
- Build mapping methods from SQLite rows to those models.
- Run this in parallel with JSON loaders behind a feature flag or debug switch.

### Stage 3: Search Path

- Move search to SQLite-backed exact/FTS/ranking queries.
- Compare search snapshots against current Swift search for known queries:
  - exact Vietnamese;
  - accentless Vietnamese;
  - pronunciation;
  - English;
  - aliases;
  - category terms;
  - related phrase terms.
- Keep a deterministic fixture test for ranking priority so flagship pages still surface ahead of weaker broad matches.

### Stage 4: Page Renderer Path

- Load article/listing sections from SQLite for the current `163` authored pages.
- Load baseline/support pages for all remaining catalog phrases through the same renderer contract.
- Replace user-facing `Watch out` labels with positive section labels during source or generation cleanup.
- Keep old page aliases so existing route IDs and deep links still open.

### Stage 5: Audio Manifest Migration

- Generate `audio_asset`, `audio_usage`, and `audio_text_dedupe` from the current manifest and authored-page audit.
- Make speaker rendering depend on `audio_usage`, not ad hoc key guessing.
- Keep a missing-audio audit for phrase rows, breakdown tokens, hero phrases, and practice prompts.

### Stage 6: Practice Integration

- Generate practice decks/items from phrase pages, relations, audio usages, and page sections.
- Store user progress in a separate local database keyed to bundled IDs.
- Do not let practice prompts expose phrases or audio combinations that fail graph/audio validation.

### Stage 7: Retire JSON Runtime Reads

- After simulator/device proof and search/page/audio parity pass, flip the runtime source to SQLite.
- Keep JSON generation for one release as a rollback artifact if needed.
- Once the SQLite path is stable, delete or demote JSON runtime resources in a dedicated cleanup task.

## Rollback Strategy

Rollback should be boring:

- keep current JSON resources and loaders intact until SQLite parity is proven;
- gate SQLite loading behind a config/build flag;
- make the SQLite generator deterministic so a bad database can be regenerated from source;
- fail closed to JSON if the SQLite database is missing or has a schema/content version mismatch during early rollout;
- keep route aliases so page IDs do not change during the transition.

Do not partially migrate search without page routing validation. Bad search-to-page identity is worse than slow JSON search because it creates duplicate-page confusion.

## Size And Performance Model

Current text resources are small:

| Resource | Current size |
| --- | ---: |
| Phrase catalog JSON | `1.29 MB` |
| Authored pages JSON | `1.27 MB` |
| Audio manifest JSON | `0.56 MB` |
| Authored audio audit JSON | `0.10 MB` |
| Total current JSON/audit surface | `3.23 MB` |
| Audio directory | about `65 MB` |

Rough growth model:

| Scale | Text/page data expectation | Search/index expectation | Audio expectation |
| --- | --- | --- | --- |
| Current `900` families / `919` rows / `163` rich pages | SQLite likely single-digit MB before FTS, based on current `3.23 MB` JSON surface | FTS and indexes may add another single-digit MB | Audio already dominates at about `65 MB` |
| `900+` phrase pages | Still comfortably small for SQLite; mostly a generator/identity problem | Needs FTS and exact-match tables for predictable search | Audio grows with new phrase/breakdown coverage |
| `10,000` phrase pages | Expect tens of MB for text/page rows depending on depth | Plan for roughly `1.5x` to `3x` text size once FTS and indexes are included; measure actual output | Could reach hundreds of MB if every phrase plus many breakdown tokens gets MP3 |

SQLite capacity is not the limiting factor. SQLite's own file format supports far larger databases than SpeakLocal needs, and the practical App Store uncompressed app-size limit is much higher than the current content footprint. The product risk is install/download size, launch time, and audio bloat. Generate an Xcode app thinning size report for release candidates and treat audio as the main size budget.

Performance expectations:

- open the bundled database lazily after launch-critical UI appears;
- use prepared statements for page, search, category, and audio lookups;
- add indexes for every foreign key used in page assembly;
- keep FTS updates build-time only for bundled content;
- keep mutable progress in a separate database so content reads stay read-only and cacheable;
- measure search and page-open latency on the oldest supported simulator/device before flipping runtime.

## Validation Gates

Generator validation:

- JSON parse/source validation still passes.
- SQLite schema migration applies from empty database.
- `PRAGMA integrity_check` returns `ok`.
- Counts match expected current truth:
  - `900` source families -> clusters;
  - `919` phrase rows -> phrases;
  - `163` authored pages -> canonical pages or aliases;
  - `18` scenarios -> scenarios.
- Every phrase has one phrase page.
- Every old `family.pageID`, authored page ID, and hand-coded page ID either is canonical or has a `page_alias`.
- Every `detailPageID` resolves to a canonical page.
- Every speaker-visible phrase/breakdown/hero/practice item either resolves to valid matching `audio_usage` / `audio_asset` rows or is excluded from renderable speaker controls and represented in `missing_audio_audit`.
- All `audio_usage` rows used for renderable speaker controls have `normalized_expected_text` matching `audio_asset.normalized_spoken_text`.
- Every missing or mismatched speaker-target row appears in `missing_audio_audit` with target, source, reason, severity, and release-blocking status.
- Exact normalized duplicate text groups are either merged, multi-context aliases, or explicit separate senses.

Runtime validation:

- Known search queries return expected top results and stable page IDs.
- Browse category counts match current app behavior where intended.
- The `Xin chào` flagship page renders from SQLite without visible regression.
- `Chào anh`-style routes resolve to one page per phrase.
- A premium phrase page can open offline after unlock state is applied.
- Practice deck generation only uses valid phrase/audio/page IDs.

Release validation:

- `git diff --check`.
- Generator unit tests.
- SQLite fixture validation.
- Swift read repository tests.
- Simulator smoke for home, browse, search, page open, back/forward, audio playback, and practice entrypoints.
- App thinning size report for any release candidate that bundles a much larger phrase/audio pack.

## Follow-Up Implementation Tasks

These are queue-ready task sketches, not auto-created queue packets. Each real `.agent/tasks/T-xxx/spec.md` should restate the outcome, allowed write scope, required checks, review gates, and recovery contract.

### 1. SQLite Schema And Viet Fixture Generator

Outcome: generate `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite` beside the current JSON resources without changing runtime behavior.

Write scope: new schema/generator files under `native-ios/scripts/`; generated SQLite fixture under `native-ios/Resources/LanguagePacks/viet/`; focused validation docs or task-local artifacts.

Dependencies: this plan; current `generate-viet-catalog.js`; current `generate-authored-tier-one-pages.js`; current root-level Viet JSON resources.

Required checks: deterministic generator rerun; `PRAGMA integrity_check`; count parity for `18` scenarios, `900` source families/clusters, `919` phrases, and `163` authored pages/aliases; `git diff --check`.

Done when: SQLite fixture is generated deterministically, current app runtime still reads JSON, and validation reports any unresolved polymorphic references.

### 2. Canonical Identity And Alias Audit

Outcome: resolve or explicitly classify exact-text duplicate groups, old route IDs, hand-coded pages, and variant relation semantics before runtime switches to SQLite.

Write scope: audit script/report under `native-ios/scripts/` or `docs/`; source-side alias/identity mapping files if introduced; no generated resource hand edits.

Dependencies: SQLite fixture schema; current `GeneratedVietContent.designedFamilyPageIDs`; authored listing page IDs; relation sidecar.

Required checks: every legacy `family.pageID`, authored page ID, hand-coded page ID, and `detailPageID` maps to exactly one canonical page or an explicit unresolved audit row; duplicate text groups are marked merge, multi-context, or separate-sense; `Chào anh`-style pages and `Cảm ơn` / `Cảm ơn nhiều` relation semantics are covered.

Done when: search, browse, related rows, practice source links, and aliases can all target one canonical page ID per phrase.

### 3. Audio Usage, Dedupe, And Missing-Audio Audit

Outcome: project `viet-audio-manifest.json` into `audio_asset`, `audio_usage`, `audio_text_dedupe`, and `missing_audio_audit` outputs.

Write scope: generator script/report files; generated SQLite fixture or sidecar reports; no MP3 generation in this task.

Dependencies: SQLite fixture generator; current audio manifest; authored audio audit; current speaker-icon behavior.

Required checks: renderable speaker controls require `audio_usage.normalized_expected_text == audio_asset.normalized_spoken_text`; missing/mismatched targets write audit rows with target, expected text, source, reason, severity, and release-blocking status; exact normalized text dedupe selects a preferred asset; `git diff --check`.

Done when: phrase rows, hero phrases, breakdown tokens, and practice-candidate audio can be validated without ad hoc Swift key guessing.

### 4. Swift Read-Only Repository Spike

Outcome: add a debug-gated Swift read path that opens bundled SQLite read-only and maps rows into existing UI contracts.

Write scope: new repository/adapter code under `native-ios/App/`; minimal XcodeGen/resource wiring if needed; tests. Do not remove JSON loaders.

Dependencies: generated SQLite fixture; canonical alias audit; audio usage audit.

Required checks: bundled DB opens read-only without runtime WAL sidecars; JSON remains default; `PhraseDetailPage`, `PhraseCatalogItem`, and `PhraseSearchResult` parity fixtures pass; simulator smoke proves fallback to JSON when SQLite is missing/version-mismatched.

Done when: a debug flag can switch selected reads to SQLite while release behavior remains unchanged.

### 5. SQLite Search Parity

Outcome: move search proof to SQLite exact/FTS/ranking queries behind the debug path.

Write scope: SQLite search query layer, fixture tests, deterministic generator normalization helpers, and task-local reports.

Dependencies: Swift read-only repository spike; canonical identity audit; deterministic accentless normalization.

Required checks: fixture queries cover exact Vietnamese, accentless Vietnamese, pronunciation, English, aliases, category terms, and related phrase terms; expected top page IDs are literal in tests; flagship/Tier priority remains intentional; latency is measured on simulator and at least one target older-device profile before release.

Done when: SQLite search matches or intentionally improves current Swift search without route duplication.

### 6. SQLite Page Renderer Migration

Outcome: render current authored and baseline phrase pages from SQLite through the article/listing renderer behind the debug path.

Write scope: SQLite page repository/adapter code, renderer mapping tests, generated fixture updates, and narrow content-label cleanup needed for rendering.

Dependencies: Swift read-only repository spike; canonical identity audit; audio usage audit.

Required checks: all `163` authored pages render; every remaining phrase has a baseline/support page; `Xin chào`, `Chào anh`, a premium page, and an unresolved-alias fixture are smoke-tested; linked rows resolve to canonical page IDs; speaker controls obey audio usage rules.

Done when: page rendering no longer depends on separate JSON and hand-coded identity paths in the debug lane.

### 7. Practice Deck Generator

Outcome: generate offline practice decks from phrase pages, relations, page sections, and audio usages while storing progress separately in local app state.

Write scope: practice generator scripts/resources, practice audio audit/report, validation tests, and native practice-read adapters if included in the task spec.

Dependencies: SQLite fixture; page renderer migration; audio usage audit; `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`.

Required checks: prompts reference valid `phrase`, `phrase_page`, `page_section`, `phrase_relation`, and `audio_usage` IDs; unresolved related pages or unsafe pronoun prompts are skipped with reasons; renderable speaker controls have matching audio; progress schema stays outside bundled SQLite; simulator smoke covers at least one page practice deck.

Done when: practice decks are deterministic, offline, source-linked, and release docs remain honest about what is and is not shipped.

### 8. Positive Section Label Cleanup

Outcome: remove remaining user-facing `Watch out` style labels from phrase-page output and map caution-like content to positive traveler-facing section labels.

Write scope: authored source and/or generator label mapping; tests/audits for rendered section titles; no unrelated copy rewrites.

Dependencies: can run before or alongside SQLite page renderer migration; should reuse the `speaklocal-listing-pages` standard.

Required checks: search rendered/native resources for `Watch out`; verify replacements such as `Good to know`, `Travel note`, or `Local tip`; ensure safety/medical copy stays direct while avoiding negative framing; `git diff --check`.

Done when: generated phrase pages no longer expose negative warning labels while preserving useful traveler guidance.

## Open Assumptions

- The first SQLite database should be per language pack, not one giant cross-language database. This matches the planned `Resources/LanguagePacks/<language>/` direction and keeps app variants clean.
- SQLite should be a read model generated from source files, not the source authoring format.
- Audio files remain separate bundled resources. The database stores metadata and lookup keys, not audio blobs.
- Practice progress remains local and mutable outside the bundled database.
- A future implementation may use GRDB or direct `sqlite3`; this plan intentionally defines the data boundary before choosing the Swift wrapper.

## Research Sources

- Apple Bundle Programming Guide, [About Bundles](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/AboutBundles/AboutBundles.html)
- Apple Bundle Programming Guide, [Bundle Structures](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html)
- Apple Bundle Programming Guide, [Accessing a Bundle's Contents](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/AccessingaBundlesContents/AccessingaBundlesContents.html)
- Apple App Store Connect Help, [Maximum build file sizes](https://developer.apple.com/help/app-store-connect/reference/app-uploads/maximum-build-file-sizes)
- Apple Xcode Help, [What is app thinning?](https://help.apple.com/xcode/mac/current/en.lproj/devbbdc5ce4f.html)
- SQLite, [Database File Format](https://www.sqlite.org/fileformat.html)
- SQLite, [FTS5 Extension](https://www.sqlite.org/fts5.html)
- SQLite, [WITHOUT ROWID Optimization](https://www.sqlite.org/withoutrowid.html)
