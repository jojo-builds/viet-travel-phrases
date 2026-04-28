const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..', '..', '..');
const worktreeRoot = process.argv[2]
  ? path.resolve(process.argv[2])
  : path.resolve(repoRoot, '..', 'SpeakLocal-App-Family-worktrees', 'tagalog-v2-expansion');

const tagalogDir = path.join(worktreeRoot, 'content-draft', 'tagalog');
const answerPagePath = path.join(tagalogDir, 'answer-page-sample-v1.json');
const relationSamplePath = path.join(tagalogDir, 'relation-sample-v1.json');
const phraseSourcePath = path.join(tagalogDir, 'phrase-source.csv');
const firstWavePriorityPath = path.join(tagalogDir, 'first-wave-priority.csv');
const firstWaveMergedPath = path.join(tagalogDir, 'tagalog-v2-first-wave.csv');

const CLASS_ORDER = [
  'greetings-social',
  'urgent-help-medical',
  'repair-clarification',
  'transport-ride-hailing',
  'directions-navigation',
  'hotel-accommodation',
  'money-transaction',
  'food-drink',
];

const SELECTED_CLUSTERS_BY_CLASS = {
  'greetings-social': [
    'tagalog-greeting-hello',
    'tagalog-polite-excuse-me',
    'tagalog-polite-thank-you',
    'tagalog-polite-acknowledge',
  ],
  'urgent-help-medical': [
    'tagalog-medical-doctor',
    'tagalog-simple-problems-13',
    'tagalog-simple-problems-14',
    'tagalog-simple-problems-15',
  ],
  'repair-clarification': [
    'tagalog-repair-understand',
    'tagalog-repair-slower',
    'tagalog-simple-problems-8',
    'tagalog-simple-problems-9',
    'tagalog-simple-problems-10',
    'tagalog-simple-problems-11',
    'tagalog-simple-problems-12',
  ],
  'transport-ride-hailing': [
    'tagalog-ride-destination',
    'tagalog-grab-taxi-8',
    'tagalog-grab-taxi-9',
    'tagalog-grab-taxi-10',
    'tagalog-grab-taxi-11',
    'tagalog-grab-taxi-12',
    'tagalog-grab-taxi-13',
    'tagalog-grab-taxi-14',
    'tagalog-grab-taxi-16',
  ],
  'directions-navigation': [
    'tagalog-directions-near',
    'tagalog-directions-walk-time',
    'tagalog-directions-8',
    'tagalog-directions-11',
    'tagalog-directions-13',
    'tagalog-directions-14',
    'tagalog-directions-16',
    'tagalog-directions-17',
  ],
  'hotel-accommodation': [
    'tagalog-hotel-hostel-8',
    'tagalog-hotel-hostel-9',
    'tagalog-hotel-hostel-10',
    'tagalog-hotel-hostel-11',
    'tagalog-hotel-hostel-13',
    'tagalog-hotel-hostel-14',
    'tagalog-hotel-hostel-15',
    'tagalog-hotel-hostel-16',
  ],
  'money-transaction': [
    'tagalog-price-check',
    'tagalog-asking-price-8',
    'tagalog-asking-price-10',
    'tagalog-asking-price-11',
    'tagalog-asking-price-12',
    'tagalog-asking-price-14',
    'tagalog-asking-price-15',
    'tagalog-convenience-store-8',
    'tagalog-convenience-store-9',
    'tagalog-convenience-store-12',
  ],
  'food-drink': [
    'tagalog-food-not-spicy',
    'tagalog-food-takeaway',
    'tagalog-street-food-8',
    'tagalog-street-food-9',
    'tagalog-street-food-11',
    'tagalog-street-food-12',
    'tagalog-street-food-13',
    'tagalog-street-food-15',
  ],
};

const MODULE_MIXES = {
  'greetings-social': {
    id: 'greetings-social-v2',
    phraseClass: 'greetings-social',
    moduleTypes: ['core-phrase', 'social-use-case', 'likely-reply', 'say-next', 'local-reality', 'graceful-exit'],
    requiredRelationBuckets: ['likelyReply', 'repairIfMissed', 'askNext'],
  },
  'urgent-help-medical': {
    id: 'urgent-help-medical-v2',
    phraseClass: 'urgent-help-medical',
    moduleTypes: [
      'urgent-core',
      'risk-or-symptom-detail',
      'likely-reply',
      'immediate-next-step',
      'what-to-show',
      'local-reality',
      'repair-branch',
      'safety-escalation',
    ],
    requiredRelationBuckets: ['likelyReply', 'repairIfMissed', 'askNext'],
  },
  'repair-clarification': {
    id: 'repair-clarification-v2',
    phraseClass: 'repair-clarification',
    moduleTypes: [
      'repair-core',
      'show-or-write',
      'number-check',
      'likely-response',
      'next-try',
      'local-reality',
      'courtesy-close',
    ],
    requiredRelationBuckets: ['repairIfMissed', 'askNext'],
  },
  'transport-ride-hailing': {
    id: 'transport-ride-hailing-v1',
    phraseClass: 'transport-ride-hailing',
    moduleTypes: ['task-core', 'confirm-detail', 'what-to-show', 'local-reality', 'next-step', 'fallback'],
    requiredRelationBuckets: ['askNext'],
  },
  'directions-navigation': {
    id: 'directions-navigation-v1',
    phraseClass: 'directions-navigation',
    moduleTypes: ['task-core', 'operator-question', 'what-to-show', 'local-reality', 'next-step', 'fallback'],
    requiredRelationBuckets: ['askNext'],
  },
  'hotel-accommodation': {
    id: 'hotel-accommodation-v1',
    phraseClass: 'hotel-accommodation',
    moduleTypes: ['task-core', 'confirm-detail', 'what-to-show', 'local-reality', 'next-step', 'fallback'],
    requiredRelationBuckets: ['askNext'],
  },
  'money-transaction': {
    id: 'money-transaction-v1',
    phraseClass: 'money-transaction',
    moduleTypes: ['task-core', 'confirm-detail', 'number-check', 'what-to-show', 'next-step', 'fallback'],
    requiredRelationBuckets: ['askNext'],
  },
  'food-drink': {
    id: 'food-drink-v1',
    phraseClass: 'food-drink',
    moduleTypes: ['task-core', 'operator-question', 'confirm-detail', 'local-reality', 'next-step', 'fallback'],
    requiredRelationBuckets: ['askNext'],
  },
};

