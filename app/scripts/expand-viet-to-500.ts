import { mkdir, readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';

import { parseCsvRows } from './csv';
import { resolveScriptRoots } from './resolve-script-roots';

type DraftRow = Record<string, string>;

type ScenarioCounts = {
  starter: number;
  premium: number;
  total: number;
};

type ScenarioTarget = {
  starter: number;
  total: number;
};

type CleanupCandidate = {
  source: 'cleanup';
  scenarioId: string;
  accessTier: 'starter' | 'premium';
  englishText: string;
  title: string;
  emoji: string;
  priority: number;
  searchAliases: string;
  notes: string;
  sourceCategory: string;
  sourceFamily: string;
};

type PreparedCandidate = {
  source: 'prepared';
  laneId: string;
  row: DraftRow;
};

type BuildCandidate = CleanupCandidate | PreparedCandidate;

const { repoRoot: REPO_ROOT } = resolveScriptRoots(import.meta.url);
const VIET_SOURCE_PATH = path.join(REPO_ROOT, 'content-draft', 'viet', 'phrase-source.csv');
const VIET_PLAN_PATH = path.join(REPO_ROOT, 'content-draft', 'viet', 'scenario-plan.json');
const CLEANUP_PATH = 'C:\\Users\\Administrator\\.openclaw\\workspace\\projects\\SpeakLocal Viet Phrase Quality Cleanup.csv';
const PREPARED_LANES = [
  {
    laneId: 'phase1-repair-recovery-core',
    csvPath: path.join(REPO_ROOT, 'content-draft', 'viet', 'premium-expansion', 'phase1-repair-recovery-core.csv'),
  },
  {
    laneId: 'phase1-food-connectivity-help',
    csvPath: path.join(REPO_ROOT, 'content-draft', 'viet', 'premium-expansion', 'phase1-food-connectivity-help.csv'),
  },
];
const AUDIT_DIR = path.join(REPO_ROOT, 'content-draft', 'viet', 'autonomous-500');
const AUDIT_ROWS_PATH = path.join(AUDIT_DIR, 'generated-rows.csv');
const AUDIT_REPORT_PATH = path.join(AUDIT_DIR, 'selection-summary.json');

const scenarioTargets: Record<string, ScenarioTarget> = {
  'polite-basics': { starter: 8, total: 13 },
  'understanding-repair': { starter: 8, total: 47 },
  'transport': { starter: 10, total: 43 },
  'hotel-accommodation': { starter: 9, total: 37 },
  'food-drink': { starter: 18, total: 40 },
  'money-numbers-prices': { starter: 9, total: 37 },
  'directions-navigation': { starter: 8, total: 26 },
  'airport-border-arrival': { starter: 8, total: 30 },
  'health-pharmacy': { starter: 8, total: 23 },
  'problems-help': { starter: 6, total: 37 },
  'time-dates-booking': { starter: 7, total: 27 },
  'shopping': { starter: 7, total: 17 },
  'phone-internet-power': { starter: 8, total: 30 },
  'bathroom-personal-needs': { starter: 6, total: 13 },
  'emergency-safety': { starter: 9, total: 30 },
  'social-small-talk': { starter: 7, total: 17 },
  'sightseeing-activities': { starter: 6, total: 13 },
  'local-services-everyday-tasks': { starter: 8, total: 20 },
};

const scenarioContext: Record<string, string> = {
  'polite-basics': 'Use this in short everyday travel exchanges when you want to stay polite without overexplaining.',
  'understanding-repair': 'Use this when the conversation is stuck and you need a clearer next step fast.',
  'transport': 'Use this during rides, stations, pickups, or route changes when the trip could go sideways.',
  'hotel-accommodation': 'Use this at the front desk or in the room when you need the hotel to fix the next step.',
  'food-drink': 'Use this while ordering, correcting the dish, or paying when the table moment needs a direct phrase.',
  'money-numbers-prices': 'Use this when you need the number, total, fee, or payment detail to be clear before it gets worse.',
  'directions-navigation': 'Use this while walking, checking a route, or confirming the exact turn, stop, or entrance.',
  'airport-border-arrival': 'Use this during arrival, transfers, baggage, pickups, or airport services when you need the next checkpoint.',
  'health-pharmacy': 'Use this when you need to describe a symptom, ask for medicine, or handle a practical health step.',
  'problems-help': 'Use this when the trip is off track and you need another person to help solve the practical problem.',
  'time-dates-booking': 'Use this when you need the exact time, date, booking detail, or schedule change to be clear.',
  'shopping': 'Use this while comparing items, checking fit, or fixing a purchase problem at the counter.',
  'phone-internet-power': 'Use this when your signal, SIM, battery, Wi-Fi, or app flow stops working the way you need.',
  'bathroom-personal-needs': 'Use this for urgent bathroom, hygiene, or small comfort needs that still matter on the road.',
  'emergency-safety': 'Use this when safety, theft, documents, police, or urgent help needs to be clear right now.',
  'social-small-talk': 'Use this when you want to stay friendly, set a boundary, or keep the social moment easy to manage.',
  'sightseeing-activities': 'Use this for tickets, tours, photos, meeting points, and attraction logistics while you are out.',
  'local-services-everyday-tasks': 'Use this for errands, printing, laundry, basic supplies, and other practical tasks that keep the trip moving.',
};

const scenarioEmoji: Record<string, string> = {
  'polite-basics': '🙏',
  'understanding-repair': '🧩',
  'transport': '🚕',
  'hotel-accommodation': '🏨',
  'food-drink': '🍽️',
  'money-numbers-prices': '💵',
  'directions-navigation': '🗺️',
  'airport-border-arrival': '🛬',
  'health-pharmacy': '💊',
  'problems-help': '🆘',
  'time-dates-booking': '🕒',
  'shopping': '🛍️',
  'phone-internet-power': '📱',
  'bathroom-personal-needs': '🚻',
  'emergency-safety': '🚨',
  'social-small-talk': '💬',
  'sightseeing-activities': '📸',
  'local-services-everyday-tasks': '🏪',
};

const scenarioOrder = [
  'polite-basics',
  'understanding-repair',
  'transport',
  'hotel-accommodation',
  'food-drink',
  'money-numbers-prices',
  'directions-navigation',
  'airport-border-arrival',
  'health-pharmacy',
  'problems-help',
  'time-dates-booking',
  'shopping',
  'phone-internet-power',
  'bathroom-personal-needs',
  'emergency-safety',
  'social-small-talk',
  'sightseeing-activities',
  'local-services-everyday-tasks',
];

async function main() {
  const liveRows = await readCsvRecords(VIET_SOURCE_PATH);
  const cleanupRows = await readCsvRecords(CLEANUP_PATH);
  const preparedRows = (await Promise.all(
    PREPARED_LANES.map(async (lane) => ({
      laneId: lane.laneId,
      rows: await readCsvRecords(lane.csvPath),
    })),
  )).flatMap((lane) => lane.rows.map((row) => ({ source: 'prepared' as const, laneId: lane.laneId, row })));

  const liveSayFirstRows = liveRows.filter((row) => normalizeVariantRole(row.variant_role) === 'say-first');
  const liveCounts = countByScenario(liveSayFirstRows);
  const promotedCounts = countByScenario(preparedRows.map((candidate) => candidate.row));

  assertTotalCounts(liveCounts, 128, 30, 158);

  const plan = JSON.parse(await readFile(VIET_PLAN_PATH, 'utf8')) as {
    scenarios: Array<{ id: string; name: string }>;
  };
  const validScenarioIds = new Set(plan.scenarios.map((scenario) => scenario.id));

  const existingPhraseIds = new Set(liveRows.map((row) => row.phrase_id));
  const existingFamilyIds = new Set(liveRows.map((row) => row.family_id || row.phrase_id));
  const existingEnglish = new Set(liveSayFirstRows.map((row) => normalizeEnglish(row.english_text)));

  const cleanupCandidates = cleanupRows
    .filter((row) => row.disposition && row.disposition !== 'drop')
    .map(buildCleanupCandidate)
    .filter((candidate): candidate is CleanupCandidate => !!candidate)
    .filter((candidate) => validScenarioIds.has(candidate.scenarioId))
    .filter((candidate) => !existingEnglish.has(normalizeEnglish(candidate.englishText)));

  const selectedPrepared = preparedRows.filter((candidate) => normalizeVariantRole(candidate.row.variant_role) === 'say-first');
  const reservedEnglish = new Set(selectedPrepared.map((candidate) => normalizeEnglish(candidate.row.english_text)));

  const selectedCleanup = selectCleanupCandidates(cleanupCandidates, liveCounts, promotedCounts, reservedEnglish);
  const translationCache = new Map<string, { targetText: string; pronunciation: string }>();

  const generatedRows: DraftRow[] = [];

  for (const candidate of selectedPrepared) {
    const translated = await translate(candidate.row.english_text, translationCache);
    generatedRows.push({
      ...candidate.row,
      target_text: translated.targetText,
      canonical_target_text: translated.targetText,
      pronunciation: translated.pronunciation,
      status: 'approved',
      notes: `${candidate.row.notes || ''} promoted live via autonomous-500`.trim(),
    });
  }

  for (const candidate of selectedCleanup) {
    const translated = await translate(candidate.englishText, translationCache);
    const ids = createIds(candidate.scenarioId, candidate.englishText, existingPhraseIds, existingFamilyIds);

    generatedRows.push({
      phrase_id: ids.phraseId,
      scenario_id: candidate.scenarioId,
      family_id: ids.familyId,
      family_title: candidate.title,
      family_summary: buildSummary(candidate.englishText),
      audio_key: ids.audioKey,
      english_text: candidate.englishText,
      target_text: translated.targetText,
      canonical_target_text: translated.targetText,
      pronunciation: translated.pronunciation,
      access_tier: candidate.accessTier,
      variant_role: 'say-first',
      context: scenarioContext[candidate.scenarioId],
      you_may_hear: '',
      search_aliases: candidate.searchAliases,
      warning_note_type: '',
      audio_status: 'planned',
      emoji: candidate.emoji,
      notes: candidate.notes,
      status: 'approved',
    });
  }

  const mergedRows = [...liveRows, ...generatedRows];
  const mergedSayFirstCounts = countByScenario(mergedRows.filter((row) => normalizeVariantRole(row.variant_role) === 'say-first'));
  assertTargetCounts(mergedSayFirstCounts);

  await mkdir(AUDIT_DIR, { recursive: true });
  await writeFile(VIET_SOURCE_PATH, serializeCsv(mergedRows), 'utf8');
  await writeFile(AUDIT_ROWS_PATH, serializeCsv(generatedRows), 'utf8');
  await writeFile(
    AUDIT_REPORT_PATH,
    `${JSON.stringify(
      {
        liveCounts,
        promotedCounts,
        generatedCounts: countByScenario(generatedRows),
        mergedCounts: mergedSayFirstCounts,
        generatedRowCount: generatedRows.length,
        translatedPhraseCount: translationCache.size,
      },
      null,
      2,
    )}\n`,
    'utf8',
  );

  console.log(`Expanded Viet to ${mergedSayFirstCounts.__all.total} visible entries with ${generatedRows.length} new live rows.`);
}

function buildCleanupCandidate(row: DraftRow): CleanupCandidate | null {
  const englishText = (row.translation_ready_english_phrase || row.rewritten_english_phrase || row.english_phrase || '').trim();
  if (!englishText) {
    return null;
  }

  const scenarioId = mapCleanupScenario(row, englishText);
  if (!scenarioId) {
    return null;
  }

  const accessTier = normalizeAccessTier(row.recommended_tier || row.tier);
  const title = toDisplayTitle(englishText);
  const priority = normalizePriority(row.priority);
  const searchAliases = buildSearchAliases(englishText);

  return {
    source: 'cleanup',
    scenarioId,
    accessTier,
    englishText,
    title,
    emoji: scenarioEmoji[scenarioId] || '🧳',
    priority,
    searchAliases,
    notes: `autonomous-500 from cleanup: ${row.category} / ${row.family} / ${row.disposition}`,
    sourceCategory: row.category,
    sourceFamily: row.family,
  };
}

function mapCleanupScenario(row: DraftRow, englishText: string) {
  const category = row.category;
  const family = row.family;
  const lowerFamily = family.toLowerCase();
  const lowerEnglish = englishText.toLowerCase();

  if (category === 'Essentials & Politeness') {
    return 'polite-basics';
  }
  if (category === 'Language Repair & Clarifying') {
    return 'understanding-repair';
  }
  if (category === 'Airport & Arrival') {
    return 'airport-border-arrival';
  }
  if (category === 'Getting Around') {
    return 'transport';
  }
  if (category === 'Directions & Places') {
    return 'directions-navigation';
  }
  if (category === 'Hotel & Accommodation') {
    return 'hotel-accommodation';
  }
  if (category === 'Food & Drink') {
    return 'food-drink';
  }
  if (category === 'Money, Prices & Payment') {
    return 'money-numbers-prices';
  }
  if (category === 'Shopping & Markets') {
    return 'shopping';
  }
  if (category === 'Tickets, Time & Bookings') {
    return 'time-dates-booking';
  }
  if (category === 'Health, Pharmacy & Medical') {
    return 'health-pharmacy';
  }
  if (category === 'Phone, Internet & Apps') {
    return 'phone-internet-power';
  }
  if (category === 'Daily Practical Needs') {
    if (family === 'Bathroom & Hygiene') {
      return 'bathroom-personal-needs';
    }
    return 'local-services-everyday-tasks';
  }
  if (category === 'Out & About: Sightseeing, Activities & Social') {
    if (
      family === 'Small Talk & Friendly Basics' ||
      family === 'Weather, Comfort & Plans' ||
      family === 'Polite Refusals & Boundaries'
    ) {
      return 'social-small-talk';
    }
    return 'sightseeing-activities';
  }
  if (category === 'Safety, Problems & Emergency Help') {
    if (
      family === 'Accidents, Fire & Ambulance' ||
      family === 'Harassment, Scams & Unsafe Situations'
    ) {
      return 'emergency-safety';
    }

    if (family === 'Embassy, Contacts & Recovery') {
      if (/hotel|airline|embassy|contact/.test(lowerEnglish)) {
        return 'problems-help';
      }
      return 'emergency-safety';
    }

    if (family === 'General Help & Urgency') {
      if (/police|ambulance|emergency|safe/.test(lowerEnglish)) {
        return 'emergency-safety';
      }
      return 'problems-help';
    }

    if (family === 'Lost, Stolen & Left Behind') {
      if (/stolen|passport|credit card/.test(lowerEnglish)) {
        return 'emergency-safety';
      }
      return 'problems-help';
    }

    if (family === 'Police, Security & Reports') {
      return 'problems-help';
    }

    return 'problems-help';
  }

  return null;
}

function selectCleanupCandidates(
  cleanupCandidates: CleanupCandidate[],
  liveCounts: Record<string, ScenarioCounts>,
  promotedCounts: Record<string, ScenarioCounts>,
  reservedEnglish: Set<string>,
) {
  const byScenario = new Map<string, CleanupCandidate[]>();
  for (const candidate of cleanupCandidates) {
    if (reservedEnglish.has(normalizeEnglish(candidate.englishText))) {
      continue;
    }
    const list = byScenario.get(candidate.scenarioId) ?? [];
    list.push(candidate);
    byScenario.set(candidate.scenarioId, list);
  }

  for (const candidates of byScenario.values()) {
    candidates.sort(compareCleanupCandidates);
  }

  const selected: CleanupCandidate[] = [];
  const selectedEnglish = new Set<string>();
  const counts = cloneCounts(liveCounts);
  applyPromotedCounts(counts, promotedCounts);

  for (const scenarioId of scenarioOrder) {
    const target = scenarioTargets[scenarioId];
    const currentStarter = counts[scenarioId]?.starter ?? 0;
    let neededStarter = Math.max(0, target.starter - currentStarter);
    const candidates = byScenario.get(scenarioId) ?? [];

    const starterFirst = candidates.filter((candidate) => candidate.accessTier === 'starter');
    const starterFallback = candidates.filter((candidate) => candidate.accessTier === 'premium');

    for (const pool of [starterFirst, starterFallback]) {
      for (const candidate of pool) {
        if (neededStarter <= 0) {
          break;
        }
        const englishKey = normalizeEnglish(candidate.englishText);
        if (selectedEnglish.has(englishKey)) {
          continue;
        }
        selected.push({
          ...candidate,
          accessTier: 'starter',
          notes: `${candidate.notes}; selected as starter fill`,
        });
        selectedEnglish.add(englishKey);
        counts[scenarioId].starter += 1;
        counts[scenarioId].total += 1;
        neededStarter -= 1;
      }
    }

    if (neededStarter > 0) {
      throw new Error(`Could not satisfy starter target for ${scenarioId}. Still need ${neededStarter}.`);
    }
  }

  for (const scenarioId of scenarioOrder) {
    const target = scenarioTargets[scenarioId];
    let neededTotal = Math.max(0, target.total - (counts[scenarioId]?.total ?? 0));
    const candidates = byScenario.get(scenarioId) ?? [];

    for (const candidate of candidates) {
      if (neededTotal <= 0) {
        break;
      }

      const englishKey = normalizeEnglish(candidate.englishText);
      if (selectedEnglish.has(englishKey)) {
        continue;
      }

      selected.push({
        ...candidate,
        accessTier: 'premium',
        notes: `${candidate.notes}; selected as premium fill`,
      });
      selectedEnglish.add(englishKey);
      counts[scenarioId].premium += 1;
      counts[scenarioId].total += 1;
      neededTotal -= 1;
    }

    if (neededTotal > 0) {
      throw new Error(`Could not satisfy total target for ${scenarioId}. Still need ${neededTotal}.`);
    }
  }

  return selected;
}

function compareCleanupCandidates(left: CleanupCandidate, right: CleanupCandidate) {
  const leftStarter = left.accessTier === 'starter' ? 0 : 1;
  const rightStarter = right.accessTier === 'starter' ? 0 : 1;
  if (leftStarter !== rightStarter) {
    return leftStarter - rightStarter;
  }

  if (left.priority !== right.priority) {
    return left.priority - right.priority;
  }

  const leftLength = left.englishText.length;
  const rightLength = right.englishText.length;
  if (leftLength !== rightLength) {
    return leftLength - rightLength;
  }

  return left.englishText.localeCompare(right.englishText);
}

async function translate(
  englishText: string,
  cache: Map<string, { targetText: string; pronunciation: string }>,
) {
  const cached = cache.get(englishText);
  if (cached) {
    return cached;
  }

  const encoded = encodeURIComponent(englishText);
  const url = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=vi&dt=t&q=${encoded}`;
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Translation request failed for "${englishText}" with ${response.status}.`);
  }

  const payload = (await response.json()) as Array<Array<Array<string>>>;
  const targetText = payload?.[0]?.map((part) => part?.[0] || '').join('').trim();
  if (!targetText) {
    throw new Error(`Translation payload was empty for "${englishText}".`);
  }

  const translated = {
    targetText,
    pronunciation: transliterate(targetText),
  };
  cache.set(englishText, translated);
  return translated;
}

