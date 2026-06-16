#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const pageUpdates = [
  {
    id: "viet-thanks-khong-co-gi",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/thank-you-khong-co-gi.json",
    summary: "A small no-problem reply for closing a thank-you without adding more explanation.",
    bodies: {
      "at-glance": "Khong co gi is the light reply after someone thanks you. It keeps the moment easy instead of formal.",
      "when-to-use": "Best after directions, service help, a small favor, or a friendly apology when no extra answer is needed.",
    },
    value: "turns a title-thin thank-you reply into a specific closing moment",
  },
  {
    id: "viet-phrase-v500-hote-acco-please-remove-the-trash",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-please-remove-the-trash.json",
    bodies: {
      "at-glance": "Use this when the room trash is the one housekeeping task that needs attention.",
      "quick-say": "Say the phrase once, then show the bin, room number, or key card so staff know the exact room task.",
    },
    value: "replaces repeated hotel visibility copy with a room-trash housekeeping request",
  },
  {
    id: "viet-phrase-v500-hote-acco-the-room-is-not-clean",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-the-room-is-not-clean.json",
    bodies: {
      "at-glance": "Use this when the room condition needs a staff check, not just more towels or supplies.",
      "quick-say": "Show the room number and the problem area after the phrase. A photo can help if staff are still at the desk.",
    },
    value: "makes the hotel cleanliness page specific to room-condition recovery",
  },
  {
    id: "viet-phrase-v900-hote-acco-the-shower-is-not-working",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-the-shower-is-not-working.json",
    bodies: {
      "at-glance": "Use this when the shower will not run, drain, heat, or switch modes correctly.",
      "quick-say": "Name the shower problem, then keep the room number ready so maintenance can find the right bathroom.",
    },
    value: "replaces generic booking copy with shower-specific repair guidance",
  },
  {
    id: "viet-phrase-v900-hote-acco-the-wi-fi-is-not-working-in-my-room",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-the-wi-fi-is-not-working-in-my-room.json",
    bodies: {
      "at-glance": "Use this when the lobby may have Wi-Fi but your room does not.",
      "quick-say": "Show the room number, network name, or error screen after the phrase so staff can separate room signal from password trouble.",
    },
    value: "makes the hotel Wi-Fi page room-specific instead of generic hotel context",
  },
  {
    id: "viet-phrase-social-8",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/social-8.json",
    bodies: {
      "quick-say": "Ask lightly, then pause. The answer is usually a number of days, weeks, or a quick story.",
      "good-to-know": "This is small talk, not paperwork. If the answer is short, let the conversation move on.",
    },
    value: "removes question-scaffold language from a social-small-talk page",
  },
  {
    id: "viet-phrase-v500-time-date-book-how-long-is-the-wait",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-how-long-is-the-wait.json",
    bodies: {
      "quick-say": "Ask once while the line, table list, or booking screen is visible. The answer should be a time, not a long explanation.",
      "good-to-know": "If the number matters, show your phone clock or booking. Waiting answers are easier when both people see the same time.",
    },
    value: "replaces lead-with-question formula with a concrete wait-time moment",
  },
  {
    id: "viet-phrase-v900-dire-navi-what-time-does-this-place-close",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-what-time-does-this-place-close.json",
    bodies: {
      "quick-say": "Ask while pointing at the place, sign, map pin, or ticket listing. The closing time is the detail to catch.",
      "good-to-know": "If staff answer with a number, repeat it back or check it against the posted sign before you leave.",
    },
    value: "makes the closing-time direction page place-specific instead of formulaic",
  },
  {
    id: "viet-hello-good-afternoon",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-good-afternoon.json",
    bodies: {
      "standard-way": "Say it when the day has clearly moved past lunch and a plain hello feels a little too flat.",
      "good-to-know": "Afternoon greetings are optional. A warm Xin chao still works if the timing feels uncertain.",
    },
    value: "removes use-it-when phrasing from a time-of-day greeting",
  },
  {
    id: "viet-phrase-v500-food-drin-this-is-cold",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-this-is-cold.json",
    bodies: {
      "when-to-use": "Best when a dish that should be hot arrives lukewarm or cold and you want staff to check it.",
      "good-to-know": "Point to the item and stay specific. The fix is usually reheating, replacing, or checking the dish.",
    },
    value: "turns a cold-food repair page into a concrete table recovery moment",
  },
  {
    id: "viet-phrase-v500-soci-smal-talk-i-want-to-be-alone-thank-you",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-i-want-to-be-alone-thank-you.json",
    bodies: {
      "at-glance": "Use this when you need privacy or quiet without escalating the moment.",
      "quick-say": "Say it once, keep your tone calm, and step back from the conversation if the other person gives you room.",
      "natural-variants": "Nearby social cards cover where you are from, first-time visits, and friendly comments when you do want to keep talking.",
    },
    value: "replaces generic social scaffold with a privacy-boundary moment",
  },
  {
    id: "viet-phrase-v500-tran-please-turn-around",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-turn-around.json",
    bodies: {
      "at-glance": "Say this when the ride has passed the needed turn and going back matters more than continuing.",
      "when-to-use": "Best in a taxi, motorbike pickup, or walking route when the map shows the missed turn clearly.",
    },
    value: "removes use-it-when wording from a route-correction page",
  },
  {
    id: "viet-phrase-v900-heal-phar-i-take-this-medicine-every-day",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-take-this-medicine-every-day.json",
    bodies: {
      "at-glance": "Say this before advice, dosage, refills, or interactions so staff know the medicine is part of your daily routine.",
      "good-to-know": "Show the package, photo, or prescription if you can. The medicine name matters more than a long explanation.",
    },
    value: "makes the daily-medicine page specific to medication-history safety",
  },
  {
    id: "viet-phrase-v900-hote-acco-i-want-to-cancel-my-stay",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-i-want-to-cancel-my-stay.json",
    bodies: {
      "at-glance": "Use this when the decision is cancellation, not checkout, room change, or one-night adjustment.",
      "quick-say": "Show the booking dates after the phrase so staff can see which nights and policies are involved.",
      "good-to-know": "Cancellation can trigger fees or app rules. Keep the booking screen open before agreeing to the next step.",
    },
    value: "replaces generic hotel request prose with cancellation-specific guidance",
  },
  {
    id: "viet-phrase-v900-tran-this-is-the-wrong-address",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-this-is-the-wrong-address.json",
    bodies: {
      "at-glance": "Say this when the address on the app, receipt, message, or driver screen does not match where you need to go.",
      "when-to-use": "Best before the ride continues too far. Show the correct address and let the driver compare both screens.",
    },
    value: "removes use-it-when wording from an address-mismatch recovery page",
  },
  {
    id: "viet-thanks-cam-on-nhieu",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/thank-you-cam-on-nhieu.json",
    bodies: {
      "when-to-use": "Best after someone carries a bag, solves a problem, walks you over, or spends extra time helping.",
      "explore-next": "After the warm thank-you, the next useful move may be goodbye, I understand, no problem, or a plain thanks.",
    },
    value: "makes the warmer-thanks page specific to extra-help moments",
  },
  {
    id: "viet-phrase-v500-tran-is-this-my-car",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-is-this-my-car.json",
    summary: "For checking the car, plate, driver, or destination before you get in.",
    value: "replaces a bare car-confirmation summary with the safety check it owns",
  },
  {
    id: "viet-phrase-food-15",
    source: "content-draft/viet/canonical-pages/tier-one/food-drink/food-peanut-allergy--food-15.json",
    bodies: {
      breakdown: "Món này means this dish; có asks whether it contains something; trứng hay đậu phộng names egg or peanuts.",
      "good-to-know": "For allergies, wait for a clear answer and choose another dish if the kitchen seems unsure.",
    },
    value: "makes a child ingredient-check page specific to egg and peanut safety",
  },
  {
    id: "viet-phrase-hotel-more-supplies-paper",
    source: "content-draft/viet/canonical-pages/tier-one/hotel-accommodation/hotel-more-supplies--hotel-more-supplies-paper.json",
    bodies: {
      breakdown: "Cho tôi asks to give me; thêm means more; giấy vệ sinh names toilet paper specifically.",
      "good-to-know": "This is a precise supply request. Keep the room number ready so staff can send it to the right door.",
    },
    value: "makes a child hotel-supply page specific to toilet paper instead of generic request rhythm",
  },
];

