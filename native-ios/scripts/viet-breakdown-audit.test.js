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

test("validation permits one-card one-word phrases but blocks word-placeholder glosses", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/acknowledge/co.json"),
    {
      pageID: "viet-acknowledge-co",
      phraseText: "Có",
      englishTitle: "Yes / there is",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [{ vietnamese: "Có", english: "Yes / there is" }],
    },
  );
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/soap.json"),
    {
      pageID: "viet-family-bathroom-soap",
      phraseText: "Có xà phòng không?",
      englishTitle: "Do you have soap?",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Có", english: "have / yes" },
        { vietnamese: "xà", english: "soap word" },
        { vietnamese: "phòng", english: "room" },
        { vietnamese: "không?", english: "yes/no?" },
        { vietnamese: "Có xà phòng không?", english: "Do you have soap?" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-acknowledge-co",
        title: "Có",
        englishTitle: "Yes / there is",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Có", english: "Yes / there is" }] }],
      },
      {
        id: "viet-family-bathroom-soap",
        title: "Có xà phòng không?",
        englishTitle: "Do you have soap?",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Có", english: "have / yes" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes('uses placeholder gloss "soap word"')));
  assert.ok(!report.errors.some((error) => error.includes("viet-acknowledge-co")));
});

test("validation blocks grammar-label question marker glosses", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/question-marker.json"),
    {
      pageID: "viet-family-question-marker",
      phraseText: "Có nước không?",
      englishTitle: "Do you have water?",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Có", english: "have / there is" },
        { vietnamese: "nước", english: "water" },
        { vietnamese: "không?", english: "question marker" },
        { vietnamese: "Có nước không?", english: "Do you have water?" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-question-marker",
        title: "Có nước không?",
        englishTitle: "Do you have water?",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Có", english: "have / there is" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes('uses placeholder gloss "question marker"')));
});

test("validation rejects generic keepTogetherReason labels", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/generic-reason.json"),
    {
      pageID: "viet-family-airport-terminal",
      phraseText: "Nhà ga ở đâu?",
      englishTitle: "Where is the terminal?",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Nhà ga", english: "terminal", keepTogetherReason: "proper name" },
        { vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "fixed place question" },
        { vietnamese: "Nhà ga ở đâu?", english: "Where is the terminal?" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-airport-terminal",
        title: "Nhà ga ở đâu?",
        englishTitle: "Where is the terminal?",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Nhà ga", english: "terminal" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes("generic keepTogetherReason")));
});

test("validation blocks split loanword and country-name compounds", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/chocolate.json"),
    {
      pageID: "viet-family-vietnamese-chocolate",
      phraseText: "sô cô la Việt Nam bao nhiêu tiền?",
      englishTitle: "How much is Vietnamese chocolate?",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "sô", english: "bucket" },
        { vietnamese: "cô", english: "aunt-age woman / respectful female address" },
        { vietnamese: "la", english: "dollar" },
        { vietnamese: "Việt", english: "Vietnamese" },
        { vietnamese: "Nam", english: "south / male" },
        { vietnamese: "bao nhiêu tiền?", english: "how much money", keepTogetherReason: "fixed price question" },
        { vietnamese: "sô cô la Việt Nam bao nhiêu tiền?", english: "How much is Vietnamese chocolate?" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-vietnamese-chocolate",
        title: "sô cô la Việt Nam bao nhiêu tiền?",
        englishTitle: "How much is Vietnamese chocolate?",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "sô", english: "bucket" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes("split sô cô la")));
  assert.ok(report.errors.some((error) => error.includes("split Việt Nam")));
});

