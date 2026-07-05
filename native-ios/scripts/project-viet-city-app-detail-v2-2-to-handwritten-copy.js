#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const defaultSourceDir = path.join(repoRoot, "content-draft", "viet", "city-library", "app-detail-v2-2");
const defaultOutDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");
const cityIDs = ["danang", "hanoi", "hcmc", "hoian", "hue"];

function parseArgs(argv) {
  const args = {
    sourceDir: defaultSourceDir,
    outDir: defaultOutDir,
    requireFinalPass: true,
    dryRun: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--source-dir") {
      args.sourceDir = path.resolve(repoRoot, requiredArg(argv, index, arg));
      index += 1;
    } else if (arg === "--out-dir") {
      args.outDir = path.resolve(repoRoot, requiredArg(argv, index, arg));
      index += 1;
    } else if (arg === "--allow-non-final") {
      args.requireFinalPass = false;
    } else if (arg === "--dry-run") {
      args.dryRun = true;
    } else if (arg === "--help" || arg === "-h") {
      printHelp();
      process.exit(0);
    } else {
      throw new Error(`unknown argument: ${arg}`);
    }
  }
  return args;
}

function requiredArg(argv, index, flag) {
  const value = argv[index + 1];
  if (!value || value.startsWith("--")) {
    throw new Error(`${flag} requires a value`);
  }
  return value;
}

function printHelp() {
  console.log([
    "Usage: node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js [--dry-run] [--allow-non-final]",
    "",
    "Projects first-class v2.2 app-detail source into legacy handwritten-copy JSON for the current native runtime path.",
    "Default behavior refuses to project unless every entry is FINAL_PASS.",
  ].join("\n"));
}

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function normalize(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim();
}

function requiredText(value, label, pageID) {
  const text = normalize(value);
  if (!text) {
    throw new Error(`${pageID} missing ${label}`);
  }
  return text;
}

function phraseIDsFor(entry) {
  return (entry.usefulPhraseCards ?? [])
    .filter((card) => card.status === "mapped" || card.status === "close_match")
    .map((card) => card.phraseId)
    .filter(Boolean)
    .slice(0, 3);
}

function joinedBodies(sections) {
  return sections
    .map((section) => normalize(section?.body))
    .filter(Boolean)
    .join(" ");
}

function projectedSections(entry) {
  const pageID = requiredText(entry.pageID, "pageID", entry.id ?? "(unknown)");
  const appSections = entry.sections ?? [];
  if (appSections.length < 2) {
    throw new Error(`${pageID} needs at least two app-detail sections to project`);
  }
  const phraseIDs = phraseIDsFor(entry);
  if (phraseIDs.length < 2) {
    throw new Error(`${pageID} needs at least two mapped useful phrase cards to project`);
  }

  const sections = [
    {
      id: "at-glance",
      title: requiredText(entry.intro?.heading, "intro.heading", pageID),
      body: requiredText(entry.intro?.body, "intro.body", pageID),
    },
    {
      id: "quick-say",
      title: "Useful Phrases",
      body: "",
      phraseIDs,
    },
    {
      id: "place-brief",
      title: requiredText(appSections[0]?.heading, "sections[0].heading", pageID),
      body: requiredText(appSections[0]?.body, "sections[0].body", pageID),
    },
    {
      id: "use-it-with",
      title: requiredText(appSections[1]?.heading, "sections[1].heading", pageID),
      body: requiredText(appSections[1]?.body, "sections[1].body", pageID),
    },
  ];

  if (appSections[2]) {
    sections.push({
      id: "when-to-use",
      title: requiredText(appSections[2].heading, "sections[2].heading", pageID),
      body: requiredText(appSections[2].body, "sections[2].body", pageID),
    });
  }

  const remainingSections = appSections.slice(3);
  if (remainingSections.length > 0) {
    const lastSection = remainingSections.at(-1);
    sections.push({
      id: "good-to-know",
      title: requiredText(lastSection.heading, "last extra section heading", pageID),
      body: requiredText(joinedBodies(remainingSections), "extra section bodies", pageID),
    });
  }

  return sections;
}

function legacySummary(entry) {
  const pageID = requiredText(entry.pageID, "pageID", entry.id ?? "(unknown)");
  const travelerMoment = requiredText(entry.travelerMoment, "travelerMoment", pageID);
  if (travelerMoment.length >= 130) return travelerMoment;
  return `${travelerMoment} ${requiredText(entry.storySpine, "storySpine", pageID)}`;
}

function projectEntry(entry) {
  const pageID = requiredText(entry.pageID, "pageID", entry.id ?? "(unknown)");
  return {
    pageID,
    summary: legacySummary(entry),
    context: requiredText(entry.travelerMoment, "travelerMoment", pageID),
    tip: requiredText(entry.sections?.at(-1)?.body, "last section body", pageID),
    rationale: requiredText(entry.storySpine, "storySpine", pageID),
    sections: projectedSections(entry),
    sourceMode: "expanded-detail",
  };
}

function loadCitySource(sourceDir, cityID) {
  const filePath = path.join(sourceDir, `${cityID}.json`);
  const source = readJSON(filePath);
  if (!Array.isArray(source.entries)) {
    throw new Error(`${path.relative(repoRoot, filePath)} missing entries array`);
  }
  return source;
}

function projectCity(sourceDir, cityID, requireFinalPass) {
  const source = loadCitySource(sourceDir, cityID);
  const notFinal = source.entries.filter((entry) => entry.status !== "FINAL_PASS");
  if (requireFinalPass && notFinal.length > 0) {
    throw new Error(`${cityID} has ${notFinal.length} entries that are not FINAL_PASS`);
  }

  const entries = source.entries
    .filter((entry) => !requireFinalPass || entry.status === "FINAL_PASS")
    .map(projectEntry);

  return {
    schemaVersion: "speaklocal.viet.city-library.handwritten-copy.v2.2-projection",
    cityID,
    authoringStandard: "speaklocal.place.app-detail.v2.2 projected to legacy runtime compatibility",
    entries,
  };
}

function projectAll(args) {
  const outputs = [];
  for (const cityID of cityIDs) {
    const cityFile = projectCity(args.sourceDir, cityID, args.requireFinalPass);
    outputs.push(cityFile);
    if (!args.dryRun) {
      writeJSON(path.join(args.outDir, `${cityID}.json`), cityFile);
    }
  }
  return {
    cities: outputs.length,
    entries: outputs.reduce((sum, file) => sum + file.entries.length, 0),
    byCity: Object.fromEntries(outputs.map((file) => [file.cityID, file.entries.length])),
  };
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const counts = projectAll(args);
  const mode = args.dryRun ? "dry-run" : "wrote";
  console.log(`${mode} v2.2 app-detail projection: cities=${counts.cities} entries=${counts.entries} byCity=${JSON.stringify(counts.byCity)}`);
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}

module.exports = {
  projectAll,
};
