#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const familyRoot = path.resolve(__dirname, "../..");
const resourcePath = path.join(familyRoot, "native-ios/Resources/viet-authored-listing-pages.json");
const outputDir = path.join(familyRoot, "docs/content-audits/phrase-copy-production-gate-2026-06-08");
const ledgerPath = path.join(outputDir, "anti-thinning-ledger.jsonl");
const summaryPath = path.join(outputDir, "phrase-source-cleanup-summary.json");

const sourceRoots = [
  "content-draft/viet/canonical-pages/tier-one",
  "content-draft/viet/canonical-pages/catalog-promoted",
];

const phraseRoles = new Set(["tier1", "child", "catalog-promoted"]);

function walkJsonFiles(dir, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const name of fs.readdirSync(dir)) {
    const filePath = path.join(dir, name);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) walkJsonFiles(filePath, out);
    else if (name.endsWith(".json")) out.push(filePath);
  }
  return out;
}

function wordCount(text) {
  return String(text ?? "").split(/\s+/).filter(Boolean).length;
}

function residuePattern(text) {
  return /(as your first sentence|Pause after the phrase|Pause naturally after the phrase|If speech still does not land|reply often comes as|^Expect .+ in [^.]+\. Say .+ once|Listen for |Keep your voice calm and let the short phrase|visible while you speak so|visible when the exact detail matters|Use the rows below|use the next rows if|keeping one travel detail clear|move the exchange forward|real [a-z -]+ exchange|detail you need resolved|likely reply is|Use the complete line|Go next to phrases|makes the next step easier to answer|It fits .*especially when the next step is|The phrase is doing one job|make the task visible with|is useful when the map, sign, or building layout|is for asking permission before you act|confirmation phrase for moments when you want to avoid guessing|friendly way to ask for help with|helps you decide whether the next move is worth the time|It names .+ in a compact way|\bUse the full phrase before adding details\.\s+Use the full phrase before adding details\b|\bKeep\s+[^.]+?\s+together as one sentence before adding details\.\s+Keep\b|\bis the line for\b|\bStart with\s+[^.]+,\s+then pause\b|\bThis is for when\b|\bThe reply may be a short reply\b|\bSay\s+[^.]+?\s+once, then watch for the reply\b|\bSay it once, then watch for the reply before adding more words\b|\bExpect a confirmation, a handoff, a price, or follow-up question\b|\bSay\s+[^.]+?\s+when you need\s+["“][^"”]+["”]|\bSay\s+[^.]+?\s+for\s+["“][^"”]+["”]\.\s+Say\b|\bSay\s+[^.]+?\s+for\s+["“][^"”]+["”]|\bUse\s+[^.]+?\s+for\s+["“][^"”]+["”]\.\s+(Say|Keep|Point|$)|\bUse\s+[^.]+?\s+for\s+["“][^"”]+["”]|Use it when\s+["“][^"”]+["”]\s+is the next thing you need to say|Try these next to confirm, answer, or continue after|quick money check|keeps the exchange focused|answer can be a number|pilot row|canonical title)/i.test(String(text ?? ""));
}

function phraseCount(section) {
  return Array.isArray(section?.phrases) ? section.phrases.length : 0;
}

function breakdownCount(section) {
  return Array.isArray(section?.breakdown) ? section.breakdown.length : 0;
}

function travelerValue(sectionID, before, after) {
  const preserved = [];
  if (/map|address|destination|route|street|pier|schedule|ticket/i.test(`${before} ${after}`)) preserved.push("kept navigation or schedule cue");
  if (/booking|room|hotel|policy|document|file|print/i.test(`${before} ${after}`)) preserved.push("kept booking/document action");
  if (/passport|visa|baggage|pickup|flight/i.test(`${before} ${after}`)) preserved.push("kept airport handoff cue");
  if (/menu|food|allergy|medicine|symptom|safe|health/i.test(`${before} ${after}`)) preserved.push("kept food/health safety cue");
  if (/reply|answer|yes\/no|point|gesture|follow-up|show|write/i.test(`${before} ${after}`)) preserved.push("kept expected reply or repair cue");
  return preserved.length ? preserved.join("; ") : `kept ${sectionID} traveler instruction while removing template scaffolding`;
}

function shouldUpdateBody(sourceBody, renderedBody) {
  if (!sourceBody || !renderedBody || sourceBody === renderedBody) return false;
  if (residuePattern(sourceBody)) return true;
  return wordCount(sourceBody) > 40 && wordCount(renderedBody) <= 40;
}

function main() {
  const resource = JSON.parse(fs.readFileSync(resourcePath, "utf8"));
  const renderedByID = new Map((resource.pages ?? [])
    .filter((page) => phraseRoles.has(page.tierRole))
    .map((page) => [page.id, page]));

  fs.mkdirSync(outputDir, { recursive: true });
  const ledger = [];
  const changedFiles = [];
  let sourcePagesChecked = 0;
  let sectionsChecked = 0;
  let sectionsUpdated = 0;

  for (const root of sourceRoots) {
    for (const filePath of walkJsonFiles(path.join(familyRoot, root))) {
      const raw = fs.readFileSync(filePath, "utf8");
      const page = JSON.parse(raw);
      const rendered = renderedByID.get(page.id);
      if (!rendered) continue;
      sourcePagesChecked += 1;

      const renderedSections = new Map((rendered.sections ?? []).map((section) => [section.id, section]));
      let changed = false;

      for (const section of page.sections ?? []) {
        sectionsChecked += 1;
        const renderedSection = renderedSections.get(section.id);
        if (!renderedSection) continue;

        const before = String(section.body ?? "");
        const after = String(renderedSection.body ?? "");
        if (!shouldUpdateBody(before, after)) continue;

        section.body = after;
        changed = true;
        sectionsUpdated += 1;
        ledger.push({
          pageID: page.id,
          phraseID: page.phraseID ?? null,
          tierRole: rendered.tierRole,
          sourcePath: path.relative(familyRoot, filePath),
          sectionID: section.id,
          sectionTitle: section.title ?? "",
          before,
          after,
          beforeWordCount: wordCount(before),
          afterWordCount: wordCount(after),
          preservedPhraseCards: phraseCount(section),
          preservedBreakdownRows: breakdownCount(section),
          concreteTravelerValueImproved: travelerValue(section.id, before, after),
          reason: residuePattern(before) ? "removed_formula_residue" : "tightened_overlong_visible_body",
        });
      }

      if (!changed) continue;
      fs.writeFileSync(filePath, `${JSON.stringify(page, null, 2)}\n`);
      changedFiles.push(path.relative(familyRoot, filePath));
    }
  }

  fs.writeFileSync(ledgerPath, `${ledger.map((entry) => JSON.stringify(entry)).join("\n")}\n`);
  const summary = {
    sourcePagesChecked,
    sectionsChecked,
    sectionsUpdated,
    changedFiles: changedFiles.length,
    ledgerPath: path.relative(familyRoot, ledgerPath),
    changedFilesSample: changedFiles.slice(0, 20),
  };
  fs.writeFileSync(summaryPath, `${JSON.stringify(summary, null, 2)}\n`);
  console.log(JSON.stringify(summary, null, 2));
}

main();