test("validation blocks split safety, food, health, and travel compounds", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/compound-classes.json"),
    {
      pageID: "viet-family-compound-classes",
      phraseText: "Tôi cần cảnh sát đậu phộng tiêu chảy bưu điện",
      englishTitle: "Compound split fixture",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Tôi", english: "I / me" },
        { vietnamese: "cần", english: "need" },
        { vietnamese: "cảnh", english: "police / scene" },
        { vietnamese: "sát", english: "close / police" },
        { vietnamese: "đậu", english: "bean / park" },
        { vietnamese: "phộng", english: "room" },
        { vietnamese: "tiêu", english: "pepper / digest" },
        { vietnamese: "chảy", english: "flow / diarrhea" },
        { vietnamese: "bưu", english: "postal" },
        { vietnamese: "điện", english: "electric" },
        { vietnamese: "Tôi cần cảnh sát đậu phộng tiêu chảy bưu điện", english: "Compound split fixture" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-compound-classes",
        title: "Tôi cần cảnh sát đậu phộng tiêu chảy bưu điện",
        englishTitle: "Compound split fixture",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Tôi", english: "I / me" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes("split cảnh sát")));
  assert.ok(report.errors.some((error) => error.includes("split đậu phộng")));
  assert.ok(report.errors.some((error) => error.includes("split tiêu chảy")));
  assert.ok(report.errors.some((error) => error.includes("split bưu điện")));
});

test("validation blocks newly found split compounds even with terminal punctuation", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/latest-compounds.json"),
    {
      pageID: "viet-family-latest-compounds",
      phraseText: "Bắt đầu thế nào? Chúng tôi khó thở",
      englishTitle: "Latest compound fixture",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Bắt", english: "catch / start" },
        { vietnamese: "đầu", english: "head" },
        { vietnamese: "thế", english: "can / able to" },
        { vietnamese: "nào?", english: "which / any" },
        { vietnamese: "Chúng", english: "we" },
        { vietnamese: "tôi", english: "I / me" },
        { vietnamese: "khó", english: "difficult" },
        { vietnamese: "thở", english: "breathe" },
        { vietnamese: "Bắt đầu thế nào? Chúng tôi khó thở", english: "Latest compound fixture" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-latest-compounds",
        title: "Bắt đầu thế nào? Chúng tôi khó thở",
        englishTitle: "Latest compound fixture",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Bắt", english: "catch / start" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes("split bắt đầu")));
  assert.ok(report.errors.some((error) => error.includes("split thế nào")));
  assert.ok(report.errors.some((error) => error.includes("split chúng tôi")));
  assert.ok(report.errors.some((error) => error.includes("split khó thở")));
});

test("validation blocks untranslated self-glosses except approved loanwords and names", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/self-gloss.json"),
    {
      pageID: "viet-family-self-gloss",
      phraseText: "Đủ chưa?",
      englishTitle: "Is it enough yet?",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Đủ", english: "Đủ" },
        { vietnamese: "chưa?", english: "yet?", keepTogetherReason: "fixed question ending" },
        { vietnamese: "Đủ chưa?", english: "Is it enough yet?" },
      ],
    },
  );
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/good/wifi.json"),
    {
      pageID: "viet-family-wifi-loanword",
      phraseText: "Wi-Fi không hoạt động",
      englishTitle: "The Wi-Fi is not working",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Wi-Fi", english: "Wi-Fi" },
        { vietnamese: "không", english: "not" },
        { vietnamese: "hoạt động", english: "work", keepTogetherReason: "compound action verb" },
        { vietnamese: "Wi-Fi không hoạt động", english: "The Wi-Fi is not working" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-self-gloss",
        title: "Đủ chưa?",
        englishTitle: "Is it enough yet?",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Đủ", english: "Đủ" }] }],
      },
      {
        id: "viet-family-wifi-loanword",
        title: "Wi-Fi không hoạt động",
        englishTitle: "The Wi-Fi is not working",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Wi-Fi", english: "Wi-Fi" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes('uses untranslated self-gloss "Đủ = Đủ"')));
  assert.ok(!report.errors.some((error) => error.includes("viet-family-wifi-loanword")));
});

test("validation blocks split high-risk traveler compounds from final manual scan", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/traveler-compounds.json"),
    {
      pageID: "viet-family-traveler-compounds",
      phraseText: "Chuyến tham quan cần hướng dẫn viên du lịch và tin nhắn",
      englishTitle: "Traveler compound fixture",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Chuyến", english: "trip" },
        { vietnamese: "tham", english: "visit / join" },
        { vietnamese: "quan", english: "office / relation" },
        { vietnamese: "cần", english: "need" },
        { vietnamese: "hướng", english: "direction" },
        { vietnamese: "dẫn", english: "guide / lead" },
        { vietnamese: "viên", english: "staff / round item" },
        { vietnamese: "du", english: "travel" },
        { vietnamese: "lịch", english: "calendar / schedule" },
        { vietnamese: "và", english: "and" },
        { vietnamese: "tin", english: "message / information" },
        { vietnamese: "nhắn", english: "text / message" },
        { vietnamese: "Chuyến tham quan cần hướng dẫn viên du lịch và tin nhắn", english: "Traveler compound fixture" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-traveler-compounds",
        title: "Chuyến tham quan cần hướng dẫn viên du lịch và tin nhắn",
        englishTitle: "Traveler compound fixture",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Chuyến", english: "trip" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes("split chuyến tham quan")));
  assert.ok(report.errors.some((error) => error.includes("split hướng dẫn viên du lịch")));
  assert.ok(report.errors.some((error) => error.includes("split tin nhắn")));
});

test("validation blocks split door, store, window, weekday, and ticket compounds", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/door-store-compounds.json"),
    {
      pageID: "viet-family-door-store-compounds",
      phraseText: "Cửa hàng đóng cửa thứ Hai và cần vé vào cửa",
      englishTitle: "Door and store compound fixture",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Cửa", english: "door / counter" },
        { vietnamese: "hàng", english: "goods / row" },
        { vietnamese: "đóng", english: "close" },
        { vietnamese: "cửa", english: "door / counter" },
        { vietnamese: "thứ", english: "thing" },
        { vietnamese: "Hai", english: "two" },
        { vietnamese: "và", english: "and" },
        { vietnamese: "cần", english: "need" },
        { vietnamese: "vé", english: "ticket" },
        { vietnamese: "vào", english: "into / enter" },
        { vietnamese: "cửa", english: "door / counter" },
        { vietnamese: "Cửa hàng đóng cửa thứ Hai và cần vé vào cửa", english: "Door and store compound fixture" },
      ],
    },
  );
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/window-compound.json"),
    {
      pageID: "viet-family-window-compound",
      phraseText: "Hãy đóng cửa sổ lại",
      englishTitle: "Please close the window",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Hãy", english: "please do" },
        { vietnamese: "đóng cửa", english: "close / closed / closing", keepTogetherReason: "wrong overlap" },
        { vietnamese: "sổ", english: "book / notebook" },
        { vietnamese: "lại", english: "again / back" },
        { vietnamese: "Hãy đóng cửa sổ lại", english: "Please close the window" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-door-store-compounds",
        title: "Cửa hàng đóng cửa thứ Hai và cần vé vào cửa",
        englishTitle: "Door and store compound fixture",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Cửa", english: "door / counter" }] }],
      },
      {
        id: "viet-family-window-compound",
        title: "Hãy đóng cửa sổ lại",
        englishTitle: "Please close the window",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Hãy", english: "please do" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes("split cửa hàng")));
  assert.ok(report.errors.some((error) => error.includes("split đóng cửa")));
  assert.ok(report.errors.some((error) => error.includes("split thứ Hai")));
  assert.ok(report.errors.some((error) => error.includes("split vé vào cửa")));
  assert.ok(report.errors.some((error) => error.includes("split cửa sổ")));
});

test("validation blocks split transit, shopping, medicine, and time compounds", () => {
  const repoRoot = tempRepo();
  writeJSON(
    path.join(repoRoot, "content-draft/viet/breakdown-audit/pages/bad/more-compounds.json"),
    {
      pageID: "viet-family-more-compounds",
      phraseText: "Bến xe gần siêu thị có thuốc chống muỗi ngày mai",
      englishTitle: "More compound fixture",
      reviewStatus: "reviewed",
      visualReview: { status: "reviewed" },
      tokens: [
        { vietnamese: "Bến", english: "station / pier" },
        { vietnamese: "xe", english: "vehicle" },
        { vietnamese: "gần", english: "near" },
        { vietnamese: "siêu", english: "super" },
        { vietnamese: "thị", english: "display / market" },
        { vietnamese: "có", english: "have / there is" },
        { vietnamese: "thuốc", english: "medicine" },
        { vietnamese: "chống", english: "anti / against" },
        { vietnamese: "muỗi", english: "mosquito" },
        { vietnamese: "ngày", english: "day" },
        { vietnamese: "mai", english: "tomorrow" },
        { vietnamese: "Bến xe gần siêu thị có thuốc chống muỗi ngày mai", english: "More compound fixture" },
      ],
    },
  );

  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages: [
      {
        id: "viet-family-more-compounds",
        title: "Bến xe gần siêu thị có thuốc chống muỗi ngày mai",
        englishTitle: "More compound fixture",
        sections: [{ id: "breakdown", breakdown: [{ vietnamese: "Bến", english: "station / pier" }] }],
      },
    ],
    requireAllReviewed: true,
    ledger,
  });

  assert.ok(report.errors.some((error) => error.includes("split bến xe")));
  assert.ok(report.errors.some((error) => error.includes("split siêu thị")));
  assert.ok(report.errors.some((error) => error.includes("split thuốc chống muỗi")));
  assert.ok(report.errors.some((error) => error.includes("split ngày mai")));
});
