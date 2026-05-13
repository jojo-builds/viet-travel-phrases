#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..");

const forbiddenPaths = [
  "app",
  "app/package.json",
  "app/app.config.js",
  "app/metro.config.js",
  "app/app",
  "app/components",
  "app/family",
  "app/lib",
];

const existing = forbiddenPaths.filter((relativePath) =>
  fs.existsSync(path.join(repoRoot, relativePath))
);

if (existing.length > 0) {
  console.error("Native-only guard failed. Legacy Expo/React Native app paths exist:");
  for (const relativePath of existing) {
    console.error(`- ${relativePath}`);
  }
  console.error("");
  console.error("SpeakLocal app product work must use native-ios/ only.");
  process.exit(1);
}

console.log("Native-only guard passed: no active Expo/React Native app surface found.");
