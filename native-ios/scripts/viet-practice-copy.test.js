#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const path = require("path");
const test = require("node:test");

const repoRoot = path.resolve(__dirname, "../..");
const catalogPath = path.join(repoRoot, "native-ios", "Resources", "viet-phrase-catalog.json");

function loadCatalogRows() {
  const payload = JSON.parse(fs.readFileSync(catalogPath, "utf8"));
  return payload.phrases ?? [];
}

test("relationship-form how-are-you practice labels read naturally in English", () => {
  const rows = new Map(loadCatalogRows().map((row) => [row.id, row]));

  assert.strictEqual(rows.get("how-are-you-anh")?.englishText, "How are you? (to an older man)");
  assert.strictEqual(rows.get("how-are-you-chi")?.englishText, "How are you? (to an older woman)");
  assert.strictEqual(rows.get("how-are-you-em")?.englishText, "How are you? (to someone younger)");
});