function transliterate(text: string) {
  return text
    .replace(/[đĐ]/g, (match) => (match === 'Đ' ? 'D' : 'd'))
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^\p{L}\p{N}\s'-]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function buildSummary(englishText: string) {
  const cleaned = englishText.replace(/[?!.]+$/g, '').trim().toLowerCase();
  if (englishText.includes('?')) {
    return `Ask this when you need ${cleaned}.`;
  }
  if (/^(i|i'm|i’m|my)\b/i.test(englishText)) {
    return `Use this when you need to explain that ${cleaned}.`;
  }
  if (/^(please|can you|could you)\b/i.test(englishText)) {
    return `Use this when you need direct help with the next step.`;
  }
  return `Use this when you need to say ${cleaned}.`;
}

function toDisplayTitle(englishText: string) {
  return englishText.replace(/[?!.]+$/g, '').trim();
}

function buildSearchAliases(englishText: string) {
  const normalized = englishText.toLowerCase().trim();
  const simplified = normalized.replace(/[?!.]+$/g, '').replace(/[^a-z0-9\s]/g, ' ').replace(/\s+/g, ' ').trim();
  const aliases = new Set<string>([normalized, simplified]);
  return [...aliases].filter(Boolean).join('|');
}

function createIds(
  scenarioId: string,
  englishText: string,
  existingPhraseIds: Set<string>,
  existingFamilyIds: Set<string>,
) {
  const base = `v500-${shortScenarioId(scenarioId)}-${slugify(englishText)}`;
  let phraseId = base;
  let familyId = base;
  let index = 2;

  while (existingPhraseIds.has(phraseId) || existingFamilyIds.has(familyId)) {
    phraseId = `${base}-${index}`;
    familyId = `${base}-${index}`;
    index += 1;
  }

  existingPhraseIds.add(phraseId);
  existingFamilyIds.add(familyId);

  return {
    phraseId,
    familyId,
    audioKey: phraseId,
  };
}

function shortScenarioId(scenarioId: string) {
  return scenarioId
    .split('-')
    .map((part) => part.slice(0, 4))
    .join('-');
}

function slugify(text: string) {
  return text
    .toLowerCase()
    .replace(/[’']/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 48);
}

function applyPromotedCounts(
  target: Record<string, ScenarioCounts>,
  promoted: Record<string, ScenarioCounts>,
) {
  for (const scenarioId of scenarioOrder) {
    if (!target[scenarioId]) {
      target[scenarioId] = { starter: 0, premium: 0, total: 0 };
    }
    if (!promoted[scenarioId]) {
      continue;
    }
    target[scenarioId].starter += promoted[scenarioId].starter;
    target[scenarioId].premium += promoted[scenarioId].premium;
    target[scenarioId].total += promoted[scenarioId].total;
  }
}

function countByScenario(rows: DraftRow[]) {
  const counts: Record<string, ScenarioCounts> = {
    __all: { starter: 0, premium: 0, total: 0 },
  };

  for (const scenarioId of scenarioOrder) {
    counts[scenarioId] = { starter: 0, premium: 0, total: 0 };
  }

  for (const row of rows) {
    const scenarioId = row.scenario_id;
    const accessTier = normalizeAccessTier(row.access_tier);
    if (!counts[scenarioId]) {
      counts[scenarioId] = { starter: 0, premium: 0, total: 0 };
    }
    counts[scenarioId].total += 1;
    counts.__all.total += 1;

    if (accessTier === 'premium') {
      counts[scenarioId].premium += 1;
      counts.__all.premium += 1;
    } else {
      counts[scenarioId].starter += 1;
      counts.__all.starter += 1;
    }
  }

  return counts;
}

function cloneCounts(counts: Record<string, ScenarioCounts>) {
  return Object.fromEntries(
    Object.entries(counts).map(([key, value]) => [key, { ...value }]),
  ) as Record<string, ScenarioCounts>;
}

function assertTargetCounts(counts: Record<string, ScenarioCounts>) {
  for (const scenarioId of scenarioOrder) {
    const target = scenarioTargets[scenarioId];
    const actual = counts[scenarioId];
    if (!actual) {
      throw new Error(`Missing merged counts for ${scenarioId}.`);
    }
    if (actual.starter !== target.starter) {
      throw new Error(`Starter target drift for ${scenarioId}: expected ${target.starter}, found ${actual.starter}.`);
    }
    if (actual.total !== target.total) {
      throw new Error(`Total target drift for ${scenarioId}: expected ${target.total}, found ${actual.total}.`);
    }
  }

  if (counts.__all.starter !== 150 || counts.__all.premium !== 350 || counts.__all.total !== 500) {
    throw new Error(
      `Final Viet boundary drifted. Expected 150 / 350 / 500, found ${counts.__all.starter} / ${counts.__all.premium} / ${counts.__all.total}.`,
    );
  }
}

function assertTotalCounts(
  counts: Record<string, ScenarioCounts>,
  starter: number,
  premium: number,
  total: number,
) {
  if (counts.__all.starter !== starter || counts.__all.premium !== premium || counts.__all.total !== total) {
    throw new Error(
      `Expected live counts ${starter} / ${premium} / ${total}, found ${counts.__all.starter} / ${counts.__all.premium} / ${counts.__all.total}.`,
    );
  }
}

function normalizeAccessTier(value?: string): 'starter' | 'premium' {
  return value?.trim().toLowerCase() === 'premium' ? 'premium' : 'starter';
}

function normalizeVariantRole(value?: string) {
  return value?.trim().toLowerCase() || 'say-first';
}

function normalizeEnglish(value?: string) {
  return (value || '')
    .toLowerCase()
    .replace(/[’']/g, "'")
    .replace(/…/g, '...')
    .replace(/[^a-z0-9?.!'\s]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function normalizePriority(value?: string) {
  if (value === 'P0') {
    return 0;
  }
  if (value === 'P1') {
    return 1;
  }
  return 2;
}

async function readCsvRecords(filePath: string) {
  const text = await readFile(filePath, 'utf8');
  const [headerRow, ...rows] = parseCsvRows(text);
  const headers = headerRow.map((cell, index) => (index === 0 ? cell.replace(/^\uFEFF/, '') : cell).trim());

  return rows.map((row) => Object.fromEntries(headers.map((header, index) => [header, row[index] ?? ''])));
}

function serializeCsv(rows: DraftRow[]) {
  const headers = [
    'phrase_id',
    'scenario_id',
    'family_id',
    'family_title',
    'family_summary',
    'audio_key',
    'english_text',
    'target_text',
    'canonical_target_text',
    'pronunciation',
    'access_tier',
    'variant_role',
    'context',
    'you_may_hear',
    'search_aliases',
    'warning_note_type',
    'audio_status',
    'emoji',
    'notes',
    'status',
  ];

  return `${headers.map(escapeCsvCell).join(',')}\n${rows
    .map((row) => headers.map((header) => escapeCsvCell(row[header] ?? '')).join(','))
    .join('\n')}\n`;
}

function escapeCsvCell(value: string) {
  return `"${String(value).replace(/"/g, '""')}"`;
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
