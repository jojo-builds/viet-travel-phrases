#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(repoRoot, "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl");

const updates = [
  {
    id: "viet-phrase-v900-tran-can-you-break-this-bill",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-can-you-break-this-bill.json",
    summary: "For asking someone to change a large bill into smaller cash before a fare, tip, or counter payment gets awkward.",
    bodies: {
      "at-glance": "Use it when the amount is clear but the bill in your hand is too large for the next payment.",
    },
    value: "replaces title-only money summary with a practical small-cash payment moment"
  },
  {
    id: "viet-thanks-khong-co-gi",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/thank-you-khong-co-gi.json",
    bodies: {
      "good-to-know": "This reply is warm but small. Let it close the thank-you moment unless the other person keeps talking.",
    },
    value: "removes repeated politeness boilerplate from a common thank-you reply"
  },
  {
    id: "viet-phrase-v500-bath-pers-need-is-there-a-public-bathroom-nearby",
    source: "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-is-there-a-public-bathroom-nearby.json",
    summary: "For finding a public bathroom nearby when a cafe, station, park, or market does not make the direction obvious.",
    bodies: {
      "quick-say": "Ask with the place around you visible: station sign, cafe entrance, market row, or map screen.",
    },
    value: "turns title-summary bathroom copy into a concrete nearby-direction request"
  },
  {
    id: "viet-how-are-you",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/how-are-you-ban.json",
    bodies: {
      breakdown: "Bạn names the person in a friendly neutral way; khỏe checks whether they are well; không? makes it a light question.",
      "good-to-know": "This works best after a hello. In a rushed service moment, a smile and thank-you may be enough.",
    },
    value: "makes the neutral how-are-you page relationship-aware without removing cards"
  },
  {
    id: "viet-how-are-you-chi",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/how-are-you-chi.json",
    bodies: {
      breakdown: "Chị names an older woman; khỏe asks about being well; không? keeps the check-in gentle.",
      "good-to-know": "Use this only when chị clearly fits. If the relationship is uncertain, a neutral greeting is safer.",
    },
    value: "replaces repeated small-talk boilerplate with specific relationship guidance"
  },
  {
    id: "viet-phrase-v500-unde-repa-please-type-it-into-my-phone",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-please-type-it-into-my-phone.json",
    summary: "For handing over your phone so a price, address, name, or instruction can be typed instead of repeated.",
    bodies: {
      "when-to-use": "Good when spelling, pronunciation, noise, or fast speech is blocking the exact detail you need to keep.",
    },
    value: "replaces title-only repair summary with a concrete phone-handoff use case"
  },
  {
    id: "viet-da-chao-ba",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/acknowledge-da-chao-ba.json",
    bodies: {
      "standard-way": "Bà is for an elderly woman or grandmother-age person; the respectful dạ makes the greeting softer.",
      "good-to-know": "If bà feels too strong for the person in front of you, choose cô or chị instead.",
    },
    value: "removes use-it-when boilerplate from an age-specific greeting"
  },
  {
    id: "viet-da-chao-chi",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/acknowledge-da-chao-chi.json",
    bodies: {
      "standard-way": "Chị fits an older woman who is not elder-generation; dạ keeps the hello respectful but still everyday.",
      "good-to-know": "This is a safe greeting for many service moments with an older woman. Switch if the age relationship is clearly different.",
    },
    value: "adds relationship-specific greeting guidance without changing cards"
  },
  {
    id: "viet-da-chao-chu",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/acknowledge-da-chao-chu.json",
    bodies: {
      "standard-way": "Chú fits an older man in an uncle-age range; dạ makes the greeting polite without becoming formal.",
      "good-to-know": "Use anh for a younger older-man feel, ông for elderly, and chú when uncle-age sounds right.",
    },
    value: "turns a repeated greeting note into specific pronoun guidance"
  },
  {
    id: "viet-da-chao-ong",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/acknowledge-da-chao-ong.json",
    bodies: {
      "standard-way": "Ông is for an elderly man or grandfather-age person; dạ keeps the greeting respectful.",
      "good-to-know": "If ông feels too old for the person, use chú or anh. The relationship word changes the warmth of the hello.",
    },
    value: "replaces generic polite-copy with age-specific greeting judgment"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-can-i-show-it-on-my-phone",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-can-i-show-it-on-my-phone.json",
    summary: "For asking airport, hotel, or counter staff if a booking, QR code, ticket, or document can be shown digitally.",
    value: "replaces title-only airport summary with a digital-document travel moment"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-feel-nauseous",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-feel-nauseous.json",
    bodies: {
      "at-glance": "Use this when nausea is the symptom you need a pharmacist, clinic, guide, or hotel desk to understand first.",
    },
    value: "makes a repeated health opener symptom-specific"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-have-diabetes",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-diabetes.json",
    bodies: {
      "at-glance": "Say this before medicine, food, sugar, or clinic decisions so the helper understands the condition behind the request.",
    },
    value: "turns a repeated health opener into condition-specific medical context"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-take-this-medicine-every-day",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-take-this-medicine-every-day.json",
    bodies: {
      "at-glance": "Use it when dosage, side effects, interactions, or refills need to account for medicine you already take daily.",
    },
    value: "adds a concrete medication-history use case"
  },
  {
    id: "viet-phrase-v500-tran-i-feel-unsafe-please-stop",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-i-feel-unsafe-please-stop.json",
    bodies: {
      "at-glance": "Use this when the ride itself feels wrong and stopping is more important than finishing the route.",
    },
    value: "makes a repeated transport opener a safety-specific stop request"
  },
  {
    id: "viet-phrase-v500-tran-i-got-on-the-wrong-bus",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-i-got-on-the-wrong-bus.json",
    bodies: {
      "at-glance": "Use it as soon as the route, stop names, or direction shows you are on the wrong bus.",
    },
    value: "turns repeated transport copy into a route-recovery moment"
  },
  {
    id: "viet-phrase-v500-tran-please-let-me-out-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-let-me-out-here.json",
    bodies: {
      "at-glance": "Use this when the curb, entrance, landmark, or safety feeling says the ride should end at this spot.",
    },
    value: "makes the stop request location-specific"
  },
  {
    id: "viet-phrase-v500-tran-please-turn-around",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-turn-around.json",
    bodies: {
      "at-glance": "Use it when the car, bike, or walking route has passed the needed turn and must go back.",
    },
    value: "replaces repeated route copy with a turn-around correction"
  },
  {
    id: "viet-phrase-v900-tran-id-like-to-rent-a-motorbike",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-id-like-to-rent-a-motorbike.json",
    bodies: {
      "at-glance": "Use this at a rental desk when the practical next questions are license, price, helmet, deposit, and return time.",
    },
    value: "adds rental-specific context to a repeated transport opener"
  },
  {
    id: "viet-phrase-v900-tran-one-ticket-to-da-nang-please",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-one-ticket-to-da-nang-please.json",
    bodies: {
      "at-glance": "Use this at a bus, train, boat, or tour counter when destination and quantity are the two details that matter.",
    },
    value: "turns generic ticket copy into a destination-counter moment"
  },
  {
    id: "viet-phrase-v900-tran-pick-me-up-at-this-entrance",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-pick-me-up-at-this-entrance.json",
    bodies: {
      "at-glance": "Use this when the building has multiple doors and your pickup point needs to match the entrance on screen.",
    },
    value: "makes pickup copy entrance-specific"
  },
  {
    id: "viet-phrase-v900-tran-this-is-the-wrong-address",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-this-is-the-wrong-address.json",
    bodies: {
      "at-glance": "Use it when the address on the map, receipt, driver screen, or message does not match where you need to be.",
    },
    value: "adds concrete address-mismatch context"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-have-soup-on-the-side",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-soup-on-the-side.json",
    summary: "For asking to keep broth or soup separate so the dish stays the way you want it at the table or takeaway counter.",
    value: "replaces title-only food summary with a concrete side-soup request"
  },
  {
    id: "viet-phrase-v900-food-drin-please-pack-it-to-go",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-please-pack-it-to-go.json",
    summary: "For asking staff to pack remaining food or a fresh order for takeaway without reopening the whole order.",
    value: "adds a specific takeaway moment to a title-only food summary"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-i-have-more-drinking-water",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-i-have-more-drinking-water.json",
    summary: "For asking a hotel, homestay, or guesthouse for more drinking water when the room bottles are gone.",
    value: "replaces title-only hotel summary with a room-supply moment"
  },
  {
    id: "viet-acknowledge-co",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/acknowledge-co.json",
    bodies: {
      "good-to-know": "Có is short and useful, but it can feel abrupt by itself. Add dạ when the moment needs softness.",
    },
    value: "removes repeated warmth boilerplate from a yes/has response"
  },
  {
    id: "viet-acknowledge-khong",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/acknowledge-khong.json",
    bodies: {
      "good-to-know": "Không is clear, not decorative. Use a softer phrase when the refusal needs extra politeness.",
    },
    value: "adds practical tone guidance to a short no response"
  },
  {
    id: "viet-hello-chao-anh",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-anh.json",
    bodies: {
      "good-to-know": "Anh works for an older man in many everyday service moments; if he seems elder-generation, move to chú or ông.",
    },
    value: "turns repeated greeting boilerplate into relationship guidance"
  },
  {
    id: "viet-hello-chao-ba",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-ba.json",
    bodies: {
      "good-to-know": "Bà is respectful and elder-generation. Use it with care; cô or chị may fit a younger woman better.",
    },
    value: "adds age-specific nuance to a greeting page"
  },
  {
    id: "viet-hello-chao-ban",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-ban.json",
    bodies: {
      "good-to-know": "Bạn is friendly and neutral, but not always the warmest choice for older people. Relationship words can sound more natural.",
    },
    value: "makes neutral greeting copy more culturally specific"
  },
  {
    id: "viet-hello-chao-chi",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-chi.json",
    bodies: {
      "good-to-know": "Chị is warm for an older woman who is not elder-generation. The word carries respect and familiarity at once.",
    },
    value: "adds specific relationship tone to a greeting"
  },
  {
    id: "viet-hello-chao-chu",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-chu.json",
    bodies: {
      "good-to-know": "Chú has an uncle-age feeling. It is respectful without making the person sound elderly.",
    },
    value: "replaces repeated greeting boilerplate with age-range nuance"
  },
  {
    id: "viet-hello-chao-co",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-co.json",
    bodies: {
      "good-to-know": "Cô can mean auntie, teacher, or older woman depending on the setting. It often sounds warmer than bạn.",
    },
    value: "adds cultural nuance to a greeting form"
  },
  {
    id: "viet-hello-chao-em",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-em.json",
    bodies: {
      "good-to-know": "Em is friendly for someone younger, but it assumes the relationship. Use bạn if age feels unclear.",
    },
    value: "adds careful relationship guidance to a younger-person greeting"
  },
  {
    id: "viet-hello-chao-ong",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/hello-chao-ong.json",
    bodies: {
      "good-to-know": "Ông is elder-generation and respectful. Use chú or anh if the person is older but not elderly.",
    },
    value: "turns repeated greeting boilerplate into exact pronoun guidance"
  },
  {
    id: "viet-smalltalk-di-dau-day",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/smalltalk-di-dau-day.json",
    bodies: {
      "good-to-know": "This can sound friendly or nosy depending on context. Keep it light and use it with someone already chatting.",
    },
    value: "adds cultural tone judgment to a small-talk page"
  },
  {
    id: "viet-smalltalk-nice-to-meet-you",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/smalltalk-nice-to-meet-you.json",
    bodies: {
      "good-to-know": "This is a polite closer after introductions. Let the smile and pause do some of the work.",
    },
    value: "removes repeated warmth boilerplate from an introduction phrase"
  },
  {
    id: "viet-thanks-cam-on-nhieu",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/thank-you-cam-on-nhieu.json",
    bodies: {
      "good-to-know": "Nhiều adds extra warmth. Use it when someone did more than a tiny routine favor.",
    },
    value: "adds degree-specific guidance to a thank-you phrase"
  },
  {
    id: "viet-thanks-khong-cam-on",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/thank-you-khong-cam-on.json",
    bodies: {
      "good-to-know": "This refusal is polite but still clear. Use it before the seller or driver invests more effort.",
    },
    value: "makes no-thank-you copy concrete to shopping and ride moments"
  },
  {
    id: "viet-phrase-food-premium-which-dish-safe",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-premium-which-dish-safe.json",
    bodies: {
      "quick-say": "Show the allergy or restriction first, then ask which dish is safest before ordering.",
      "good-to-know": "A safe dish needs a clear answer, not just a friendly nod. Ask again if the reply feels vague.",
    },
    value: "removes lead-with-question scaffold from a food-safety page"
  }
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
}