const supportUpdates = [
  {
    phraseID: "ves-do-you-speak-english-anh",
    fields: {
      context: "Choose this with an older man or male helper when English may solve the next step.",
      atGlance: "This male-address version fits after a respectful hello when English would solve the next step.",
      quickSay: "Ask after Da, chao anh or Chao anh, then show the phone, booking, address, or word you need help with.",
      useItWith: "Choose it when the helper is an older man and the relationship word anh feels natural.",
      whenToUse: "At hotel desks, counters, rides, or help moments, English can make the next step clearer.",
      goodToKnow: "If the person says mot chut, keep your next English sentence short and show the screen.",
    },
    value: "removes repeated repair-copy residue from the male-address English-help support page",
  },
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function countCards(page) {
  return (page.sections || []).reduce((total, section) => total + ((section.phrases || []).length), 0);
}

function applyPageUpdate(update) {
  const page = readJson(update.source);
  const before = JSON.parse(JSON.stringify(page));
  if (Object.prototype.hasOwnProperty.call(update, "summary")) {
    page.summary = update.summary;
  }
  page.sections = (page.sections || []).map((section) => {
    if (!Object.prototype.hasOwnProperty.call(update.bodies || {}, section.id)) return section;
    return { ...section, body: update.bodies[section.id] };
  });
  writeJson(update.source, page);
  return {
    batch: "48",
    tierRole: page.tierRole,
    sectionID: "page-visible-copy",
    sectionTitle: "Watch-row copy polish",
    pageID: page.id,
    phraseID: page.phraseID,
    sourcePath: update.source,
    before: {
      summary: before.summary,
      phraseCardCount: countCards(before),
      changedBodies: Object.fromEntries((before.sections || [])
        .filter((section) => Object.prototype.hasOwnProperty.call(update.bodies || {}, section.id))
        .map((section) => [section.id, section.body])),
    },
    after: {
      summary: page.summary,
      phraseCardCount: countCards(page),
      changedBodies: Object.fromEntries((page.sections || [])
        .filter((section) => Object.prototype.hasOwnProperty.call(update.bodies || {}, section.id))
        .map((section) => [section.id, section.body])),
    },
    preservedPhraseCards: countCards(page),
    concreteTravelerValueImproved: update.value,
    reason: "premium_audit_batch_48_watch_polish",
  };
}

function applySupportUpdates() {
  const source = "content-draft/viet/editorial-model-support/TASK-VIET-EDITORIAL-MODEL-SUPPORT-001/source/support-pages.json";
  const doc = readJson(source);
  const rows = [];
  for (const update of supportUpdates) {
    const record = doc.pages.find((page) => page.phraseID === update.phraseID);
    if (!record) throw new Error(`Missing support record ${update.phraseID}`);
    const before = {};
    const after = {};
    for (const [key, value] of Object.entries(update.fields)) {
      before[key] = record[key];
      record[key] = value;
      after[key] = value;
    }
    rows.push({
      batch: "48",
      tierRole: "editorial-model-support",
      sectionID: "page-visible-copy",
      sectionTitle: "Watch-row support copy polish",
      pageID: `viet-family-${update.phraseID}`,
      phraseID: update.phraseID,
      sourcePath: source,
      before,
      after,
      preservedPhraseCards: (record.relatedPhraseIDs || []).length + (record.explorePhraseIDs || []).length,
      concreteTravelerValueImproved: update.value,
      reason: "premium_audit_batch_48_watch_polish",
    });
  }
  writeJson(source, doc);
  return rows;
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const keys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}:${row.sectionID}`];
    } catch {
      return [];
    }
  }));
  const fresh = rows.filter((row) => !keys.has(`${row.reason}:${row.pageID}:${row.sectionID}`));
  if (fresh.length) {
    fs.appendFileSync(ledgerPath, `${fresh.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return fresh.length;
}

const ledgerRows = [
  ...pageUpdates.map(applyPageUpdate),
  ...applySupportUpdates(),
];

console.log(JSON.stringify({
  batch: "48",
  repairedPages: ledgerRows.length,
  pageIDs: ledgerRows.map((row) => row.pageID),
  ledgerRowsAdded: appendLedger(ledgerRows),
}, null, 2));
