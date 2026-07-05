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
    id: "viet-phrase-v900-time-date-book-is-it-closed-on-mondays",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-it-closed-on-mondays.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-it-closed-on-mondays.json",
    summary: "For checking a weekly closure before you plan around it.",
    beforeSummary: "Is it closed on Mondays?",
    bodies: {
      "at-glance": "Monday closures can change a museum, clinic, restaurant, salon, ticket office, or tour plan.",
      "quick-say": "Show the place or booking date, then ask. Let the answer be yes, no, or a different open day.",
      breakdown: "Đóng cửa means closed; vào thứ Hai means on Monday; không? makes it a yes/no check.",
      "natural-variants": "If the schedule changes, ask what time, today, or tomorrow morning next.",
      "when-to-use": "Good before booking, walking over, paying, or sending a driver to a place that may be shut.",
      "good-to-know": "Vietnam schedules can shift around holidays and weekly rest days. A current sign, booking page, or staff answer beats an old map listing.",
      "explore-next": "Use booking, opening time, date-change, boarding-time, or wait questions if the answer changes the plan."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nó", english: "it" },
      { id: "chunk-2", vietnamese: "có đóng cửa", english: "is closed", keepTogetherReason: "business-hours closure phrase" },
      { id: "chunk-3", vietnamese: "vào thứ Hai", english: "on Monday", keepTogetherReason: "weekday phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "turns a title-repeat schedule page into a concrete weekly-closure check before booking, walking, or sending a driver"
  },
  {
    id: "viet-phrase-v900-tran-can-i-pay-by-bank-transfer",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-can-i-pay-by-bank-transfer.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-can-i-pay-by-bank-transfer.json",
    summary: "For asking whether a fare or counter payment can be sent by bank transfer.",
    beforeSummary: "Can I pay by bank transfer?",
    bodies: {
      "at-glance": "Bank transfer is common in Vietnam, but it is not always available for rides, small counters, or tourist bookings.",
      "quick-say": "Ask before the staff starts the payment. Keep the amount and recipient screen visible.",
      breakdown: "Thanh toán means pay; chuyển khoản ngân hàng means bank transfer; không? asks if it is possible.",
      "natural-variants": "If transfer is not accepted, use cash, card, receipt, fare, or final-total follow-ups.",
      "when-to-use": "Good at ride counters, rentals, tour desks, small hotels, or service desks before the total is confirmed.",
      "good-to-know": "If they agree, check the name and amount before sending. A screenshot can help both sides confirm payment.",
      "explore-next": "Use cash, card, receipt, fare, or stop-here phrases if the payment answer changes the ride."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi", english: "I / me" },
      { id: "chunk-2", vietnamese: "có thể", english: "can / able to", keepTogetherReason: "fixed modal phrase" },
      { id: "chunk-3", vietnamese: "thanh toán", english: "pay", keepTogetherReason: "compound payment verb" },
      { id: "chunk-4", vietnamese: "bằng chuyển khoản ngân hàng", english: "by bank transfer", keepTogetherReason: "bank-transfer payment phrase" },
      { id: "chunk-5", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "grounds bank-transfer payment in a real counter or ride payment moment and fixes weak payment chunks"
  },
  {
    id: "viet-phrase-v900-tran-the-motorbike-has-a-problem",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-the-motorbike-has-a-problem.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-the-motorbike-has-a-problem.json",
    summary: "For telling a rental shop, guide, or driver that the motorbike is not okay.",
    beforeSummary: "The motorbike has a problem",
    bodies: {
      "at-glance": "Use it for a flat tire, weak brake, odd sound, dead battery, or anything that should be checked before riding.",
      "quick-say": "Say the line, then point to the part or show a photo. Do not ride if the problem feels unsafe.",
      breakdown: "Xe máy is motorbike; có vấn đề means has a problem.",
      "natural-variants": "Repair, rental, receipt, pickup, and route follow-ups stay useful if the bike needs replacing.",
      "when-to-use": "Good at rental counters, hotel desks, tour shops, roadside help, or before accepting a motorbike.",
      "good-to-know": "Keep the explanation simple. A short video or pointing at the part may work better than naming the exact mechanical issue.",
      "explore-next": "Use rental agreement, return, wait, company contact, or route questions if the shop needs the next step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xe máy", english: "motorbike", keepTogetherReason: "compound vehicle term" },
      { id: "chunk-2", vietnamese: "có vấn đề", english: "has a problem", keepTogetherReason: "problem phrase" }
    ],
    value: "turns a generic transport line into a rental or roadside safety check and keeps vấn đề together"
  },
  {
    id: "viet-phrase-v900-unde-repa-can-you-explain-it-in-english",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v900-unde-repa-can-you-explain-it-in-english.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v900-unde-repa-can-you-explain-it-in-english.json",
    summary: "For asking someone to switch from fast Vietnamese into simple English.",
    beforeSummary: "Can you explain it in English?",
    bodies: {
      "at-glance": "Use it when a price, address, rule, medicine note, or booking answer is important and gestures are not enough.",
      "quick-say": "Ask once, then show the word, screen, address, or note that needs explaining.",
      breakdown: "Có thể asks can; giải thích means explain; bằng tiếng Anh means in English.",
      "natural-variants": "If English is not possible, move to slower speech, writing, pointing, or translation-app help.",
      "when-to-use": "Good at counters, clinics, hotels, stations, tours, and shops when the answer matters.",
      "good-to-know": "The reply may still be short. Combine this with pointing or writing instead of asking for a long explanation.",
      "explore-next": "Use repeat, write-down, meaning, slower-speech, or show-me follow-ups if English is not available."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn", english: "you" },
      { id: "chunk-2", vietnamese: "có thể", english: "can / able to", keepTogetherReason: "fixed modal phrase" },
      { id: "chunk-3", vietnamese: "giải thích", english: "explain", keepTogetherReason: "compound explanation verb" },
      { id: "chunk-4", vietnamese: "nó", english: "it" },
      { id: "chunk-5", vietnamese: "bằng tiếng Anh", english: "in English", keepTogetherReason: "language phrase" },
      { id: "chunk-6", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "turns a bare repair phrase into a useful switch-to-English moment and removes the bad explain=price source chunk"
  },
  {
    id: "viet-phrase-money-premium-split-payment",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/money-premium-split-payment.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/money-split-payment.json",
    summary: "For asking whether one bill can be divided between people or payment methods.",
    beforeSummary: "Can we split the payment?",
    bodies: {
      "at-glance": "Some places can split a restaurant bill or tour payment; small stalls may prefer one total.",
      "quick-say": "Ask before anyone pays. Show two cards, two phones, or the group if that makes the split clear.",
      breakdown: "Chúng ta means we; chia tiền thanh toán means split the payment; được không asks if it is possible.",
      "natural-variants": "If the answer is no, use cash, card, final price, receipt, or another payment question.",
      "when-to-use": "Good at restaurants, hotel desks, tour counters, clinics, and ticket offices before the total is settled.",
      "good-to-know": "A calculator helps. Agree on the split before handing over cash or tapping a card.",
      "explore-next": "Use total price, receipt, card, cash, or refund follow-ups if the payment needs a second step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng ta", english: "we", keepTogetherReason: "group speaker phrase" },
      { id: "chunk-2", vietnamese: "có thể", english: "can / able to", keepTogetherReason: "fixed modal phrase" },
      { id: "chunk-3", vietnamese: "chia tiền thanh toán", english: "split the payment", keepTogetherReason: "payment-splitting phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "fixed yes-no question ending" }
    ],
    value: "makes split payment about a bill or payment-method split instead of a bare money question"
  },
  {
    id: "viet-phrase-transport-premium-wrong-pickup-point",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/transport-premium-wrong-pickup-point.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/transport-wrong-pickup-point.json",
    summary: "For checking a pickup spot before you wait in the wrong place.",
    beforeSummary: "Is this the right pickup point?",
    bodies: {
      "at-glance": "Airport doors, bus bays, hotel entrances, and tour pickups can have several nearby points that look correct.",
      "quick-say": "Show the app, ticket, or message and point to where you are standing.",
      breakdown: "Đây có phải là asks is this; điểm đón is pickup point; phù hợp means right or suitable; không? checks it.",
      "natural-variants": "If the point is wrong, ask where to meet the driver, which entrance, or where the pickup area is.",
      "when-to-use": "Good before a Grab, shuttle, tour, bus, ferry, or hotel-arranged car.",
      "good-to-know": "A small walk can move you from the wrong curb to the correct pickup lane. Confirm before the driver arrives.",
      "explore-next": "Use driver, entrance, pickup area, stop-here, or route follow-ups if the spot needs to change."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "confirmation frame" },
      { id: "chunk-2", vietnamese: "điểm đón", english: "pickup point", keepTogetherReason: "pickup-point phrase" },
      { id: "chunk-3", vietnamese: "phù hợp", english: "right / suitable", keepTogetherReason: "suitability phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "turns the page into a real curbside pickup confirmation and fixes misleading pickup-point chunks"
  },
  {
    id: "viet-phrase-v500-tran-do-you-have-a-helmet",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-do-you-have-a-helmet.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-do-you-have-a-helmet.json",
    summary: "For asking for a helmet before getting on a motorbike.",
    beforeSummary: "Do you have a helmet?",
    bodies: {
      "at-glance": "Helmet questions belong before the ride starts, not after traffic is moving.",
      "quick-say": "Ask while you are still off the bike. Wait for the helmet or choose another ride.",
      breakdown: "Mũ bảo hiểm means helmet; bạn có asks do you have; không? makes it yes/no.",
      "natural-variants": "If there is no helmet, use wait, wrong ride, unsafe, or another pickup question.",
      "when-to-use": "Good for motorbike taxis, rentals, tours, and hotel-arranged rides.",
      "good-to-know": "A real helmet should fit and fasten. Do not treat a vague nod as enough.",
      "explore-next": "Use driver check, wrong car, unsafe stop, rental agreement, or wait-here phrases if the ride changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "yes-no possession frame" },
      { id: "chunk-2", vietnamese: "mũ bảo hiểm", english: "helmet", keepTogetherReason: "compound safety noun" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "makes the helmet page about pre-ride safety and keeps mũ bảo hiểm together"
  },
  {
    id: "viet-phrase-v500-tran-is-this-my-car",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-is-this-my-car.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-is-this-my-car.json",
    summary: "For confirming the car before you get in.",
    beforeSummary: "Is this my car?",
    bodies: {
      "at-glance": "At busy curbs, two similar cars can arrive at once. Names, plates, and app screens matter.",
      "quick-say": "Ask through the window first. Show the booking name, plate, or destination if needed.",
      breakdown: "Đây có phải là asks is this; xe của tôi means my car; không? confirms it.",
      "natural-variants": "If it is not your car, ask for the driver, pickup point, plate, or destination.",
      "when-to-use": "Good for ride apps, hotel pickups, airport transfers, tours, and station pickups.",
      "good-to-know": "Do not rely on color alone. Match the plate, driver name, and destination before loading bags.",
      "explore-next": "Use driver check, pickup point, car number, destination, or wait-here follow-ups next."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "confirmation frame" },
      { id: "chunk-2", vietnamese: "xe của tôi", english: "my car", keepTogetherReason: "ride ownership phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "turns the page into a ride identity check and removes the false immigration-line breakdown"
  },
  {
    id: "viet-phrase-v500-tran-please-follow-the-map",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-follow-the-map.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-follow-the-map.json",
    summary: "For asking a driver to use the route on your phone.",
    beforeSummary: "Please follow the map",
    bodies: {
      "at-glance": "Useful when the route matters: hotel entrance, pickup lane, toll road, wrong turn, or a specific saved address.",
      "quick-say": "Show the map and say the line before the driver commits to another route.",
      breakdown: "Hãy đi theo means please follow; bản đồ means map.",
      "natural-variants": "If the route still feels wrong, use turn, address, correct street, wrong way, or stop phrases.",
      "when-to-use": "Good in taxis, private cars, motorbike taxis, or transfer vans when the map is already open.",
      "good-to-know": "Keep your tone practical, not accusatory. Point to the route, not the driver.",
      "explore-next": "Use address, route, wrong way, turn, or stop-here follow-ups if the driver needs the next instruction."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy đi theo", english: "please follow", keepTogetherReason: "route-following request" },
      { id: "chunk-2", vietnamese: "bản đồ", english: "map", keepTogetherReason: "compound map noun" }
    ],
    value: "makes map-following about the route on the phone instead of generic transport support copy"
  },
  {
    id: "viet-phrase-v500-tran-please-wait-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-wait-here.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-wait-here.json",
    summary: "For asking a driver, guide, or helper to wait at the current spot.",
    beforeSummary: "Please wait here",
    bodies: {
      "at-glance": "This is useful when bags, tickets, check-in, or a quick errand will only take a few minutes.",
      "quick-say": "Say how long if you know it. Point to the spot so waiting here is not confused with waiting nearby.",
      breakdown: "Xin vui lòng is please; đợi ở đây means wait here.",
      "natural-variants": "If timing changes, use five minutes, pickup point, stop here, or I have a booking.",
      "when-to-use": "Good with drivers, hotel staff, tour desks, rental counters, and pickup arrangements.",
      "good-to-know": "Be specific about time. A short wait is easier to agree to than an open-ended hold.",
      "explore-next": "Use five-minutes wait, pickup point, stop here, booking, or call-driver follow-ups."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin vui lòng", english: "please", keepTogetherReason: "polite request phrase" },
      { id: "chunk-2", vietnamese: "đợi ở đây", english: "wait here", keepTogetherReason: "wait-here phrase" }
    ],
    value: "turns the page into a concrete short-wait request and removes generic map/destination copy"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-where-is-the-departure-hall",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-departure-hall.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-departure-hall.json",
    summary: "For finding the departure hall before check-in, security, or a terminal split.",
    beforeSummary: "Where is the departure hall?",
    bodies: {
      "at-glance": "Departure halls can be on another floor, another building, or the opposite side of arrivals.",
      "quick-say": "Show the airline, flight number, or ticket first. Ask before following the wrong crowd.",
      breakdown: "Sảnh khởi hành means departure hall; ở đâu asks where.",
      "natural-variants": "If the answer sends you elsewhere, ask about terminal, check-in, gate, elevator, or shuttle.",
      "when-to-use": "Good at airport entrances, information desks, taxi drop-offs, and terminal transfers.",
      "good-to-know": "Airports often answer with a floor, door, or terminal name. Repeat that one detail back before walking away.",
      "explore-next": "Use terminal, gate, check-in, elevator, or shuttle follow-ups if the route has another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Sảnh khởi hành", english: "departure hall", keepTogetherReason: "airport area phrase" },
      { id: "chunk-2", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where-question ending" }
    ],
    value: "turns a bare airport where-question into a check-in/security wayfinding moment"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-grab-pickup-point.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-grab-pickup-point.json",
    summary: "For finding the exact Grab pickup spot after landing.",
    beforeSummary: "Where is the Grab pickup point?",
    bodies: {
      "at-glance": "Airport pickup points can be outside the main door, across a lane, or signed separately from taxis.",
      "quick-say": "Show the Grab screen and ask near information, security, or the curb.",
      breakdown: "Điểm đón means pickup point; Grab names the app; ở đâu asks where.",
      "natural-variants": "If the pickup spot changes, ask for the pickup area, driver, terminal, plate, or nearest exit.",
      "when-to-use": "Good at airports, stations, malls, and large hotels where app pickups use a separate zone.",
      "good-to-know": "The app pin may not match the real curb. Follow local signs and staff directions once they point.",
      "explore-next": "Use pickup area, driver, car number, terminal, or this-address follow-ups if the app location is confusing."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Điểm đón", english: "pickup point", keepTogetherReason: "pickup-point phrase" },
      { id: "chunk-2", vietnamese: "Grab", english: "Grab" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where-question ending" }
    ],
    value: "makes the Grab page about real airport curb pickup instead of generic airport detail copy"
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

function updateSource(repair) {
  const page = readJson(repair.source);
  const before = {
    summary: page.summary,
    sections: Object.fromEntries((page.sections ?? []).map((section) => [section.id, section.body])),
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
          english: page.englishTitle.replace(/[?!.]$/, ""),
          audioKey: null
        }
      ];
    }
  }

  writeJson(repair.source, page);

  const after = {
    summary: page.summary,
    sections: Object.fromEntries((page.sections ?? []).map((section) => [section.id, section.body])),
    phraseCards: phraseCardCount(page),
    breakdownRows: breakdownCount(page)
  };

  return { page, before, after };
}

function updateAudit(repair, page) {
  const audit = readJson(repair.audit);
  audit.tokens = [
    ...repair.breakdown.map((entry) => ({ ...entry })),
    {
      id: "full",
      vietnamese: audit.phraseText,
      english: audit.englishTitle,
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
      batch: 11,
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
      reason: "premium_audit_batch_11"
    });
  }

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const hasBatch11Rows = existingLedgerRows.some((line) => {
    try {
      const row = JSON.parse(line);
      return row.batch === 11 || row.reason === "premium_audit_batch_11";
    } catch {
      return false;
    }
  });

  if (!hasBatch11Rows) {
    fs.appendFileSync(ledgerPath, `${ledgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 11,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    ledgerRows: hasBatch11Rows ? 0 : ledgerRows.length,
    ledgerSkippedAlreadyPresent: hasBatch11Rows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
