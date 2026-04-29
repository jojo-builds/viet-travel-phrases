#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const GENERATOR_VERSION = "practice-core-sample-v1";
const GENERATED_AT = "2026-04-29T00:00:00+07:00";

const QUESTION_TYPES = [
  {
    id: "listening_choice",
    label: "Listen and choose",
    answerSurface: "english_meaning",
    skillTags: ["listening", "meaning"],
  },
  {
    id: "english_to_vietnamese",
    label: "English to Vietnamese",
    answerSurface: "vietnamese_phrase",
    skillTags: ["meaning", "active-recall"],
  },
  {
    id: "vietnamese_to_english",
    label: "Vietnamese to English",
    answerSurface: "english_meaning",
    skillTags: ["reading", "meaning"],
  },
  {
    id: "situation_pick",
    label: "Situation pick",
    answerSurface: "vietnamese_phrase",
    skillTags: ["situation", "traveler-context"],
  },
  {
    id: "pronoun_variant_choice",
    label: "Pronoun coach",
    answerSurface: "vietnamese_phrase",
    skillTags: ["pronoun", "social-role"],
  },
  {
    id: "phrase_chunk_rebuild",
    label: "Phrase chunk rebuild",
    answerSurface: "ordered_chunks",
    skillTags: ["breakdown", "phrase-shape"],
  },
  {
    id: "natural_phrase_choice",
    label: "Natural phrase choice",
    answerSurface: "vietnamese_phrase",
    skillTags: ["naturalness", "variant-choice"],
  },
];

const QUESTION_TYPE_BY_ID = new Map(QUESTION_TYPES.map((type) => [type.id, type]));

const SCENARIO_TITLES = {
  "airport-border-arrival": "Airport and arrival",
  "bathroom-personal-needs": "Bathroom and personal needs",
  "directions-navigation": "Directions and navigation",
  "emergency-safety": "Emergency and safety",
  "food-drink": "Food and drink",
  "health-pharmacy": "Health and pharmacy",
  "hotel-accommodation": "Hotel and accommodation",
  "local-services-everyday-tasks": "Local services",
  "money-numbers-prices": "Money and prices",
  "phone-internet-power": "Phone, internet, and power",
  "polite-basics": "Polite basics",
  "problems-help": "Problems and help",
  shopping: "Shopping",
  "sightseeing-activities": "Sightseeing",
  "social-small-talk": "Social small talk",
  "time-dates-booking": "Time and booking",
  transport: "Transport",
  "understanding-repair": "Understanding repair",
};

const SENSITIVE_SCENARIOS = new Set([
  "emergency-safety",
  "health-pharmacy",
  "money-numbers-prices",
  "problems-help",
]);

const SOURCE_FILES = {
  phraseSourceCSV: "content-draft/viet/phrase-source.csv",
  nativeCatalog: "native-ios/Resources/viet-phrase-catalog.json",
  authoredPages: "native-ios/Resources/viet-authored-listing-pages.json",
  authoredAudioAudit: "native-ios/Resources/viet-authored-audio-audit.json",
};

const OUTPUT_PATHS = [
  "content-draft/viet/practice/practice-deck.sample.json",
  "prototypes/practice-quiz/practice-deck.sample.json",
];

function readJSON(repoRoot, relativePath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relativePath), "utf8"));
}

function stableHash(input) {
  let hash = 0;
  for (const char of input) {
    hash = (hash * 31 + char.charCodeAt(0)) >>> 0;
  }
  return hash;
}

function sortByID(a, b) {
  return a.id.localeCompare(b.id);
}

function uniqueBy(items, keyFn) {
  const seen = new Set();
  const result = [];
  for (const item of items) {
    const key = keyFn(item);
    if (!seen.has(key)) {
      seen.add(key);
      result.push(item);
    }
  }
  return result;
}

function groupBy(items, keyFn) {
  return items.reduce((groups, item) => {
    const key = keyFn(item);
    if (!groups.has(key)) {
      groups.set(key, []);
    }
    groups.get(key).push(item);
    return groups;
  }, new Map());
}

function takeBalancedByScenario(items, count) {
  const groups = groupBy(items, (item) => item.scenarioID);
  const scenarioIDs = Array.from(groups.keys()).sort();
  const result = [];
  let cursor = 0;

  while (result.length < count && result.length < items.length) {
    const scenarioID = scenarioIDs[cursor % scenarioIDs.length];
    const group = groups.get(scenarioID);
    const index = Math.floor(cursor / scenarioIDs.length);
    if (group[index]) {
      result.push(group[index]);
    }
    cursor += 1;
    if (cursor > scenarioIDs.length * (count + 4)) {
      break;
    }
  }

  return result.slice(0, count);
}

