import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';

import { parseCsvRows } from './csv';
import { resolveScriptRoots } from './resolve-script-roots';

type DraftRow = Record<string, string>;

type BoundaryCounts = {
  starter: number;
  premium: number;
  total: number;
};

type LaneManifest = {
  laneId: string;
  variant: string;
  title: string;
  phase: string;
  status: 'prepared-not-live' | 'promoted-live';
  summary: string;
  whyFirst: string;
  priceTarget: string;
  currentLiveBoundary: BoundaryCounts;
  preparedDelta: BoundaryCounts & {
    rawPhraseRows: number;
  };
  preparedBoundaryIfPromoted: BoundaryCounts;
  sourceCsv: string;
  scenarios: Array<{
    scenarioId: string;
    newPremiumFamilies: number;
    whyIncluded: string;
  }>;
  nextRecommendedLaneId: string;
  notes?: string[];
};

const { repoRoot: REPO_ROOT } = resolveScriptRoots(import.meta.url);
const VIET_DRAFT_ROOT = path.join(REPO_ROOT, 'content-draft', 'viet');
const LIVE_SOURCE_PATH = path.join(VIET_DRAFT_ROOT, 'phrase-source.csv');
const SCENARIO_PLAN_PATH = path.join(VIET_DRAFT_ROOT, 'scenario-plan.json');
const PREMIUM_EXPANSION_ROOT = path.join(VIET_DRAFT_ROOT, 'premium-expansion');

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) {
    throw new Error(message);
  }
}

async function main() {
  const liveRows = await readCsvFile(LIVE_SOURCE_PATH);
  const liveBoundary = computeVisibleBoundary(liveRows);
  const scenarioPlan = JSON.parse(await readFile(SCENARIO_PLAN_PATH, 'utf8')) as {
    scenarios: Array<{ id: string }>;
  };
  const validScenarioIds = new Set(scenarioPlan.scenarios.map((scenario) => scenario.id));
  const livePhraseIds = new Set(liveRows.map((row) => row.phrase_id.trim()));
  const liveFamilyIds = new Set(
    liveRows
      .map((row) => normalizeFamilyId(row))
      .filter(Boolean),
  );

  const manifestFiles = (await readdir(PREMIUM_EXPANSION_ROOT))
    .filter((entry) => entry.endsWith('.manifest.json'))
    .sort();

  assert(manifestFiles.length > 0, 'No premium expansion lane manifests were found.');

  for (const manifestFile of manifestFiles) {
    const manifestPath = path.join(PREMIUM_EXPANSION_ROOT, manifestFile);
    const manifest = JSON.parse(await readFile(manifestPath, 'utf8')) as LaneManifest;
    validateManifestShape(manifest);
    if (manifest.status === 'prepared-not-live') {
      assert(
        boundariesMatch(manifest.currentLiveBoundary, liveBoundary),
        `${manifest.laneId} expected live boundary ${formatBoundary(manifest.currentLiveBoundary)} but found ${formatBoundary(liveBoundary)}.`,
      );
    } else {
      assert(
        boundaryAtLeast(liveBoundary, manifest.currentLiveBoundary),
        `${manifest.laneId} recorded historical live boundary ${formatBoundary(
          manifest.currentLiveBoundary,
        )}, which is greater than the current live boundary ${formatBoundary(liveBoundary)}.`,
      );
    }

    const laneRows = await readCsvFile(path.join(PREMIUM_EXPANSION_ROOT, manifest.sourceCsv));
    validateLaneRows({
      manifest,
      rows: laneRows,
      liveBoundary,
      livePhraseIds,
      liveFamilyIds,
      validScenarioIds,
    });
  }

  console.log('Prepared premium expansion validation passed.');
}

function validateManifestShape(manifest: LaneManifest) {
  assert(manifest.laneId.trim().length > 0, 'Lane manifest is missing laneId.');
  assert(manifest.variant === 'viet', `${manifest.laneId} must target the viet variant.`);
  assert(
    manifest.status === 'prepared-not-live' || manifest.status === 'promoted-live',
    `${manifest.laneId} must be prepared-not-live or promoted-live.`,
  );
  assert(manifest.priceTarget === '$4.99', `${manifest.laneId} drifted away from the $4.99 premium target.`);
  assert(manifest.sourceCsv.trim().length > 0, `${manifest.laneId} is missing sourceCsv.`);
  assert(manifest.nextRecommendedLaneId.trim().length > 0, `${manifest.laneId} is missing nextRecommendedLaneId.`);
  assert(manifest.scenarios.length > 0, `${manifest.laneId} must describe at least one scenario.`);
  assert(
    manifest.preparedDelta.total === manifest.preparedDelta.starter + manifest.preparedDelta.premium,
    `${manifest.laneId} has inconsistent preparedDelta totals.`,
  );
}

