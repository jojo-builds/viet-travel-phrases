#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const gateRoot = __dirname;
const chunksDir = path.join(gateRoot, "chunks");
const reportsDir = path.join(gateRoot, "reports");
const promptsDir = path.join(gateRoot, "prompts", process.env.PROMPT_SUBDIR ?? "voice-cleanup");
const reportPath = path.join(reportsDir, "humanizer_chunk_validation.json");
const sessionPrefix = process.env.SESSION_PREFIX ?? "voice_cleanup";
const maxTargets = Number(process.env.MAX_TARGETS ?? 0);

const report = JSON.parse(fs.readFileSync(reportPath, "utf8"));

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeText(filePath, text) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, text);
}

function collectTargetIDs(chunkReport) {
  const ids = new Set();
  for (const item of [...chunkReport.errors, ...chunkReport.warnings]) {
    if (!item.id) continue;
    if (/^\d{3}-\d{3}$/.test(item.id)) continue;
    if (item.id.includes("_humanized.json")) continue;
    ids.add(item.id);
  }
  return ids;
}

function groupPairs(items) {
  const groups = [];
  for (let i = 0; i < items.length; i += 2) {
    groups.push(items.slice(i, i + 2));
  }
  return groups;
}

function filterItemsForEntries(items, entries) {
  const ids = new Set(entries.map((entry) => entry.pageID));
  return items.filter((item) => ids.has(item.id) || /^\d{3}-\d{3}$/.test(item.id ?? ""));
}

const chunkTargets = [];
for (const chunkReport of report.chunks) {
  if (!chunkReport.file || !chunkReport.file.endsWith(".json")) continue;

  const targetIDs = collectTargetIDs(chunkReport);
  if (!targetIDs.size) continue;

  const chunk = readJSON(path.join(chunksDir, chunkReport.file));
  const entries = chunk.entries.filter((entry) => targetIDs.has(entry.pageID));
  if (!entries.length) continue;

  chunkTargets.push({
    file: chunkReport.file,
    cityID: chunkReport.cityID,
    range: chunkReport.range,
    errors: chunkReport.errors,
    warnings: chunkReport.warnings,
    entries,
  });
}

const promptTargets = [];
if (maxTargets > 0) {
  for (const target of chunkTargets) {
    for (let index = 0; index < target.entries.length; index += maxTargets) {
      const entries = target.entries.slice(index, index + maxTargets);
      promptTargets.push({
        ...target,
        errors: filterItemsForEntries(target.errors, entries),
        warnings: filterItemsForEntries(target.warnings, entries),
        entries,
      });
    }
  }
} else {
  promptTargets.push(...chunkTargets);
}

const groups = maxTargets > 0 ? promptTargets.map((target) => [target]) : groupPairs(promptTargets);
const manifest = [];

for (const [index, group] of groups.entries()) {
  const sessionID = `${sessionPrefix}_${String(index + 1).padStart(2, "0")}`;
  const promptPath = path.join(promptsDir, `${sessionID}.txt`);
  const payload = {
    sessionID,
    chunks: group.map((target) => ({
      chunkFile: target.file,
      cityID: target.cityID,
      range: target.range,
      errors: target.errors,
      warnings: target.warnings,
      targetEntries: target.entries,
    })),
  };

  const prompt = `You are in the ChatGPT Project "SpeakLocal City Pages v2.2 Copy". Use the project source pack and v2.2 as the source of truth.

Task: repair only the targeted SpeakLocal city-page entries below. Return replacement entry objects that Codex will merge back into the chunk files.

Expected replacement count: ${payload.chunks.reduce((sum, chunk) => sum + chunk.targetEntries.length, 0)}

Hard rules:
- Preserve every replacement entry's exact top-level field names, pageID, section IDs, section order, sourceMode, and phraseIDs arrays.
- Do not add phraseIDs. Do not remove phraseIDs.
- If quick-say has phraseIDs, title stays "Useful Phrases" and body stays empty.
- If quick-say has no phraseIDs, do not use "Useful Phrases" and do not default to generic name cards like "Name To Recognize", "Local Name", "Venue Name", "Street Name", "Dish Name", or "Route Name".
- Remove command headings starting with Use/Keep/Choose/Ask/Confirm/Leave/Start/Let/Check.
- Remove visible QA/status language such as current details, fresh check, details can shift, needs checking, can change, can vary, verification, review, source, schema, database, entry, page, or production-ready.
- Do not use replacement crutches: works best, best when, best as, useful because, should feel, should be, gives [city] a, worth knowing, worth saving, matters when, fits when, safe frame, stable role, source detail, or verified.
- Keep summary/context/tip/rationale and every non-empty section body under 45 words.
- Keep summary at least 130 characters.
- Keep the place-specific substance. Cleaner prose cannot be achieved by deleting the actual place.
- Write like a well-traveled friend quietly pointing out how this place fits into the day. Short, observed, adult, calm. No article voice.
- Return every targeted replacement entry. Do not skip entries that look "already okay"; if an entry is in the payload, return a complete replacement for it.

Output format:
Return one fenced json block only. It must be valid JSON:
{
  "sessionID": "${sessionID}",
  "chunkReplacements": [
    {
      "chunkFile": "...",
      "cityID": "...",
      "range": "...",
      "replacements": [
        { "pageID": "...", "entry": { ...complete replacement entry object... } }
      ]
    }
  ],
  "selfGate": {
    "status": "pass" or "revise",
    "expectedReplacementCount": ${payload.chunks.reduce((sum, chunk) => sum + chunk.targetEntries.length, 0)},
    "returnedReplacementCount": ${payload.chunks.reduce((sum, chunk) => sum + chunk.targetEntries.length, 0)},
    "notes": "...",
    "remainingRisks": []
  }
}

Set selfGate.status to "pass" only if you returned every targeted replacement entry, kept the place-specific substance, removed every listed validator issue, kept the copy natural on an iPhone, and see no remaining risks. If any targeted item still feels thin, mechanical, over-trimmed, or uncertain, set status to "revise" and explain it in remainingRisks.

Do not return prose outside the fenced json block.

Target payload:
\`\`\`json
${JSON.stringify(payload, null, 2)}
\`\`\`
`;

  writeText(promptPath, prompt);
	  manifest.push({
	    sessionID,
	    promptPath: path.relative(gateRoot, promptPath),
	    chunks: group.map((target) => target.file),
	    targetPageIDs: group.flatMap((target) => target.entries.map((entry) => entry.pageID)),
	    targetEntryCount: group.reduce((sum, target) => sum + target.entries.length, 0),
	    errorCount: group.reduce((sum, target) => sum + target.errors.length, 0),
	    warningCount: group.reduce((sum, target) => sum + target.warnings.length, 0),
	  });
}

writeText(
  path.join(promptsDir, "manifest.json"),
  `${JSON.stringify({ generatedAt: new Date().toISOString(), sessions: manifest }, null, 2)}\n`,
);

console.log(`Wrote ${manifest.length} voice cleanup prompts to ${path.relative(process.cwd(), promptsDir)}`);
for (const item of manifest) {
  console.log(`${item.sessionID}: ${item.chunks.join(", ")} targets=${item.targetEntryCount} errors=${item.errorCount} warnings=${item.warningCount}`);
}
