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
      "      Text(\"MESSAGES\")",
      "      Label(\"Back to Messages\", systemImage: \"text.bubble.fill\")",
      "      Text(\"Conversation complete\")",
      "      Color.clear.accessibilityLabel(turn.text ?? \"Conversation break\")",
      "      Color.clear.accessibilityLabel(\"Unread\")",
      "      Label(\"Mark Unread\", systemImage: \"circle.fill\")",
      "      Label(\"Open thread\", systemImage: \"text.bubble.fill\")",
      "      Text(\"Simple ways to start speaking.\")",
      "      let proof = \"Useful before pickup and hotel messages.\"",
      "    }",
      "  }",
      "}",
      "",
    ].join("\n"),
  );
  fs.writeFileSync(
    path.join(fixtureRoot, "GeneratedResource.json"),
    JSON.stringify({
      title: "Practice moments",
      body: "This generated copy should not say Quick conversations or hotel messages.",
    }, null, 2),
  );

  const result = spawnSync(process.execPath, [scriptPath, "--root", fixtureRoot], {
    cwd: path.resolve(__dirname, "../.."),
    encoding: "utf8",
  });

  assert.notStrictEqual(result.status, 0, result.stdout);
  assert.match(result.stdout, /Quick conversations/);
  assert.match(result.stdout, /MESSAGES/);
  assert.match(result.stdout, /Back to Messages/);
  assert.match(result.stdout, /Conversation complete/);
  assert.match(result.stdout, /Conversation break/);
  assert.match(result.stdout, /Unread/);
  assert.match(result.stdout, /Mark Unread/);
  assert.match(result.stdout, /Open thread/);
  assert.match(result.stdout, /hotel messages/);
  assert.match(result.stdout, /GeneratedResource\.json/);
  assert.doesNotMatch(result.stdout, /Simple ways to start speaking/);
});
