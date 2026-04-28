#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const audioManifestPath = path.join(nativeRoot, "Resources", "viet-audio-manifest.json");
const xcodeProjectPath = path.join(nativeRoot, "project.yml");
const schemaPath = path.join(__dirname, "sqlite", "001_initial.sql");
const outputDir = path.join(nativeRoot, "Resources", "LanguagePacks", "viet");
const databasePath = path.join(outputDir, "speaklocal-viet.sqlite");
const reportPath = path.join(outputDir, "speaklocal-viet-report.json");

const languagePackID = "viet";
const sourcePaths = {
  catalog: catalogPath,
  authoredPages: authoredPagesPath,
  audioManifest: audioManifestPath,
  xcodeProject: xcodeProjectPath,
  schema: schemaPath,
};

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalizeText(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase();
}

function accentlessText(value) {
  return normalizeText(value)
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d");
}

function sha256(value) {
  return crypto.createHash("sha256").update(value).digest("hex");
}

function shortHash(value) {
  return sha256(value).slice(0, 16);
}

function stableID(parts) {
  return shortHash(parts.map((part) => String(part ?? "")).join("\u0000"));
}

function relative(filePath) {
  return path.relative(repoRoot, filePath).replaceAll(path.sep, "/");
}

function sqlValue(value) {
  if (value === null || value === undefined) return "NULL";
  if (typeof value === "number") {
    if (!Number.isFinite(value)) return "NULL";
    return String(value);
  }
  if (typeof value === "boolean") return value ? "1" : "0";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function insertRows(table, columns, rows) {
  if (rows.length === 0) return "";
  return rows
    .map((row) => {
      const values = columns.map((column) => sqlValue(row[column])).join(", ");
      return `INSERT INTO ${table} (${columns.join(", ")}) VALUES (${values});`;
    })
    .join("\n");
}

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    cwd: repoRoot,
    encoding: "utf8",
    ...options,
  });

  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`);
  }

  return result.stdout.trim();
}

function sqliteQuery(sql) {
  return run("sqlite3", [databasePath, sql]);
}

function countBy(rows, key) {
  const groups = new Map();
  for (const row of rows) {
    const value = key(row);
    if (!groups.has(value)) groups.set(value, []);
    groups.get(value).push(row);
  }
  return groups;
}

function sortByID(rows) {
  return [...rows].sort((a, b) => String(a.id).localeCompare(String(b.id)));
}

function main() {
  const catalog = readJSON(catalogPath);
  const authoredBundle = readJSON(authoredPagesPath);
  const audioManifest = readJSON(audioManifestPath);
  const xcodeProject = fs.readFileSync(xcodeProjectPath, "utf8");
  const schema = fs.readFileSync(schemaPath, "utf8");
  const inputHash = sha256(
    [catalogPath, authoredPagesPath, audioManifestPath, schemaPath]
      .map((filePath) => `${relative(filePath)}\n${sha256(fs.readFileSync(filePath))}`)
      .join("\n")
  );
  const generatedAt = `source-hash:${inputHash.slice(0, 16)}`;
  const contentVersion = `viet-sqlite-fixture:${inputHash.slice(0, 16)}`;
  const languagePacksExcludedFromResources = /excludes:\s*(?:\n\s+- .*)*\n\s+- LanguagePacks/m.test(xcodeProject);

  const scenarioByID = new Map(catalog.scenarios.map((scenario) => [scenario.id, scenario]));
  const familyByID = new Map(catalog.families.map((family) => [family.id, family]));
  const phraseByID = new Map(catalog.phrases.map((phrase) => [phrase.id, phrase]));
  const authoredPages = authoredBundle.pages ?? [];
  const authoredPageByID = new Map(authoredPages.map((page) => [page.id, page]));
  const authoredPageByPhraseID = new Map();

  for (const page of authoredPages) {
    if (!authoredPageByPhraseID.has(page.phraseID)) {
      authoredPageByPhraseID.set(page.phraseID, page);
    }
  }

  const canonicalPageIDs = new Map(catalog.phrases.map((phrase) => [phrase.id, `viet-phrase-${phrase.id}`]));
  const aliases = new Map();
  const aliasConflicts = [];
  const unresolvedDetailPageRefs = [];
  const authoredPhraseItemsNotInCatalog = [];
  const authoredPagePhraseIDMissing = [];
  const categoryIDs = new Set();

  function canonicalPageIDForPhrase(phraseID) {
    return canonicalPageIDs.get(phraseID) ?? null;
  }

  function addAlias(aliasID, canonicalPageID, aliasKind, sourcePath) {
    if (!aliasID || !canonicalPageID) return;
    const existing = aliases.get(aliasID);
    if (existing) {
      if (existing.canonical_page_id !== canonicalPageID) {
        aliasConflicts.push({
          aliasID,
          firstCanonicalPageID: existing.canonical_page_id,
          nextCanonicalPageID: canonicalPageID,
          sourcePath,
        });
      }
      return;
    }

    aliases.set(aliasID, {
      alias_id: aliasID,
      canonical_page_id: canonicalPageID,
      alias_kind: aliasKind,
      source_path: sourcePath,
    });
  }

  for (const family of catalog.families) {
    addAlias(family.pageID, canonicalPageIDForPhrase(family.primaryPhraseID), "source-family-page", relative(catalogPath));
  }

  for (const page of authoredPages) {
    const canonicalPageID = canonicalPageIDForPhrase(page.phraseID);
    if (!canonicalPageID) {
      authoredPagePhraseIDMissing.push({ pageID: page.id, phraseID: page.phraseID });
      continue;
    }
    addAlias(page.id, canonicalPageID, "authored-page", relative(authoredPagesPath));
  }

  for (const page of authoredPages) {
    for (const categoryID of page.categoryIDs ?? []) categoryIDs.add(categoryID);
    for (const section of page.sections ?? []) {
      for (const phrase of section.phrases ?? []) {
        if (!phraseByID.has(phrase.id)) {
          authoredPhraseItemsNotInCatalog.push({
            pageID: page.id,
            sectionID: section.id,
            phraseID: phrase.id,
            detailPageID: phrase.detailPageID ?? null,
          });
          continue;
        }
        if (phrase.detailPageID) {
          addAlias(phrase.detailPageID, canonicalPageIDForPhrase(phrase.id), "section-detail-ref", relative(authoredPagesPath));
        }
      }
    }
  }

  for (const page of authoredPages) {
    for (const section of page.sections ?? []) {
      for (const phrase of section.phrases ?? []) {
        if (phrase.detailPageID && !canonicalPageIDs.has(phrase.id) && !aliases.has(phrase.detailPageID)) {
          unresolvedDetailPageRefs.push({
            pageID: page.id,
            sectionID: section.id,
            phraseID: phrase.id,
            detailPageID: phrase.detailPageID,
          });
        }
      }
    }
  }

  const phraseRows = catalog.phrases.map((phrase) => {
    const authoredPage = authoredPageByPhraseID.get(phrase.id);
    const family = familyByID.get(phrase.familyID);
    return {
      id: phrase.id,
      language_pack_id: languagePackID,
      canonical_phrase_key: phrase.id,
      target_text: phrase.targetText,
      normalized_target_text: normalizeText(phrase.targetText),
      accentless_target_text: accentlessText(phrase.targetText),
      english_text: phrase.englishText,
      pronunciation: phrase.pronunciation,
      access_tier: phrase.accessTier,
      completeness_status: authoredPage?.depth ?? ((family?.phraseIDs ?? []).length > 1 ? "support" : "baseline"),
      audio_status: phrase.audioStatus || "unknown",
      source_path: relative(catalogPath),
      source_row_id: phrase.id,
      sense_key: null,
    };
  });

  const pageRows = catalog.phrases.map((phrase) => {
    const authoredPage = authoredPageByPhraseID.get(phrase.id);
    const family = familyByID.get(phrase.familyID);
    const scenario = scenarioByID.get(phrase.scenarioID);
    return {
      id: canonicalPageIDForPhrase(phrase.id),
      language_pack_id: languagePackID,
      phrase_id: phrase.id,
      title: authoredPage?.title ?? phrase.targetText,
      english_title: authoredPage?.englishTitle ?? phrase.englishText,
      summary: authoredPage?.summary ?? family?.summary ?? phrase.context ?? phrase.englishText,
      icon_name: authoredPage?.iconName ?? scenario?.symbolName ?? "text.bubble.fill",
      tint_name: authoredPage?.tintName ?? scenario?.tintName ?? "gray",
      page_renderer: "article-listing",
      completeness_status: authoredPage?.depth ?? ((family?.phraseIDs ?? []).length > 1 ? "support" : "baseline"),
      is_authored: authoredPage ? 1 : 0,
    };
  });

  const sectionRows = [];
  const sectionItemRows = [];
  const breakdownRows = [];
  const pageCategoryRows = [];
  const usedSectionIDs = new Set();

  for (const page of authoredPages) {
    const canonicalPageID = canonicalPageIDForPhrase(page.phraseID);
    if (!canonicalPageID) continue;

    for (const [index, categoryID] of (page.categoryIDs ?? []).entries()) {
      pageCategoryRows.push({
        page_id: canonicalPageID,
        category_id: categoryID,
        sort_order: index,
        source_path: relative(authoredPagesPath),
      });
    }

    for (const [sectionIndex, section] of (page.sections ?? []).entries()) {
      const sectionID = `${canonicalPageID}:${section.id}`;
      usedSectionIDs.add(sectionID);
      sectionRows.push({
        id: sectionID,
        page_id: canonicalPageID,
        section_key: section.id,
        title: section.title,
        body: section.body ?? "",
        presentation: section.presentation ?? "plain-text",
        sort_order: sectionIndex,
        source_path: relative(authoredPagesPath),
      });

      let itemIndex = 0;
      for (const phrase of section.phrases ?? []) {
        const targetID = phraseByID.has(phrase.id) ? phrase.id : `authored:${phrase.id}`;
        sectionItemRows.push({
          id: `${sectionID}:phrase:${itemIndex}:${stableID([phrase.id, phrase.vietnamese, phrase.english])}`,
          section_id: sectionID,
          item_kind: phraseByID.has(phrase.id) ? "phrase" : "authored_phrase",
          target_id: targetID,
          title_override: phrase.vietnamese ?? null,
          subtitle_override: phrase.english ?? null,
          note: phrase.detailPageID ?? null,
          sort_order: itemIndex,
        });
        itemIndex += 1;
      }

      for (const token of section.breakdown ?? []) {
        const tokenID = `${sectionID}:breakdown:${token.id}`;
        breakdownRows.push({
          id: tokenID,
          phrase_id: page.phraseID,
          token_text: token.vietnamese,
          normalized_token_text: normalizeText(token.vietnamese),
          english_gloss: token.english ?? "",
          sort_order: itemIndex,
        });
        sectionItemRows.push({
          id: `${sectionID}:breakdown:${itemIndex}:${stableID([token.id, token.vietnamese, token.english])}`,
          section_id: sectionID,
          item_kind: "breakdown_token",
          target_id: tokenID,
          title_override: token.vietnamese ?? null,
          subtitle_override: token.english ?? null,
          note: null,
          sort_order: itemIndex,
        });
        itemIndex += 1;
      }
    }
  }

  const audioAssetRows = Object.entries(audioManifest)
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([key, entry]) => ({
      id: key,
      language_pack_id: languagePackID,
      file_name: entry.fileName,
      voice_id: null,
      duration_ms: null,
      normalized_spoken_text: normalizeText(entry.text),
      source_manifest_key: key,
    }));

  const audioUsageRows = [];
  const missingAudioRows = [];
  const seenAudioUsageIDs = new Set();

  function addAudioUsage({ usageKind, targetKind, targetID, expectedText, audioKey, isPrimary, sourcePath }) {
    const normalizedExpected = normalizeText(expectedText);
    const entry = audioManifest[audioKey];
    const resolved = Boolean(entry && normalizeText(entry.text) === normalizedExpected);
    if (!resolved) {
      missingAudioRows.push({
        id: `missing-audio:${stableID([usageKind, targetKind, targetID, expectedText, audioKey])}`,
        language_pack_id: languagePackID,
        target_kind: targetKind,
        target_id: targetID,
        expected_text: expectedText,
        normalized_expected_text: normalizedExpected,
        source_path: sourcePath,
        reason: entry ? "normalized-text-mismatch" : "missing-manifest-key",
        severity: "blocking",
        release_blocking: 1,
        suggested_audio_key: audioKey ?? null,
        created_at: generatedAt,
      });
      return;
    }

    let id = `audio-usage:${stableID([usageKind, targetKind, targetID, expectedText, audioKey])}`;
    let suffix = 1;
    while (seenAudioUsageIDs.has(id)) {
      id = `audio-usage:${stableID([usageKind, targetKind, targetID, expectedText, audioKey, suffix])}`;
      suffix += 1;
    }
    seenAudioUsageIDs.add(id);
    audioUsageRows.push({
      id,
      audio_asset_id: audioKey,
      usage_kind: usageKind,
      target_kind: targetKind,
      target_id: targetID,
      expected_text: expectedText,
      normalized_expected_text: normalizedExpected,
      is_primary: isPrimary ? 1 : 0,
      source_path: sourcePath,
    });
  }

  for (const phrase of catalog.phrases) {
    addAudioUsage({
      usageKind: "catalog-phrase",
      targetKind: "phrase",
      targetID: phrase.id,
      expectedText: phrase.targetText,
      audioKey: phrase.audioKey,
      isPrimary: phrase.variantRole === "say-first",
      sourcePath: relative(catalogPath),
    });
  }

  for (const page of authoredPages) {
    const canonicalPageID = canonicalPageIDForPhrase(page.phraseID);
    addAudioUsage({
      usageKind: "authored-hero",
      targetKind: "phrase_page",
      targetID: canonicalPageID,
      expectedText: page.title,
      audioKey: page.audioKey,
      isPrimary: 1,
      sourcePath: relative(authoredPagesPath),
    });

    for (const section of page.sections ?? []) {
      const sectionID = `${canonicalPageID}:${section.id}`;
      for (const phrase of section.phrases ?? []) {
        addAudioUsage({
          usageKind: "authored-section-phrase",
          targetKind: phraseByID.has(phrase.id) ? "phrase" : "authored_phrase",
          targetID: phraseByID.has(phrase.id) ? phrase.id : `authored:${phrase.id}`,
          expectedText: phrase.vietnamese,
          audioKey: phrase.audioKey,
          isPrimary: 0,
          sourcePath: relative(authoredPagesPath),
        });
      }
      for (const token of section.breakdown ?? []) {
        const tokenID = `${sectionID}:breakdown:${token.id}`;
        addAudioUsage({
          usageKind: "authored-breakdown-token",
          targetKind: "breakdown_token",
          targetID: tokenID,
          expectedText: token.vietnamese,
          audioKey: token.audioKey,
          isPrimary: 0,
          sourcePath: relative(authoredPagesPath),
        });
      }
    }
  }

  const audioTextDedupeRows = Array.from(countBy(audioAssetRows, (asset) => asset.normalized_spoken_text).entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([normalizedTextValue, assets]) => ({
      language_pack_id: languagePackID,
      normalized_text: normalizedTextValue,
      preferred_audio_asset_id: assets.map((asset) => asset.id).sort()[0],
      duplicate_count: assets.length,
    }));

  const searchRows = catalog.phrases.map((phrase, index) => {
    const page = authoredPageByPhraseID.get(phrase.id);
    const family = familyByID.get(phrase.familyID);
    const scenario = scenarioByID.get(phrase.scenarioID);
    const aliasText = [
      ...(phrase.searchAliases ?? []),
      family?.pageID,
      page?.id,
      ...Array.from(aliases.values())
        .filter((alias) => alias.canonical_page_id === canonicalPageIDForPhrase(phrase.id))
        .map((alias) => alias.alias_id),
    ]
      .filter(Boolean)
      .join(" ");
    return {
      rowid: index + 1,
      id: `search:${canonicalPageIDForPhrase(phrase.id)}`,
      language_pack_id: languagePackID,
      target_kind: "phrase_page",
      target_id: canonicalPageIDForPhrase(phrase.id),
      title_text: page?.title ?? phrase.targetText,
      target_text: phrase.targetText,
      accentless_target_text: accentlessText(phrase.targetText),
      pronunciation_text: phrase.pronunciation,
      english_text: phrase.englishText,
      alias_text: aliasText,
      category_text: [scenario?.title, family?.familyTitle, ...(page?.categoryIDs ?? [])].filter(Boolean).join(" "),
      related_text: [family?.summary, phrase.context, phrase.youMayHear].filter(Boolean).join(" "),
      priority_tier: page ? 100 : phrase.accessTier === "starter" ? 75 : 50,
      is_canonical_page: 1,
    };
  });

  const duplicateNormalizedTargetGroups = Array.from(countBy(catalog.phrases, (phrase) => normalizeText(phrase.targetText)).entries())
    .filter(([, phrases]) => phrases.length > 1)
    .map(([normalizedTargetText, phrases]) => ({
      normalizedTargetText,
      phraseIDs: phrases.map((phrase) => phrase.id).sort(),
    }))
    .sort((a, b) => a.normalizedTargetText.localeCompare(b.normalizedTargetText));

  const tableInserts = [
    insertRows("language_pack", ["id", "app_id", "language_code", "display_name", "content_version", "generated_at"], [{
      id: languagePackID,
      app_id: "speaklocal-vietnam",
      language_code: "vi",
      display_name: "Vietnamese",
      content_version: contentVersion,
      generated_at: generatedAt,
    }]),
    insertRows("scenario", ["id", "language_pack_id", "title", "traveler_label", "symbol_name", "tint_name", "sort_order"], catalog.scenarios.map((scenario, index) => ({
      id: scenario.id,
      language_pack_id: languagePackID,
      title: scenario.title,
      traveler_label: scenario.title,
      symbol_name: scenario.symbolName,
      tint_name: scenario.tintName,
      sort_order: index,
    }))),
    insertRows("phrase", ["id", "language_pack_id", "canonical_phrase_key", "target_text", "normalized_target_text", "accentless_target_text", "english_text", "pronunciation", "access_tier", "completeness_status", "audio_status", "source_path", "source_row_id", "sense_key"], phraseRows),
    insertRows("phrase_page", ["id", "language_pack_id", "phrase_id", "title", "english_title", "summary", "icon_name", "tint_name", "page_renderer", "completeness_status", "is_authored"], pageRows),
    insertRows("page_alias", ["alias_id", "canonical_page_id", "alias_kind", "source_path"], sortByID(Array.from(aliases.values()).map((alias) => ({ id: alias.alias_id, ...alias })))),
    insertRows("phrase_cluster", ["id", "language_pack_id", "cluster_kind", "title", "summary", "primary_phrase_id", "source_family_id", "source_path"], catalog.families.map((family) => ({
      id: family.id,
      language_pack_id: languagePackID,
      cluster_kind: "source-family",
      title: family.familyTitle,
      summary: family.summary,
      primary_phrase_id: family.primaryPhraseID,
      source_family_id: family.id,
      source_path: relative(catalogPath),
    }))),
    insertRows("phrase_cluster_member", ["cluster_id", "phrase_id", "role", "sort_order", "note"], catalog.families.flatMap((family) => (family.phraseIDs ?? []).map((phraseID, index) => {
      const phrase = phraseByID.get(phraseID);
      return {
        cluster_id: family.id,
        phrase_id: phraseID,
        role: phrase?.variantRole ?? "member",
        sort_order: index,
        note: phrase?.notes ?? null,
      };
    }))),
    insertRows("phrase_scenario", ["phrase_id", "scenario_id", "relevance", "sort_order"], catalog.phrases.map((phrase, index) => ({
      phrase_id: phrase.id,
      scenario_id: phrase.scenarioID,
      relevance: "primary",
      sort_order: index,
    }))),
    insertRows("cluster_scenario", ["cluster_id", "scenario_id", "relevance"], catalog.families.map((family) => ({
      cluster_id: family.id,
      scenario_id: family.scenarioID,
      relevance: "primary",
    }))),
    insertRows("page_category", ["page_id", "category_id", "sort_order", "source_path"], pageCategoryRows),
    insertRows("page_section", ["id", "page_id", "section_key", "title", "body", "presentation", "sort_order", "source_path"], sectionRows),
    insertRows("breakdown_token", ["id", "phrase_id", "token_text", "normalized_token_text", "english_gloss", "sort_order"], breakdownRows),
    insertRows("page_section_item", ["id", "section_id", "item_kind", "target_id", "title_override", "subtitle_override", "note", "sort_order"], sectionItemRows),
    insertRows("audio_asset", ["id", "language_pack_id", "file_name", "voice_id", "duration_ms", "normalized_spoken_text", "source_manifest_key"], audioAssetRows),
    insertRows("audio_usage", ["id", "audio_asset_id", "usage_kind", "target_kind", "target_id", "expected_text", "normalized_expected_text", "is_primary", "source_path"], audioUsageRows),
    insertRows("audio_text_dedupe", ["language_pack_id", "normalized_text", "preferred_audio_asset_id", "duplicate_count"], audioTextDedupeRows),
    insertRows("missing_audio_audit", ["id", "language_pack_id", "target_kind", "target_id", "expected_text", "normalized_expected_text", "source_path", "reason", "severity", "release_blocking", "suggested_audio_key", "created_at"], missingAudioRows),
    insertRows("search_document", ["rowid", "id", "language_pack_id", "target_kind", "target_id", "title_text", "target_text", "accentless_target_text", "pronunciation_text", "english_text", "alias_text", "category_text", "related_text", "priority_tier", "is_canonical_page"], searchRows),
  ].filter(Boolean);

  fs.mkdirSync(outputDir, { recursive: true });
  fs.rmSync(databasePath, { force: true });

  const sql = [
    "PRAGMA page_size = 4096;",
    "PRAGMA journal_mode = OFF;",
    "PRAGMA synchronous = OFF;",
    schema,
    "BEGIN;",
    ...tableInserts,
    "COMMIT;",
    "INSERT INTO search_document_fts(search_document_fts) VALUES('rebuild');",
    "VACUUM;",
  ].join("\n\n");

  run("sqlite3", [databasePath], { input: sql });

  const integrityCheck = sqliteQuery("PRAGMA integrity_check;");
  const foreignKeyRows = sqliteQuery("PRAGMA foreign_key_check;");
  if (integrityCheck !== "ok") {
    throw new Error(`SQLite integrity_check failed: ${integrityCheck}`);
  }
  if (foreignKeyRows) {
    throw new Error(`SQLite foreign_key_check failed:\n${foreignKeyRows}`);
  }

  const generatedCounts = JSON.parse(sqliteQuery(`SELECT json_object(
    'languagePacks', (SELECT count(*) FROM language_pack),
    'scenarios', (SELECT count(*) FROM scenario),
    'clusters', (SELECT count(*) FROM phrase_cluster),
    'clusterMembers', (SELECT count(*) FROM phrase_cluster_member),
    'phrases', (SELECT count(*) FROM phrase),
    'pages', (SELECT count(*) FROM phrase_page),
    'aliases', (SELECT count(*) FROM page_alias),
    'pageCategories', (SELECT count(*) FROM page_category),
    'sections', (SELECT count(*) FROM page_section),
    'sectionItems', (SELECT count(*) FROM page_section_item),
    'breakdownTokens', (SELECT count(*) FROM breakdown_token),
    'searchDocuments', (SELECT count(*) FROM search_document),
    'audioAssets', (SELECT count(*) FROM audio_asset),
    'audioUsages', (SELECT count(*) FROM audio_usage),
    'audioTextDedupeRows', (SELECT count(*) FROM audio_text_dedupe),
    'missingAudioAuditRows', (SELECT count(*) FROM missing_audio_audit)
  );`));

  const authoredPagesOrAliases = authoredPages.filter((page) => {
    const canonicalPageID = canonicalPageIDForPhrase(page.phraseID);
    return canonicalPageID === page.id || aliases.has(page.id);
  }).length;

  const report = {
    version: 1,
    languagePack: {
      id: languagePackID,
      appID: "speaklocal-vietnam",
      languageCode: "vi",
      contentVersion,
      generatedAt,
    },
    sourceInputs: Object.fromEntries(Object.entries(sourcePaths).map(([key, filePath]) => [
      key,
      {
        path: relative(filePath),
        sha256: sha256(fs.readFileSync(filePath)),
      },
    ])),
    outputs: {
      database: relative(databasePath),
      report: relative(reportPath),
      schema: relative(schemaPath),
      databaseSha256: sha256(fs.readFileSync(databasePath)),
      deterministicMode: "byte-for-byte recreated from sorted inserts and source-hash metadata",
    },
    bundlePackaging: {
      xcodeProjectPath: relative(xcodeProjectPath),
      resourcePath: relative(databasePath),
      isIncludedInXcodeResources: !languagePacksExcludedFromResources,
      status: languagePacksExcludedFromResources ? "generated-not-bundled" : "bundle-ready",
      requiredNextStep: languagePacksExcludedFromResources
        ? "Update native-ios/project.yml resource rules before opening this fixture with Bundle.main."
        : "",
    },
    countParity: {
      scenarios: { expected: 18, actual: catalog.scenarios.length, ok: catalog.scenarios.length === 18 },
      clusters: { expected: 900, actual: catalog.families.length, ok: catalog.families.length === 900 },
      phrases: { expected: 919, actual: catalog.phrases.length, ok: catalog.phrases.length === 919 },
      authoredPagesOrAliases: { expected: 163, actual: authoredPagesOrAliases, ok: authoredPagesOrAliases === 163 },
    },
    generatedCounts,
    validation: {
      integrityCheck,
      foreignKeyCheckRows: foreignKeyRows ? foreignKeyRows.split("\n").length : 0,
      ftsRowCount: Number(sqliteQuery("SELECT count(*) FROM search_document_fts;")),
    },
    unresolvedReferences: {
      detailPageIDCount: unresolvedDetailPageRefs.length,
      detailPageIDs: unresolvedDetailPageRefs,
      authoredPagePhraseIDMissingCount: authoredPagePhraseIDMissing.length,
      authoredPagePhraseIDMissing,
      authoredPhraseItemsNotInCatalogCount: authoredPhraseItemsNotInCatalog.length,
      authoredPhraseItemsNotInCatalog,
    },
    canonicalIdentityWarnings: {
      duplicateNormalizedTargetTextGroupCount: duplicateNormalizedTargetGroups.length,
      duplicateNormalizedTargetTextGroups: duplicateNormalizedTargetGroups,
      aliasConflictCount: aliasConflicts.length,
      aliasConflicts,
    },
    audio: {
      manifestEntries: Object.keys(audioManifest).length,
      uniqueNormalizedSpokenTextCount: audioTextDedupeRows.length,
      assets: audioAssetRows.length,
      usages: audioUsageRows.length,
      missingAudioAuditRows: missingAudioRows.length,
      missingAudioAuditSample: missingAudioRows.slice(0, 20),
    },
    categoryData: {
      authoredCategoryCount: categoryIDs.size,
      authoredCategoryIDs: Array.from(categoryIDs).sort(),
    },
    notes: [
      "The native Swift runtime still reads the existing root-level JSON resources.",
      "SQLite is generated as a bundled fixture under Resources/LanguagePacks/viet for migration proof only.",
      "All phrase rows receive canonical phrase_page rows; legacy family, authored page, and section detail IDs are represented as page_alias rows.",
      "The initial relation and practice tables are schema-ready but intentionally unpopulated in this fixture step.",
    ],
  };

  fs.writeFileSync(reportPath, `${JSON.stringify(report, null, 2)}\n`);

  console.log(`Wrote ${relative(databasePath)}`);
  console.log(`Wrote ${relative(reportPath)}`);
  console.log(`${generatedCounts.scenarios} scenarios, ${generatedCounts.clusters} clusters, ${generatedCounts.phrases} phrases, ${generatedCounts.pages} pages`);
  console.log(`SQLite integrity_check: ${integrityCheck}`);
}

main();
