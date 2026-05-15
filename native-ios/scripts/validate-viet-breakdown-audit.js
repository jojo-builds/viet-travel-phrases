#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const {
  loadBreakdownAuditLedger,
  renderBreakdownAuditExport,
  validateBreakdownAuditCoverage,
} = require("./lib/viet-breakdown-audit");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const exportPath = path.join(repoRoot, "content-draft", "viet", "breakdown-audit", "audit", "rendered-breakdown-audit.json");

function hasFlag(flag) {
  return process.argv.includes(flag);
}

function writeExport(pages, ledger) {
  fs.mkdirSync(path.dirname(exportPath), { recursive: true });
  fs.writeFileSync(exportPath, `${JSON.stringify(renderBreakdownAuditExport({ pages, ledger }), null, 2)}\n`);
}

function main() {
  const authoredPages = JSON.parse(fs.readFileSync(authoredResourcePath, "utf8"));
  const pages = authoredPages.pages ?? [];
  const ledger = loadBreakdownAuditLedger({ repoRoot });
  const report = validateBreakdownAuditCoverage({
    pages,
    ledger,
    requireAllReviewed: hasFlag("--require-all-reviewed"),
  });

  if (hasFlag("--write-export")) {
    writeExport(pages, ledger);
  }

  if (hasFlag("--json")) {
    process.stdout.write(`${JSON.stringify(report, null, 2)}\n`);
  } else {
    process.stdout.write(
      `Breakdown audit: ${report.ok ? "PASS" : "FAIL"}; `
      + `${report.counts.reviewedEntries}/${report.counts.pagesWithBreakdown} reviewed entries`
      + (report.counts.missingReviewedEntries == null ? "" : `; ${report.counts.missingReviewedEntries} missing reviewed entries`)
      + "\n"
    );
    for (const error of report.errors.slice(0, 40)) {
      process.stderr.write(`ERROR: ${error}\n`);
    }
  }

  if (!report.ok) {
    process.exitCode = 1;
  }
}

main();
