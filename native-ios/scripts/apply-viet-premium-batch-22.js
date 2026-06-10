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
    id: "viet-phrase-v500-bath-pers-need-where-can-i-wash-my-hands",
    source: "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-where-can-i-wash-my-hands.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/bathroom-personal-needs/v500-bath-pers-need-where-can-i-wash-my-hands.json",
    beforeSummary: "Where can I wash my hands?",
    summary: "For finding a sink or hand-washing spot before eating, after a market stall, or after using a restroom.",
    bodies: {
      "at-glance": "Ask staff while pointing to your hands or soap. The answer is usually a restroom, sink, back room, or outside tap.",
      "quick-say": "Keep it simple and follow the gesture. If they point to the restroom, ask for soap or paper only if you still need it.",
      breakdown: "Tôi có thể asks can I; rửa tay means wash my hands; ở đâu asks where.",
      "natural-variants": "Restroom, soap, paper, water, and pharmacy cards cover the hand-washing moment around this question.",
      "when-to-use": "Good in restaurants, markets, clinics, stations, roadside stops, and guesthouses when the sink is not obvious.",
      "good-to-know": "Some places keep a sink outside the restroom or near the kitchen. Watch where staff wash their hands.",
      "explore-next": "Move to restroom, soap, paper, bottled water, or pharmacy cards if the hygiene stop needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "rửa tay", english: "wash my hands", keepTogetherReason: "wash-hands phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns a bare hygiene question into a concrete sink/restroom handoff"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-ill-think-about-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-ill-think-about-it.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-ill-think-about-it.json",
    beforeSummary: "I’ll think about it",
    summary: "For politely pausing a price, tour, service, or shopping decision without saying yes yet.",
    bodies: {
      "at-glance": "Use it after you hear the price or offer. It gives you room to step back without starting an argument.",
      "quick-say": "Say it once, smile, and put the item, menu, or quote down if you are not ready to decide.",
      breakdown: "Tôi sẽ means I will; nghĩ về means think about; nó means it.",
      "natural-variants": "No-thanks, too-expensive, final-price, come-back-later, and discount cards cover the polite pause around it.",
      "when-to-use": "Good at markets, tour desks, repair shops, hotel counters, transport counters, and any flexible-price moment.",
      "good-to-know": "This is softer than no, but it is not a promise. If you know the answer is no, use no-thanks next.",
      "explore-next": "Move to no-thanks, too-expensive, final-price, discount, or come-back-later cards if the seller keeps talking."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi sẽ", english: "I will", keepTogetherReason: "future marker" },
      { id: "chunk-2", vietnamese: "nghĩ về", english: "think about", keepTogetherReason: "think-about phrase" },
      { id: "chunk-3", vietnamese: "nó", english: "it", keepTogetherReason: "object pronoun" }
    ],
    value: "makes the bargaining pause clear without turning it into a false yes"
  },
  {
    id: "viet-phrase-v500-soci-smal-talk-will-it-rain-today",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-will-it-rain-today.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-will-it-rain-today.json",
    beforeSummary: "Will it rain today?",
    summary: "For checking the weather before you choose transport, clothes, a waiting spot, or an outdoor plan.",
    bodies: {
      "at-glance": "Ask when the sky is changing or staff seem to know the local pattern. A short yes, no, or maybe is enough.",
      "quick-say": "Point outside or show the weather app if needed. Keep the question light; this is often small talk too.",
      breakdown: "Hôm nay means today; trời means the weather or sky; có mưa means rain; không makes it a yes/no question.",
      "natural-variants": "Rain shelter, umbrella, hot weather, wait here, and taxi cards cover the plan changes around rain.",
      "when-to-use": "Good at hotels, cafes, tour desks, markets, beach areas, stations, and outdoor attractions before you leave.",
      "good-to-know": "A local answer may be about this neighborhood, not the whole city. Afternoon rain can be very local.",
      "explore-next": "Move to rain shelter, umbrella, taxi, wait-here, or change-time cards if the weather changes the plan."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hôm nay", english: "today", keepTogetherReason: "today phrase" },
      { id: "chunk-2", vietnamese: "trời", english: "weather / sky", keepTogetherReason: "weather noun" },
      { id: "chunk-3", vietnamese: "có mưa", english: "rain", keepTogetherReason: "rain phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the rain question into a practical planning and small-talk moment"
  },
  {
    id: "viet-phrase-v500-tran-please-drive-carefully",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-drive-carefully.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-drive-carefully.json",
    beforeSummary: "Please drive carefully",
    summary: "For asking a taxi, ride-hailing, motorbike, or tour driver to drive more carefully when the ride feels unsafe.",
    bodies: {
      "at-glance": "Say it calmly and early. Pointing to the road, speed, seat belt, or traffic can make the request clearer.",
      "quick-say": "Keep the line short. The driver needs the safety request more than a long explanation.",
      breakdown: "Hãy is a request marker; lái xe means drive; cẩn thận means carefully.",
      "natural-variants": "Drive slower, stop here, follow the map, lower the music, and seat-belt cards cover the ride-safety flow.",
      "when-to-use": "Good in taxis, ride-hailing cars, motorbike taxis, vans, and private transfers when the driving feels too risky.",
      "good-to-know": "A calm tone works better than a panic tone. If the ride still feels unsafe, ask to stop at the next safe place.",
      "explore-next": "Move to drive-slower, stop-here, follow-map, lower-music, or wrong-route cards if the ride still feels off."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy", english: "please / do", keepTogetherReason: "request marker" },
      { id: "chunk-2", vietnamese: "lái xe", english: "drive", keepTogetherReason: "drive phrase" },
      { id: "chunk-3", vietnamese: "cẩn thận", english: "carefully", keepTogetherReason: "carefully phrase" }
    ],
    value: "grounds the safety request in a live vehicle moment without anxiety padding"
  },
  {
    id: "viet-phrase-v500-tran-please-drive-slower",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v500-tran-please-drive-slower.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v500-tran-please-drive-slower.json",
    beforeSummary: "Please drive slower",
    summary: "For asking a driver to slow down when speed, traffic, turns, or rain make the ride uncomfortable.",
    bodies: {
      "at-glance": "Say it before the next turn or fast stretch. A small hand-down gesture can help if words are not enough.",
      "quick-say": "Say the line once, then pause. If nothing changes, follow with stop at the next corner or drive carefully.",
      breakdown: "Xin hãy means please; lái xe means drive; chậm lại means slow down.",
      "natural-variants": "Drive carefully, stop here, next corner, follow the map, and lower the music cards cover the ride adjustment.",
      "when-to-use": "Good in taxis, ride-hailing cars, motorbike taxis, vans, and mountain or rainy-road transfers.",
      "good-to-know": "This is more direct than asking if the road is safe. Say it when the speed itself is the problem.",
      "explore-next": "Move to drive-carefully, stop-here, next-corner, follow-map, or wrong-route cards if the ride still needs adjusting."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy", english: "please", keepTogetherReason: "polite request" },
      { id: "chunk-2", vietnamese: "lái xe", english: "drive", keepTogetherReason: "drive phrase" },
      { id: "chunk-3", vietnamese: "chậm lại", english: "slower / slow down", keepTogetherReason: "slow-down phrase" }
    ],
    value: "makes the slow-down page a direct ride-comfort tool"
  },
  {
    id: "viet-phrase-v500-unde-repa-please-mark-it-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-please-mark-it-here.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-please-mark-it-here.json",
    beforeSummary: "Please mark it here",
    summary: "For asking someone to mark the exact box, line, map spot, receipt item, or phone-screen place you need.",
    bodies: {
      "at-glance": "Point to the paper, map, or screen first. The phrase works best when the place to mark is already visible.",
      "quick-say": "Hold the form or phone steady and pause. Let the other person circle, tick, underline, or tap the right spot.",
      breakdown: "Hãy is a request marker; đánh dấu means mark; nó means it; ở đây means here.",
      "natural-variants": "Write it down, point to it, show me where to tap, spell the name, and right-number cards cover the same repair moment.",
      "when-to-use": "Good with forms, maps, receipts, tickets, clinic instructions, hotel notes, and phone screens.",
      "good-to-know": "Marking is safer than remembering when numbers, times, gates, or addresses are involved.",
      "explore-next": "Move to write-it-down, point-to-it, show-where-to-tap, spell-name, or right-number cards if the detail still needs checking."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy", english: "please / do", keepTogetherReason: "request marker" },
      { id: "chunk-2", vietnamese: "đánh dấu", english: "mark", keepTogetherReason: "mark phrase" },
      { id: "chunk-3", vietnamese: "nó", english: "it", keepTogetherReason: "object pronoun" },
      { id: "chunk-4", vietnamese: "ở đây", english: "here", keepTogetherReason: "here phrase" }
    ],
    value: "turns the marking page into a precise form/map/screen handoff"
  },
  {
    id: "viet-phrase-v500-unde-repa-that-is-not-what-i-meant",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-that-is-not-what-i-meant.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-that-is-not-what-i-meant.json",
    beforeSummary: "That is not what I meant",
    summary: "For correcting a misunderstanding when the wrong item, place, number, route, or request is being used.",
    bodies: {
      "at-glance": "Use it before the mistake turns into payment, booking, food, or a ride. Keep the correction calm and specific.",
      "quick-say": "Say the line, then point to the right item, screen, number, or address so the fix has somewhere to go.",
      breakdown: "Đó means that; không phải là means is not; ý tôi means what I meant or my meaning.",
      "natural-variants": "This one, not this, write it down, translation app, and misunderstanding cards cover the repair flow around it.",
      "when-to-use": "Good in shops, restaurants, taxis, hotel desks, clinics, and counters when someone picked up the wrong meaning.",
      "good-to-know": "This phrase works best with a visible correction. Point, show, or write the right version immediately after.",
      "explore-next": "Move to this-one, not-this, write-it-down, translation-app, or misunderstanding cards if the correction needs another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đó", english: "that", keepTogetherReason: "that pronoun" },
      { id: "chunk-2", vietnamese: "không phải là", english: "is not", keepTogetherReason: "not phrase" },
      { id: "chunk-3", vietnamese: "ý tôi", english: "what I meant", keepTogetherReason: "my-meaning phrase" }
    ],
    value: "makes the correction page practical without sounding confrontational"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-can-i-pay-the-driver-by-card",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-can-i-pay-the-driver-by-card.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-can-i-pay-the-driver-by-card.json",
    beforeSummary: "Can I pay the driver by card?",
    summary: "For checking whether a driver can take card payment before you get in, leave the airport, or finish the ride.",
    bodies: {
      "at-glance": "Ask before the luggage goes in or the ride starts. The answer may be card, cash, bank transfer, or app payment.",
      "quick-say": "Show the card or payment screen if needed. Do not wait until the end of the ride if you have no cash.",
      breakdown: "Tôi có thể asks can I; thanh toán means pay; cho tài xế means the driver; bằng thẻ means by card; không makes it a yes/no question.",
      "natural-variants": "Cash, bank transfer, receipt, break this bill, and airport-fee cards cover the payment questions around a ride.",
      "when-to-use": "Good at airport pickups, hotel-arranged cars, taxis, private drivers, and counters that assign a driver.",
      "good-to-know": "A card terminal may belong to the company, not the driver. Confirm before the car leaves the pickup area.",
      "explore-next": "Move to cash, bank-transfer, receipt, break-bill, or airport-fee cards if payment needs another option."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "thanh toán", english: "pay", keepTogetherReason: "payment verb" },
      { id: "chunk-3", vietnamese: "cho tài xế", english: "the driver", keepTogetherReason: "driver phrase" },
      { id: "chunk-4", vietnamese: "bằng thẻ", english: "by card", keepTogetherReason: "by-card phrase" },
      { id: "chunk-5", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns the card-payment page into a pre-ride cash/card decision"
  },
  {
    id: "viet-phrase-v900-dire-navi-is-it-across-from-the-cafe",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-is-it-across-from-the-cafe.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-is-it-across-from-the-cafe.json",
    beforeSummary: "Is it across from the cafe?",
    summary: "For confirming a place is opposite the cafe you are using as a landmark before you cross or keep walking.",
    bodies: {
      "at-glance": "Point to the cafe first. The answer should confirm the opposite side, another corner, or a different landmark.",
      "quick-say": "Ask before crossing the street if traffic is busy. Let the other person point across, left, right, or behind you.",
      breakdown: "Nó có ở asks is it at; đối diện means across from; quán cà phê means cafe; không makes it a yes/no question.",
      "natural-variants": "Corner, behind-building, entrance, right-direction, and map-location cards cover the landmark check around it.",
      "when-to-use": "Good near cafes, markets, hotels, stations, and shop rows where the landmark is easier than the address.",
      "good-to-know": "Across from can still mean a different door or alley. Ask for the entrance if the building has several fronts.",
      "explore-next": "Move to corner, behind-building, entrance, right-direction, or map-location cards if the landmark answer is not enough."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nó có ở", english: "is it at", keepTogetherReason: "location question" },
      { id: "chunk-2", vietnamese: "đối diện", english: "across from", keepTogetherReason: "opposite phrase" },
      { id: "chunk-3", vietnamese: "quán cà phê", english: "cafe", keepTogetherReason: "cafe phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the cafe-landmark page about crossing and entrance confirmation"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-order-half-a-portion",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-order-half-a-portion.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-order-half-a-portion.json",
    beforeSummary: "Can I order half a portion?",
    summary: "For asking whether a restaurant can serve a smaller half portion before you order.",
    bodies: {
      "at-glance": "Ask before the dish is made. Staff may say yes, no, small size, or point to a different item.",
      "quick-say": "Point to the dish on the menu first. If there is already a small size, use that instead of repeating half portion.",
      breakdown: "Tôi có thể asks can I; gọi means order; một nửa phần means half a portion; được không softens the question.",
      "natural-variants": "Small size, one portion, not too spicy, recommendation, and take-away cards cover the ordering decision around it.",
      "when-to-use": "Good at restaurants, cafes, noodle shops, food courts, and family-style tables when portions look large.",
      "good-to-know": "Some kitchens cannot halve a dish, but they may offer a smaller bowl, side dish, or shared plate.",
      "explore-next": "Move to small-size, one-portion, recommendation, take-away, or pack-to-go cards if the order changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "gọi", english: "order", keepTogetherReason: "order verb" },
      { id: "chunk-3", vietnamese: "một nửa phần", english: "half a portion", keepTogetherReason: "half-portion phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the half-portion page into a real ordering-size question"
  },
  {
    id: "viet-phrase-v900-heal-phar-i-have-a-cough",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-a-cough.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-i-have-a-cough.json",
    beforeSummary: "I have a cough",
    title: "Tôi bị ho",
    pronunciation: "Toi bi ho",
    summary: "For telling a pharmacist, clinic desk, or doctor that cough is the symptom you need help with.",
    bodies: {
      "at-glance": "Say it before asking for medicine. Add fever, asthma, pregnancy, or allergies if any of those also matter.",
      "quick-say": "Keep the symptom clear and let staff ask about duration, fever, mucus, or other medicine.",
      breakdown: "Tôi bị means I have or I am suffering from; ho means cough.",
      "natural-variants": "Fever, asthma, sore throat, medicine, and drug-interaction cards cover the health questions around a cough.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks calling a doctor, and travel-insurance calls when cough is the main symptom.",
      "good-to-know": "If you also have fever, chest pain, asthma, pregnancy, or trouble breathing, say that next before buying medicine.",
      "explore-next": "Move to fever, asthma, medicine, how-to-take-this, or drug-interaction cards if the health conversation continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have / I am suffering from", keepTogetherReason: "symptom phrase" },
      { id: "chunk-2", vietnamese: "ho", english: "cough", keepTogetherReason: "symptom noun" }
    ],
    value: "turns the cough page into a pharmacist/clinic symptom handoff with warning context"
  },
  {
    id: "viet-phrase-v900-tran-i-think-the-fare-is-wrong",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-i-think-the-fare-is-wrong.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-i-think-the-fare-is-wrong.json",
    beforeSummary: "I think the fare is wrong",
    summary: "For telling a driver, ticket counter, or ride-hailing helper that the fare does not look right.",
    bodies: {
      "at-glance": "Show the app, meter, ticket, or posted price first. The phrase is stronger when the number is visible.",
      "quick-say": "Say it calmly and point to the amount. Wait for a recalculation, explanation, or correction before paying more.",
      breakdown: "Tôi nghĩ means I think; giá vé means fare or ticket price; sai means wrong.",
      "natural-variants": "Receipt, refund, card payment, tolls, and exact-change cards cover the fare dispute around this phrase.",
      "when-to-use": "Good in taxis, ride-hailing pickups, bus counters, boat tickets, airport transfers, and tour transport desks.",
      "good-to-know": "If the issue is tolls, airport fee, or route change, use the specific card next instead of arguing over the total.",
      "explore-next": "Move to receipt, refund, tolls, airport-fee, card-payment, or exact-change cards if the fare needs proof."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi nghĩ", english: "I think", keepTogetherReason: "I-think phrase" },
      { id: "chunk-2", vietnamese: "giá vé", english: "fare / ticket price", keepTogetherReason: "fare phrase" },
      { id: "chunk-3", vietnamese: "sai", english: "wrong", keepTogetherReason: "wrong adjective" }
    ],
    value: "turns the fare page into a visible-price correction instead of a vague complaint"
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

function withFullBreakdown(page, tokens) {
  return [
    ...tokens.map((token) => ({ ...token })),
    {
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    }
  ];
}

function alignSelfPhraseCards(page, repair) {
  if (!repair.title && !repair.englishTitle && !repair.pronunciation) return;

  const alignPhrase = (phrase) => {
    if (!phrase || phrase.detailPageID !== null || phrase.id !== page.phraseID) return phrase;
    return {
      ...phrase,
      vietnamese: page.title,
      english: page.englishTitle,
      pronunciation: page.pronunciation,
      symbolName: page.audioKey ? "speaker.wave.2.fill" : phrase.symbolName,
      audioKey: page.audioKey
    };
  };

  page.sections = (page.sections || []).map((section) => ({
    ...section,
    phrases: (section.phrases || []).map(alignPhrase)
  }));
  page.examples = (page.examples || []).map(alignPhrase);
}

function updateSource(repair) {
  const page = readJson(repair.source);
  const before = JSON.parse(JSON.stringify(page));
  if (repair.title) page.title = repair.title;
  if (repair.englishTitle) page.englishTitle = repair.englishTitle;
  if (repair.pronunciation) page.pronunciation = repair.pronunciation;
  page.summary = repair.summary;
  page.sections = (page.sections || []).map((section) => {
    const next = { ...section };
    if (Object.prototype.hasOwnProperty.call(repair.bodies, section.id)) {
      next.body = repair.bodies[section.id];
    }
    if (section.id === "breakdown") {
      next.breakdown = withFullBreakdown(page, repair.breakdown);
    }
    return next;
  });
  alignSelfPhraseCards(page, repair);
  writeJson(repair.source, page);
  return {
    page,
    before,
    after: {
      title: page.title,
      englishTitle: page.englishTitle,
      summary: page.summary,
      sections: Object.fromEntries((page.sections || []).map((section) => [section.id, section.body || ""])),
      phraseCards: countSectionItems(page, "phrases"),
      breakdownRows: countSectionItems(page, "breakdown")
    }
  };
}

function updateAudit(repair, page) {
  const audit = readJson(repair.audit);
  audit.pageID = page.id;
  audit.phraseText = page.title;
  audit.englishTitle = page.englishTitle;
  audit.reviewStatus = "reviewed";
  audit.tokens = withFullBreakdown(page, repair.breakdown);
  writeJson(repair.audit, audit);
}

function parseCSV(text) {
  const rows = [];
  let row = [];
  let field = "";
  let quoted = false;
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];
    if (quoted) {
      if (char === "\"" && next === "\"") {
        field += "\"";
        i += 1;
      } else if (char === "\"") {
        quoted = false;
      } else {
        field += char;
      }
    } else if (char === "\"") {
      quoted = true;
    } else if (char === ",") {
      row.push(field);
      field = "";
    } else if (char === "\n") {
      row.push(field);
      rows.push(row);
      row = [];
      field = "";
    } else if (char !== "\r") {
      field += char;
    }
  }
  if (field.length || row.length) row.push(field), rows.push(row);
  return rows.filter((item) => item.length > 1 || item[0] !== "");
}

function formatCSV(rows, bomMode) {
  const body = rows.map((row, rowIndex) => row.map((field, fieldIndex) => {
    let value = String(field ?? "");
    if (rowIndex === 0 && fieldIndex === 0) {
      value = value.replace(/^[\ufeff]+/, "");
      if (bomMode === "first-header-cell") value = `\ufeff${value}`;
    }
    return `"${value.replace(/"/g, "\"\"")}"`;
  }).join(",")).join("\n");
  return `${bomMode === "file" ? "\ufeff" : ""}${body}\n`;
}

function updateCSV(relPath, repairsByPhraseID) {
  const absPath = path.join(repoRoot, relPath);
  const original = fs.readFileSync(absPath, "utf8");
  const rows = parseCSV(original);
  const hasHeaderCellBOM = /^[\ufeff]+/.test(String(rows[0]?.[0] ?? "")) || original.startsWith("\"\ufeff");
  const bomMode = hasHeaderCellBOM
    ? "first-header-cell"
    : original.charCodeAt(0) === 0xfeff
      ? "file"
      : "none";
  const header = rows[0];
  const index = Object.fromEntries(header.map((name, i) => [String(name).replace(/^[\ufeff]+/, ""), i]));
  let changed = 0;
  for (let i = 1; i < rows.length; i += 1) {
    const row = rows[i];
    const repair = repairsByPhraseID.get(row[index.phrase_id]);
    if (!repair) continue;
    if (repair.title && index.target_text !== undefined) row[index.target_text] = repair.title;
    if (repair.title && index.canonical_target_text !== undefined) row[index.canonical_target_text] = repair.title;
    if (repair.englishTitle && index.english_text !== undefined) row[index.english_text] = repair.englishTitle;
    if (repair.pronunciation && index.pronunciation !== undefined) row[index.pronunciation] = repair.pronunciation;
    if (repair.summary && index.family_summary !== undefined) row[index.family_summary] = repair.summary;
    changed += 1;
  }
  fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
}

function main() {
  const repairsByPhraseID = new Map();
  const ledgerRows = [];
  for (const repair of repairs) {
    const { page, before, after } = updateSource(repair);
    updateAudit(repair, page);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch: 22,
      tierRole: page.tierRole,
      sectionID: "page-visible-copy",
      sectionTitle: "Page visible copy",
      pageID: page.id,
      phraseID: page.phraseID,
      sourcePath: repair.source,
      before: {
        title: before.title,
        englishTitle: before.englishTitle,
        summary: repair.beforeSummary ?? before.summary,
        issues: [
          "title-as-summary",
          "formulaic projection prose",
          repair.title ? "capitalization or source text polish" : "source breakdown gloss repair"
        ]
      },
      after: {
        title: after.title,
        englishTitle: after.englishTitle,
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
      reason: "premium_audit_batch_22"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const ledgerRowsByKey = new Map(
    ledgerRows.map((row) => [`${row.reason}:${row.pageID}`, row])
  );
  let updatedLedgerRows = 0;
  const rewrittenLedgerRows = existingLedgerRows.map((line) => {
    try {
      const row = JSON.parse(line);
      const key = `${row.reason}:${row.pageID}`;
      if (ledgerRowsByKey.has(key)) {
        updatedLedgerRows += 1;
        return JSON.stringify(ledgerRowsByKey.get(key));
      }
    } catch {
      return line;
    }
    return line;
  });
  const existingKeys = new Set(existingLedgerRows.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const newLedgerRows = ledgerRows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  const finalLedgerRows = [
    ...rewrittenLedgerRows,
    ...newLedgerRows.map((row) => JSON.stringify(row))
  ];
  if (updatedLedgerRows || newLedgerRows.length) {
    fs.writeFileSync(ledgerPath, `${finalLedgerRows.join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 22,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: newLedgerRows.length,
    updatedLedgerRows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
