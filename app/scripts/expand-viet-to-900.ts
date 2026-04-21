import { mkdir, writeFile } from 'node:fs/promises';
import path from 'node:path';

import {
  assertBoundaryCounts,
  assertScenarioTargets,
  BoundaryCounts,
  buildCleanupGeneratedRow,
  countByScenario,
  countCandidatesByScenario,
  countPriorityMix,
  createIds,
  DraftRow,
  normalizeEnglish,
  normalizeVariantRole,
  prepareCleanupCandidates,
  readCsvRecords,
  readValidScenarioIds,
  selectPremiumCandidatesByQuota,
  serializeCsv,
  translate,
  VIET_SOURCE_PATH,
  CLEANUP_PATH,
} from './viet-expansion-lib';
import { resolveScriptRoots } from './resolve-script-roots';

const { repoRoot: REPO_ROOT } = resolveScriptRoots(import.meta.url);
const AUDIT_DIR = path.join(REPO_ROOT, 'content-draft', 'viet', 'autonomous-900');
const AUDIT_ROWS_PATH = path.join(AUDIT_DIR, 'generated-rows.csv');
const AUDIT_REPORT_PATH = path.join(AUDIT_DIR, 'selection-summary.json');

const startingBoundary: BoundaryCounts = {
  starter: 150,
  premium: 350,
  total: 500,
};

const finalTargets = {
  'polite-basics': { starter: 8, total: 20 },
  'understanding-repair': { starter: 8, total: 55 },
  transport: { starter: 10, total: 93 },
  'hotel-accommodation': { starter: 9, total: 79 },
  'food-drink': { starter: 18, total: 92 },
  'money-numbers-prices': { starter: 9, total: 62 },
  'directions-navigation': { starter: 8, total: 52 },
  'airport-border-arrival': { starter: 8, total: 55 },
  'health-pharmacy': { starter: 8, total: 65 },
  'problems-help': { starter: 6, total: 41 },
  'time-dates-booking': { starter: 7, total: 59 },
  shopping: { starter: 7, total: 37 },
  'phone-internet-power': { starter: 8, total: 47 },
  'bathroom-personal-needs': { starter: 6, total: 14 },
  'emergency-safety': { starter: 9, total: 43 },
  'social-small-talk': { starter: 7, total: 17 },
  'sightseeing-activities': { starter: 6, total: 28 },
  'local-services-everyday-tasks': { starter: 8, total: 41 },
} as const;

const premiumQuotas: Record<string, number> = {
  'polite-basics': 7,
  'understanding-repair': 8,
  transport: 50,
  'hotel-accommodation': 42,
  'food-drink': 52,
  'money-numbers-prices': 25,
  'directions-navigation': 26,
  'airport-border-arrival': 25,
  'health-pharmacy': 42,
  'problems-help': 4,
  'time-dates-booking': 32,
  shopping: 20,
  'phone-internet-power': 17,
  'bathroom-personal-needs': 1,
  'emergency-safety': 13,
  'social-small-talk': 0,
  'sightseeing-activities': 15,
  'local-services-everyday-tasks': 21,
};

async function main() {
  const liveRows = await readCsvRecords(VIET_SOURCE_PATH);
  const cleanupRows = await readCsvRecords(CLEANUP_PATH);
  const validScenarioIds = await readValidScenarioIds();

  const liveSayFirstRows = liveRows.filter(
    (row) => row.status === 'approved' && normalizeVariantRole(row.variant_role) === 'say-first',
  );
  const liveCounts = countByScenario(liveSayFirstRows);
  assertBoundaryCounts(liveCounts.__all, startingBoundary, 'Starting live Viet boundary');

  const existingPhraseIds = new Set(liveRows.map((row) => row.phrase_id));
  const existingFamilyIds = new Set(liveRows.map((row) => row.family_id || row.phrase_id));
  const existingEnglish = new Set(liveSayFirstRows.map((row) => normalizeEnglish(row.english_text)));

  const cleanupCandidates = prepareCleanupCandidates({
    cleanupRows,
    validScenarioIds,
    existingEnglish,
  });

  const availablePremiumCounts = countCandidatesByScenario(
    cleanupCandidates.filter((candidate) => candidate.accessTier === 'premium'),
  );
  if (availablePremiumCounts.__all.premium < 400) {
    throw new Error(`Expected at least 400 non-live premium candidates, found ${availablePremiumCounts.__all.premium}.`);
  }

  const { selected, availableCounts } = selectPremiumCandidatesByQuota({
    cleanupCandidates,
    premiumQuotas,
  });

  if (selected.length !== 400) {
    throw new Error(`Expected to select 400 premium candidates, selected ${selected.length}.`);
  }

  const translationCache = new Map<string, { targetText: string; pronunciation: string }>();
  const generatedRows: DraftRow[] = [];

  for (const candidate of selected) {
    const translated = await translate(candidate.englishText, translationCache);
    const ids = createIds({
      scenarioId: candidate.scenarioId,
      englishText: candidate.englishText,
      idPrefix: 'v900',
      existingPhraseIds,
      existingFamilyIds,
    });

    generatedRows.push(
      buildCleanupGeneratedRow({
        candidate,
        translated,
        ids,
      }),
    );
  }

  const mergedRows = [...liveRows, ...generatedRows];
  const mergedSayFirstCounts = countByScenario(
    mergedRows.filter((row) => row.status === 'approved' && normalizeVariantRole(row.variant_role) === 'say-first'),
  );
  assertScenarioTargets(mergedSayFirstCounts, finalTargets, {
    starter: 150,
    premium: 750,
    total: 900,
  });

  await mkdir(AUDIT_DIR, { recursive: true });
  await writeFile(VIET_SOURCE_PATH, serializeCsv(mergedRows), 'utf8');
  await writeFile(AUDIT_ROWS_PATH, serializeCsv(generatedRows), 'utf8');
  await writeFile(
    AUDIT_REPORT_PATH,
    `${JSON.stringify(
      {
        startingBoundary,
        premiumQuotas,
        availablePremiumCounts,
        availableCounts,
        selectedCounts: countCandidatesByScenario(selected),
        selectedPriorityMix: countPriorityMix(selected),
        finalTargets,
        mergedCounts: mergedSayFirstCounts,
        generatedRowCount: generatedRows.length,
        translatedPhraseCount: translationCache.size,
      },
      null,
      2,
    )}\n`,
    'utf8',
  );

  console.log(
    `Expanded Viet to ${mergedSayFirstCounts.__all.total} visible entries with ${generatedRows.length} new premium rows.`,
  );
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
