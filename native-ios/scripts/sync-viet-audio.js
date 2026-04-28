const fs = require("fs");
const path = require("path");

const sourceAudioDir = path.resolve(__dirname, "../../app/assets/audio");
const sourceManifestPath = path.join(sourceAudioDir, "manifest.json");
const resourcesDir = path.resolve(__dirname, "../Resources");
const outputAudioDir = path.join(resourcesDir, "Audio");
const outputManifestPath = path.join(resourcesDir, "viet-audio-manifest.json");

if (!fs.existsSync(sourceManifestPath)) {
  throw new Error(`Missing source audio manifest: ${sourceManifestPath}`);
}

const manifest = JSON.parse(fs.readFileSync(sourceManifestPath, "utf8"));
const sortedEntries = Object.entries(manifest).sort(([leftKey], [rightKey]) =>
  leftKey.localeCompare(rightKey)
);
const nativeManifest = {};

fs.mkdirSync(outputAudioDir, { recursive: true });

for (const [audioKey, entry] of sortedEntries) {
  if (!entry.fileName || !entry.text) {
    throw new Error(`Invalid manifest entry for ${audioKey}`);
  }

  const sourcePath = path.join(sourceAudioDir, entry.fileName);
  const outputPath = path.join(outputAudioDir, entry.fileName);

  if (!fs.existsSync(sourcePath)) {
    throw new Error(`Missing source audio file for ${audioKey}: ${sourcePath}`);
  }

  fs.copyFileSync(sourcePath, outputPath);
  nativeManifest[audioKey] = {
    fileName: entry.fileName,
    text: entry.text,
  };
}

fs.writeFileSync(
  outputManifestPath,
  `${JSON.stringify(nativeManifest, null, 2)}\n`
);

console.log(`Synced ${sortedEntries.length} audio files into ${outputAudioDir}`);