main();

function main() {
  const answerPage = readJson(answerPagePath);
  const relationSample = readJson(relationSamplePath);

  const phraseSource = readCsvFile(phraseSourcePath);
  const firstWavePriority = readCsvFile(firstWavePriorityPath);
  const firstWaveMerged = readCsvFile(firstWaveMergedPath);

  const currentHubIdByClusterId = new Map(
    answerPage.hubs.map((hub) => [hub.relationClusterId, hub.hubId]),
  );
  const clusterById = new Map(relationSample.clusters.map((cluster) => [cluster.clusterId, cluster]));
  const clusterByFamilyId = new Map(relationSample.clusters.map((cluster) => [cluster.familyId, cluster]));

  const phraseRows = phraseSource.objects;
  const phraseRowsById = new Map(phraseRows.map((row) => [row.phrase_id, row]));
  const familyRowsByFamilyId = new Map();
  for (const row of phraseRows) {
    const familyId = normalizeFamilyId(row);
    const group = familyRowsByFamilyId.get(familyId) ?? [];
    group.push(row);
    familyRowsByFamilyId.set(familyId, group);
  }

  const selectedEntries = [];
  for (const phraseClass of CLASS_ORDER) {
    for (const clusterId of SELECTED_CLUSTERS_BY_CLASS[phraseClass]) {
      const cluster = clusterById.get(clusterId);
      if (!cluster) {
        throw new Error(`Missing selected cluster "${clusterId}".`);
      }

      selectedEntries.push({
        clusterId,
        phraseClass,
        moduleMixId: MODULE_MIXES[phraseClass].id,
        hubId: currentHubIdByClusterId.get(clusterId) ?? `${clusterId}-answer`,
        familyId: cluster.familyId,
      });
    }
  }

  const selectedByClusterId = new Map(selectedEntries.map((entry) => [entry.clusterId, entry]));
  const selectedFamilyIds = selectedEntries.map((entry) => entry.familyId);

  relationSample.clusters = relationSample.clusters.map((cluster) => {
    const selected = selectedByClusterId.get(cluster.clusterId);

    if (!selected) {
      if (!cluster.answerPageReady) {
        return cluster;
      }

      const clone = { ...cluster };
      clone.answerPageReady = false;
      delete clone.answerPageHubId;
      delete clone.phraseClass;
      delete clone.moduleMixId;
      delete clone.relationBuckets;
      return clone;
    }

    const relationBuckets = buildRelationBuckets(cluster, clusterByFamilyId);
    return {
      ...cluster,
      answerPageReady: true,
      answerPageHubId: selected.hubId,
      phraseClass: selected.phraseClass,
      moduleMixId: selected.moduleMixId,
      relationBuckets,
    };
  });

  const promotedClusters = selectedEntries.map((entry) => relationSample.clusters.find((cluster) => cluster.clusterId === entry.clusterId));
  const answerPageHubs = promotedClusters.map((cluster) =>
    buildAnswerPageHub(cluster, selectedByClusterId.get(cluster.clusterId), clusterByFamilyId, familyRowsByFamilyId, phraseRowsById),
  );

  answerPage.hubCount = answerPageHubs.length;
  answerPage.phraseClassCount = CLASS_ORDER.length;
  answerPage.moduleMixes = CLASS_ORDER.map((phraseClass) => MODULE_MIXES[phraseClass]);
  answerPage.contentRules = mergeContentRules(answerPage.contentRules);
  answerPage.hubs = answerPageHubs;

  relationSample.answerPageCoverage = {
    sampleId: answerPage.sampleId,
    hubCount: answerPageHubs.length,
    phraseClassCount: CLASS_ORDER.length,
    moduleMixCount: CLASS_ORDER.length,
    phraseClasses: CLASS_ORDER,
    moduleMixIds: CLASS_ORDER.map((phraseClass) => MODULE_MIXES[phraseClass].id),
    answerReadyFamilyIds: selectedFamilyIds,
    relationBucketFields: ['likelyReply', 'repairIfMissed', 'askNext', 'escalateTo'],
  };

  updatePhraseSourceMarkers(phraseSource.objects, selectedByClusterId, clusterByFamilyId, familyRowsByFamilyId);
  updateFirstWaveAnswerFields(firstWavePriority.objects, selectedByClusterId, clusterByFamilyId);
  updateFirstWaveAnswerFields(firstWaveMerged.objects, selectedByClusterId, clusterByFamilyId);

  writeJson(answerPagePath, answerPage);
  writeJson(relationSamplePath, relationSample);
  writeCsvFile(phraseSourcePath, phraseSource);
  writeCsvFile(firstWavePriorityPath, firstWavePriority);
  writeCsvFile(firstWaveMergedPath, firstWaveMerged);

  const answerMarkedRows = phraseSource.objects.filter((row) => hasAnswerPageMarker(row.notes)).length;
  const byClass = {};
  for (const phraseClass of CLASS_ORDER) {
    byClass[phraseClass] = answerPageHubs.filter((hub) => hub.phraseClass === phraseClass).length;
  }

  console.log(
    JSON.stringify(
      {
        selectedHubCount: answerPageHubs.length,
        phraseClassCount: CLASS_ORDER.length,
        answerMarkedRows,
        byClass,
      },
      null,
      2,
    ),
  );
}

