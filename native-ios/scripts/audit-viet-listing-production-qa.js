#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const resourcesRoot = path.join(repoRoot, "native-ios", "Resources");
const outputRoot = path.join(repoRoot, "docs", "content-audits", "viet-listing-production-qa-001");
const authoredPagesPath = path.join(resourcesRoot, "viet-authored-listing-pages.json");
const audioAuditPath = path.join(resourcesRoot, "viet-authored-audio-audit.json");

const fixedRepresentatives = [
  { label: "Tôi không hiểu", pageID: "viet-family-repair-understand", expectedIntent: "simple_phrase" },
  { label: "Bàn này còn trống", pageID: "viet-family-vpe-likely-replies-ban-nay-con-trong", expectedIntent: "traveler_may_hear" },
  { label: "Bà Nà Hills", pageID: "viet-family-city-danang-place-ba-na-hills", expectedIntent: "macro_attraction_journey" },
  { label: "Cầu Rồng", pageID: "viet-family-city-danang-place-dragon-bridge", expectedIntent: "landmark_micro_place" },
  { label: "Đường Nguyễn Văn Linh", pageID: "viet-family-city-danang-place-nguyen-van-linh-street", expectedIntent: "street" },
  { label: "Anăn Sài Gòn", pageID: "viet-family-city-hcmc-place-anan-saigon", expectedIntent: "restaurant" },
  { label: "Bún chả Hương Liên", pageID: "viet-family-city-hanoi-place-bun-cha-huong-lien", expectedIntent: "restaurant" },
  { label: "Phở Bát Đàn", pageID: "viet-family-city-hanoi-place-pho-bat-dan", expectedIntent: "restaurant" },
  { label: "Bún bò Huế", pageID: "viet-family-city-hue-place-bun-bo-city", expectedIntent: "dish" },
  { label: "Cao lầu", pageID: "viet-family-city-hoian-place-cao-lau-city", expectedIntent: "dish" },
  { label: "Bưu điện Thành phố ở đâu?", pageID: "viet-family-city-hcmc-where-post-office", expectedIntent: "derived_place_phrase" },
  { label: "Hotel check-in", pageID: "viet-family-hotel-check-in", expectedIntent: "practical_flow" },
  { label: "Airport arrival", pageID: "viet-family-airport-immigration", expectedIntent: "practical_flow" },
  { label: "Taxi/Grab pickup", pageID: "viet-family-airport-pickup", expectedIntent: "practical_flow" },
  { label: "Shopping", pageID: null, expectedIntent: "topic_hub", externalSurface: "native browse collection" },
  { label: "Da Nang", pageID: null, expectedIntent: "city_hub", externalSurface: "native city hub" },
  { label: "All Vietnam", pageID: null, expectedIntent: "country_hub", externalSurface: "native browse root" },
];

const bannedCopyPatterns = [
  { pattern: /\bplace name\b/i, reason: "internal page-type language" },
  { pattern: /\bcity anchor\b/i, reason: "internal content-model language" },
  { pattern: /\banchor\b/i, reason: "internal content-model language" },
  { pattern: /\buseful moments\b/i, reason: "internal content-model language" },
  { pattern: /\broute phrase\b/i, reason: "internal content-model language" },
  { pattern: /\bwhere-question\b/i, reason: "internal content-model language" },
  { pattern: /\brelationship rows\b/i, reason: "internal content-model language" },
  { pattern: /\bcontent role\b/i, reason: "internal content-model language" },
  { pattern: /\bsource rationale\b/i, reason: "source/editor language" },
  { pattern: /\bthis page helps\b/i, reason: "product/editor voice" },
  { pattern: /\buse it with\b/i, reason: "awkward template heading" },
  { pattern: /\bnearby needs\b/i, reason: "vague bucket label" },
  { pattern: /\bPractice nearby\b/i, reason: "generic recommender bucket label" },
  { pattern: /\bdurable next steps\b/i, reason: "internal editorial language" },
  { pattern: /\bconnect to\b/i, reason: "database navigation language" },
  { pattern: /\bstarter phrases in a quick practice loop\b/i, reason: "generic practice-card copy" },
  { pattern: /\bUseful phrase pages for this travel moment\b/i, reason: "generic catalog shelf subtitle" },
];

const issueSeverityRank = {
  BLOCKER: 3,
  MAJOR: 2,
  MINOR: 1,
  INFO: 0,
};

