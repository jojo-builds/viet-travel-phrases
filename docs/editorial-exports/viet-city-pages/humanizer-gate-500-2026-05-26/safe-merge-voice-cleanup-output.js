#!/usr/bin/env node

const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");

const gateRoot = __dirname;
const chunksDir = path.join(gateRoot, "chunks");
const reportPath = path.join(gateRoot, "reports", "humanizer_chunk_validation.json");
const receiptPath = path.join(gateRoot, "reports", "voice_cleanup_merge_receipts.jsonl");
const validatorPath = path.join(gateRoot, "validate-humanizer-chunks.js");
const mergePath = path.join(gateRoot, "merge-voice-cleanup-output.js");
const repoRoot = path.resolve(gateRoot, "..", "..", "..", "..");
const rejectedDir = path.join(gateRoot, "chatgpt-outputs", "rejected", "voice-cleanup");

function runNode(args, stdio = "inherit") {
  return spawnSync(process.execPath, args, { cwd: repoRoot, stdio });
}

function readReport() {
  return JSON.parse(fs.readFileSync(reportPath, "utf8"));
}

function copyDir(from, to) {
  fs.cpSync(from, to, { recursive: true });
}

function replaceDir(from, to) {
  fs.rmSync(to, { recursive: true, force: true });
  copyDir(from, to);
}

function moveRejectedOutput(outputPath) {
  const absolutePath = path.resolve(repoRoot, outputPath);
  if (!absolutePath.includes(`${path.sep}chatgpt-outputs${path.sep}voice-cleanup${path.sep}`)) return;
  if (!fs.existsSync(absolutePath)) return;

  fs.mkdirSync(rejectedDir, { recursive: true });
  const parsed = path.parse(absolutePath);
  let destination = path.join(rejectedDir, `${parsed.name}_regression${parsed.ext}`);
  let counter = 2;
  while (fs.existsSync(destination)) {
    destination = path.join(rejectedDir, `${parsed.name}_regression_${counter}${parsed.ext}`);
    counter += 1;
  }
  fs.renameSync(absolutePath, destination);
  console.error(`Moved rejected output to ${path.relative(repoRoot, destination)}`);
}

const allowPartial = process.argv.includes("--allow-partial");
const outputPaths = process.argv.slice(2).filter((arg) => arg !== "--allow-partial");
if (!outputPaths.length) {
  console.error("Usage: node safe-merge-voice-cleanup-output.js [--allow-partial] <chatgpt-output.json> [...]");
  process.exit(2);
}

runNode([validatorPath], "ignore");
const before = readReport();
const beforeReceipt = fs.existsSync(receiptPath) ? fs.readFileSync(receiptPath, "utf8") : null;
const backupDir = fs.mkdtempSync(path.join(os.tmpdir(), "speaklocal-city-chunks-"));
copyDir(chunksDir, path.join(backupDir, "chunks"));

const merge = runNode([mergePath, ...(allowPartial ? ["--allow-partial"] : []), ...outputPaths]);
if (merge.status !== 0) {
  replaceDir(path.join(backupDir, "chunks"), chunksDir);
  if (beforeReceipt === null) {
    fs.rmSync(receiptPath, { force: true });
  } else {
    fs.writeFileSync(receiptPath, beforeReceipt);
  }
  for (const outputPath of outputPaths) moveRejectedOutput(outputPath);
  runNode([validatorPath], "ignore");
  console.error(`Safe merge rolled back because merge command failed with status ${merge.status ?? "unknown"}.`);
  process.exit(1);
}
runNode([validatorPath], "ignore");
const after = readReport();

const improved =
  after.errorCount <= before.errorCount &&
  after.warningCount <= before.warningCount &&
  (after.errorCount < before.errorCount || after.warningCount < before.warningCount);

if (!improved) {
  replaceDir(path.join(backupDir, "chunks"), chunksDir);
  if (beforeReceipt === null) {
    fs.rmSync(receiptPath, { force: true });
  } else {
    fs.writeFileSync(receiptPath, beforeReceipt);
  }
  for (const outputPath of outputPaths) moveRejectedOutput(outputPath);
  runNode([validatorPath], "ignore");
  console.error(
    `Safe merge rolled back: before errors=${before.errorCount} warnings=${before.warningCount}; ` +
      `after errors=${after.errorCount} warnings=${after.warningCount}`,
  );
  process.exit(1);
}

console.log(
  `Safe merge kept: before errors=${before.errorCount} warnings=${before.warningCount}; ` +
    `after errors=${after.errorCount} warnings=${after.warningCount}`,
);
process.exit(0);
