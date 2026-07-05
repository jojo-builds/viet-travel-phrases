#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const validatorPath = path.join(__dirname, "validate-viet-city-app-detail-v2-2.js");

function tempSourceDir() {
  return fs.mkdtempSync(path.join(os.tmpdir(), "viet-city-app-detail-v2-2-"));
}

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function runValidator(args = []) {
  return spawnSync(process.execPath, [validatorPath, ...args], {
    cwd: path.resolve(__dirname, "..", ".."),
    encoding: "utf8",
  });
}

function validEntry(overrides = {}) {
  return {
    contentContract: "speaklocal.place.app-detail.v2.2",
    id: "city-danang-place-han-market",
    displayName: "Chợ Hàn",
    englishName: "Han Market",
    city: "danang",
    category: "shopping-markets",
    pronunciation: "cho han",
    travelerMoment: "You are near the river and want a market stop that will not eat the whole afternoon.",
    storySpine: "The market belongs to Da Nang's riverfront trade habit, where daily errands and visitor shopping overlap.",
    intro: {
      heading: "A riverfront market stop",
      body: "Chợ Hàn is a compact market with local rhythm, snack counters, gifts, and enough city texture to avoid feeling like a mall errand.",
    },
    usefulPhraseCards: [
      {
        vi: "Cái này bao nhiêu tiền?",
        en: "How much is this?",
        intent: "ask a price before buying",
        phraseId: "viet-phrase-shopping-price",
        audioId: "audio-shopping-price",
        status: "mapped",
      },
      {
        vi: "Bớt chút được không?",
        en: "Can you lower it a little?",
        intent: "ask for a lower price",
        phraseId: "viet-phrase-shopping-lower",
        audioId: "audio-shopping-lower",
        status: "mapped",
      },
    ],
    sections: [
      {
        id: "walk-the-aisles",
        heading: "Walk once before choosing",
        body: "The first lap helps you compare snacks, fabric, and souvenirs before you bargain.",
      },
      {
        id: "leave-space",
        heading: "Leave room in the bag",
        body: "It is easiest to buy small things here, then keep bigger food or coffee plans for after the market.",
      },
    ],
    mentionedHereCandidates: [
      {
        label: "Dragon Bridge",
        type: "place",
        catalogId: "city-danang-place-dragon-bridge",
        sourceText: "near the river",
        displaySubtitle: "Nearby river landmark",
        reason: "Internal route context.",
        status: "render",
      },
    ],
    relatedPlaceCandidates: [],
    verificationFlags: [],
    qa: {
      replaceabilityTest: "pass",
      phraseCardTest: "pass",
      mentionedHereTest: "pass",
      catalogMentionScan: "pass",
      duplicateBodyTest: "pass",
      antiCynicismTest: "pass",
      notes: [],
    },
    score: {
      value: 30,
      max: 30,
      reason: "Clear traveler moment, story spine, phrase card, and compact sections.",
    },
    status: "FINAL_PASS",
    sourceNotes: ["Internal notes are not visible."],
    ...overrides,
  };
}

test("passes valid v2.2 source files and reports city/status inventory", () => {
  const sourceDir = tempSourceDir();
  writeJSON(path.join(sourceDir, "danang", "han-market.json"), validEntry());
  writeJSON(
    path.join(sourceDir, "hanoi", "coffee.json"),
    validEntry({
      id: "city-hanoi-place-giang-cafe",
      displayName: "Cà phê Giảng",
      englishName: "Giang Cafe",
      city: "hanoi",
    }),
  );

  const result = runValidator(["--source-dir", sourceDir]);

  assert.strictEqual(result.status, 0, `${result.stdout}\n${result.stderr}`);
  assert.match(result.stdout, /Viet city app-detail v2\.2 validation: PASS/);
  assert.match(result.stdout, /total entries: 2/);
  assert.match(result.stdout, /danang\s+1\s+FINAL_PASS=1/);
  assert.match(result.stdout, /hanoi\s+1\s+FINAL_PASS=1/);
});

test("ignores underscore index files and rejects stale v2_2_gate_passed as approval", () => {
  const sourceDir = tempSourceDir();
  writeJSON(path.join(sourceDir, "_index.json"), {
    entries: [{ id: "index-row-only", city: "danang", status: "needs_voice_gate" }],
  });
  writeJSON(path.join(sourceDir, "danang.json"), {
    entries: [validEntry({ status: "v2_2_gate_passed" })],
  });

  const result = runValidator(["--source-dir", sourceDir]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout, /total entries: 1/);
  assert.match(result.stdout + result.stderr, /unsupported status v2_2_gate_passed/);
});

test("default mode allows needs_voice_gate but prints production blocked", () => {
  const sourceDir = tempSourceDir();
  writeJSON(path.join(sourceDir, "danang", "han-market.json"), validEntry({ status: "needs_voice_gate" }));

  const result = runValidator(["--source-dir", sourceDir]);

  assert.strictEqual(result.status, 0, `${result.stdout}\n${result.stderr}`);
  assert.match(result.stdout, /production blocked: 1 entr(?:y|ies) are not FINAL_PASS/i);
});

test("strict production mode fails unless every entry is FINAL_PASS", () => {
  const sourceDir = tempSourceDir();
  writeJSON(path.join(sourceDir, "danang", "han-market.json"), validEntry({ status: "needs_voice_gate" }));

  const result = runValidator(["--source-dir", sourceDir, "--strict-production"]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout + result.stderr, /strict production requires every entry to be FINAL_PASS/i);
});

