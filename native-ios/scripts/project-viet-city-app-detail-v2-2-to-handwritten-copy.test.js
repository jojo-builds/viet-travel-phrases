#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const repoRoot = path.resolve(__dirname, "..", "..");
const scriptPath = path.join(__dirname, "project-viet-city-app-detail-v2-2-to-handwritten-copy.js");
const cityIDs = ["danang", "hanoi", "hcmc", "hoian", "hue"];

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function appEntry(cityID, index, status = "FINAL_PASS") {
  const pageID = `city-${cityID}-place-test-${index}`;
  return {
    contentContract: "speaklocal.place.app-detail.v2.2",
    id: `viet-family-${pageID}`,
    pageID,
    displayName: `Test ${index}`,
    englishName: `Test ${index}`,
    city: cityID,
    category: "Museum",
    pronunciation: "test",
    travelerMoment: "A concrete arrival scene before the visit begins.",
    storySpine: "A truthful local reason this place belongs here.",
    intro: {
      heading: "A Real First Screen",
      body: "This compact body gives enough place-specific context to project into the legacy runtime path without inventing new copy.",
    },
    usefulPhraseCards: [
      { vi: "Một", en: "One", intent: "one", phraseId: "phrase-one", audioId: "audio-one", status: "mapped" },
      { vi: "Hai", en: "Two", intent: "two", phraseId: "phrase-two", audioId: "audio-two", status: "mapped" },
    ],
    sections: [
      { id: "first-move", heading: "First Move", body: "Start with one clear action before trying to do everything." },
      { id: "why-here", heading: "Why Here", body: "The place earns attention through a specific local pattern." },
      { id: "leave-well", heading: "Leave Well", body: "Leave before the visit becomes a checklist." },
    ],
    mentionedHereCandidates: [],
    relatedPlaceCandidates: [],
    verificationFlags: [],
    qa: {
      replaceabilityTest: "pass",
      phraseCardTest: "pass",
      mentionedHereTest: "pass",
      catalogMentionScan: "pass",
      duplicateBodyTest: "pass",
      antiCynicismTest: "pass",
    },
    score: { value: 30, max: 30, reason: "pass" },
    sourceNotes: [],
    status,
    review: { status, voiceGateStatus: "passed" },
  };
}

function run(args) {
  return spawnSync(process.execPath, [scriptPath, ...args], {
    cwd: repoRoot,
    encoding: "utf8",
  });
}

test("projects FINAL_PASS app-detail entries to legacy handwritten-copy shape", () => {
  const sourceDir = fs.mkdtempSync(path.join(os.tmpdir(), "app-detail-v2-2-source-"));
  const outDir = fs.mkdtempSync(path.join(os.tmpdir(), "handwritten-copy-out-"));
  for (const cityID of cityIDs) {
    writeJSON(path.join(sourceDir, `${cityID}.json`), {
      contentContract: "speaklocal.place.app-detail.v2.2",
      cityID,
      entries: [appEntry(cityID, 1)],
    });
  }

  const result = run(["--source-dir", sourceDir, "--out-dir", outDir]);
  assert.strictEqual(result.status, 0, `${result.stdout}\n${result.stderr}`);
  assert.match(result.stdout, /entries=5/);

  const danang = JSON.parse(fs.readFileSync(path.join(outDir, "danang.json"), "utf8"));
  assert.strictEqual(danang.authoringStandard, "speaklocal.place.app-detail.v2.2 projected to legacy runtime compatibility");
  assert.strictEqual(danang.entries.length, 1);
  assert.strictEqual(
    danang.entries[0].summary,
    "A concrete arrival scene before the visit begins. A truthful local reason this place belongs here."
  );
  assert.strictEqual(danang.entries[0].sections[0].id, "at-glance");
  assert.strictEqual(danang.entries[0].sections[1].id, "quick-say");
  assert.deepStrictEqual(danang.entries[0].sections[1].phraseIDs, ["phrase-one", "phrase-two"]);
  assert.strictEqual(danang.entries[0].sections[2].id, "place-brief");
  assert.strictEqual(danang.entries[0].sections[3].id, "use-it-with");
  assert.strictEqual(danang.entries[0].sections[4].id, "when-to-use");
});

test("refuses non-final entries by default", () => {
  const sourceDir = fs.mkdtempSync(path.join(os.tmpdir(), "app-detail-v2-2-source-"));
  const outDir = fs.mkdtempSync(path.join(os.tmpdir(), "handwritten-copy-out-"));
  for (const cityID of cityIDs) {
    writeJSON(path.join(sourceDir, `${cityID}.json`), {
      contentContract: "speaklocal.place.app-detail.v2.2",
      cityID,
      entries: [appEntry(cityID, 1, cityID === "danang" ? "needs_voice_gate" : "FINAL_PASS")],
    });
  }

  const result = run(["--source-dir", sourceDir, "--out-dir", outDir]);
  assert.notStrictEqual(result.status, 0);
  assert.match(result.stderr, /danang has 1 entries that are not FINAL_PASS/);
});