function buildAnswerPageHub(cluster, selected, clusterByFamilyId, familyRowsByFamilyId, phraseRowsById) {
  const relationBuckets = buildRelationBuckets(cluster, clusterByFamilyId);
  const familyRows = familyRowsByFamilyId.get(cluster.familyId) ?? [];
  const clearerPhraseId = cluster.clearerFormPhraseId || firstPhraseIdByRole(familyRows, 'clearer');
  const morePolitePhraseId = cluster.morePoliteFormPhraseId || firstPhraseIdByRole(familyRows, 'more-polite');
  const alternatePhraseIds = familyRows
    .filter((row) => ![cluster.anchorPhraseId, clearerPhraseId, morePolitePhraseId].includes(row.phrase_id))
    .map((row) => row.phrase_id);

  return {
    hubId: selected.hubId,
    scenarioId: cluster.scenarioId,
    familyId: cluster.familyId,
    familyTitle: cluster.familyTitle,
    phraseClass: selected.phraseClass,
    moduleMixId: selected.moduleMixId,
    relationClusterId: cluster.clusterId,
    anchorPhraseId: cluster.anchorPhraseId,
    defaultPhraseId: cluster.anchorPhraseId,
    quickSayPhraseId: cluster.shortestFormPhraseId || cluster.anchorPhraseId,
    clearerPhraseId: clearerPhraseId || null,
    morePolitePhraseId: morePolitePhraseId || null,
    alternatePhraseIds,
    relationBuckets: orderedBucketNames(relationBuckets),
    modules: buildModules(cluster, selected.phraseClass, relationBuckets, familyRows, phraseRowsById, clusterByFamilyId),
  };
}