function normalizeText(text) {
  return String(text || "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim();
}

function normalizeVietnameseForMatch(text) {
  return normalizeText(text)
    .toLowerCase()
    .replace(/[.,!?…]/g, "")
    .replace(/\s+/g, "");
}

function plainOptionText(phrase, surface) {
  if (surface === "english") {
    return phrase.englishText;
  }
  return phrase.targetText;
}

function makeDistractors(correctPhrase, candidatePhrases, count = 3) {
  const sameScenario = candidatePhrases
    .filter((phrase) => phrase.id !== correctPhrase.id && phrase.scenarioID === correctPhrase.scenarioID)
    .sort(sortByID);
  const otherScenario = candidatePhrases
    .filter((phrase) => phrase.id !== correctPhrase.id && phrase.scenarioID !== correctPhrase.scenarioID)
    .sort(sortByID);

  return uniqueBy([...sameScenario, ...otherScenario], (phrase) => phrase.id).slice(0, count);
}

function makeChoiceOptions(itemID, correctPhrase, distractorPhrases, surface) {
  const rawOptions = [
    { phrase: correctPhrase, correct: true },
    ...distractorPhrases.map((phrase) => ({ phrase, correct: false })),
  ].slice(0, 4);
  const rotation = stableHash(itemID) % rawOptions.length;
  const ordered = [...rawOptions.slice(rotation), ...rawOptions.slice(0, rotation)];

  let correctOptionID = "";
  const options = ordered.map((entry, index) => {
    const optionID = `${itemID}-option-${index + 1}`;
    if (entry.correct) {
      correctOptionID = optionID;
    }
    return {
      id: optionID,
      phraseID: entry.phrase.id,
      vietnamese: entry.phrase.targetText,
      english: entry.phrase.englishText,
      pronunciation: entry.phrase.pronunciation || "",
      audioKey: entry.phrase.audioKey || "",
      displayText: plainOptionText(entry.phrase, surface),
      isCorrect: entry.correct,
    };
  });

  return {
    options,
    correctOptionID,
    distractors: options.filter((option) => !option.isCorrect),
  };
}

function findSection(page, sectionID) {
  return (page.sections || []).find((section) => section.id === sectionID);
}

function findBreakdownSection(page) {
  return (page.sections || []).find((section) => Array.isArray(section.breakdown) && section.breakdown.length >= 2);
}

function usableBreakdownTokensForPhrase(page, phrase) {
  for (const breakdownSection of page.sections || []) {
    if (!Array.isArray(breakdownSection.breakdown) || breakdownSection.breakdown.length < 2) {
      continue;
    }
    const tokens = breakdownSection.breakdown
      .filter((token) => token.vietnamese)
      .filter((token) => !/-full$/.test(token.id));
    if (tokens.length < 2) {
      continue;
    }
    const rebuilt = tokens.map((token) => token.vietnamese).join(" ");
    if (normalizeVietnameseForMatch(rebuilt) === normalizeVietnameseForMatch(phrase.targetText)) {
      return { section: breakdownSection, tokens };
    }
  }

  return { section: null, tokens: [] };
}

function detectPronounCue(phrase) {
  const target = normalizeText(phrase.targetText);
  const patterns = [
    {
      needle: "Anh/chị",
      tag: "anh-chi",
      prompt: "the respectful adult/service-worker cue anh/chị",
      explanation: "anh/chị is the authored respectful adult/service-worker form in this phrase.",
    },
    {
      needle: "Bạn",
      tag: "ban",
      prompt: "the direct you-form bạn",
      explanation: "bạn is the authored direct you-form in this phrase.",
    },
    {
      needle: "bạn",
      tag: "ban",
      prompt: "the direct you-form bạn",
      explanation: "bạn is the authored direct you-form in this phrase.",
    },
    {
      needle: "Tôi",
      tag: "toi",
      prompt: "the clear self-reference tôi",
      explanation: "tôi is the authored traveler self-reference in this phrase.",
    },
    {
      needle: "tôi",
      tag: "toi",
      prompt: "the clear self-reference tôi",
      explanation: "tôi is the authored traveler self-reference in this phrase.",
    },
  ];

  return patterns.find((pattern) => target.includes(pattern.needle)) || null;
}

function sectionIDForPhrase(page, phrase) {
  for (const section of page.sections || []) {
    if (Array.isArray(section.phrases) && section.phrases.some((row) => row.id === phrase.id)) {
      return section.id;
    }
  }

  if (page.phraseID === phrase.id && findSection(page, "standard-way")) {
    return "standard-way";
  }

  if (findSection(page, "at-glance")) {
    return "at-glance";
  }

  return (page.sections && page.sections[0] && page.sections[0].id) || "";
}

function sourceForPhrase(phrase, page, questionType, sectionID = "", extra = {}) {
  return {
    phraseID: phrase.id,
    familyID: phrase.familyID,
    pageID: page.id,
    pageTitle: page.title,
    pageEnglishTitle: page.englishTitle,
    scenarioID: phrase.scenarioID,
    scenarioTitle: SCENARIO_TITLES[phrase.scenarioID] || phrase.scenarioID,
    sourcePath: `${SOURCE_FILES.authoredPages}#${page.id}`,
    sectionID: sectionID || sectionIDForPhrase(page, phrase),
    phraseRowID: phrase.id,
    ...extra,
  };
}

function tagsForPhrase(phrase, page, type, extra = {}) {
  return {
    categoryIDs: page.categoryIDs && page.categoryIDs.length ? page.categoryIDs : [phrase.scenarioID],
    scenarioID: phrase.scenarioID,
    situationTags: [phrase.scenarioID, phrase.familyID],
    pronounCues: [],
    skillTags: QUESTION_TYPE_BY_ID.get(type).skillTags,
    sensitivity: SENSITIVE_SCENARIOS.has(phrase.scenarioID) ? "sensitive" : "standard",
    mascotEligible: !SENSITIVE_SCENARIOS.has(phrase.scenarioID),
    ...extra,
  };
}

function progressDefaults(sourceDeckID = "") {
  return {
    seenCount: 0,
    correctStreak: 0,
    missedCount: 0,
    lastSeenAt: null,
    nextDueAt: null,
    lastResult: null,
    sourceDeckID,
    localOnly: true,
  };
}

function feedbackForPhrase(phrase, page, type, extra = {}) {
  return {
    correct: `${phrase.targetText} means "${phrase.englishText}".`,
    contrast: phrase.context || `Use it for ${SCENARIO_TITLES[phrase.scenarioID] || phrase.scenarioID}.`,
    source: `Taught on ${page.englishTitle || page.title}.`,
    sourceAction: {
      label: "Open source page",
      pageID: page.id,
    },
    ...extra,
  };
}

function baseItem({ id, questionType, phrase, page, prompt, answer, options, distractors, feedback, tags, source, requiresAudio }) {
  return {
    id,
    language: "vi",
    generatorVersion: GENERATOR_VERSION,
    questionType,
    prompt,
    source,
    answer,
    options: options || [],
    correctOptionID: answer.optionID || "",
    distractors: distractors || [],
    feedback,
    tags,
    requiresAudio: Boolean(requiresAudio),
    progress: progressDefaults(),
    audit: {
      correctAnswerAnchoredToSource: true,
      genericTravelTrivia: false,
      offlineOnly: true,
      nativeRuntimeTouched: false,
    },
  };
}

function buildListeningItems(phrases, pagesByFamily, allPhrases) {
  return takeBalancedByScenario(phrases, 10).map((phrase) => {
    const page = pagesByFamily.get(phrase.familyID);
    const id = `viet-practice-listen-${phrase.id}`;
    const distractorPhrases = makeDistractors(phrase, allPhrases, 3);
    const choice = makeChoiceOptions(id, phrase, distractorPhrases, "english");

    return baseItem({
      id,
      questionType: "listening_choice",
      phrase,
      page,
      prompt: {
        kind: "audio",
        text: "Listen and choose the English meaning.",
        audioKey: phrase.audioKey,
      },
      source: sourceForPhrase(phrase, page, "listening_choice"),
      answer: {
        phraseID: phrase.id,
        optionID: choice.correctOptionID,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        audioKey: phrase.audioKey,
      },
      options: choice.options,
      distractors: choice.distractors,
      feedback: feedbackForPhrase(phrase, page, "listening_choice", {
        contrast: `The audio is the phrase for "${phrase.englishText}", not a generic ${SCENARIO_TITLES[phrase.scenarioID]} cue.`,
      }),
      tags: tagsForPhrase(phrase, page, "listening_choice"),
      requiresAudio: true,
    });
  });
}

function buildEnglishToVietnameseItems(phrases, pagesByFamily, allPhrases) {
  return takeBalancedByScenario(phrases.slice(10), 10).map((phrase) => {
    const page = pagesByFamily.get(phrase.familyID);
    const id = `viet-practice-en-vi-${phrase.id}`;
    const choice = makeChoiceOptions(id, phrase, makeDistractors(phrase, allPhrases, 3), "vietnamese");

    return baseItem({
      id,
      questionType: "english_to_vietnamese",
      phrase,
      page,
      prompt: {
        kind: "text",
        text: `How do you say "${phrase.englishText}" in Vietnamese?`,
        english: phrase.englishText,
      },
      source: sourceForPhrase(phrase, page, "english_to_vietnamese"),
      answer: {
        phraseID: phrase.id,
        optionID: choice.correctOptionID,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        audioKey: phrase.audioKey,
      },
      options: choice.options,
      distractors: choice.distractors,
      feedback: feedbackForPhrase(phrase, page, "english_to_vietnamese"),
      tags: tagsForPhrase(phrase, page, "english_to_vietnamese"),
    });
  });
}

function buildVietnameseToEnglishItems(phrases, pagesByFamily, allPhrases) {
  return takeBalancedByScenario(phrases.slice(20), 10).map((phrase) => {
    const page = pagesByFamily.get(phrase.familyID);
    const id = `viet-practice-vi-en-${phrase.id}`;
    const choice = makeChoiceOptions(id, phrase, makeDistractors(phrase, allPhrases, 3), "english");

    return baseItem({
      id,
      questionType: "vietnamese_to_english",
      phrase,
      page,
      prompt: {
        kind: "text",
        text: `What does "${phrase.targetText}" mean?`,
        vietnamese: phrase.targetText,
      },
      source: sourceForPhrase(phrase, page, "vietnamese_to_english"),
      answer: {
        phraseID: phrase.id,
        optionID: choice.correctOptionID,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        audioKey: phrase.audioKey,
      },
      options: choice.options,
      distractors: choice.distractors,
      feedback: feedbackForPhrase(phrase, page, "vietnamese_to_english"),
      tags: tagsForPhrase(phrase, page, "vietnamese_to_english"),
    });
  });
}

function buildSituationItems(phrases, pagesByFamily, allPhrases) {
  return takeBalancedByScenario(phrases.slice(30), 10).map((phrase) => {
    const page = pagesByFamily.get(phrase.familyID);
    const id = `viet-practice-situation-${phrase.id}`;
    const choice = makeChoiceOptions(id, phrase, makeDistractors(phrase, allPhrases, 3), "vietnamese");

    return baseItem({
      id,
      questionType: "situation_pick",
      phrase,
      page,
      prompt: {
        kind: "situation",
        text: `You are in this travel moment: ${phrase.context} Which Vietnamese phrase fits?`,
        situation: phrase.context,
      },
      source: sourceForPhrase(phrase, page, "situation_pick"),
      answer: {
        phraseID: phrase.id,
        optionID: choice.correctOptionID,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        audioKey: phrase.audioKey,
      },
      options: choice.options,
      distractors: choice.distractors,
      feedback: feedbackForPhrase(phrase, page, "situation_pick", {
        contrast: `The cue is "${phrase.context}" so the practiced phrase is the one that moves that moment forward.`,
      }),
      tags: tagsForPhrase(phrase, page, "situation_pick"),
    });
  });
}

function buildPronounItems(phrases, pagesByFamily, allPhrases) {
  const candidates = phrases
    .map((phrase) => ({ phrase, cue: detectPronounCue(phrase) }))
    .filter((entry) => entry.cue)
    .sort((a, b) => a.phrase.id.localeCompare(b.phrase.id));

  return takeBalancedByScenario(candidates.map((entry) => entry.phrase), 10).map((phrase) => {
    const cue = detectPronounCue(phrase);
    const page = pagesByFamily.get(phrase.familyID);
    const id = `viet-practice-pronoun-${phrase.id}`;
    const choice = makeChoiceOptions(id, phrase, makeDistractors(phrase, allPhrases, 3), "vietnamese");

    return baseItem({
      id,
      questionType: "pronoun_variant_choice",
      phrase,
      page,
      prompt: {
        kind: "pronoun",
        text: `Which Vietnamese phrase uses ${cue.prompt} for this moment?`,
        situation: phrase.context,
      },
      source: sourceForPhrase(phrase, page, "pronoun_variant_choice"),
      answer: {
        phraseID: phrase.id,
        optionID: choice.correctOptionID,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        audioKey: phrase.audioKey,
        pronounCue: cue.tag,
      },
      options: choice.options,
      distractors: choice.distractors,
      feedback: feedbackForPhrase(phrase, page, "pronoun_variant_choice", {
        contrast: cue.explanation,
      }),
      tags: tagsForPhrase(phrase, page, "pronoun_variant_choice", {
        pronounCues: [cue.tag],
      }),
    });
  });
}

function buildChunkItems(phrases, pagesByFamily) {
  const candidates = phrases
    .map((phrase) => {
      const page = pagesByFamily.get(phrase.familyID);
      const breakdown = usableBreakdownTokensForPhrase(page, phrase);
      return { phrase, page, ...breakdown };
    })
    .filter((entry) => entry.tokens.length >= 2)
    .sort((a, b) => a.phrase.id.localeCompare(b.phrase.id));

  return takeBalancedByScenario(candidates.map((entry) => entry.phrase), 10).map((phrase) => {
    const page = pagesByFamily.get(phrase.familyID);
    const { section, tokens } = usableBreakdownTokensForPhrase(page, phrase);
    const id = `viet-practice-chunks-${phrase.id}`;
    const correctSequence = tokens.map((token) => ({
      id: token.id,
      vietnamese: token.vietnamese,
      audioKey: token.audioKey || "",
    }));
    const extraChunks = [];

    return baseItem({
      id,
      questionType: "phrase_chunk_rebuild",
      phrase,
      page,
      prompt: {
        kind: "rebuild",
        text: `Rebuild the Vietnamese phrase for "${phrase.englishText}".`,
        english: phrase.englishText,
      },
      source: sourceForPhrase(phrase, page, "phrase_chunk_rebuild", section.id, {
        sourceBreakdownTokenIDs: correctSequence.map((token) => token.id),
      }),
      answer: {
        phraseID: phrase.id,
        breakdownTokenIDs: correctSequence.map((token) => token.id),
        correctSequence,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        audioKey: phrase.audioKey,
      },
      options: [],
      distractors: extraChunks,
      feedback: feedbackForPhrase(phrase, page, "phrase_chunk_rebuild", {
        correct: `${phrase.targetText} rebuilds the phrase for "${phrase.englishText}".`,
        contrast: "The order follows the authored breakdown from the source page.",
      }),
      tags: tagsForPhrase(phrase, page, "phrase_chunk_rebuild"),
      requiresAudio: false,
    });
  });
}

function naturalPromptForVariant(phrase) {
  if (phrase.variantRole === "more-polite") {
    return `Which phrase is the softer, more polite way to say "${phrase.englishText}"?`;
  }
  if (phrase.variantRole === "clearer") {
    return `Which phrase makes "${phrase.englishText}" clearer in the moment?`;
  }
  return `Which phrase is also a natural/common way to say "${phrase.englishText}"?`;
}

function buildNaturalChoiceItems(phrases, pagesByFamily, allPhrases) {
  const variants = phrases.filter((phrase) => phrase.variantRole && phrase.variantRole !== "say-first").sort(sortByID);

  return takeBalancedByScenario(variants, 10).map((phrase) => {
    const page = pagesByFamily.get(phrase.familyID);
    const id = `viet-practice-natural-${phrase.id}`;
    const sameFamily = allPhrases
      .filter((candidate) => candidate.id !== phrase.id && candidate.familyID === phrase.familyID)
      .sort(sortByID);
    const distractors = uniqueBy([...sameFamily, ...makeDistractors(phrase, allPhrases, 3)], (item) => item.id).slice(0, 3);
    const choice = makeChoiceOptions(id, phrase, distractors, "vietnamese");

    return baseItem({
      id,
      questionType: "natural_phrase_choice",
      phrase,
      page,
      prompt: {
        kind: "naturalness",
        text: naturalPromptForVariant(phrase),
        variantRole: phrase.variantRole,
      },
      source: sourceForPhrase(phrase, page, "natural_phrase_choice"),
      answer: {
        phraseID: phrase.id,
        optionID: choice.correctOptionID,
        vietnamese: phrase.targetText,
        english: phrase.englishText,
        audioKey: phrase.audioKey,
        variantRole: phrase.variantRole,
      },
      options: choice.options,
      distractors: choice.distractors,
      feedback: feedbackForPhrase(phrase, page, "natural_phrase_choice", {
        contrast: `This item practices the authored "${phrase.variantRole}" variant, not a newly invented wording.`,
      }),
      tags: tagsForPhrase(phrase, page, "natural_phrase_choice", {
        variantRole: phrase.variantRole,
      }),
    });
  });
}

function buildPracticeFlows(items) {
  const byScenario = groupBy(items, (item) => item.source.scenarioID);
  const byType = groupBy(items, (item) => item.questionType);

  function idsForScenario(scenarioID, limit) {
    return (byScenario.get(scenarioID) || []).slice(0, limit).map((item) => item.id);
  }

  function firstIDForType(type) {
    return (byType.get(type) || [])[0] && (byType.get(type) || [])[0].id;
  }

  function uniqueIDs(ids, limit) {
    return Array.from(new Set(ids.filter(Boolean))).slice(0, limit);
  }

  const starter = uniqueIDs(
    [
      firstIDForType("listening_choice"),
      firstIDForType("english_to_vietnamese"),
      firstIDForType("vietnamese_to_english"),
      firstIDForType("situation_pick"),
      firstIDForType("phrase_chunk_rebuild"),
      firstIDForType("natural_phrase_choice"),
      firstIDForType("pronoun_variant_choice"),
      ...idsForScenario("polite-basics", 3),
      ...idsForScenario("understanding-repair", 3),
      ...idsForScenario("transport", 3),
      ...idsForScenario("food-drink", 3),
    ],
    12,
  );

  return [
    {
      id: "starter-essentials",
      title: "Starter essentials",
      source: "curated-starter",
      summary: "A five-prompt sampler across listening, phrase choice, meaning, situations, and chunks.",
      itemIDs: starter.length >= 5 ? starter : items.slice(0, 10).map((item) => item.id),
      defaultSessionLength: 5,
      entryPoints: ["home", "practice"],
    },
    {
      id: "hotel-desk",
      title: "Hotel desk",
      source: "category",
      summary: "Check-in, room, and front-desk phrases from real hotel pages.",
      itemIDs: idsForScenario("hotel-accommodation", 12),
      defaultSessionLength: 5,
      entryPoints: ["practice", "category"],
    },
    {
      id: "food-counter",
      title: "Food counter",
      source: "category",
      summary: "Cafe, menu, and ordering phrases from the authored food lane.",
      itemIDs: idsForScenario("food-drink", 12),
      defaultSessionLength: 5,
      entryPoints: ["practice", "category"],
    },
    {
      id: "pronoun-coach",
      title: "Pronoun coach",
      source: "pronouns",
      summary: "Authored pronoun/self-reference cues only; no invented kinship drills.",
      itemIDs: (byType.get("pronoun_variant_choice") || []).map((item) => item.id),
      defaultSessionLength: 5,
      entryPoints: ["practice", "source-page"],
    },
    {
      id: "review-missed",
      title: "Review missed",
      source: "local-progress",
      summary: "A due-first demo flow using item progress fields that stay local later.",
      itemIDs: [
        ...(byScenario.get("money-numbers-prices") || []),
        ...(byScenario.get("health-pharmacy") || []),
        ...(byScenario.get("emergency-safety") || []),
      ]
        .slice(0, 10)
        .map((item) => item.id),
      defaultSessionLength: 5,
      entryPoints: ["practice", "completion"],
    },
  ];
}

function buildPracticeCore({ repoRoot }) {
  const catalog = readJSON(repoRoot, SOURCE_FILES.nativeCatalog);
  const authoredPages = readJSON(repoRoot, SOURCE_FILES.authoredPages);
  const audioAudit = readJSON(repoRoot, SOURCE_FILES.authoredAudioAudit);
  const phraseSourceText = fs.readFileSync(path.join(repoRoot, SOURCE_FILES.phraseSourceCSV), "utf8");
  const phraseSourceRowCount = phraseSourceText.split(/\r?\n/).filter(Boolean).length - 1;
  const resolvedAudioKeys = new Set((audioAudit.required || []).filter((entry) => entry.resolved).map((entry) => entry.audioKey));
  const pagesByFamily = new Map();

  for (const page of authoredPages.pages || []) {
    if (page.familyID && !pagesByFamily.has(page.familyID)) {
      pagesByFamily.set(page.familyID, page);
    }
  }

  const eligiblePhrases = (catalog.phrases || [])
    .filter((phrase) => phrase.audioStatus === "ready")
    .filter((phrase) => phrase.targetText && phrase.englishText)
    .filter((phrase) => pagesByFamily.has(phrase.familyID))
    .filter((phrase) => phrase.audioKey && resolvedAudioKeys.has(phrase.audioKey))
    .sort((a, b) => {
      const scenarioCompare = a.scenarioID.localeCompare(b.scenarioID);
      return scenarioCompare || a.id.localeCompare(b.id);
    });

  const allItems = [
    ...buildListeningItems(eligiblePhrases, pagesByFamily, eligiblePhrases),
    ...buildEnglishToVietnameseItems(eligiblePhrases, pagesByFamily, eligiblePhrases),
    ...buildVietnameseToEnglishItems(eligiblePhrases, pagesByFamily, eligiblePhrases),
    ...buildSituationItems(eligiblePhrases, pagesByFamily, eligiblePhrases),
    ...buildPronounItems(eligiblePhrases, pagesByFamily, eligiblePhrases),
    ...buildChunkItems(eligiblePhrases, pagesByFamily),
    ...buildNaturalChoiceItems(eligiblePhrases, pagesByFamily, eligiblePhrases),
  ];

  const items = uniqueBy(allItems, (item) => item.id);
  const scenarioIDs = Array.from(new Set(items.map((item) => item.source.scenarioID))).sort();
  const categoryIDs = Array.from(new Set(items.flatMap((item) => item.tags.categoryIDs))).sort();
  const questionTypeIDs = Array.from(new Set(items.map((item) => item.questionType))).sort();
  const audioKeys = Array.from(new Set(items.flatMap((item) => [item.prompt.audioKey, item.answer.audioKey].filter(Boolean)))).sort();

  const practiceCore = {
    schemaVersion: "speaklocal.practice-core.v0.1",
    language: "vi",
    localeName: "Vietnamese",
    generatedAt: GENERATED_AT,
    generatorVersion: GENERATOR_VERSION,
    sourceFiles: SOURCE_FILES,
    metadata: {
      itemCount: items.length,
      scenarioCount: scenarioIDs.length,
      categoryCount: categoryIDs.length,
      questionTypeCount: questionTypeIDs.length,
      flowCount: 5,
      phraseSourceRowCount,
      offlineOnly: true,
      runtimeAI: false,
      nativeRuntimeTouched: false,
      correctAnswerPolicy: "Every item anchors its correct answer to a source phrase, source page, phrase row, or breakdown token.",
    },
    questionTypeDefinitions: QUESTION_TYPES,
    scenarios: scenarioIDs.map((id) => ({
      id,
      title: SCENARIO_TITLES[id] || id,
    })),
    practiceFlows: buildPracticeFlows(items),
    items,
    audioAudit: {
      requiredCount: audioKeys.length,
      missingCount: 0,
      required: audioKeys.map((audioKey) => ({
        audioKey,
        resolved: true,
        source: "native-ios/Resources/viet-authored-audio-audit.json",
      })),
    },
    nativeHandoff: {
      bundledReadModel: "Later native work can move this JSON shape into the T-168 SQLite phrase graph or a generated native resource without changing prompt identity.",
      localStateBridge: "T-167 local saved/practice state should store selected source phrase/page IDs and prompt progress keyed by items[].id.",
      noRuntimeAI: "Deck assembly and prompt feedback remain deterministic and bundled offline.",
    },
  };

  practiceCore.metadata.flowCount = practiceCore.practiceFlows.length;
  return practiceCore;
}

function buildSectionIDMap(authoredPages) {
  if (!authoredPages || !Array.isArray(authoredPages.pages)) {
    return null;
  }
  return new Map(authoredPages.pages.map((page) => [page.id, new Set((page.sections || []).map((section) => section.id))]));
}

function validatePracticeCore(practiceCore, options = {}) {
  const errors = [];
  const itemIDs = new Set();
  const questionTypes = new Set();
  const scenarios = new Set();
  const flowIDs = new Set();
  const sectionIDsByPage = buildSectionIDMap(options.authoredPages);

  if (!practiceCore || typeof practiceCore !== "object") {
    return { errors: ["practice core is not an object"], warnings: [] };
  }

  if (!Array.isArray(practiceCore.items)) {
    errors.push("items must be an array");
  }

  for (const item of practiceCore.items || []) {
    if (!item.id) {
      errors.push("item missing id");
      continue;
    }
    if (itemIDs.has(item.id)) {
      errors.push(`${item.id} duplicate item id`);
    }
    itemIDs.add(item.id);
    questionTypes.add(item.questionType);
    scenarios.add(item.source && item.source.scenarioID);

    if (!QUESTION_TYPE_BY_ID.has(item.questionType)) {
      errors.push(`${item.id} unknown questionType ${item.questionType}`);
    }
    if (!item.source || !item.source.phraseID || !item.source.pageID || !item.source.familyID || !item.source.scenarioID) {
      errors.push(`${item.id} missing source identity`);
    }
    if (sectionIDsByPage && item.source) {
      const sectionIDs = sectionIDsByPage.get(item.source.pageID);
      if (!sectionIDs) {
        errors.push(`${item.id} source.pageID does not resolve to an authored page`);
      } else if (!sectionIDs.has(item.source.sectionID)) {
        errors.push(`${item.id} source.sectionID does not resolve to an authored page section`);
      }
    }
    if (!item.prompt || !item.prompt.text) {
      errors.push(`${item.id} missing prompt text`);
    }
    if (!item.answer || (!item.answer.phraseID && !item.answer.breakdownTokenIDs)) {
      errors.push(`${item.id} missing answer anchor`);
    }
    if (item.answer && item.answer.phraseID && item.source && item.answer.phraseID !== item.source.phraseID) {
      errors.push(`${item.id} answer phrase does not match source phrase`);
    }
    if (item.questionType !== "phrase_chunk_rebuild") {
      if (!Array.isArray(item.options) || item.options.length < 3) {
        errors.push(`${item.id} needs at least 3 options`);
      }
      if (!item.correctOptionID || !item.options.some((option) => option.id === item.correctOptionID && option.isCorrect)) {
        errors.push(`${item.id} correctOptionID does not identify a correct option`);
      }
      if (!Array.isArray(item.distractors) || item.distractors.length < 2) {
        errors.push(`${item.id} needs at least 2 distractors`);
      }
    }
    if (item.questionType === "phrase_chunk_rebuild") {
      if (!item.answer || !Array.isArray(item.answer.correctSequence) || item.answer.correctSequence.length < 2) {
        errors.push(`${item.id} rebuild item needs answer.correctSequence`);
      }
      if (
        item.answer &&
        Array.isArray(item.answer.correctSequence) &&
        normalizeVietnameseForMatch(item.answer.correctSequence.map((chunk) => chunk.vietnamese).join(" ")) !==
          normalizeVietnameseForMatch(item.answer.vietnamese)
      ) {
        errors.push(`${item.id} rebuild chunks do not reconstruct the practiced phrase`);
      }
      if (item.answer && Array.isArray(item.answer.correctSequence) && item.answer.correctSequence.some((chunk) => Object.prototype.hasOwnProperty.call(chunk, "english"))) {
        errors.push(`${item.id} rebuild chunks must not expose unreviewed token glosses`);
      }
      if (!item.source.sourceBreakdownTokenIDs || item.source.sourceBreakdownTokenIDs.length < 2) {
        errors.push(`${item.id} rebuild item needs source breakdown tokens`);
      }
    }
    if (item.questionType === "listening_choice" && (!item.prompt.audioKey || item.requiresAudio !== true)) {
      errors.push(`${item.id} listening item needs prompt audio and requiresAudio`);
    }
    if (!item.feedback || !item.feedback.correct || !item.feedback.source) {
      errors.push(`${item.id} missing feedback`);
    }
    if (!item.tags || !Array.isArray(item.tags.categoryIDs) || !Array.isArray(item.tags.skillTags)) {
      errors.push(`${item.id} missing tags`);
    }
    for (const field of ["seenCount", "correctStreak", "missedCount", "lastSeenAt", "nextDueAt", "lastResult", "sourceDeckID"]) {
      if (!item.progress || !Object.prototype.hasOwnProperty.call(item.progress, field)) {
        errors.push(`${item.id} missing progress.${field}`);
      }
    }
    if (!item.progress || item.progress.localOnly !== true) {
      errors.push(`${item.id} progress.localOnly must be true`);
    }
    if (item.audit && item.audit.genericTravelTrivia !== false) {
      errors.push(`${item.id} does not explicitly reject generic travel trivia`);
    }
  }

  if ((practiceCore.items || []).length < 60) {
    errors.push(`expected at least 60 items, found ${(practiceCore.items || []).length}`);
  }
  if (scenarios.size < 8) {
    errors.push(`expected at least 8 scenarios, found ${scenarios.size}`);
  }
  for (const type of QUESTION_TYPES.map((entry) => entry.id)) {
    if (!questionTypes.has(type)) {
      errors.push(`missing question type ${type}`);
    }
  }

  for (const flow of practiceCore.practiceFlows || []) {
    if (flowIDs.has(flow.id)) {
      errors.push(`${flow.id} duplicate flow id`);
    }
    flowIDs.add(flow.id);
    if (!Array.isArray(flow.itemIDs) || flow.itemIDs.length < 5) {
      errors.push(`${flow.id} needs at least 5 item ids`);
    }
    for (const itemID of flow.itemIDs || []) {
      if (!itemIDs.has(itemID)) {
        errors.push(`${flow.id} references missing item ${itemID}`);
      }
    }
  }

  if ((practiceCore.practiceFlows || []).length < 3 || (practiceCore.practiceFlows || []).length > 5) {
    errors.push(`expected 3-5 practice flows, found ${(practiceCore.practiceFlows || []).length}`);
  }

  return { errors, warnings: [] };
}

function writeOutputs(practiceCore, { repoRoot }) {
  const json = `${JSON.stringify(practiceCore, null, 2)}\n`;
  for (const relativePath of OUTPUT_PATHS) {
    const absolutePath = path.join(repoRoot, relativePath);
    fs.mkdirSync(path.dirname(absolutePath), { recursive: true });
    fs.writeFileSync(absolutePath, json, "utf8");
  }
}

function checkExistingOutputs(practiceCore, { repoRoot, authoredPages }) {
  const errors = [];
  for (const relativePath of OUTPUT_PATHS) {
    const absolutePath = path.join(repoRoot, relativePath);
    if (!fs.existsSync(absolutePath)) {
      errors.push(`${relativePath} does not exist`);
      continue;
    }
    const parsed = JSON.parse(fs.readFileSync(absolutePath, "utf8"));
    const validation = validatePracticeCore(parsed, { authoredPages });
    errors.push(...validation.errors.map((error) => `${relativePath}: ${error}`));
    if (JSON.stringify(parsed) !== JSON.stringify(practiceCore)) {
      errors.push(`${relativePath} is stale; rerun node scripts/practice/generate-viet-practice-deck.js`);
    }
  }
  return errors;
}

function main() {
  const repoRoot = path.resolve(__dirname, "../..");
  const args = new Set(process.argv.slice(2));
  const practiceCore = buildPracticeCore({ repoRoot });
  const authoredPages = readJSON(repoRoot, SOURCE_FILES.authoredPages);
  const validation = validatePracticeCore(practiceCore, { authoredPages });

  if (validation.errors.length) {
    console.error(validation.errors.join("\n"));
    process.exit(1);
  }

  if (args.has("--check")) {
    const outputErrors = checkExistingOutputs(practiceCore, { repoRoot, authoredPages });
    if (outputErrors.length) {
      console.error(outputErrors.join("\n"));
      process.exit(1);
    }
    console.log(
      `Practice deck check OK: ${practiceCore.items.length} items, ${practiceCore.metadata.scenarioCount} scenarios, ${practiceCore.metadata.questionTypeCount} question types`,
    );
    return;
  }

  writeOutputs(practiceCore, { repoRoot });
  console.log(
    `Wrote Practice Core sample deck: ${practiceCore.items.length} items, ${practiceCore.metadata.scenarioCount} scenarios, ${practiceCore.metadata.questionTypeCount} question types`,
  );
}

if (require.main === module) {
  main();
}

module.exports = {
  QUESTION_TYPES,
  buildPracticeCore,
  validatePracticeCore,
  writeOutputs,
};
