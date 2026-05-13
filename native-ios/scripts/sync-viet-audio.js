#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const resourcesDir = path.join(nativeRoot, "Resources");
const audioDir = path.join(resourcesDir, "Audio");
const manifestPath = path.join(resourcesDir, "viet-audio-manifest.json");
const shouldWrite = process.env.SPEAKLOCAL_SYNC_AUDIO_WRITE === "1";

if (!fs.existsSync(manifestPath)) {
  throw new Error(`Missing native audio manifest: ${manifestPath}`);
}

const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const normalizedManifest = {};
const missingFiles = [];
const invalidEntries = [];

for (const [audioKey, entry] of Object.entries(manifest)) {
  if (!entry.fileName || !entry.text) {
    invalidEntries.push(audioKey);
    continue;
  }

  const audioPath = path.join(audioDir, entry.fileName);
  if (!fs.existsSync(audioPath)) {
    missingFiles.push({ audioKey, fileName: entry.fileName });
  }

  normalizedManifest[audioKey] = {
    fileName: entry.fileName,
    text: entry.text,
  };
}

if (invalidEntries.length > 0 || missingFiles.length > 0) {
  throw new Error(
    [
      "Native audio manifest is not valid.",
      invalidEntries.length > 0 ? `Invalid entries: ${invalidEntries.join(", ")}` : null,
      missingFiles.length > 0
        ? `Missing files: ${JSON.stringify(missingFiles.slice(0, 25), null, 2)}`
        : null,
      missingFiles.length > 25 ? `...and ${missingFiles.length - 25} more` : null,
    ]
      .filter(Boolean)
      .join("\n")
  );
}

if (shouldWrite) {
  fs.writeFileSync(manifestPath, `${JSON.stringify(normalizedManifest, null, 2)}\n`);
}

console.log(
  `Validated ${Object.keys(normalizedManifest).length} native audio manifest entries in ${path.relative(
    path.resolve(nativeRoot, ".."),
    audioDir
  )}`
);