function buildModules(cluster, phraseClass, relationBuckets, familyRows, phraseRowsById, clusterByFamilyId) {
  const anchorRow = phraseRowsById.get(cluster.anchorPhraseId);
  const variantRows = familyRows.filter((row) => row.phrase_id !== cluster.anchorPhraseId);
  const variantPhraseIds = variantRows.map((row) => row.phrase_id);
  const likelyReply = relationBuckets.likelyReply ?? [];
  const repair = relationBuckets.repairIfMissed ?? [];
  const askNext = relationBuckets.askNext ?? [];
  const escalate = relationBuckets.escalateTo ?? [];

  const phraseIds = [cluster.anchorPhraseId, ...variantPhraseIds];
  const contextBullet = anchorRow?.context?.trim() || `Use this for ${cluster.familyTitle.toLowerCase()} when the moment goes active.`;

  switch (phraseClass) {
    case 'greetings-social':
      return [
        makeModule('core-phrase', 'core-phrase', phraseIds, [cluster.familyId], [], 'Open with this briefly, then move to the real ask before the moment stalls.', [
          contextBullet,
          'Keep the opener short when you already know the practical reason you stopped the person.',
        ]),
        makeModule('social-use-case', 'social-use-case', phraseIds, [cluster.familyId], [], 'Treat the social layer as a soft door into a useful interaction, not the whole interaction.', [
          'Best fit: counters, front desks, pickups, and quick help from a stranger.',
          'If the moment is high-friction, go from the opener straight into the request.',
        ]),
        ...maybeModule(
          likelyReply.length,
          makeModule(
            'likely-reply',
            'likely-reply',
            bucketPhraseIds(likelyReply),
            bucketFamilyIds(likelyReply),
            ['likelyReply'],
            'The most honest reply rail here is a short acknowledgment, not a long side conversation.',
            bucketBullets(likelyReply, 'Be ready for', clusterByFamilyId),
          ),
        ),
        makeModule(
          'say-next',
          'say-next',
          bucketPhraseIds(askNext),
          bucketFamilyIds(askNext),
          ['askNext'],
          'Use the next beat to pivot into the real question, screen, or booking problem.',
          bucketBullets(askNext, 'Once this lands, the next useful move is', clusterByFamilyId),
        ),
        makeModule('local-reality', 'local-reality', phraseIds, [cluster.familyId], [], 'Busy staff usually wait for the real request right after this.', [
          'Do not spend the answer page on extra small talk when the traveler really needs a map, receipt, booking, or route fix.',
          'A clean short opener is stronger than a warm but vague one.',
        ]),
        ...maybeModule(
          repair.length,
          makeModule(
            'graceful-exit',
            'graceful-exit',
            bucketPhraseIds(repair),
            bucketFamilyIds(repair),
            ['repairIfMissed'],
            'If the opener misses, switch into repair immediately instead of repeating it louder.',
            bucketBullets(repair, 'If this still misses, switch to', clusterByFamilyId),
          ),
        ),
      ];
    case 'urgent-help-medical':
      return [
        makeModule('urgent-core', 'urgent-core', phraseIds, [cluster.familyId], [], 'Keep this direct. In a help or symptom moment, clarity beats politeness extras.', [
          contextBullet,
          'Lead with the problem first, then add extra detail once someone is listening.',
        ]),
        makeModule('risk-or-symptom-detail', 'risk-or-symptom-detail', phraseIds, [cluster.familyId], [], 'Be ready to add one concrete symptom or urgency detail right after the first line lands.', [
          'If you have a clearer or more polite variant, use it only when it removes confusion.',
          'Do not over-explain before the helper understands the core problem.',
        ]),
        ...maybeModule(
          likelyReply.length,
          makeModule(
            'likely-reply',
            'likely-reply',
            bucketPhraseIds(likelyReply),
            bucketFamilyIds(likelyReply),
            ['likelyReply'],
            'The first reply is usually a quick acknowledgment before the helper asks or points you somewhere.',
            bucketBullets(likelyReply, 'Expect the first answer rail to be', clusterByFamilyId),
          ),
        ),
        makeModule(
          'immediate-next-step',
          'immediate-next-step',
          bucketPhraseIds(askNext),
          bucketFamilyIds(askNext),
          ['askNext'],
          'Once someone engages, move quickly into the next useful medical or pharmacy detail.',
          bucketBullets(askNext, 'Next useful move after this is', clusterByFamilyId),
        ),
        makeModule('what-to-show', 'what-to-show', phraseIds, [cluster.familyId], [], 'Have the medicine, body area, booking, or translation note ready to show if speaking gets thin.', [
          'Showing the location, bottle, or screen often speeds up help more than repeating the same sentence.',
          'Use the phrase first, then point or show immediately.',
        ]),
        makeModule('local-reality', 'local-reality', phraseIds, [cluster.familyId], [], 'Medical help often splits fast into pharmacy, doctor, or follow-up symptom detail.', [
          'Be ready for short routing answers rather than a full explanation.',
          'If the answer comes back too fast, jump straight into repair.',
        ]),
        ...maybeModule(
          repair.length,
          makeModule(
            'repair-branch',
            'repair-branch',
            bucketPhraseIds(repair),
            bucketFamilyIds(repair),
            ['repairIfMissed'],
            'If the urgent ask does not land cleanly, move to repair without softening the urgency away.',
            bucketBullets(repair, 'If this still does not land, use', clusterByFamilyId),
          ),
        ),
        ...maybeModule(
          escalate.length,
          makeModule(
            'safety-escalation',
            'safety-escalation',
            bucketPhraseIds(escalate),
            bucketFamilyIds(escalate),
            ['escalateTo'],
            'Keep the stronger escalation branch nearby when the first phrase is not enough.',
            bucketBullets(escalate, 'Escalate to', clusterByFamilyId),
          ),
        ),
      ];
    case 'repair-clarification':
      return [
        makeModule('repair-core', 'repair-core', phraseIds, [cluster.familyId], [], 'Use this to reset the interaction fast instead of pretending you followed it.', [
          contextBullet,
          'Repair is strongest when you say it early, before the other person keeps talking.',
        ]),
        makeModule('show-or-write', 'show-or-write', phraseIds, [cluster.familyId], [], 'This repair lane works best when you pair it with writing, a screen, or a map.', [
          'If speech is failing, move the interaction onto paper or your phone instead of repeating the same line.',
          'The more concrete the item is, the faster the repair usually lands.',
        ]),
        makeModule('number-check', 'number-check', phraseIds, [cluster.familyId], [], 'Numbers, totals, room codes, pickup points, and stops are where this lane saves the trip.', [
          'Use the repair phrase before the number disappears on you.',
          'If the problem is specifically a number, keep the number follow-up one tap away.',
        ]),
        ...maybeModule(
          likelyReply.length,
          makeModule(
            'likely-response',
            'likely-response',
            bucketPhraseIds(likelyReply),
            bucketFamilyIds(likelyReply),
            ['likelyReply'],
            'The honest response rail here is usually a quick acknowledgment, not a full repair by itself.',
            bucketBullets(likelyReply, 'Most likely response after this is', clusterByFamilyId),
          ),
        ),
        ...maybeModule(
          askNext.length,
          makeModule(
            'next-try',
            'next-try',
            bucketPhraseIds(askNext),
            bucketFamilyIds(askNext),
            ['askNext'],
            'Once the reset lands, move into the next concrete repair step right away.',
            bucketBullets(askNext, 'Next repair move after this is', clusterByFamilyId),
          ),
        ),
        makeModule('local-reality', 'local-reality', phraseIds, [cluster.familyId], [], 'A good repair page keeps the traveler moving forward instead of trapping them in one apology loop.', [
          'Favor practical follow-ups like write it down, type it here, or say the number again.',
          'Do not pad the page with decorative politeness if the real problem is understanding.',
        ]),
        makeModule(
          'courtesy-close',
          'courtesy-close',
          phraseIds,
          [cluster.familyId],
          [],
          'Once the repair lands, close the reset and get back to the actual task.',
          [
            'Use a quick thanks or acknowledgment, then return to the booking, route, number, or symptom you were trying to solve.',
            'The repair phrase is the bridge, not the destination.',
          ],
        ),
      ];
    case 'transport-ride-hailing':
      return [
        makeModule('task-core', 'task-core', phraseIds, [cluster.familyId], [], 'Use this as the ride-control phrase before the car, curb, or route starts drifting away from you.', [
          contextBullet,
          'Ride moments get harder to fix once the driver starts moving, so say the key line early.',
        ]),
        makeModule('confirm-detail', 'confirm-detail', phraseIds, [cluster.familyId], [], 'Confirm the one detail that matters most: pickup point, route, entrance, toll, or the app destination.', [
          variantRows.length
            ? 'If the short version gets a blank look, switch to the clearer or more respectful variant instead of repeating faster.'
            : 'If the short version misses, pair it with the map or app screen immediately.',
          'Keep the request concrete enough that the driver can act on it fast.',
        ]),
        makeModule('what-to-show', 'what-to-show', phraseIds, [cluster.familyId], [], 'This page gets stronger when the traveler shows the pin, map, entrance, or booking screen at the same time.', [
          'A visible screen often resolves ride friction faster than another spoken pass.',
          'Point at the destination or route problem while you say the line.',
        ]),
        makeModule('local-reality', 'local-reality', phraseIds, [cluster.familyId], [], 'Ride interactions usually come back as short confirmations while the driver keeps working.', [
          'Expect movement, traffic, and background noise; shorter, clearer ride-control phrases win here.',
          'If the driver still looks unsure, go to repair rather than stacking more ride jargon.',
        ]),
        ...maybeModule(
          askNext.length,
          makeModule(
            'next-step',
            'next-step',
            bucketPhraseIds(askNext),
            bucketFamilyIds(askNext),
            ['askNext'],
            'Once the main ride phrase lands, move to the next travel-control detail without backing out of the flow.',
            bucketBullets(askNext, 'Next useful ride move after this is', clusterByFamilyId),
          ),
        ),
        ...maybeModule(
          repair.length,
          makeModule(
            'fallback',
            'fallback',
            bucketPhraseIds(repair),
            bucketFamilyIds(repair),
            ['repairIfMissed'],
            'If the driver still does not track the request, switch into repair immediately.',
            bucketBullets(repair, 'Fallback if this misses is', clusterByFamilyId),
          ),
        ),
      ];
    case 'directions-navigation':
      return [
        makeModule('task-core', 'task-core', phraseIds, [cluster.familyId], [], 'Use this to force the direction question into one clear decision instead of a vague exchange.', [
          contextBullet,
          'Direction help gets cleaner when you isolate one thing: entrance, distance, route choice, or safety.',
        ]),
        makeModule('operator-question', 'operator-question', phraseIds, [cluster.familyId], [], 'Expect the answer to come back as a quick gesture, landmark, or short route phrase.', [
          'You may get pointing or map tapping instead of full spoken directions.',
          'Have the destination or map visible before you ask.',
        ]),
        makeModule('what-to-show', 'what-to-show', phraseIds, [cluster.familyId], [], 'Maps and pins are part of the phrase here, not an optional extra.', [
          'Show the exact place name, map pin, or entrance photo if the spoken place name is weak.',
          'Point first, then ask the follow-up direction question.',
        ]),
        makeModule('local-reality', 'local-reality', phraseIds, [cluster.familyId], [], 'Direction answers are often short and local: landmarks, exits, stops, or a hand signal.', [
          'If you miss the first answer, repair fast instead of asking a new question on top of it.',
          'The page should keep the traveler moving toward the next concrete route check.',
        ]),
        ...maybeModule(
          askNext.length,
          makeModule(
            'next-step',
            'next-step',
            bucketPhraseIds(askNext),
            bucketFamilyIds(askNext),
            ['askNext'],
            'Once this question works, move into the next route check while the person is still engaged.',
            bucketBullets(askNext, 'Next useful navigation move after this is', clusterByFamilyId),
          ),
        ),
        ...maybeModule(
          repair.length,
          makeModule(
            'fallback',
            'fallback',
            bucketPhraseIds(repair),
            bucketFamilyIds(repair),
            ['repairIfMissed'],
            'If the answer comes back too fast or too local, drop into repair and get the map or writing involved.',
            bucketBullets(repair, 'Fallback if this misses is', clusterByFamilyId),
          ),
        ),
      ];
    case 'hotel-accommodation':
      return [
        makeModule('task-core', 'task-core', phraseIds, [cluster.familyId], [], 'Use this as the concrete hotel-service line, not as a soft front-desk hint.', [
          contextBullet,
          'Hotel fixes go faster when the traveler says the exact booking or room problem up front.',
        ]),
        makeModule('confirm-detail', 'confirm-detail', phraseIds, [cluster.familyId], [], 'Pair the phrase with the one detail the staff need next: name, room, key card, luggage, breakfast, or checkout timing.', [
          variantRows.length
            ? 'Use the clearer or more polite variant when the service tone matters or the first line feels too thin.'
            : 'Keep the ask short, then add the booking or room detail right after it lands.',
          'A precise hotel detail beats a broad complaint every time.',
        ]),
        makeModule('what-to-show', 'what-to-show', phraseIds, [cluster.familyId], [], 'Show the booking screen, room number, key card, or broken service point as soon as you can.', [
          'Front-desk and housekeeping problems resolve faster when the evidence is already visible.',
          'Use the phrase to frame the problem, then point at the booking or item.',
        ]),
        makeModule('local-reality', 'local-reality', phraseIds, [cluster.familyId], [], 'Hotel replies are often short, practical, and procedural rather than chatty.', [
          'Be ready for the staff to route you into one more service step instead of solving everything in one line.',
          'If the answer is too fast or unclear, go to repair instead of escalating too early.',
        ]),
        ...maybeModule(
          askNext.length,
          makeModule(
            'next-step',
            'next-step',
            bucketPhraseIds(askNext),
            bucketFamilyIds(askNext),
            ['askNext'],
            'Once staff understand the problem, move straight into the next useful hotel follow-up.',
            bucketBullets(askNext, 'Next useful hotel move after this is', clusterByFamilyId),
          ),
        ),
        ...maybeModule(
          repair.length,
          makeModule(
            'fallback',
            'fallback',
            bucketPhraseIds(repair),
            bucketFamilyIds(repair),
            ['repairIfMissed'],
            'If the hotel fix still is not landing, switch to repair without dropping the concrete service detail.',
            bucketBullets(repair, 'Fallback if this misses is', clusterByFamilyId),
          ),
        ),
      ];
    case 'money-transaction':
      return [
        makeModule('task-core', 'task-core', phraseIds, [cluster.familyId], [], 'Use this to control the number, total, payment method, or mismatch before the transaction drifts past you.', [
          contextBullet,
          'Money friction gets worse fast if the traveler lets the total or payment assumption go unchallenged.',
        ]),
        makeModule('confirm-detail', 'confirm-detail', phraseIds, [cluster.familyId], [], 'Keep the money question narrow: total, change, cash, card, sign mismatch, or receipt.', [
          variantRows.length
            ? 'If the first pass feels too thin, switch to the clearer form instead of adding extra filler.'
            : 'Point at the amount, sign, card terminal, or receipt while you say it.',
          'Small payment details are the whole task here.',
        ]),
        makeModule('number-check', 'number-check', phraseIds, [cluster.familyId], [], 'Numbers are the fragile part of this page: totals, bills, change, and what the screen is actually showing.', [
          'If the amount is unclear, move quickly into write-it-down or say-it-again repair.',
          'Do not let polite nodding replace a clean number check.',
        ]),
        makeModule('what-to-show', 'what-to-show', phraseIds, [cluster.familyId], [], 'Show the total on the screen, the printed sign, the large bill, or the failed payment prompt right away.', [
          'Visual proof shortens money disputes more than another spoken loop.',
          'The page should help the traveler point at the exact mismatch.',
        ]),
        ...maybeModule(
          askNext.length,
          makeModule(
            'next-step',
            'next-step',
            bucketPhraseIds(askNext),
            bucketFamilyIds(askNext),
            ['askNext'],
            'Once the cashier or driver understands the issue, move into the next payment-control step immediately.',
            bucketBullets(askNext, 'Next useful money move after this is', clusterByFamilyId),
          ),
        ),
        ...maybeModule(
          repair.length,
          makeModule(
            'fallback',
            'fallback',
            bucketPhraseIds(repair),
            bucketFamilyIds(repair),
            ['repairIfMissed'],
            'If the amount or payment method is still fuzzy, drop into repair before the transaction closes out wrong.',
            bucketBullets(repair, 'Fallback if this misses is', clusterByFamilyId),
          ),
        ),
      ];
    case 'food-drink':
      return [
        makeModule('task-core', 'task-core', phraseIds, [cluster.familyId], [], 'Use this to land the food decision fast: preference, restriction, menu, sweetness, or takeaway.', [
          contextBullet,
          'Food pages work best when they stay concrete and order-focused, not conversational.',
        ]),
        makeModule('operator-question', 'operator-question', phraseIds, [cluster.familyId], [], 'Expect short practical answers here: yes/no, pointing, menu options, or a quick follow-up question.', [
          'Staff may answer by gesture or by pointing at the menu or tray instead of a full spoken explanation.',
          'Keep the next order move ready while they are still engaged.',
        ]),
        makeModule('confirm-detail', 'confirm-detail', phraseIds, [cluster.familyId], [], 'Clarify the one food constraint or ordering detail that matters most.', [
          variantRows.length
            ? 'If the first pass feels too short, use the clearer or more specific variant next.'
            : 'Pair the phrase with pointing, menu text, or the ingredient concern you need to confirm.',
          'Restriction and order pages should stay sharper than generic dining small talk.',
        ]),
        makeModule('local-reality', 'local-reality', phraseIds, [cluster.familyId], [], 'Food answers often come back as a short yes/no, a gesture, or a quick recommendation.', [
          'If the answer gets too fast or ingredient-heavy, go to repair instead of pretending you caught it.',
          'This page should help the traveler keep the order moving forward.',
        ]),
        ...maybeModule(
          askNext.length,
          makeModule(
            'next-step',
            'next-step',
            bucketPhraseIds(askNext),
            bucketFamilyIds(askNext),
            ['askNext'],
            'Once the food constraint or order hook lands, move right into the next useful ordering step.',
            bucketBullets(askNext, 'Next useful food move after this is', clusterByFamilyId),
          ),
        ),
        ...maybeModule(
          repair.length,
          makeModule(
            'fallback',
            'fallback',
            bucketPhraseIds(repair),
            bucketFamilyIds(repair),
            ['repairIfMissed'],
            'If the order still is not clear, switch into repair before the wrong item gets packed or plated.',
            bucketBullets(repair, 'Fallback if this misses is', clusterByFamilyId),
          ),
        ),
      ];
    default:
      throw new Error(`Unsupported phrase class "${phraseClass}".`);
  }
}

