#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const gateRoot = __dirname;
const chunksDir = path.join(gateRoot, "chunks");
const outputsDir = path.join(gateRoot, "chatgpt-outputs", "voice-cleanup");
const reportsDir = path.join(gateRoot, "reports");
const manifestPath = path.join(gateRoot, "prompts", "voice-cleanup", "manifest.json");

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function sectionIDs(entry) {
  return (entry.sections ?? []).map((section) => section.id).join("|");
}

function phraseIDs(entry) {
  const quickSay = (entry.sections ?? []).find((section) => section.id === "quick-say");
  return Array.isArray(quickSay?.phraseIDs) ? quickSay.phraseIDs.map(String).join("|") : "";
}

function sameKeys(a, b) {
  return Object.keys(a).join("|") === Object.keys(b).join("|");
}

function sorted(values) {
  return [...values].sort();
}

function expectedSession(output) {
  if (!fs.existsSync(manifestPath)) return null;
  const manifest = readJSON(manifestPath);
  return (manifest.sessions ?? []).find((session) => session.sessionID === output.sessionID) ?? null;
}

function replacementCount(output) {
  return output.chunkReplacements.reduce((sum, group) => sum + (Array.isArray(group.replacements) ? group.replacements.length : 0), 0);
}

function validateSelfGate(output, outputPath, expected) {
  if (!output.sessionID) throw new Error(`${outputPath} missing sessionID`);
  const gate = output.selfGate;
  if (!gate || typeof gate !== "object") throw new Error(`${output.sessionID} missing selfGate`);
  if (gate.status !== "pass") throw new Error(`${output.sessionID} selfGate status is ${gate.status ?? "missing"}`);
  if (Array.isArray(gate.remainingRisks) && gate.remainingRisks.length) {
    throw new Error(`${output.sessionID} selfGate remainingRisks is not empty`);
  }
  const returned = replacementCount(output);
  if (expected && gate.expectedReplacementCount !== expected.targetEntryCount) {
    throw new Error(
      `${output.sessionID} selfGate expectedReplacementCount is ${gate.expectedReplacementCount}; expected ${expected.targetEntryCount}`,
    );
  }
  if (gate.returnedReplacementCount !== returned) {
    throw new Error(
      `${output.sessionID} selfGate returnedReplacementCount is ${gate.returnedReplacementCount}; actual ${returned}`,
    );
  }
}

function mergeOutput(outputPath, { allowPartial = false } = {}) {
  const output = readJSON(outputPath);
  if (!output || typeof output !== "object") throw new Error(`${outputPath} is not an object`);
  if (!Array.isArray(output.chunkReplacements)) throw new Error(`${outputPath} missing chunkReplacements[]`);

  const expected = expectedSession(output);
  validateSelfGate(output, outputPath, expected);
  if (expected) {
	  const outputChunks = output.chunkReplacements.map((group) => path.basename(group.chunkFile)).sort().join("|");
	  const expectedChunks = [...expected.chunks].sort().join("|");
	  if (outputChunks !== expectedChunks) {
	    throw new Error(`${output.sessionID} chunk set mismatch: got [${outputChunks}], expected [${expectedChunks}]`);
	  }
	  if (Array.isArray(expected.targetPageIDs)) {
	    const outputPageIDs = sorted(output.chunkReplacements.flatMap((group) => (group.replacements ?? []).map((replacement) => replacement.pageID))).join("|");
	    const expectedPageIDs = sorted(expected.targetPageIDs).join("|");
	    if (outputPageIDs !== expectedPageIDs) {
	      throw new Error(`${output.sessionID} target pageID mismatch: got [${outputPageIDs}], expected [${expectedPageIDs}]`);
	    }
	  }
	}

  const merged = [];
  const chunksToWrite = [];
  for (const group of output.chunkReplacements) {
    if (!group.chunkFile) throw new Error("replacement group missing chunkFile");
    const chunkPath = path.join(chunksDir, path.basename(group.chunkFile));
    const chunk = readJSON(chunkPath);
    const byID = new Map(chunk.entries.map((entry, index) => [entry.pageID, { entry, index }]));
    if (!Array.isArray(group.replacements)) throw new Error(`${group.chunkFile} missing replacements[]`);

    for (const replacement of group.replacements) {
      const pageID = replacement.pageID;
      const next = replacement.entry;
      const existing = byID.get(pageID);
      if (!existing) throw new Error(`${group.chunkFile} has no pageID ${pageID}`);
      if (!next || next.pageID !== pageID) throw new Error(`${group.chunkFile} replacement pageID mismatch for ${pageID}`);
      if (!sameKeys(existing.entry, next)) throw new Error(`${pageID} changed top-level field order/keys`);
      if (sectionIDs(existing.entry) !== sectionIDs(next)) throw new Error(`${pageID} changed section IDs/order`);
      if (phraseIDs(existing.entry) !== phraseIDs(next)) throw new Error(`${pageID} changed phraseIDs`);
      chunk.entries[existing.index] = next;
      merged.push({ chunkFile: path.basename(group.chunkFile), pageID });
    }

    chunksToWrite.push({ chunkPath, chunk });
  }

  const partial = expected && merged.length !== expected.targetEntryCount;
  if (partial && !allowPartial) {
    throw new Error(`${output.sessionID} merged ${merged.length} entries; expected ${expected.targetEntryCount}`);
  }
  if (partial) {
    console.warn(`${output.sessionID} partial merge: ${merged.length} entries; expected ${expected.targetEntryCount}`);
  }

  for (const { chunkPath, chunk } of chunksToWrite) {
    writeJSON(chunkPath, chunk);
  }

  const receiptPath = path.join(reportsDir, "voice_cleanup_merge_receipts.jsonl");
  fs.mkdirSync(reportsDir, { recursive: true });
  fs.appendFileSync(
    receiptPath,
    `${JSON.stringify({
      mergedAt: new Date().toISOString(),
      output: path.relative(gateRoot, outputPath),
      sessionID: output.sessionID,
      partial: Boolean(partial),
      expectedEntryCount: expected?.targetEntryCount ?? null,
      mergedEntryCount: merged.length,
      merged,
    })}\n`,
  );

  return { sessionID: output.sessionID, merged };
}

const allowPartial = process.argv.includes("--allow-partial");
const outputPaths = process.argv.slice(2).filter((arg) => !arg.startsWith("--"));
if (!outputPaths.length) {
  console.error("Usage: node merge-voice-cleanup-output.js <chatgpt-output.json> [...]");
  process.exit(2);
}

for (const outputPath of outputPaths) {
  const absolutePath = path.resolve(outputPath);
  const result = mergeOutput(absolutePath, { allowPartial });
  console.log(`${result.sessionID ?? path.basename(outputPath)} merged ${result.merged.length} entries`);
}

const validation = spawnSync(process.execPath, [path.join(gateRoot, "validate-humanizer-chunks.js")], {
  cwd: path.resolve(gateRoot, "..", "..", "..", ".."),
  stdio: "inherit",
});
process.exit(validation.status ?? 1);