function main() {
  const args = new Set(process.argv.slice(2));
  const checkMode = args.has("--check");
  const pages = loadAuthoredPages();
  const pageByID = new Map(pages.map((page) => [page.id, page]));
  const issues = [];

  const fixedProbeResults = fixedRepresentatives.map((probe) => {
    if (!probe.pageID) {
      issues.push({
        severity: "INFO",
        code: "external_surface_probe",
        pageID: "",
        title: probe.label,
        detail: `${probe.label} is a ${probe.externalSurface}; inspect it in simulator screenshots, not authored listing JSON.`,
      });
      return {
        ...probe,
        status: "EXTERNAL_SURFACE",
      };
    }

    const page = pageByID.get(probe.pageID);
    if (!page) {
      issues.push({
        severity: "BLOCKER",
        code: "fixed_probe_missing",
        pageID: probe.pageID,
        title: probe.label,
        detail: "Fixed representative page is missing from authored listing pages.",
      });
      return {
        ...probe,
        status: "MISSING",
      };
    }

    const verdict = inspectPage(page, probe.expectedIntent, issues, "fixed");
    return {
      label: probe.label,
      pageID: page.id,
      title: page.title,
      englishTitle: page.englishTitle,
      expectedIntent: probe.expectedIntent,
      detectedIntent: classifyIntent(page),
      practice: page.practiceMetadata
        ? {
            kind: page.practiceMetadata.practiceKind,
            cta: page.practiceMetadata.practiceCTALabel,
            surfacePolicy: page.practiceMetadata.practiceSurfacePolicy,
            scenarioEligible: page.practiceMetadata.scenarioEligible,
          }
        : null,
      renderedSections: visibleSections(page).map((section) => section.title),
      status: verdict,
    };
  });

  const randomSample = stratifiedRandomSample(pages, 3, 50, 20260506);
  for (const page of randomSample.pages) {
    inspectPage(page, classifyIntent(page), issues, "random");
  }

  const dataDuplicateHeroCount = countDataHeroDuplicates(pages);
  const missingAudioPriority = buildMissingAudioPriority(pages);
  const heroImageReport = buildHeroImageReport(pages);
  const practiceMetadataSamples = buildPracticeMetadataSamples(pageByID);
  const fallbackReport = buildFallbackTemplateReport(pages);
  const screenshotChecklist = buildScreenshotChecklist();

  writeOutputs({
    pages,
    issues,
    fixedProbeResults,
    randomSample,
    dataDuplicateHeroCount,
    missingAudioPriority,
    heroImageReport,
    practiceMetadataSamples,
    fallbackReport,
    screenshotChecklist,
  });

  const blockerCount = issues.filter((issue) => issue.severity === "BLOCKER").length;
  const majorCount = issues.filter((issue) => issue.severity === "MAJOR").length;
  const summaryLine = [
    `Production QA audit wrote ${path.relative(repoRoot, outputRoot)}`,
    `${pages.length} pages`,
    `${blockerCount} blockers`,
    `${majorCount} majors`,
    `${dataDuplicateHeroCount.renderedHidden} duplicate hero sections hidden at render-time`,
    `${missingAudioPriority.length} missing-audio priority rows`,
  ].join("; ");

  console.log(summaryLine);

  if (checkMode && (blockerCount > 0 || majorCount > 0)) {
    process.exitCode = 1;
  }
}

