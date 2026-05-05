import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const packetDir = path.dirname(new URL(import.meta.url).pathname);
const outputPath = path.join(packetDir, "speaklocal-viet-hero-image-production-tracker-2026-05-05.xlsx");

const sheetFiles = [
  ["README", "manifest.csv"],
  ["Asset Tracker", "asset_tracker.csv"],
  ["Image Queue", "image_queue.csv"],
  ["Standards", "standards.csv"],
  ["Prompt Recipes", "prompt_recipes.csv"],
  ["QA Gates", "qa_gates.csv"],
];

function parseCsv(text) {
  const rows = [];
  let current = [];
  let value = "";
  let inQuotes = false;

  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    const next = text[index + 1];
    if (inQuotes && char === '"' && next === '"') {
      value += '"';
      index += 1;
    } else if (char === '"') {
      inQuotes = !inQuotes;
    } else if (!inQuotes && char === ",") {
      current.push(value);
      value = "";
    } else if (!inQuotes && (char === "\n" || char === "\r")) {
      if (char === "\r" && next === "\n") {
        index += 1;
      }
      current.push(value);
      if (current.some((cell) => cell.length > 0)) {
        rows.push(current);
      }
      current = [];
      value = "";
    } else {
      value += char;
    }
  }

  if (value.length || current.length) {
    current.push(value);
    rows.push(current);
  }

  return rows;
}

function colName(index) {
  let name = "";
  let value = index + 1;
  while (value > 0) {
    const remainder = (value - 1) % 26;
    name = String.fromCharCode(65 + remainder) + name;
    value = Math.floor((value - 1) / 26);
  }
  return name;
}

function fitValue(value) {
  if (value == null) return "";
  if (typeof value !== "string") return value;
  if (value.length > 480) {
    return `${value.slice(0, 477)}...`;
  }
  return value;
}

const workbook = Workbook.create();

for (const [sheetName, fileName] of sheetFiles) {
  const sheet = workbook.worksheets.add(sheetName);
  let rows = parseCsv(await fs.readFile(path.join(packetDir, fileName), "utf8"));

  if (sheetName === "README") {
    rows = [
      ["SpeakLocal Viet Hero Image Production Tracker", ""],
      ["Purpose", "Track which hero images exist, what still needs creation, and what crop/proof rules must pass before shipping."],
      ["Google Sheet tabs", "Asset Tracker, Image Queue, Standards, Prompt Recipes, QA Gates"],
      ["Important crop rule", "The iOS hero is a shallow masthead crop. A standalone image is not approved until the phone/simulator crop looks right."],
      [],
      ...rows,
    ];
  }

  const safeRows = rows.map((row) => row.map(fitValue));
  const rowCount = Math.max(safeRows.length, 1);
  const colCount = Math.max(...safeRows.map((row) => row.length), 1);
  const endCell = `${colName(colCount - 1)}${rowCount}`;
  sheet.getRange(`A1:${endCell}`).values = safeRows.map((row) => {
    const padded = [...row];
    while (padded.length < colCount) padded.push("");
    return padded;
  });
}

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);
console.log(outputPath);
