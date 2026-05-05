#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "../..");
const listingPath = path.join(root, "native-ios/Resources/viet-authored-listing-pages.json");
const catalogPath = path.join(root, "native-ios/Resources/viet-phrase-catalog.json");
const audioAuditPath = path.join(root, "native-ios/Resources/viet-authored-audio-audit.json");
const legacyAuditPath = path.join(root, "docs/content-audits/viet-canonical-content-audit-001/per-page-audit.jsonl");
const outDir = path.join(root, "docs/content-audits/viet-canonical-editorial-finish-all-001");

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .replace(/\s+/g, " ")
    .trim();
}

function wordTokens(value) {
  return new Set(Array.from(String(value || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .replace(/đ/g, "d")
    .matchAll(/[a-z0-9]+/g), (match) => match[0]));
}

function csv(value) {
  const text = value == null ? "" : String(value);
  return /[",\n]/.test(text) ? `"${text.replace(/"/g, '""')}"` : text;
}

function sourceMap() {
  if (!fs.existsSync(legacyAuditPath)) return new Map();
  return new Map(fs.readFileSync(legacyAuditPath, "utf8")
    .split(/\n+/)
    .filter(Boolean)
    .map((line) => JSON.parse(line))
    .map((row) => [row.pageID, row]));
}

function pageProfile(page) {
  const meta = page.cityMetadata || {};
  const pageKind = meta.pageKind || "";
  const placeKind = meta.placeKind || "";
  const contentRole = meta.contentRole || "";
  const categories = new Set(page.categoryIDs || []);
  const title = normalize(`${page.title} ${page.englishTitle}`);
  if (pageKind === "restaurant") return "restaurant";
  if (pageKind === "dish") return "dish";
  if (pageKind === "place" && (placeKind === "street" || categories.has("street-pronouncer") || /\bduong\b/.test(title))) return "streetDriver";
  if (pageKind === "place") return "landmark";
  if (page.tierRole === "city-v1" || meta.cityID) return "cityPhrase";
  return "singlePhrase";
}

function isNamePage(profile) {
  return ["landmark", "restaurant", "dish", "streetDriver"].includes(profile);
}

function expectedPracticeKind(profile, page) {
  const categories = new Set(page.categoryIDs || []);
  const text = normalize(`${page.title} ${page.englishTitle}`);
  const tokens = wordTokens(page.title || "");
  const englishTitle = String(page.englishTitle || "").toLowerCase();
  if (
    categories.has("polite-basics")
    && (
      tokens.has("chao")
      || englishTitle.includes("hello")
      || ["anh", "chi", "em", "co", "chu", "ong", "ba"].some((token) => tokens.has(token))
    )
  ) return "greeting_choice_mini_flow";
  if (profile === "restaurant") return "restaurant_ordering_scenario";
  if (profile === "dish") return "dish_ordering_scenario";
  if (profile === "streetDriver") return "street_driver_mini_scenario";
  if (profile === "landmark" && /\bba na hills\b|\bmarble mountains\b|\bairport\b/.test(text)) return "trip_journey_scenario";
  if (profile === "landmark") return "place_visit_mini_scenario";
  if (categories.has("emergency-safety")) return "urgent_help_scenario";
  if (
    categories.has("hotel-accommodation")
    || categories.has("airport-border-arrival")
    || categories.has("transport")
    || categories.has("health-pharmacy")
    || categories.has("bathroom-personal-needs")
    || categories.has("shopping")
  ) return "practical_flow_scenario";
  return "phrase_audio_review";
}

function expectedPracticeCTA(profile, page) {
  const kind = expectedPracticeKind(profile, page);
  return {
    greeting_choice_mini_flow: "Practice this greeting",
    restaurant_ordering_scenario: "Practice ordering here",
    dish_ordering_scenario: "Practice ordering this",
    street_driver_mini_scenario: "Practice this street",
    trip_journey_scenario: "Practice this trip",
    place_visit_mini_scenario: "Practice this place",
    urgent_help_scenario: "Practice urgent help",
    practical_flow_scenario: "Practice this situation",
    phrase_audio_review: "Practice this phrase",
  }[kind] || "Practice this phrase";
}

function displayPage(page) {
  return page ? `${page.title}${page.englishTitle ? ` / ${page.englishTitle}` : ""}` : "";
}

const representativeSamples = [
  ["dragon-bridge", "viet-family-city-danang-place-dragon-bridge"],
  ["ba-na-hills", "viet-family-city-danang-place-ba-na-hills"],
  ["marble-mountains", "viet-family-city-danang-place-marble-mountains"],
  ["linh-ung", "viet-family-city-danang-place-linh-ung-pagoda"],
  ["nguyen-van-linh", "viet-family-city-danang-place-nguyen-van-linh-street"],
  ["bach-dang", "viet-family-city-danang-place-bach-dang-street"],
  ["bun-cha-huong-lien", "viet-family-city-hanoi-place-bun-cha-huong-lien"],
  ["pho-bat-dan", "viet-family-city-hanoi-place-pho-bat-dan"],
  ["bun-bo-hue", "viet-family-city-hue-place-bun-bo-city"],
  ["cao-lau", "viet-family-city-hoian-place-cao-lau-city"],
  ["bathroom", "viet-family-bathroom-where"],
  ["hotel-check-in", "viet-hotel-check-in"],
  ["airport-arrival", "viet-family-airport-immigration"],
  ["taxi-grab", "viet-family-transport-destination"],
];

const practiceMetadataSampleIDs = [
  "viet-family-city-danang-place-dragon-bridge",
  "viet-family-city-danang-place-ba-na-hills",
  "viet-family-city-danang-place-nguyen-van-linh-street",
  "viet-family-city-hanoi-place-bun-cha-huong-lien",
  "viet-hotel-check-in",
];

function samplePageLookup(pages) {
  const byID = new Map(pages.map((page) => [page.id, page]));
  const findByNeedle = (needle) => pages.find((page) => normalize(`${page.id} ${page.title} ${page.englishTitle}`).includes(normalize(needle)));
  return (sampleID, preferredID) => byID.get(preferredID) || findByNeedle(sampleID);
}

function renderedExcerpt(page, label) {
  if (!page) {
    return `## ${label}\n\nMissing from generated runtime resource.\n`;
  }
  const lines = [
    `## ${label}: ${displayPage(page)}`,
    "",
    `- Page ID: ${page.id}`,
    `- Sections: ${(page.sections || []).map((section) => section.title).join(" > ")}`,
    `- Practice: ${page.practiceMetadata?.practiceKind || ""} / ${page.practiceMetadata?.practiceCTALabel || ""}`,
    `- Hero: ${page.heroImageName || "generic language masthead"}`,
    "",
  ];
  for (const section of page.sections || []) {
    lines.push(`### ${section.title}`);
    if (section.body) lines.push(section.body);
    const phrases = (section.phrases || []).slice(0, 4);
    for (const phrase of phrases) {
      lines.push(`- ${phrase.vietnamese} — ${phrase.english}`);
    }
    const breakdown = (section.breakdown || []).slice(0, 4);
    for (const token of breakdown) {
      lines.push(`- ${token.vietnamese} = ${token.english}`);
    }
    lines.push("");
  }
  return `${lines.join("\n").trim()}\n`;
}

function audioPriority(page, item) {
  const profile = page ? pageProfile(page) : "";
  const text = normalize(`${item.text} ${page?.title || ""} ${page?.englishTitle || ""}`);
  if (item.kind === "hero" && profile === "streetDriver") return "P0_street_name";
  if (item.kind === "hero" && profile === "restaurant") return "P0_restaurant_name";
  if (item.kind === "hero" && profile === "dish") return "P0_dish_name";
  if (item.kind === "hero" && profile === "landmark") return "P0_landmark_name";
  if (/ba na|cau rong|dragon bridge|ngu hanh son|marble mountains|linh ung|nguyen van linh|bach dang|vo nguyen giap/.test(text)) {
    return "P0_top_place_or_street";
  }
  if (["restaurant", "dish", "streetDriver", "landmark"].includes(profile)) return "P1_name_page_phrase";
  if (page?.practiceMetadata?.practiceKind && page.practiceMetadata.practiceKind !== "phrase_audio_review") return "P1_scenario_phrase";
  return "P2_planned_audio";
}

function writeAcceptanceArtifacts(pages) {
  const lookup = samplePageLookup(pages);
  const byID = new Map(pages.map((page) => [page.id, page]));
  const excerpts = [
    "# Representative Rendered Text Excerpts",
    "",
    "Text dump from `native-ios/Resources/viet-authored-listing-pages.json`. This is the content the native listing renderer consumes.",
    "",
    ...representativeSamples.map(([label, id]) => renderedExcerpt(lookup(label, id), label)),
  ].join("\n");
  fs.writeFileSync(path.join(outDir, "representative-page-excerpts.md"), excerpts);

  const practiceSamples = {};
  for (const id of practiceMetadataSampleIDs) {
    const page = byID.get(id) || lookup(id, id);
    if (!page) continue;
    practiceSamples[id] = {
      title: displayPage(page),
      practiceMetadata: page.practiceMetadata || null,
    };
  }
  fs.writeFileSync(path.join(outDir, "practice-metadata-samples.json"), JSON.stringify(practiceSamples, null, 2) + "\n");

  const heroHeaders = ["pageID", "title", "profile", "heroImageName", "issue", "followUp"];
  const heroRows = pages
    .filter((page) => isNamePage(pageProfile(page)))
    .map((page) => ({
      pageID: page.id,
      title: displayPage(page),
      profile: pageProfile(page),
      heroImageName: page.heroImageName || "",
      issue: page.heroImageName ? "" : "generic_language_masthead",
      followUp: page.heroImageName ? "" : "Add owned/licensed/generated page-specific artwork when this page becomes high priority.",
    }));
  fs.writeFileSync(path.join(outDir, "hero-image-followups.csv"), [
    heroHeaders.join(","),
    ...heroRows.map((row) => heroHeaders.map((header) => csv(row[header])).join(",")),
  ].join("\n") + "\n");

  const fallback = {
    generatedAt: new Date().toISOString(),
    note: "Fallback here means the page is using the deterministic lightweight traveler template instead of a page-specific human patch.",
    countsByProfile: pages.reduce((acc, page) => {
      const profile = pageProfile(page);
      acc[profile] = (acc[profile] || 0) + 1;
      return acc;
    }, {}),
    pageSpecificHeroCount: pages.filter((page) => page.heroImageName).length,
    genericHeroNamePageCount: pages.filter((page) => isNamePage(pageProfile(page)) && !page.heroImageName).length,
  };
  fs.writeFileSync(path.join(outDir, "fallback-template-report.json"), JSON.stringify(fallback, null, 2) + "\n");

  if (fs.existsSync(audioAuditPath)) {
    const audioAudit = readJSON(audioAuditPath);
    const audioHeaders = ["priority", "pageID", "title", "profile", "sectionID", "kind", "text", "audioKey"];
    const rows = (audioAudit.required || [])
      .filter((item) => !item.resolved)
      .map((item) => {
        const page = byID.get(item.pageID);
        return {
          priority: audioPriority(page, item),
          pageID: item.pageID,
          title: displayPage(page),
          profile: page ? pageProfile(page) : "",
          sectionID: item.sectionID || "",
          kind: item.kind || "",
          text: item.text || "",
          audioKey: item.audioKey || "",
        };
      })
      .sort((a, b) => a.priority.localeCompare(b.priority) || a.pageID.localeCompare(b.pageID));
    fs.writeFileSync(path.join(outDir, "missing-audio-priority.csv"), [
      audioHeaders.join(","),
      ...rows.map((row) => audioHeaders.map((header) => csv(row[header])).join(",")),
    ].join("\n") + "\n");
  }
}

function textForPage(page) {
  const parts = [page.title, page.englishTitle, page.summary];
  for (const section of page.sections || []) {
    parts.push(section.title, section.body);
    for (const phrase of section.phrases || []) parts.push(phrase.vietnamese, phrase.english);
    for (const token of section.breakdown || []) parts.push(token.vietnamese, token.english);
  }
  return parts.filter(Boolean).join("\n");
}

function repeatedBodies(pages) {
  const counts = new Map();
  for (const page of pages) {
    for (const section of page.sections || []) {
      const body = String(section.body || "").trim();
      if (body.length < 110) continue;
      const key = normalize(body);
      const row = counts.get(key) || { body, pages: new Set() };
      row.pages.add(page.id);
      counts.set(key, row);
    }
  }
  return counts;
}

const internalChecks = [
  ["internal_place_name", /\bplace name\b/i],
  ["internal_useful_moments", /\buseful moments\b/i],
  ["internal_route_phrase", /\broute phrase\b/i],
  ["internal_where_question", /\bwhere-question\b|where-questions\b/i],
  ["internal_connect_to", /\bconnect to:\b|\bconnect it to\b/i],
  ["internal_this_page", /\bthis page\b/i],
  ["internal_relationship_rows", /\brelationship rows\b/i],
  ["internal_content_role", /\bcontent role\b/i],
  ["internal_page_kind", /\bpage kind\b/i],
  ["internal_anchor", /\banchor\b/i],
  ["internal_durable_next_steps", /\bdurable next steps\b/i],
  ["internal_database", /\bdatabase\b/i],
  ["internal_canonical", /\bcanonical\b/i],
  ["internal_notes_below", /\bnotes below\b/i],
  ["internal_likely_replies", /\blikely replies\b/i],
  ["internal_the_user", /\bthe user\b/i],
  ["internal_meta_review", /\bwithout turning (?:this|the) page into\b/i],
  ["internal_generator_phrase", /\bGo next to phrases that help\b/i],
  ["internal_complete_line", /\bUse the complete line\b/i],
  ["internal_situation_visible", /\bKeep the situation visible\b/i],
  ["bad_question_period", /\?\./],
];

const placeholderGlossChecks = [
  ["placeholder_full_phrase", /^full phrase$/i],
  ["placeholder_key_word", /^key word$/i],
  ["placeholder_first_name_part", /^first name part$/i],
  ["placeholder_second_name_part", /^second name part$/i],
  ["placeholder_question_ending", /^question ending$/i],
  ["placeholder_name_recognition", /\bname recognition\b/i],
  ["placeholder_name_ending", /\bname ending\b/i],
  ["placeholder_local_place", /\blocal place\b/i],
];

const namePageInstructionPattern = /\b(Use this when|Use it when|Use these with|Use the full sentence|This helps you|This phrase helps|The useful moments are|The name works best|Use .* as .* anchor)\b/i;

function issuesForPage(page, bodyCounts) {
  const profile = pageProfile(page);
  const text = textForPage(page);
  const issues = [];
  for (const [code, regex] of internalChecks) {
    if (regex.test(text)) issues.push(code);
  }

  for (const section of page.sections || []) {
    const body = String(section.body || "");
    const repeated = body.length >= 110 ? bodyCounts.get(normalize(body)) : null;
    if (repeated?.pages.size >= 25) issues.push("robotic_repeated_section_body");
    if (isNamePage(profile) && namePageInstructionPattern.test(body)) {
      issues.push("patronizing_name_page_instruction");
    }
    if (isNamePage(profile) && /^(Use it with|When to use it|Place anchor|Place brief)$/i.test(section.title || "")) {
      issues.push("wrong_page_type_section");
    }
    if (String(section.body || "").split(/\s+/).filter(Boolean).length > 45) {
      issues.push("section_body_too_long");
    }
    if (/(?:sentences are below|More phrases for this situation|Useful next phrases|Play each piece)/i.test(section.body || "")) {
      issues.push("scaffolding_section_body");
    }
    if (!String(section.body || "").trim() && (section.phrases || []).length === 0 && (section.breakdown || []).length === 0) {
      issues.push("empty_rendered_section");
    }
    for (const token of section.breakdown || []) {
      for (const [code, regex] of placeholderGlossChecks) {
        if (regex.test(String(token.english || "").trim())) issues.push(code);
      }
    }
  }

  if (profile === "restaurant" && !/\b(order|menu|bill|pay|drink|table|taxi|ride)\b/i.test(text)) {
    issues.push("restaurant_not_interaction_oriented");
  }
  if (profile === "dish" && !/\b(order|inside|ingredient|spicy|allergy|dish|food)\b/i.test(text)) {
    issues.push("dish_not_order_oriented");
  }
  if (profile === "streetDriver" && !/\b(driver|street|drop|wrong place|taxi|grab)\b/i.test(text)) {
    issues.push("street_missing_driver_flow");
  }
  const practice = page.practiceMetadata || {};
  if (!practice.integrationVersion) {
    issues.push("missing_practice_integration_metadata");
  } else {
    if (practice.practiceKind !== expectedPracticeKind(profile, page)) {
      issues.push("practice_kind_mismatch");
    }
    if (practice.practiceCTALabel !== expectedPracticeCTA(profile, page)) {
      issues.push("practice_cta_mismatch");
    }
    if (!practice.scenarioSeedID || !Array.isArray(practice.scenarioStepGroups) || practice.scenarioStepGroups.length === 0) {
      issues.push("practice_seed_missing_steps");
    }
    if (!Array.isArray(practice.primaryPracticePhraseIDs) || practice.primaryPracticePhraseIDs.length === 0) {
      issues.push("practice_seed_missing_primary_phrases");
    }
  }

  return Array.from(new Set(issues)).sort();
}

function main() {
  const pages = readJSON(listingPath).pages || [];
  const catalog = readJSON(catalogPath);
  const phraseByID = new Map((catalog.phrases || []).map((phrase) => [phrase.id, phrase]));
  const sources = sourceMap();
  const bodyCounts = repeatedBodies(pages);
  const tracker = [];
  const issues = [];
  const profileCounts = {};
  const statusCounts = {};
  const issueCounts = {};

  for (const page of pages) {
    const profile = pageProfile(page);
    const pageIssues = issuesForPage(page, bodyCounts);
    const status = pageIssues.length ? "SAFE_FIX_NOW" : "APPROVED_LIVE";
    const meta = page.cityMetadata || {};
    const legacy = sources.get(page.id) || {};
    profileCounts[profile] = (profileCounts[profile] || 0) + 1;
    statusCounts[status] = (statusCounts[status] || 0) + 1;
    for (const issue of pageIssues) issueCounts[issue] = (issueCounts[issue] || 0) + 1;
    const row = {
      pageID: page.id,
      phraseID: page.phraseID,
      vietnamese: page.title,
      english: page.englishTitle,
      tierRole: page.tierRole || "",
      profile,
      pageKind: meta.pageKind || "",
      placeKind: meta.placeKind || "",
      contentRole: meta.contentRole || "",
      sourceLane: legacy.sourceLane || page.tierRole || "",
      sourcePath: legacy.sourcePath || "",
      sectionOrder: (page.sections || []).map((section) => section.title).join(" > "),
      practiceKind: page.practiceMetadata?.practiceKind || "",
      practiceCTALabel: page.practiceMetadata?.practiceCTALabel || "",
      scenarioEligible: page.practiceMetadata?.scenarioEligible === false ? "false" : "true",
      practiceSurfacePolicy: page.practiceMetadata?.practiceSurfacePolicy || "",
      scenarioSeedID: page.practiceMetadata?.scenarioSeedID || "",
      scenarioStepCount: page.practiceMetadata?.scenarioStepGroups?.length || 0,
      topRelatedRows: (page.sections || [])
        .flatMap((section) => section.phrases || [])
        .filter((phrase) => phrase.detailPageID)
        .slice(0, 8)
        .map((phrase) => `${phrase.id}:${phrase.english}`)
        .join(" | "),
      issueFlags: pageIssues.join("|"),
      reviewStatus: status === "APPROVED_LIVE" ? "machine-clean" : "needs-editorial-repair",
      reviewerStatus: "pending-focused-review",
      importSourceStatus: phraseByID.get(page.phraseID)?.source || "",
      finalStatus: status,
      continuationNotes: pageIssues.length ? `Fix: ${pageIssues.join(", ")}` : "",
    };
    tracker.push(row);
    for (const issue of pageIssues) {
      issues.push({ issue, pageID: page.id, phraseID: page.phraseID, vietnamese: page.title, english: page.englishTitle, profile, tierRole: page.tierRole || "", sourcePath: row.sourcePath });
    }
  }

  fs.mkdirSync(outDir, { recursive: true });
  fs.writeFileSync(path.join(outDir, "tracker.jsonl"), tracker.map((row) => JSON.stringify(row)).join("\n") + "\n");
  const headers = ["issue", "pageID", "phraseID", "vietnamese", "english", "profile", "tierRole", "sourcePath"];
  fs.writeFileSync(path.join(outDir, "issues.csv"), [headers.join(","), ...issues.map((row) => headers.map((header) => csv(row[header])).join(","))].join("\n") + "\n");
  const summary = {
    generatedAt: new Date().toISOString(),
    pageCount: pages.length,
    profileCounts,
    statusCounts,
    issueCounts,
    issueCount: issues.length,
    trackerPath: "docs/content-audits/viet-canonical-editorial-finish-all-001/tracker.jsonl",
    issuesPath: "docs/content-audits/viet-canonical-editorial-finish-all-001/issues.csv",
    representativeExcerptsPath: "docs/content-audits/viet-canonical-editorial-finish-all-001/representative-page-excerpts.md",
    practiceMetadataSamplesPath: "docs/content-audits/viet-canonical-editorial-finish-all-001/practice-metadata-samples.json",
    missingAudioPriorityPath: "docs/content-audits/viet-canonical-editorial-finish-all-001/missing-audio-priority.csv",
    heroImageFollowupsPath: "docs/content-audits/viet-canonical-editorial-finish-all-001/hero-image-followups.csv",
    fallbackTemplateReportPath: "docs/content-audits/viet-canonical-editorial-finish-all-001/fallback-template-report.json",
  };
  writeAcceptanceArtifacts(pages);
  fs.writeFileSync(path.join(outDir, "summary.json"), JSON.stringify(summary, null, 2) + "\n");
  fs.writeFileSync(path.join(outDir, "README.md"), `# Viet Canonical Editorial Finish-All Tracker

Generated by \`native-ios/scripts/audit-viet-editorial-finish-all.js\`.

This tracker is stricter than the legacy content audit. It flags internal content-model wording, forced phrase-page structures, patronizing instructions on name-based pages, placeholder breakdown labels, long mobile copy, and repeated boilerplate.

- Pages: ${pages.length}
- Issues: ${issues.length}
- Approved live candidates: ${statusCounts.APPROVED_LIVE || 0}
- Needs safe editorial repair: ${statusCounts.SAFE_FIX_NOW || 0}
`);
  console.log(`Wrote ${tracker.length} tracker rows and ${issues.length} issues to ${outDir}`);
  console.log(JSON.stringify(summary, null, 2));
}

main();