function buildRelationBuckets(cluster, clusterByFamilyId) {
  const buckets = {};
  const likelyReply = collectBucketEntries(
    cluster.possibleTravelerResponses,
    (entry) => entry.kind === 'likelyReply' && clusterByFamilyId.has(entry.familyId),
    (entry) => ({
      targetFamilyId: entry.familyId,
      targetPhraseId: entry.phraseId,
      reason: entry.note,
    }),
  );

  if (!likelyReply.length) {
    likelyReply.push(
      ...collectBucketEntries(
        cluster.familyRelations,
        (entry) =>
          (entry.relationType === 'likely_answer_to' || entry.relationType === 'reply_to') &&
          clusterByFamilyId.has(entry.targetFamilyId) &&
          !entry.targetStatus &&
          !entry.targetFollowOnClass,
        (entry) => ({
          targetFamilyId: entry.targetFamilyId,
          targetPhraseId: clusterByFamilyId.get(entry.targetFamilyId).anchorPhraseId,
          reason: entry.reason,
        }),
      ),
    );
  }

  const askNext = collectBucketEntries(
    cluster.possibleTravelerResponses,
    (entry) => entry.kind !== 'likelyReply' && entry.kind !== 'repair-branch' && clusterByFamilyId.has(entry.familyId),
    (entry) => ({
      targetFamilyId: entry.familyId,
      targetPhraseId: entry.phraseId,
      reason: entry.note,
    }),
  );
  askNext.push(
    ...collectBucketEntries(
      cluster.familyRelations,
      (entry) =>
        entry.relationType === 'next_step_after' &&
        clusterByFamilyId.has(entry.targetFamilyId) &&
        !entry.targetStatus &&
        !entry.targetFollowOnClass,
      (entry) => ({
        targetFamilyId: entry.targetFamilyId,
        targetPhraseId: clusterByFamilyId.get(entry.targetFamilyId).anchorPhraseId,
        reason: entry.reason,
      }),
    ),
  );

  const repairIfMissed = collectBucketEntries(
    cluster.possibleTravelerResponses,
    (entry) => entry.kind === 'repair-branch' && clusterByFamilyId.has(entry.familyId),
    (entry) => ({
      targetFamilyId: entry.familyId,
      targetPhraseId: entry.phraseId,
      reason: entry.note,
    }),
  );
  repairIfMissed.push(
    ...collectBucketEntries(
      cluster.familyRelations,
      (entry) =>
        entry.relationType === 'repair_for' &&
        clusterByFamilyId.has(entry.targetFamilyId) &&
        !entry.targetStatus &&
        !entry.targetFollowOnClass,
      (entry) => ({
        targetFamilyId: entry.targetFamilyId,
        targetPhraseId: clusterByFamilyId.get(entry.targetFamilyId).anchorPhraseId,
        reason: entry.reason,
      }),
    ),
  );

  const escalateTo = collectBucketEntries(
    cluster.familyRelations,
    (entry) =>
      entry.relationType === 'escalation_for' &&
      clusterByFamilyId.has(entry.targetFamilyId) &&
      !entry.targetStatus &&
      !entry.targetFollowOnClass,
    (entry) => ({
      targetFamilyId: entry.targetFamilyId,
      targetPhraseId: clusterByFamilyId.get(entry.targetFamilyId).anchorPhraseId,
      reason: entry.reason,
    }),
  );

  if (likelyReply.length) {
    buckets.likelyReply = dedupeBucketEntries(likelyReply);
  }
  if (repairIfMissed.length) {
    buckets.repairIfMissed = dedupeBucketEntries(repairIfMissed);
  }
  if (askNext.length) {
    buckets.askNext = dedupeBucketEntries(askNext);
  }
  if (escalateTo.length) {
    buckets.escalateTo = dedupeBucketEntries(escalateTo);
  }

  return buckets;
}

