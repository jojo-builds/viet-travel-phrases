#!/usr/bin/env node

const assert = require("assert");
const crypto = require("crypto");
const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const repoRoot = path.resolve(__dirname, "..", "..");
const scriptPath = path.join(__dirname, "build-viet-city-app-detail-v2-2.js");

function run(args) {
  const result = spawnSync(process.execPath, [scriptPath, ...args], {
    cwd: repoRoot,
    encoding: "utf8",
  });
  assert.strictEqual(
    result.status,
    0,
    `script failed\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}`
  );
  return result.stdout.trim();
}

function sha256Tree(dirPath) {
  const files = [];
  function walk(current) {
    for (const name of fs.readdirSync(current).sort()) {
      const filePath = path.join(current, name);
      const stat = fs.statSync(filePath);
      if (stat.isDirectory()) {
        walk(filePath);
      } else {
        files.push(filePath);
      }
    }
  }
  walk(dirPath);
  const hash = crypto.createHash("sha256");
  for (const filePath of files) {
    hash.update(path.relative(dirPath, filePath));
    hash.update("\0");
    hash.update(fs.readFileSync(filePath));
    hash.update("\0");
  }
  return hash.digest("hex");
}

test("builds deterministic v2.2 app-detail source files from handwritten city copy", () => {
  const outDir = fs.mkdtempSync(path.join(os.tmpdir(), "viet-city-app-detail-v2-2-"));

  const firstOutput = run(["--out-dir", outDir]);
  const firstHash = sha256Tree(outDir);
  const secondOutput = run(["--out-dir", outDir]);
  const secondHash = sha256Tree(outDir);

  assert.strictEqual(firstHash, secondHash, "output tree should be deterministic");
  assert.strictEqual(firstOutput, secondOutput, "command summary should be deterministic");
  assert.match(firstOutput, /entries: 519/);
  assert.match(firstOutput, /cities: 5/);

  const index = JSON.parse(fs.readFileSync(path.join(outDir, "_index.json"), "utf8"));
  assert.strictEqual(index.contentContract, "speaklocal.place.app-detail.v2.2");
  assert.strictEqual(index.counts.entries, 519);
  assert.deepStrictEqual(index.counts.byCity, {
    danang: 106,
    hanoi: 106,
    hcmc: 106,
    hoian: 101,
    hue: 100,
  });

  const danang = JSON.parse(fs.readFileSync(path.join(outDir, "danang.json"), "utf8"));
  assert.strictEqual(danang.entries.length, 106);

  const firstEntry = danang.entries.find((entry) => entry.pageID === "city-danang-place-3d-art-in-paradise");
  assert.ok(firstEntry, "expected Da Nang 3D Art in Paradise entry");
  assert.strictEqual(firstEntry.contentContract, "speaklocal.place.app-detail.v2.2");
  assert.strictEqual(firstEntry.id, "viet-family-city-danang-place-3d-art-in-paradise");
  assert.strictEqual(firstEntry.displayName, "Bảo tàng 3D Art in Paradise Đà Nẵng");
  assert.strictEqual(firstEntry.englishName, "3D Art in Paradise Da Nang");
  assert.strictEqual(firstEntry.city, "Đà Nẵng");
  assert.strictEqual(firstEntry.category, "Museum");
  assert.strictEqual(firstEntry.travelerMoment, "Good for friends, families, or rainy afternoons when the day needs something playful without turning into a full museum visit.");
  assert.strictEqual(firstEntry.storySpine, "It gives the day a low-pressure laugh between outdoor plans, with enough structure to make group photos feel easy.");
  assert.strictEqual(firstEntry.intro.body, "Good for friends, families, or rainy afternoons when the day needs something playful without turning into a full museum visit. It gives the day a low-pressure laugh between outdoor plans, with enough structure to make group photos feel easy.");
  assert.ok(firstEntry.usefulPhraseCards.some((card) => card.phraseId === "sight-3" && card.status === "mapped"));
  assert.ok(firstEntry.sections.every((section) => section.heading && section.body));
  assert.strictEqual(firstEntry.status, "needs_voice_gate");
  assert.strictEqual(firstEntry.review.status, "needs_voice_gate");
  assert.strictEqual(index.counts.needsVoiceGate, 519);
  assert.ok(firstEntry.sourceNotes.some((note) => note.includes("handwritten-copy/danang.json")));
});
