#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const defaultRoot = path.join(repoRoot, "native-ios", "App");
const defaultSourceBackedRoots = [
  defaultRoot,
  path.join(repoRoot, "native-ios", "Resources", "viet-authored-listing-pages.json"),
  path.join(repoRoot, "native-ios", "Resources", "viet-phrase-catalog.json"),
  path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json"),
  path.join(repoRoot, "content-draft", "viet", "city-library", "app-detail-v2-2"),
  path.join(repoRoot, "content-draft", "viet", "search-only-surfacing-v1.json"),
];

const retiredVisiblePhrases = [
  "Quick conversations",
  "Back to Messages",
  "Messages thread",
  "Restart conversation",
  "Conversation complete",
  "Conversation break",
  "Mark Unread",
  "Open thread",
  "Market Hello",
  "Hotel Hello",
  "Respectful Hello",
];

const retiredExactVisibleLabels = [
  "Messages",
  "Unread",
];

const retiredSourceBackedPhrases = [
  ...retiredVisiblePhrases,
  "hotel messages",
];

const visibleLiteralPatterns = [
  /\bText\s*\(\s*"([^"]+)"/g,
  /\bLabel\s*\(\s*"([^"]+)"/g,
  /\bButton\s*\(\s*"([^"]+)"/g,
  /\.accessibilityLabel\s*\(\s*"([^"]+)"/g,
  /\.accessibilityLabel\s*\([^)]*\?\?\s*"([^"]+)"/g,
  /\.navigationTitle\s*\(\s*"([^"]+)"/g,
];

function parseArgs(argv) {
  const args = {
    root: defaultRoot,
  };

  for (let index = 2; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--root") {
      args.root = path.resolve(argv[index + 1] ?? "");
      index += 1;
    } else if (arg === "--help" || arg === "-h") {
      args.help = true;
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }

  return args;
}

function shouldSkipPath(current) {
  const entry = path.basename(current);
  return entry === "artifacts"
    || entry.startsWith("DerivedData")
    || entry === "v22-render-proof-screenshots";
}

function filesWithExtensions(root, extensions) {
  const results = [];
  if (!fs.existsSync(root)) {
    return results;
  }

  function visit(current) {
    if (shouldSkipPath(current)) {
      return;
    }

    const stat = fs.statSync(current);
    if (stat.isDirectory()) {
      for (const entry of fs.readdirSync(current)) {
        visit(path.join(current, entry));
      }
      return;
    }

    if (extensions.some((extension) => current.endsWith(extension))) {
      results.push(current);
    }
  }

  visit(root);
  return results;
}

function swiftFiles(root) {
  return filesWithExtensions(root, [".swift"]);
}

function sourceBackedFiles(root) {
  return filesWithExtensions(root, [".swift", ".json", ".csv"]);
}

function lineNumber(source, index) {
  return source.slice(0, index).split("\n").length;
}

function retiredReason(value) {
  const exactLabel = retiredExactVisibleLabels.find(
    (retired) => value.localeCompare(retired, undefined, { sensitivity: "accent" }) === 0,
  );
  if (exactLabel) {
    return `exact retired label "${exactLabel}"`;
  }

  const phrase = retiredVisiblePhrases.find((retired) => value.includes(retired));
  if (phrase) {
    return `retired phrase "${phrase}"`;
  }

  return null;
}

function sourceBackedRetiredReason(value) {
  const phrase = retiredSourceBackedPhrases.find((retired) => value.includes(retired));
  if (phrase) {
    return `source-backed retired phrase "${phrase}"`;
  }

  return null;
}

function auditSourceBackedCopy(filePath, source) {
  const findings = [];
  for (const phrase of retiredSourceBackedPhrases) {
    let searchIndex = source.indexOf(phrase);

    while (searchIndex !== -1) {
      findings.push({
        filePath,
        line: lineNumber(source, searchIndex),
        value: source.slice(searchIndex, searchIndex + phrase.length),
        reason: `source-backed retired phrase "${phrase}"`,
      });
      searchIndex = source.indexOf(phrase, searchIndex + phrase.length);
    }
  }

  return findings;
}

function auditFile(filePath) {
  const source = fs.readFileSync(filePath, "utf8");
  const findings = [];

  for (const pattern of visibleLiteralPatterns) {
    pattern.lastIndex = 0;
    let match;
    while ((match = pattern.exec(source)) !== null) {
      const value = match[1];
      const reason = retiredReason(value);
      if (!reason) {
        continue;
      }

      findings.push({
        filePath,
        line: lineNumber(source, match.index),
        value,
        reason,
      });
    }
  }

  return findings;
}

function uniqueFindings(findings) {
  const seen = new Set();
  return findings.filter((finding) => {
    const key = `${finding.filePath}:${finding.line}:${finding.value}:${finding.reason}`;
    if (seen.has(key)) {
      return false;
    }
    seen.add(key);
    return true;
  });
}

function auditVisibleProductLanguage(root = null) {
  const roots = root ? [root] : defaultSourceBackedRoots;
  const findings = [];
  const visibleSwiftFiles = new Set();
  const sourceFiles = new Set();

  for (const auditRoot of roots) {
    for (const filePath of swiftFiles(auditRoot)) {
      visibleSwiftFiles.add(filePath);
    }
    for (const filePath of sourceBackedFiles(auditRoot)) {
      sourceFiles.add(filePath);
    }
  }

  for (const filePath of visibleSwiftFiles) {
    findings.push(...auditFile(filePath));
  }

  for (const filePath of sourceFiles) {
    findings.push(...auditSourceBackedCopy(filePath, fs.readFileSync(filePath, "utf8")));
  }

  return uniqueFindings(findings);
}

function main() {
  const args = parseArgs(process.argv);
  if (args.help) {
    console.log("Usage: node native-ios/scripts/audit-visible-product-language.js [--root path]");
    return 0;
  }

  const findings = auditVisibleProductLanguage(args.root);
  if (findings.length === 0) {
    console.log("Visible product language audit passed: no retired visible labels found.");
    return 0;
  }

  console.log(`Visible product language audit failed: ${findings.length} finding(s).`);
  for (const finding of findings) {
    const relative = path.relative(repoRoot, finding.filePath);
    console.log(`${relative}:${finding.line}: ${finding.reason}: ${finding.value}`);
  }
  return 1;
}

if (require.main === module) {
  try {
    process.exitCode = main();
  } catch (error) {
    console.error(error.message);
    process.exitCode = 2;
  }
}

module.exports = {
  auditVisibleProductLanguage,
  retiredReason,
};
