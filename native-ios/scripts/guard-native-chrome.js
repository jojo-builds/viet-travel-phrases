#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const nativeGlassPath = path.join(repoRoot, "native-ios", "App", "Design", "NativeGlass.swift");
const source = fs.readFileSync(nativeGlassPath, "utf8");
const lightGradientMatch = source.match(
  /guard extendsBehindMenuSectionChrome else \{\s*return \[(?<block>[\s\S]*?)\]\s*\}/
);

if (!lightGradientMatch?.groups?.block) {
  console.error("Native chrome guard failed: could not find the light ChromeSeparationGradient stops.");
  process.exit(1);
}

const lightGradientStops = lightGradientMatch.groups.block;

const blockers = [
  {
    label: "opaque light top chrome color stop",
    pattern: /Color\(\.systemBackground\)(?!\.opacity)/,
  },
  {
    label: "fully opaque light top chrome stop",
    pattern: /Color\(\.systemBackground\)\.opacity\(1\)/,
  },
  {
    label: "nearly opaque page-background top chrome stop",
    pattern: /PhrasePageStyle\.pageBackground\.opacity\(0\.(9[0-9])\)/,
  },
  {
    label: "expanded top readable shield height",
    pattern: /topReadableShieldHeight:[^\n]+topAdminHitTestEnvelopeHeight\)\s*\+\s*\d+/,
  },
];

const failures = blockers.filter(({ pattern, label }) =>
  label === "expanded top readable shield height" ? pattern.test(source) : pattern.test(lightGradientStops)
);

if (failures.length > 0) {
  console.error("Native chrome guard failed: opaque top chrome shield detected.");
  console.error("Keep the light ChromeSeparationGradient soft, matching main/native visual direction.");
  for (const failure of failures) {
    console.error(`- ${failure.label}`);
  }
  process.exit(1);
}

console.log("Native chrome guard passed: no opaque light top chrome shield detected.");
