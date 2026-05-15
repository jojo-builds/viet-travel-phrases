#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const os = require("os");
const path = require("path");
const test = require("node:test");

const {
  applyReviewedBreakdownOverride,
  loadBreakdownAuditLedger,
  renderBreakdownAuditExport,
  validateBreakdownAuditCoverage,
} = require("./lib/viet-breakdown-audit");

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function tempRepo() {
  return fs.mkdtempSync(path.join(os.tmpdir(), "viet-breakdown-audit-"));
}

function emailPage() {
  return {
    id: "viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me",
    title: "Bạn có thể gửi email cho tôi được không?",
    englishTitle: "Can you email it to me?",
    sections: [
      {
        id: "breakdown",
        title: "Break it down",
        breakdown: [
          { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you" },
          { id: "chunk-2", vietnamese: "gửi email cho", english: "email" },
          { id: "chunk-3", vietnamese: "tôi", english: "I / me" },
          { id: "chunk-4", vietnamese: "được không", english: "is it possible?" },
          {
            id: "chunk-5",
            vietnamese: "Bạn có thể gửi email cho tôi được không?",
            english: "Can you email it to me",
          },
        ],
      },
    ],
  };
}

function reviewedEmailEntry() {
  return {
    pageID: "viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me",
    phraseText: "Bạn có thể gửi email cho tôi được không?",
    englishTitle: "Can you email it to me?",
    reviewStatus: "reviewed",
    visualReview: {
      status: "reviewed",
      method: "simulator",
      launchArguments: [
        "--detail-page",
        "viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me",
        "--detail-scroll",
        "first-breakdown",
      ],
    },
    tokens: [
      { vietnamese: "Bạn", english: "you" },
      { vietnamese: "có thể", english: "can", keepTogetherReason: "fixed modal phrase" },
      { vietnamese: "gửi", english: "send" },
      { vietnamese: "email", english: "email" },
      { vietnamese: "cho", english: "to / for" },
      { vietnamese: "tôi", english: "me" },
      { vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "fixed yes-no question ending" },
      {
        vietnamese: "Bạn có thể gửi email cho tôi được không?",
        english: "Can you email it to me?",
      },
    ],
  };
}

test("loads reviewed ledger entries and applies only app-facing breakdown fields", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/local-services/email-it-to-me.json"),
    reviewedEmailEntry(),
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const page = emailPage();
  const overridden = applyReviewedBreakdownOverride({
    page,
    existingBreakdown: page.sections[0].breakdown,
    ledger,
    audioKeyForToken: (text) => `audio:${text}`,
  });

  assert.deepStrictEqual(
    overridden.map((token) => [token.vietnamese, token.english]),
    [
      ["Bạn", "you"],
      ["có thể", "can"],
      ["gửi", "send"],
      ["email", "email"],
      ["cho", "to / for"],
      ["tôi", "me"],
      ["được không?", "is that possible?"],
      ["Bạn có thể gửi email cho tôi được không?", "Can you email it to me?"],
    ],
  );
  assert.ok(overridden.every((token) => !Object.prototype.hasOwnProperty.call(token, "keepTogetherReason")));
  assert.strictEqual(overridden[0].audioKey, "audio:Bạn");
  assert.strictEqual(overridden.at(-1).audioKey, "audio:Bạn có thể gửi email cho tôi được không?");
});

test("rendered audit export keeps review-only evidence out of app-facing tokens", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/local-services/email-it-to-me.json"),
    reviewedEmailEntry(),
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const exportData = renderBreakdownAuditExport({
    pages: [emailPage()],
    ledger,
  });
  const page = exportData.pages[0];

  assert.deepStrictEqual(
    {
      pages: exportData.summary.pages,
      reviewed: exportData.summary.reviewed,
      visualReviewed: exportData.summary.visualReviewed,
      missing: exportData.summary.missing,
    },
    {
      pages: 1,
      reviewed: 1,
      visualReviewed: 1,
      missing: 0,
    },
  );
  assert.strictEqual(page.visualReview.status, "reviewed");
  assert.ok(page.reviewedBreakdown.some((token) => token.keepTogetherReason === "fixed modal phrase"));
  assert.ok(page.runtimeBreakdown.some((token) => token.vietnamese === "gửi email cho"));
});

test("require-all-reviewed validation rejects missing and unreviewed pages", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/local-services/email-it-to-me.json"),
    { ...reviewedEmailEntry(), reviewStatus: "draft" },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      emailPage(),
      {
        id: "viet-family-airport-baggage",
        title: "Lấy hành lý ở đâu?",
        englishTitle: "Where is baggage claim?",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Lấy", english: "claim / collect" }] }],
      },
    ],
    ledger,
    requireAllReviewed: true,
  });

  assert.ok(report.errors.some((error) => error.includes("reviewStatus must be reviewed")));
  assert.ok(report.errors.some((error) => error.includes("viet-family-airport-baggage missing reviewed ledger entry")));
});

test("validation blocks malformed chunk glosses and unreconstructed phrases", () => {
  const repoRoot = tempRepo();
  const badEntry = reviewedEmailEntry();
  badEntry.tokens = [
    { vietnamese: "Bạn có thể", english: "can you" },
    { vietnamese: "gửi email cho", english: "email", keepTogetherReason: "bad old chunk" },
    { vietnamese: "tôi", english: "me" },
    { vietnamese: "được không", english: "is it possible?", keepTogetherReason: "missing punctuation" },
    { vietnamese: "Bạn có thể gửi email cho tôi được không?", english: "Can you email it to me?" },
  ];
  writeJSON(path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/local-services/bad.json"), badEntry);

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [emailPage()],
    ledger,
    requireAllReviewed: true,
  });

  assert.ok(report.errors.some((error) => error.includes("gửi email cho = email")));
  assert.ok(report.errors.some((error) => error.includes("non-final tokens do not reconstruct phrase")));
});