function collectBucketEntries(source, predicate, mapper) {
  return (source ?? []).filter(predicate).map(mapper);
}

function dedupeBucketEntries(entries) {
  const seen = new Set();
  const deduped = [];

  for (const entry of entries) {
    const key = `${entry.targetFamilyId}|${entry.targetPhraseId}`;
    if (seen.has(key)) {
      continue;
    }
    seen.add(key);
    deduped.push(entry);
  }

  return deduped;
}

function updatePhraseSourceMarkers(rows, selectedByClusterId, clusterByFamilyId, familyRowsByFamilyId) {
  const selectedByFamilyId = new Map();
  for (const entry of selectedByClusterId.values()) {
    const cluster = clusterByFamilyId.get(entry.familyId);
    selectedByFamilyId.set(entry.familyId, {
      ...entry,
      cluster,
      hubId: entry.hubId,
    });
  }

  for (const row of rows) {
    const familyId = normalizeFamilyId(row);
    const selected = selectedByFamilyId.get(familyId);

    if (!selected) {
      row.notes = replaceAnswerPageMarker(row.notes, null);
      continue;
    }

    const familyRows = familyRowsByFamilyId.get(familyId) ?? [];
    const cluster = selected.cluster;
    const clearerPhraseId = cluster.clearerFormPhraseId || firstPhraseIdByRole(familyRows, 'clearer');
    const morePolitePhraseId = cluster.morePoliteFormPhraseId || firstPhraseIdByRole(familyRows, 'more-polite');
    let token = null;

    if (row.phrase_id === cluster.anchorPhraseId) {
      token = `${selected.hubId}:anchor`;
    } else if (row.phrase_id === clearerPhraseId) {
      token = `${selected.hubId}:variant:clearer`;
    } else if (row.phrase_id === morePolitePhraseId) {
      token = `${selected.hubId}:variant:more-polite`;
    } else if ((row.variant_role || '').trim() === 'also-common') {
      token = `${selected.hubId}:variant:also-common`;
    }

    row.notes = replaceAnswerPageMarker(row.notes, token);
  }
}

