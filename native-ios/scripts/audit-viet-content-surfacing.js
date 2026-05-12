#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const outputDir = path.join(repoRoot, "docs/content-audits/content-surfacing-2026-05-12");

const catalogPath = path.join(repoRoot, "native-ios/Resources/viet-phrase-catalog.json");
const pagesPath = path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json");
const audioManifestPath = path.join(repoRoot, "native-ios/Resources/viet-audio-manifest.json");
const tierOneIndexPath = path.join(repoRoot, "content-draft/viet/canonical-pages/tier-one/_tier-one-index.json");

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function csvEscape(value) {
  if (value === null || value === undefined) return "";
  const text = Array.isArray(value) ? value.join("|") : String(value);
  if (/[",\n\r]/.test(text)) return `"${text.replace(/"/g, '""')}"`;
  return text;
}

function writeCSV(filePath, rows) {
  const headers = Object.keys(rows[0] || {});
  const body = [
    headers.map(csvEscape).join(","),
    ...rows.map((row) => headers.map((header) => csvEscape(row[header])).join(",")),
  ].join("\n");
  fs.writeFileSync(filePath, `${body}\n`, "utf8");
}

function normalize(text) {
  return String(text || "")
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .toLowerCase()
    .replace(/[^\p{Letter}\p{Number}\s]/gu, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function wordCount(text) {
  return normalize(text).split(/\s+/).filter(Boolean).length;
}

function unique(values) {
  return [...new Set(values.filter(Boolean))];
}

function countBy(rows, keyFn) {
  const counts = new Map();
  for (const row of rows) {
    const key = keyFn(row) || "unknown";
    counts.set(key, (counts.get(key) || 0) + 1);
  }
  return [...counts.entries()].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]));
}

function byID(rows) {
  return new Map(rows.map((row) => [row.id, row]));
}

function scoreAudio(phrase, audioManifest) {
  if (!phrase) return 0;
  if (phrase.audioKey && audioManifest[phrase.audioKey]) return 30;
  if (phrase.audioStatus === "ready") return 24;
  if (phrase.audioKey) return 14;
  return 0;
}

function audioState(phrase, audioManifest) {
  if (!phrase) return "missing-phrase";
  if (phrase.audioKey && audioManifest[phrase.audioKey]) return "manifest-ready";
  if (phrase.audioStatus === "ready") return "ready-no-manifest-hit";
  if (phrase.audioStatus === "planned") return "planned";
  if (phrase.audioKey) return "has-key-not-in-manifest";
  return "missing";
}

function phrasePageID(phrase, pagesByPhraseID, familyByID) {
  if (!phrase) return "";
  const page = pagesByPhraseID.get(phrase.id);
  if (page) return page.id;
  const family = familyByID.get(phrase.familyID);
  return family?.pageID || "";
}

function scenarioTitle(phrase, scenarioByID) {
  return scenarioByID.get(phrase?.scenarioID)?.title || phrase?.scenarioID || "";
}

function isUsefulHomepageScenario(scenarioID) {
  return new Set([
    "polite-basics",
    "understanding-repair",
    "bathroom-personal-needs",
    "food-drink",
    "money-numbers-prices",
    "airport-border-arrival",
    "hotel-accommodation",
    "transport",
    "phone-internet-power",
    "problems-help",
    "local-services-everyday-tasks",
  ]).has(scenarioID);
}

function homepageScore(phrase, page, audioManifest) {
  let score = 0;
  if (phrase.accessTier === "starter") score += 38;
  if (page?.tierRole === "tier1") score += 18;
  if (isUsefulHomepageScenario(phrase.scenarioID)) score += 12;
  score += scoreAudio(phrase, audioManifest);

  const targetWords = wordCount(phrase.targetText);
  const englishWords = wordCount(phrase.englishText);
  if (targetWords <= 3) score += 16;
  else if (targetWords <= 5) score += 10;
  else if (targetWords <= 7) score += 4;
  else score -= 10;

  if (englishWords <= 4) score += 10;
  else if (englishWords <= 7) score += 5;
  else score -= 6;

  if (/passport|emergency|ambulance|police|injured|stolen|hospital/i.test(phrase.englishText)) score -= 8;
  if (/hello|thank|sorry|bathroom|water|menu|bill|understand|repeat|slow|wifi|sim|taxi|atm/i.test(phrase.englishText)) score += 8;
  if (phrase.cityLibraryPageKind === "phrase" && phrase.accessTier !== "starter") score -= 8;
  if (!page) score -= 10;
  return score;
}

function readinessBand(score) {
  if (score >= 90) return "homepage-now";
  if (score >= 75) return "homepage-good";
  if (score >= 60) return "secondary-shelf";
  return "keep-buried";
}

const conversationNameOverrides = new Map(Object.entries({
  "polite-hello": "First hello",
  "polite-thank-you": "Say thanks",
  "polite-excuse-me": "Excuse me",
  "polite-no-thanks": "No thanks",
  "polite-goodbye": "Say goodbye",
  "repair-understand": "Need clarity",
  "repair-slower": "Speak slower",
  "repair-repeat": "Say again",
  "repair-write-down": "Write it",
  "repair-meaning": "What means?",
  "transport-destination": "Show address",
  "transport-stop-here": "Stop here",
  "transport-wait": "Wait please",
  "transport-cash": "Pay cash",
  "transport-fare": "Ask fare",
  "transport-meter": "Use meter",
  "transport-lost": "Lost route",
  "transport-main-destination": "District 1",
  "transport-route": "Take route",
  "transport-aircon": "Turn AC",
  "hotel-reservation": "Hotel booking",
  "hotel-check-in": "Check in",
  "hotel-checkout": "Check out",
  "hotel-checkout-time": "Check-out time",
  "hotel-luggage": "Hold bags",
  "hotel-aircon-broken": "Fix AC",
  "hotel-room-hot": "Room hot",
  "hotel-more-supplies": "More towels",
  "food-menu": "Ask menu",
  "food-pay-now": "Pay bill",
  "food-need-table": "Get table",
  "food-one-portion": "Order food",
  "food-bottled-water": "Buy water",
  "food-not-spicy": "Not spicy",
  "food-no-sugar": "No sugar",
  "food-peanut-allergy": "Peanut allergy",
  "money-how-much": "Ask price",
  "money-find-atm": "Find ATM",
  "airport-baggage": "Find baggage",
  "airport-sim": "Buy SIM",
  "airport-pickup": "Find pickup",
  "airport-bag-missing": "Missing bag",
  "health-doctor": "Find doctor",
  "health-pharmacy": "Find pharmacy",
  "help-need-help": "Need help",
  "help-lost": "Lost way",
  "help-left-something": "Forgot item",
  "phone-wifi-password": "Ask Wi-Fi",
  "phone-sim": "Buy SIM",
  "bathroom-where": "Find bathroom",
  "bathroom-paper": "Toilet paper",
  "bathroom-soap": "Find soap",
  "bathroom-water": "Need water",
  "emergency-passport": "Lost passport",
  "emergency-not-safe": "Feel unsafe",
  "sight-ticket": "Buy ticket",
  "sight-photos": "Take photo",
  "sight-start": "Tour start",
  "sight-close": "Closing time",
  "service-water": "Buy water",
  "service-receipt": "Get receipt",
  "service-bag": "Need bag",
  "service-tissues": "Need tissues",
  "shopping-just-looking": "Just looking",
  "shopping-try-on": "Try on",
  "shopping-size": "Ask size",
  "shopping-color": "Ask color",
  "time-open": "Open today",
  "time-have-booking": "Have booking",
  "time-what-time": "Ask time",
  "directions-how-to-get": "Get there",
  "directions-near": "Nearby?",
  "directions-how-long": "How long",
  "directions-turn-left": "Turn left",
  "directions-turn-right": "Turn right",
  "directions-go-straight": "Go straight",
  "v500-airp-bord-arri-here-is-my-passport": "Show passport",
  "v500-airp-bord-arri-here-is-my-visa": "Show visa",
}));

function conciseConversationName(page) {
  if (conversationNameOverrides.has(page.familyID)) return conversationNameOverrides.get(page.familyID);
  if (/door-does-not-lock/.test(page.familyID)) return "Door lock";
  if (page.cityMetadata?.pageKind === "place") {
    return (page.englishTitle || page.title || "").split(/\s+/).slice(0, 3).join(" ");
  }
  let english = page.englishTitle || page.summary || page.title || "";
  const normalizedEnglish = normalize(english);
  if (/passport/.test(normalizedEnglish) && /lost|missing|do not have|dont have|new/.test(normalizedEnglish)) {
    return "Lost passport";
  }
  if (/atm/.test(normalizedEnglish)) return "Find ATM";
  if (/wifi|wi fi/.test(normalizedEnglish)) return "Ask Wi-Fi";
  if (/sim|esim/.test(normalizedEnglish)) return "Buy SIM";
  if (/bathroom|toilet|restroom/.test(normalizedEnglish)) return "Find bathroom";
  if (/doctor/.test(normalizedEnglish)) return "Find doctor";
  if (/pharmacy/.test(normalizedEnglish)) return "Find pharmacy";
  if (/ticket/.test(normalizedEnglish)) return "Buy ticket";
  if (/injured|hurt/.test(normalizedEnglish)) return "Injured";
  if (/unsafe|not safe/.test(normalizedEnglish)) return "Feel unsafe";
  if (/air conditioner|aircon|ac/.test(normalizedEnglish)) return "Fix AC";
  if (/where/.test(normalizedEnglish)) {
    const nouns = english
      .replace(/[?]/g, "")
      .split(/\s+/)
      .filter((word) => !/^(where|is|the|a|an|my|your|can|could|i|we|do|does)$/i.test(word));
    return `Find ${nouns.slice(-2).join(" ")}`.trim().split(/\s+/).slice(0, 3).join(" ");
  }
  english = english
    .replace(/[’']/g, "")
    .replace(/\b(I’d|Id|I'd|I’ll|Ill|I'm|Im|I am|I will|I want|I need)\b/gi, " ")
    .replace(/\b(can|could|would|please|i|me|my|the|a|an|is|there|where|what|how)\b/gi, " ")
    .replace(/\b(like|to|do|does|for|this|that|it|be|have|has|not|isnt|isn t)\b/gi, " ")
    .replace(/\s+/g, " ")
    .trim();
  let words = english.split(/\s+/).filter(Boolean).slice(0, 3);
  if (words.length && /^[^A-Za-z0-9À-ỹ]+$/.test(words[0])) words = words.slice(1);
  if (words.length === 1 && words[0].length > 14) words = page.title.split(/\s+/).slice(0, 3);
  const derivedName = words.join(" ") || page.title.split(/\s+/).slice(0, 3).join(" ");
  return derivedName.charAt(0).toLocaleUpperCase() + derivedName.slice(1);
}

function messagePattern(page, phrase) {
  if (page.cityMetadata?.pageKind === "place") return "entity-topic";
  if (phrase?.youMayHear) return "local-first";
  if (page.categoryIDs?.includes("city-guides")) return "city-micro-moment";
  return "traveler-first";
}

function messageCandidateScore(page, phrase, phraseByID, audioManifest) {
  let score = 0;
  const scenarioPriority = new Map(Object.entries({
    "polite-basics": 28,
    "understanding-repair": 26,
    "hotel-accommodation": 24,
    "airport-border-arrival": 24,
    "food-drink": 22,
    transport: 21,
    "bathroom-personal-needs": 20,
    "phone-internet-power": 20,
    "money-numbers-prices": 18,
    "problems-help": 18,
    "health-pharmacy": 16,
    "emergency-safety": 14,
    "sightseeing-activities": 12,
    "local-services-everyday-tasks": 12,
    shopping: 8,
    "time-dates-booking": 8,
    "social-small-talk": 6,
  }));
  score += scenarioPriority.get(phrase?.scenarioID) || 0;
  if (page.tierRole === "tier1") score += 30;
  if (page.practiceMetadata?.scenarioEligible) score += 20;
  if (page.practiceMetadata?.primaryPracticePhraseIDs?.length >= 2) score += 14;
  if (page.cityMetadata?.pageKind === "place") score += 12;
  if (phrase?.accessTier === "starter") score += 14;
  score += scoreAudio(phrase, audioManifest);
  const ids = unique([
    page.phraseID,
    ...(page.practiceMetadata?.primaryPracticePhraseIDs || []),
    ...(page.practiceMetadata?.secondaryPracticePhraseIDs || []),
  ]);
  const resolved = ids.filter((id) => phraseByID.has(id));
  score += Math.min(16, resolved.length * 3);
  if (wordCount(page.title) <= 5) score += 4;
  if (!phrase) score -= 8;
  return score;
}

function messageReadiness(score, phraseIDs) {
  if (score >= 85 && phraseIDs.length >= 4) return "ready-thread";
  if (score >= 70 && phraseIDs.length >= 2) return "ready-short-thread";
  if (phraseIDs.length >= 1) return "needs-neighbor-phrases";
  return "needs-source-phrase";
}

function expectedEssentialRows(phraseByID) {
  const essentials = [
    ["hello", ["hello", "xin chào"]],
    ["thank you", ["thank you", "cảm ơn"]],
    ["excuse me", ["excuse me", "sorry", "xin lỗi"]],
    ["goodbye", ["goodbye", "tạm biệt"]],
    ["i don't understand", ["don't understand", "không hiểu"]],
    ["speak slowly", ["speak slowly", "nói chậm"]],
    ["say again", ["say again", "repeat", "nói lại"]],
    ["write it down", ["write", "viết"]],
    ["bathroom", ["bathroom", "toilet", "nhà vệ sinh"]],
    ["water", ["water", "nước"]],
    ["menu", ["menu", "thực đơn"]],
    ["bill", ["bill", "pay", "tính tiền"]],
    ["not spicy", ["not spicy", "không cay"]],
    ["no sugar", ["no sugar", "không đường"]],
    ["wifi", ["wi-fi", "wifi"]],
    ["sim card", ["sim", "esim"]],
    ["atm", ["atm"]],
    ["reservation", ["reservation", "booking", "đặt phòng"]],
    ["passport", ["passport", "hộ chiếu"]],
    ["taxi", ["taxi", "driver"]],
    ["pickup", ["pickup", "đón"]],
    ["help", ["help", "giúp"]],
    ["doctor", ["doctor", "bác sĩ"]],
    ["pharmacy", ["pharmacy", "nhà thuốc"]],
    ["ticket", ["ticket", "vé"]],
  ];
  const phrases = [...phraseByID.values()];
  return essentials.map(([intent, needles]) => {
    const matches = phrases
      .filter((phrase) => {
        const haystack = normalize([
          phrase.id,
          phrase.familyID,
          phrase.englishText,
          phrase.targetText,
          ...(phrase.searchAliases || []),
        ].join(" "));
        return needles.some((needle) => haystack.includes(normalize(needle)));
      })
      .slice(0, 8);
    return {
      intent,
      status: matches.length ? "covered" : "missing",
      candidatePhraseIDs: matches.map((phrase) => phrase.id),
      candidateEnglish: matches.map((phrase) => phrase.englishText),
      candidateVietnamese: matches.map((phrase) => phrase.targetText),
    };
  });
}

function main() {
  const catalog = readJSON(catalogPath);
  const pagesResource = readJSON(pagesPath);
  const audioManifest = readJSON(audioManifestPath);
  const tierOneIndex = readJSON(tierOneIndexPath);

  const phrases = catalog.phrases;
  const families = catalog.families;
  const pages = pagesResource.pages;

  const phraseByID = byID(phrases);
  const familyByID = byID(families);
  const scenarioByID = byID(catalog.scenarios);
  const pageByID = byID(pages);
  const pagesByPhraseID = new Map();
  for (const page of pages) {
    if (page.phraseID && !pagesByPhraseID.has(page.phraseID)) pagesByPhraseID.set(page.phraseID, page);
  }

  ensureDir(outputDir);

  const tierOneRows = tierOneIndex.inventory.map((item, index) => {
    const page = pageByID.get(item.pageID);
    const phrase = page ? phraseByID.get(page.phraseID) : phraseByID.get(familyByID.get(item.familyID)?.primaryPhraseID);
    const sections = page?.sections || [];
    const hasPhraseRows = sections.some((section) => (section.phrases || []).length > 0);
    const hasBreakdown = sections.some((section) => (section.breakdown || []).length > 0);
    const hasGoodToKnow = sections.some((section) => /good|insight|tip/i.test(`${section.id} ${section.title}`));
    const score = [
      page?.depth === "deep" ? 25 : 0,
      sections.length >= 4 ? 20 : Math.min(20, sections.length * 4),
      hasBreakdown ? 15 : 0,
      hasPhraseRows ? 15 : 0,
      hasGoodToKnow ? 10 : 0,
      page?.practiceMetadata ? 8 : 0,
      scoreAudio(phrase, audioManifest) >= 24 ? 7 : 0,
    ].reduce((sum, part) => sum + part, 0);
    return {
      rank: index + 1,
      scenarioID: phrase?.scenarioID || "",
      scenarioTitle: scenarioTitle(phrase, scenarioByID),
      familyID: item.familyID,
      pageID: item.pageID,
      title: item.title,
      english: phrase?.englishText || page?.englishTitle || "",
      coverage: item.coverage,
      resourceFound: page ? "yes" : "no",
      tierRole: page?.tierRole || "",
      depth: page?.depth || "",
      sectionCount: sections.length,
      hasBreakdown: hasBreakdown ? "yes" : "no",
      hasPhraseRows: hasPhraseRows ? "yes" : "no",
      hasGoodToKnow: hasGoodToKnow ? "yes" : "no",
      practiceEligible: page?.practiceMetadata?.scenarioEligible ? "yes" : "no",
      practiceKind: page?.practiceMetadata?.practiceKind || "",
      audioState: audioState(phrase, audioManifest),
      buildoutScore: score,
      buildoutBand: score >= 85 ? "xin-chao-like" : score >= 70 ? "solid" : "needs-review",
    };
  });

  const homepageRows = phrases
    .map((phrase) => {
      const pageID = phrasePageID(phrase, pagesByPhraseID, familyByID);
      const page = pageByID.get(pageID);
      const score = homepageScore(phrase, page, audioManifest);
      return {
        rank: 0,
        score,
        band: readinessBand(score),
        pageID,
        phraseID: phrase.id,
        familyID: phrase.familyID,
        scenarioID: phrase.scenarioID,
        scenarioTitle: scenarioTitle(phrase, scenarioByID),
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        pronunciation: phrase.pronunciation,
        accessTier: phrase.accessTier,
        audioState: audioState(phrase, audioManifest),
        targetWordCount: wordCount(phrase.targetText),
        englishWordCount: wordCount(phrase.englishText),
        searchAliases: phrase.searchAliases || [],
        rationale: [
          phrase.accessTier === "starter" ? "starter" : "",
          page?.tierRole === "tier1" ? "tier1-page" : "",
          isUsefulHomepageScenario(phrase.scenarioID) ? "high-frequency-travel" : "",
          wordCount(phrase.targetText) <= 5 ? "short-vietnamese" : "",
          scoreAudio(phrase, audioManifest) >= 24 ? "audio-ready" : "",
        ].filter(Boolean),
      };
    })
    .filter((row) => row.pageID && row.score >= 58)
    .sort((a, b) => b.score - a.score || a.targetWordCount - b.targetWordCount || a.english.localeCompare(b.english))
    .slice(0, 120)
    .map((row, index) => ({ ...row, rank: index + 1 }));

  const messageRows = pages
    .filter((page) => page.tierRole === "tier1" || page.cityMetadata?.pageKind === "place")
    .map((page) => {
      const phrase = phraseByID.get(page.phraseID);
      const phraseIDs = unique([
        page.phraseID,
        ...(page.practiceMetadata?.primaryPracticePhraseIDs || []),
        ...(page.practiceMetadata?.secondaryPracticePhraseIDs || []),
        ...(page.sections || []).flatMap((section) => (section.phrases || []).map((row) => row.id)),
      ]).filter((id) => phraseByID.has(id)).slice(0, 10);
      const score = messageCandidateScore(page, phrase, phraseByID, audioManifest);
      const conversationName = conciseConversationName(page);
      return {
        rank: 0,
        score,
        readiness: messageReadiness(score, phraseIDs),
        conversationName,
        conversationNameWordCount: conversationName.split(/\s+/).filter(Boolean).length,
        sourcePageID: page.id,
        sourcePhraseID: page.phraseID || "",
        sourceFamilyID: page.familyID || "",
        sourceType: page.cityMetadata?.pageKind || page.tierRole,
        entryPattern: messagePattern(page, phrase),
        vietnamese: page.title,
        english: page.englishTitle,
        scenarioID: phrase?.scenarioID || page.cityMetadata?.subcategoryID || "",
        phraseIDs,
        firstExchangePhraseID: phraseIDs[0] || "",
        avoidNewPhrases: "yes",
        audioState: audioState(phrase, audioManifest),
        note: phraseIDs.length >= 4
          ? "Enough existing phrase IDs for a short 4-5 turn conversation."
          : "Use as a short seed; borrow neighboring phrase IDs before creating any new phrase.",
      };
    })
    .filter((row) => row.score >= 52)
    .sort((a, b) => b.score - a.score || a.conversationName.localeCompare(b.conversationName))
    .slice(0, 160)
    .map((row, index) => ({ ...row, rank: index + 1 }));

  const audioRows = countBy(phrases, (phrase) => `${phrase.scenarioID}|${phrase.audioStatus || "unknown"}`)
    .map(([key, count]) => {
      const [scenarioID, status] = key.split("|");
      return {
        scenarioID,
        scenarioTitle: scenarioByID.get(scenarioID)?.title || scenarioID,
        audioStatus: status,
        phraseCount: count,
      };
    });

  const cityPages = pages.filter((page) => page.tierRole === "city-v1");
  const cityGapRows = countBy(cityPages, (page) => [
    page.cityMetadata?.cityID || "unknown-city",
    page.cityMetadata?.pageKind || "unknown-page-kind",
    page.cityMetadata?.placeKind || "unknown-place-kind",
    page.cityMetadata?.derivedPlacePhrase ? "derived" : "entity",
  ].join("|")).map(([key, count]) => {
    const [cityID, pageKind, placeKind, layer] = key.split("|");
    return {
      cityID,
      pageKind,
      placeKind,
      layer,
      pageCount: count,
      surfacingRisk: pageKind === "phrase" && layer === "derived" ? "hide-from-level-zero-browse" : "safe-entity-row",
      recommendation: pageKind === "phrase" && layer === "derived"
        ? "Keep searchable and visible inside entity pages/messages; do not top-surface as city browse rows."
        : "Use as level-zero browse row and message topic.",
    };
  });

  const foodEntityCandidates = new Map(Object.entries({
    "food-coffee-milk": "Cà phê sữa đá / iced milk coffee",
    "food-coffee-black": "Cà phê đen đá / iced black coffee",
    "food-coffee-bac-xiu": "Bạc xỉu đá / iced bạc xỉu",
    "food-bottled-water": "Nước suối / bottled water",
    "food-one-portion": "Một phần / one portion",
    "food-this-bowl": "Tô này / this bowl",
  }));

  const entityFirstGaps = [
    ...pages
      .filter((page) => page.tierRole === "tier1" && foodEntityCandidates.has(page.familyID))
      .map((page) => ({
        area: "food-drink",
        gapType: "phrase-first-category-row",
        sourcePageID: page.id,
        currentTitle: page.title,
        currentEnglish: page.englishTitle,
        suggestedEntityLayer: foodEntityCandidates.get(page.familyID),
        recommendation: "Consider a noun/entity page first, then attach order/adjust phrases below it.",
      })),
    ...cityGapRows
      .filter((row) => row.surfacingRisk === "hide-from-level-zero-browse")
      .slice(0, 50)
      .map((row) => ({
        area: row.cityID,
        gapType: "derived-city-phrase-volume",
        sourcePageID: "",
        currentTitle: `${row.pageCount} ${row.placeKind} derived phrase pages`,
        currentEnglish: row.pageKind,
        suggestedEntityLayer: row.placeKind,
        recommendation: row.recommendation,
      })),
  ];

  const essentialRows = expectedEssentialRows(phraseByID);

  const summaryRows = [
    ["Runtime phrases", phrases.length],
    ["Runtime families", families.length],
    ["Runtime scenarios", catalog.scenarios.length],
    ["Runtime listing pages", pages.length],
    ["Tier 1 inventory", tierOneIndex.inventory.length],
    ["Tier 1 xin-chao-like pages", tierOneRows.filter((row) => row.buildoutBand === "xin-chao-like").length],
    ["Homepage candidates emitted", homepageRows.length],
    ["Message candidates emitted", messageRows.length],
    ["Entity-first gaps emitted", entityFirstGaps.length],
    ["Covered essentials", essentialRows.filter((row) => row.status === "covered").length],
  ];

  writeCSV(path.join(outputDir, "tier1-listings.csv"), tierOneRows);
  writeCSV(path.join(outputDir, "homepage-quick-phrase-candidates.csv"), homepageRows);
  writeCSV(path.join(outputDir, "message-conversation-candidates.csv"), messageRows);
  writeCSV(path.join(outputDir, "audio-coverage-by-scenario.csv"), audioRows);
  writeCSV(path.join(outputDir, "city-entity-vs-derived-phrases.csv"), cityGapRows);
  writeCSV(path.join(outputDir, "entity-first-browse-gaps.csv"), entityFirstGaps);
  writeCSV(path.join(outputDir, "easy-beginner-essential-coverage.csv"), essentialRows);

  const topHomepage = homepageRows.slice(0, 24);
  const topMessages = messageRows.slice(0, 30);
  const missingEssentials = essentialRows.filter((row) => row.status !== "covered");
  const audioStatusCounts = countBy(phrases, (phrase) => phrase.audioStatus || "unknown");
  const pageRoleCounts = countBy(pages, (page) => page.tierRole || "unknown");

  const report = `# Viet Content Coverage And Surfacing Audit

Date: 2026-05-12

## Why This Exists

This audit maps the shipped Viet phrase catalog into concrete surfaces:

- Tier 1 listing pages that are already fully built out.
- Quick, friendly homepage phrase candidates.
- Messages conversation seeds that reuse existing phrase IDs first.
- Audio coverage by scenario.
- Entity-first Browse gaps where nouns/entities should surface before long-tail phrases.
- Easy beginner essentials coverage.

## Headline Counts

${summaryRows.map(([label, value]) => `- ${label}: ${value}`).join("\n")}

Phrase audio status:
${audioStatusCounts.map(([status, count]) => `- ${status}: ${count}`).join("\n")}

Listing page roles:
${pageRoleCounts.map(([role, count]) => `- ${role}: ${count}`).join("\n")}

## Homepage Surfacing Recommendation

Use the CSV \`homepage-quick-phrase-candidates.csv\` as the source list for expanding "Use now" and other beginner shelves. The top ranked phrases are short, audio-backed, starter-friendly, and high-frequency.

Top candidates:

| Rank | Phrase | English | Page | Band |
| --- | --- | --- | --- | --- |
${topHomepage.map((row) => `| ${row.rank} | ${row.vietnamese} | ${row.english} | \`${row.pageID}\` | ${row.band} |`).join("\n")}

## Messages Reuse Recommendation

Use \`message-conversation-candidates.csv\` as the first pass for Messages. Each row includes a short conversation name, source page, entry pattern, and existing phrase IDs. The rule is: build the chat around those IDs before creating any new phrase.

Top message seeds:

| Rank | Name | Source | Entry | Existing phrase IDs |
| --- | --- | --- | --- | --- |
${topMessages.map((row) => `| ${row.rank} | ${row.conversationName} | \`${row.sourcePageID}\` | ${row.entryPattern} | ${row.phraseIDs.slice(0, 5).map((id) => `\`${id}\``).join(", ")} |`).join("\n")}

## Tier 1 Listing Pages

The Tier 1 inventory still resolves to ${tierOneRows.length} rows. This audit scores whether each page is "Xin chào-like" from the runtime resource itself: deep page, multiple sections, breakdown, related phrase rows, useful note/insight, practice metadata, and audio.

- Xin-chao-like: ${tierOneRows.filter((row) => row.buildoutBand === "xin-chao-like").length}
- Solid: ${tierOneRows.filter((row) => row.buildoutBand === "solid").length}
- Needs review: ${tierOneRows.filter((row) => row.buildoutBand === "needs-review").length}

See \`tier1-listings.csv\` for the full page map.

## Entity-First Browse Direction

The app has a strong city entity layer, but long-tail city phrase volume is much larger than the noun/entity layer. That is fine for search and entity detail pages, but city/category browse should keep showing noun/entity rows first.

Use:

- \`city-entity-vs-derived-phrases.csv\` for city/entity volume.
- \`entity-first-browse-gaps.csv\` for rows that should not be promoted as top-level Browse cards.

## Easy Beginner Essentials

${missingEssentials.length === 0 ? "All audited beginner essentials have at least one existing phrase match." : `Missing or weak essentials: ${missingEssentials.map((row) => row.intent).join(", ")}`}

See \`easy-beginner-essential-coverage.csv\` for phrase IDs by intent.

## Generated Artifacts

- \`tier1-listings.csv\`
- \`homepage-quick-phrase-candidates.csv\`
- \`message-conversation-candidates.csv\`
- \`audio-coverage-by-scenario.csv\`
- \`city-entity-vs-derived-phrases.csv\`
- \`entity-first-browse-gaps.csv\`
- \`easy-beginner-essential-coverage.csv\`

## Next Product Moves

1. Homepage can expand "Use now" from the first 24-48 rows in \`homepage-quick-phrase-candidates.csv\`.
2. Messages can start with the \`ready-thread\` and \`ready-short-thread\` rows from \`message-conversation-candidates.csv\`.
3. Browse/category work should use \`entity-first-browse-gaps.csv\` to avoid resurfacing long-tail phrase rows where an entity page should come first.
4. Audio planning should focus on \`planned\` rows in city and premium phrase coverage, not on the already audio-backed starter rows.
`;

  fs.writeFileSync(path.join(outputDir, "README.md"), report, "utf8");

  console.log(JSON.stringify({
    outputDir,
    summary: Object.fromEntries(summaryRows),
    topHomepage: topHomepage.slice(0, 5).map((row) => [row.vietnamese, row.english, row.pageID]),
    topMessages: topMessages.slice(0, 5).map((row) => [row.conversationName, row.sourcePageID, row.phraseIDs.slice(0, 4)]),
  }, null, 2));
}

main();
