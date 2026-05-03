#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const pilotRoot = path.join(repoRoot, "docs", "editorial-exports", "viet-canonical-pages", "chatgpt-pilot-2026-05-03");
const patchPath = path.join(pilotRoot, "SpeakLocal_Vietnam_Editorial_Pilot_Patch_v1.json");
const p0ApprovalPath = path.join(pilotRoot, "approved-imports-TASK-VIET-EDITORIAL-PILOT-IMPORT-001.json");
const supportRoot = path.join(repoRoot, "content-draft", "viet", "editorial-model-support", "TASK-VIET-EDITORIAL-MODEL-SUPPORT-001");
const supportManifestPath = path.join(supportRoot, "manifest.json");
const readinessPath = path.join(supportRoot, "audit", "deferred-readiness.json");
const catalogPath = path.join(nativeRoot, "Resources", "viet-phrase-catalog.json");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");

const importedP0IDs = new Set(["EP-017", "EP-018", "EP-019"]);
const deferredPatchIDs = new Set([
  "EP-001",
  "EP-002",
  "EP-003",
  "EP-004",
  "EP-005",
  "EP-006",
  "EP-007",
  "EP-008",
  "EP-009",
  "EP-010",
  "EP-011",
  "EP-012",
  "EP-013",
  "EP-014",
  "EP-015",
  "EP-016",
  "EP-020",
]);
const readinessValues = new Set([
  "ready_for_jojo_approval",
  "ready_with_title_preserving_import",
  "blocked_title_identity",
  "blocked_research_needed",
  "blocked_unresolved_links",
]);
const requiredSupportSectionIDs = new Set([
  "at-glance",
  "quick-say",
  "breakdown",
  "use-it-with",
  "when-to-use",
  "good-to-know",
  "explore-next",
]);
const wrongTemplatePattern = /landmark quickly|Use this page before you visit|route, ticket, shopping, or help phrases branch from it|Understanding Repair|repair phrase|Watch out/i;
const volatileFactPattern = /\b(VND|current price|ticket price|opening hours|hours are|schedule|award|ranked|#1|number one|best|must-visit|wait times?)\b/i;

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function parseVisibleRows(value) {
  return String(value ?? "")
    .split("|")
    .map((row) => row.trim())
    .filter(Boolean)
    .map((raw) => {
      const match = raw.match(/^(.*?):\s*(.*?)\s*->\s*(.*)$/);
      assert(match, `Unable to parse pilot visible row: ${raw}`);
      return {
        slot: match[1].trim(),
        vietnamese: match[2].trim(),
        english: match[3].trim(),
        raw,
      };
    });
}

function collectSupportRecords(manifest) {
  return (manifest.sourceShards ?? []).flatMap((relativePath) => {
    const shardPath = path.join(supportRoot, relativePath);
    const shard = readJSON(shardPath);
    return (shard.pages ?? []).map((record) => ({
      ...record,
      sourceShard: relativePath,
    }));
  });
}

function pageText(page) {
  return [
    page.title,
    page.englishTitle,
    page.summary,
    ...(page.sections ?? []).flatMap((section) => [
      section.title,
      section.body,
      ...(section.phrases ?? []).flatMap((phrase) => [
        phrase.vietnamese,
        phrase.english,
      ]),
      ...(section.breakdown ?? []).flatMap((token) => [
        token.vietnamese,
        token.english,
      ]),
    ]),
  ].filter(Boolean).join("\n");
}

function main() {
  const patchFile = readJSON(patchPath);
  const p0Approval = readJSON(p0ApprovalPath);
  const supportManifest = readJSON(supportManifestPath);
  const readiness = readJSON(readinessPath);
  const catalog = readJSON(catalogPath);
  const authored = readJSON(authoredPagesPath);

  const patchByID = new Map((patchFile.patches ?? []).map((row) => [row.patch_id, row]));
  const readinessRows = readiness.rows ?? [];
  const readinessByID = new Map(readinessRows.map((row) => [row.patchID, row]));
  const catalogByPhraseID = new Map((catalog.phrases ?? []).map((phrase) => [phrase.id, phrase]));
  const catalogByNormalizedVietnamese = new Map();
  for (const phrase of catalog.phrases ?? []) {
    const key = normalize(phrase.targetText);
    if (!catalogByNormalizedVietnamese.has(key)) catalogByNormalizedVietnamese.set(key, []);
    catalogByNormalizedVietnamese.get(key).push(phrase);
  }
  const authoredByPhraseID = new Map((authored.pages ?? []).map((page) => [page.phraseID, page]));
  const supportRecords = collectSupportRecords(supportManifest);
  const supportByPhraseID = new Map(supportRecords.map((record) => [record.phraseID, record]));
  const supportSourceIDs = new Set((supportManifest.stableFactSources ?? []).map((source) => source.id));
  const approvedP0IDs = new Set((p0Approval.approvals ?? [])
    .filter((row) => row.import_approval === "APPROVED_FOR_IMPORT")
    .map((row) => row.patch_id));

  assert(supportManifest.taskID === "TASK-VIET-EDITORIAL-MODEL-SUPPORT-001", "support manifest taskID mismatch");
  assert(readiness.taskID === "TASK-VIET-EDITORIAL-MODEL-SUPPORT-001", "readiness taskID mismatch");

  for (const patchID of importedP0IDs) {
    assert(approvedP0IDs.has(patchID), `${patchID} missing from P0 approval overlay`);
  }
  for (const patchID of deferredPatchIDs) {
    assert(!approvedP0IDs.has(patchID), `${patchID} is unexpectedly approved in the P0 overlay`);
    const patch = patchByID.get(patchID);
    assert(patch, `${patchID} missing from pilot patch`);
    assert(patch.import_approval === "REVIEW_ONLY", `${patchID} must remain REVIEW_ONLY`);
    assert(readinessByID.has(patchID), `${patchID} missing from deferred readiness artifact`);
  }
  assert(readinessRows.length === deferredPatchIDs.size, `Expected ${deferredPatchIDs.size} readiness rows, found ${readinessRows.length}`);

  const supportCreatedPhraseIDs = new Set(readinessRows.flatMap((row) =>
    (row.visibleRows ?? []).filter((visibleRow) => visibleRow.source === "created-support").map((visibleRow) => visibleRow.phraseID)
  ));

  for (const supportID of supportCreatedPhraseIDs) {
    const record = supportByPhraseID.get(supportID);
    assert(record, `${supportID} referenced as created support but missing source record`);
    const catalogPhrase = catalogByPhraseID.get(supportID);
    assert(catalogPhrase, `${supportID} missing from generated catalog`);
    assert(catalogPhrase.audioStatus === "planned", `${supportID} must have planned audio`);
    const authoredPage = authoredByPhraseID.get(supportID);
    assert(authoredPage, `${supportID} missing authored page`);
    assert(authoredPage.tierRole === "editorial-model-support", `${supportID} has wrong tierRole ${authoredPage.tierRole}`);
    const sectionIDs = new Set((authoredPage.sections ?? []).map((section) => section.id));
    for (const sectionID of requiredSupportSectionIDs) {
      assert(sectionIDs.has(sectionID), `${supportID} missing full support section ${sectionID}`);
    }
    for (const section of authoredPage.sections ?? []) {
      if (section.id !== "breakdown") {
        assert(String(section.body ?? "").length >= 40, `${supportID} section ${section.id} is too short`);
      }
    }
    const breakdown = (authoredPage.sections ?? []).find((section) => section.id === "breakdown")?.breakdown ?? [];
    assert(breakdown.length >= 3, `${supportID} needs meaningful breakdown tokens`);
    assert(!wrongTemplatePattern.test(pageText(authoredPage)), `${supportID} contains wrong-template or internal wording`);
    assert(!volatileFactPattern.test([
      record.context,
      record.atGlance,
      record.quickSay,
      record.useItWith,
      record.whenToUse,
      record.goodToKnow,
      record.exploreNextBody,
    ].filter(Boolean).join("\n")), `${supportID} contains unsupported volatile-fact wording`);
  }

  const createdSupportByNormalized = new Map();
  for (const record of supportRecords) {
    const key = normalize(record.targetText);
    assert(!createdSupportByNormalized.has(key), `duplicate support source Vietnamese: ${record.targetText}`);
    createdSupportByNormalized.set(key, record.phraseID);
  }

  const summary = {
    readyForJojoApproval: 0,
    readyWithTitlePreservingImport: 0,
    blockedTitleIdentity: 0,
    blockedResearchNeeded: 0,
    blockedUnresolvedLinks: 0,
    createdSupportPages: supportRecords.length,
  };

  for (const row of readinessRows) {
    const patch = patchByID.get(row.patchID);
    assert(deferredPatchIDs.has(row.patchID), `${row.patchID} is not a deferred pilot row`);
    assert(readinessValues.has(row.readiness), `${row.patchID} has invalid readiness ${row.readiness}`);
    assert(row.patchPageID === patch.page_id, `${row.patchID} pageID mismatch`);
    assert(row.phraseID === patch.phrase_id, `${row.patchID} phraseID mismatch`);

    const currentPhrase = catalogByPhraseID.get(patch.phrase_id);
    assert(currentPhrase, `${row.patchID} current canonical phrase missing from catalog: ${patch.phrase_id}`);
    assert(
      normalize(currentPhrase.targetText) === normalize(patch.current_vietnamese),
      `${row.patchID} canonical Vietnamese title changed from pilot current value`
    );

    const titleChanges = normalize(patch.current_vietnamese) !== normalize(patch.proposed_vietnamese);
    if (titleChanges) {
      assert(
        row.readiness === "ready_with_title_preserving_import" || row.readiness === "blocked_title_identity",
        `${row.patchID} changes proposed Vietnamese and cannot be ready as-is`
      );
    }

    const parsedVisibleRows = parseVisibleRows(patch.proposed_visible_phrase_rows);
    assert((row.visibleRows ?? []).length === parsedVisibleRows.length, `${row.patchID} readiness visible row count mismatch`);

    for (const parsed of parsedVisibleRows) {
      const artifactRow = (row.visibleRows ?? []).find((candidate) => normalize(candidate.vietnamese) === normalize(parsed.vietnamese));
      assert(artifactRow, `${row.patchID} missing readiness row for ${parsed.vietnamese}`);
      const matches = catalogByNormalizedVietnamese.get(normalize(parsed.vietnamese)) ?? [];
      assert(matches.length === 1, `${row.patchID} visible row ${parsed.vietnamese} resolves to ${matches.length} canonical phrases`);
      const match = matches[0];
      assert(match.id === artifactRow.phraseID, `${row.patchID} ${parsed.vietnamese} artifact phraseID ${artifactRow.phraseID} does not match catalog ${match.id}`);
      assert(authoredByPhraseID.has(match.id), `${row.patchID} ${parsed.vietnamese} resolves to a phrase without an authored page`);
    }

    const unresolved = (row.visibleRows ?? []).filter((visibleRow) => visibleRow.status !== "resolved");
    if (row.readiness.startsWith("ready")) {
      assert(unresolved.length === 0, `${row.patchID} is marked ready but has unresolved visible rows`);
    }

    if (row.patchID === "EP-005" || row.patchID === "EP-007") {
      assert((row.sourceEvidenceIDs ?? []).length > 0, `${row.patchID} needs stable source evidence IDs`);
      for (const sourceID of row.sourceEvidenceIDs ?? []) {
        assert(supportSourceIDs.has(sourceID), `${row.patchID} references missing stable source ${sourceID}`);
      }
    }

    if (row.readiness === "ready_for_jojo_approval") summary.readyForJojoApproval += 1;
    if (row.readiness === "ready_with_title_preserving_import") summary.readyWithTitlePreservingImport += 1;
    if (row.readiness === "blocked_title_identity") summary.blockedTitleIdentity += 1;
    if (row.readiness === "blocked_research_needed") summary.blockedResearchNeeded += 1;
    if (row.readiness === "blocked_unresolved_links") summary.blockedUnresolvedLinks += 1;
  }

  console.log(JSON.stringify({
    status: "pass",
    deferredRowsChecked: readinessRows.length,
    ...summary,
  }, null, 2));
}

main();
