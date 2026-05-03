PRAGMA foreign_keys = ON;

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

CREATE TABLE phrase_scenario (
  phrase_id TEXT NOT NULL REFERENCES phrase(id),
  scenario_id TEXT NOT NULL REFERENCES scenario(id),
  relevance TEXT NOT NULL DEFAULT 'primary',
  sort_order INTEGER NOT NULL,
  PRIMARY KEY(phrase_id, scenario_id)
);

CREATE TABLE city (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  title TEXT NOT NULL,
  short_title TEXT NOT NULL,
  vietnamese_name TEXT NOT NULL,
  emoji TEXT,
  source_ids TEXT NOT NULL
);

CREATE TABLE city_subcategory (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  title TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);

CREATE TABLE city_place (
  id TEXT PRIMARY KEY,
  city_id TEXT NOT NULL REFERENCES city(id),
  vietnamese_name TEXT NOT NULL,
  english_name TEXT NOT NULL,
  place_kind TEXT NOT NULL,
  content_role TEXT NOT NULL DEFAULT '',
  source_ids TEXT NOT NULL
);

CREATE TABLE phrase_city_tag (
  phrase_id TEXT PRIMARY KEY REFERENCES phrase(id),
  city_id TEXT NOT NULL REFERENCES city(id),
  subcategory_id TEXT NOT NULL REFERENCES city_subcategory(id),
  place_id TEXT NOT NULL REFERENCES city_place(id),
  difficulty TEXT NOT NULL,
  page_kind TEXT NOT NULL,
  place_kind TEXT NOT NULL DEFAULT '',
  content_role TEXT NOT NULL DEFAULT '',
  spoken_chunks INTEGER NOT NULL,
  source_ids TEXT NOT NULL,
  rationale TEXT NOT NULL
);

CREATE TABLE cluster_scenario (
  cluster_id TEXT NOT NULL REFERENCES phrase_cluster(id),
  scenario_id TEXT NOT NULL REFERENCES scenario(id),
  relevance TEXT NOT NULL DEFAULT 'primary',
  PRIMARY KEY(cluster_id, scenario_id)
);

CREATE TABLE page_category (
  page_id TEXT NOT NULL REFERENCES phrase_page(id),
  category_id TEXT NOT NULL,
  sort_order INTEGER NOT NULL,
  source_path TEXT NOT NULL,
  PRIMARY KEY(page_id, category_id)
);

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

CREATE TABLE breakdown_token (
  id TEXT PRIMARY KEY,
  phrase_id TEXT NOT NULL REFERENCES phrase(id),
  token_text TEXT NOT NULL,
  normalized_token_text TEXT NOT NULL,
  english_gloss TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);

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

CREATE TABLE audio_asset (
  id TEXT PRIMARY KEY,
  language_pack_id TEXT NOT NULL REFERENCES language_pack(id),
  file_name TEXT NOT NULL,
  voice_id TEXT,
  duration_ms INTEGER,
  normalized_spoken_text TEXT NOT NULL,
  source_manifest_key TEXT NOT NULL UNIQUE
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

CREATE INDEX idx_phrase_family_key ON phrase(language_pack_id, canonical_phrase_key);
CREATE INDEX idx_phrase_canonical_phrase ON phrase(canonical_phrase_id);
CREATE INDEX idx_phrase_city_tag_city ON phrase_city_tag(city_id, subcategory_id, difficulty);
CREATE INDEX idx_city_place_city ON city_place(city_id);
CREATE INDEX idx_phrase_page_phrase ON phrase_page(phrase_id);
CREATE INDEX idx_page_alias_canonical ON page_alias(canonical_page_id);
CREATE INDEX idx_phrase_cluster_source_family ON phrase_cluster(source_family_id);
CREATE INDEX idx_page_section_page ON page_section(page_id, sort_order);
CREATE INDEX idx_page_section_item_section ON page_section_item(section_id, sort_order);
CREATE INDEX idx_phrase_relation_source ON phrase_relation(source_kind, source_id, sort_order);
CREATE INDEX idx_phrase_relation_target ON phrase_relation(target_kind, target_id);
CREATE INDEX idx_audio_usage_target ON audio_usage(target_kind, target_id);
CREATE INDEX idx_search_document_target ON search_document(target_kind, target_id);