function loadAuthoredPages() {
  const payload = JSON.parse(fs.readFileSync(authoredPagesPath, "utf8"));
  return payload.pages ?? [];
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[đĐ]/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function wordCount(value) {
  const normalized = normalize(value);
  return normalized ? normalized.split(" ").length : 0;
}

function sectionText(section) {
  return [
    section.id,
    section.title,
    section.body,
    ...(section.phrases ?? []).flatMap((phrase) => [phrase.vietnamese, phrase.english]),
    ...(section.breakdown ?? []).flatMap((token) => [token.vietnamese, token.english]),
  ]
    .filter(Boolean)
    .join("\n");
}

function visibleSections(page) {
  return (page.sections ?? []).filter((section) => {
    if (isHeroRepeatSection(section, page)) return false;
    return Boolean(section.body) || (section.phrases ?? []).length > 0 || (section.breakdown ?? []).length > 0;
  });
}

const exactBreakdownExpectations = new Map([
  ["tỏi", { expected: /garlic/i, forbidden: /\bI\s*\/\s*me\b|\bme\b/i }],
  ["tôi", { expected: /\bI\s*\/\s*me\b|\bI\b/i, forbidden: /garlic/i }],
  ["bàn", { expected: /table/i, forbidden: /\byou\b/i }],
  ["bạn", { expected: /\byou\b|friend/i, forbidden: /table/i }],
  ["bơ", { expected: /butter/i, forbidden: /remove|leave out/i }],
  ["bỏ", { expected: /remove|leave out/i, forbidden: /butter/i }],
  ["có", { expected: /have|is there|yes/i, forbidden: /aunt|female address/i }],
  ["cô", { expected: /female address|aunt|woman/i, forbidden: /\bhave\b|is there/i }],
  ["chưa", { expected: /not yet/i, forbidden: /pagoda/i }],
  ["chùa", { expected: /pagoda/i, forbidden: /not yet/i }],
]);

function exactVietnamese(value) {
  return String(value ?? "").normalize("NFC").trim().toLowerCase();
}

function phraseRows(sections) {
  return sections.flatMap((section) => (section.phrases ?? []).map((phrase) => ({
    ...phrase,
    sectionID: section.id,
    sectionTitle: section.title,
  })));
}

function isIngredientQuestionPage(page) {
  const id = String(page.phraseID || page.familyID || page.id || "");
  return id.includes("vpe-food-has-") || /^does it have\b/i.test(String(page.englishTitle || page.summary || ""));
}

function isTaxiRideHelpPage(page) {
  const text = normalize([
    page.phraseID,
    page.familyID,
    page.id,
    page.title,
    page.englishTitle,
  ].filter(Boolean).join(" "));
  return /taxi|ride share|pickup point|drop me off|call a taxi|goi taxi|goi xe cong nghe/.test(text);
}

function isDoctorComingPage(page) {
  return normalize(page.title) === "bac si dang den";
}

function isHeroRepeatSection(section, page) {
  return isSelfOnlyHeroPhraseRepeat(section, page) || isHeroMeaningRepeat(section, page);
}

function isSelfOnlyHeroPhraseRepeat(section, page) {
  if (!["Quick say", "Say this"].includes(section.title)) return false;
  if ((section.phrases ?? []).length !== 1) return false;
  const phrase = section.phrases[0];
  return normalize(phrase.vietnamese) === normalize(page.title)
    && normalize(phrase.english) === normalize(page.englishTitle);
}

function isHeroMeaningRepeat(section, page) {
  if (!["Meaning", "At a glance"].includes(section.title)) return false;
  if ((section.phrases ?? []).length > 0 || (section.breakdown ?? []).length > 0) return false;

  const body = normalize(section.body);
  const title = normalize(page.title);
  const english = normalize(page.englishTitle);
  const summary = normalize(page.summary);

  if (!body || !english) return false;
  if (body === english) return true;
  if (summary && summary === english && body === summary) return true;
  if (title && (body === `${title} means ${english}` || body === `${title} ${english}`)) return true;
  if (title && body.startsWith(`${title} means `) && body.includes(english)) return true;
  return body.startsWith(english) && wordCount(body) <= Math.max(4, wordCount(english) + 2);
}

function classifyIntent(page) {
  const categories = new Set(page.categoryIDs ?? []);
  const sectionTitles = new Set((page.sections ?? []).map((section) => section.title));

  if (categories.has("practice-likely-replies") || page.id.includes("vpe-likely-replies-")) return "traveler_may_hear";
  if (categories.has("derived-place-phrases")) return "derived_place_phrase";
  if (categories.has("place-kind-street")) return "street";
  if (categories.has("city-page-kind-restaurant") || categories.has("restaurants")) return "restaurant";
  if (categories.has("city-page-kind-dish") || categories.has("local-dishes")) return "dish";
  if (categories.has("journey-page")) return "macro_attraction_journey";
  if (categories.has("city-page-kind-place") || categories.has("place-kind-landmark")) return "landmark_micro_place";
  if (categories.has("hotel-accommodation") || categories.has("airport-border-arrival") || categories.has("transport")) return "practical_flow";
  if (sectionTitles.has("You may hear")) return "traveler_may_hear";
  return "simple_phrase";
}

function inspectPage(page, expectedIntent, issues, source) {
  const detectedIntent = classifyIntent(page);
  const rendered = visibleSections(page);
  const allRenderedText = rendered.map(sectionText).join("\n");
  let worst = "PASS";

  if (expectedIntent && detectedIntent !== expectedIntent) {
    addIssue(issues, {
      severity: "MAJOR",
      code: "intent_mismatch",
      page,
      source,
      detail: `Expected ${expectedIntent}, detected ${detectedIntent}.`,
    });
    worst = maxVerdict(worst, "FAIL");
  }

  for (const section of rendered) {
    for (const banned of bannedCopyPatterns) {
      if (banned.pattern.test(sectionText(section))) {
        addIssue(issues, {
          severity: "MAJOR",
          code: "banned_user_facing_copy",
          page,
          source,
          sectionID: section.id,
          sectionTitle: section.title,
          detail: `${banned.reason}: ${banned.pattern}`,
        });
        worst = maxVerdict(worst, "FAIL");
      }
    }

    const bodyWords = wordCount(section.body);
    if (bodyWords > 40) {
      addIssue(issues, {
        severity: "MAJOR",
        code: "section_body_too_long",
        page,
        source,
        sectionID: section.id,
        sectionTitle: section.title,
        detail: `${bodyWords} words; body copy should usually be under 40 words.`,
      });
      worst = maxVerdict(worst, "FAIL");
    } else if (bodyWords > 25) {
      addIssue(issues, {
        severity: "MINOR",
        code: "section_body_long",
        page,
        source,
        sectionID: section.id,
        sectionTitle: section.title,
        detail: `${bodyWords} words; consider tightening if the rendered page feels wordy.`,
      });
    }

    if (/\/.+\//.test(section.body ?? "") && (section.phrases ?? []).length === 0) {
      addIssue(issues, {
        severity: "MAJOR",
        code: "slash_separated_phrase_body",
        page,
        source,
        sectionID: section.id,
        sectionTitle: section.title,
        detail: "Slash-separated phrase bodies should be rendered as rows.",
      });
      worst = maxVerdict(worst, "FAIL");
    }

    for (const token of section.breakdown ?? []) {
      const expectation = exactBreakdownExpectations.get(exactVietnamese(token.vietnamese));
      if (!expectation) continue;
      const gloss = String(token.english ?? "");
      if (!expectation.expected.test(gloss) || expectation.forbidden.test(gloss)) {
        addIssue(issues, {
          severity: "BLOCKER",
          code: "diacritic_sensitive_breakdown_gloss",
          page,
          source,
          sectionID: section.id,
          sectionTitle: section.title,
          detail: `${token.vietnamese} has unsafe gloss "${gloss}".`,
        });
        worst = maxVerdict(worst, "FAIL");
      }
    }
  }

  if (isIngredientQuestionPage(page)) {
    const unrelatedRows = phraseRows(rendered).filter((row) => {
      const text = normalize(`${row.vietnamese ?? ""} ${row.english ?? ""}`);
      return !/ingredient|allerg|seafood|chili|pork|beef|chicken|fish|butter|msg|garlic|peanut|spicy|vegetarian|does it have|co |thit|hai san|ot|bo |bot ngot|ca |dau phong/.test(text);
    });
    if (unrelatedRows.length > 0) {
      addIssue(issues, {
        severity: "BLOCKER",
        code: "ingredient_page_unrelated_rows",
        page,
        source,
        detail: `Ingredient page has unrelated rows: ${unrelatedRows.map((row) => row.english).join("; ")}`,
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (isTaxiRideHelpPage(page)) {
    const unrelatedRows = phraseRows(rendered).filter((row) => {
      const text = normalize(`${row.vietnamese ?? ""} ${row.english ?? ""}`);
      if (normalize(row.vietnamese) === normalize(page.title)) return false;
      return !/taxi|ride|address|pickup|driver|drop|wait|route|way|map|destination|diem don|dia chi|xuong|cho toi den|goi xe|goi taxi|cho mot chut|chi duong|write the address/.test(text);
    });
    if (unrelatedRows.length > 0) {
      addIssue(issues, {
        severity: "BLOCKER",
        code: "taxi_help_unrelated_rows",
        page,
        source,
        detail: `Taxi/ride page has unrelated rows: ${unrelatedRows.map((row) => row.english).join("; ")}`,
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (isDoctorComingPage(page)) {
    const unrelatedRows = phraseRows(rendered).filter((row) => {
      const text = normalize(`${row.vietnamese ?? ""} ${row.english ?? ""}`);
      if (normalize(row.vietnamese) === normalize(page.title)) return false;
      return !/doctor|pain|stomach|headache|emergency|help|thank|calm|bac si|dau|cap cuu|giup|cam on/.test(text);
    });
    if (unrelatedRows.length > 0) {
      addIssue(issues, {
        severity: "BLOCKER",
        code: "doctor_may_hear_unrelated_rows",
        page,
        source,
        detail: `Doctor may-hear page has unrelated rows: ${unrelatedRows.map((row) => row.english).join("; ")}`,
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (detectedIntent === "simple_phrase") {
    const duplicateHero = rendered.some((section) => isHeroRepeatSection(section, page));
    if (duplicateHero) {
      addIssue(issues, {
        severity: "BLOCKER",
        code: "visible_duplicate_hero_section",
        page,
        source,
        detail: "Simple phrase page still visibly repeats the hero in Meaning or Say this.",
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (detectedIntent === "traveler_may_hear") {
    if (!rendered.some((section) => section.title === "You may hear")) {
      addIssue(issues, {
        severity: "BLOCKER",
        code: "may_hear_missing_recognition_section",
        page,
        source,
        detail: "Likely reply page must teach recognition before next actions.",
      });
      worst = maxVerdict(worst, "FAIL");
    }
    if (/Say this|Quick say/i.test(allRenderedText)) {
      addIssue(issues, {
        severity: "BLOCKER",
        code: "may_hear_rendered_as_command",
        page,
        source,
        detail: "Likely reply page is still rendered like something the traveler should say first.",
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (detectedIntent === "restaurant") {
    assertSectionOrder(page, rendered, issues, source, ["About", "Hear the name", "Getting there", "Table & menu", "Order", "Drinks", "Pay"], "restaurant_section_order");
    for (const section of rendered) {
      if (section.title === "Drinks" && /(allergy|dị ứng|peanut|đậu phộng|pork|thịt heo|beef|thịt bò)/i.test(sectionText(section))) {
        addIssue(issues, {
          severity: "BLOCKER",
          code: "restaurant_drinks_contains_diet_rows",
          page,
          source,
          sectionID: section.id,
          sectionTitle: section.title,
          detail: "Drink sections must not pull diet/allergy rows.",
        });
        worst = maxVerdict(worst, "FAIL");
      }
    }
  }

  if (detectedIntent === "dish") {
    const dishDestinationRows = rendered.flatMap((section) => section.phrases ?? []).filter((phrase) => {
      const english = normalize(phrase.english);
      return english.startsWith("go to ") || english.startsWith("stop at ") || english.startsWith("where is ");
    });
    if (dishDestinationRows.length > 0) {
      addIssue(issues, {
        severity: "BLOCKER",
        code: "dish_as_destination",
        page,
        source,
        detail: `Dish page contains destination rows: ${dishDestinationRows.map((row) => row.english).join("; ")}`,
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (detectedIntent === "macro_attraction_journey") {
    assertSectionOrder(page, rendered, issues, source, ["About", "Visit flow", "Getting there", "Tickets", "Cable car", "Photos", "Getting back", "Good to know", "Food & cash"], "macro_attraction_section_order");
    if (/Nearby needs/i.test(allRenderedText)) {
      addIssue(issues, {
        severity: "MAJOR",
        code: "nearby_needs_label",
        page,
        source,
        detail: "Macro attraction page uses vague Nearby needs bucket.",
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (detectedIntent === "derived_place_phrase") {
    const allowedTitles = new Set(["Break it down", "Related phrases", "Tip"]);
    const unexpected = rendered.filter((section) => !allowedTitles.has(section.title));
    if (unexpected.length > 0) {
      addIssue(issues, {
        severity: "MAJOR",
        code: "derived_phrase_too_heavy",
        page,
        source,
        detail: `Derived phrase page has heavy/unexpected sections: ${unexpected.map((section) => section.title).join(", ")}`,
      });
      worst = maxVerdict(worst, "FAIL");
    }
  }

  if (detectedIntent === "street") {
    assertSectionOrder(page, rendered, issues, source, ["About", "Hear the street", "Tell the driver", "Driver phrases", "Confirm", "Find it nearby", "Wrong place"], "street_section_order");
  }

  if (detectedIntent !== "simple_phrase" && rendered.length > 10) {
    addIssue(issues, {
      severity: "MINOR",
      code: "many_rendered_sections",
      page,
      source,
      detail: `${rendered.length} rendered sections. Confirm it remains scannable on phone.`,
    });
  }

  const practice = page.practiceMetadata;
  if (!practice?.practiceCTALabel) {
    addIssue(issues, {
      severity: "MAJOR",
      code: "missing_practice_cta",
      page,
      source,
      detail: "Listing page is missing page-type-specific practice CTA metadata.",
    });
    worst = maxVerdict(worst, "FAIL");
  } else if (practice.practiceCTALabel === "Add to practice") {
    addIssue(issues, {
      severity: "MAJOR",
      code: "generic_practice_cta",
      page,
      source,
      detail: "Primary practice CTA should be page-type specific, not Add to practice.",
    });
    worst = maxVerdict(worst, "FAIL");
  }

  return worst === "PASS" ? "PASS" : "FAIL";
}

function assertSectionOrder(page, rendered, issues, source, expectedTitles, code) {
  const titles = rendered.map((section) => section.title);
  let lastIndex = -1;
  const missing = [];

  for (const expectedTitle of expectedTitles) {
    const index = titles.indexOf(expectedTitle);
    if (index === -1) {
      missing.push(expectedTitle);
      continue;
    }
    if (index < lastIndex) {
      addIssue(issues, {
        severity: "MAJOR",
        code,
        page,
        source,
        detail: `Section "${expectedTitle}" is out of order. Rendered order: ${titles.join(" > ")}`,
      });
      return;
    }
    lastIndex = index;
  }

  if (missing.length > 0) {
    addIssue(issues, {
      severity: "MINOR",
      code: `${code}_missing_optional`,
      page,
      source,
      detail: `Expected sections not present: ${missing.join(", ")}. Rendered order: ${titles.join(" > ")}`,
    });
  }
}

function addIssue(issues, issue) {
  issues.push({
    severity: issue.severity,
    code: issue.code,
    source: issue.source ?? "",
    pageID: issue.page?.id ?? issue.pageID ?? "",
    title: issue.page?.title ?? issue.title ?? "",
    englishTitle: issue.page?.englishTitle ?? "",
    intent: issue.page ? classifyIntent(issue.page) : "",
    sectionID: issue.sectionID ?? "",
    sectionTitle: issue.sectionTitle ?? "",
    detail: issue.detail,
  });
}

function maxVerdict(current, next) {
  if (current === "FAIL" || next === "FAIL") return "FAIL";
  return "PASS";
}

function countDataHeroDuplicates(pages) {
  let meaning = 0;
  let sayThis = 0;

  for (const page of pages) {
    for (const section of page.sections ?? []) {
      if (isHeroMeaningRepeat(section, page)) meaning += 1;
      if (isSelfOnlyHeroPhraseRepeat(section, page)) sayThis += 1;
    }
  }

  return {
    meaning,
    sayThis,
    renderedHidden: meaning + sayThis,
  };
}

function stratifiedRandomSample(pages, perIntent, total, seed) {
  const groups = new Map();
  for (const page of pages) {
    const intent = classifyIntent(page);
    if (!groups.has(intent)) groups.set(intent, []);
    groups.get(intent).push(page);
  }

  const random = mulberry32(seed);
  const selected = [];
  const byIntent = {};

  for (const [intent, group] of [...groups.entries()].sort(([a], [b]) => a.localeCompare(b))) {
    const shuffled = shuffle(group, random);
    const slice = shuffled.slice(0, Math.min(perIntent, shuffled.length));
    byIntent[intent] = slice.map(pageSummary);
    selected.push(...slice);
  }

  const remaining = shuffle(pages.filter((page) => !selected.includes(page)), random);
  for (const page of remaining) {
    if (selected.length >= total) break;
    selected.push(page);
  }

  return {
    seed,
    perIntent,
    targetTotal: total,
    actualTotal: selected.length,
    byIntent,
    pages: selected,
    pageSummaries: selected.map(pageSummary),
  };
}

function shuffle(items, random) {
  const copy = [...items];
  for (let index = copy.length - 1; index > 0; index -= 1) {
    const swapIndex = Math.floor(random() * (index + 1));
    [copy[index], copy[swapIndex]] = [copy[swapIndex], copy[index]];
  }
  return copy;
}

function mulberry32(seed) {
  return function next() {
    let value = seed += 0x6d2b79f5;
    value = Math.imul(value ^ (value >>> 15), value | 1);
    value ^= value + Math.imul(value ^ (value >>> 7), value | 61);
    return ((value ^ (value >>> 14)) >>> 0) / 4294967296;
  };
}

function pageSummary(page) {
  return {
    pageID: page.id,
    title: page.title,
    englishTitle: page.englishTitle,
    intent: classifyIntent(page),
    categoryIDs: page.categoryIDs ?? [],
    renderedSections: visibleSections(page).map((section) => section.title),
  };
}

function buildMissingAudioPriority(pages) {
  if (!fs.existsSync(audioAuditPath)) return [];
  const audioAudit = JSON.parse(fs.readFileSync(audioAuditPath, "utf8"));
  const pageByID = new Map(pages.map((page) => [page.id, page]));
  const priorityRows = [];

  for (const missing of audioAudit.missing ?? []) {
    const page = pageByID.get(missing.pageID);
    if (!page) continue;
    const intent = classifyIntent(page);
    const categoryIDs = new Set(page.categoryIDs ?? []);
    const priority = audioPriorityForMissing(intent, categoryIDs, missing.kind);
    if (priority === "low") continue;
    priorityRows.push({
      priority,
      pageID: page.id,
      title: page.title,
      englishTitle: page.englishTitle,
      intent,
      sectionID: missing.sectionID,
      kind: missing.kind,
      audioKey: missing.audioKey,
      text: missing.text,
    });
  }

  return priorityRows
    .sort((lhs, rhs) => priorityRank(lhs.priority) - priorityRank(rhs.priority) || lhs.pageID.localeCompare(rhs.pageID))
    .slice(0, 500);
}

function audioPriorityForMissing(intent, categoryIDs, kind) {
  if (kind === "hero" && ["landmark_micro_place", "macro_attraction_journey", "street", "restaurant", "dish"].includes(intent)) return "p0";
  if (["macro_attraction_journey", "landmark_micro_place", "street"].includes(intent)) return "p1";
  if (["restaurant", "dish", "practical_flow"].includes(intent)) return "p2";
  if (categoryIDs.has("beginner") || categoryIDs.has("premium")) return "p3";
  return "low";
}

function priorityRank(priority) {
  return { p0: 0, p1: 1, p2: 2, p3: 3, low: 4 }[priority] ?? 9;
}

function buildHeroImageReport(pages) {
  return pages
    .filter((page) => ["landmark_micro_place", "macro_attraction_journey", "restaurant", "dish", "street"].includes(classifyIntent(page)))
    .map((page) => ({
      pageID: page.id,
      title: page.title,
      englishTitle: page.englishTitle,
      intent: classifyIntent(page),
      heroImageName: page.heroImageName ?? "",
      status: heroImageStatus(page.heroImageName),
    }))
    .filter((row) => row.status !== "page_specific_or_explicit")
    .slice(0, 250);
}

function heroImageStatus(heroImageName) {
  if (!heroImageName || heroImageName === "HeroVietnamMasthead") {
    return "generic_image_follow_up";
  }
  if (heroImageName === "HeroNeutralMasthead") {
    return "neutral_fallback_follow_up";
  }
  return "page_specific_or_explicit";
}

function buildPracticeMetadataSamples(pageByID) {
  const sampleIDs = [
    "viet-family-city-danang-place-dragon-bridge",
    "viet-family-city-danang-place-ba-na-hills",
    "viet-family-city-danang-place-nguyen-van-linh-street",
    "viet-family-city-hcmc-place-anan-saigon",
    "viet-family-hotel-check-in",
    "viet-family-repair-understand",
  ];

  return Object.fromEntries(sampleIDs.map((id) => {
    const page = pageByID.get(id);
    return [id, page?.practiceMetadata ?? null];
  }));
}

function buildFallbackTemplateReport(pages) {
  const byIntent = {};
  for (const page of pages) {
    const intent = classifyIntent(page);
    byIntent[intent] = (byIntent[intent] ?? 0) + 1;
  }

  return {
    byIntent,
    pagesWithGenericBrowseTitleRisk: pages
      .filter((page) => !["derived_place_phrase", "restaurant", "dish", "street", "landmark_micro_place", "macro_attraction_journey"].includes(classifyIntent(page)))
      .slice(0, 100)
      .map(pageSummary),
  };
}

function buildScreenshotChecklist() {
  return fixedRepresentatives.map((probe) => ({
    label: probe.label,
    pageID: probe.pageID,
    launchArguments: probe.pageID ? ["--detail-page", probe.pageID] : [],
    requiredProof: probe.pageID ? ["top", "middle", "bottom"] : ["native hub top", "native hub scrolled"],
    notes: probe.pageID
      ? "Use launch args in the iOS simulator and capture rendered proof."
      : `Open ${probe.externalSurface} and capture proof manually or with a targeted UI test.`,
  }));
}

function writeOutputs(payload) {
  fs.mkdirSync(outputRoot, { recursive: true });

  const summary = {
    generatedAt: new Date().toISOString(),
    pageCount: payload.pages.length,
    issueCounts: countIssues(payload.issues),
    fixedProbeCount: payload.fixedProbeResults.length,
    randomSeed: payload.randomSample.seed,
    randomSampleCount: payload.randomSample.actualTotal,
    dataDuplicateHeroCount: payload.dataDuplicateHeroCount,
    missingAudioPriorityCount: payload.missingAudioPriority.length,
    heroImageFollowUpCount: payload.heroImageReport.length,
    verdict: countIssues(payload.issues).BLOCKER || countIssues(payload.issues).MAJOR ? "NOT_PRODUCTION_READY_YET" : "NO_BLOCKER_OR_MAJOR_ISSUES_IN_STATIC_RENDER_MODEL",
  };

  writeJSON("summary.json", summary);
  writeJSON("fixed-probes.json", payload.fixedProbeResults);
  writeJSON("random-sample.json", {
    ...payload.randomSample,
    pages: payload.randomSample.pageSummaries,
  });
  writeJSON("practice-metadata-samples.json", payload.practiceMetadataSamples);
  writeJSON("fallback-template-report.json", payload.fallbackReport);
  writeJSON("screenshot-checklist.json", payload.screenshotChecklist);
  writeCSV("issues.csv", payload.issues, ["severity", "code", "source", "pageID", "title", "englishTitle", "intent", "sectionID", "sectionTitle", "detail"]);
  writeCSV("missing-audio-priority.csv", payload.missingAudioPriority, ["priority", "pageID", "title", "englishTitle", "intent", "sectionID", "kind", "audioKey", "text"]);
  writeCSV("hero-image-report.csv", payload.heroImageReport, ["pageID", "title", "englishTitle", "intent", "heroImageName", "status"]);
  writeMarkdown("representative-rendered-excerpts.md", representativeMarkdown(payload.fixedProbeResults, payload.pages));
}

function countIssues(issues) {
  const counts = { BLOCKER: 0, MAJOR: 0, MINOR: 0, INFO: 0 };
  for (const issue of issues) counts[issue.severity] = (counts[issue.severity] ?? 0) + 1;
  return counts;
}

function representativeMarkdown(fixedProbeResults, pages) {
  const pageByID = new Map(pages.map((page) => [page.id, page]));
  const lines = [
    "# Viet Listing Production QA Representative Render Model",
    "",
    "This is a static approximation of rendered listing content after renderer-level duplicate suppression. Screenshots remain required for final product acceptance.",
    "",
  ];

  for (const probe of fixedProbeResults) {
    lines.push(`## ${probe.label}`);
    if (!probe.pageID) {
      lines.push("");
      lines.push(`External surface: ${probe.externalSurface ?? "not in authored listing JSON"}`);
      lines.push("");
      continue;
    }
    const page = pageByID.get(probe.pageID);
    if (!page) {
      lines.push("");
      lines.push("Missing from authored listing JSON.");
      lines.push("");
      continue;
    }
    lines.push("");
    lines.push(`- Page ID: \`${page.id}\``);
    lines.push(`- Intent: \`${classifyIntent(page)}\``);
    lines.push(`- Hero: ${page.title} / ${page.englishTitle}`);
    lines.push(`- Practice CTA: ${page.practiceMetadata?.practiceCTALabel ?? "missing"}`);
    lines.push("");
    for (const section of visibleSections(page)) {
      lines.push(`### ${section.title}`);
      if (section.body) lines.push(section.body);
      for (const phrase of (section.phrases ?? []).slice(0, 6)) {
        lines.push(`- ${phrase.vietnamese} — ${phrase.english}`);
      }
      for (const token of (section.breakdown ?? []).slice(0, 6)) {
        lines.push(`- ${token.vietnamese} = ${token.english}`);
      }
      lines.push("");
    }
  }

  return `${lines.join("\n").trim()}\n`;
}

function writeJSON(filename, value) {
  fs.writeFileSync(path.join(outputRoot, filename), `${JSON.stringify(value, null, 2)}\n`);
}

function writeCSV(filename, rows, columns) {
  const csv = [
    columns.join(","),
    ...rows.map((row) => columns.map((column) => csvCell(row[column])).join(",")),
  ].join("\n");
  fs.writeFileSync(path.join(outputRoot, filename), `${csv}\n`);
}

function csvCell(value) {
  const text = String(value ?? "");
  if (/[",\n]/.test(text)) return `"${text.replace(/"/g, '""')}"`;
  return text;
}

function writeMarkdown(filename, value) {
  fs.writeFileSync(path.join(outputRoot, filename), value);
}

main();
