#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const repoRoot = path.resolve(__dirname, "../..");
const proofRoot = path.join(
  repoRoot,
  "docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global"
);
const defaultManifest = path.join(proofRoot, "v2-2-render-proof-manifest.json");
const defaultResults = path.join(proofRoot, "category-balanced-results.jsonl");
const defaultLogDir = path.join(proofRoot, "xcodebuild-logs");
const defaultProject = path.join(repoRoot, "native-ios/SpeakLocalNative.xcodeproj");
const defaultDerivedData = "/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/DerivedData/SpeakLocalNative-8f3e721625a0";
const defaultDestination = "platform=iOS Simulator,id=7C386DD3-4BF1-4A34-A918-768C43CD1258";
const testIdentifier = "SpeakLocalNativeUITests/CityAppDetailV22RenderProofUITests/testCaptureCityAppDetailV22RenderProofBatch";

const args = parseArgs(process.argv.slice(2));
const manifestPath = path.resolve(args.manifest || defaultManifest);
const resultsPath = path.resolve(args.results || defaultResults);
const logDir = path.resolve(args.logDir || defaultLogDir);
const screenshotRoot = path.resolve(args.screenshotRoot || proofRoot);
const start = numberArg(args.start, 0);
const count = numberArg(args.count, 1);
const stopOnFailure = args.stopOnFailure !== "false";

fs.mkdirSync(logDir, { recursive: true });
const pages = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const passedOffsets = readPassedOffsets(resultsPath);
const selectedOffsets = [];

for (let offset = start; offset < pages.length && selectedOffsets.length < count; offset += 1) {
  if (!passedOffsets.has(offset)) {
    selectedOffsets.push(offset);
  }
}

if (selectedOffsets.length === 0) {
  console.log(`No unproved offsets selected from start=${start} count=${count}.`);
  process.exit(0);
}

let failures = 0;
for (const offset of selectedOffsets) {
  const page = pages[offset];
  const index = offset + 1;
  const indexLabel = String(index).padStart(3, "0");
  const screenshotDir = path.join(screenshotRoot, `screenshots-single-${indexLabel}`);
  const logPath = path.join(logDir, `proof-${indexLabel}.log`);
  fs.rmSync(screenshotDir, { recursive: true, force: true });
  fs.mkdirSync(screenshotDir, { recursive: true });

  const startedAt = new Date().toISOString();
  const env = {
    ...process.env,
    TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_MANIFEST: manifestPath,
    TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_DIR: screenshotDir,
    TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_OFFSET: String(offset),
    TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_LIMIT: "1"
  };

  const result = spawnSync(
    "xcodebuild",
    [
      "test-without-building",
      "-project",
      defaultProject,
      "-scheme",
      "SpeakLocalNative",
      "-destination",
      args.destination || defaultDestination,
      "-derivedDataPath",
      args.derivedDataPath || defaultDerivedData,
      "-only-testing:" + testIdentifier
    ],
    {
      cwd: repoRoot,
      env,
      encoding: "utf8",
      maxBuffer: 20 * 1024 * 1024
    }
  );

  const combinedLog = [result.stdout || "", result.stderr || ""].join("\n");
  fs.writeFileSync(logPath, combinedLog);

  const screenshotCount = countScreenshots(screenshotDir);
  const status = result.status === 0 ? "PASS" : "FAIL";
  const endedAt = new Date().toISOString();
  const row = {
    status,
    offset,
    index,
    pageID: page.pageID,
    title: page.title,
    city: page.city,
    category: page.category,
    screenshotCount,
    startedAt,
    endedAt,
    logPath
  };

  fs.appendFileSync(resultsPath, JSON.stringify(row) + "\n");
  console.log(`${status} ${indexLabel} ${page.pageID} screenshots=${screenshotCount}`);

  if (status !== "PASS") {
    failures += 1;
    process.stdout.write(tail(combinedLog, 50));
    if (stopOnFailure) {
      break;
    }
  }
}

if (failures > 0) {
  process.exit(1);
}

function parseArgs(rawArgs) {
  const parsed = {};
  for (let index = 0; index < rawArgs.length; index += 1) {
    const arg = rawArgs[index];
    if (!arg.startsWith("--")) {
      continue;
    }
    const key = arg.slice(2);
    const next = rawArgs[index + 1];
    if (!next || next.startsWith("--")) {
      parsed[key] = "true";
    } else {
      parsed[key] = next;
      index += 1;
    }
  }
  return parsed;
}

function numberArg(value, fallback) {
  const number = Number(value);
  return Number.isFinite(number) ? number : fallback;
}

function readPassedOffsets(resultsPath) {
  const offsets = new Set();
  if (!fs.existsSync(resultsPath)) {
    return offsets;
  }

  for (const line of fs.readFileSync(resultsPath, "utf8").split("\n")) {
    if (!line.trim()) {
      continue;
    }
    const row = JSON.parse(line);
    if (row.status === "PASS") {
      offsets.add(row.offset);
    }
  }
  return offsets;
}

function countScreenshots(directory) {
  if (!fs.existsSync(directory)) {
    return 0;
  }
  return fs.readdirSync(directory).filter((file) => file.endsWith(".png")).length;
}

function tail(text, lines) {
  return text.split("\n").slice(-lines).join("\n") + "\n";
}