test("rejects missing required fields, bad section counts, and banned visible-copy phrases", () => {
  const sourceDir = tempSourceDir();
  const entry = validEntry({
    travelerMoment: "",
    storySpine: undefined,
    sections: [{ id: "only-one", heading: "Only one", body: "Too few." }],
    status: "REVISE",
  });
  entry.intro.body = "This page helps because the destination reference line works as a stable role.";
  delete entry.qa;
  writeJSON(path.join(sourceDir, "danang", "bad.json"), entry);

  const result = runValidator(["--source-dir", sourceDir]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout + result.stderr, /travelerMoment is required/);
  assert.match(result.stdout + result.stderr, /storySpine is required/);
  assert.match(result.stdout + result.stderr, /sections must contain 2-4 items/);
  assert.match(result.stdout + result.stderr, /qa is required/);
  assert.match(result.stdout + result.stderr, /banned visible-copy phrase "destination reference line"/);
});

test("rejects FINAL_PASS entries with unmapped or audio-less phrase cards", () => {
  const sourceDir = tempSourceDir();
  const entry = validEntry({
    usefulPhraseCards: [
      {
        vi: "Chợ Hàn",
        en: "Han Market",
        intent: "recognize place name",
        phraseId: "city-danang-place-han-market",
        audioId: null,
        status: "hide_until_audio",
      },
      {
        vi: "Hai",
        en: "Two",
        intent: "two",
        phraseId: "phrase-two",
        audioId: "audio-two",
        status: "mapped",
      },
    ],
  });
  writeJSON(path.join(sourceDir, "danang", "bad-phrase.json"), entry);

  const result = runValidator(["--source-dir", sourceDir]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout + result.stderr, /usefulPhraseCards\[0\]\.status must be mapped for FINAL_PASS entries/);
  assert.match(result.stdout + result.stderr, /usefulPhraseCards\[0\]\.audioId must be set for FINAL_PASS entries/);
});

test("requires at least two useful phrase cards", () => {
  const sourceDir = tempSourceDir();
  writeJSON(path.join(sourceDir, "danang", "too-few-phrases.json"), validEntry({
    usefulPhraseCards: [
      {
        vi: "Một",
        en: "One",
        intent: "one",
        phraseId: "phrase-one",
        audioId: "audio-one",
        status: "mapped",
      },
    ],
  }));

  const result = runValidator(["--source-dir", sourceDir]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout + result.stderr, /usefulPhraseCards must contain at least 2 items/);
});

test("rejects FINAL_PASS entries with too many phrase cards or legacy section ids", () => {
  const sourceDir = tempSourceDir();
  writeJSON(path.join(sourceDir, "danang", "legacy-section.json"), validEntry({
    usefulPhraseCards: [
      { vi: "Một", en: "One", intent: "one", phraseId: "phrase-one", audioId: "audio-one", status: "mapped" },
      { vi: "Hai", en: "Two", intent: "two", phraseId: "phrase-two", audioId: "audio-two", status: "mapped" },
      { vi: "Ba", en: "Three", intent: "three", phraseId: "phrase-three", audioId: "audio-three", status: "mapped" },
      { vi: "Bốn", en: "Four", intent: "four", phraseId: "phrase-four", audioId: "audio-four", status: "mapped" },
    ],
    sections: [
      { id: "place-brief", heading: "Legacy section", body: "This legacy section should never be approval authority." },
      { id: "hội-an-car", heading: "Bad slug", body: "Section IDs should stay ASCII in first-class v2.2 source." },
    ],
  }));

  const result = runValidator(["--source-dir", sourceDir]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout + result.stderr, /usefulPhraseCards must contain at most 3 items/);
  assert.match(result.stdout + result.stderr, /sections\[0\]\.id uses legacy city-v1 section id "place-brief"/);
  assert.match(result.stdout + result.stderr, /sections\[1\]\.id must be lowercase ASCII slug/);
});

test("rejects stale source index statuses and counts", () => {
  const sourceDir = tempSourceDir();
  const entry = validEntry();
  writeJSON(path.join(sourceDir, "danang.json"), {
    entries: [entry],
  });
  writeJSON(path.join(sourceDir, "_index.json"), {
    counts: {
      entries: 1,
      finalPass: 0,
      needsVoiceGate: 1,
    },
    entries: [
      {
        id: entry.id,
        pageID: entry.pageID,
        cityID: "danang",
        status: "needs_voice_gate",
        file: "danang.json",
      },
    ],
  });

  const result = runValidator(["--source-dir", sourceDir]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout + result.stderr, /counts\.finalPass is 0, expected 1/);
  assert.match(result.stdout + result.stderr, /counts\.needsVoiceGate is 1, expected 0/);
  assert.match(result.stdout + result.stderr, /danang\.json:city-danang-place-han-market status is needs_voice_gate, expected FINAL_PASS/);
});

test("fails clearly when the source directory is missing", () => {
  const sourceDir = path.join(tempSourceDir(), "missing");

  const result = runValidator(["--source-dir", sourceDir]);

  assert.notStrictEqual(result.status, 0);
  assert.match(result.stdout + result.stderr, /source directory not found/i);
});
