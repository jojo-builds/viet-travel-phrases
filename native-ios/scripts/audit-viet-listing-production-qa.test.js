#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const repoRoot = path.resolve(__dirname, "../..");
const auditPath = path.join(__dirname, "audit-viet-listing-production-qa.js");
const summaryPath = path.join(
  repoRoot,
  "docs",
  "content-audits",
  "viet-listing-production-qa-001",
  "summary.json",
);

test("--check validates production QA without rewriting the summary artifact", () => {
  const before = fs.readFileSync(summaryPath, "utf8");
  let after = before;

  try {
    const result = spawnSync(process.execPath, [auditPath, "--check"], {
      cwd: repoRoot,
      encoding: "utf8",
    });

    after = fs.readFileSync(summaryPath, "utf8");
    assert.strictEqual(result.status, 0, result.stderr || result.stdout);
    assert.strictEqual(after, before);
  } finally {
    if (after !== before) {
      fs.writeFileSync(summaryPath, before);
    }
  }
});
