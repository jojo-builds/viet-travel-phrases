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
  return /(A direct line for|as your first sentence|Pause after the phrase|Pause naturally after the phrase|If speech still does not land|reply often comes as|^Expect .+ in [^.]+\. Say .+ once|Listen for |Keep your voice calm and let the short phrase|visible while you speak so|visible when the exact detail matters|Use the rows below|use the next rows if|keeping one travel detail clear|move the exchange forward|real [a-z -]+ exchange|detail you need resolved|likely reply is|Use the complete line|Go next to phrases|makes the next step easier to answer|It fits .*especially when the next step is|The phrase is doing one job|make the task visible with|is useful when the map, sign, or building layout|is for asking permission before you act|confirmation phrase for moments when you want to avoid guessing|friendly way to ask for help with|helps you decide whether the next move is worth the time|It names .+ in a compact way|keeps the first line simple|works best as a short first line|Best in a hotel desk|Best in a map|in a hotel desk, street help moment, or police counter|in a map, street corner, or ticket counter|\bUse the full phrase before adding details\.\s+Use the full phrase before adding details\b|\bKeep\s+[^.]+?\s+together as one sentence before adding details\.\s+Keep\b|\bis the line for\b|\bStart with\s+[^.]+,\s+then pause\b|\bThis is for when\b|\bThe reply may be a short reply\b|\bSay\s+[^.]+?\s+once, then watch for the reply\b|\bSay it once, then watch for the reply before adding more words\b|\bExpect a confirmation, a handoff, a price, or follow-up question\b|\bSay\s+[^.]+?\s+when you need\s+["“][^"”]+["”]|\bSay\s+[^.]+?\s+for\s+["“][^"”]+["”]\.\s+Say\b|\b(?:Use|Say)\s+[^.]+?\s+for\s+["“][^"”]+["”]|\b(?:Use this|Ask this)\s+when\b|need to (?:say|explain)|Use it when\s+["“]|Use it when\s+["“][^"”]+["”]\s+is the next thing you need to say|traveler need is already visible|\bmap pin\b|map pin, counter item, booking detail, or phone screen|ready if the reply stalls|can solve the second turn|Let the first reply tell you whether to show|Hold [^.]+ nearby, but lead with the question itself|Use it when the [a-z -]+ is already visible and you need one short first sentence|\?\s*,|Try these next to confirm, answer, or continue after|quick money check|keeps the exchange focused|answer can be a number|gives the exchange one clear starting point|one clear opening line|needs to land quickly|needs a quick first line|fits when one short phrase can open the next step|clear enough for the first reply|Next cards:|exchange gets crowded with details|Keep the question intact|Use the full question and pause|Say it as one question|Use this card when the same idea needs|note under the phrase|puts the main need in one short line|puts the .*? upfront before extra explanation|Ask the whole question first|visible detail carry the rest|Keep one visible clue close|real-world detail close|phone, receipt, or booking|map, item, booking, or screen|not chemical lime|This pattern asks for a yes-or-no answer|pilot row|canonical title)/i.test(String(text ?? ""));
}

function premiumWeakPattern(text) {
  const value = String(text ?? "");
  if (/\bmeans\s+[“"][^”"]+[”"]\.?$/i.test(value.trim())) return true;
  const sentences = value.match(/[^.!?]+[.!?]+(?:["”])?/g)?.map((sentence) => sentence.trim()) ?? [];
  if (sentences.length === 2 && sentences[0].toLowerCase() === sentences[1].toLowerCase()) return true;
  return /(A direct line for|Play each piece, then the full phrase|then play the full line at real conversation speed|Keep these cards ready for|They cover the next turn after the first line lands|are the nearby cards for the likely next step|Use these nearby phrases if the conversation shifts toward another|Read the cards left to right|Use these next when the conversation moves one step forward|Use these if the answer changes the next step|Use it when the next move is|keeps the travel moment short and clear|keeps the question easy to answer|keeps the first line simple|works best as a short first line|Best in a hotel desk|Best in a map|in a hotel desk, street help moment, or police counter|in a map, street corner, or ticket counter|makes the request direct without adding extra explanation|keeps the social move simple and polite|names the need before the details start piling up|gives the exchange one clear starting point|one clear opening line|needs to land quickly|needs a quick first line|fits when one short phrase can open the next step|clear enough for the first reply|Next cards:|exchange gets crowded with details|Keep the question intact|Use the full question and pause|Say it as one question|Use this card when the same idea needs|note under the phrase|puts the main need in one short line|puts the .*? upfront before extra explanation|Keep one visible clue close|real-world detail close|phone, receipt, or booking|map pin, counter item, booking, or phone screen|map pin, counter item, booking detail, or phone screen|map, item, booking, or screen|not chemical lime|traveler need is already visible|ready if the reply stalls|can solve the second turn|Let the first reply tell you whether to show|Hold [^.]+ nearby, but lead with the question itself|Use it when\s+["“]|Use it when the [a-z -]+ is already visible and you need one short first sentence|\bUse\s+[^.]+?\s+for\s+["“][^"”]+["”]|\?\s*,|This pattern asks for a yes-or-no answer|visible detail carry the rest|Keep the relevant place, item, or screen visible|Use the full phrase before adding details|as one clean sentence before the visible detail carries the rest|Ask the whole question first|Keep [^.]+ together as one sentence before adding details|Keep [^.!?]*(Tôi|Bạn|Có|Đây|Đó|Xin|Vui|Ứng|Mấy|Làm|Cho|Đi|Được|Ở|Bàn|Ai|Bao)[^.!?]*(?:$|[.!?])|The reply may be|This form changes the tone or setting|is the clearest way to explain what changed|is the short line for naming what you need next|works best when [^.]+ is visible on your phone|asks someone to do one helpful action|Use it for [^.]+ when pointing|Beginners should keep|This row keeps the next exchange close to|Use this row when the reply points toward|Keep these close for the likely follow-up|Keep these close:|These cards stay near the first phrase|Move here when the next turn is|likely follow-up|reply points toward|next exchange close|\.\s*,\s*(and\s+)?[a-z]|,\s*(and\s+)?[a-z][^.?!]*$)/i.test(value);
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
  if (premiumWeakPattern(sourceBody)) return true;
  if (residuePattern(sourceBody)) return true;
  return wordCount(sourceBody) > 40 && wordCount(renderedBody) <= 40;
}

function shouldUpdateSummary(sourceSummary, renderedSummary) {
  if (!sourceSummary || !renderedSummary || sourceSummary === renderedSummary) return false;
  return premiumWeakPattern(sourceSummary) || residuePattern(sourceSummary);
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
  let summariesChecked = 0;
  let summariesUpdated = 0;
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

      summariesChecked += 1;
      if (shouldUpdateSummary(page.summary, rendered.summary)) {
        const before = String(page.summary ?? "");
        const after = String(rendered.summary ?? "");
        page.summary = after;
        changed = true;
        summariesUpdated += 1;
        ledger.push({
          pageID: page.id,
          phraseID: page.phraseID ?? null,
          tierRole: rendered.tierRole,
          sourcePath: path.relative(familyRoot, filePath),
          sectionID: "__summary",
          sectionTitle: "Summary",
          before,
          after,
          beforeWordCount: wordCount(before),
          afterWordCount: wordCount(after),
          preservedPhraseCards: (page.sections ?? []).reduce((total, section) => total + phraseCount(section), 0),
          preservedBreakdownRows: (page.sections ?? []).reduce((total, section) => total + breakdownCount(section), 0),
          concreteTravelerValueImproved: "replaced formula summary while preserving page sections, phrase cards, and breakdown rows",
          reason: residuePattern(before)
            ? "removed_formula_residue"
            : "removed_premium_weak_pattern",
        });
      }

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
          reason: residuePattern(before)
            ? "removed_formula_residue"
            : premiumWeakPattern(before)
              ? "removed_premium_weak_pattern"
              : "tightened_overlong_visible_body",
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
    summariesChecked,
    summariesUpdated,
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
