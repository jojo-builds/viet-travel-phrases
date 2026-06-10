#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-airp-bord-arri-where-is-the-oversized-baggage-area",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-oversized-baggage-area.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-where-is-the-oversized-baggage-area.json",
    summary: "For finding the side counter, belt, or doorway where large luggage comes out after a flight.",
    bodies: {
      "at-glance": "Ask before waiting at the normal carousel with a stroller, surfboard, box, golf bag, or bulky suitcase.",
      "quick-say": "Keep the baggage tag and flight number visible. Airport staff can usually point to a side door, special belt, or service desk.",
      breakdown: "Khu vực means area; hành lý quá khổ means oversized baggage; ở đâu asks where.",
      "when-to-use": "Good in the arrivals hall, at baggage claim, or beside an airline counter when your item is too large for the regular belt.",
      "good-to-know": "Oversized items may arrive later than normal bags. Show the tag before explaining the item so staff can check the right flight.",
      "explore-next": "Baggage-claim, pickup-area, driver-meet, missing-bag, and visa cards cover the next airport move.",
      "natural-variants": "Immigration, domestic-terminal, and SIM-card cards help when the answer sends you back across the arrivals hall."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Khu vực", english: "area", keepTogetherReason: "area noun" },
      { id: "chunk-2", vietnamese: "hành lý quá khổ", english: "oversized baggage", keepTogetherReason: "oversized-baggage phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where ending" }
    ],
    value: "turns a bare airport title into a practical oversized-luggage arrival check"
  },
  {
    id: "viet-phrase-v900-dire-navi-where-do-i-meet-the-tour-group",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-where-do-i-meet-the-tour-group.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-where-do-i-meet-the-tour-group.json",
    summary: "For finding the exact tour meeting point before the guide, van, boat, or group walks away.",
    bodies: {
      "at-glance": "Ask with the booking screen, tour name, and start time open so the answer can be a lobby, gate, landmark, or desk.",
      "quick-say": "Show the tour name first. A guard, receptionist, ticket seller, or cafe staffer may know the meeting spot even if they are not the guide.",
      breakdown: "Tôi gặp means I meet; nhóm du lịch means tour group; ở đâu asks where.",
      "when-to-use": "Good before walking around a crowded plaza, hotel lobby, pier, museum, station, or attraction entrance looking for the group.",
      "good-to-know": "If the answer is a landmark, ask them to point or show it on the map before you leave the counter.",
      "explore-next": "Turn-left, right, straight, nearby, and walking-time cards cover the route once the meeting point is named.",
      "natural-variants": "Excuse-me, how-to-get-there, and near-here cards keep the same direction exchange moving."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi gặp", english: "I meet", keepTogetherReason: "meet phrase" },
      { id: "chunk-2", vietnamese: "nhóm du lịch", english: "tour group", keepTogetherReason: "tour-group phrase" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where ending" }
    ],
    value: "turns a generic where-page into a tour pickup and meeting-point page"
  },
  {
    id: "viet-phrase-v900-dire-navi-where-is-the-exit-to-the-street",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-exit-to-the-street.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-where-is-the-exit-to-the-street.json",
    summary: "For getting out of a station, mall, market, clinic, or parking level onto the street.",
    bodies: {
      "at-glance": "Ask while you are still near staff, signs, escalators, or security instead of guessing through a maze of exits.",
      "quick-say": "Point toward the hallway or show the map. The useful answer is usually a floor, escalator, door number, or street-side landmark.",
      breakdown: "Lối ra means exit; đường means street; ở đâu asks where.",
      "when-to-use": "Good inside bus stations, airports, markets, malls, apartment towers, hospitals, and parking garages with several exits.",
      "good-to-know": "In big buildings, the right exit matters more than the shortest path. Confirm the street side if a ride or hotel is waiting.",
      "explore-next": "Turn-left, right, straight, nearby, and walking-time cards cover the walk after you reach the street.",
      "natural-variants": "Excuse-me, how-to-get-there, and near-here cards help if the answer becomes a longer route."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Lối ra", english: "exit", keepTogetherReason: "exit noun" },
      { id: "chunk-2", vietnamese: "đường", english: "street", keepTogetherReason: "street noun" },
      { id: "chunk-3", vietnamese: "ở đâu?", english: "where?", keepTogetherReason: "where ending" }
    ],
    value: "turns a repeated directions page into a building-exit decision with route context"
  },
  {
    id: "viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-cooler",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-we-sit-somewhere-cooler.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-we-sit-somewhere-cooler.json",
    title: "Chúng tôi có thể ngồi chỗ nào mát hơn được không?",
    pronunciation: "Chung toi co the ngoi cho nao mat hon duoc khong",
    audioKey: null,
    audioStatus: "planned",
    summary: "For asking to move toward shade, a fan, or air-conditioning when the heat is starting to matter.",
    bodies: {
      "at-glance": "Ask before ordering, waiting, or unpacking bags if the current seat is too hot to stay comfortable.",
      "quick-say": "Gesture toward the cooler table, fan, shade, or indoor area. Keep the request light so staff can offer a practical alternative.",
      breakdown: "Chúng tôi có thể asks can we; ngồi chỗ nào means sit somewhere; mát hơn means cooler; được không asks is that possible.",
      "when-to-use": "Good in cafes, food courts, hotel lobbies, tour stops, waiting rooms, and open-air restaurants during hot hours.",
      "good-to-know": "A small move may solve it: one table nearer a fan, away from sun, or inside for a few minutes.",
      "explore-next": "Sit-inside, sit-outside, air-conditioning, table, and seat-available cards cover the next comfort move.",
      "natural-variants": "Sit-by-the-fan, can-I-sit-here, and seats-together cards keep the seating request close."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chúng tôi có thể", english: "can we", keepTogetherReason: "traveler-party can-we phrase" },
      { id: "chunk-2", vietnamese: "ngồi chỗ nào", english: "sit somewhere", keepTogetherReason: "sit-somewhere phrase" },
      { id: "chunk-3", vietnamese: "mát hơn", english: "cooler", keepTogetherReason: "cooler phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite possibility ending" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-food-drin-can-we-sit-by-the-fan",
        "viet-phrase-v900-poli-basi-can-i-sit-here",
        "viet-phrase-v900-time-date-book-can-i-have-seats-together"
      ],
      "explore-next": [
        "viet-phrase-v900-food-drin-can-we-sit-inside",
        "viet-phrase-v900-food-drin-can-we-sit-outside",
        "viet-family-transport-aircon",
        "viet-family-food-need-table",
        "viet-phrase-v900-tran-is-this-seat-available"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic errand cards with seating-specific fan, permission, and group-seat follow-ups",
      "explore-next": "replaces generic store-service cards with inside/outside, air-conditioning, table, and seat-availability follow-ups"
    },
    value: "turns a title repeat into a useful heat-comfort seating request"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-is-this-price-in-vietnamese-dong",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-is-this-price-in-vietnamese-dong.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-is-this-price-in-vietnamese-dong.json",
    summary: "For confirming the currency on a quote, deposit, bill, or booking before money changes hands.",
    bodies: {
      "at-glance": "Point to the number and ask before tapping a card, handing over cash, or approving a transfer.",
      "quick-say": "Keep the price tag, calculator, receipt, booking screen, or card terminal visible so the currency and amount stay together.",
      breakdown: "Giá này means this price; đồng Việt Nam means Vietnamese dong; phải không asks right?",
      "when-to-use": "Good around tours, hotels, airport services, online bookings, SIM shops, and stalls where dollars and dong can be mixed.",
      "good-to-know": "Currency confusion gets expensive quickly. Ask while the number is visible, then repeat the amount if needed.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the ordinary price follow-up.",
      "natural-variants": "How-much and per-kilo cards help when the issue is the number itself rather than the currency."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Giá này", english: "this price", keepTogetherReason: "this-price phrase" },
      { id: "chunk-2", vietnamese: "bằng đồng Việt Nam", english: "in Vietnamese dong", keepTogetherReason: "Vietnamese-dong phrase" },
      { id: "chunk-3", vietnamese: "phải không?", english: "right?", keepTogetherReason: "confirmation ending" }
    ],
    value: "turns a bare currency question into a payment-safety page"
  },
  {
    id: "viet-phrase-v900-mone-numb-pric-what-is-the-exchange-rate",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-what-is-the-exchange-rate.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v900-mone-numb-pric-what-is-the-exchange-rate.json",
    summary: "For asking the rate a counter, hotel, shop, or driver is using before you exchange or compare money.",
    bodies: {
      "at-glance": "Ask before accepting a conversion, especially when a calculator, note, bill, or foreign-currency amount is already visible.",
      "quick-say": "Show the cash, quoted amount, or calculator. Then let the other person write or type the rate instead of explaining it aloud.",
      breakdown: "Tỷ giá hối đoái means exchange rate; là gì asks what is it.",
      "when-to-use": "Good at exchange counters, hotel desks, tour offices, border towns, and shops quoting in more than one currency.",
      "good-to-know": "Rates can include a fee or a worse round number. Ask for the total you will receive before handing over cash.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover the money conversation after the rate is clear.",
      "natural-variants": "How-much and per-kilo cards stay useful when the next question is a price rather than a conversion."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tỷ giá hối đoái", english: "exchange rate", keepTogetherReason: "exchange-rate phrase" },
      { id: "chunk-2", vietnamese: "là gì?", english: "what is it?", keepTogetherReason: "what-is-it ending" }
    ],
    value: "turns a repeated money title into an exchange-counter decision page"
  },
  {
    id: "viet-phrase-v900-time-date-book-do-you-have-anything-available-this-afternoon",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-do-you-have-anything-available-this-afternoon.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-do-you-have-anything-available-this-afternoon.json",
    title: "Chiều nay còn chỗ trống không?",
    pronunciation: "Chieu nay con cho trong khong",
    audioKey: null,
    audioStatus: "planned",
    summary: "For asking whether a booking desk, salon, clinic, tour, or table has an open slot this afternoon.",
    bodies: {
      "at-glance": "Ask with today's date, your preferred time, and the service you want visible on your phone or booking note.",
      "quick-say": "Say the line once, then show the time window. Staff can answer with yes, no, or a specific opening.",
      breakdown: "Chiều nay means this afternoon; còn chỗ trống asks whether there is still an open spot; không makes it a yes/no question.",
      "when-to-use": "Good for tours, cafes, restaurants, clinics, spas, laundry pickups, and ticket counters when morning is already gone.",
      "good-to-know": "If they offer a time, confirm the exact hour before giving your name or deposit.",
      "explore-next": "Booking, opening-time, move-it-later, boarding-time, and wait-list cards cover the scheduling follow-up.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help when afternoon availability is not possible."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Chiều nay", english: "this afternoon", keepTogetherReason: "this-afternoon phrase" },
      { id: "chunk-2", vietnamese: "còn chỗ trống", english: "still an open spot", keepTogetherReason: "availability phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a thin booking question into a concrete same-day availability page"
  },
  {
    id: "viet-phrase-repair-premium-simpler-words",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/repair-premium-simpler-words.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/repair-simpler-words.json",
    summary: "For slowing a complicated explanation down without blaming the other person or ending the exchange.",
    bodies: {
      "at-glance": "Ask after one or two sentences have gone past you and you need easier words, not just a slower repeat.",
      "quick-say": "Keep your tone soft and hold the receipt, form, address, or screen in view. The other person can point to the simple part.",
      breakdown: "Bạn có thể asks can you; sử dụng means use; những từ đơn giản hơn means simpler words.",
      "when-to-use": "Good at desks, clinics, counters, hotels, and ticket offices when the topic is clear but the vocabulary is too much.",
      "good-to-know": "This works best with one visible object. Show the line, price, address, or field that needs plainer wording.",
      "explore-next": "Repeat, write-it-down, meaning, number, and show-me cards cover the next repair move.",
      "natural-variants": "Do-not-understand, slower, and polite-slower cards help when the whole sentence needs another pass."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "sử dụng", english: "use", keepTogetherReason: "use verb" },
      { id: "chunk-3", vietnamese: "những từ đơn giản hơn?", english: "simpler words?", keepTogetherReason: "simpler-words phrase" }
    ],
    value: "turns a scaffolded repair phrase into a respectful comprehension tool"
  },
  {
    id: "viet-phrase-transport-premium-wait-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/transport-premium-wait-here.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/transport-wait-here.json",
    summary: "For asking a driver or pickup contact to stay put while you walk toward them.",
    bodies: {
      "at-glance": "Send or show it when the driver is nearby but you still need a minute to reach the car, bike, gate, or curb.",
      "quick-say": "Keep the pickup point, plate, or chat open. The sentence works best with a small wave or map location so they know where to wait.",
      breakdown: "Xin hãy đợi means please wait; ở đây means here; tôi đang tới means I am coming.",
      "when-to-use": "Good at airports, hotels, bus stations, ferry piers, cafes, and crowded pickup lanes where moving early can break the meet-up.",
      "good-to-know": "If traffic rules prevent stopping, switch to a pickup-point or call-driver phrase instead of repeating this one.",
      "explore-next": "Stop-here, go-this-way, air-conditioning, fare, and meter cards cover the ride once you meet.",
      "natural-variants": "Take-me-here, District-1, and stop-here cards cover the normal taxi direction sequence."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy đợi", english: "please wait", keepTogetherReason: "please-wait phrase" },
      { id: "chunk-2", vietnamese: "ở đây,", english: "here,", keepTogetherReason: "here phrase" },
      { id: "chunk-3", vietnamese: "tôi đang tới.", english: "I am coming.", keepTogetherReason: "I-am-coming phrase" }
    ],
    value: "turns a repeated transport page into a pickup coordination page"
  },
  {
    id: "viet-phrase-v500-heal-phar-i-need-a-hospital",
    source: "content-draft/viet/canonical-pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-need-a-hospital.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/health-pharmacy/v500-heal-phar-i-need-a-hospital.json",
    summary: "For telling a pharmacist, hotel desk, clinic, or helper that the situation needs a hospital now.",
    bodies: {
      "at-glance": "Say the need first, then show the symptom, injury, medicine packet, location, or translated note.",
      "quick-say": "Keep the sentence short. If the person understands the urgency, move to transport, ambulance, or address details immediately.",
      breakdown: "Tôi cần means I need; một bệnh viện means a hospital.",
      "when-to-use": "Good when a pharmacy answer is not enough, pain is serious, an injury needs care, or staff should help you choose the nearest hospital.",
      "good-to-know": "If breathing, heavy bleeding, chest pain, or severe allergy is involved, use emergency or ambulance phrases rather than waiting for a long explanation.",
      "explore-next": "Headache, stomach, motion-sickness, allergy, and diarrhea cards cover symptom detail only if the situation stays non-urgent.",
      "natural-variants": "Doctor and pharmacy-location cards help when staff say a hospital is not necessary."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "một bệnh viện", english: "a hospital", keepTogetherReason: "hospital phrase" }
    ],
    value: "turns a bare hospital title into a health-escalation page with urgency guidance"
  },
  {
    id: "viet-phrase-v500-soci-smal-talk-i-need-to-rest-for-a-moment",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-i-need-to-rest-for-a-moment.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-i-need-to-rest-for-a-moment.json",
    summary: "For politely pausing a walk, tour, conversation, or errand when heat or fatigue catches up.",
    bodies: {
      "at-glance": "Say it before you are visibly struggling. It gives the other person a clear reason to slow down without a big explanation.",
      "quick-say": "Gesture toward a bench, shade, wall, or lobby if you need a place to pause. A calm tone keeps it from sounding dramatic.",
      breakdown: "Tôi cần means I need; nghỉ ngơi means rest; một lát means for a moment.",
      "when-to-use": "Good during market walks, tours, temple visits, hotel check-ins, family visits, and friendly chats that have gone longer than expected.",
      "good-to-know": "If the issue is heat, dizziness, or pain, switch to water, pharmacy, doctor, or hospital phrases instead of treating it like small talk.",
      "explore-next": "Like-Vietnam, food-good, hot-weather, how-are-you, and first-time cards cover lighter chat after the pause.",
      "natural-variants": "From-US, from-UK, and first-time cards stay close when the conversation resumes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "nghỉ ngơi", english: "rest", keepTogetherReason: "rest verb" },
      { id: "chunk-3", vietnamese: "một lát", english: "for a moment", keepTogetherReason: "short-time phrase" }
    ],
    value: "turns a generic small-talk page into a useful fatigue and heat pause"
  },
  {
    id: "viet-phrase-v500-unde-repa-please-be-patient-with-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-please-be-patient-with-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-please-be-patient-with-me.json",
    summary: "For keeping a tense or rushed exchange kind while you catch up with the language.",
    bodies: {
      "at-glance": "Say it when the other person is moving faster than you can understand and you need one calm beat.",
      "quick-say": "Pair the line with a small nod, open phone, receipt, or form. Then ask for the exact repair you need: repeat, write, show, or point.",
      breakdown: "Xin hãy means please; kiên nhẫn means be patient; với tôi means with me.",
      "when-to-use": "Good at counters, clinics, hotels, stations, and police or security desks when pressure is rising but you still need cooperation.",
      "good-to-know": "This is a bridge phrase. Follow it with a specific request so the other person knows how to help.",
      "explore-next": "Repeat, write-it-down, meaning, number, and show-me cards cover the practical follow-up.",
      "natural-variants": "Do-not-understand, slower, and polite-slower cards help when you need the sentence itself repeated."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy", english: "please", keepTogetherReason: "polite request frame" },
      { id: "chunk-2", vietnamese: "kiên nhẫn", english: "be patient", keepTogetherReason: "be-patient phrase" },
      { id: "chunk-3", vietnamese: "với tôi", english: "with me", keepTogetherReason: "with-me phrase" }
    ],
    value: "turns a mechanical repair page into a calm de-escalation phrase with next action"
  }
];

console.log(JSON.stringify(applyRepairs(41, repairs), null, 2));
