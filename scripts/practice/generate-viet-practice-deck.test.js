#!/usr/bin/env node

const assert = require("assert");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const generator = require("./generate-viet-practice-deck.js");

const REQUIRED_TYPES = new Set([
  "listening_choice",
  "english_to_vietnamese",
  "vietnamese_to_english",
  "situation_pick",
  "pronoun_variant_choice",
  "phrase_chunk_rebuild",
  "natural_phrase_choice",
]);

const REQUIRED_PROGRESS_FIELDS = [
  "seenCount",
  "correctStreak",
  "missedCount",
  "lastSeenAt",
  "nextDueAt",
  "lastResult",
  "sourceDeckID",
];

function normalizeVietnamese(text) {
  return String(text || "")
    .normalize("NFC")
    .toLowerCase()
    .replace(/[.,!?…]/g, "")
    .replace(/\s+/g, "");
}

const practiceCore = generator.buildPracticeCore({ repoRoot });
const authoredPages = require(path.join(repoRoot, "native-ios/Resources/viet-authored-listing-pages.json"));
const validation = generator.validatePracticeCore(practiceCore, { authoredPages });
const sectionIDsByPage = new Map(
  authoredPages.pages.map((page) => [page.id, new Set((page.sections || []).map((section) => section.id))]),
);

const badSectionDeck = JSON.parse(JSON.stringify(practiceCore));
badSectionDeck.items[0].source.sectionID = "hero";
assert.ok(
  generator.validatePracticeCore(badSectionDeck, { authoredPages }).errors.some((error) => error.includes("source.sectionID")),
  "validatePracticeCore should reject unresolved source.sectionID values",
);

assert.deepStrictEqual(validation.errors, [], validation.errors.join("\n"));
assert.ok(practiceCore.items.length >= 60, "sample deck must include at least 60 items");

const scenarios = new Set(practiceCore.items.map((item) => item.source.scenarioID));
assert.ok(scenarios.size >= 8, `expected at least 8 scenarios, got ${scenarios.size}`);

const questionTypes = new Set(practiceCore.items.map((item) => item.questionType));
const airportChunkItem = practiceCore.items.find((item) => item.id === "viet-practice-chunks-airport-1");
assert.ok(
  airportChunkItem,
  "chunk rebuild generation should ignore the authored full-phrase breakdown token",
);
assert.deepStrictEqual(
  airportChunkItem.answer.correctSequence.map((chunk) => chunk.vietnamese),
  ["Nhập cảnh", "ở đâu?"],
);

for (const type of REQUIRED_TYPES) {
  assert.ok(questionTypes.has(type), `missing question type ${type}`);
}

for (const item of practiceCore.items) {
  assert.ok(item.id, "item has stable id");
  assert.ok(item.source.phraseID, `${item.id} missing source.phraseID`);
  assert.ok(item.source.pageID, `${item.id} missing source.pageID`);
  assert.ok(sectionIDsByPage.get(item.source.pageID), `${item.id} references unknown source page ${item.source.pageID}`);
  assert.ok(
    sectionIDsByPage.get(item.source.pageID).has(item.source.sectionID),
    `${item.id} source.sectionID must resolve to an authored page section`,
  );
  assert.ok(item.source.familyID, `${item.id} missing source.familyID`);
  assert.ok(item.source.scenarioID, `${item.id} missing source.scenarioID`);
  assert.ok(item.prompt.text, `${item.id} missing prompt text`);
  assert.ok(item.answer.phraseID || item.answer.breakdownTokenIDs, `${item.id} missing answer anchor`);
  assert.ok(item.feedback.correct, `${item.id} missing correct feedback`);
  assert.ok(item.feedback.source, `${item.id} missing source feedback`);
  assert.ok(Array.isArray(item.tags.categoryIDs), `${item.id} missing category tags`);
  assert.ok(Array.isArray(item.tags.skillTags), `${item.id} missing skill tags`);
  for (const field of REQUIRED_PROGRESS_FIELDS) {
    assert.ok(Object.prototype.hasOwnProperty.call(item.progress, field), `${item.id} missing progress.${field}`);
  }
  if (item.questionType === "listening_choice") {
    assert.ok(item.prompt.audioKey, `${item.id} listening prompt missing audioKey`);
    assert.strictEqual(item.requiresAudio, true, `${item.id} listening prompt should require audio`);
  }
  if (item.questionType === "phrase_chunk_rebuild") {
    assert.ok(item.answer.correctSequence.length >= 2, `${item.id} needs a rebuild sequence`);
    assert.strictEqual(
      normalizeVietnamese(item.answer.correctSequence.map((chunk) => chunk.vietnamese).join(" ")),
      normalizeVietnamese(item.answer.vietnamese),
      `${item.id} chunk sequence must rebuild the practiced phrase exactly`,
    );
    assert.ok(
      item.answer.correctSequence.every((chunk) => !Object.prototype.hasOwnProperty.call(chunk, "english")),
      `${item.id} chunk sequence should not expose unreviewed word-level English glosses`,
    );
  } else {
    assert.ok(item.distractors.length >= 2, `${item.id} should include distractors`);
  }
}

const flowIDs = new Set(practiceCore.practiceFlows.map((flow) => flow.id));
for (const id of ["starter-essentials", "hotel-desk", "food-counter", "pronoun-coach", "city-first-trip"]) {
  assert.ok(flowIDs.has(id), `missing prototype flow ${id}`);
}

const cityItems = practiceCore.items.filter((item) => item.source.scenarioID === "city-guides");
assert.ok(cityItems.length >= practiceCore.metadata.cityLibraryPageCount, "city-guides practice items should cover the city library");
const cityIDs = new Set(cityItems.map((item) => item.tags.cityID));
for (const cityID of ["hcmc", "hanoi", "danang", "hoian", "hue"]) {
  assert.ok(cityIDs.has(cityID), `city-guides practice items should include ${cityID}`);
}
for (const item of cityItems) {
  assert.ok(item.tags.cityID, `${item.id} should carry cityID`);
  assert.ok(item.tags.citySubcategoryID, `${item.id} should carry city subcategory`);
  assert.ok(item.tags.difficulty, `${item.id} should carry difficulty`);
  assert.equal(item.requiresAudio, false, `${item.id} should not require planned city audio`);
}

const cityFirstTrip = practiceCore.practiceFlows.find((flow) => flow.id === "city-first-trip");
assert.ok(cityFirstTrip, "city-first-trip flow should be present");
const cityFirstTripCities = new Set(
  cityFirstTrip.itemIDs
    .map((itemID) => practiceCore.items.find((item) => item.id === itemID))
    .filter(Boolean)
    .map((item) => item.tags.cityID),
);
for (const cityID of ["hcmc", "hanoi", "danang", "hoian", "hue"]) {
  assert.ok(cityFirstTripCities.has(cityID), `city-first-trip flow should include ${cityID}`);
}

assert.ok(
  practiceCore.practiceFlows.some((flow) =>
    flow.itemIDs.slice(0, flow.defaultSessionLength || 5).some((itemID) => {
      const item = practiceCore.items.find((candidate) => candidate.id === itemID);
      return item && item.questionType === "phrase_chunk_rebuild";
    }),
  ),
  "at least one default prototype flow should expose chunk rebuild without extending the session",
);

console.log(
  `Practice deck contract OK: ${practiceCore.items.length} items, ${scenarios.size} scenarios, ${questionTypes.size} question types`,
);
