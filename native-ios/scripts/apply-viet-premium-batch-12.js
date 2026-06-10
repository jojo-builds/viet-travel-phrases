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
    id: "viet-phrase-v900-dire-navi-is-this-the-correct-pickup-point",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-is-this-the-correct-pickup-point.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-is-this-the-correct-pickup-point.json",
    summary: "For checking the exact pickup spot before you wait in the wrong place.",
    beforeSummary: "Is this the correct pickup point?",
    bodies: {
      "at-glance": "Pickup areas can be split by gate, curb, app lane, tour group, or hotel entrance.",
      "quick-say": "Show the booking, app pin, or message and point to where you are standing.",
      breakdown: "Đây có phải là asks is this; điểm đón means pickup point; chính xác means correct or exact.",
      "natural-variants": "If the answer sends you elsewhere, ask for the pickup point, entrance, driver, or nearest landmark.",
      "when-to-use": "Good before a Grab, shuttle, tour bus, airport pickup, or hotel-arranged car.",
      "good-to-know": "Do not wait on a guess if the curb is crowded. A small correction now can save a missed pickup.",
      "explore-next": "Use pickup point, address, direction, meeting-point, or stop-here follow-ups if the location changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây có phải là", english: "is this", keepTogetherReason: "confirmation frame" },
      { id: "chunk-2", vietnamese: "điểm đón", english: "pickup point", keepTogetherReason: "pickup-point phrase" },
      { id: "chunk-3", vietnamese: "chính xác", english: "correct / exact", keepTogetherReason: "accuracy phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "turns the page into a precise pickup-location check and fixes false word-piece glosses"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-have-a-cup-of-ice",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-a-cup-of-ice.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-a-cup-of-ice.json",
    summary: "For asking for a separate cup of ice at a cafe, stall, or restaurant.",
    beforeSummary: "Can I have a cup of ice?",
    title: "Cho tôi xin một ly đá được không?",
    englishTitle: "Can I have a cup of ice?",
    pronunciation: "Cho toi xin mot ly da duoc khong",
    audioPlanned: true,
    bodies: {
      "at-glance": "Use this when the drink is warm, the ice is separate, or the table needs one extra cup.",
      "quick-say": "Point to the drink or empty cup first. Keep the request small and easy to answer.",
      breakdown: "Cho tôi xin is a polite asking frame; một ly đá means a cup of ice; được không asks if it is possible.",
      "natural-variants": "If the drink order changes, move to less ice, no sugar, bottled water, or one fresh coconut.",
      "when-to-use": "Good at cafes, juice stalls, casual restaurants, hotel breakfast, and street-food tables.",
      "good-to-know": "Ice is common, but staff may bring it in a glass, a small bucket, or directly in the drink.",
      "explore-next": "Use less-ice, no-sugar, bottled-water, straw, or to-go follow-ups if the order needs one more detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cho tôi xin", english: "may I have / please give me", keepTogetherReason: "polite request frame" },
      { id: "chunk-2", vietnamese: "một ly đá", english: "a cup of ice", keepTogetherReason: "cup-of-ice phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces a literal Can-I-have translation with a natural cafe request and moves stale audio to planned"
  },
  {
    id: "viet-phrase-v900-heal-phar-can-i-drink-alcohol-with-this",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-can-i-drink-alcohol-with-this.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-can-i-drink-alcohol-with-this.json",
    summary: "For checking whether alcohol is safe with a medicine you were given.",
    beforeSummary: "Can I drink alcohol with this?",
    title: "Tôi có thể uống rượu khi dùng thuốc này không?",
    englishTitle: "Can I drink alcohol with this?",
    pronunciation: "Toi co the uong ruou khi dung thuoc nay khong",
    audioPlanned: true,
    bodies: {
      "at-glance": "Ask before you leave the pharmacy or clinic, while the package or prescription is still visible.",
      "quick-say": "Show the medicine and ask once. Let the staff answer yes, no, or how many hours to wait.",
      breakdown: "Uống rượu means drink alcohol; khi dùng thuốc này means while taking this medicine.",
      "natural-variants": "If the answer is complicated, ask when to take it, whether it causes sleepiness, or whether food matters.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, or with a guide helping translate medicine instructions.",
      "good-to-know": "Keep the packaging visible. The exact medicine matters more than a long explanation in English.",
      "explore-next": "Use food, bedtime, sleepy, dosage, or come-back follow-ups if the medicine instructions need another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "uống rượu", english: "drink alcohol", keepTogetherReason: "alcohol phrase" },
      { id: "chunk-3", vietnamese: "khi dùng thuốc này", english: "while taking this medicine", keepTogetherReason: "medicine-use phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "makes the health question medicine-specific instead of a vague literal with this translation"
  },
  {
    id: "viet-phrase-v900-heal-phar-can-i-get-a-medical-report",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-can-i-get-a-medical-report.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-can-i-get-a-medical-report.json",
    summary: "For asking a clinic for written medical proof before you leave.",
    beforeSummary: "Can I get a medical report?",
    title: "Tôi có thể lấy giấy xác nhận y tế không?",
    englishTitle: "Can I get a medical report?",
    pronunciation: "Toi co the lay giay xac nhan y te khong",
    audioPlanned: true,
    bodies: {
      "at-glance": "Useful when insurance, an airline, a tour company, or a hotel may need written proof.",
      "quick-say": "Ask before paying or leaving the clinic. Show the insurer, booking, or form if you have one.",
      breakdown: "Lấy means get; giấy xác nhận y tế is written medical confirmation; không asks if it is possible.",
      "natural-variants": "If they ask what kind, move to receipt, insurance, email, report, or come-back follow-ups.",
      "when-to-use": "Good at clinics, hospitals, pharmacies with clinic counters, and hotel-assisted medical visits.",
      "good-to-know": "Names and dates matter on medical paperwork. Check them before you leave the desk.",
      "explore-next": "Use receipt, insurance, email, clinic bill, or come-back questions if the paperwork has another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể lấy", english: "can I get", keepTogetherReason: "request frame" },
      { id: "chunk-2", vietnamese: "giấy xác nhận y tế", english: "medical confirmation paper", keepTogetherReason: "medical-document phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "replaces stiff medical-report wording with a clearer clinic paperwork request and moves stale audio to planned"
  },
  {
    id: "viet-phrase-v900-heal-phar-should-i-take-it-before-bed",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-should-i-take-it-before-bed.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-should-i-take-it-before-bed.json",
    summary: "For checking bedtime timing on a medicine before you take it.",
    beforeSummary: "Should I take it before bed?",
    title: "Tôi có nên uống thuốc này trước khi đi ngủ không?",
    englishTitle: "Should I take it before bed?",
    pronunciation: "Toi co nen uong thuoc nay truoc khi di ngu khong",
    audioPlanned: true,
    bodies: {
      "at-glance": "Ask while the medicine is in view, especially if sleepiness, food, or timing matters.",
      "quick-say": "Show the box or blister pack. Let the answer be morning, night, after food, or not before bed.",
      breakdown: "Có nên asks should; uống thuốc này means take this medicine; trước khi đi ngủ means before bed.",
      "natural-variants": "If timing is unclear, ask with food, before bed, will this make me sleepy, or when should I come back.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, or any counter where someone is explaining dosage.",
      "good-to-know": "A written schedule helps. Point to morning, afternoon, or night if the answer gets too fast.",
      "explore-next": "Use food, sleepy, alcohol, dosage, or come-back follow-ups if the instructions still need checking."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có nên", english: "should I", keepTogetherReason: "advice question frame" },
      { id: "chunk-2", vietnamese: "uống thuốc này", english: "take this medicine", keepTogetherReason: "medicine-taking phrase" },
      { id: "chunk-3", vietnamese: "trước khi đi ngủ", english: "before bed", keepTogetherReason: "bedtime phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "makes the bedtime question medicine-specific and moves the old audio-backed wording to planned"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-is-there-a-withdrawal-fee",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-is-there-a-withdrawal-fee.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-is-there-a-withdrawal-fee.json",
    summary: "For checking an ATM or cash-service fee before you withdraw money.",
    beforeSummary: "Is there a withdrawal fee?",
    bodies: {
      "at-glance": "Use it before confirming an ATM withdrawal, exchange-counter cash service, or card cash advance.",
      "quick-say": "Point to the ATM screen, fee line, or amount first. Ask before you press confirm.",
      breakdown: "Có phí rút tiền không asks whether there is a withdrawal fee.",
      "natural-variants": "If the fee is unclear, ask final total, smaller bills, card fee, or refund difference next.",
      "when-to-use": "Good at ATMs, banks, hotel desks, exchange counters, and convenience-store cash services.",
      "good-to-know": "ATM screens may show several fees. Check both the local fee and your bank's warning before accepting.",
      "explore-next": "Use ATM, final price, smaller bills, card fee, or receipt follow-ups if the money question has another step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is there" },
      { id: "chunk-2", vietnamese: "phí rút tiền", english: "withdrawal fee", keepTogetherReason: "ATM fee phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "turns a bare fee question into a practical ATM confirmation before accepting a charge"
  },
  {
    id: "viet-phrase-v900-sigh-acti-is-there-an-english-guide",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-there-an-english-guide.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-there-an-english-guide.json",
    summary: "For checking whether a tour or attraction has an English-speaking guide.",
    beforeSummary: "Is there an English guide?",
    title: "Có hướng dẫn viên tiếng Anh không?",
    englishTitle: "Is there an English guide?",
    pronunciation: "Co huong dan vien tieng Anh khong",
    audioPlanned: true,
    bodies: {
      "at-glance": "Ask at the ticket desk or meeting point before you commit to the tour.",
      "quick-say": "Show the booking, time slot, or attraction name so staff know which tour you mean.",
      breakdown: "Có hướng dẫn viên tiếng Anh không asks whether an English-speaking guide is available.",
      "natural-variants": "If there is no guide, ask for English audio, a map, start time, or where the group meets.",
      "when-to-use": "Good at museums, boat tours, walking tours, temples, caves, and ticket counters.",
      "good-to-know": "Some places have English signs but no English guide. Ask before paying if the guide matters.",
      "explore-next": "Use ticket, meeting point, start time, photo, or booking follow-ups if the tour details need another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is there" },
      { id: "chunk-2", vietnamese: "hướng dẫn viên tiếng Anh", english: "English-speaking guide", keepTogetherReason: "guide phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?" }
    ],
    value: "fixes the guide phrase to name a person, not vague English guidance, and moves stale audio to planned"
  },
  {
    id: "viet-phrase-v900-tran-can-i-see-the-rental-agreement",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-can-i-see-the-rental-agreement.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-can-i-see-the-rental-agreement.json",
    summary: "For asking to read the rental terms before you sign or pay.",
    beforeSummary: "Can I see the rental agreement?",
    bodies: {
      "at-glance": "Useful before a motorbike, scooter, car, room, or equipment rental becomes a real commitment.",
      "quick-say": "Ask before handing over a passport, deposit, or full payment. Point to the document if it is nearby.",
      breakdown: "Xem means see or read; hợp đồng thuê means rental agreement; được không asks if it is possible.",
      "natural-variants": "If the terms are unclear, ask about deposit, return time, damage, receipt, or who to call.",
      "when-to-use": "Good at rental counters, tour desks, hotel desks, and shops lending gear or vehicles.",
      "good-to-know": "Photos help if the agreement is only on paper. Check deposit, return time, and damage rules before signing.",
      "explore-next": "Use deposit, receipt, return, damage, or contact-number follow-ups if the agreement raises a question."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể xem", english: "can I see / read", keepTogetherReason: "document request frame" },
      { id: "chunk-2", vietnamese: "hợp đồng thuê", english: "rental agreement", keepTogetherReason: "rental contract phrase" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the rental-agreement page into a pre-signing document check instead of generic transport copy"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-am-pregnant",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-am-pregnant.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-am-pregnant.json",
    summary: "For telling a pharmacist or clinician you are pregnant before advice or medicine.",
    beforeSummary: "I am pregnant",
    title: "Tôi đang mang thai",
    englishTitle: "I am pregnant",
    pronunciation: "Toi dang mang thai",
    bodies: {
      "at-glance": "Say it early, before medicine, X-rays, injections, or strong treatment advice.",
      "quick-say": "Keep the line simple. Show any prescription, symptom note, or gestational-week detail if you have it.",
      breakdown: "Tôi đang means I am; mang thai means pregnant.",
      "natural-variants": "If the answer changes, ask allergy, medicine, doctor, receipt, or clinic follow-ups.",
      "when-to-use": "Good at pharmacies, clinics, hospitals, hotel desks, and with guides helping translate health details.",
      "good-to-know": "You do not need to explain everything first. This one fact can change which medicine is safe.",
      "explore-next": "Use doctor, allergy, medicine, pharmacy, or medical-report follow-ups if the staff needs more context."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đang", english: "I am", keepTogetherReason: "current-state phrase" },
      { id: "chunk-2", vietnamese: "mang thai", english: "pregnant", keepTogetherReason: "pregnancy phrase" }
    ],
    value: "makes the pregnancy page direct, respectful, and medically practical while preserving the existing audio text"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-have-diarrhea",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-diarrhea.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-have-diarrhea.json",
    summary: "For naming diarrhea clearly at a pharmacy, clinic, or hotel desk.",
    beforeSummary: "I have diarrhea",
    bodies: {
      "at-glance": "Use this when you need medicine, oral rehydration salts, clinic advice, or help changing plans.",
      "quick-say": "Say the line plainly. Point to your stomach, a pharmacy shelf, or a translated note if needed.",
      breakdown: "Tôi bị means I have or I am affected by; tiêu chảy means diarrhea.",
      "natural-variants": "If the answer changes, ask pharmacy, doctor, stomach pain, allergy, or how to take this.",
      "when-to-use": "Good at pharmacies, clinics, hotel desks, tour counters, or with a guide helping translate.",
      "good-to-know": "Short and direct is kinder here. If symptoms are severe, ask for a doctor instead of only medicine.",
      "explore-next": "Use stomach, doctor, pharmacy, dosage, or allergy follow-ups if the staff needs the next detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị", english: "I have / I am affected by", keepTogetherReason: "condition phrase" },
      { id: "chunk-2", vietnamese: "tiêu chảy", english: "diarrhea", keepTogetherReason: "symptom phrase" }
    ],
    value: "keeps the health phrase direct while replacing repeated generic pharmacy helper prose"
  },
  {
    id: "viet-phrase-v500-hote-acco-the-toilet-is-not-working",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-the-toilet-is-not-working.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v500-hote-acco-the-toilet-is-not-working.json",
    summary: "For telling hotel staff the toilet in the room cannot be used.",
    beforeSummary: "The toilet is not working",
    title: "Bồn cầu không sử dụng được",
    englishTitle: "The toilet is not working",
    pronunciation: "Bon cau khong su dung duoc",
    audioPlanned: true,
    bodies: {
      "at-glance": "Say it with the room number visible so staff can send maintenance or change rooms.",
      "quick-say": "Use the line at the front desk or in a message. Add the room number, not a long explanation.",
      breakdown: "Bồn cầu means toilet; không sử dụng được means cannot be used.",
      "natural-variants": "If the issue affects the room, ask for cleaning, a room change, maintenance, or another bathroom.",
      "when-to-use": "Good at hotels, homestays, apartments, guesthouses, and reception desks.",
      "good-to-know": "Be specific if it will not flush, leaks, or is blocked. A photo can help if the desk is busy.",
      "explore-next": "Use room-change, maintenance, cleaning, front-desk, or bathroom follow-ups if the first answer is not enough."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bồn cầu", english: "toilet", keepTogetherReason: "toilet fixture phrase" },
      { id: "chunk-2", vietnamese: "không sử dụng được", english: "cannot be used / is not working", keepTogetherReason: "not-usable phrase" }
    ],
    value: "makes the hotel repair phrase more specific to the toilet fixture and moves stale audio to planned"
  },
  {
    id: "viet-phrase-v500-prob-help-can-i-leave-my-contact-information",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-can-i-leave-my-contact-information.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-can-i-leave-my-contact-information.json",
    summary: "For leaving your phone, email, or hotel contact so someone can follow up.",
    beforeSummary: "Can I leave my contact information?",
    bodies: {
      "at-glance": "Useful when a lost item, report, refund, repair, or booking problem will not be solved immediately.",
      "quick-say": "Show the phone number, email, room card, or hotel name. Ask before writing anything down.",
      breakdown: "Để lại means leave behind; thông tin liên lạc means contact information; được không asks if it is possible.",
      "natural-variants": "If they need more, use call hotel, text me, report, manager, or left-something follow-ups.",
      "when-to-use": "Good at hotel desks, police counters, clinics, shops, tour offices, and transport desks.",
      "good-to-know": "Write clearly and include country code if you use a non-Vietnam number. A hotel contact can be easier.",
      "explore-next": "Use phone-number, hotel-call, report, manager, or text-me follow-ups if the handoff needs one more step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "để lại", english: "leave behind", keepTogetherReason: "leave-contact action" },
      { id: "chunk-3", vietnamese: "thông tin liên lạc của mình", english: "my contact information", keepTogetherReason: "contact-information phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns contact-information into a concrete unresolved-problem handoff instead of generic help copy"
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

function selfSymbol(repair, page) {
  if (repair.audioPlanned || page.audioKey === null) return "text.bubble.fill";
  return "speaker.wave.2.fill";
}

function updateSelfPhrase(option, repair, page) {
  option.vietnamese = repair.title ?? page.title;
  option.english = repair.englishTitle ?? page.englishTitle;
  option.pronunciation = repair.pronunciation ?? option.pronunciation;
  option.symbolName = selfSymbol(repair, page);
  option.detailPageID = null;
  option.audioKey = repair.audioPlanned ? null : page.audioKey;
}

function updateSource(repair) {
  const page = readJson(repair.source);
  const before = {
    title: page.title,
    englishTitle: page.englishTitle,
    summary: page.summary,
    sections: Object.fromEntries((page.sections ?? []).map((section) => [section.id, section.body])),
    phraseCards: phraseCardCount(page),
    breakdownRows: breakdownCount(page)
  };

  if (repair.title) page.title = repair.title;
  if (repair.englishTitle) page.englishTitle = repair.englishTitle;
  if (repair.pronunciation) page.pronunciation = repair.pronunciation;
  if (repair.audioPlanned) page.audioKey = null;
  page.summary = repair.summary;

  for (const section of page.sections ?? []) {
    if (repair.bodies[section.id]) section.body = repair.bodies[section.id];
    if (section.phrases) {
      for (const option of section.phrases) {
        if (option.id === page.phraseID || option.detailPageID === null) {
          updateSelfPhrase(option, repair, page);
        }
      }
    }
    if (section.id === "breakdown") {
      section.breakdown = [
        ...repair.breakdown.map((entry) => ({ ...entry, audioKey: null })),
        {
          id: `chunk-${repair.breakdown.length + 1}`,
          vietnamese: page.title,
          english: page.englishTitle.replace(/[?!.]$/, ""),
          audioKey: page.audioKey ?? null
        }
      ];
    }
  }

  for (const example of page.examples ?? []) {
    if (example.id === page.phraseID || example.detailPageID === null) {
      updateSelfPhrase(example, repair, page);
    }
  }

  writeJson(repair.source, page);
  return {
    page,
    before,
    after: {
      title: page.title,
      englishTitle: page.englishTitle,
      summary: page.summary,
      sections: Object.fromEntries((page.sections ?? []).map((section) => [section.id, section.body])),
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

function parseCSV(text) {
  if (text.charCodeAt(0) === 0xfeff) text = text.slice(1);
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

function formatCSV(rows, includeBOM) {
  const body = rows.map((row) => row.map((field) => {
    const value = String(field ?? "");
    if (/[",\n\r]/.test(value)) return `"${value.replace(/"/g, "\"\"")}"`;
    return value;
  }).join(",")).join("\n");
  return `${includeBOM ? "\ufeff" : ""}${body}\n`;
}

function updateCSV(relPath, repairsByPhraseID) {
  const absPath = path.join(repoRoot, relPath);
  const original = fs.readFileSync(absPath, "utf8");
  const includeBOM = original.charCodeAt(0) === 0xfeff;
  const rows = parseCSV(original);
  const header = rows[0];
  const index = Object.fromEntries(header.map((name, i) => [name, i]));
  let changed = 0;
  for (let i = 1; i < rows.length; i += 1) {
    const row = rows[i];
    const phraseID = row[index.phrase_id];
    const repair = repairsByPhraseID.get(phraseID);
    if (!repair) continue;
    if (repair.title) {
      row[index.target_text] = repair.title;
      row[index.canonical_target_text] = repair.title;
    }
    if (repair.englishTitle) row[index.english_text] = repair.englishTitle;
    if (repair.pronunciation) row[index.pronunciation] = repair.pronunciation;
    if (repair.audioPlanned) {
      row[index.audio_status] = "planned";
      const note = row[index.notes] || "";
      if (!note.includes("Batch 12 semantic repair moved audio to planned")) {
        row[index.notes] = `${note}; Batch 12 semantic repair moved audio to planned`;
      }
    }
    changed += 1;
  }
  fs.writeFileSync(absPath, formatCSV(rows, includeBOM));
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
      batch: 12,
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
          "source/rendered breakdown mismatch risk"
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
      reason: "premium_audit_batch_12"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const hasBatch12Rows = existingLedgerRows.some((line) => {
    try {
      const row = JSON.parse(line);
      return row.batch === 12 || row.reason === "premium_audit_batch_12";
    } catch {
      return false;
    }
  });

  if (!hasBatch12Rows) {
    fs.appendFileSync(ledgerPath, `${ledgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 12,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    ledgerRows: hasBatch12Rows ? 0 : ledgerRows.length,
    ledgerSkippedAlreadyPresent: hasBatch12Rows,
    csvRowsUpdated: csvChanges.reduce((sum, count) => sum + count, 0),
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
