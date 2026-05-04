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
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const plannedMissingAudioQueuePath = path.join(repoRoot, "docs", "audio-queues", "viet-planned-missing-audio.csv");
const outputDir = path.join(nativeRoot, "Resources", "LanguagePacks", "viet");
const databasePath = path.join(outputDir, "speaklocal-viet.sqlite");
const reportPath = path.join(outputDir, "speaklocal-viet-report.json");

const languagePackID = "viet";
const relationshipWordSectionKey = "relationship-words";
const relationshipWordPhraseIDs = [
  "hello-chao-anh",
  "hello-chao-chi",
  "hello-chao-em",
  "hello-chao-ong",
  "hello-chao-ba",
  "hello-chao-chu",
  "hello-chao-co",
];
const relationshipWordTokens = new Set(["anh", "chị", "em", "ông", "bà", "chú", "cô"]);
const greetingCategoryIDs = new Set(["greetings", "polite-basics"]);
const baNaJourneyPageID = "viet-phrase-city-danang-place-ba-na-hills";
const approvedQuickSayShortcutPairs = [
  ["viet-phrase-city-danang-place-ba-na-hills", "viet-phrase-ves-two-tickets-ba-na-hills"],
  ["viet-phrase-city-danang-place-marble-mountains", "viet-phrase-city-danang-ticket-marble-mountains"],
  ["viet-phrase-city-danang-place-son-tra", "viet-phrase-city-danang-go-son-tra"],
  ["viet-phrase-city-hanoi-place-bun-cha-huong-lien", "viet-phrase-ves-order-bun-cha-portion"],
  ["viet-phrase-city-hanoi-place-pho-bat-dan", "viet-phrase-ves-order-pho-bowl"],
  ["viet-phrase-city-hue-place-bun-bo-city", "viet-phrase-ves-order-bun-bo-hue-bowl"],
];
const legacyNativePageAliases = [
  { aliasID: "viet-hello-anh", phraseID: "hello-chao-anh" },
  { aliasID: "viet-hello-chi", phraseID: "hello-chao-chi" },
  { aliasID: "viet-hello-em", phraseID: "hello-chao-em" },
  { aliasID: "viet-hello-ong", phraseID: "hello-chao-ong" },
  { aliasID: "viet-hello-ba", phraseID: "hello-chao-ba" },
  { aliasID: "viet-hello-chu", phraseID: "hello-chao-chu" },
  { aliasID: "viet-hello-co", phraseID: "hello-chao-co" },
  { aliasID: "viet-respectful-hello", phraseID: "hello-da-chao-anh-chi" },
  { aliasID: "viet-phone-hello", phraseID: "hello-alo" },
  { aliasID: "viet-where-going", phraseID: "smalltalk-di-dau-day" },
  { aliasID: "viet-nice-to-meet-you", phraseID: "smalltalk-nice-to-meet-you" },
  { aliasID: "viet-hello-anh-way-respectful", phraseID: "acknowledge-da-chao-anh" },
  { aliasID: "viet-hello-chi-way-respectful", phraseID: "acknowledge-da-chao-chi" },
  { aliasID: "viet-hello-ong-way-respectful", phraseID: "acknowledge-da-chao-ong" },
  { aliasID: "viet-hello-ba-way-respectful", phraseID: "acknowledge-da-chao-ba" },
  { aliasID: "viet-hello-chu-way-respectful", phraseID: "acknowledge-da-chao-chu" },
  { aliasID: "viet-hello-co-way-respectful", phraseID: "acknowledge-da-chao-co" },
];
const sourcePaths = {
  catalog: catalogPath,
  authoredPages: authoredPagesPath,
  audioManifest: audioManifestPath,
  xcodeProject: xcodeProjectPath,
  schema: schemaPath,
  cityLibrary: cityLibraryPath,
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

function csvCell(value) {
  return `"${String(value ?? "").replace(/"/g, "\"\"")}"`;
}

function writePlannedMissingAudioQueue(missingAudioRows) {
  const rows = [
    [
      "normalized_text",
      "expected_text",
      "usage_count",
      "suggested_audio_key",
      "target_kinds",
      "target_ids",
      "source_paths",
      "severity",
      "release_blocking",
      "reasons",
    ],
  ];
  const groups = new Map();

  for (const row of missingAudioRows) {
    const normalized = row.normalized_expected_text;
    if (!groups.has(normalized)) {
      groups.set(normalized, {
        expectedText: row.expected_text,
        normalized,
        usageCount: 0,
        suggestedAudioKey: row.suggested_audio_key ?? "",
        targetKinds: new Set(),
        targetIDs: new Set(),
        sourcePaths: new Set(),
        severities: new Set(),
        releaseBlocking: 0,
        reasons: new Set(),
      });
    }
    const group = groups.get(normalized);
    group.usageCount += 1;
    group.targetKinds.add(row.target_kind);
    group.targetIDs.add(row.target_id);
    group.sourcePaths.add(row.source_path);
    group.severities.add(row.severity);
    group.releaseBlocking = Math.max(group.releaseBlocking, Number(row.release_blocking ?? 0));
    group.reasons.add(row.reason);
    if (!group.suggestedAudioKey && row.suggested_audio_key) {
      group.suggestedAudioKey = row.suggested_audio_key;
    }
  }

  rows.push(...Array.from(groups.values())
    .sort((a, b) => a.normalized.localeCompare(b.normalized))
    .map((group) => [
      group.normalized,
      group.expectedText,
      String(group.usageCount),
      group.suggestedAudioKey,
      Array.from(group.targetKinds).sort().join("|"),
      Array.from(group.targetIDs).sort().join("|"),
      Array.from(group.sourcePaths).sort().join("|"),
      Array.from(group.severities).sort().join("|"),
      String(group.releaseBlocking),
      Array.from(group.reasons).sort().join("|"),
    ]));

  fs.mkdirSync(path.dirname(plannedMissingAudioQueuePath), { recursive: true });
  fs.writeFileSync(plannedMissingAudioQueuePath, `${rows.map((row) => row.map(csvCell).join(",")).join("\n")}\n`);
  return groups.size;
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
  const cityLibrary = fs.existsSync(cityLibraryPath) ? readJSON(cityLibraryPath) : null;
  const xcodeProject = fs.readFileSync(xcodeProjectPath, "utf8");
  const schema = fs.readFileSync(schemaPath, "utf8");
  const inputHash = sha256(
    [catalogPath, authoredPagesPath, audioManifestPath, schemaPath, ...(cityLibrary ? [cityLibraryPath] : [])]
      .map((filePath) => `${relative(filePath)}\n${sha256(fs.readFileSync(filePath))}`)
      .join("\n")
  );
  const generatedAt = `source-hash:${inputHash.slice(0, 16)}`;
  const contentVersion = `viet-sqlite-fixture:${inputHash.slice(0, 16)}`;
  const languagePacksExcludedFromBroadResources = /excludes:\s*(?:\n\s+- .*)*\n\s+- LanguagePacks/m.test(xcodeProject);
  const languagePacksExplicitlyIncluded = /-\s+path:\s*Resources\/LanguagePacks\b/m.test(xcodeProject);
  const languagePacksIncludedInXcodeResources =
    languagePacksExplicitlyIncluded || !languagePacksExcludedFromBroadResources;

  const scenarioByID = new Map(catalog.scenarios.map((scenario) => [scenario.id, scenario]));
  const familyByID = new Map(catalog.families.map((family) => [family.id, family]));
  const phraseByID = new Map(catalog.phrases.map((phrase) => [phrase.id, phrase]));
  const relationshipWordPhrases = relationshipWordPhraseIDs.map((phraseID) => {
    const phrase = phraseByID.get(phraseID);
    if (!phrase) {
      throw new Error(`Missing required relationship-word phrase ${phraseID}`);
    }
    return phrase;
  });
  const authoredPages = authoredBundle.pages ?? [];
  const cityLibraryPages = (cityLibrary?.pages ?? []).filter((page) => page.status === "approved");
  const cityLibraryPageByPhraseID = new Map(cityLibraryPages.map((page) => [page.id, page]));
  const cityLibraryPhraseIDs = new Set(cityLibraryPages.map((page) => page.id));
  const authoredPageByID = new Map(authoredPages.map((page) => [page.id, page]));
  const authoredPageByPhraseID = new Map();

  for (const page of authoredPages) {
    if (!authoredPageByPhraseID.has(page.phraseID)) {
      authoredPageByPhraseID.set(page.phraseID, page);
    }
  }

  const phraseOrderByID = new Map(catalog.phrases.map((phrase, index) => [phrase.id, index]));
  const normalizedPhraseGroups = Array.from(countBy(catalog.phrases, (phrase) => normalizeText(phrase.targetText)).entries())
    .sort(([a], [b]) => a.localeCompare(b));
  const canonicalPhraseIDByPhraseID = new Map();

  function phraseCanonicalSort(a, b) {
    const aHasAuthoredPage = authoredPageByPhraseID.has(a.id) ? 0 : 1;
    const bHasAuthoredPage = authoredPageByPhraseID.has(b.id) ? 0 : 1;
    if (aHasAuthoredPage !== bHasAuthoredPage) return aHasAuthoredPage - bHasAuthoredPage;

    const aIsSayFirst = a.variantRole === "say-first" ? 0 : 1;
    const bIsSayFirst = b.variantRole === "say-first" ? 0 : 1;
    if (aIsSayFirst !== bIsSayFirst) return aIsSayFirst - bIsSayFirst;

    const aIsStarter = a.accessTier === "starter" ? 0 : 1;
    const bIsStarter = b.accessTier === "starter" ? 0 : 1;
    if (aIsStarter !== bIsStarter) return aIsStarter - bIsStarter;

    return (phraseOrderByID.get(a.id) ?? 0) - (phraseOrderByID.get(b.id) ?? 0);
  }

  for (const [, phrases] of normalizedPhraseGroups) {
    const canonicalPhrase = [...phrases].sort(phraseCanonicalSort)[0];
    for (const phrase of phrases) {
      canonicalPhraseIDByPhraseID.set(phrase.id, canonicalPhrase.id);
    }
  }

  const canonicalPhraseIDByNormalizedTargetText = new Map(
    normalizedPhraseGroups.map(([normalizedTargetText, phrases]) => [
      normalizedTargetText,
      canonicalPhraseIDByPhraseID.get(phrases[0].id),
    ])
  );

  const canonicalPhraseIDs = new Set(canonicalPhraseIDByPhraseID.values());
  const duplicateNormalizedTargetGroups = normalizedPhraseGroups
    .filter(([, phrases]) => phrases.length > 1)
    .map(([normalizedTargetText, phrases]) => {
      const sortedPhraseIDs = phrases.map((phrase) => phrase.id).sort();
      const canonicalPhraseID = canonicalPhraseIDByPhraseID.get(phrases[0].id);
      return {
        normalizedTargetText,
        canonicalPhraseID,
        canonicalPageID: `viet-phrase-${canonicalPhraseID}`,
        phraseIDs: sortedPhraseIDs,
        aliasedPhraseIDs: sortedPhraseIDs.filter((phraseID) => phraseID !== canonicalPhraseID),
      };
    })
    .sort((a, b) => a.normalizedTargetText.localeCompare(b.normalizedTargetText));

  const aliases = new Map();
  const aliasConflicts = [];
  const unresolvedDetailPageRefs = [];
  const authoredPhraseItemsNotInCatalog = [];
  const authoredPagePhraseIDMissing = [];
  const categoryIDs = new Set();

  function sourcePageIDForPhrase(phraseID) {
    return `viet-phrase-${phraseID}`;
  }

  function canonicalPhraseIDForPhrase(phraseID) {
    return canonicalPhraseIDByPhraseID.get(phraseID) ?? null;
  }

  function canonicalPageIDForPhrase(phraseID) {
    const canonicalPhraseID = canonicalPhraseIDForPhrase(phraseID);
    return canonicalPhraseID ? sourcePageIDForPhrase(canonicalPhraseID) : null;
  }

  function resolvedCatalogPhraseIDForAuthoredPhrase(phrase) {
    if (phraseByID.has(phrase.id)) return phrase.id;
    const normalizedVietnamese = normalizeText(phrase.vietnamese);
    return canonicalPhraseIDByNormalizedTargetText.get(normalizedVietnamese) ?? null;
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

  for (const phrase of catalog.phrases) {
    const sourcePageID = sourcePageIDForPhrase(phrase.id);
    const canonicalPageID = canonicalPageIDForPhrase(phrase.id);
    if (sourcePageID !== canonicalPageID) {
      addAlias(sourcePageID, canonicalPageID, "duplicate-phrase-page", relative(catalogPath));
    }
  }

  for (const { aliasID, phraseID } of legacyNativePageAliases) {
    addAlias(
      aliasID,
      canonicalPageIDForPhrase(phraseID),
      "legacy-native-page",
      "native-ios/App/Models/PhrasePage.swift"
    );
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
        const resolvedPhraseID = resolvedCatalogPhraseIDForAuthoredPhrase(phrase);
        if (!resolvedPhraseID) {
          authoredPhraseItemsNotInCatalog.push({
            pageID: page.id,
            sectionID: section.id,
            phraseID: phrase.id,
            vietnamese: phrase.vietnamese ?? null,
            detailPageID: phrase.detailPageID ?? null,
          });
          continue;
        }
        if (phrase.detailPageID) {
          addAlias(phrase.detailPageID, canonicalPageIDForPhrase(resolvedPhraseID), "section-detail-ref", relative(authoredPagesPath));
        }
      }
    }
  }

  for (const page of authoredPages) {
    for (const section of page.sections ?? []) {
      for (const phrase of section.phrases ?? []) {
        const resolvedPhraseID = resolvedCatalogPhraseIDForAuthoredPhrase(phrase);
        if (phrase.detailPageID && !resolvedPhraseID && !aliases.has(phrase.detailPageID)) {
          unresolvedDetailPageRefs.push({
            pageID: page.id,
            sectionID: section.id,
            phraseID: phrase.id,
            vietnamese: phrase.vietnamese ?? null,
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
      canonical_phrase_id: canonicalPhraseIDForPhrase(phrase.id),
      target_text: phrase.targetText,
      normalized_target_text: normalizeText(phrase.targetText),
      accentless_target_text: accentlessText(phrase.targetText),
      english_text: phrase.englishText,
      pronunciation: phrase.pronunciation,
      access_tier: phrase.accessTier,
      completeness_status: "deep",
      audio_status: phrase.audioStatus || "unknown",
      source_path: relative(catalogPath),
      source_row_id: phrase.id,
      sense_key: null,
    };
  });

  const canonicalPhrases = catalog.phrases.filter((phrase) => canonicalPhraseIDs.has(phrase.id));
  const pageRows = canonicalPhrases.map((phrase) => {
    const authoredPage = authoredPageByPhraseID.get(phrase.id);
    const family = familyByID.get(phrase.familyID);
    const scenario = scenarioByID.get(phrase.scenarioID);
    return {
      id: canonicalPageIDForPhrase(phrase.id),
      language_pack_id: languagePackID,
      phrase_id: phrase.id,
      title: authoredPage?.title ?? phrase.targetText,
      english_title: phrase.englishText,
      summary: pageSummaryForPhrase(phrase, authoredPage, family),
      icon_name: authoredPage?.iconName ?? scenario?.symbolName ?? "text.bubble.fill",
      tint_name: authoredPage?.tintName ?? scenario?.tintName ?? "gray",
      hero_image_name: authoredPage?.heroImageName ?? null,
      page_renderer: "article-listing",
      completeness_status: "deep",
      is_authored: authoredPage ? 1 : 0,
    };
  });
  const cityCanonicalPageIDs = new Set(
    cityLibraryPages
      .map((page) => canonicalPageIDForPhrase(page.id))
      .filter(Boolean)
  );
  const plannedAudioPhraseIDs = new Set(
    catalog.phrases
      .filter((phrase) => phrase.audioStatus === "planned")
      .map((phrase) => phrase.id)
  );
  const plannedAudioCanonicalPageIDs = new Set(
    Array.from(plannedAudioPhraseIDs)
      .map((phraseID) => canonicalPageIDForPhrase(phraseID))
      .filter(Boolean)
  );
  const cityRows = (cityLibrary?.cities ?? []).map((city) => ({
    id: city.id,
    language_pack_id: languagePackID,
    title: city.title,
    short_title: city.shortTitle,
    vietnamese_name: city.vietnameseName,
    emoji: city.emoji ?? null,
    source_ids: (city.sourceIDs ?? []).join("|"),
  }));
  const citySubcategoryRows = (cityLibrary?.subcategories ?? []).map((subcategory, index) => ({
    id: subcategory.id,
    language_pack_id: languagePackID,
    title: subcategory.title,
    sort_order: index,
  }));
  const cityPlaceRows = (cityLibrary?.places ?? []).map((place) => ({
    id: place.id,
    city_id: place.cityID,
    vietnamese_name: place.vietnameseName,
    english_name: place.englishName,
    place_kind: place.placeKind ?? place.kind,
    content_role: place.contentRole ?? "",
    source_ids: (place.sourceIDs ?? []).join("|"),
  }));
  const phraseCityTagRows = cityLibraryPages.map((page) => ({
    phrase_id: page.id,
    city_id: page.cityID,
    subcategory_id: page.subcategoryID,
    place_id: page.placeID,
    difficulty: page.difficulty,
    page_kind: page.pageKind ?? page.kind,
    place_kind: page.placeKind ?? "",
    content_role: page.contentRole ?? "",
    spoken_chunks: Number(page.spokenChunks ?? 0),
    source_ids: (page.sourceIDs ?? []).join("|"),
    rationale: page.rationale,
  }));

  const sectionRows = [];
  const sectionItemRows = [];
  const breakdownRows = [];
  const pageCategoryRows = [];
  const relationRows = [];
  const usedSectionIDs = new Set();
  const pageCategoryKeys = new Set();
  const relationKeys = new Set();
  const pagePhraseTargetKeys = new Map();

  function phraseTargetKey(pageID, targetID, note = null) {
    if (note) return note;
    if (targetID && phraseByID.has(targetID)) return canonicalPageIDForPhrase(targetID) ?? targetID;
    return targetID ? `${pageID}:${targetID}` : null;
  }

  function hasPagePhraseTarget(pageID, targetID, note = null) {
    const key = phraseTargetKey(pageID, targetID, note);
    return key ? (pagePhraseTargetKeys.get(pageID)?.has(key) ?? false) : false;
  }

  function claimPagePhraseTarget(pageID, targetID, note = null) {
    const key = phraseTargetKey(pageID, targetID, note);
    if (!key) return true;
    if (!pagePhraseTargetKeys.has(pageID)) {
      pagePhraseTargetKeys.set(pageID, new Set());
    }
    const pageKeys = pagePhraseTargetKeys.get(pageID);
    if (pageKeys.has(key)) return false;
    pageKeys.add(key);
    return true;
  }

  function addPageCategory(pageID, categoryID, sortOrder, sourcePath) {
    if (!pageID || !categoryID) return;
    const key = `${pageID}\u0000${categoryID}`;
    if (pageCategoryKeys.has(key)) return;
    pageCategoryKeys.add(key);
    pageCategoryRows.push({
      page_id: pageID,
      category_id: categoryID,
      sort_order: sortOrder,
      source_path: sourcePath,
    });
  }

  function sentence(value) {
    const text = String(value ?? "").trim();
    if (!text) return "";
    return /[.!?]$/.test(text) ? text : `${text}.`;
  }

  function scenarioTitle(scenarioID) {
    return scenarioByID.get(scenarioID)?.title ?? "Vietnam travel";
  }

  function vietnameseWordTokens(value) {
    return Array.from(String(value ?? "").toLowerCase().matchAll(/\p{L}+/gu), (match) => match[0]);
  }

  function shouldShowRelationshipWordsSection(phrase, authoredPage = null) {
    if (!phrase) return false;
    const cityPageKind = authoredPage?.cityMetadata?.pageKind
      ?? cityLibraryPageByPhraseID.get(phrase.id)?.pageKind
      ?? "";
    if (["place", "restaurant", "dish", "city", "category"].includes(cityPageKind)) {
      return false;
    }
    if (relationshipWordPhraseIDs.includes(phrase.id)) return true;

    const targetTokens = vietnameseWordTokens(phrase.targetText);
    if (targetTokens.some((token) => relationshipWordTokens.has(token))) return true;

    const accentlessTarget = accentlessText(phrase.targetText);
    if (accentlessTarget.split(/\s+/).includes("chao")) return true;

    const englishSignal = normalizeText([
      phrase.englishText,
      phrase.context,
      ...(phrase.searchAliases ?? []),
      authoredPage?.summary,
      ...(authoredPage?.sections ?? []).flatMap((section) => [section.title, section.body]),
    ].filter(Boolean).join(" "));

    const authoredCategories = new Set(authoredPage?.categoryIDs ?? []);
    const isGreetingCategory = greetingCategoryIDs.has(phrase.scenarioID)
      || Array.from(authoredCategories).some((categoryID) => greetingCategoryIDs.has(categoryID));

    return isGreetingCategory && /\b(hello|hi|greeting|greet)\b/.test(englishSignal);
  }

  function baselineContextBody(phrase, family) {
    const context = sentence(phrase.context);
    if (context) return context;
    const summary = sentence(family?.summary);
    if (summary) return summary;
    return `${phrase.targetText} is the phrase to keep ready for "${phrase.englishText}" in ${scenarioTitle(phrase.scenarioID)}.`;
  }

  function pageSummaryForPhrase(phrase, authoredPage, family) {
    if (authoredPage?.summary && !internalAuthoringSummary(authoredPage.summary)) return authoredPage.summary;
    const summary = sentence(family?.summary);
    if (summary && !/^use this when\b/i.test(summary) && !internalAuthoringSummary(summary)) return summary;
    return travelerFacingSummary(phrase);
  }

  function internalAuthoringSummary(value) {
    return /\bDifferent ways\b/i.test(String(value ?? ""));
  }

  function travelerFacingSummary(phrase) {
    const english = String(phrase.englishText ?? "").trim();
    const target = String(phrase.targetText ?? "").trim();
    if (english.endsWith("?")) {
      return `Ask "${english}" with ${target}, then use the notes below to understand likely replies and next steps.`;
    }
    if (/^(hello|hi|goodbye|thank|thanks|sorry|excuse me|yes|no|okay|it.?s okay)\b/i.test(english)) {
      return `Start with ${target} for "${english}", then use the notes below to choose the warmer local form.`;
    }
    return `Say "${english}" with ${target}, then use the notes below to adjust tone and next steps.`;
  }

  function scenarioNeighborPhrases(phrase, limit = 3) {
    const family = familyByID.get(phrase.familyID);
    const familyPhraseIDs = (family?.phraseIDs ?? []).filter((phraseID) => phraseID !== phrase.id);
    const scenarioFamilies = catalog.families.filter((candidate) => candidate.scenarioID === phrase.scenarioID);
    const familyIndex = scenarioFamilies.findIndex((candidate) => candidate.id === phrase.familyID);
    const neighborFamilyPhraseIDs = [];
    for (let offset = 1; offset <= Math.max(limit + 2, 5); offset += 1) {
      neighborFamilyPhraseIDs.push(
        scenarioFamilies[familyIndex + offset]?.primaryPhraseID,
        scenarioFamilies[familyIndex - offset]?.primaryPhraseID
      );
    }
    const seen = new Set();
    return [...familyPhraseIDs, ...neighborFamilyPhraseIDs]
      .filter(Boolean)
      .filter((phraseID) => {
        const targetPhrase = phraseByID.get(phraseID);
        const canonicalPageID = canonicalPageIDForPhrase(phraseID);
        if (!targetPhrase || !canonicalPageID || canonicalPageID === canonicalPageIDForPhrase(phrase.id)) return false;
        if (seen.has(canonicalPageID)) return false;
        seen.add(canonicalPageID);
        return true;
      })
      .slice(0, limit)
      .map((phraseID) => phraseByID.get(phraseID));
  }

  function broaderFallbackPhrases(phrase, limit = 12) {
    const currentPageID = canonicalPageIDForPhrase(phrase.id);
    const preferredScenarioIDs = [
      phrase.scenarioID,
      "directions-navigation",
      "polite-basics",
      "problems-help",
      "money-numbers-prices",
      "phone-internet-power",
    ];
    const seen = new Set([currentPageID]);
    return catalog.phrases
      .filter((candidate) => canonicalPhraseIDs.has(candidate.id))
      .filter((candidate) => preferredScenarioIDs.includes(candidate.scenarioID))
      .filter((candidate) => {
        const pageID = canonicalPageIDForPhrase(candidate.id);
        if (!pageID || seen.has(pageID)) return false;
        seen.add(pageID);
        return true;
      })
      .slice(0, limit);
  }

  function normalizedVietnameseKey(value) {
    return accentlessText(value)
      .replace(/[^a-z0-9/]+/g, " ")
      .trim()
      .replace(/\s+/g, " ");
  }

  const preferredBreakdownChunks = new Set([
    "anh/chi",
    "anh chi",
    "bac si",
    "bao lau",
    "bao nhieu",
    "buu dien",
    "ca phe",
    "ca phe den",
    "ca phe sua",
    "cam thay",
    "cam on",
    "cho hoi",
    "cho toi",
    "co ban",
    "co the",
    "cua toi",
    "dat tour",
    "da xay ra",
    "di bo",
    "di thang",
    "dien thoai",
    "duoc khong",
    "gan nhat",
    "giam gia",
    "giup toi",
    "hanh ly",
    "ho chieu",
    "giay ve sinh",
    "it cay",
    "khach san",
    "khong duong",
    "khong sao",
    "khu don",
    "lam on",
    "lac duong",
    "may lanh",
    "mat khau",
    "mua sim",
    "nha thuoc",
    "nha ve sinh",
    "nhan phong",
    "nhap canh",
    "noi lai",
    "nuoc suoi",
    "o dau",
    "phong yen tinh",
    "ung dung",
    "cho biet",
    "trinh dieu khien",
    "co o day",
    "tim thay",
    "di chuyen",
    "dung o day",
    "hoat dong",
    "kem chong nang",
    "khan giay",
    "khong an toan",
    "re phai",
    "re trai",
    "say xe",
    "the hanh ly",
    "thi thuc",
    "tien mat",
    "tieng anh",
    "toi bi",
    "toi can",
    "toi co",
    "toi co the",
    "toi khong",
    "toi muon",
    "toi tra",
    "tra phong",
    "truong hop",
    "viet xuong",
    "yen tinh",
    "tu tu",
    "xe cuu thuong",
    "xin chao",
    "xin loi",
  ]);

  const breakdownMeanings = new Map(Object.entries({
    "anh/chi": "you (polite)",
    "anh chi": "you (polite)",
    "bac si": "doctor",
    "bao lau": "how long",
    "bao nhieu": "how much",
    "bot": "reduce / lower",
    "buu dien": "post office",
    "ca phe": "coffee",
    "ca phe den": "black coffee",
    "ca phe sua": "milk coffee",
    "cam thay": "feel",
    "cho hoi": "excuse me / may I ask",
    "cho toi": "can I have",
    "cho": "give / let",
    "cho biet": "says / tells",
    "co": "have / yes",
    "co ban": "do you sell",
    "co the": "can",
    "cong an": "police",
    "cua toi": "my / mine",
    "can": "need",
    "dat tour": "booked a tour",
    "day": "here / this",
    "dia chi": "address",
    "di": "go",
    "di bo": "walk",
    "di chuyen": "move",
    "di thang": "go straight",
    "dien thoai": "phone",
    "dung": "correct",
    "duoc khong": "is it possible?",
    "gan nhat": "nearest",
    "gia": "price",
    "giay ve sinh": "toilet paper",
    "giam gia": "lower the price",
    "giup toi": "help me",
    "hanh ly": "baggage",
    "ho chieu": "passport",
    "it cay": "less spicy",
    "khach san": "hotel",
    "khong": "not / no",
    "khong duong": "no sugar",
    "khong sao": "it is okay",
    "khu don": "pickup area",
    "lac": "lost",
    "lac duong": "lost on the route",
    "la": "is",
    "lam on": "please",
    "lien he": "contact",
    "may lanh": "air conditioning",
    "mat khau": "password",
    "mua": "buy",
    "mua sim": "buy a SIM",
    "nha thuoc": "pharmacy",
    "nha ve sinh": "bathroom",
    "nhan phong": "check in",
    "nhap canh": "immigration",
    "noi lai": "say again",
    "nuoc suoi": "bottled water",
    "o dau": "where?",
    "o day": "here",
    "phong": "room",
    "phong yen tinh": "quiet room",
    "an toan": "safe",
    "cuu thuong": "ambulance",
    "dung o day": "stop here",
    "hoat dong": "working",
    "kem chong nang": "sunscreen",
    "khan giay": "tissues",
    "khong an toan": "unsafe",
    "nhe": "soft polite ending",
    "nhé": "soft polite ending",
    "noi": "say / speak",
    "re phai": "turn right",
    "re trai": "turn left",
    "roi": "already / enough",
    "rồi": "already / enough",
    "say xe": "motion sickness",
    "sim": "SIM card",
    "tam": "for now",
    "the hanh ly": "baggage tag",
    "thi thuc": "visa",
    "tien mat": "cash",
    "tieng anh": "English",
    "toi": "I / me",
    "toi bi": "I have / got",
    "toi can": "I need",
    "toi co": "I have",
    "toi co the": "can I",
    "toi khong": "I do not",
    "toi muon": "I want",
    "toi tra": "I pay",
    "the": "can / able to",
    "trinh dieu khien": "driver",
    "tra phong": "check out",
    "truong hop": "case / situation",
    "ung dung": "app",
    "co o day": "is here",
    "thuong": "injury / medical help",
    "tu tu": "slowly",
    "ve": "ticket",
    "xe cuu thuong": "ambulance",
    "tim thay": "find",
    "nhung": "but",
    "chung": "them",
    "viet xuong": "write down",
    "yen tinh": "quiet",
    "xin": "please / ask",
    "xin chao": "hello",
    "xin loi": "excuse me / sorry",
    "dau": "soft reassurance",
  }));

  const exactBreakdownPieces = new Map(Object.entries({
    "cam on": [
      { vietnamese: "Cảm", english: "feel / receive" },
      { vietnamese: "ơn", english: "kindness / favor" },
    ],
    "xin loi": [
      { vietnamese: "Xin", english: "please / ask" },
      { vietnamese: "lỗi", english: "mistake / fault" },
    ],
    "tam biet": [
      { vietnamese: "Tạm", english: "for now" },
      { vietnamese: "biệt", english: "separate / goodbye" },
    ],
    "khong sao": [
      { vietnamese: "Không", english: "no / not" },
      { vietnamese: "sao", english: "problem / why" },
    ],
    "khong sao dau": [
      { vietnamese: "Không sao", english: "it is okay" },
      { vietnamese: "đâu", english: "soft reassurance" },
    ],
  }));

  function fallbackBreakdownMeaning(vietnamese) {
    if (/^\d+$/.test(normalizedVietnameseKey(vietnamese))) return vietnamese;
    if (/^[A-ZĐ][\p{L}\p{M}'-]+(?:\s+[A-ZĐ][\p{L}\p{M}'-]+)*$/u.test(vietnamese)) {
      return "name or place detail";
    }
    return "specific detail";
  }

  function breakdownMeaning(vietnamese) {
    const raw = String(vietnamese ?? "").trim().toLowerCase();
    if (raw === "có") return "have / yes";
    if (raw === "cô") return "aunt-age woman / respectful female address";
    if (raw === "chưa") return "not yet";
    if (raw === "chùa") return "pagoda";
    if (raw === "vé") return "ticket";
    if (raw === "vệ") return "hygiene";
    if (raw === "giấy vệ sinh") return "toilet paper";
    const normalized = normalizedVietnameseKey(vietnamese);
    if (/^\d+$/.test(normalized)) return vietnamese;
    return breakdownMeanings.get(normalized) ?? fallbackBreakdownMeaning(vietnamese);
  }

  function chunkVietnamesePhrase(phrase) {
    const words = phrase.split(/\s+/).filter(Boolean);
    const chunks = [];

    while (words.length > 0) {
      const maxCandidateLength = Math.min(3, words.length);
      let matchedChunk = null;

      for (let length = maxCandidateLength; length >= 2; length -= 1) {
        const candidate = words.slice(0, length).join(" ");
        if (preferredBreakdownChunks.has(normalizedVietnameseKey(candidate))) {
          matchedChunk = candidate;
          break;
        }
      }

      if (matchedChunk) {
        chunks.push(matchedChunk);
        words.splice(0, matchedChunk.split(/\s+/).length);
      } else {
        chunks.push(words.shift());
      }
    }

    return chunks;
  }

  function semanticBreakdownPieces(targetText, englishText) {
    const terminal = targetText.match(/[?!.,]+$/)?.[0] ?? "";
    let workingTarget = targetText.replace(/[?!.,]+$/g, "").trim();
    const suffixPieces = [];
    const suffixes = [
      ["được không", "is it possible?"],
      ["đúng không", "right?"],
      ["phải không", "is that right?"],
      ["không", "asks yes or no"],
    ];

    for (const [vietnamese, english] of suffixes) {
      if (!normalizedVietnameseKey(workingTarget).endsWith(normalizedVietnameseKey(vietnamese))) continue;
      const suffixWithSpace = ` ${vietnamese}`;
      const index = workingTarget.toLowerCase().lastIndexOf(suffixWithSpace);
      if (index >= 0) {
        workingTarget = workingTarget.slice(0, index).trim();
        suffixPieces.push({ vietnamese: vietnamese + (terminal === "?" ? "?" : ""), english });
        break;
      }
    }

    const corePieces = chunkVietnamesePhrase(workingTarget)
      .filter(Boolean)
      .map((chunk) => ({
        vietnamese: chunk,
        english: breakdownMeaning(chunk),
      }));

    return [...corePieces, ...suffixPieces];
  }

  function showingItemLabel(englishText, ownsItem) {
    const prefixes = ownsItem
      ? ["Here is my", "This is my", "Here is the", "This is the", "Here is", "This is"]
      : ["Here is", "This is", "It is"];

    for (const prefix of prefixes) {
      if (String(englishText).toLowerCase().startsWith(prefix.toLowerCase())) {
        return String(englishText).slice(prefix.length).replace(/[ .?!]+$/g, "").trim().toLowerCase();
      }
    }
    return String(englishText ?? "").toLowerCase();
  }

  function splitVietnamesePieces(targetText, englishText) {
    const normalizedTargetText = String(targetText ?? "").normalize("NFC");
    const exactPieces = exactBreakdownPieces.get(normalizedVietnameseKey(normalizedTargetText));
    if (exactPieces) return exactPieces;

    if (normalizedTargetText.endsWith(" ở đâu?")) {
      const subject = normalizedTargetText.slice(0, -" ở đâu?".length).trim();
      const match = String(englishText ?? "").match(/^where\s+(?:is|are|can i buy)\s+(.+?)\??$/i);
      return [
        ...semanticBreakdownPieces(subject, match ? match[1].trim().toLowerCase() : "place"),
        { vietnamese: "ở đâu?", english: "where?" },
      ];
    }

    if (normalizedTargetText.startsWith("Đây là ") && normalizedTargetText.endsWith(" của tôi")) {
      const itemText = normalizedTargetText
        .slice("Đây là ".length, normalizedTargetText.length - " của tôi".length)
        .trim();
      return [
        { vietnamese: "Đây", english: "here / this" },
        { vietnamese: "là", english: "is" },
        ...semanticBreakdownPieces(itemText, showingItemLabel(englishText, true)),
        { vietnamese: "của tôi", english: "my / mine" },
      ];
    }

    if (normalizedTargetText.startsWith("Đây là ")) {
      const itemText = normalizedTargetText.slice("Đây là ".length).trim();
      return [
        { vietnamese: "Đây", english: "here / this" },
        { vietnamese: "là", english: "is" },
        ...semanticBreakdownPieces(itemText, showingItemLabel(englishText, false)),
      ];
    }

    return semanticBreakdownPieces(normalizedTargetText, englishText);
  }

  function generatedBreakdownPieces(phrase) {
    const pieces = splitVietnamesePieces(phrase.targetText, phrase.englishText)
      .filter((piece) => piece.vietnamese && piece.english);
    const titleKey = normalizedVietnameseKey(phrase.targetText);
    const titleWordCount = phrase.targetText.split(/\s+/).filter(Boolean).length;

    if (
      titleWordCount > 1 &&
      pieces.length === 1 &&
      normalizedVietnameseKey(pieces[0].vietnamese) === titleKey
    ) {
      return phrase.targetText
        .replace(/[?!.,]+$/g, "")
        .split(/\s+/)
        .filter(Boolean)
        .map((word) => ({
          vietnamese: word,
          english: breakdownMeaning(word),
        }));
    }

    return pieces;
  }

  function generatedBreakdownLeadIn(phrase) {
    const wordCount = phrase.targetText.split(/\s+/).filter(Boolean).length;
    if (wordCount === 1) {
      return "This is a compact one-word phrase, so the whole word is the reusable piece to recognize and say clearly.";
    }
    if (phrase.targetText.endsWith(" ở đâu?")) {
      return "This pattern asks where a place or service is. Keep the place first, then use ở đâu for where.";
    }
    if (phrase.targetText.includes("không")) {
      return "This pattern asks for a yes-or-no answer or sets a clear limit. Keep the main need together so it sounds natural.";
    }
    return "Use these cards to see the useful pieces first, then the full phrase as the version to say out loud.";
  }

  function addBreakdownSectionItems(sectionID, phrase, sourcePath) {
    const pieces = generatedBreakdownPieces(phrase);
    const wordCount = phrase.targetText.split(/\s+/).filter(Boolean).length;
    const tokens = wordCount === 1
      ? [{
        id: `${sectionID}:breakdown:full`,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
      }]
      : [
        ...pieces.map((piece, index) => ({
          id: `${sectionID}:breakdown:piece-${index + 1}`,
          vietnamese: piece.vietnamese,
          english: piece.english,
        })),
        {
          id: `${sectionID}:breakdown:full`,
          vietnamese: phrase.targetText,
          english: phrase.englishText,
        },
      ];

    tokens.forEach((token, index) => {
      breakdownRows.push({
        id: token.id,
        phrase_id: phrase.id,
        token_text: token.vietnamese,
        normalized_token_text: normalizeText(token.vietnamese),
        english_gloss: token.english,
        sort_order: index,
      });
      sectionItemRows.push({
        id: `${sectionID}:breakdown:${index}:${stableID([token.vietnamese, token.english])}`,
        section_id: sectionID,
        item_kind: "breakdown_token",
        target_id: token.id,
        title_override: token.vietnamese,
        subtitle_override: token.english,
        note: null,
        sort_order: index,
      });
    });
  }

  function addSection({ pageID, sectionKey, title, body, presentation, sortOrder, sourcePath }) {
    const sectionID = `${pageID}:${sectionKey}`;
    if (usedSectionIDs.has(sectionID)) return sectionID;
    usedSectionIDs.add(sectionID);
    sectionRows.push({
      id: sectionID,
      page_id: pageID,
      section_key: sectionKey,
      title,
      body: body ?? "",
      presentation: presentation ?? "plain-text",
      sort_order: sortOrder,
      source_path: sourcePath,
    });
    return sectionID;
  }

  function addPhraseSectionItem({ sectionID, phrase, itemKind = "phrase", sortOrder, note = null }) {
    const pageID = sectionID.slice(0, sectionID.lastIndexOf(":"));
    if (itemKind === "phrase" && !claimPagePhraseTarget(pageID, phrase.id, note)) {
      return false;
    }
    sectionItemRows.push({
      id: `${sectionID}:${itemKind}:${sortOrder}:${stableID([phrase.id, phrase.targetText, phrase.englishText, note])}`,
      section_id: sectionID,
      item_kind: itemKind,
      target_id: phrase.id,
      title_override: phrase.targetText,
      subtitle_override: phrase.englishText,
      note,
      sort_order: sortOrder,
    });
    return true;
  }

  function addRelationshipWordsSection({ pageID, sortOrder, sourcePath }) {
    const newRelationshipPhrases = relationshipWordPhrases.filter((phrase) => (
      !hasPagePhraseTarget(pageID, phrase.id, canonicalPageIDForPhrase(phrase.id))
    ));
    if (newRelationshipPhrases.length === 0) return false;

    const sectionID = addSection({
      pageID,
      sectionKey: relationshipWordSectionKey,
      title: "Relationship words",
      body: "Vietnamese often uses a relationship word where English uses one all-purpose you. Use these when the person's age or role is clear; if you are unsure, keep the main phrase simple and friendly.",
      presentation: "relationship-shelf",
      sortOrder,
      sourcePath,
    });

    newRelationshipPhrases.forEach((phrase, index) => {
      addPhraseSectionItem({
        sectionID,
        phrase,
        sortOrder: index,
        note: canonicalPageIDForPhrase(phrase.id),
      });
    });
    return true;
  }

  function addPageRelation({ sourcePhraseID, targetPhraseID, relationType, reason, displayLabel, sortOrder, sourcePath }) {
    const sourcePageID = canonicalPageIDForPhrase(sourcePhraseID);
    const targetPageID = canonicalPageIDForPhrase(targetPhraseID);
    if (!sourcePageID || !targetPageID || sourcePageID === targetPageID) return;
    const key = `${sourcePageID}\u0000${targetPageID}\u0000${relationType}`;
    if (relationKeys.has(key)) return;
    relationKeys.add(key);
    relationRows.push({
      id: `relation:${stableID([sourcePageID, targetPageID, relationType])}`,
      language_pack_id: languagePackID,
      source_kind: "phrase_page",
      source_id: sourcePageID,
      target_kind: "phrase_page",
      target_id: targetPageID,
      relation_type: relationType,
      reason,
      display_label: displayLabel,
      sort_order: sortOrder,
      source_path: sourcePath,
    });
  }

  for (const page of authoredPages) {
    const canonicalPageID = canonicalPageIDForPhrase(page.phraseID);
    if (!canonicalPageID) continue;
    const authoredSourcePath = relative(authoredPagesPath);
    const relationshipWordsSortOrder = 3;
    const phrase = phraseByID.get(page.phraseID);

    for (const [index, categoryID] of (page.categoryIDs ?? []).entries()) {
      addPageCategory(canonicalPageID, categoryID, index, authoredSourcePath);
    }

    const seenAuthoredDestinations = new Set();
    let relationshipWordsInserted = (page.sections ?? []).some((section) => section.id === relationshipWordSectionKey);
    const maybeAddRelationshipWordsSection = () => {
      if (relationshipWordsInserted || !shouldShowRelationshipWordsSection(phrase, page)) return;
      relationshipWordsInserted = addRelationshipWordsSection({
        pageID: canonicalPageID,
        sortOrder: relationshipWordsSortOrder,
        sourcePath: authoredSourcePath,
      }) === true;
    };

    for (const [sectionIndex, section] of (page.sections ?? []).entries()) {
      if (sectionIndex >= relationshipWordsSortOrder) {
        maybeAddRelationshipWordsSection();
      }
      const sectionID = `${canonicalPageID}:${section.id}`;
      const sortOrder = sectionIndex >= relationshipWordsSortOrder ? sectionIndex + 1 : sectionIndex;
      usedSectionIDs.add(sectionID);
      sectionRows.push({
        id: sectionID,
        page_id: canonicalPageID,
        section_key: section.id,
        title: section.title,
        body: section.body ?? "",
        presentation: section.presentation ?? "plain-text",
        sort_order: sortOrder,
        source_path: authoredSourcePath,
      });

      let itemIndex = 0;
      for (const phrase of section.phrases ?? []) {
        const resolvedPhraseID = resolvedCatalogPhraseIDForAuthoredPhrase(phrase);
        const targetID = resolvedPhraseID ?? `authored:${phrase.id}`;
        const destinationPageID = resolvedPhraseID ? canonicalPageIDForPhrase(resolvedPhraseID) : (phrase.detailPageID ?? null);
        const allowDuplicateJourneyRow =
          canonicalPageID === baNaJourneyPageID
          && ["quick-say", "journey-flow", "key-phrases"].includes(section.id);
        if (
          (!allowDuplicateJourneyRow && section.id === "explore-next" && destinationPageID && seenAuthoredDestinations.has(destinationPageID))
          || (!allowDuplicateJourneyRow && !claimPagePhraseTarget(canonicalPageID, targetID, destinationPageID))
        ) {
          continue;
        }
        if (allowDuplicateJourneyRow) {
          claimPagePhraseTarget(canonicalPageID, `${section.id}:${targetID}`, `${section.id}:${destinationPageID ?? targetID}`);
        }
        sectionItemRows.push({
          id: `${sectionID}:phrase:${itemIndex}:${stableID([phrase.id, phrase.vietnamese, phrase.english])}`,
          section_id: sectionID,
          item_kind: resolvedPhraseID ? "phrase" : "authored_phrase",
          target_id: targetID,
          title_override: phrase.vietnamese ?? null,
          subtitle_override: phrase.english ?? null,
          note: destinationPageID,
          sort_order: itemIndex,
        });
        if (destinationPageID) {
          seenAuthoredDestinations.add(destinationPageID);
        }
        if (resolvedPhraseID) {
          addPageRelation({
            sourcePhraseID: page.phraseID,
            targetPhraseID: resolvedPhraseID,
            relationType: section.id === "explore-next" ? "next_step_after" : "see_also",
            reason: `Authored ${section.title ?? section.id} row links these phrase pages.`,
            displayLabel: section.title ?? "Related",
            sortOrder: itemIndex,
            sourcePath: authoredSourcePath,
          });
        }
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

    const exploreSectionID = `${canonicalPageID}:explore-next`;
    if (usedSectionIDs.has(exploreSectionID) && !sectionItemRows.some((item) => item.section_id === exploreSectionID)) {
      const fallbackPhrases = [
        ...scenarioNeighborPhrases(phrase, 8),
        ...broaderFallbackPhrases(phrase, 16),
      ];
      for (const [index, fallbackPhrase] of fallbackPhrases.entries()) {
        const added = addPhraseSectionItem({
          sectionID: exploreSectionID,
          phrase: fallbackPhrase,
          sortOrder: index,
          note: canonicalPageIDForPhrase(fallbackPhrase.id),
        });
        if (!added) continue;
        addPageRelation({
          sourcePhraseID: page.phraseID,
          targetPhraseID: fallbackPhrase.id,
          relationType: "next_step_after",
          reason: "Fallback Explore next row from neighboring phrases in the same travel category.",
          displayLabel: "Explore next",
          sortOrder: index,
          sourcePath: authoredSourcePath,
        });
        if (sectionItemRows.filter((item) => item.section_id === exploreSectionID).length >= 3) {
          break;
        }
      }
    }

    maybeAddRelationshipWordsSection();
  }

  for (const pageRow of pageRows) {
    const phrase = phraseByID.get(pageRow.phrase_id);
    if (!phrase) continue;
    const family = familyByID.get(phrase.familyID);
    const scenario = scenarioByID.get(phrase.scenarioID);
    addPageCategory(pageRow.id, phrase.scenarioID, 0, relative(catalogPath));
    if (pageRow.is_authored) continue;

    addSection({
      pageID: pageRow.id,
      sectionKey: "at-glance",
      title: "At a glance",
      body: `Use ${phrase.targetText} for "${phrase.englishText}" in ${scenario?.title ?? "Vietnam travel"}. The full phrase comes first, and the breakdown below shows the reusable pieces a traveler is most likely to recognize again.`,
      presentation: "plain-text",
      sortOrder: 0,
      sourcePath: relative(catalogPath),
    });

    const quickSaySectionID = addSection({
      pageID: pageRow.id,
      sectionKey: "quick-say",
      title: "Quick say",
      body: `Use ${phrase.targetText} first when you need to say "${phrase.englishText}" clearly. Keep it short, then point, show the screen, or wait for the answer before adding more words.`,
      presentation: "phrase-list",
      sortOrder: 1,
      sourcePath: relative(catalogPath),
    });
    addPhraseSectionItem({
      sectionID: quickSaySectionID,
      phrase,
      sortOrder: 0,
      note: pageRow.id,
    });

    const breakdownSectionID = addSection({
      pageID: pageRow.id,
      sectionKey: "breakdown",
      title: "Break it down",
      body: generatedBreakdownLeadIn(phrase),
      presentation: "breakdown-strip",
      sortOrder: 2,
      sourcePath: relative(catalogPath),
    });
    addBreakdownSectionItems(breakdownSectionID, phrase, relative(catalogPath));

    if (shouldShowRelationshipWordsSection(phrase)) {
      addRelationshipWordsSection({
        pageID: pageRow.id,
        sortOrder: 3,
        sourcePath: relative(catalogPath),
      });
    }

    const relatedPhrases = scenarioNeighborPhrases(phrase, 6);
    const teachingPhrases = relatedPhrases.length > 0 ? relatedPhrases.slice(0, 1) : [];
    const nearbyPhrases = relatedPhrases.slice(teachingPhrases.length, teachingPhrases.length + 3);
    const whenToUseSectionID = addSection({
      pageID: pageRow.id,
      sectionKey: "when-to-use",
      title: "When to use it",
      body: baselineContextBody(phrase, family),
      presentation: "phrase-list",
      sortOrder: 4,
      sourcePath: relative(catalogPath),
    });
    teachingPhrases.forEach((teachingPhrase, index) => {
      addPhraseSectionItem({
        sectionID: whenToUseSectionID,
        phrase: teachingPhrase,
        sortOrder: index,
        note: canonicalPageIDForPhrase(teachingPhrase.id),
      });
    });

    if (phrase.youMayHear) {
      addSection({
        pageID: pageRow.id,
        sectionKey: "what-you-may-hear",
        title: "What you may hear",
        body: sentence(phrase.youMayHear),
        presentation: "plain-text",
        sortOrder: 5,
        sourcePath: relative(catalogPath),
      });
    }

    addSection({
      pageID: pageRow.id,
      sectionKey: "good-to-know",
      title: "Good to know",
      body: `Say it once, then give the other person the place, item, screen, or document that makes the request clear.`,
      presentation: "tip-callout",
      sortOrder: 6,
      sourcePath: relative(catalogPath),
    });

    const nearbySectionID = addSection({
      pageID: pageRow.id,
      sectionKey: "explore-next",
      title: "Explore next",
      body: nearbyPhrases.length > 0
        ? `These nearby ${scenario?.title ?? "travel"} phrases help if the answer creates one more step.`
        : `This phrase is ready as a standalone ${scenario?.title ?? "travel"} page.`,
      presentation: "phrase-list",
      sortOrder: 7,
      sourcePath: relative(catalogPath),
    });
    nearbyPhrases.forEach((nearbyPhrase, index) => {
      const added = addPhraseSectionItem({
        sectionID: nearbySectionID,
        phrase: nearbyPhrase,
        sortOrder: index,
        note: canonicalPageIDForPhrase(nearbyPhrase.id),
      });
      if (!added) return;
      addPageRelation({
        sourcePhraseID: phrase.id,
        targetPhraseID: nearbyPhrase.id,
        relationType: "see_also",
        reason: "Generated from neighboring phrases in the same travel category.",
        displayLabel: "Nearby phrases",
        sortOrder: index,
        sourcePath: relative(catalogPath),
      });
    });
  }

  for (const family of catalog.families) {
    const primaryPhraseID = family.primaryPhraseID;
    for (const [index, phraseID] of (family.phraseIDs ?? []).entries()) {
      if (phraseID === primaryPhraseID) continue;
      const phrase = phraseByID.get(phraseID);
      const role = phrase?.variantRole ?? "also-common";
      const relationType = role === "clearer"
        ? "clearer_than"
        : role === "more-polite"
          ? "more_polite_than"
          : role === "also-common"
            ? "also_common_with"
            : "same_need_alt_context";
      addPageRelation({
        sourcePhraseID: primaryPhraseID,
        targetPhraseID: phraseID,
        relationType,
        reason: `Same phrase cluster variant with role ${role}.`,
        displayLabel: "Natural choice",
        sortOrder: index,
        sourcePath: relative(catalogPath),
      });
      addPageRelation({
        sourcePhraseID: phraseID,
        targetPhraseID: primaryPhraseID,
        relationType: "same_need_alt_context",
        reason: "Variant points back to the main phrase in the same travel need.",
        displayLabel: "Main phrase",
        sortOrder: index,
        sourcePath: relative(catalogPath),
      });
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
  const audioAssetIDByNormalizedText = new Map();
  for (const row of audioAssetRows) {
    if (!audioAssetIDByNormalizedText.has(row.normalized_spoken_text)) {
      audioAssetIDByNormalizedText.set(row.normalized_spoken_text, row.id);
    }
  }

  const audioUsageRows = [];
  const missingAudioRows = [];
  const seenAudioUsageIDs = new Set();
  const seenMissingAudioIDs = new Set();
  const seenPlannedMissingAudioText = new Set();

  function plannedAudioTarget(targetKind, targetID) {
    return (targetKind === "phrase" && plannedAudioPhraseIDs.has(targetID))
      || (targetKind === "phrase_page" && plannedAudioCanonicalPageIDs.has(targetID))
      || (targetKind === "authored_phrase" && String(targetID ?? "").startsWith("authored:city-"))
      || (targetKind === "authored_phrase" && String(targetID ?? "").startsWith("authored:viet-practice-expansion-"));
  }

  function addAudioUsage({ usageKind, targetKind, targetID, expectedText, audioKey, isPrimary, sourcePath }) {
    const normalizedExpected = normalizeText(expectedText);
    let effectiveAudioKey = audioKey;
    let entry = audioManifest[effectiveAudioKey];
    let resolved = Boolean(entry && normalizeText(entry.text) === normalizedExpected);
    if (!resolved) {
      const exactReusableAudioKey = audioAssetIDByNormalizedText.get(normalizedExpected);
      if (exactReusableAudioKey) {
        effectiveAudioKey = exactReusableAudioKey;
        entry = audioManifest[effectiveAudioKey];
        resolved = Boolean(entry && normalizeText(entry.text) === normalizedExpected);
      }
    }
    if (!resolved) {
      const plannedMissing = plannedAudioTarget(targetKind, targetID);
      if (plannedMissing && seenPlannedMissingAudioText.has(normalizedExpected)) {
        return;
      }
      if (plannedMissing) {
        seenPlannedMissingAudioText.add(normalizedExpected);
      }
      let missingID = plannedMissing
        ? `missing-audio:planned:${stableID([normalizedExpected])}`
        : `missing-audio:${stableID([usageKind, targetKind, targetID, expectedText, audioKey])}`;
      let missingSuffix = 1;
      while (seenMissingAudioIDs.has(missingID)) {
        missingID = `missing-audio:${stableID([usageKind, targetKind, targetID, expectedText, audioKey, missingSuffix])}`;
        missingSuffix += 1;
      }
      seenMissingAudioIDs.add(missingID);
      missingAudioRows.push({
        id: missingID,
        language_pack_id: languagePackID,
        target_kind: targetKind,
        target_id: targetID,
        expected_text: expectedText,
        normalized_expected_text: normalizedExpected,
        source_path: sourcePath,
        reason: plannedMissing ? "planned-authored-audio" : (entry ? "normalized-text-mismatch" : "missing-manifest-key"),
        severity: plannedMissing ? "planned" : "blocking",
        release_blocking: plannedMissing ? 0 : 1,
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
      audio_asset_id: effectiveAudioKey,
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
        const resolvedPhraseID = resolvedCatalogPhraseIDForAuthoredPhrase(phrase);
        addAudioUsage({
          usageKind: "authored-section-phrase",
          targetKind: resolvedPhraseID ? "phrase" : "authored_phrase",
          targetID: resolvedPhraseID ?? `authored:${phrase.id}`,
          expectedText: phrase.vietnamese,
          audioKey: phrase.audioKey,
          isPrimary: 0,
          sourcePath: relative(authoredPagesPath),
        });
      }
      for (const token of section.breakdown ?? []) {
        if (!token.audioKey) {
          continue;
        }

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
        .filter((alias) => alias.alias_kind !== "legacy-native-page")
        .map((alias) => alias.alias_id),
    ]
      .filter(Boolean)
      .join(" ");
    return {
      rowid: index + 1,
      id: `search:${phrase.id}`,
      language_pack_id: languagePackID,
      target_kind: "phrase_page",
      target_id: canonicalPageIDForPhrase(phrase.id),
      title_text: page?.title ?? phrase.targetText,
      target_text: phrase.targetText,
      accentless_target_text: accentlessText(phrase.targetText),
      pronunciation_text: phrase.pronunciation,
      english_text: phrase.englishText,
      alias_text: aliasText,
      category_text: [
        scenario?.title,
        family?.familyTitle,
        phrase.cityName,
        phrase.citySubcategoryTitle,
        phrase.difficulty,
        phrase.placeName,
        phrase.placeVietnameseName,
        ...(page?.categoryIDs ?? []),
      ].filter(Boolean).join(" "),
      related_text: [
        family?.summary,
        phrase.context,
        phrase.youMayHear,
        phrase.cityShortTitle,
        phrase.cityVietnameseName,
      ].filter(Boolean).join(" "),
      priority_tier: page ? 100 : phrase.accessTier === "starter" ? 75 : 50,
      is_canonical_page: 1,
    };
  });

  const sectionIDsWithItems = new Set(sectionItemRows.map((item) => item.section_id));
  const renderedSectionRows = sectionRows.filter((section) => (
    sectionIDsWithItems.has(section.id)
    || !["phrase-list", "relationship-shelf"].includes(section.presentation)
  ));

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
    insertRows("phrase", ["id", "language_pack_id", "canonical_phrase_key", "canonical_phrase_id", "target_text", "normalized_target_text", "accentless_target_text", "english_text", "pronunciation", "access_tier", "completeness_status", "audio_status", "source_path", "source_row_id", "sense_key"], phraseRows),
    insertRows("phrase_page", ["id", "language_pack_id", "phrase_id", "title", "english_title", "summary", "icon_name", "tint_name", "hero_image_name", "page_renderer", "completeness_status", "is_authored"], pageRows),
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
    insertRows("city", ["id", "language_pack_id", "title", "short_title", "vietnamese_name", "emoji", "source_ids"], cityRows),
    insertRows("city_subcategory", ["id", "language_pack_id", "title", "sort_order"], citySubcategoryRows),
    insertRows("city_place", ["id", "city_id", "vietnamese_name", "english_name", "place_kind", "content_role", "source_ids"], cityPlaceRows),
    insertRows("phrase_city_tag", ["phrase_id", "city_id", "subcategory_id", "place_id", "difficulty", "page_kind", "place_kind", "content_role", "spoken_chunks", "source_ids", "rationale"], phraseCityTagRows),
    insertRows("cluster_scenario", ["cluster_id", "scenario_id", "relevance"], catalog.families.map((family) => ({
      cluster_id: family.id,
      scenario_id: family.scenarioID,
      relevance: "primary",
    }))),
    insertRows("page_category", ["page_id", "category_id", "sort_order", "source_path"], pageCategoryRows),
    insertRows("page_section", ["id", "page_id", "section_key", "title", "body", "presentation", "sort_order", "source_path"], renderedSectionRows),
    insertRows("breakdown_token", ["id", "phrase_id", "token_text", "normalized_token_text", "english_gloss", "sort_order"], breakdownRows),
    insertRows("page_section_item", ["id", "section_id", "item_kind", "target_id", "title_override", "subtitle_override", "note", "sort_order"], sectionItemRows),
    insertRows("phrase_relation", ["id", "language_pack_id", "source_kind", "source_id", "target_kind", "target_id", "relation_type", "reason", "display_label", "sort_order", "source_path"], sortByID(relationRows)),
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
    'relations', (SELECT count(*) FROM phrase_relation),
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
  const expectedCanonicalPhrasePages = canonicalPhraseIDs.size;
  const unresolvedDuplicateNormalizedTargetTextGroups = duplicateNormalizedTargetGroups.filter((group) =>
    group.aliasedPhraseIDs.some((phraseID) => {
      const alias = aliases.get(sourcePageIDForPhrase(phraseID));
      return !alias || alias.canonical_page_id !== group.canonicalPageID;
    })
  );
  const duplicateCanonicalPageGroupCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM (
      SELECT p.normalized_target_text
      FROM phrase_page pp
      JOIN phrase p ON p.id = pp.phrase_id
      GROUP BY p.normalized_target_text
      HAVING count(*) > 1
    );
  `));
  const phrasesResolvedToCanonicalPages = Number(sqliteQuery(`
    SELECT count(*)
    FROM phrase p
    JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id;
  `));
  const sectionlessCanonicalPageCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM phrase_page pp
    WHERE NOT EXISTS (SELECT 1 FROM page_section ps WHERE ps.page_id = pp.id);
  `));
  const relationshipWordsEligiblePageIDs = pageRows
    .filter((row) => shouldShowRelationshipWordsSection(
      phraseByID.get(row.phrase_id),
      authoredPageByPhraseID.get(row.phrase_id)
    ))
    .map((row) => row.id)
    .sort();
  const relationshipWordsEligiblePageIDSQL = relationshipWordsEligiblePageIDs.length > 0
    ? relationshipWordsEligiblePageIDs.map((id) => `'${id.replace(/'/g, "''")}'`).join(",")
    : "'__none__'";
  const missingRelationshipWordsSectionCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM phrase_page pp
    WHERE pp.id IN (${relationshipWordsEligiblePageIDSQL})
      AND NOT EXISTS (
      SELECT 1
      FROM page_section ps
      WHERE ps.page_id = pp.id
        AND ps.section_key = '${relationshipWordSectionKey}'
    );
  `));
  const unexpectedRelationshipWordsSectionCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM page_section ps
    WHERE ps.section_key = '${relationshipWordSectionKey}'
      AND ps.page_id NOT IN (${relationshipWordsEligiblePageIDSQL});
  `));
  const relationshipWordsMissingSample = sqliteQuery(`
    SELECT pp.id || ': ' || pp.title
    FROM phrase_page pp
    WHERE pp.id IN (${relationshipWordsEligiblePageIDSQL})
      AND NOT EXISTS (
        SELECT 1
        FROM page_section ps
        WHERE ps.page_id = pp.id
          AND ps.section_key = '${relationshipWordSectionKey}'
      )
    ORDER BY pp.id
    LIMIT 20;
  `).split("\n").filter(Boolean);
  const relationshipWordsUnexpectedSample = sqliteQuery(`
    SELECT ps.page_id || ': ' || pp.title
    FROM page_section ps
    JOIN phrase_page pp ON pp.id = ps.page_id
    WHERE ps.section_key = '${relationshipWordSectionKey}'
      AND ps.page_id NOT IN (${relationshipWordsEligiblePageIDSQL})
    ORDER BY ps.page_id
    LIMIT 20;
  `).split("\n").filter(Boolean);
  const badRelationshipWordsSectionCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM page_section ps
    WHERE ps.section_key = '${relationshipWordSectionKey}'
      AND (
        (SELECT count(*) FROM page_section_item psi WHERE psi.section_id = ps.id AND psi.item_kind = 'phrase') = 0
        OR EXISTS (
          SELECT 1
          FROM page_section_item psi
          WHERE psi.section_id = ps.id
            AND psi.item_kind = 'phrase'
            AND COALESCE(psi.title_override, '') NOT IN (${relationshipWordPhrases.map((phrase) => `'${phrase.targetText.replace(/'/g, "''")}'`).join(",")})
        )
      );
  `));
  const badQuickSayTeachingRows = sqliteQuery(`
    SELECT pp.id || ': ' || ps.section_key || ' -> ' || COALESCE(psi.title_override, '') || ' / ' || COALESCE(psi.note, '')
    FROM phrase_page pp
    JOIN page_section ps ON ps.page_id = pp.id
    JOIN page_section_item psi ON psi.section_id = ps.id
    WHERE ps.section_key IN ('quick-say', 'standard-way')
      AND psi.item_kind = 'phrase'
      AND NOT (
        (psi.note = pp.id AND psi.title_override = pp.title)
        OR (
          pp.id = 'viet-phrase-polite-1'
          AND psi.note = 'viet-phrase-hello-chao'
          AND psi.title_override = 'Chào'
        )
        OR (
          pp.id || '>' || psi.note IN (${approvedQuickSayShortcutPairs.map(([sourceID, targetID]) => `'${sourceID}>${targetID}'`).join(",")})
        )
      )
    ORDER BY pp.id, ps.sort_order, psi.sort_order;
  `).split("\n").filter(Boolean);
  const textOnlySectionRunRows = sqliteQuery(`
    WITH section_flags AS (
      SELECT
        pp.id AS page_id,
        pp.title AS page_title,
        ps.title AS section_title,
        ps.sort_order,
        CASE WHEN EXISTS (
          SELECT 1
          FROM page_section_item psi
          WHERE psi.section_id = ps.id
            AND psi.item_kind IN ('phrase', 'authored_phrase', 'breakdown_token')
        ) THEN 0 ELSE 1 END AS text_only
      FROM phrase_page pp
      JOIN page_section ps ON ps.page_id = pp.id
    ),
    runs AS (
      SELECT
        section_flags.*,
        SUM(CASE WHEN text_only = 0 THEN 1 ELSE 0 END) OVER (
          PARTITION BY page_id
          ORDER BY sort_order
          ROWS UNBOUNDED PRECEDING
        ) AS run_group
      FROM section_flags
    )
    SELECT page_id || ': ' || group_concat(section_title, ' | ')
    FROM runs
    WHERE text_only = 1
    GROUP BY page_id, run_group
    HAVING count(*) >= 3
    ORDER BY page_id;
  `).split("\n").filter(Boolean);
  const repeatedVisiblePhraseRows = sqliteQuery(`
    WITH visible_phrase_rows AS (
      SELECT
        ps.page_id,
        COALESCE(psi.note, pp.id, psi.target_id) AS canonical_target,
        ps.section_key
      FROM page_section ps
      JOIN page_section_item psi ON psi.section_id = ps.id
      LEFT JOIN phrase p ON p.id = psi.target_id
      LEFT JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
      WHERE psi.item_kind IN ('phrase', 'authored_phrase')
    )
    SELECT page_id || ': ' || canonical_target || ' in ' || group_concat(section_key, ' | ')
    FROM visible_phrase_rows
    WHERE page_id != '${baNaJourneyPageID}'
    GROUP BY page_id, canonical_target
    HAVING count(*) > 1
    ORDER BY page_id, canonical_target;
  `).split("\n").filter(Boolean);
  const repeatedVisiblePhraseTextRows = sqliteQuery(`
    WITH visible_phrase_rows AS (
      SELECT
        ps.page_id,
        lower(trim(COALESCE(psi.title_override, p.target_text, psi.target_id))) AS visible_text,
        ps.section_key
      FROM page_section ps
      JOIN page_section_item psi ON psi.section_id = ps.id
      LEFT JOIN phrase p ON p.id = psi.target_id
      WHERE psi.item_kind IN ('phrase', 'authored_phrase')
    )
    SELECT page_id || ': ' || visible_text || ' in ' || group_concat(section_key, ' | ')
    FROM visible_phrase_rows
    WHERE page_id != '${baNaJourneyPageID}'
    GROUP BY page_id, visible_text
    HAVING count(*) > 1
    ORDER BY page_id, visible_text;
  `).split("\n").filter(Boolean);
  const nonDeepCompletenessStatusRows = sqliteQuery(`
    SELECT id || ': ' || completeness_status
    FROM phrase_page
    WHERE completeness_status != 'deep'
    ORDER BY id;
  `).split("\n").filter(Boolean);
  const incompleteArticleContractRows = sqliteQuery(`
    WITH page_contract AS (
      SELECT
        pp.id AS page_id,
        pp.title AS page_title,
        MAX(CASE WHEN ps.section_key = 'at-glance' THEN 1 ELSE 0 END) AS has_at_glance,
        MAX(CASE WHEN ps.section_key IN ('quick-say', 'standard-way') THEN 1 ELSE 0 END) AS has_quick_or_standard,
        MAX(CASE WHEN ps.section_key = 'breakdown' THEN 1 ELSE 0 END) AS has_breakdown,
        MAX(CASE
          WHEN ps.section_key = 'when-to-use' THEN 1
          WHEN pp.id = '${baNaJourneyPageID}' AND ps.section_key = 'journey-flow' THEN 1
          ELSE 0
        END) AS has_when_to_use,
        MAX(CASE WHEN ps.section_key = 'good-to-know' THEN 1 ELSE 0 END) AS has_good_to_know,
        SUM(CASE WHEN psi.item_kind = 'phrase' AND ps.section_key != 'relationship-words' THEN 1 ELSE 0 END) AS article_phrase_rows,
        SUM(CASE WHEN psi.item_kind = 'breakdown_token' THEN 1 ELSE 0 END) AS breakdown_rows
      FROM phrase_page pp
      JOIN page_section ps ON ps.page_id = pp.id
      LEFT JOIN page_section_item psi ON psi.section_id = ps.id
      GROUP BY pp.id
    )
    SELECT page_id || ': ' || page_title
    FROM page_contract
    WHERE page_id != 'viet-phrase-polite-1'
      AND (
        has_at_glance = 0
        OR has_quick_or_standard = 0
        OR has_breakdown = 0
        OR has_when_to_use = 0
        OR has_good_to_know = 0
        OR article_phrase_rows = 0
        OR breakdown_rows = 0
      )
    ORDER BY page_id;
  `).split("\n").filter(Boolean);
  const brokenRelationCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM phrase_relation r
    WHERE r.source_kind != 'phrase_page'
       OR r.target_kind != 'phrase_page'
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.source_id)
       OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.target_id);
  `));
  const relationSourceIndexPresent = Number(sqliteQuery(`
    SELECT count(*)
    FROM sqlite_master
    WHERE type = 'index'
      AND name = 'idx_phrase_relation_source';
  `)) === 1;
  const relationLookupPlan = sqliteQuery(`
    EXPLAIN QUERY PLAN
    SELECT r.id
    FROM phrase_relation r
    JOIN phrase_page pp ON pp.id = r.target_id
    WHERE r.source_kind = 'phrase_page'
      AND r.target_kind = 'phrase_page'
      AND r.source_id = 'viet-phrase-polite-1'
    ORDER BY r.sort_order, r.relation_type, pp.title
    LIMIT 8;
  `);
  const relationLookupUsesSourceIndex = relationLookupPlan.includes("idx_phrase_relation_source");
  const searchDocumentsWithMissingPageTargets = Number(sqliteQuery(`
    SELECT count(*)
    FROM search_document sd
    WHERE sd.target_kind = 'phrase_page'
      AND NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = sd.target_id);
  `));
  const authoredPhraseSectionItemCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM page_section_item
    WHERE item_kind = 'authored_phrase';
  `));
  const phraseSectionRouteMismatchCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM page_section_item psi
    JOIN phrase p ON p.id = psi.target_id
    LEFT JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
    WHERE psi.item_kind = 'phrase'
      AND psi.note IS NOT NULL
      AND psi.note != ''
      AND psi.note != pp.id;
  `));
  const visiblePhraseTextMismatchCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM page_section_item psi
    JOIN phrase p ON p.id = psi.target_id
    WHERE psi.item_kind = 'phrase'
      AND psi.title_override IS NOT NULL
      AND lower(trim(psi.title_override)) != lower(trim(p.target_text));
  `));
  const pageTitlePhraseTextMismatchCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    WHERE lower(trim(pp.title)) != lower(trim(p.target_text));
  `));
  const pageEnglishTitlePhraseTextMismatchCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM phrase_page pp
    JOIN phrase p ON p.id = pp.phrase_id
    WHERE lower(trim(pp.english_title)) != lower(trim(p.english_text));
  `));
  const audioUsageMismatchCount = Number(sqliteQuery(`
    SELECT count(*)
    FROM audio_usage au
    JOIN audio_asset aa ON aa.id = au.audio_asset_id
    WHERE au.normalized_expected_text != aa.normalized_spoken_text;
  `));
  const badBreakdownGlossRows = sqliteQuery(`
    SELECT pp.id || ': ' || bt.token_text || ' = ' || bt.english_gloss
    FROM page_section ps
    JOIN phrase_page pp ON pp.id = ps.page_id
    JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
    JOIN breakdown_token bt ON bt.id = psi.target_id
    WHERE ps.section_key = 'breakdown'
      AND psi.sort_order < (
        SELECT max(psi2.sort_order)
        FROM page_section_item psi2
        WHERE psi2.section_id = ps.id
          AND psi2.item_kind = 'breakdown_token'
      )
      AND (
        lower(bt.english_gloss) = lower(pp.english_title)
        OR lower(bt.english_gloss) LIKE '% detail'
        OR lower(bt.english_gloss) LIKE 'starts phrase%'
        OR lower(bt.english_gloss) LIKE 'start phrase%'
        OR lower(bt.english_gloss) LIKE 'finish%'
        OR lower(bt.english_gloss) LIKE 'sets up%'
        OR lower(bt.english_gloss) LIKE 'part of%'
        OR lower(bt.english_gloss) LIKE 'proper name%'
        OR lower(bt.english_gloss) LIKE 'names %'
        OR lower(bt.english_gloss) IN (
          'place name',
          'name starter',
          'street name',
          'market name',
          'driver word',
          'phrase piece',
          'key word',
          'phrase ending',
          'word',
          'action',
          'question ending',
          'place / service',
          'main phrase piece',
          'extra detail',
          'the main place or thing',
          'specific detail',
          'name or place detail',
          'first name part',
          'second name part',
          'middle name part',
          'final name part',
          'soft reassurance',
          'context word',
          'meaningful phrase part',
          'meaning to keep'
        )
      );
  `).split("\n").filter(Boolean);
  const duplicateBreakdownGlossRows = sqliteQuery(`
    WITH rows AS (
      SELECT
        pp.id AS page_id,
        ps.id AS section_id,
        bt.token_text,
        bt.english_gloss,
        lower(trim(bt.english_gloss)) AS normalized_gloss,
        psi.sort_order,
        (
          SELECT max(psi2.sort_order)
          FROM page_section_item psi2
          WHERE psi2.section_id = ps.id
            AND psi2.item_kind = 'breakdown_token'
        ) AS max_sort_order
      FROM page_section ps
      JOIN phrase_page pp ON pp.id = ps.page_id
      JOIN page_section_item psi ON psi.section_id = ps.id AND psi.item_kind = 'breakdown_token'
      JOIN breakdown_token bt ON bt.id = psi.target_id
      WHERE ps.section_key = 'breakdown'
    ),
    duplicates AS (
      SELECT page_id, section_id, normalized_gloss
      FROM rows
      WHERE sort_order < max_sort_order
        AND normalized_gloss != ''
      GROUP BY page_id, section_id, normalized_gloss
      HAVING count(*) > 1
    )
    SELECT rows.page_id || ': ' || rows.english_gloss || ' = ' || group_concat(rows.token_text, ' + ')
    FROM rows
    JOIN duplicates
      ON duplicates.page_id = rows.page_id
     AND duplicates.section_id = rows.section_id
     AND duplicates.normalized_gloss = rows.normalized_gloss
    WHERE rows.sort_order < rows.max_sort_order
    GROUP BY rows.page_id, rows.section_id, rows.normalized_gloss
    ORDER BY rows.page_id, rows.section_id, rows.normalized_gloss;
  `).split("\n").filter(Boolean);
  const bannedUserFacingPatterns = [
    /Watch out/i,
    /repair phrase/i,
    /Understanding Repair/i,
    /\bDifferent ways\b/i,
    /question marker/i,
    /key word/i,
    /warning-callout/i,
    /watch-out/i,
  ];
  const bannedUserFacingMatches = [];

  function scanBannedUserFacing(scope, id, value) {
    const text = String(value ?? "");
    if (!text) return;
    for (const pattern of bannedUserFacingPatterns) {
      if (pattern.test(text)) {
        bannedUserFacingMatches.push({ scope, id, pattern: String(pattern) });
      }
    }
  }

  for (const row of pageRows) {
    scanBannedUserFacing("phrase_page.title", row.id, row.title);
    scanBannedUserFacing("phrase_page.english_title", row.id, row.english_title);
    scanBannedUserFacing("phrase_page.summary", row.id, row.summary);
  }
  for (const row of renderedSectionRows) {
    scanBannedUserFacing("page_section.title", row.id, row.title);
    scanBannedUserFacing("page_section.body", row.id, row.body);
    scanBannedUserFacing("page_section.presentation", row.id, row.presentation);
  }
  for (const row of sectionItemRows) {
    scanBannedUserFacing("page_section_item.title_override", row.id, row.title_override);
    scanBannedUserFacing("page_section_item.subtitle_override", row.id, row.subtitle_override);
  }

  const plannedMissingAudioQueueRows = writePlannedMissingAudioQueue(missingAudioRows);

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
      isIncludedInXcodeResources: languagePacksIncludedInXcodeResources,
      status: languagePacksIncludedInXcodeResources ? "bundle-ready" : "generated-not-bundled",
      requiredNextStep: languagePacksIncludedInXcodeResources
        ? ""
        : "Update native-ios/project.yml resource rules before opening this fixture with Bundle.main.",
    },
    countParity: {
      scenarios: { expected: catalog.scenarios.length, actual: catalog.scenarios.length, ok: true },
      clusters: { expected: catalog.families.length, actual: catalog.families.length, ok: true },
      phrases: { expected: catalog.phrases.length, actual: catalog.phrases.length, ok: true },
      canonicalPhrasePages: {
        expected: expectedCanonicalPhrasePages,
        actual: pageRows.length,
        ok: pageRows.length === expectedCanonicalPhrasePages,
      },
      authoredPagesOrAliases: {
        expected: authoredPages.length,
        actual: authoredPagesOrAliases,
        ok: authoredPagesOrAliases === authoredPages.length,
      },
    },
    generatedCounts,
    validation: {
      integrityCheck,
      foreignKeyCheckRows: foreignKeyRows ? foreignKeyRows.split("\n").length : 0,
      ftsRowCount: Number(sqliteQuery("SELECT count(*) FROM search_document_fts;")),
      duplicateCanonicalPageGroupCount,
      sectionlessCanonicalPageCount,
      relationshipWordsEligiblePageCount: relationshipWordsEligiblePageIDs.length,
      relationshipWordsEligiblePageIDs,
      missingRelationshipWordsSectionCount,
      unexpectedRelationshipWordsSectionCount,
      relationshipWordsMissingSample,
      relationshipWordsUnexpectedSample,
      badRelationshipWordsSectionCount,
      badQuickSayTeachingRowCount: badQuickSayTeachingRows.length,
      badQuickSayTeachingRowSample: badQuickSayTeachingRows.slice(0, 20),
      repeatedVisiblePhraseRowCount: repeatedVisiblePhraseRows.length,
      repeatedVisiblePhraseRowSample: repeatedVisiblePhraseRows.slice(0, 20),
      repeatedVisiblePhraseTextRowCount: repeatedVisiblePhraseTextRows.length,
      repeatedVisiblePhraseTextRowSample: repeatedVisiblePhraseTextRows.slice(0, 20),
      textOnlySectionRunCount: textOnlySectionRunRows.length,
      textOnlySectionRunSample: textOnlySectionRunRows.slice(0, 20),
      nonDeepCompletenessStatusCount: nonDeepCompletenessStatusRows.length,
      nonDeepCompletenessStatusSample: nonDeepCompletenessStatusRows.slice(0, 20),
      incompleteArticleContractCount: incompleteArticleContractRows.length,
      incompleteArticleContractSample: incompleteArticleContractRows.slice(0, 20),
      brokenRelationCount,
      relationSourceIndexPresent,
      relationLookupUsesSourceIndex,
      searchDocumentsWithMissingPageTargets,
      authoredPhraseSectionItemCount,
      phraseSectionRouteMismatchCount,
      visiblePhraseTextMismatchCount,
      pageTitlePhraseTextMismatchCount,
      pageEnglishTitlePhraseTextMismatchCount,
      audioUsageMismatchCount,
      badBreakdownGlossCount: badBreakdownGlossRows.length,
      badBreakdownGlossSample: badBreakdownGlossRows.slice(0, 20),
      duplicateBreakdownGlossCount: duplicateBreakdownGlossRows.length,
      duplicateBreakdownGlossSample: duplicateBreakdownGlossRows.slice(0, 20),
      bannedUserFacingMatchCount: bannedUserFacingMatches.length,
      bannedUserFacingMatches,
      cityLibraryPageCount: cityLibraryPages.length,
      cityCount: cityRows.length,
      cityPlaceCount: cityPlaceRows.length,
      cityTagCount: phraseCityTagRows.length,
    },
    unresolvedReferences: {
      detailPageIDCount: unresolvedDetailPageRefs.length,
      detailPageIDs: unresolvedDetailPageRefs,
      authoredPagePhraseIDMissingCount: authoredPagePhraseIDMissing.length,
      authoredPagePhraseIDMissing,
      authoredPhraseItemsNotInCatalogCount: authoredPhraseItemsNotInCatalog.length,
      authoredPhraseItemsNotInCatalog,
    },
    canonicalIdentity: {
      canonicalPageCount: pageRows.length,
      sourcePhraseRowCount: phraseRows.length,
      phrasesResolvedToCanonicalPages,
      duplicateNormalizedTargetTextGroupCount: duplicateNormalizedTargetGroups.length,
      resolvedDuplicateNormalizedTargetTextGroups: duplicateNormalizedTargetGroups,
      unresolvedDuplicateNormalizedTargetTextGroups,
      aliasConflictCount: aliasConflicts.length,
      aliasConflicts,
    },
    graph: {
      relationCount: relationRows.length,
      relationTypes: Array.from(countBy(relationRows, (row) => row.relation_type).entries())
        .sort(([a], [b]) => a.localeCompare(b))
        .map(([relationType, rows]) => ({ relationType, count: rows.length })),
    },
    audio: {
      manifestEntries: Object.keys(audioManifest).length,
      uniqueNormalizedSpokenTextCount: audioTextDedupeRows.length,
      assets: audioAssetRows.length,
      usages: audioUsageRows.length,
      missingAudioAuditRows: missingAudioRows.length,
      plannedMissingAudioAuditRows: missingAudioRows.filter((row) => row.severity === "planned" && row.release_blocking === 0).length,
      releaseBlockingMissingAudioAuditRows: missingAudioRows.filter((row) => row.release_blocking === 1).length,
      plannedMissingAudioQueue: relative(plannedMissingAudioQueuePath),
      plannedMissingAudioQueueRows,
      missingAudioAuditSample: missingAudioRows.slice(0, 20),
    },
    categoryData: {
      authoredCategoryCount: categoryIDs.size,
      authoredCategoryIDs: Array.from(categoryIDs).sort(),
    },
    notes: [
      "The native Swift runtime uses the bundled SQLite phrase graph by default unless explicitly disabled for JSON resource testing.",
      "SQLite is generated as a bundled fixture under Resources/LanguagePacks/viet and remains reproducible from catalog, authored page, and audio manifest inputs.",
      "Every source phrase row resolves to one canonical phrase_page through phrase.canonical_phrase_id; exact duplicate Vietnamese rows alias to one page.",
      "Legacy family, authored page, duplicate source phrase page, and section detail IDs are represented as page_alias rows.",
      "The relation table is populated from authored page links, generated category neighbors, and same-cluster variants.",
      "Practice tables remain schema-ready but intentionally unpopulated in this fixture step.",
      "City V1 pages may have planned missing audio; those rows are non-release-blocking and are queued for later recording.",
    ],
  };

  fs.writeFileSync(reportPath, `${JSON.stringify(report, null, 2)}\n`);

  console.log(`Wrote ${relative(databasePath)}`);
  console.log(`Wrote ${relative(reportPath)}`);
  console.log(`${generatedCounts.scenarios} scenarios, ${generatedCounts.clusters} clusters, ${generatedCounts.phrases} phrases, ${generatedCounts.pages} pages`);
  console.log(`SQLite integrity_check: ${integrityCheck}`);
}

main();
