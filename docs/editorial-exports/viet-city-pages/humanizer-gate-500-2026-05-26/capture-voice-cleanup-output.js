#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const gateRoot = __dirname;
const outputsDir = path.join(gateRoot, "chatgpt-outputs", "voice-cleanup");
const safeMergePath = path.join(gateRoot, "safe-merge-voice-cleanup-output.js");
const repoRoot = path.resolve(gateRoot, "..", "..", "..", "..");

function usage() {
  console.error("Usage: node capture-voice-cleanup-output.js [--from-clipboard | <json-file>] [--no-merge] [--allow-partial]");
  process.exit(2);
}

function readInput(args) {
  if (args.includes("--from-clipboard")) {
    const result = spawnSync("pbpaste", { encoding: "utf8" });
    if (result.status !== 0) throw new Error("pbpaste failed");
    return result.stdout;
  }

  const fileArg = args.find((arg) => !arg.startsWith("--"));
  if (!fileArg) usage();
  return fs.readFileSync(fileArg, "utf8");
}

function stripFence(text) {
  const trimmed = text.trim();
  const match = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
  return match ? match[1].trim() : trimmed;
}

const args = process.argv.slice(2);
const shouldMerge = !args.includes("--no-merge");
const allowPartial = args.includes("--allow-partial");
const raw = stripFence(readInput(args));
const output = JSON.parse(raw);

if (!output.sessionID) throw new Error("ChatGPT output missing sessionID");
if (!Array.isArray(output.chunkReplacements)) throw new Error(`${output.sessionID} missing chunkReplacements[]`);

fs.mkdirSync(outputsDir, { recursive: true });
const outputPath = path.join(outputsDir, `${output.sessionID}.json`);
fs.writeFileSync(outputPath, `${JSON.stringify(output, null, 2)}\n`);

const replacementCount = output.chunkReplacements.reduce((sum, group) => sum + (group.replacements?.length ?? 0), 0);
console.log(JSON.stringify({
  saved: path.relative(repoRoot, outputPath),
  sessionID: output.sessionID,
  replacementCount,
  selfGate: output.selfGate ?? null,
}, null, 2));

if (shouldMerge) {
  const merge = spawnSync(process.execPath, [safeMergePath, ...(allowPartial ? ["--allow-partial"] : []), outputPath], {
    cwd: repoRoot,
    stdio: "inherit",
  });
  process.exit(merge.status ?? 1);
}
