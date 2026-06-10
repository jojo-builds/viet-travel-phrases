#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-food-drin-i-do-not-eat-pork",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-i-do-not-eat-pork.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-i-do-not-eat-pork.json",
    summary: "For saying a pork-free food limit before you order, accept a bowl, or point at a tray.",
    bodies: {
      "at-glance": "Say it before the dish is chosen, especially around soups, skewers, dumplings, sausages, and mixed fillings.",
      "quick-say": "Point to the menu photo, buffet tray, or food cart while you say the line. Ask what meat is inside if the answer is unclear.",
      breakdown: "Tôi không means I do not; ăn means eat; thịt lợn means pork.",
      "when-to-use": "Good at noodle shops, banh mi counters, buffets, family meals, and street stalls with mixed toppings.",
      "good-to-know": "Pork can appear as broth, pate, minced filling, sausage, or topping. Ask the meat-type follow-up before ordering.",
      "explore-next": "No-meat, fish-sauce allergy, shellfish allergy, and broader allergy phrases cover the nearby food-safety path.",
      "natural-variants": "No-meat, without-ingredient, safe-dish, meat-type, and shrimp-check phrases help clarify the plate."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi không", english: "I do not", keepTogetherReason: "negative I-do-not phrase" },
      { id: "chunk-2", vietnamese: "ăn", english: "eat", keepTogetherReason: "eat verb" },
      { id: "chunk-3", vietnamese: "thịt lợn", english: "pork", keepTogetherReason: "pork phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-food-drin-can-i-order-this-without-meat",
        "viet-phrase-v500-food-drin-i-am-allergic-to-fish-sauce",
        "viet-phrase-v500-food-drin-i-am-allergic-to-shellfish",
        "viet-phrase-v500-food-drin-i-cannot-eat-this-because-of-an-allergy",
        "viet-phrase-v500-food-drin-i-ordered-this-without-peanuts"
      ]
    },
    cardParityLedger: {
      "explore-next": "aligns source to the rendered five-card food-safety flow instead of dropping allergy and no-meat follow-ups"
    },
    value: "turns a title-repeat pork limit into a practical food-safety ordering moment"
  },
  {
    id: "viet-phrase-v900-hote-acco-can-you-write-down-the-cancellation-policy",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-write-down-the-cancellation-policy.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-can-you-write-down-the-cancellation-policy.json",
    summary: "For getting cancellation rules in writing before you pay, extend, or leave a deposit.",
    bodies: {
      "at-glance": "The rule matters most when a room, tour, deposit, or date change is still undecided.",
      "quick-say": "Show the booking screen and ask for the written rule. A photo, message, or receipt is easier to compare later.",
      breakdown: "Bạn có thể asks can you; viết ra means write down; chính sách hủy means cancellation policy; được không makes it polite.",
      "when-to-use": "Good at hotel desks, tour counters, homestays, and booking chats before paying or changing dates.",
      "good-to-know": "Ask for the amount, deadline, and refund method in the same written note if money is involved.",
      "explore-next": "After the rule is written down, the next questions are usually canceling the stay, checking the deposit, or confirming where any refund goes.",
      "natural-variants": "Reservation and check-in phrases cover the opening move before policy details."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "viết ra", english: "write down", keepTogetherReason: "write-down phrase" },
      { id: "chunk-3", vietnamese: "chính sách hủy", english: "cancellation policy", keepTogetherReason: "cancellation-policy phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-hote-acco-i-want-to-cancel-my-stay",
        "viet-phrase-v900-hote-acco-was-the-deposit-refunded",
        "viet-phrase-v900-hote-acco-can-i-get-a-refund-for-the-room",
        "viet-phrase-v900-time-date-book-i-need-to-cancel-my-booking",
        "viet-phrase-v900-time-date-book-please-send-the-refund-to-this-card"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five visible cards from generic hotel asks to cancellation, deposit, and refund follow-ups"
    },
    value: "makes the cancellation-policy page a written-money-rules handoff instead of generic front-desk copy"
  },
  {
    id: "viet-phrase-v900-hote-acco-please-change-the-sheets",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-please-change-the-sheets.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-please-change-the-sheets.json",
    summary: "For asking housekeeping or the front desk to replace sheets that are dirty, damp, or not fresh.",
    bodies: {
      "at-glance": "The room is already assigned, and the problem is specific enough to name the sheets.",
      "quick-say": "Say the line and point to the bed or a photo. Keep the room number visible so staff know where to go.",
      breakdown: "Vui lòng means please; thay means change; ga trải giường means bed sheets.",
      "when-to-use": "Good at hotels, guesthouses, homestays, or apartment stays when the bed needs attention.",
      "good-to-know": "If the issue is urgent, ask when someone can come instead of retelling the whole room problem.",
      "explore-next": "If staff need more context, ask for someone to come, mention hot water or toilet trouble, or point to smoke smell or the key card.",
      "natural-variants": "Reservation and check-in phrases cover the front-desk opening if staff ask which room is yours."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "thay", english: "change", keepTogetherReason: "change verb" },
      { id: "chunk-3", vietnamese: "ga trải giường", english: "bed sheets", keepTogetherReason: "bed-sheets phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v500-hote-acco-can-someone-come-fix-it",
        "viet-phrase-hotel-premium-no-hot-water",
        "viet-phrase-v500-hote-acco-the-toilet-is-not-working",
        "viet-phrase-v900-hote-acco-the-room-smells-like-smoke",
        "viet-phrase-hotel-8"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five visible cards toward room-fix and housekeeping-adjacent problems without reducing card count"
    },
    value: "turns a bare housekeeping request into a concrete room-service moment"
  },
  {
    id: "viet-phrase-v900-hote-acco-the-water-pressure-is-too-low",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-the-water-pressure-is-too-low.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-the-water-pressure-is-too-low.json",
    summary: "For telling the front desk the shower or sink has too little pressure to use comfortably.",
    bodies: {
      "at-glance": "This is a room problem for staff to check, not a general complaint.",
      "quick-say": "Name the pressure problem first, then point to the bathroom, room number, or a short video if needed.",
      breakdown: "Áp lực nước means water pressure; quá thấp means too low.",
      "when-to-use": "Good after trying the shower, sink, or hose and needing staff to check the room.",
      "good-to-know": "A time estimate matters here. Ask when someone can come or whether another room is possible.",
      "explore-next": "If it turns into a room repair, ask for someone to come, mention no hot water or a broken toilet, or bring up heat and air conditioning.",
      "natural-variants": "Reservation and check-in phrases cover the desk opening if you need to identify the room first."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Áp lực nước", english: "water pressure", keepTogetherReason: "water-pressure phrase" },
      { id: "chunk-2", vietnamese: "quá thấp", english: "too low", keepTogetherReason: "too-low phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v500-hote-acco-can-someone-come-fix-it",
        "viet-phrase-hotel-premium-no-hot-water",
        "viet-phrase-v500-hote-acco-the-toilet-is-not-working",
        "viet-family-hotel-room-hot",
        "viet-family-hotel-aircon-broken"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five visible cards toward plumbing, heat, and room-fix follow-ups without reducing card count"
    },
    value: "makes the water-pressure page a specific room-fix request"
  },
  {
    id: "viet-phrase-v900-hote-acco-this-is-not-the-room-i-booked",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v900-hote-acco-this-is-not-the-room-i-booked.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v900-hote-acco-this-is-not-the-room-i-booked.json",
    summary: "For showing the booking does not match the room you were given.",
    bodies: {
      "at-glance": "The key works, but the room type, bed setup, view, or floor is not what you booked.",
      "quick-say": "Show the booking screen next to the room detail. Let staff compare the mismatch before adding more.",
      breakdown: "Đây không phải means this is not; phòng tôi đã đặt means the room I booked.",
      "when-to-use": "Good at check-in or right after entering the room, before unpacking or accepting the change.",
      "good-to-know": "Keep the exact room type visible: bed count, window, floor, or included feature.",
      "explore-next": "If the desk needs another path, ask about a different room, confirm the reservation name, request a higher or quieter room, or discuss a refund.",
      "natural-variants": "Reservation and check-in phrases help reopen the desk conversation if the booking has to be found."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây không phải", english: "this is not", keepTogetherReason: "this-is-not phrase" },
      { id: "chunk-2", vietnamese: "là", english: "is", keepTogetherReason: "is connector" },
      { id: "chunk-3", vietnamese: "phòng tôi đã đặt", english: "the room I booked", keepTogetherReason: "booked-room phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-hotel-premium-different-room",
        "viet-phrase-v900-hote-acco-the-reservation-is-under-this-name",
        "viet-phrase-v900-hote-acco-can-i-have-a-higher-floor",
        "viet-phrase-v900-hote-acco-can-i-have-a-room-away-from-the-street",
        "viet-phrase-v900-hote-acco-can-i-get-a-refund-for-the-room"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five visible cards toward booking mismatch, room change, and refund follow-ups"
    },
    value: "turns the wrong-room page into a specific booking mismatch repair"
  },
  {
    id: "viet-phrase-v900-poli-basi-im-very-sorry",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v900-poli-basi-im-very-sorry.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/polite-basics/v900-poli-basi-im-very-sorry.json",
    summary: "For giving a clear apology after a mistake, delay, bump, spill, or awkward moment.",
    bodies: {
      "at-glance": "A small, sincere apology is enough; the tone carries most of the meaning.",
      "quick-say": "Say it once, gently. If something needs fixing, follow with the practical request instead of overexplaining.",
      breakdown: "Tôi means I; rất means very; xin lỗi means sorry.",
      "when-to-use": "Good after bumping someone, arriving late, misunderstanding a price, or needing to correct yourself.",
      "good-to-know": "Vietnamese politeness often lives in tone and brevity. A calm face and short apology work better than a speech.",
      "explore-next": "Yes, no-thank-you, excuse-me, it-is-okay, and goodbye phrases cover the next polite turn.",
      "natural-variants": "Hello, thank-you, and thank-you-very-much phrases keep small exchanges warm."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "tôi", english: "I", keepTogetherReason: "I pronoun" },
      { id: "chunk-2", vietnamese: "rất", english: "very", keepTogetherReason: "very intensifier" },
      { id: "chunk-3", vietnamese: "xin lỗi", english: "sorry", keepTogetherReason: "sorry phrase" }
    ],
    value: "turns a bare apology page into a small social-repair moment"
  },
  {
    id: "viet-phrase-v900-shop-do-you-have-a-larger-size",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-do-you-have-a-larger-size.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-do-you-have-a-larger-size.json",
    summary: "For asking a shop or market stall for the same item one size bigger.",
    bodies: {
      "at-glance": "The item is already chosen; only the size needs to change.",
      "quick-say": "Hold up the item or tag while you ask. Pointing usually does more than a long explanation.",
      breakdown: "Bạn có asks do you have; kích thước means size; lớn hơn means larger; không makes it a yes/no question.",
      "when-to-use": "Good for clothes, hats, shoes, helmets, raincoats, and packed items where sizes are kept behind the counter.",
      "good-to-know": "If sizes are not labeled in English, point to the fit problem on yourself or the tag.",
      "explore-next": "Looking, pay-where, exchange, price, and lower-price phrases cover the next shop move.",
      "natural-variants": "Size, color, and try-on phrases help narrow the same item without starting over."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có", english: "do you have", keepTogetherReason: "do-you-have question frame" },
      { id: "chunk-2", vietnamese: "kích thước", english: "size", keepTogetherReason: "size phrase" },
      { id: "chunk-3", vietnamese: "lớn hơn", english: "larger", keepTogetherReason: "larger phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a generic larger-size page into a concrete shop-counter fit check"
  },
  {
    id: "viet-phrase-v900-shop-i-bought-the-wrong-size",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-i-bought-the-wrong-size.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-i-bought-the-wrong-size.json",
    summary: "For explaining that the item you bought is the wrong size before asking about an exchange.",
    bodies: {
      "at-glance": "The purchase is already made; the receipt, tag, and item need to be visible.",
      "quick-say": "Show the item and receipt together. Then point to the size tag or the fit problem.",
      breakdown: "Tôi mua means I bought; nhầm means by mistake; kích thước means size.",
      "when-to-use": "Good at a shop counter soon after buying clothes, sandals, raincoats, helmets, or packed goods.",
      "good-to-know": "A quick exchange is easier when the item is unused and the bag or receipt is still with you.",
      "explore-next": "Looking, pay-where, exchange, price, and lower-price phrases cover the next shop move.",
      "natural-variants": "Size, color, and try-on phrases help narrow the same item without starting over."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi mua", english: "I bought", keepTogetherReason: "I-bought phrase" },
      { id: "chunk-2", vietnamese: "nhầm", english: "by mistake", keepTogetherReason: "mistake marker" },
      { id: "chunk-3", vietnamese: "kích thước", english: "size", keepTogetherReason: "size phrase" }
    ],
    value: "turns the wrong-size page into a practical exchange setup"
  },
  {
    id: "viet-phrase-v900-shop-this-one-is-damaged",
    source: "content-draft/viet/canonical-pages/catalog-promoted/shopping/v900-shop-this-one-is-damaged.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/shopping/v900-shop-this-one-is-damaged.json",
    summary: "For showing a damaged item before asking what can be done.",
    bodies: {
      "at-glance": "The problem is visible, so point to the crack, tear, stain, dent, or missing part.",
      "quick-say": "Say the line calmly and show the item or photo. Keep the receipt or rental form ready if money is involved.",
      breakdown: "Cái này means this one; bị hỏng means is damaged or broken.",
      "when-to-use": "Good before paying, returning an item, checking a rental, or reporting something found in the room.",
      "good-to-know": "Show the damaged spot first, then ask about exchange, refund, or repair.",
      "explore-next": "Looking, pay-where, exchange, price, and lower-price phrases cover nearby shop decisions.",
      "natural-variants": "Size, color, and try-on phrases stay useful if the next step is replacing the item."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cái này", english: "this one", keepTogetherReason: "this-one phrase" },
      { id: "chunk-2", vietnamese: "bị hỏng", english: "is damaged", keepTogetherReason: "damaged phrase" }
    ],
    value: "turns a generic damaged-item page into a clear shop or rental proof moment"
  },
  {
    id: "viet-phrase-v900-time-date-book-id-like-to-book-for-two-people",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-id-like-to-book-for-two-people.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-id-like-to-book-for-two-people.json",
    summary: "For asking for a reservation for two before a restaurant, tour, room, class, or ticket slot fills up.",
    bodies: {
      "at-glance": "The head count is the key detail; the date and time can come right after.",
      "quick-say": "Say the line, then show the date, time, or place. Keep two fingers or the number on screen if the counter is loud.",
      breakdown: "Tôi muốn means I want; đặt chỗ means make a reservation; cho hai người means for two people.",
      "when-to-use": "Good for restaurants, classes, boat trips, spas, homestays, and ticketed activities where capacity matters.",
      "good-to-know": "If the answer is yes, confirm the time and name before putting the phone away.",
      "explore-next": "Booking, opening-time, move-later, boarding-time, and wait-time phrases cover the next time detail.",
      "natural-variants": "What-time, today, and tomorrow-morning phrases help pin down the reservation."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi muốn", english: "I want", keepTogetherReason: "I-want phrase" },
      { id: "chunk-2", vietnamese: "đặt chỗ", english: "make a reservation", keepTogetherReason: "reservation phrase" },
      { id: "chunk-3", vietnamese: "cho hai người", english: "for two people", keepTogetherReason: "two-people phrase" }
    ],
    value: "turns a booking title repeat into a concrete reservation head-count moment"
  },
  {
    id: "viet-phrase-v900-time-date-book-is-there-a-student-discount",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-there-a-student-discount.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-is-there-a-student-discount.json",
    summary: "For asking about a student discount before buying a ticket, class, tour, transport fare, or museum entry.",
    bodies: {
      "at-glance": "The student ID is the proof; show it before the price is finalized.",
      "quick-say": "Show the card or student app while you ask. The answer may depend on the ticket type or local rules.",
      breakdown: "Có asks is there; giảm giá means discount; cho sinh viên means for students; không makes it a yes/no question.",
      "when-to-use": "Good at museums, attractions, cinemas, tours, classes, buses, and ticket counters.",
      "good-to-know": "Some discounts are only for local schools or certain ages. Ask before paying, not after the receipt is printed.",
      "explore-next": "After the discount answer, you may need the ticket price, one ticket, today's date, a refund question, or the scan point.",
      "natural-variants": "What-time, today, and tomorrow-morning phrases help if the discount depends on the session."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "is there", keepTogetherReason: "is-there question opener" },
      { id: "chunk-2", vietnamese: "giảm giá", english: "discount", keepTogetherReason: "discount phrase" },
      { id: "chunk-3", vietnamese: "cho sinh viên", english: "for students", keepTogetherReason: "student phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-family-sight-ticket",
        "viet-family-v500-time-date-book-one-ticket-please",
        "viet-phrase-v900-time-date-book-is-this-ticket-for-today",
        "viet-phrase-v900-time-date-book-can-i-get-a-ticket-refund",
        "viet-phrase-v900-time-date-book-where-do-i-scan-the-ticket"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five visible cards toward ticket-price, ticket-date, refund, and scanning follow-ups"
    },
    value: "turns the student-discount page into a real ticket-counter price check"
  },
  {
    id: "viet-phrase-v900-time-date-book-please-send-it-by-email",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-send-it-by-email.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-send-it-by-email.json",
    summary: "For asking staff to send a receipt, ticket, booking note, or document to your email instead of paper.",
    bodies: {
      "at-glance": "The document matters later, so the email address needs to be clear.",
      "quick-say": "Show the email address on your phone while you say the line. Spell it slowly if they start typing.",
      breakdown: "Vui lòng means please; gửi means send; nó means it; qua email means by email.",
      "when-to-use": "Good for hotel invoices, tour confirmations, tickets, forms, receipts, and service documents.",
      "good-to-know": "Keep the inbox open until it arrives if the document is important for reimbursement or entry.",
      "explore-next": "For nearby document needs, ask for an invoice by email, a receipt by email, a report by email, or a paper receipt.",
      "natural-variants": "What-time, today, and tomorrow-morning phrases stay useful if the email confirms a booking time."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vui lòng", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "gửi", english: "send", keepTogetherReason: "send verb" },
      { id: "chunk-3", vietnamese: "nó", english: "it", keepTogetherReason: "it pronoun" },
      { id: "chunk-4", vietnamese: "qua email", english: "by email", keepTogetherReason: "email-delivery phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-hote-acco-can-you-email-me-the-invoice",
        "viet-phrase-v900-mone-numb-pric-can-you-email-the-receipt",
        "viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me",
        "viet-phrase-v900-heal-phar-can-you-email-the-report-to-me",
        "viet-family-service-receipt"
      ]
    },
    cardParityLedger: {
      "explore-next": "retargets five visible cards toward email, receipt, invoice, and report follow-ups without reducing card count"
    },
    value: "turns the email request into a document-delivery moment instead of a generic date/booking shell"
  }
];

console.log(JSON.stringify(applyRepairs(38, repairs), null, 2));