function validateLaneRows(params: {
  manifest: LaneManifest;
  rows: DraftRow[];
  liveBoundary: BoundaryCounts;
  livePhraseIds: Set<string>;
  liveFamilyIds: Set<string>;
  validScenarioIds: Set<string>;
}) {
  const { manifest, rows, liveBoundary, livePhraseIds, liveFamilyIds, validScenarioIds } = params;
  const isPreparedOnly = manifest.status === 'prepared-not-live';

  assert(rows.length > 0, `${manifest.laneId} has no rows in ${manifest.sourceCsv}.`);

  const lanePhraseIds = new Set<string>();
  const scenarioPremiumCounts = new Map<string, number>();
  const familyToRoles = new Map<string, Set<string>>();
  const familyToScenario = new Map<string, string>();

  for (const row of rows) {
    const phraseId = row.phrase_id?.trim();
    const familyId = normalizeFamilyId(row);
    const scenarioId = row.scenario_id?.trim();
    const familyTitle = row.family_title?.trim();
    const familySummary = row.family_summary?.trim();
    const audioKey = row.audio_key?.trim();
    const englishText = row.english_text?.trim();
    const context = row.context?.trim();
    const emoji = row.emoji?.trim();
    const status = row.status?.trim();
    const accessTier = normalizeAccessTier(row.access_tier);
    const variantRole = normalizeVariantRole(row.variant_role);
    const audioStatus = normalizeAudioStatus(row.audio_status);

    assert(phraseId, `${manifest.laneId} contains a row with a missing phrase_id.`);
    assert(scenarioId, `${manifest.laneId} phrase "${phraseId}" is missing scenario_id.`);
    assert(familyId, `${manifest.laneId} phrase "${phraseId}" is missing family_id.`);
    assert(familyTitle, `${manifest.laneId} phrase "${phraseId}" is missing family_title.`);
    assert(familySummary, `${manifest.laneId} phrase "${phraseId}" is missing family_summary.`);
    assert(audioKey, `${manifest.laneId} phrase "${phraseId}" is missing audio_key.`);
    assert(englishText, `${manifest.laneId} phrase "${phraseId}" is missing english_text.`);
    assert(context, `${manifest.laneId} phrase "${phraseId}" is missing context.`);
    assert(emoji, `${manifest.laneId} phrase "${phraseId}" is missing emoji.`);
    assert(validScenarioIds.has(scenarioId), `${manifest.laneId} phrase "${phraseId}" references unknown scenario "${scenarioId}".`);
    if (isPreparedOnly) {
      assert(!livePhraseIds.has(phraseId), `${manifest.laneId} phrase "${phraseId}" collides with a live Viet phrase ID.`);
      assert(!liveFamilyIds.has(familyId), `${manifest.laneId} family "${familyId}" collides with a live Viet family ID.`);
    } else {
      assert(livePhraseIds.has(phraseId), `${manifest.laneId} promoted-live phrase "${phraseId}" is missing from the live Viet source.`);
      assert(liveFamilyIds.has(familyId), `${manifest.laneId} promoted-live family "${familyId}" is missing from the live Viet source.`);
    }
    assert(!lanePhraseIds.has(phraseId), `${manifest.laneId} reuses phrase ID "${phraseId}".`);
    lanePhraseIds.add(phraseId);

    assert(accessTier === 'premium', `${manifest.laneId} phrase "${phraseId}" must stay premium-only.`);
    assert(status === 'needs-translation', `${manifest.laneId} phrase "${phraseId}" must stay marked as needs-translation.`);
    assert(audioStatus === 'planned' || audioStatus === 'ready', `${manifest.laneId} phrase "${phraseId}" has invalid audio status.`);

    const targetText = row.target_text?.trim();
    const canonicalTargetText = row.canonical_target_text?.trim();
    const pronunciation = row.pronunciation?.trim();
    if (isPreparedOnly) {
      assert(
        !targetText && !canonicalTargetText && !pronunciation,
        `${manifest.laneId} phrase "${phraseId}" should stay translation-empty while this lane is still prepared-not-live.`,
      );
    }

    const familyRoles = familyToRoles.get(familyId) ?? new Set<string>();
    assert(!familyRoles.has(variantRole), `${manifest.laneId} family "${familyId}" duplicates the role "${variantRole}".`);
    familyRoles.add(variantRole);
    familyToRoles.set(familyId, familyRoles);

    const previousScenario = familyToScenario.get(familyId);
    assert(
      !previousScenario || previousScenario === scenarioId,
      `${manifest.laneId} family "${familyId}" crosses scenarios "${previousScenario}" and "${scenarioId}".`,
    );
    familyToScenario.set(familyId, scenarioId);

    if (variantRole === 'say-first') {
      scenarioPremiumCounts.set(scenarioId, (scenarioPremiumCounts.get(scenarioId) ?? 0) + 1);
    }
  }

  for (const [familyId, roles] of familyToRoles.entries()) {
    assert(roles.has('say-first'), `${manifest.laneId} family "${familyId}" is missing a say-first phrase.`);
  }

  const preparedPremiumFamilies = [...familyToRoles.values()].filter((roles) => roles.has('say-first')).length;
  const preparedDelta = {
    starter: 0,
    premium: preparedPremiumFamilies,
    total: preparedPremiumFamilies,
  };
  const computedPreparedBoundaryIfPromoted = {
    starter: liveBoundary.starter + preparedDelta.starter,
    premium: liveBoundary.premium + preparedDelta.premium,
    total: liveBoundary.total + preparedDelta.total,
  };

  assert(
    boundariesMatch(manifest.preparedDelta, preparedDelta),
    `${manifest.laneId} prepared delta drifted. Expected ${formatBoundary(manifest.preparedDelta)} but computed ${formatBoundary(preparedDelta)}.`,
  );
  assert(
    manifest.preparedDelta.rawPhraseRows === rows.length,
    `${manifest.laneId} expected ${manifest.preparedDelta.rawPhraseRows} raw rows but found ${rows.length}.`,
  );
  if (isPreparedOnly) {
    assert(
      boundariesMatch(manifest.preparedBoundaryIfPromoted, computedPreparedBoundaryIfPromoted),
      `${manifest.laneId} prepared boundary drifted. Expected ${formatBoundary(
        manifest.preparedBoundaryIfPromoted,
      )} but computed ${formatBoundary(computedPreparedBoundaryIfPromoted)}.`,
    );
  }

  const manifestScenarioCounts = new Map(manifest.scenarios.map((entry) => [entry.scenarioId, entry.newPremiumFamilies]));
  assert(manifestScenarioCounts.size === manifest.scenarios.length, `${manifest.laneId} duplicates a scenario in the manifest.`);

  for (const [scenarioId, count] of scenarioPremiumCounts.entries()) {
    assert(
      manifestScenarioCounts.has(scenarioId),
      `${manifest.laneId} scenario "${scenarioId}" is present in the CSV but missing from the manifest.`,
    );
    assert(
      manifestScenarioCounts.get(scenarioId) === count,
      `${manifest.laneId} expected ${manifestScenarioCounts.get(scenarioId)} premium families for "${scenarioId}" but found ${count}.`,
    );
  }

  for (const entry of manifest.scenarios) {
    assert(
      scenarioPremiumCounts.has(entry.scenarioId),
      `${manifest.laneId} manifest scenario "${entry.scenarioId}" has no prepared premium families in the CSV.`,
    );
  }

  if (isPreparedOnly) {
    console.log(
      `Validated ${manifest.laneId}: +${preparedDelta.premium} premium families, ${rows.length} raw rows, prepared boundary ${formatBoundary(
        computedPreparedBoundaryIfPromoted,
      )}`,
    );
    return;
  }

  assert(
    boundaryAtLeast(manifest.currentLiveBoundary, manifest.preparedBoundaryIfPromoted),
    `${manifest.laneId} historical live boundary ${formatBoundary(
      manifest.currentLiveBoundary,
    )} should be at least the historical pre-promotion boundary ${formatBoundary(manifest.preparedBoundaryIfPromoted)}.`,
  );
  console.log(`Validated ${manifest.laneId} as a promoted-live historical lane with ${rows.length} scaffold rows.`);
}

