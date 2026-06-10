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
    id: "viet-phrase-v900-dire-navi-please-point-me-in-the-right-direction",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-please-point-me-in-the-right-direction.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-please-point-me-in-the-right-direction.json",
    summary: "For asking someone to show the right way when the map is close but the next turn is unclear.",
    beforeSummary: "Please point me in the right direction",
    bodies: {
      "at-glance": "Ask when you can show the destination but still need a local to point the next move.",
      "quick-say": "Show the map or address first. Let the answer be a gesture, a turn, or a short landmark.",
      breakdown: "Xin hãy is a polite please; chỉ cho tôi means point or show me; đi đúng hướng means go the right way.",
      "natural-variants": "If the route still feels unclear, ask how to get there, whether it is near, or how long it takes on foot.",
      "when-to-use": "Good at street corners, station exits, hotel desks, ticket counters, and shopfronts near your destination.",
      "good-to-know": "A pointed answer may be enough. Watch the gesture before asking for a longer explanation.",
      "explore-next": "Move to left, right, straight, pickup point, or wrong-way follow-ups if the route needs another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy", english: "please", keepTogetherReason: "polite request opener" },
      { id: "chunk-2", vietnamese: "chỉ cho tôi", english: "point out / show me", keepTogetherReason: "pointing-help phrase" },
      { id: "chunk-3", vietnamese: "đi đúng hướng", english: "go the right way", keepTogetherReason: "right-direction phrase" }
    ],
    value: "turns the page into a map-and-gesture direction handoff instead of generic route scaffolding"
  },
  {
    id: "viet-phrase-v900-dire-navi-where-is-the-nearest-convenience-store",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-nearest-convenience-store.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-nearest-convenience-store.json",
    summary: "For finding a nearby minimart for water, snacks, SIM top-up, tissues, or small essentials.",
    beforeSummary: "Where is the nearest convenience store?",
    bodies: {
      "at-glance": "Ask when you need the closest shop, not a market recommendation across town.",
      "quick-say": "Say the question near a hotel, cafe, station, or street corner. Staff may point to a Circle K, WinMart, or small local shop.",
      breakdown: "Cửa hàng tiện lợi means convenience store; gần nhất means nearest; ở đâu asks where.",
      "natural-variants": "If the answer points you onward, ask how to get there, whether it is near, or how long the walk takes.",
      "when-to-use": "Good for late-night water, snacks, toiletries, SIM help, rain ponchos, and small travel fixes.",
      "good-to-know": "The nearest option may be a branded minimart or a family-run shop. Follow the gesture, then look for lit signs.",
      "explore-next": "Use left, right, straight, bus-stop, or how-far follow-ups if the directions need one more detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cửa hàng tiện lợi", english: "convenience store", keepTogetherReason: "shop-type phrase" },
      { id: "chunk-2", vietnamese: "gần nhất", english: "nearest", keepTogetherReason: "nearest phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "makes the convenience-store page specific to quick travel errands and nearby minimarts"
  },
  {
    id: "viet-phrase-v900-dire-navi-where-is-the-train-station",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-train-station.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-train-station.json",
    summary: "For getting pointed toward the railway station before you commit to a taxi, walk, or wrong entrance.",
    beforeSummary: "Where is the train station?",
    bodies: {
      "at-glance": "Ask when the station is nearby but the entrance, platform side, or street approach is not obvious.",
      "quick-say": "Show the ticket, station name, or map if you have it. The answer may be a direction, entrance, or taxi suggestion.",
      breakdown: "Nhà ga xe lửa means train station; ở đâu asks where.",
      "natural-variants": "If the route is still fuzzy, ask how to get there, whether it is near, or how long the walk takes.",
      "when-to-use": "Good near hotels, bus stops, market streets, and city centers when a station trip is next.",
      "good-to-know": "Some stations have several gates or taxi drop-off points. Ask again if the entrance is not visible.",
      "explore-next": "Use left, right, straight, elevator, or train-delay follow-ups once you are moving toward the station."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nhà ga xe lửa", english: "train station", keepTogetherReason: "train-station phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "grounds the train-station page in entrances, tickets, and local pointing instead of broad directions prose"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-you-print-my-document-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-print-my-document-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-print-my-document-for-me.json",
    summary: "For asking a hotel or guesthouse desk to print a visa page, ticket, form, or booking document.",
    beforeSummary: "Can you print my document for me?",
    bodies: {
      "at-glance": "Ask before you need the paper urgently, especially for transport, embassy, visa, or clinic paperwork.",
      "quick-say": "Have the file open, emailed, or ready on a USB drive. Ask whether they can print it and how much it costs.",
      breakdown: "Bạn có thể asks can you; in tài liệu means print a document; cho tôi means for me; được không softens the request.",
      "natural-variants": "If the desk needs context, move to reservation, checkout, email, receipt, or document follow-ups.",
      "when-to-use": "Good at hotel desks, guesthouses, coworking counters, travel agencies, and reception areas with a printer nearby.",
      "good-to-know": "Some desks will ask you to email the file. Remove private pages before sending anything sensitive.",
      "explore-next": "Use checkout, quiet-room, receipt, email, or front-desk cards if the print request becomes a hotel task."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you request frame" },
      { id: "chunk-2", vietnamese: "in tài liệu", english: "print a document", keepTogetherReason: "print-document phrase" },
      { id: "chunk-3", vietnamese: "cho tôi", english: "for me", keepTogetherReason: "for-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a generic hotel request into a real front-desk printing task with privacy and timing context"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-can-you-process-a-refund",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-you-process-a-refund.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-can-you-process-a-refund.json",
    summary: "For asking whether a shop, counter, app desk, or ticket office can start a refund.",
    beforeSummary: "Can you process a refund?",
    bodies: {
      "at-glance": "Ask while the receipt, booking, charge, or item is visible.",
      "quick-say": "Show the proof first. Then ask whether they can process the refund or need a manager.",
      breakdown: "Bạn có thể asks can you; xử lý means process; hoàn tiền means refund.",
      "natural-variants": "If the answer changes, move to final price, receipt, manager, refund difference, or charged-twice follow-ups.",
      "when-to-use": "Good at ticket counters, shops, tour desks, hotel desks, and payment counters after a mistake or cancellation.",
      "good-to-know": "Refunds may go back to the original card or need manager approval. Keep the receipt and payment screen open.",
      "explore-next": "Use receipt, manager, charged-twice, refund-difference, or final-price follow-ups if the refund needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "xử lý", english: "process", keepTogetherReason: "process action" },
      { id: "chunk-3", vietnamese: "hoàn tiền", english: "refund", keepTogetherReason: "refund phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the refund page about proof, manager approval, and payment flow rather than generic money copy"
  },
  {
    id: "viet-phrase-v900-shop-can-you-show-me-the-inside",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-can-you-show-me-the-inside.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-can-you-show-me-the-inside.json",
    summary: "For asking to see inside a bag, box, case, room, or wrapped item before deciding.",
    beforeSummary: "Can you show me the inside?",
    bodies: {
      "at-glance": "Ask before opening something yourself, especially if it is sealed, fragile, or behind the counter.",
      "quick-say": "Point to the item and wait for staff to open it. This keeps the request polite and easy to refuse.",
      breakdown: "Bạn có thể asks can you; cho tôi xem means show me; bên trong means inside; được không softens the request.",
      "natural-variants": "If the item still needs checking, move to size, color, try-on, or touch-it follow-ups.",
      "when-to-use": "Good in shops, markets, boutiques, luggage stores, souvenir stalls, and hotel-room checks.",
      "good-to-know": "Let staff handle packaging or fragile goods first. A careful request protects both sides.",
      "explore-next": "Use just-looking, pay-where, exchange, touch-it, or smaller-size follow-ups as the shopping decision changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you request frame" },
      { id: "chunk-2", vietnamese: "cho tôi xem", english: "show me", keepTogetherReason: "show-me phrase" },
      { id: "chunk-3", vietnamese: "bên trong", english: "inside", keepTogetherReason: "inside phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the inside-check page concrete and tactful while preserving the shopping follow-up set"
  },
  {
    id: "viet-phrase-v900-shop-do-you-have-a-smaller-size",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-do-you-have-a-smaller-size.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-do-you-have-a-smaller-size.json",
    summary: "For asking for a smaller size while the item, tag, or sample is in front of you.",
    beforeSummary: "Do you have a smaller size?",
    bodies: {
      "at-glance": "Ask with the item in hand so staff knows which cut, shoe, shirt, or packet you mean.",
      "quick-say": "Point to the tag or hold up the item. The answer may be another size, another color, or no stock.",
      breakdown: "Bạn có asks do you have; kích thước nhỏ hơn means a smaller size; không makes it a yes/no question.",
      "natural-variants": "If the size is close, move to this-size, another-color, try-on, or show-inside follow-ups.",
      "when-to-use": "Good for clothes, shoes, helmets, bags, packaged goods, and anything sold in size options.",
      "good-to-know": "Vietnam sizing can vary by shop. Pointing to the tag is clearer than translating a size system.",
      "explore-next": "Use try-on, color, touch-it, exchange, or pay-where cards if the shopping choice continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "do-you-have frame" },
      { id: "chunk-2", vietnamese: "kích thước nhỏ hơn", english: "a smaller size", keepTogetherReason: "smaller-size phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "anchors the smaller-size page to tags, stock, and real shop interaction instead of generic shopping prose"
  },
  {
    id: "viet-phrase-v900-time-date-book-can-i-have-a-window-seat",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-can-i-have-a-window-seat.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-can-i-have-a-window-seat.json",
    summary: "For asking for a window seat while booking or checking in for a bus, train, flight, or tour vehicle.",
    beforeSummary: "Can I have a window seat?",
    bodies: {
      "at-glance": "Ask before the seat is assigned, not after everyone is already boarding.",
      "quick-say": "Show the ticket or booking screen. Staff may answer with available, sold out, or a different row.",
      breakdown: "Tôi có thể asks can I; ngồi cạnh cửa sổ means sit by the window; được không softens the request.",
      "natural-variants": "If seating changes, move to seats-together, change-time, booking, or ticket follow-ups.",
      "when-to-use": "Good at bus desks, train counters, airport check-in, tour offices, and message threads before travel.",
      "good-to-know": "Window seats may depend on vehicle type, fare class, or how early you ask.",
      "explore-next": "Use booking, opening-time, move-later, seats-together, or ticket follow-ups if the booking needs another adjustment."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I request frame" },
      { id: "chunk-2", vietnamese: "ngồi cạnh cửa sổ", english: "sit by the window", keepTogetherReason: "window-seat phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the window-seat page useful for real booking and check-in moments"
  },
  {
    id: "viet-phrase-v900-tran-does-that-include-tolls",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-does-that-include-tolls.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-does-that-include-tolls.json",
    summary: "For checking whether the quoted ride price already includes tolls.",
    beforeSummary: "Does that include tolls?",
    bodies: {
      "at-glance": "Ask before agreeing to the fare, especially on airport, highway, or long-distance rides.",
      "quick-say": "Point to the price or ride screen first. You are checking whether another road fee will appear later.",
      breakdown: "Điều đó means that; có bao gồm means include; phí cầu đường means tolls.",
      "natural-variants": "If the price changes, move to avoid tolls, final price, pay-by-card, or cash follow-ups.",
      "when-to-use": "Good with taxis, private cars, app rides, station counters, and hotel-arranged transport.",
      "good-to-know": "Some drivers quote fare only; others include fees. Confirm before the car leaves.",
      "explore-next": "Use avoid-tolls, stop-here, go-this-way, card-payment, or final-price follow-ups if the ride cost needs another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Điều đó", english: "that", keepTogetherReason: "that-reference phrase" },
      { id: "chunk-2", vietnamese: "có bao gồm", english: "include", keepTogetherReason: "include phrase" },
      { id: "chunk-3", vietnamese: "phí cầu đường", english: "tolls", keepTogetherReason: "toll-fee phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a toll question into a clear fare-check page with cost context"
  },
  {
    id: "viet-phrase-v900-tran-please-turn-right-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-turn-right-here.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-turn-right-here.json",
    summary: "For giving a driver a simple turn instruction while the map or street is visible.",
    beforeSummary: "Please turn right here",
    bodies: {
      "at-glance": "Say it before the corner, not after the driver has passed the turn.",
      "quick-say": "Point lightly or show the map as you say it. Keep the phrase short so the driver can act quickly.",
      breakdown: "Vui lòng means please; rẽ phải means turn right; ở đây means here.",
      "natural-variants": "If the route keeps changing, move to stop-here, go-this-way, take-me-here, or correct-address follow-ups.",
      "when-to-use": "Good in taxis, app rides, motorbike taxis, private cars, and hotel-arranged transport.",
      "good-to-know": "Short route instructions land best before the intersection. Pair the phrase with the map if traffic is busy.",
      "explore-next": "Use stop-here, go-this-way, air-conditioning, correct-address, or avoid-tolls cards as the ride changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "rẽ phải", english: "turn right", keepTogetherReason: "turn-right phrase" },
      { id: "chunk-3", vietnamese: "ở đây", english: "here", keepTogetherReason: "here phrase" }
    ],
    value: "makes the turn-right page an immediate driver instruction with timing context"
  },
  {
    id: "viet-phrase-v900-tran-this-is-the-correct-address",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-this-is-the-correct-address.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-this-is-the-correct-address.json",
    summary: "For confirming the driver, desk, or delivery helper is looking at the right address.",
    beforeSummary: "This is the correct address",
    bodies: {
      "at-glance": "The map location, booking, street number, or hotel address is being questioned; this confirms the right one.",
      "quick-say": "Show the address and say the line once. Let the other person compare it with their screen or notes.",
      breakdown: "Đây là means this is; địa chỉ means address; chính xác means correct or exact.",
      "natural-variants": "If the location still needs work, move to take-me-here, call-driver, correct-pickup-point, or write-address follow-ups.",
      "when-to-use": "Good with taxis, delivery handoffs, hotel pickups, tour desks, and anyone checking a destination.",
      "good-to-know": "Vietnam addresses can hinge on ward, district, alley, or landmark. Keep the full address visible.",
      "explore-next": "Use stop-here, go-this-way, turn-right, pickup-point, or driver-call follow-ups if the route still needs confirmation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây là", english: "this is", keepTogetherReason: "this-is phrase" },
      { id: "chunk-2", vietnamese: "địa chỉ", english: "address", keepTogetherReason: "address phrase" },
      { id: "chunk-3", vietnamese: "chính xác", english: "correct / exact", keepTogetherReason: "accuracy phrase" }
    ],
    value: "turns the correct-address page into a precise destination confirmation"
  },
  {
    id: "viet-phrase-v500-dire-navi-is-it-on-the-corner",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-on-the-corner.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-on-the-corner.json",
    summary: "For confirming whether the place is on the corner before you cross, turn, or keep walking.",
    beforeSummary: "Is it on the corner?",
    bodies: {
      "at-glance": "Ask when the place is almost found but the exact side or corner still feels uncertain.",
      "quick-say": "Point toward the corner or show the map. Wait for yes, no, or a correction before moving.",
      breakdown: "Nó có means is it; ở góc means on the corner; không makes it a yes/no question.",
      "natural-variants": "If the answer points elsewhere, ask whether it is near, across the street, inside the mall, or next to the hotel.",
      "when-to-use": "Good near intersections, markets, malls, hotel blocks, and streets where signs are hard to spot.",
      "good-to-know": "Corner directions can mean the building corner or the street corner. Let the other person point.",
      "explore-next": "Use left, right, straight, across-street, or near-market follow-ups if the corner clue is not enough."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nó có", english: "is it", keepTogetherReason: "is-it question frame" },
      { id: "chunk-2", vietnamese: "ở góc", english: "on the corner", keepTogetherReason: "corner-location phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the corner-confirmation page specific to navigating intersections and exact sides"
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
      batch: 14,
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
      reason: "premium_audit_batch_14"
    });
  }

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const hasBatch14Rows = existingLedgerRows.some((line) => {
    try {
      const row = JSON.parse(line);
      return row.batch === 14 || row.reason === "premium_audit_batch_14";
    } catch {
      return false;
    }
  });

  if (!hasBatch14Rows) {
    fs.appendFileSync(ledgerPath, `${ledgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 14,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    ledgerRows: hasBatch14Rows ? 0 : ledgerRows.length,
    ledgerSkippedAlreadyPresent: hasBatch14Rows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
