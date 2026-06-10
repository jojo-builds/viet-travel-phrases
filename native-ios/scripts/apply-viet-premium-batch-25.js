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
    id: "viet-phrase-v500-food-drin-does-this-contain-shrimp",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-does-this-contain-shrimp.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-does-this-contain-shrimp.json",
    summary: "For checking shrimp before you order, eat, or accept a dish.",
    bodies: {
      "at-glance": "Use it before tasting the dish. Point to the menu line, sauce, soup, or topping so the answer stays about shrimp.",
      "quick-say": "Ask while the dish or photo is visible. If this is an allergy, show the allergy note before eating.",
      breakdown: "Cái này means this item; có chứa asks whether it contains; tôm means shrimp; không makes it a yes/no question.",
      "when-to-use": "Restaurants, street-food stalls, markets, and hotel buffets are the right places to check shrimp clearly.",
      "good-to-know": "Shrimp can appear in broths, sauces, fillings, or dried toppings. A yes/no answer matters more than a long explanation.",
      "explore-next": "Peanuts, egg, vegetarian, and peanut-allergy cards cover nearby food-safety checks.",
      "natural-variants": "No-meat, no-ingredient, safe-dish, pork-beef-chicken, and fish-sauce cards help if the answer changes the order."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this item", keepTogetherReason: "visible item" },
      { id: "chunk-2", vietnamese: "có chứa", english: "contains", keepTogetherReason: "contains phrase" },
      { id: "chunk-3", vietnamese: "tôm", english: "shrimp", keepTogetherReason: "ingredient noun" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a bare shrimp question into a clear allergy/order check while preserving food-safety cards"
  },
  {
    id: "viet-phrase-v500-hote-acco-can-i-check-in-early",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-can-i-check-in-early.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v500-hote-acco-can-i-check-in-early.json",
    summary: "For asking the front desk whether the room can be ready before normal check-in.",
    bodies: {
      "at-glance": "Ask before luggage, waiting time, or a tired arrival gets awkward. Keep the booking name and passport handy.",
      "quick-say": "Show the booking screen while you ask. The answer may be yes, a fee, a wait time, or luggage storage.",
      breakdown: "Tôi có thể asks can I; nhận phòng means check in; sớm means early; được không asks if it is possible.",
      "natural-variants": "Reservation, check-in, and polite check-in cards help if the desk needs to look up the stay.",
      "when-to-use": "Front desks and guesthouse counters are the right place to ask before normal check-in time.",
      "good-to-know": "Early check-in often depends on housekeeping. If the room is not ready, ask where to leave luggage.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover the next front-desk needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I phrase" },
      { id: "chunk-2", vietnamese: "nhận phòng", english: "check in", keepTogetherReason: "hotel check-in phrase" },
      { id: "chunk-3", vietnamese: "sớm", english: "early", keepTogetherReason: "time adverb" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces generic hotel scaffolding with a real early-arrival front-desk request"
  },
  {
    id: "viet-phrase-v500-hote-acco-what-time-is-breakfast",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-what-time-is-breakfast.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v500-hote-acco-what-time-is-breakfast.json",
    summary: "For checking the hotel breakfast time before you plan the morning.",
    bodies: {
      "at-glance": "Ask at check-in, the front desk, or breakfast-room entrance. A room number or booking screen may help staff answer.",
      "quick-say": "Keep the question short and listen for the hour range. If the answer is fast, ask them to write or show the time.",
      breakdown: "Bữa sáng means breakfast; lúc asks at what time; mấy giờ asks which hour.",
      "natural-variants": "Reservation, check-in, and polite check-in cards help if the breakfast question starts at the desk.",
      "when-to-use": "Use it before early tours, airport rides, or checkout mornings when breakfast timing changes the plan.",
      "good-to-know": "Some stays have a breakfast window, not one exact time. Confirm the last serving time if the morning is tight.",
      "explore-next": "Checkout-time, quiet-room, checkout, hot-room, and air-conditioner cards cover nearby hotel logistics."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bữa sáng", english: "breakfast", keepTogetherReason: "breakfast noun" },
      { id: "chunk-2", vietnamese: "lúc mấy giờ?", english: "at what time?", keepTogetherReason: "time question" }
    ],
    value: "turns a title-only breakfast page into a practical morning-planning question"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-do-i-need-exact-change",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-do-i-need-exact-change.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-do-i-need-exact-change.json",
    title: "Tôi có cần trả đúng tiền không?",
    pronunciation: "Toi co can tra dung tien khong",
    audioPlanned: true,
    summary: "For checking whether the cashier, driver, stall, or ticket counter needs the exact amount.",
    bodies: {
      "at-glance": "Ask before handing over a large bill. Keep the price, fare, ticket total, or calculator screen visible.",
      "quick-say": "Show the cash while you ask. The answer may be yes, no, smaller bills, or a quick change request.",
      breakdown: "Tôi có cần asks do I need; trả đúng tiền means pay the exact amount; không makes it a yes/no question.",
      "natural-variants": "How-much and per-kilo cards help if the exact-change question starts from a price check.",
      "when-to-use": "Markets, buses, taxis, ticket windows, and small shops are where exact cash can matter.",
      "good-to-know": "If they cannot break a bill, ask for smaller bills or show another note before the payment gets tense.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the next money step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có cần", english: "do I need", keepTogetherReason: "need question" },
      { id: "chunk-2", vietnamese: "trả đúng tiền", english: "pay the exact amount", keepTogetherReason: "exact-payment phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "repairs the exact-change Vietnamese from a literal change/alteration phrase to a cash-payment question"
  },
  {
    id: "viet-phrase-v500-poli-basi-sorry",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v500-poli-basi-sorry.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/polite-basics/v500-poli-basi-sorry.json",
    title: "Tôi xin lỗi",
    pronunciation: "Toi xin loi",
    audioPlanned: true,
    summary: "For giving a direct apology after a small mistake, delay, bump, or misunderstanding.",
    bodies: {
      "at-glance": "Use it when you actually need to apologize, not just get attention. Keep the next words small.",
      "quick-say": "Say it calmly, then pause. If needed, add the mistake, item, room number, or request after the apology lands.",
      breakdown: "Tôi means I; xin lỗi means apologize or sorry.",
      "natural-variants": "Hello, thank-you, and thank-you-very-much cards cover softer polite openings.",
      "when-to-use": "Counters, rides, hotel desks, shops, and crowded walkways are common places for a quick apology.",
      "good-to-know": "Xin lỗi alone can mean excuse me or sorry. Tôi xin lỗi makes the apology more direct.",
      "explore-next": "Yes, no-thank-you, excuse-me, it's-okay, and goodbye cards cover the next polite move."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi", english: "I", keepTogetherReason: "speaker pronoun" },
      { id: "chunk-2", vietnamese: "xin lỗi", english: "am sorry / apologize", keepTogetherReason: "apology phrase" }
    ],
    value: "replaces formal regret wording with a distinct direct apology while preserving the lighter Xin loi card nearby"
  },
  {
    id: "viet-phrase-v900-bath-pers-need-is-there-a-fee-for-the-bathroom",
    source: "content-draft/viet/canonical-pages/catalog-promoted/bathroom-personal-needs/v900-bath-pers-need-is-there-a-fee-for-the-bathroom.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/bathroom-personal-needs/v900-bath-pers-need-is-there-a-fee-for-the-bathroom.json",
    title: "Nhà vệ sinh có tính phí không?",
    pronunciation: "Nha ve sinh co tinh phi khong",
    audioPlanned: true,
    summary: "For checking whether a restroom costs money before you enter or ask for a key.",
    bodies: {
      "at-glance": "Ask near cafes, stations, markets, beaches, or attractions where a small fee or ticket may apply.",
      "quick-say": "Point to the restroom sign or door while you ask. The answer may be a price, token, key, or free-use nod.",
      breakdown: "Nhà vệ sinh means restroom; có tính phí asks whether there is a fee; không makes it a yes/no question.",
      "natural-variants": "Bathroom, toilet paper, and bathroom-use cards cover nearby restroom questions.",
      "when-to-use": "Public restrooms, station stops, markets, and small cafes are the places where the fee may be unclear.",
      "good-to-know": "Have small cash ready if the answer is yes. Some places charge for paper, entry, or a shower separately.",
      "explore-next": "Soap, hand-washing, water, shower, and toilet-location cards cover the next personal-needs step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Nhà vệ sinh", english: "restroom", keepTogetherReason: "restroom phrase" },
      { id: "chunk-2", vietnamese: "có tính phí", english: "has a fee", keepTogetherReason: "fee phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "repairs bathroom wording toward restroom fee, not shower/bathroom-room language"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-have-rice-with-this",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-rice-with-this.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-rice-with-this.json",
    title: "Cho tôi cơm ăn kèm được không?",
    pronunciation: "Cho toi com an kem duoc khong",
    audioPlanned: true,
    summary: "For asking whether rice can come with the dish you are ordering.",
    bodies: {
      "at-glance": "Useful with grilled dishes, soups, curries, and shared plates when rice is not obvious on the menu.",
      "quick-say": "Point to the dish while you ask. Staff may answer with yes, a price, or a different rice option.",
      breakdown: "Cho tôi asks give me; cơm means rice; ăn kèm means to go with it; được không asks if possible.",
      "when-to-use": "Casual restaurants, food stalls, rice shops, and hotel kitchens are the natural places to ask.",
      "good-to-know": "Rice may be included, extra, or ordered separately. Let staff point to the menu or price if needed.",
      "explore-next": "Napkins, half-portion, two-of-these, one-more, and one-portion cards cover the rest of the order.",
      "natural-variants": "Herbs, utensils, soup-on-the-side, sauce, and lime cards cover nearby side requests."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cho tôi", english: "give me / please give me", keepTogetherReason: "request opener" },
      { id: "chunk-2", vietnamese: "cơm", english: "rice", keepTogetherReason: "rice noun" },
      { id: "chunk-3", vietnamese: "ăn kèm", english: "to go with it", keepTogetherReason: "with-the-dish phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    sectionPhrases: {
      "explore-next": [
        { id: "v900-food-drin-can-i-have-napkins", vietnamese: "Cho tôi xin khăn giấy được không?", english: "Can I have napkins?", pronunciation: "Cho toi xin khan giay duoc khong", symbolName: "text.bubble.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-can-i-have-napkins", audioKey: "audio-authored-cho-toi-xin-khan-giay-duoc-khong-7718394956" },
        { id: "v900-food-drin-can-i-order-half-a-portion", vietnamese: "Tôi có thể gọi một nửa phần được không?", english: "Can I order half a portion?", pronunciation: "Toi co the goi mot nua phan duoc khong", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-can-i-order-half-a-portion", audioKey: "v900-food-drin-can-i-order-half-a-portion" },
        { id: "v900-food-drin-two-of-these-please", vietnamese: "Xin vui lòng cho hai trong số này", english: "Two of these, please", pronunciation: "Xin vui long cho hai trong so nay", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-two-of-these-please", audioKey: "v900-food-drin-two-of-these-please" },
        { id: "v900-food-drin-one-more-please", vietnamese: "Xin thêm một cái nữa", english: "One more, please", pronunciation: "Xin them mot cai nua", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-one-more-please", audioKey: "v900-food-drin-one-more-please" },
        { id: "food-1", vietnamese: "Cho tôi một phần", english: "One portion please", pronunciation: "cho toy mot fun", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-family-food-one-portion", audioKey: "food-1" }
      ]
    },
    value: "repairs a literal rice question into a natural side-rice request and mirrors the richer rendered food follow-up set"
  },
  {
    id: "viet-phrase-v900-food-drin-that-was-very-good",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-that-was-very-good.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-that-was-very-good.json",
    title: "Món này rất ngon",
    pronunciation: "Mon nay rat ngon",
    audioPlanned: true,
    summary: "For complimenting a dish after tasting it or finishing the meal.",
    bodies: {
      "at-glance": "Use it with staff, a cook, or a host when you want the compliment to land on the food, not the whole situation.",
      "quick-say": "Point to the dish or empty plate while you say it. A smile does most of the extra work.",
      breakdown: "Món này means this dish; rất ngon means very delicious.",
      "when-to-use": "Restaurants, homestays, cooking classes, and street-food stalls are natural places for this small compliment.",
      "good-to-know": "Ngon is the food word travelers want here. It sounds warmer and more natural than a literal good.",
      "explore-next": "Peanut-allergy, recommendation, mild-food, less-spicy, and too-spicy cards cover the next food conversation.",
      "natural-variants": "This-bowl, not-spicy, utensils, pack-to-go, and pay-now cards cover nearby meal flow."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Món này", english: "this dish", keepTogetherReason: "dish phrase" },
      { id: "chunk-2", vietnamese: "rất ngon", english: "very delicious", keepTogetherReason: "food compliment" }
    ],
    sectionPhrases: {
      "explore-next": [
        { id: "food-peanut-allergy", vietnamese: "Tôi bị dị ứng đậu phộng", english: "I am allergic to peanuts", pronunciation: "toy bee zee ung dow fong", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-family-food-peanut-allergy", audioKey: "food-peanut-allergy" },
        { id: "v900-food-drin-what-do-you-recommend", vietnamese: "Bạn đề xuất món gì?", english: "What do you recommend?", pronunciation: "Ban de xuat mon gi", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-what-do-you-recommend", audioKey: "v900-food-drin-what-do-you-recommend" },
        { id: "v900-food-drin-what-is-not-too-spicy", vietnamese: "Cái gì không quá cay?", english: "What is not too spicy?", pronunciation: "Cai gi khong qua cay", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-what-is-not-too-spicy", audioKey: "v900-food-drin-what-is-not-too-spicy" },
        { id: "v900-food-drin-please-make-it-less-spicy", vietnamese: "Làm ơn làm cho nó bớt cay đi", english: "Please make it less spicy", pronunciation: "Lam on lam cho no bot cay di", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-v900-food-drin-please-make-it-less-spicy", audioKey: "v900-food-drin-please-make-it-less-spicy" },
        { id: "food-premium-too-spicy-now", vietnamese: "Món này quá cay đối với tôi.", english: "This is too spicy for me.", pronunciation: "Mon nay qua cay doi voi toi", symbolName: "speaker.wave.2.fill", tintName: "green", detailPageID: "viet-phrase-food-premium-too-spicy-now", audioKey: "food-premium-too-spicy-now" }
      ]
    },
    value: "repairs an unnatural literal compliment into a food-specific compliment and preserves the richer rendered food cards"
  },
  {
    id: "viet-phrase-v900-heal-phar-is-this-safe-with-my-medicine",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-is-this-safe-with-my-medicine.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-is-this-safe-with-my-medicine.json",
    title: "Dùng cái này cùng thuốc của tôi có an toàn không?",
    pronunciation: "Dung cai nay cung thuoc cua toi co an toan khong",
    audioPlanned: true,
    summary: "For asking a pharmacist or clinician about mixing a new medicine with what you already take.",
    bodies: {
      "at-glance": "Show your current medicine, prescription, or translated note before you take the new item.",
      "quick-say": "Hold both medicines visible while you ask. Wait for a yes, no, dosage change, or doctor referral.",
      breakdown: "Dùng cái này means using this; cùng thuốc của tôi means with my medicine; có an toàn không asks is it safe.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards help if the safety question needs a professional handoff.",
      "when-to-use": "Pharmacies, clinics, and hotel medical desks are the right places for this interaction check.",
      "good-to-know": "Medicine names are easy to mishear. Showing the package or active ingredient matters more than repeating the phrase.",
      "explore-next": "Headache, stomach pain, motion-sickness medicine, allergy, and diarrhea cards cover nearby health needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Dùng cái này", english: "using this", keepTogetherReason: "use-this phrase" },
      { id: "chunk-2", vietnamese: "cùng thuốc của tôi", english: "with my medicine", keepTogetherReason: "with-my-medicine phrase" },
      { id: "chunk-3", vietnamese: "có an toàn không?", english: "is it safe?", keepTogetherReason: "safety question" }
    ],
    value: "turns medicine safety into a concrete interaction check with visible medicine context"
  },
  {
    id: "viet-phrase-v900-heal-phar-please-write-the-instructions",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v900-heal-phar-please-write-the-instructions.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v900-heal-phar-please-write-the-instructions.json",
    title: "Vui lòng viết hướng dẫn dùng thuốc",
    pronunciation: "Vui long viet huong dan dung thuoc",
    audioPlanned: true,
    summary: "For asking pharmacy or clinic staff to write the medicine instructions clearly.",
    bodies: {
      "at-glance": "Use it before leaving the counter. Keep the medicine box, dosage label, or translation screen visible.",
      "quick-say": "Point to the medicine and a note field. Written timing is safer than trying to remember fast speech.",
      breakdown: "Vui lòng means please; viết hướng dẫn means write instructions; dùng thuốc means taking medicine.",
      "natural-variants": "Doctor, pharmacy, and nearest-pharmacy cards help if you need a place or professional first.",
      "when-to-use": "Pharmacies, clinics, and hotel desks are where written dosage, timing, and warnings matter most.",
      "good-to-know": "Ask for morning, night, before food, after food, and number of days in writing if the answer is fast.",
      "explore-next": "Headache, stomach pain, motion-sickness medicine, allergy, and diarrhea cards cover nearby health needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "viết hướng dẫn", english: "write instructions", keepTogetherReason: "write-instructions phrase" },
      { id: "chunk-3", vietnamese: "dùng thuốc", english: "taking medicine", keepTogetherReason: "medicine-use phrase" }
    ],
    value: "repairs the health page from vague instructions into written medicine-dosage utility"
  },
  {
    id: "viet-phrase-v900-poli-basi-im-in-a-hurry",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v900-poli-basi-im-in-a-hurry.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/polite-basics/v900-poli-basi-im-in-a-hurry.json",
    title: "Tôi đang vội",
    pronunciation: "Toi dang voi",
    summary: "For politely explaining that time is tight before a counter, ride, or queue answer drags on.",
    bodies: {
      "at-glance": "Keep it calm. This is a time-pressure note, not a complaint.",
      "quick-say": "Say it once, then add the concrete request: taxi, bill, ticket, room key, or direction.",
      breakdown: "Tôi đang means I am; vội means in a hurry.",
      "natural-variants": "Hello, thank-you, and thank-you-very-much cards cover softer polite openings.",
      "when-to-use": "Use it at counters, rides, queues, or hotel desks when the other person can still help quickly.",
      "good-to-know": "A rushed tone can sound sharp. Calm wording plus the visible ticket, map, or bill works better.",
      "explore-next": "Yes, no-thank-you, excuse-me, it's-okay, and goodbye cards cover the next polite move."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đang", english: "I am", keepTogetherReason: "I-am phrase" },
      { id: "chunk-2", vietnamese: "vội", english: "in a hurry", keepTogetherReason: "hurry word" }
    ],
    value: "fixes casing and a bad breakdown gloss while making the hurry phrase usable at counters and rides"
  },
  {
    id: "viet-phrase-v900-sigh-acti-is-this-included-in-the-ticket",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-this-included-in-the-ticket.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v900-sigh-acti-is-this-included-in-the-ticket.json",
    summary: "For checking whether a ride, exhibit, guide, locker, or extra area is covered by your ticket.",
    bodies: {
      "at-glance": "Ask before paying twice or walking into the wrong line. Keep the ticket, wristband, or booking screen visible.",
      "quick-say": "Point to the thing you mean while you ask. Staff can answer yes, no, extra fee, or different entrance.",
      breakdown: "Cái này means this item; có bao gồm asks whether it is included; trong vé means in the ticket; không makes it a yes/no question.",
      "natural-variants": "Ticket price, start point, and photo-permission cards cover nearby attraction questions.",
      "when-to-use": "Attractions, museums, cable cars, tours, and activity desks are the right places to check inclusions.",
      "good-to-know": "Tickets may include the entrance but not lockers, rides, guides, or special zones. Pointing keeps the question precise.",
      "explore-next": "Closing time, meeting point, advance booking, tour booking, and entrance cards cover the next attraction detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this item", keepTogetherReason: "visible item" },
      { id: "chunk-2", vietnamese: "có bao gồm", english: "is included", keepTogetherReason: "included phrase" },
      { id: "chunk-3", vietnamese: "trong vé", english: "in the ticket", keepTogetherReason: "ticket phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a bare ticket-inclusion question into a concrete attraction extra-fee check"
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
    if (repair.sectionPhrases?.[section.id]) {
      next.phrases = repair.sectionPhrases[section.id];
    }
    if (section.id === "breakdown") {
      next.breakdown = withFullBreakdown(page, repair.breakdown);
    }
    return next;
  });
  alignSelfPhraseCards(page, repair);
  writeJson(repair.source, page);
  return { page, before };
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
  if (!fs.existsSync(absPath)) return 0;
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
        if (!note.includes("Batch 25 semantic repair moved audio to planned")) {
          row[index.notes] = `${note}; Batch 25 semantic repair moved audio to planned`;
        }
      }
    }
    changed += 1;
  }
  if (changed) fs.writeFileSync(absPath, formatCSV(rows, bomMode));
  return changed;
}

function updateSearchOnlySurfacing(repair) {
  if (!repair.title) return 0;
  const relPath = "content-draft/viet/search-only-surfacing-v1.json";
  const data = readJson(relPath);
  let changed = 0;
  for (const entry of data.entries || []) {
    if (entry.canonicalPageID !== repair.id && entry.originalPageID !== repair.id) continue;
    entry.vietnameseTitle = repair.title;
    changed += 1;
  }
  if (changed) writeJson(relPath, data);
  return changed;
}

function appendLedger(rows) {
  const existing = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const existingKeys = new Set(existing.flatMap((line) => {
    try {
      const row = JSON.parse(line);
      return [`${row.reason}:${row.pageID}`];
    } catch {
      return [];
    }
  }));
  const freshRows = rows.filter((row) => !existingKeys.has(`${row.reason}:${row.pageID}`));
  if (freshRows.length) {
    fs.appendFileSync(ledgerPath, `${freshRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }
  return freshRows.length;
}

function main() {
  const repairsByPhraseID = new Map();
  const ledgerRows = [];
  let searchOnlyChanges = 0;

  for (const repair of repairs) {
    const { page, before } = updateSource(repair);
    updateAudit(repair, page);
    searchOnlyChanges += updateSearchOnlySurfacing(repair);
    repairsByPhraseID.set(page.phraseID, repair);
    ledgerRows.push({
      batch: 25,
      tierRole: page.tierRole,
      sectionID: "page-visible-copy",
      sectionTitle: "Page visible copy",
      pageID: page.id,
      phraseID: page.phraseID,
      sourcePath: repair.source,
      before: {
        title: before.title,
        englishTitle: before.englishTitle,
        summary: before.summary,
        issues: [
          "title-as-summary",
          "formulaic projection prose",
          repair.audioPlanned ? "semantic audio replacement" : "visible prose/breakdown repair"
        ]
      },
      after: {
        title: page.title,
        englishTitle: page.englishTitle,
        summary: page.summary,
        sections: {
          atGlance: repair.bodies["at-glance"],
          quickSay: repair.bodies["quick-say"],
          breakdown: repair.bodies.breakdown
        }
      },
      preservedPhraseCards: countSectionItems(page, "phrases"),
      preservedBreakdownRows: countSectionItems(page, "breakdown"),
      concreteTravelerValueImproved: repair.value,
      reason: "premium_audit_batch_25"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-500/generated-rows.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];
  const ledgerRowsAdded = appendLedger(ledgerRows);

  console.log(JSON.stringify({
    batch: 25,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    searchOnlyChanges,
    ledgerRows: ledgerRowsAdded,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
