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
    id: "viet-phrase-v900-loca-serv-ever-task-can-you-sew-this",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-sew-this.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-sew-this.json",
    beforeSummary: "Can you sew this?",
    summary: "For asking a tailor, laundry counter, or repair stall whether a torn strap, button, seam, or bag can be sewn.",
    bodies: {
      "at-glance": "Show the tear or loose piece first. The question works best when the repair is visible in your hand.",
      "quick-say": "Point to the exact spot that needs stitching. Let the answer be yes, no, a price, or a pickup time.",
      breakdown: "Bạn có thể asks can you; may cái này means sew this; được không softens the request.",
      "natural-variants": "Water, bag, tissues, receipt, and print cards cover the everyday counter errands that often sit nearby.",
      "when-to-use": "Good at laundry shops, market repair stalls, hotel desks, clothing shops, and small service counters.",
      "good-to-know": "Small sewing repairs are easier to explain by pointing than by describing. Keep the damaged part visible until the price or timing is clear.",
      "explore-next": "Move to water, bag, open-this, card-payment, receipt, or print cards if the errand turns into a shop or counter request."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you phrase" },
      { id: "chunk-2", vietnamese: "may cái này", english: "sew this", keepTogetherReason: "sewing request" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a title-only sewing page into a visible repair-counter moment without dropping service cards"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-please-cancel-that-card-payment",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-please-cancel-that-card-payment.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-please-cancel-that-card-payment.json",
    beforeSummary: "Please cancel that card payment",
    summary: "For stopping a mistaken card charge while the terminal, receipt, or bank notification is still visible.",
    bodies: {
      "at-glance": "Use it immediately after a wrong tap, duplicate charge, or amount that does not match the bill.",
      "quick-say": "Show the receipt, terminal, or phone notification. Keep the request short so staff can reverse or check the transaction.",
      breakdown: "Vui lòng means please; hủy means cancel; thanh toán thẻ đó points to that card payment.",
      "natural-variants": "Price and calculator cards help if the cancellation turns into an amount check.",
      "when-to-use": "Good at counters, restaurants, ticket desks, hotel desks, and shops while the payment record is still fresh.",
      "good-to-know": "Card reversals are easier before you leave. Keep the receipt and the card screen open until the answer is clear.",
      "explore-next": "Move to too-expensive, lower-price, final-price, another-one, or take-this cards if the issue becomes a price conversation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "hủy", english: "cancel", keepTogetherReason: "cancel verb" },
      { id: "chunk-3", vietnamese: "thanh toán thẻ đó", english: "that card payment", keepTogetherReason: "card-payment phrase" }
    ],
    value: "reframes the payment page around a real terminal/receipt correction instead of generic price scaffolding"
  },
  {
    id: "viet-phrase-v900-shop-do-you-have-a-cheaper-one",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-do-you-have-a-cheaper-one.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-do-you-have-a-cheaper-one.json",
    beforeSummary: "Do you have a cheaper one?",
    summary: "For asking about a lower-priced version without turning the shop exchange into a long negotiation.",
    bodies: {
      "at-glance": "Point to the item you like, then ask if there is a cheaper option nearby.",
      "quick-say": "Keep the tone light. The answer may be another size, simpler version, different color, or a firm no.",
      breakdown: "Bạn có asks do you have; cái nào means which one; rẻ hơn means cheaper; không makes it a question.",
      "natural-variants": "Size, color, try-on, and lower-price cards cover the next normal shop moves.",
      "when-to-use": "Good at markets, clothing shops, souvenir stalls, phone accessory counters, and small stores with several versions of one item.",
      "good-to-know": "This is softer than asking for a discount. It lets the seller offer a different item instead of arguing over the same one.",
      "explore-next": "Move to just-looking, where-pay, exchange-this, item-price, or lower-price cards if the shop conversation continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "have question" },
      { id: "chunk-2", vietnamese: "cái nào", english: "which one / any one", keepTogetherReason: "which-item phrase" },
      { id: "chunk-3", vietnamese: "rẻ hơn", english: "cheaper", keepTogetherReason: "cheaper phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the cheaper-option page feel like a real market/shop move while preserving shopping follow-ups"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-where-can-i-exchange-money",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-where-can-i-exchange-money.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-where-can-i-exchange-money.json",
    beforeSummary: "Where can I exchange money?",
    summary: "For finding a money exchange counter, bank desk, or nearby place to change cash before paying.",
    bodies: {
      "at-glance": "Ask at a hotel desk, shop, station, or bank area when you need directions to the right counter.",
      "quick-say": "Mention the question, then pause. The answer may be a bank name, street, floor, or warning not to exchange there.",
      breakdown: "Tôi có thể asks can I; đổi tiền means exchange money; ở đâu asks where.",
      "natural-variants": "Price, kilo, and calculator cards stay nearby if the exchange question turns into a payment moment.",
      "when-to-use": "Good before markets, ticket counters, taxis, or cash-only stalls when your current bills will not work.",
      "good-to-know": "Exchange directions often come with a landmark. Repeat the place name or ask them to point if the route is fast.",
      "explore-next": "Move to too-expensive, lower-price, final-price, another-one, or take-this cards once cash is ready."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "đổi tiền", english: "exchange money", keepTogetherReason: "money-exchange phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "replaces wrong breakdown glosses and generic price copy with a real cash-exchange errand"
  },
  {
    id: "viet-phrase-v900-food-drin-what-is-not-too-spicy",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-what-is-not-too-spicy.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-what-is-not-too-spicy.json",
    beforeSummary: "What is not too spicy?",
    summary: "For asking staff to steer you toward a milder dish before ordering from a menu or counter.",
    bodies: {
      "at-glance": "Use it while looking at the menu, pointing at the case, or choosing between dishes.",
      "quick-say": "Let the question invite a recommendation. A photo or menu line can help, but the answer may be a different dish.",
      breakdown: "Cái gì asks what; không quá cay means not too spicy.",
      "when-to-use": "Good at street stalls, cafes, noodle shops, seafood restaurants, and counters where spice level is not obvious.",
      "good-to-know": "Mild in Vietnam can still mean some chili. If you need very mild food, follow with the not-spicy card.",
      "explore-next": "Move to beer, iced-tea, what-they-have, two-of-these, or not-spicy cards if ordering continues.",
      "natural-variants": "Portion, bowl, vegetarian, peanut-allergy, and not-spicy cards cover the food choices that usually follow."
    },
    phraseSections: {
      "explore-next": [
        {
          id: "v900-food-drin-one-iced-tea-please",
          vietnamese: "Làm ơn cho một ly trà đá",
          english: "One iced tea, please",
          pronunciation: "Lam on cho mot ly tra da",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-one-iced-tea-please",
          audioKey: "v900-food-drin-one-iced-tea-please"
        },
        {
          id: "v900-food-drin-ill-have-what-they-are-having",
          vietnamese: "Tôi sẽ có những gì họ đang có",
          english: "I’ll have what they are having",
          pronunciation: "Toi se co nhung gi ho dang co",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-ill-have-what-they-are-having",
          audioKey: "v900-food-drin-ill-have-what-they-are-having"
        },
        {
          id: "v900-food-drin-two-of-these-please",
          vietnamese: "Xin vui lòng cho hai trong số này",
          english: "Two of these, please",
          pronunciation: "Xin vui long cho hai trong so nay",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-two-of-these-please",
          audioKey: "v900-food-drin-two-of-these-please"
        },
        {
          id: "v900-food-drin-one-more-please",
          vietnamese: "Xin thêm một cái nữa",
          english: "One more, please",
          pronunciation: "Xin them mot cai nua",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-phrase-v900-food-drin-one-more-please",
          audioKey: "v900-food-drin-one-more-please"
        },
        {
          id: "food-menu",
          vietnamese: "Cho tôi xem thực đơn được không?",
          english: "Can I see the menu?",
          pronunciation: "cho toy sem thook dun dook khong",
          symbolName: "speaker.wave.2.fill",
          tintName: "green",
          detailPageID: "viet-family-food-menu",
          audioKey: "food-menu"
        }
      ]
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái gì", english: "what", keepTogetherReason: "what question" },
      { id: "chunk-2", vietnamese: "không quá cay?", english: "is not too spicy?", keepTogetherReason: "not-too-spicy phrase" }
    ],
    value: "makes the spice page recommendation-oriented while preserving food phrase density"
  },
  {
    id: "viet-phrase-v900-hote-acco-where-can-i-pick-up-my-luggage",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-where-can-i-pick-up-my-luggage.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-where-can-i-pick-up-my-luggage.json",
    beforeSummary: "Where can I pick up my luggage?",
    summary: "For finding stored bags after checkout, before check-in, or after a transfer handoff.",
    bodies: {
      "at-glance": "Ask near reception with the claim tag, room number, or booking screen ready.",
      "quick-say": "Keep the luggage tag visible. The answer may be a storage room, desk, time, or staff member.",
      breakdown: "Tôi có thể asks can I; nhận hành lý của mình means pick up my luggage; ở đâu asks where.",
      "natural-variants": "Reservation, check-in, and polite check-in cards cover the hotel desk flow around it.",
      "when-to-use": "Good at hotels, guesthouses, serviced apartments, station storage desks, and tour counters holding bags.",
      "good-to-know": "Bag storage answers are often location plus timing. Confirm both before leaving the desk.",
      "explore-next": "Move to checkout-time, quiet-room, checkout, hot-room, or air-conditioner cards if the front desk conversation continues."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "nhận hành lý của mình", english: "pick up my luggage", keepTogetherReason: "luggage-pickup phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "turns luggage pickup into a specific front-desk/storage moment and fixes rough glosses"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-where-can-i-do-laundry",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-do-laundry.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-do-laundry.json",
    beforeSummary: "Where can I do laundry?",
    summary: "For asking where to wash clothes when a hotel, hostel, or neighborhood counter is the easiest lead.",
    bodies: {
      "at-glance": "Ask with the laundry bag, hotel card, or map nearby so the answer can become a direction.",
      "quick-say": "One clear question is enough. Listen for a shop name, street, floor, or pickup time.",
      breakdown: "Tôi có thể asks can I; giặt đồ means wash clothes or do laundry; ở đâu asks where.",
      "natural-variants": "Water, bag, tissues, receipt, and print cards cover small counter errands near this one.",
      "when-to-use": "Good at hotel desks, guesthouses, laundry shops, apartment lobbies, and local-service counters.",
      "good-to-know": "Laundry directions may include timing. If the answer is a service counter, ask when it will be ready next.",
      "explore-next": "Move to sunscreen, open-this, card-payment, receipt, or print cards if the errand becomes a shop-counter exchange."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "giặt đồ", english: "do laundry / wash clothes", keepTogetherReason: "laundry phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "replaces generic errand copy and wrong breakdown glosses with an actual laundry-finding moment"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-where-can-i-repair-my-bag",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-repair-my-bag.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-where-can-i-repair-my-bag.json",
    beforeSummary: "Where can I repair my bag?",
    summary: "For finding a bag repair, tailor, market stall, or shoe-repair counter when a strap, zip, or seam fails.",
    bodies: {
      "at-glance": "Show the damaged bag if you can. The answer is often a nearby stall, alley, counter, or person.",
      "quick-say": "Ask once, then point to the broken part. That keeps the repair need clear even if the directions are short.",
      breakdown: "Tôi có thể asks can I; sửa túi means repair a bag; ở đâu asks where.",
      "natural-variants": "Water, bag, tissues, receipt, and print cards stay nearby for small service-counter errands.",
      "when-to-use": "Good at hotels, markets, laundry shops, tailor counters, shoe-repair stalls, and shopping streets.",
      "good-to-know": "Small repairs often depend on who is nearby, not a formal shop sign. A point or name may be the whole answer.",
      "explore-next": "Move to sunscreen, open-this, card-payment, receipt, or print cards if the errand shifts to buying or counter help."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "sửa túi", english: "repair my bag", keepTogetherReason: "bag-fix words" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where question" }
    ],
    value: "grounds bag repair in a real broken-strap/zip errand while preserving the service card graph"
  },
  {
    id: "viet-phrase-v900-poli-basi-may-i",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v900-poli-basi-may-i.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/polite-basics/v900-poli-basi-may-i.json",
    beforeSummary: "May I?",
    title: "Tôi có thể làm vậy được không?",
    englishTitle: "May I do that?",
    pronunciation: "Toi co the lam vay duoc khong",
    audioPlanned: true,
    summary: "For asking permission with a gesture toward the seat, item, doorway, or action you mean.",
    bodies: {
      "at-glance": "Best when the action is obvious from your gesture, not when the other person has to guess.",
      "quick-say": "Point or gesture first, then ask. The phrase works like a polite permission check for a small action.",
      breakdown: "Tôi có thể asks can I; làm vậy means do that; được không softens the permission question.",
      "natural-variants": "Hello, thank-you, and excuse-me cards cover the polite frame around the permission ask.",
      "when-to-use": "Good before sitting, entering, touching an item, taking a photo, moving something, or trying a small action.",
      "good-to-know": "The gesture matters. Without the action in view, this phrase is too vague to carry the whole request.",
      "explore-next": "Move to yes, no-thank-you, excuse-me, it's-okay, or goodbye cards when the exchange becomes basic politeness."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "làm vậy", english: "do that", keepTogetherReason: "do-that phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that okay?", keepTogetherReason: "permission ending" }
    ],
    value: "fixes a semantically under-specified permission phrase and moves stale audio to planned instead of hiding the issue"
  },
  {
    id: "viet-phrase-v900-tran-please-stop-at-the-next-corner",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-stop-at-the-next-corner.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-stop-at-the-next-corner.json",
    beforeSummary: "Please stop at the next corner",
    summary: "For giving a driver a clean stopping point before the map location or street entrance gets confusing.",
    bodies: {
      "at-glance": "Say it before the corner arrives, with the map or street visible if possible.",
      "quick-say": "Keep the line short and clear. The driver needs the stop point more than the full explanation.",
      breakdown: "Vui lòng means please; dừng lại means stop; ở góc tiếp theo means at the next corner.",
      "natural-variants": "Take-me-here, District 1, and stop-here cards cover nearby ride instructions.",
      "when-to-use": "Good in taxis, rideshares, motorbike taxis, and private cars when the exact building entrance is hard to reach.",
      "good-to-know": "Corners are useful landmarks. If traffic is moving fast, point toward the side where you want to stop.",
      "explore-next": "Move to stop-here, go-this-way, air-conditioning, wait-five-minutes, or cash cards if the ride needs another instruction."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "dừng lại", english: "stop", keepTogetherReason: "stop verb" },
      { id: "chunk-3", vietnamese: "ở góc tiếp theo", english: "at the next corner", keepTogetherReason: "next-corner phrase" }
    ],
    value: "turns the next-corner page into a live ride instruction instead of repeated route scaffolding"
  },
  {
    id: "viet-phrase-phone-7",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/phone-7.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/phone-esim.json",
    beforeSummary: "My eSIM is not working",
    summary: "For showing a phone shop, hotel desk, or carrier counter that the eSIM is installed but not connecting.",
    bodies: {
      "at-glance": "Open the cellular screen before asking so the problem is visible.",
      "quick-say": "Show the eSIM setting, error message, or no-service bar. The screen will explain more than a long sentence.",
      breakdown: "eSIM của tôi means my eSIM; không hoạt động means is not working.",
      "natural-variants": "Wi-Fi password and SIM-card cards cover the setup questions that often come next.",
      "when-to-use": "Good at phone shops, airport SIM counters, hotel desks, cafes, and anywhere someone can look at the phone settings.",
      "good-to-know": "Connection problems may be activation, data, roaming, or coverage. Keep the settings screen open for the follow-up.",
      "explore-next": "Move to battery, charger, charge-here, data-top-up, verification-code, or data-not-working cards if the issue changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "eSIM của tôi", english: "my eSIM", keepTogetherReason: "eSIM phrase" },
      { id: "chunk-2", vietnamese: "không hoạt động", english: "is not working", keepTogetherReason: "not-working phrase" }
    ],
    value: "makes the eSIM page specific to a visible phone-settings problem while preserving phone setup follow-ups"
  },
  {
    id: "viet-phrase-phone-premium-data-not-working",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/phone-premium-data-not-working.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/phone-data-not-working.json",
    beforeSummary: "My data is not working.",
    title: "Dữ liệu của tôi không hoạt động.",
    englishTitle: "My data is not working.",
    summary: "For showing that mobile data is on but maps, messages, or browser pages still will not load.",
    bodies: {
      "at-glance": "Use it with the cellular data screen, no-service bar, or failed app open.",
      "quick-say": "Show the phone while you say it. The helper may check data balance, roaming, SIM setup, or coverage.",
      breakdown: "Dữ liệu của tôi means my data; không hoạt động means is not working.",
      "natural-variants": "Wi-Fi password and SIM-card cards help if the answer is to switch networks or check the SIM.",
      "when-to-use": "Good at phone shops, airport SIM desks, hotel desks, cafes, and anywhere you need help getting online.",
      "good-to-know": "Data problems are easier to diagnose with the settings screen open. Keep the phone unlocked until the next check is clear.",
      "explore-next": "Move to battery, charger, charge-here, data-top-up, eSIM, or verification-code cards if the fix needs another phrase."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Dữ liệu của tôi", english: "my data", keepTogetherReason: "mobile-data phrase" },
      { id: "chunk-2", vietnamese: "không hoạt động.", english: "is not working", keepTogetherReason: "not-working phrase" }
    ],
    value: "fixes punctuation and bad breakdown glosses while making the data page a real phone-settings support moment"
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
  const next = tokens.map((token) => ({ ...token }));
  const finalToken = next[next.length - 1];
  if (finalToken?.vietnamese !== page.title || finalToken?.english !== page.englishTitle) {
    next.push({
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    });
  }
  return next;
}

function alignSelfPhraseCards(page, repair) {
  const changedSelf = repair.audioPlanned || repair.title || repair.englishTitle || repair.pronunciation;
  if (!changedSelf) return;

  const alignPhrase = (phrase) => {
    if (!phrase || phrase.detailPageID !== null || phrase.id !== page.phraseID) return phrase;
    return {
      ...phrase,
      vietnamese: page.title,
      english: page.englishTitle,
      pronunciation: page.pronunciation,
      symbolName: repair.audioPlanned ? "text.bubble.fill" : phrase.symbolName,
      audioKey: repair.audioPlanned ? null : page.audioKey
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
  if (repair.audioPlanned) page.audioKey = null;
  page.summary = repair.summary;
  page.sections = (page.sections || []).map((section) => {
    const next = { ...section };
    if (Object.prototype.hasOwnProperty.call(repair.bodies, section.id)) {
      next.body = repair.bodies[section.id];
    }
    if (repair.phraseSections && Object.prototype.hasOwnProperty.call(repair.phraseSections, section.id)) {
      next.phrases = repair.phraseSections[section.id].map((phrase) => ({ ...phrase }));
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
  if (field.length || row.length) {
    row.push(field);
    rows.push(row);
  }
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
    if (repair.audioPlanned) {
      if (index.audio_key !== undefined) row[index.audio_key] = "";
      if (index.audio_status !== undefined) row[index.audio_status] = "planned";
      if (index.notes !== undefined) {
        const note = row[index.notes] || "";
        if (!note.includes("Batch 18 semantic repair moved audio to planned")) {
          row[index.notes] = `${note}; Batch 18 semantic repair moved audio to planned`;
        }
      }
    }
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
      batch: 18,
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
          repair.audioPlanned ? "semantic audio replacement" : "copy-only visible prose repair"
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
      reason: "premium_audit_batch_18"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existingLedgerRows.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const newLedgerRows = ledgerRows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  if (newLedgerRows.length) {
    fs.appendFileSync(ledgerPath, `${newLedgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 18,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: newLedgerRows.length,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
