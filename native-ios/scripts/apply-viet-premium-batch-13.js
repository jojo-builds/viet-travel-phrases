#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "../..");
const ledgerPath = path.join(
  repoRoot,
  "docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl"
);

const repairs = [
  {
    id: "viet-phrase-v500-shop-can-i-touch-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v500-shop-can-i-touch-it.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v500-shop-can-i-touch-it.json",
    summary: "For asking before handling clothing, ceramics, souvenirs, or display items in a shop.",
    beforeSummary: "Can I touch it?",
    bodies: {
      "at-glance": "Ask before picking up anything fragile, handmade, sealed, or displayed behind the counter.",
      "quick-say": "Point to the item first. A small pause gives staff room to say yes, no, or only with help.",
      breakdown: "Tôi có thể asks can I; chạm vào nó means touch it; được không softens the request.",
      "natural-variants": "If staff says yes, move to size, color, try-on, or exchange follow-ups.",
      "when-to-use": "Good in markets, boutiques, souvenir shops, galleries, and counters with breakable items.",
      "good-to-know": "Some sellers prefer to hand items to you. Let them pick up ceramics, jewelry, or wrapped goods first.",
      "explore-next": "Use just-looking, where-to-pay, try-on, size, or exchange follow-ups as the shopping moment changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I request frame" },
      { id: "chunk-2", vietnamese: "chạm vào nó", english: "touch it", keepTogetherReason: "touch-the-item phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a bare shopping question into a respectful ask-before-handling page without removing any cards"
  },
  {
    id: "viet-phrase-v500-time-date-book-can-i-change-the-time",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-can-i-change-the-time.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v500-time-date-book-can-i-change-the-time.json",
    summary: "For moving a booking time without restarting the whole plan.",
    beforeSummary: "Can I change the time?",
    bodies: {
      "at-glance": "The day still works, but the hour needs to move.",
      "quick-say": "Show the booking, ticket, or message thread first. Then ask and let staff check the schedule.",
      breakdown: "Tôi có thể asks can I; thay đổi thời gian means change the time; được không asks if it is possible.",
      "natural-variants": "If they ask for a replacement, move to today, tomorrow morning, what time, or move-it-later follow-ups.",
      "when-to-use": "Good at tour desks, salons, clinics, transport counters, hotel desks, and booking chats.",
      "good-to-know": "Time changes are easier before payment, pickup, or a fixed ticket window. Keep the original time visible.",
      "explore-next": "Use booking, opening-time, later, tomorrow, or call-my-name follow-ups if the schedule needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "thay đổi", english: "change", keepTogetherReason: "change action" },
      { id: "chunk-3", vietnamese: "thời gian", english: "the time", keepTogetherReason: "time phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the time-change page about a real rescheduling moment instead of repeating the title"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-where-can-i-charge-my-phone",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-can-i-charge-my-phone.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-can-i-charge-my-phone.json",
    summary: "For finding a safe place to plug in before your phone battery dies at the airport.",
    beforeSummary: "Where can I charge my phone?",
    bodies: {
      "at-glance": "Ask near information desks, cafes, boarding areas, or luggage counters when the battery is low.",
      "quick-say": "Show the cable or battery screen if needed. You are asking for a place, not a borrowed charger.",
      breakdown: "Sạc điện thoại means charge a phone; ở đâu asks where.",
      "natural-variants": "If the battery problem changes the plan, move to Wi-Fi, SIM, pickup, or information-desk follow-ups.",
      "when-to-use": "Good after a long flight, during a delay, before calling a driver, or before opening a mobile ticket.",
      "good-to-know": "Airport outlets can be tucked near cafes, columns, or paid lounges. Watch where staff points.",
      "explore-next": "Use pickup-area, driver, SIM, Wi-Fi, or baggage follow-ups if the phone issue is part of arrival logistics."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "sạc điện thoại", english: "charge my phone", keepTogetherReason: "phone-charging phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "reframes the airport phone page around low-battery arrival logistics and keeps all follow-up cards"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-you-arrange-a-taxi-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-arrange-a-taxi-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-arrange-a-taxi-for-me.json",
    summary: "For asking the hotel desk to book a taxi tied to your address, room, or departure time.",
    beforeSummary: "Can you arrange a taxi for me?",
    bodies: {
      "at-glance": "Ask before you are already late, especially for airport rides, dinner plans, or early tours.",
      "quick-say": "Have the destination and pickup time ready. The desk may ask room number, car size, or cash/card preference.",
      breakdown: "Bạn có thể asks can you; sắp xếp một chiếc taxi cho tôi means arrange a taxi for me; được không softens the request.",
      "natural-variants": "If the desk needs details, move to address, airport, driver-call, wait-here, or pay-by-card follow-ups.",
      "when-to-use": "Good at hotel desks, guesthouses, serviced apartments, and tour counters helping with local transport.",
      "good-to-know": "Hotel-arranged taxis may cost more than an app ride, but the desk can help if the driver needs directions.",
      "explore-next": "Use checkout, quiet-room, luggage, address, or airport-car follow-ups depending on why you need the taxi."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you request frame" },
      { id: "chunk-2", vietnamese: "sắp xếp", english: "arrange", keepTogetherReason: "arrange action" },
      { id: "chunk-3", vietnamese: "một chiếc taxi cho tôi", english: "a taxi for me", keepTogetherReason: "taxi-for-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the hotel-taxi request operational, with pickup time and destination context instead of generic front-desk copy"
  },
  {
    id: "viet-phrase-v900-tran-please-avoid-toll-roads",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-avoid-toll-roads.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-avoid-toll-roads.json",
    summary: "For telling a driver you want a route without toll roads before the ride is underway.",
    beforeSummary: "Please avoid toll roads",
    bodies: {
      "at-glance": "Say it before the driver chooses the route, especially on airport, highway, or intercity trips.",
      "quick-say": "Keep the map open and say the line calmly. If price matters, point to the toll road or route option.",
      breakdown: "Vui lòng means please; tránh means avoid; đường thu phí means toll roads.",
      "natural-variants": "If the route changes, move to stop-here, go-this-way, District 1, or take-me-here follow-ups.",
      "when-to-use": "Good in taxis, private cars, app rides, and shuttle arrangements before the driver commits to a highway.",
      "good-to-know": "Avoiding tolls can make the ride longer. Confirm whether time or price matters more before you insist.",
      "explore-next": "Use stop-here, go-this-way, air-conditioning, fare, or address follow-ups if the ride needs another adjustment."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "tránh", english: "avoid", keepTogetherReason: "avoid action" },
      { id: "chunk-3", vietnamese: "đường thu phí", english: "toll roads", keepTogetherReason: "toll-road phrase" }
    ],
    value: "turns a route preference into a clear pre-ride instruction with the cost/time tradeoff visible"
  },
  {
    id: "viet-phrase-v500-prob-help-where-is-the-police-station",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-where-is-the-police-station.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-where-is-the-police-station.json",
    summary: "For finding the police station when a report, lost item, or safety issue needs an official desk.",
    beforeSummary: "Where is the police station?",
    bodies: {
      "at-glance": "Ask for the station, then be ready to show the map, hotel card, photo, or last known location.",
      "quick-say": "Keep it direct. If the situation is urgent, say you need help now before asking for directions.",
      breakdown: "Đồn cảnh sát means police station; ở đâu asks where.",
      "natural-variants": "If the first answer is not enough, move to lost, left-something, contact-information, or call-hotel follow-ups.",
      "when-to-use": "Good at hotel desks, shop counters, transport desks, or with someone helping you find official help.",
      "good-to-know": "Staff may point you to a ward-level station or suggest calling first. A hotel address can help.",
      "explore-next": "Use need-help, hotel-call, manager, report, or contact-information follow-ups once you reach the right desk."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đồn cảnh sát", english: "police station", keepTogetherReason: "police-station phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "moves the police-station page from generic directions into a calm official-help handoff"
  },
  {
    id: "viet-phrase-v500-soci-smal-talk-where-can-i-wait-out-the-rain",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-where-can-i-wait-out-the-rain.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-where-can-i-wait-out-the-rain.json",
    summary: "For asking where to stand or sit until a sudden rain shower passes.",
    beforeSummary: "Where can I wait out the rain?",
    bodies: {
      "at-glance": "Vietnam rain can arrive fast. Ask before ducking into a cafe, lobby, shopfront, or covered doorway.",
      "quick-say": "Smile, point outside, and keep the question light. You are asking for a short shelter suggestion.",
      breakdown: "Tôi có thể asks can I; chờ mưa means wait out the rain; ở đâu asks where.",
      "natural-variants": "If the chat continues, move to weather, first-time, where-you-are-from, or like-Vietnam follow-ups.",
      "when-to-use": "Good during afternoon showers, market walks, beach days, and cafe stops when the street suddenly floods.",
      "good-to-know": "A quick rain pause can become a friendly small-talk moment. Buy a drink if you end up staying inside.",
      "explore-next": "Use weather, food, first-time, or where-from follow-ups if the shelter question turns into conversation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "chờ mưa", english: "wait out the rain", keepTogetherReason: "rain-waiting phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "makes the rain page feel like an observed Vietnam travel moment instead of generic small-talk scaffolding"
  },
  {
    id: "viet-phrase-v500-tran-i-left-something-in-the-car",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-i-left-something-in-the-car.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-i-left-something-in-the-car.json",
    summary: "For telling a driver or desk that a bag, phone, wallet, or small item stayed in the car.",
    beforeSummary: "I left something in the car",
    bodies: {
      "at-glance": "Use it as soon as you notice the missing item, while the ride, plate, or driver contact is still available.",
      "quick-say": "Show the booking, plate number, or driver message first. Then say what item you left if they ask.",
      breakdown: "Tôi để quên means I left behind; thứ gì đó means something; trong xe means in the car.",
      "natural-variants": "If recovery takes another step, move to call-driver, contact-information, hotel-call, or report follow-ups.",
      "when-to-use": "Good after taxis, app rides, private cars, hotel pickups, and tour vans.",
      "good-to-know": "The faster you ask, the better. Plate number, pickup point, and drop-off time matter more than a long story.",
      "explore-next": "Use stop-here, go-this-way, driver-call, contact-information, or left-something follow-ups as the recovery path changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi để quên", english: "I left behind", keepTogetherReason: "left-behind phrase" },
      { id: "chunk-2", vietnamese: "thứ gì đó", english: "something", keepTogetherReason: "something phrase" },
      { id: "chunk-3", vietnamese: "trong xe", english: "in the car", keepTogetherReason: "in-car phrase" }
    ],
    value: "turns the transport page into a concrete lost-item recovery moment with no phrase-card loss"
  },
  {
    id: "viet-phrase-v500-tran-please-lower-the-music",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-lower-the-music.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-lower-the-music.json",
    summary: "For asking a driver to turn the music down without making the ride feel tense.",
    beforeSummary: "Please lower the music",
    bodies: {
      "at-glance": "Ask when the music is too loud for calls, directions, nausea, or a tired ride back.",
      "quick-say": "A small hand-lowering gesture makes the request clear. Keep your voice calm and let the driver answer.",
      breakdown: "Làm ơn means please; giảm nhạc means lower the music; đi gives the request a spoken ending.",
      "natural-variants": "If comfort is still the issue, move to slower driving, air-conditioning, stop-here, or wait-here follow-ups.",
      "when-to-use": "Good in taxis, app rides, vans, and private cars when the volume is the problem.",
      "good-to-know": "Keep the tone light. A gesture plus the phrase usually lands better than repeating in English.",
      "explore-next": "Use stop-here, go-this-way, air-conditioning, drive-slower, or wait-here cards if the ride still needs adjusting."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Làm ơn", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "giảm nhạc", english: "lower the music", keepTogetherReason: "lower-music phrase" },
      { id: "chunk-3", vietnamese: "đi", english: "spoken request ending", keepTogetherReason: "imperative softener" }
    ],
    value: "makes the comfort request specific and tactful instead of generic transport prose"
  },
  {
    id: "viet-phrase-v500-unde-repa-can-you-spell-the-name",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-spell-the-name.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-can-you-spell-the-name.json",
    summary: "For getting a hotel, street, passenger, or contact name letter by letter.",
    beforeSummary: "Can you spell the name?",
    bodies: {
      "at-glance": "Ask when hearing the name is not enough and a written spelling would prevent mistakes.",
      "quick-say": "Show the form, phone, map, or booking field. Let them spell slowly or type it for you.",
      breakdown: "Bạn có thể asks can you; đánh vần means spell; tên means name; được không softens the request.",
      "natural-variants": "If spelling is still unclear, move to repeat, write-it-down, speak-slower, or type-into-phone follow-ups.",
      "when-to-use": "Good with hotel names, street names, passenger names, contact names, and booking records.",
      "good-to-know": "Names can sound familiar but be written differently. A typed version is safer than a guessed spelling.",
      "explore-next": "Use say-again, write-down, meaning, spell, or type-into-phone follow-ups as the repair moment continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "đánh vần", english: "spell", keepTogetherReason: "spell action" },
      { id: "chunk-3", vietnamese: "tên", english: "the name", keepTogetherReason: "name phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the repair page about preventing name/address mistakes rather than a generic slow-speech page"
  },
  {
    id: "viet-phrase-v500-unde-repa-do-you-mean-this-one",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-do-you-mean-this-one.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-do-you-mean-this-one.json",
    summary: "For confirming the exact item, option, button, address, or person before you agree.",
    beforeSummary: "Do you mean this one?",
    bodies: {
      "at-glance": "Pointing can be clearer than another long explanation.",
      "quick-say": "Point to the item, screen, map location, or written line. Keep the question short and wait for yes or no.",
      breakdown: "Ý bạn là means you mean; cái này means this one; phải không asks for confirmation.",
      "natural-variants": "If the answer is not clear, move to repeat, point-to-it, translation-correct, or write-it-down follow-ups.",
      "when-to-use": "Good with menus, forms, maps, shop items, ticket options, names, and app screens.",
      "good-to-know": "This line is helpful when both people can see the same thing. Point first, then ask.",
      "explore-next": "Use say-again, write-down, meaning, point-to-it, or translation-correct cards if confirmation needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Ý bạn là", english: "you mean", keepTogetherReason: "meaning-confirmation frame" },
      { id: "chunk-2", vietnamese: "cái này", english: "this one", keepTogetherReason: "this-one phrase" },
      { id: "chunk-3", vietnamese: "phải không?", english: "right?", keepTogetherReason: "confirmation ending" }
    ],
    value: "turns the confirmation page into a concrete point-and-check tool without altering card richness"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-is-there-a-shuttle-between-terminals",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-is-there-a-shuttle-between-terminals.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-is-there-a-shuttle-between-terminals.json",
    summary: "For checking whether airport terminals are connected by shuttle before walking the wrong way.",
    beforeSummary: "Is there a shuttle between terminals?",
    bodies: {
      "at-glance": "Ask before leaving the arrivals hall, baggage area, or check-in zone for another terminal.",
      "quick-say": "Show the terminal number, boarding pass, or flight screen. The answer may be shuttle, walkway, or taxi.",
      breakdown: "Có asks is there; xe đưa đón means shuttle; giữa các nhà ga means between terminals.",
      "natural-variants": "If the route changes, move to terminal, departure hall, information desk, or shuttle-between-terminals follow-ups.",
      "when-to-use": "Good after landing, during a transfer, or when domestic and international terminal signs are not obvious.",
      "good-to-know": "Some airport transfers are close; others need a bus, taxi, or staff direction. Confirm before you start walking.",
      "explore-next": "Use pickup-area, driver, baggage, terminal, or information-desk cards if the transfer has another detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is there", keepTogetherReason: "existence question opener" },
      { id: "chunk-2", vietnamese: "xe đưa đón", english: "shuttle", keepTogetherReason: "shuttle phrase" },
      { id: "chunk-3", vietnamese: "giữa các nhà ga", english: "between terminals", keepTogetherReason: "between-terminals phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the terminal-shuttle page into a concrete airport transfer check instead of generic arrival copy"
  }
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(path.join(repoRoot, relPath), `${JSON.stringify(value, null, 2)}\n`);
}

function phraseCardCount(page) {
  return (page.sections ?? []).reduce((total, section) => total + (section.phrases ?? []).length, 0);
}

function breakdownCount(page) {
  return (page.sections ?? []).reduce((total, section) => total + (section.breakdown ?? []).length, 0);
}

function sectionBodies(page) {
  return Object.fromEntries((page.sections ?? []).map((section) => [section.id, section.body]));
}

function updateSource(repair) {
  const page = readJson(repair.source);
  const before = {
    summary: page.summary,
    sections: sectionBodies(page),
    phraseCards: phraseCardCount(page),
    breakdownRows: breakdownCount(page)
  };

  page.summary = repair.summary;
  for (const section of page.sections ?? []) {
    if (repair.bodies[section.id]) section.body = repair.bodies[section.id];
    if (section.id === "breakdown") {
      section.breakdown = [
        ...repair.breakdown.map((entry) => ({ ...entry, audioKey: null })),
        {
          id: `chunk-${repair.breakdown.length + 1}`,
          vietnamese: page.title,
          english: page.englishTitle,
          audioKey: page.audioKey ?? null
        }
      ];
    }
  }

  writeJson(repair.source, page);
  return {
    page,
    before,
    after: {
      summary: page.summary,
      sections: sectionBodies(page),
      phraseCards: phraseCardCount(page),
      breakdownRows: breakdownCount(page)
    }
  };
}

function updateAudit(repair, page) {
  const audit = readJson(repair.audit);
  audit.phraseText = page.title;
  audit.englishTitle = page.englishTitle;
  audit.tokens = [
    ...repair.breakdown.map((entry) => ({ ...entry })),
    {
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    }
  ];
  writeJson(repair.audit, audit);
}

function main() {
  const ledgerRows = [];
  for (const repair of repairs) {
    const { page, before, after } = updateSource(repair);
    updateAudit(repair, page);
    ledgerRows.push({
      batch: 13,
      tierRole: page.tierRole,
      sectionID: "page-visible-copy",
      sectionTitle: "Page visible copy",
      pageID: page.id,
      phraseID: page.phraseID,
      sourcePath: repair.source,
      before: {
        summary: repair.beforeSummary ?? before.summary,
        issues: [
          "title-as-summary",
          "formulaic projection prose",
          "source/rendered breakdown mismatch risk"
        ]
      },
      after: {
        summary: after.summary,
        sections: {
          atGlance: after.sections["at-glance"],
          quickSay: after.sections["quick-say"],
          breakdown: after.sections.breakdown
        }
      },
      preservedPhraseCards: after.phraseCards,
      preservedBreakdownRows: after.breakdownRows,
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_13"
    });
  }

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const hasBatch13Rows = existingLedgerRows.some((line) => {
    try {
      const row = JSON.parse(line);
      return row.batch === 13 || row.reason === "premium_audit_batch_13";
    } catch {
      return false;
    }
  });

  if (!hasBatch13Rows) {
    fs.appendFileSync(ledgerPath, `${ledgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 13,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    ledgerRows: hasBatch13Rows ? 0 : ledgerRows.length,
    ledgerSkippedAlreadyPresent: hasBatch13Rows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