function sectionCardTargets(section) {
  return (section.phrases || []).map((card) => card.detailPageID || card.id);
}

function allCardTargets(page) {
  return (page.sections || []).flatMap(sectionCardTargets);
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}:${row.sectionID}`];
    } catch {
      return [];
    }
  }));
  const freshRows = rows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}:${row.sectionID}`));
  if (freshRows.length) {
    fs.appendFileSync(ledgerPath, `${freshRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return freshRows.length;
}

const ledgerRows = [];
const missingSections = [];

for (const update of updates) {
  const page = readJson(update.source);
  const before = JSON.parse(JSON.stringify(page));
  if (update.summary) page.summary = update.summary;
  page.sections = (page.sections || []).map((section) => {
    if (!update.bodies || !Object.prototype.hasOwnProperty.call(update.bodies, section.id)) return section;
    return { ...section, body: update.bodies[section.id] };
  });
  for (const sectionID of Object.keys(update.bodies || {})) {
    if (!(before.sections || []).some((section) => section.id === sectionID)) {
      missingSections.push(`${update.id}:${sectionID}`);
    }
  }
  writeJson(update.source, page);
  ledgerRows.push({
    batch: "47",
    tierRole: page.tierRole,
    sectionID: "page-visible-copy",
    sectionTitle: "Page visible copy",
    pageID: page.id,
    phraseID: page.phraseID,
    sourcePath: update.source,
    before: {
      summary: before.summary,
      editedSections: Object.fromEntries(Object.keys(update.bodies || {}).map((sectionID) => [
        sectionID,
        (before.sections || []).find((section) => section.id === sectionID)?.body || null
      ])),
      cardTargets: allCardTargets(before),
      phraseCardCount: countSectionItems(before, "phrases"),
      breakdownRows: countSectionItems(before, "breakdown"),
      issues: ["weak repeated visible copy", "title-only summary", "formulaic follow-up wording"],
    },
    after: {
      summary: page.summary,
      editedSections: Object.fromEntries(Object.keys(update.bodies || {}).map((sectionID) => [
        sectionID,
        (page.sections || []).find((section) => section.id === sectionID)?.body || null
      ])),
      cardTargets: allCardTargets(page),
      phraseCardCount: countSectionItems(page, "phrases"),
      breakdownRows: countSectionItems(page, "breakdown"),
    },
    preservedPhraseCards: countSectionItems(page, "phrases"),
    preservedBreakdownRows: countSectionItems(page, "breakdown"),
    concreteTravelerValueImproved: update.value,
    reason: "premium_audit_batch_47_weak_cluster_polish"
  });
}

const ledgerRowsAdded = appendLedger(ledgerRows);

console.log(JSON.stringify({
  batch: "47",
  updatedPages: updates.length,
  pageIDs: updates.map((update) => update.id),
  missingSections,
  ledgerRowsAdded
}, null, 2));