function updateFirstWaveAnswerFields(rows, selectedByClusterId, clusterByFamilyId) {
  const selectedByFamilyId = new Map();
  for (const entry of selectedByClusterId.values()) {
    const cluster = clusterByFamilyId.get(entry.familyId);
    selectedByFamilyId.set(entry.familyId, {
      ...entry,
      cluster,
    });
  }

  for (const row of rows) {
    const selected = selectedByFamilyId.get(row.family_id);
    if (!selected) {
      row.answer_page_hub_id = '';
      row.answer_page_phrase_class = '';
      row.answer_page_module_mix_id = '';
      continue;
    }

    row.answer_page_hub_id = selected.hubId;
    row.answer_page_phrase_class = selected.phraseClass;
    row.answer_page_module_mix_id = selected.moduleMixId;
  }
}

function mergeContentRules(existingRules) {
  const merged = [
    ...(existingRules ?? []),
    'Promoted relationBuckets come only from authored relation-sample-v1.json edges and response hints.',
    'Parked or deferred relation targets stay in relation metadata only and do not populate answer-page relationBuckets.',
    'Relation-driven modules only appear when the current relation sample actually authors the supporting bucket.',
  ];

  return [...new Set(merged)];
}

function replaceAnswerPageMarker(notes, token) {
  const entries = (notes || '')
    .split(';')
    .map((entry) => entry.trim())
    .filter(Boolean)
    .filter((entry) => !entry.startsWith('answer-page-sample='));

  if (token) {
    entries.push(`answer-page-sample=${token}`);
  }

  return entries.join('; ');
}