async function readCsvFile(filePath: string) {
  const text = await readFile(filePath, 'utf8');
  const parsed = parseCsvRows(text);
  assert(parsed.length > 0, `CSV file "${filePath}" is empty.`);

  const [header, ...rows] = parsed;
  return rows.map((row) => {
    const record: DraftRow = {};

    header.forEach((columnName, index) => {
      const normalizedColumnName = index === 0 ? columnName.replace(/^\uFEFF/, '') : columnName;
      record[normalizedColumnName] = row[index] ?? '';
    });

    return record;
  });
}

function computeVisibleBoundary(rows: DraftRow[]): BoundaryCounts {
  let starter = 0;
  let premium = 0;
  let total = 0;

  for (const row of rows) {
    if (normalizeVariantRole(row.variant_role) !== 'say-first') {
      continue;
    }

    total += 1;
    if (normalizeAccessTier(row.access_tier) === 'premium') {
      premium += 1;
    } else {
      starter += 1;
    }
  }

  return { starter, premium, total };
}

function normalizeFamilyId(row: DraftRow) {
  return row.family_id?.trim() || row.phrase_id?.trim() || '';
}

function normalizeAccessTier(value?: string) {
  const normalizedValue = value?.trim().toLowerCase();
  return normalizedValue === 'premium' ? 'premium' : 'starter';
}

function normalizeVariantRole(value?: string) {
  const normalizedValue = value?.trim().toLowerCase();
  return normalizedValue || 'say-first';
}

function normalizeAudioStatus(value?: string) {
  const normalizedValue = value?.trim().toLowerCase();
  return normalizedValue || 'planned';
}

function boundariesMatch(left: BoundaryCounts, right: BoundaryCounts) {
  return left.starter === right.starter && left.premium === right.premium && left.total === right.total;
}

function boundaryAtLeast(current: BoundaryCounts, floor: BoundaryCounts) {
  return current.starter >= floor.starter && current.premium >= floor.premium && current.total >= floor.total;
}

function formatBoundary(boundary: BoundaryCounts) {
  return `${boundary.starter} / ${boundary.premium} / ${boundary.total}`;
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
