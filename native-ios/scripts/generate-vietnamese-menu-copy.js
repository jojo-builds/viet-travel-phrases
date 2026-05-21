#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const {
  CSV_RELATIVE_PATH,
  RUNTIME_RELATIVE_PATH,
  buildCSV,
  buildRuntimePayload,
  loadAuthoredMenuSource,
  stableStringify,
  writeRuntimeAndCSV,
} = require("./lib/vietnamese-menu-copy-source");

const repoRoot = path.resolve(__dirname, "..", "..");
const checkOnly = process.argv.includes("--check");

main();

function main() {
  const source = loadAuthoredMenuSource(repoRoot);
  const payload = buildRuntimePayload(source);
  const csvText = buildCSV(source);

  if (checkOnly) {
    assertMatches(path.join(repoRoot, RUNTIME_RELATIVE_PATH), stableStringify(payload));
    assertMatches(path.join(repoRoot, CSV_RELATIVE_PATH), csvText);
    console.log(`Vietnamese menu generated artifacts match authored source (${payload.items.length} items)`);
    return;
  }

  writeRuntimeAndCSV(repoRoot, payload, csvText);
  console.log(
    `Generated ${RUNTIME_RELATIVE_PATH} and ${CSV_RELATIVE_PATH} from ${payload.items.length} authored menu items`
  );
}

function assertMatches(filePath, expected) {
  const actual = fs.readFileSync(filePath, "utf8");
  if (actual !== expected) {
    throw new Error(`${path.relative(repoRoot, filePath)} is out of date. Run node native-ios/scripts/generate-vietnamese-menu-copy.js`);
  }
}