function hasAnswerPageMarker(notes) {
  return (notes || '').includes('answer-page-sample=');
}

function normalizeFamilyId(row) {
  return (row.family_id || row.phrase_id || '').trim();
}

function firstPhraseIdByRole(rows, role) {
  const row = rows.find((candidate) => (candidate.variant_role || '').trim() === role);
  return row ? row.phrase_id : null;
}

function orderedBucketNames(buckets) {
  return ['likelyReply', 'repairIfMissed', 'askNext', 'escalateTo'].filter((name) => Array.isArray(buckets[name]) && buckets[name].length);
}

function bucketPhraseIds(entries) {
  return dedupe(entries.map((entry) => entry.targetPhraseId).filter(Boolean));
}

function bucketFamilyIds(entries) {
  return dedupe(entries.map((entry) => entry.targetFamilyId).filter(Boolean));
}

function bucketBullets(entries, prefix, clusterByFamilyId) {
  if (!entries.length) {
    return ['Keep the next tap focused on the concrete follow-up instead of repeating the same line.'];
  }

  return entries.slice(0, 3).map((entry) => `${prefix} "${clusterByFamilyId.get(entry.targetFamilyId)?.familyTitle || entry.targetFamilyId}".`);
}

function dedupe(values) {
  return [...new Set(values)];
}

function makeModule(moduleId, type, sourcePhraseIds, sourceFamilyIds, relationRefs, summary, bullets) {
  return {
    moduleId,
    type,
    required: true,
    sourcePhraseIds: dedupe(sourcePhraseIds.filter(Boolean)),
    sourceFamilyIds: dedupe(sourceFamilyIds.filter(Boolean)),
    relationRefs,
    content: {
      summary,
      bullets: bullets.filter(Boolean),
    },
  };
}

function maybeModule(condition, module) {
  return condition ? [module] : [];
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\r\n`, 'utf8');
}

function readCsvFile(filePath) {
  const raw = fs.readFileSync(filePath, 'utf8');
  const hasBom = raw.charCodeAt(0) === 0xfeff;
  const text = hasBom ? raw.slice(1) : raw;
  const rows = parseCsvRows(text);
  const headers = rows[0].map((cell, index) => (index === 0 ? cell.replace(/^\ufeff/, '').trim() : cell.trim()));
  const objects = rows.slice(1).map((row) => {
    const entry = {};
    headers.forEach((header, index) => {
      entry[header] = row[index] ?? '';
    });
    return entry;
  });

  return {
    hasBom,
    headers,
    objects,
  };
}

function writeCsvFile(filePath, csv) {
  const rows = [csv.headers, ...csv.objects.map((entry) => csv.headers.map((header) => entry[header] ?? ''))];
  const text = rows.map(formatCsvRow).join('\r\n');
  fs.writeFileSync(filePath, `${csv.hasBom ? '\ufeff' : ''}${text}\r\n`, 'utf8');
}

function formatCsvRow(row) {
  return row
    .map((value) => {
      const text = `${value ?? ''}`;
      if (/[",\r\n]/.test(text)) {
        return `"${text.replace(/"/g, '""')}"`;
      }
      return text;
    })
    .join(',');
}

function parseCsvRows(text) {
  const rows = [];
  let row = [];
  let cell = '';
  let inQuotes = false;

  for (let index = 0; index < text.length; index += 1) {
    const character = text[index];
    const next = text[index + 1];

    if (character === '"') {
      if (inQuotes && next === '"') {
        cell += '"';
        index += 1;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }

    if (character === ',' && !inQuotes) {
      row.push(cell);
      cell = '';
      continue;
    }

    if ((character === '\n' || character === '\r') && !inQuotes) {
      if (character === '\r' && next === '\n') {
        index += 1;
      }

      row.push(cell);
      if (row.some((value) => value.length > 0)) {
        rows.push(row);
      }
      row = [];
      cell = '';
      continue;
    }

    cell += character;
  }

  if (cell.length > 0 || row.length > 0) {
    row.push(cell);
    rows.push(row);
  }

  return rows;
}
