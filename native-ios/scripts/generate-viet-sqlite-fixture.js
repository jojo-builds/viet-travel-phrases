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
  const languagePacksExcludedFromBroadResources = /excludes:\s*(?:\n\s+- .*)*\n\s+- LanguagePacks/m.test(xcodeProject);
  const languagePacksExplicitlyIncluded = /-\s+path:\s*Resources\/LanguagePacks\b/m.test(xcodeProject);
  const languagePacksIncludedInXcodeResources =
    languagePacksExplicitlyIncluded || !languagePacksExcludedFromBroadResources;

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
      completeness_status: authoredPage?.depth ?? ((family?.phraseIDs ?? []).length > 1 ? "support" : "baseline"),
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
      english_title: authoredPage?.englishTitle ?? phrase.englishText,
      summary: pageSummaryForPhrase(phrase, authoredPage, family),
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
  const relationRows = [];
  const usedSectionIDs = new Set();
  const pageCategoryKeys = new Set();
  const relationKeys = new Set();

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

  function baselineContextBody(phrase, family) {
    const context = sentence(phrase.context);
    if (context) return context;
    const summary = sentence(family?.summary);
    if (summary) return summary;
    return `${phrase.targetText} is the phrase to keep ready for "${phrase.englishText}" in ${scenarioTitle(phrase.scenarioID)}.`;
  }

  function pageSummaryForPhrase(phrase, authoredPage, family) {
    if (authoredPage?.summary) return authoredPage.summary;
    const summary = sentence(family?.summary);
    if (summary && !/^use this when\b/i.test(summary)) return summary;
    return `Different ways to say "${phrase.englishText}" in Vietnam, starting with ${phrase.targetText} and the pieces to recognize.`;
  }

  function scenarioNeighborPhrases(phrase) {
    const family = familyByID.get(phrase.familyID);
    const familyPhraseIDs = (family?.phraseIDs ?? []).filter((phraseID) => phraseID !== phrase.id);
    const scenarioFamilies = catalog.families.filter((candidate) => candidate.scenarioID === phrase.scenarioID);
    const familyIndex = scenarioFamilies.findIndex((candidate) => candidate.id === phrase.familyID);
    const neighborFamilyPhraseIDs = [
      scenarioFamilies[familyIndex - 1]?.primaryPhraseID,
      scenarioFamilies[familyIndex + 1]?.primaryPhraseID,
      scenarioFamilies[familyIndex + 2]?.primaryPhraseID,
    ].filter(Boolean);
    const seen = new Set();
    return [...familyPhraseIDs, ...neighborFamilyPhraseIDs]
      .filter((phraseID) => {
        const targetPhrase = phraseByID.get(phraseID);
        const canonicalPageID = canonicalPageIDForPhrase(phraseID);
        if (!targetPhrase || !canonicalPageID || canonicalPageID === canonicalPageIDForPhrase(phrase.id)) return false;
        if (seen.has(canonicalPageID)) return false;
        seen.add(canonicalPageID);
        return true;
      })
      .slice(0, 3)
      .map((phraseID) => phraseByID.get(phraseID));
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

    for (const [index, categoryID] of (page.categoryIDs ?? []).entries()) {
      addPageCategory(canonicalPageID, categoryID, index, relative(authoredPagesPath));
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
        const resolvedPhraseID = resolvedCatalogPhraseIDForAuthoredPhrase(phrase);
        const targetID = resolvedPhraseID ?? `authored:${phrase.id}`;
        sectionItemRows.push({
          id: `${sectionID}:phrase:${itemIndex}:${stableID([phrase.id, phrase.vietnamese, phrase.english])}`,
          section_id: sectionID,
          item_kind: resolvedPhraseID ? "phrase" : "authored_phrase",
          target_id: targetID,
          title_override: phrase.vietnamese ?? null,
          subtitle_override: phrase.english ?? null,
          note: resolvedPhraseID ? canonicalPageIDForPhrase(resolvedPhraseID) : (phrase.detailPageID ?? null),
          sort_order: itemIndex,
        });
        if (resolvedPhraseID) {
          addPageRelation({
            sourcePhraseID: page.phraseID,
            targetPhraseID: resolvedPhraseID,
            relationType: section.id === "explore-next" ? "next_step_after" : "see_also",
            reason: `Authored ${section.title ?? section.id} row links these phrase pages.`,
            displayLabel: section.title ?? "Related",
            sortOrder: itemIndex,
            sourcePath: relative(authoredPagesPath),
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
      body: `Start with ${phrase.targetText} when "${phrase.englishText}" is the main idea you need to get across.`,
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

    addSection({
      pageID: pageRow.id,
      sectionKey: "when-to-use",
      title: "When to use it",
      body: baselineContextBody(phrase, family),
      presentation: "plain-text",
      sortOrder: 3,
      sourcePath: relative(catalogPath),
    });

    if (phrase.youMayHear) {
      addSection({
        pageID: pageRow.id,
        sectionKey: "what-you-may-hear",
        title: "What you may hear",
        body: sentence(phrase.youMayHear),
        presentation: "plain-text",
        sortOrder: 4,
        sourcePath: relative(catalogPath),
      });
    }

    addSection({
      pageID: pageRow.id,
      sectionKey: "good-to-know",
      title: "Good to know",
      body: `Say it once, then give the other person the place, item, screen, or document that makes the request clear.`,
      presentation: "tip-callout",
      sortOrder: 5,
      sourcePath: relative(catalogPath),
    });

    const nearbyPhrases = scenarioNeighborPhrases(phrase);
    const nearbySectionID = addSection({
      pageID: pageRow.id,
      sectionKey: "nearby-phrases",
      title: "Nearby phrases",
      body: nearbyPhrases.length > 0
        ? `These nearby ${scenario?.title ?? "travel"} phrases help if the answer creates one more step.`
        : `This phrase is ready as a standalone ${scenario?.title ?? "travel"} page.`,
      presentation: "phrase-list",
      sortOrder: 6,
      sourcePath: relative(catalogPath),
    });
    nearbyPhrases.forEach((nearbyPhrase, index) => {
      addPhraseSectionItem({
        sectionID: nearbySectionID,
        phrase: nearbyPhrase,
        sortOrder: index,
        note: canonicalPageIDForPhrase(nearbyPhrase.id),
      });
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
      category_text: [scenario?.title, family?.familyTitle, ...(page?.categoryIDs ?? [])].filter(Boolean).join(" "),
      related_text: [family?.summary, phrase.context, phrase.youMayHear].filter(Boolean).join(" "),
      priority_tier: page ? 100 : phrase.accessTier === "starter" ? 75 : 50,
      is_canonical_page: 1,
    };
  });

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
      AND lower(bt.english_gloss) = lower(pp.english_title);
  `).split("\n").filter(Boolean);
  const bannedUserFacingPatterns = [
    /Watch out/i,
    /repair phrase/i,
    /Understanding Repair/i,
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
  for (const row of sectionRows) {
    scanBannedUserFacing("page_section.title", row.id, row.title);
    scanBannedUserFacing("page_section.body", row.id, row.body);
    scanBannedUserFacing("page_section.presentation", row.id, row.presentation);
  }
  for (const row of sectionItemRows) {
    scanBannedUserFacing("page_section_item.title_override", row.id, row.title_override);
    scanBannedUserFacing("page_section_item.subtitle_override", row.id, row.subtitle_override);
  }

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
      scenarios: { expected: 18, actual: catalog.scenarios.length, ok: catalog.scenarios.length === 18 },
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
      brokenRelationCount,
      relationSourceIndexPresent,
      relationLookupUsesSourceIndex,
      searchDocumentsWithMissingPageTargets,
      authoredPhraseSectionItemCount,
      phraseSectionRouteMismatchCount,
      audioUsageMismatchCount,
      badBreakdownGlossCount: badBreakdownGlossRows.length,
      badBreakdownGlossSample: badBreakdownGlossRows.slice(0, 20),
      bannedUserFacingMatchCount: bannedUserFacingMatches.length,
      bannedUserFacingMatches,
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
    ],
  };

  fs.writeFileSync(reportPath, `${JSON.stringify(report, null, 2)}\n`);

  console.log(`Wrote ${relative(databasePath)}`);
  console.log(`Wrote ${relative(reportPath)}`);
  console.log(`${generatedCounts.scenarios} scenarios, ${generatedCounts.clusters} clusters, ${generatedCounts.phrases} phrases, ${generatedCounts.pages} pages`);
  console.log(`SQLite integrity_check: ${integrityCheck}`);
}

main();
