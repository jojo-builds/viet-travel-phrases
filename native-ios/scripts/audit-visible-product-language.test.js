#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const scriptPath = path.join(__dirname, "audit-visible-product-language.js");

test("visible product language audit catches retired Messages labels in Swift UI literals", () => {
  const fixtureRoot = fs.mkdtempSync(path.join(os.tmpdir(), "speaklocal-visible-copy-"));
  const swiftPath = path.join(fixtureRoot, "LegacyLabels.swift");

  fs.writeFileSync(
    swiftPath,
    [
      "import SwiftUI",
      "struct LegacyLabels: View {",
      "  var body: some View {",
      "    VStack {",
      "      Text(\"Quick conversations\")",
      "      Label(\"Back to Messages\", systemImage: \"text.bubble.fill\")",
      "      Text(\"Simple ways to start conversations.\")",
      "    }",
      "  }",
      "}",
      "",
    ].join("\n"),
  );

  const result = spawnSync(process.execPath, [scriptPath, "--root", fixtureRoot], {
    cwd: path.resolve(__dirname, "../.."),
    encoding: "utf8",
  });

  assert.notStrictEqual(result.status, 0, result.stdout);
  assert.match(result.stdout, /Quick conversations/);
  assert.match(result.stdout, /Back to Messages/);
  assert.doesNotMatch(result.stdout, /Simple ways to start conversations/);
});

