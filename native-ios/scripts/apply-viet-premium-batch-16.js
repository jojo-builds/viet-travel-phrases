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
    id: "viet-phrase-v900-loca-serv-ever-task-can-you-print-this-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-print-this-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v900-loca-serv-ever-task-can-you-print-this-for-me.json",
    title: "Anh/chị in cái này giúp tôi được không?",
    englishTitle: "Can you print this for me?",
    pronunciation: "Anh chi in cai nay giup toi duoc khong",
    audioPlanned: true,
    beforeSummary: "Can you print this for me?",
    summary: "For asking a hotel desk, copy shop, or service counter to print the file on your phone.",
    bodies: {
      "at-glance": "Use it when the document is visible and the next step is a printed copy, not a long explanation.",
      "quick-say": "Open the file first. Show the screen, then ask once and let staff point to price, paper size, or pickup time.",
      breakdown: "Anh/chị is a polite you; in cái này means print this; giúp tôi means help me; được không softens the request.",
      "natural-variants": "If the print job needs detail, move to black-and-white, copy, scan, email, or receipt follow-ups.",
      "when-to-use": "Good at hotel desks, copy shops, tour offices, visa errands, clinics, and counters that handle documents.",
      "good-to-know": "Printing requests move faster when the file is already open and the name is easy to see.",
      "explore-next": "Use copy, scan, black-and-white, email-it, or receipt cards if the counter needs one more instruction."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Anh/chị", english: "you", keepTogetherReason: "polite address" },
      { id: "chunk-2", vietnamese: "in cái này", english: "print this", keepTogetherReason: "print-this phrase" },
      { id: "chunk-3", vietnamese: "giúp tôi", english: "help me / for me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a generic print request into a practical document-counter moment with natural Vietnamese"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-is-this-the-correct-location-pin",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-is-this-the-correct-location-pin.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-is-this-the-correct-location-pin.json",
    title: "Vị trí này có đúng không?",
    englishTitle: "Is this the correct location?",
    pronunciation: "Vi tri nay co dung khong",
    audioPlanned: true,
    beforeSummary: "Is this the correct location pin?",
    summary: "For checking a map location before you walk, wait, or send it to a driver.",
    bodies: {
      "at-glance": "Use it while the map is open and one dot, entrance, or pickup point needs confirmation.",
      "quick-say": "Point to the screen. Wait for yes, no, or a corrected spot before moving.",
      breakdown: "Vị trí này means this location; có đúng means is correct; không makes it a yes/no question.",
      "natural-variants": "If the location is wrong, move to address, pickup, entrance, map not working, or type-the-address follow-ups.",
      "when-to-use": "Good with ride-hailing drivers, hotel desks, tour pickups, cafe meetups, and shops with more than one entrance.",
      "good-to-know": "Map dots can land on a back door, side street, or old listing. A quick check saves the wrong wait.",
      "explore-next": "Use pickup-here, correct-address, map-not-working, type-address, or entrance cards if the location needs another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Vị trí này", english: "this location", keepTogetherReason: "shown-location phrase" },
      { id: "chunk-2", vietnamese: "có đúng", english: "is correct", keepTogetherReason: "correctness phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "removes the misleading pin-as-battery wording and makes the page a real map-location check"
  },
  {
    id: "viet-phrase-v900-phon-inte-powe-the-wi-fi-keeps-disconnecting",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-the-wi-fi-keeps-disconnecting.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v900-phon-inte-powe-the-wi-fi-keeps-disconnecting.json",
    title: "Wi-Fi cứ bị ngắt kết nối",
    englishTitle: "The Wi-Fi keeps disconnecting",
    pronunciation: "Wi-Fi cu bi ngat ket noi",
    audioPlanned: true,
    beforeSummary: "The Wi-Fi keeps disconnecting",
    summary: "For showing that the Wi-Fi connects, drops, and needs help staying online.",
    bodies: {
      "at-glance": "Use it when the password worked but the connection keeps falling out.",
      "quick-say": "Keep the Wi-Fi screen open. Let staff see the network name, error, or reconnect loop.",
      breakdown: "Wi-Fi names the connection; cứ bị means keeps getting; ngắt kết nối means disconnected.",
      "natural-variants": "If the fix is different, move to password, charger, SIM, data top-up, or map-not-working follow-ups.",
      "when-to-use": "Good at hotels, cafes, coworking rooms, SIM shops, and anywhere the connection matters before you can move on.",
      "good-to-know": "The screen is the proof. It saves everyone from guessing whether the problem is password, signal, or the network.",
      "explore-next": "Use Wi-Fi password, eSIM not working, data top-up, charge-phone, or map-not-working cards if the connection problem changes."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Wi-Fi", english: "Wi-Fi", keepTogetherReason: "connection name" },
      { id: "chunk-2", vietnamese: "cứ bị", english: "keeps getting", keepTogetherReason: "repeated-problem phrase" },
      { id: "chunk-3", vietnamese: "ngắt kết nối", english: "disconnected", keepTogetherReason: "disconnect phrase" }
    ],
    value: "makes the Wi-Fi page about repeated drops instead of generic phone troubleshooting"
  },
  {
    id: "viet-phrase-v900-time-date-book-please-send-it-by-text-message",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-send-it-by-text-message.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-send-it-by-text-message.json",
    title: "Anh/chị gửi qua tin nhắn giúp tôi được không?",
    englishTitle: "Can you send it by text message?",
    pronunciation: "Anh chi gui qua tin nhan giup toi duoc khong",
    audioPlanned: true,
    beforeSummary: "Please send it by text message",
    summary: "For getting a time, address, booking detail, or confirmation in writing on your phone.",
    bodies: {
      "at-glance": "Use it when spoken details are too easy to miss and a message would be safer.",
      "quick-say": "Show the chat or phone number first. Let the other person send the address, time, code, or confirmation.",
      breakdown: "Anh/chị is polite you; gửi qua tin nhắn means send by message; giúp tôi means help me; được không softens the request.",
      "natural-variants": "If writing is enough, move to write-down-time, send-confirmation, type-address, email-it, or call-my-name follow-ups.",
      "when-to-use": "Good at hotels, tour desks, clinics, drivers, ticket counters, and message threads where exact details matter.",
      "good-to-know": "A text message is useful when the next step depends on a spelling, time, address, pickup point, or code.",
      "explore-next": "Use confirmation-message, write-down-time, type-address, email-invoice, or call-my-name cards if the detail needs another format."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Anh/chị", english: "you", keepTogetherReason: "polite address" },
      { id: "chunk-2", vietnamese: "gửi qua tin nhắn", english: "send by text message", keepTogetherReason: "send-by-message phrase" },
      { id: "chunk-3", vietnamese: "giúp tôi", english: "help me / for me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces literal text-message wording with a natural written-confirmation request"
  },
  {
    id: "viet-phrase-v900-time-date-book-please-write-down-the-time",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-write-down-the-time.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v900-time-date-book-please-write-down-the-time.json",
    title: "Anh/chị ghi giờ giúp tôi được không?",
    englishTitle: "Can you write down the time?",
    pronunciation: "Anh chi ghi gio giup toi duoc khong",
    audioPlanned: true,
    beforeSummary: "Please write down the time",
    summary: "For getting the exact time written before you leave the counter or desk.",
    bodies: {
      "at-glance": "Use it when a departure, pickup, appointment, or return time needs to be exact.",
      "quick-say": "Hand over paper or show your phone note. Let the written time carry the detail.",
      breakdown: "Anh/chị is polite you; ghi giờ means write the time; giúp tôi means help me; được không softens the request.",
      "natural-variants": "If the detail changes, move to text-message, confirmation, today, tomorrow, or change-time follow-ups.",
      "when-to-use": "Good at stations, clinics, tour counters, hotel desks, ticket offices, and pickup points.",
      "good-to-know": "Written times prevent mixups between morning, afternoon, last call, pickup, and return windows.",
      "explore-next": "Use text-message, confirmation, what-time, move-later, or tomorrow cards if the schedule needs another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Anh/chị", english: "you", keepTogetherReason: "polite address" },
      { id: "chunk-2", vietnamese: "ghi giờ", english: "write the time", keepTogetherReason: "write-time phrase" },
      { id: "chunk-3", vietnamese: "giúp tôi", english: "help me / for me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "makes the write-time page a precise schedule confirmation instead of a generic booking card"
  },
  {
    id: "viet-phrase-v900-tran-can-you-pick-me-up-here",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-can-you-pick-me-up-here.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-can-you-pick-me-up-here.json",
    title: "Anh/chị đón tôi ở đây được không?",
    englishTitle: "Can you pick me up here?",
    pronunciation: "Anh chi don toi o day duoc khong",
    audioPlanned: true,
    beforeSummary: "Can you pick me up here?",
    summary: "For confirming the exact pickup spot before a driver stops somewhere else.",
    bodies: {
      "at-glance": "Use it when the entrance, curb, lobby, or side street matters.",
      "quick-say": "Show the map or entrance while you ask. Wait for yes, no, or a corrected pickup point.",
      breakdown: "Anh/chị is polite you; đón tôi means pick me up; ở đây means here; được không softens the request.",
      "natural-variants": "If the driver needs detail, move to entrance, correct address, app route, call driver, or car-number follow-ups.",
      "when-to-use": "Good for ride-hailing pickups, hotel entrances, stations, malls, night markets, and tour meeting points.",
      "good-to-know": "Pickup confusion usually comes from entrances and sides of the street. Show the exact spot before the vehicle arrives.",
      "explore-next": "Use entrance, correct-address, call-driver, car-number, or app-route cards if the pickup still needs sorting."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Anh/chị", english: "you", keepTogetherReason: "polite address" },
      { id: "chunk-2", vietnamese: "đón tôi", english: "pick me up", keepTogetherReason: "pickup phrase" },
      { id: "chunk-3", vietnamese: "ở đây", english: "here", keepTogetherReason: "location phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns the pickup page into a specific entrance/curb coordination tool"
  },
  {
    id: "viet-phrase-v900-tran-please-take-the-faster-route",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-take-the-faster-route.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-take-the-faster-route.json",
    title: "Đi đường nhanh hơn giúp tôi được không?",
    englishTitle: "Please take the faster route",
    pronunciation: "Di duong nhanh hon giup toi duoc khong",
    audioPlanned: true,
    beforeSummary: "Please take the faster route",
    summary: "For asking a driver to choose the quicker route when the map or timing matters.",
    bodies: {
      "at-glance": "Use it before the turn, toll choice, bridge, or traffic split is already missed.",
      "quick-say": "Show the map route. Keep the request calm so it sounds like timing, not blame.",
      breakdown: "Đi đường means take the road; nhanh hơn means faster; giúp tôi means help me; được không softens the request.",
      "natural-variants": "If the route is still unclear, move to follow-map, avoid-tolls, turn-right, correct-address, or app-route follow-ups.",
      "when-to-use": "Good in taxis, ride-hailing cars, private transfers, and hotel-arranged rides when the route choice is visible.",
      "good-to-know": "A map screen helps. It turns the request into a route comparison instead of a complaint.",
      "explore-next": "Use follow-map, avoid-tolls, app-route, turn-right, or correct-address cards if the route needs another cue."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đi đường", english: "take the route", keepTogetherReason: "route phrase" },
      { id: "chunk-2", vietnamese: "nhanh hơn", english: "faster", keepTogetherReason: "faster phrase" },
      { id: "chunk-3", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a blunt route command into a polite map-backed driver request"
  },
  {
    id: "viet-phrase-v900-tran-the-app-shows-a-different-route",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-the-app-shows-a-different-route.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-the-app-shows-a-different-route.json",
    title: "Ứng dụng đang chỉ đường khác",
    englishTitle: "The app shows a different route",
    pronunciation: "Ung dung dang chi duong khac",
    audioPlanned: true,
    beforeSummary: "The app shows a different route",
    summary: "For pointing out that your map or ride app is showing a different way.",
    bodies: {
      "at-glance": "Use it when you need the driver to compare routes before the ride drifts too far.",
      "quick-say": "Hold up the app and say the line once. Let the screen show the route, time, or turn difference.",
      breakdown: "Ứng dụng means app; đang chỉ means is showing or directing; đường khác means a different route.",
      "natural-variants": "If the driver needs a decision, move to follow-map, faster-route, avoid-tolls, turn-right, or correct-address follow-ups.",
      "when-to-use": "Good in taxis, ride-hailing cars, station pickups, and any ride where your map and the driver disagree.",
      "good-to-know": "Pointing at the route keeps the exchange practical. You are comparing screens, not arguing about every street.",
      "explore-next": "Use follow-map, faster-route, avoid-tolls, correct-address, or turn-right cards if the route needs a next cue."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Ứng dụng", english: "the app", keepTogetherReason: "app phrase" },
      { id: "chunk-2", vietnamese: "đang chỉ", english: "is showing / directing", keepTogetherReason: "showing-route phrase" },
      { id: "chunk-3", vietnamese: "đường khác", english: "a different route", keepTogetherReason: "different-route phrase" }
    ],
    value: "makes the app-route page specific to comparing visible route screens"
  },
  {
    id: "viet-phrase-v900-tran-the-entrance-is-on-the-other-side",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-the-entrance-is-on-the-other-side.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-the-entrance-is-on-the-other-side.json",
    beforeSummary: "The entrance is on the other side",
    summary: "For explaining that the door, gate, or pickup entrance is across from where you are now.",
    bodies: {
      "at-glance": "Use it when the car, walking route, or meeting point is on the wrong side.",
      "quick-say": "Point across the street, lobby, station, or parking area. Let the gesture carry the direction.",
      breakdown: "Lối vào means entrance; nằm ở means is located at; phía bên kia means the other side.",
      "natural-variants": "If the route changes, move to stop-here, pick-up-entrance, correct-address, turn-around, or main-entrance follow-ups.",
      "when-to-use": "Good at malls, stations, hotels, markets, ports, and buildings with more than one entrance.",
      "good-to-know": "This line works best with a gesture. The other side may mean across the street, around the building, or another gate.",
      "explore-next": "Use pickup-entrance, main-entrance, turn-around, stop-here, or correct-address cards if the entrance still needs sorting."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Lối vào", english: "the entrance", keepTogetherReason: "entrance phrase" },
      { id: "chunk-2", vietnamese: "nằm ở", english: "is located at", keepTogetherReason: "location phrase" },
      { id: "chunk-3", vietnamese: "phía bên kia", english: "the other side", keepTogetherReason: "other-side phrase" }
    ],
    value: "makes the entrance page useful for real gates, curbs, and pickup sides"
  },
  {
    id: "viet-phrase-v500-dire-navi-do-i-go-upstairs",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-do-i-go-upstairs.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-do-i-go-upstairs.json",
    title: "Tôi lên lầu phải không?",
    englishTitle: "Do I go upstairs?",
    pronunciation: "Toi len lau phai khong",
    audioPlanned: true,
    beforeSummary: "Do I go upstairs?",
    summary: "For confirming whether the place is above you before taking the stairs or elevator.",
    bodies: {
      "at-glance": "Use it when a sign, guard, shop, or counter points upward but you are not sure.",
      "quick-say": "Point to the stairs, elevator, or upper floor. Wait for yes, no, or a floor number.",
      breakdown: "Tôi lên lầu means I go upstairs; phải không asks right? or is that correct?",
      "natural-variants": "If the direction changes, move to downstairs, elevator, inside-mall, which-entrance, or write-address follow-ups.",
      "when-to-use": "Good in malls, clinics, stations, hotels, apartment lobbies, offices, and older buildings with unclear signs.",
      "good-to-know": "Floor words can come fast. A finger pointing up or down may be more useful than another sentence.",
      "explore-next": "Use downstairs, elevator, inside-mall, which-entrance, or right-number cards if the building still feels confusing."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi", english: "I", keepTogetherReason: "subject" },
      { id: "chunk-2", vietnamese: "lên lầu", english: "go upstairs", keepTogetherReason: "upstairs phrase" },
      { id: "chunk-3", vietnamese: "phải không?", english: "right? / is that correct?", keepTogetherReason: "confirmation ending" },
      { id: "full", vietnamese: "Tôi lên lầu phải không?", english: "Do I go upstairs?", audioKey: null }
    ],
    value: "turns the upstairs page into a building-navigation check instead of bare yes/no scaffolding"
  },
  {
    id: "viet-phrase-v500-dire-navi-is-it-open-now",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-open-now.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-is-it-open-now.json",
    title: "Bây giờ có mở cửa không?",
    englishTitle: "Is it open now?",
    pronunciation: "Bay gio co mo cua khong",
    audioPlanned: true,
    beforeSummary: "Is it open now?",
    summary: "For checking current opening before you walk in, wait outside, or keep moving.",
    bodies: {
      "at-glance": "Use it when a door, counter, restaurant, clinic, or ticket window looks uncertain.",
      "quick-say": "Show the place or point to the door. Listen for open, closed, later, or another entrance.",
      breakdown: "Bây giờ means now; có mở cửa means is open; không makes it a yes/no question.",
      "natural-variants": "If timing matters, move to open-today, what-time, closed-Monday, wait, or ticket-office follow-ups.",
      "when-to-use": "Good at shops, cafes, museums, clinics, ticket desks, small counters, and places with unclear hours.",
      "good-to-know": "Small places may be open but using a side door, break time, or family-run schedule.",
      "explore-next": "Use open-today, what-time, wait, closed-Monday, or ticket-office cards if the hours need another check."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bây giờ", english: "now", keepTogetherReason: "time phrase" },
      { id: "chunk-2", vietnamese: "có mở cửa", english: "is open", keepTogetherReason: "open-status phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "makes the open-now page specific to doors, counters, and uncertain hours"
  },
  {
    id: "viet-phrase-v500-emer-safe-someone-is-injured",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-someone-is-injured.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-someone-is-injured.json",
    beforeSummary: "Someone is injured",
    summary: "For telling nearby staff, a driver, or a hotel desk that someone needs urgent help.",
    bodies: {
      "at-glance": "Use it when the injury is the first fact people need to understand.",
      "quick-say": "Say the line, then point to the person or location. Keep the next request short.",
      breakdown: "Có người means there is someone; bị thương means injured.",
      "natural-variants": "If help is needed now, move to ambulance, hospital, police, stay-with-me, or emergency-services follow-ups.",
      "when-to-use": "Good after a fall, traffic incident, cut, fainting, tour accident, or any moment where staff need to react quickly.",
      "good-to-know": "This line states the problem. Follow it with ambulance, hospital, or please help if action is needed.",
      "explore-next": "Use ambulance, hospital, emergency-services, stay-with-me, or police cards if the injury needs immediate help."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có người", english: "there is someone", keepTogetherReason: "someone phrase" },
      { id: "chunk-2", vietnamese: "bị thương", english: "injured", keepTogetherReason: "injury phrase" }
    ],
    value: "makes the injury page clear, direct, and action-ready without fear padding"
  }
];

function readJson(relPath) {
  return JSON.parse(fs.readFileSync(path.join(repoRoot, relPath), "utf8"));
}

function writeJson(relPath, value) {
  fs.writeFileSync(`${path.join(repoRoot, relPath)}`, `${JSON.stringify(value, null, 2)}\n`);
}

function countSectionItems(page, key) {
  return (page.sections || []).reduce((total, section) => total + ((section[key] || []).length), 0);
}

function updateSectionBodies(page, repair) {
  const bodies = repair.bodies || {};
  page.sections = (page.sections || []).map((section) => {
    const next = { ...section };
    if (Object.prototype.hasOwnProperty.call(bodies, section.id)) {
      next.body = bodies[section.id];
    }
    if (section.id === "breakdown" && repair.breakdown) {
      next.breakdown = repair.breakdown.map((token) => ({ ...token }));
      const finalToken = next.breakdown[next.breakdown.length - 1];
      if (finalToken?.vietnamese !== page.title || finalToken?.english !== page.englishTitle) {
        next.breakdown.push({
          id: "full",
          vietnamese: page.title,
          english: page.englishTitle,
          audioKey: page.audioKey ?? null
        });
      }
    }
    return next;
  });
}

function alignSelfPhraseCards(page) {
  const alignPhrase = (phrase) => {
    if (!phrase || phrase.detailPageID !== null || phrase.id !== page.phraseID) return phrase;
    return {
      ...phrase,
      vietnamese: page.title,
      english: page.englishTitle,
      pronunciation: page.pronunciation,
      symbolName: "text.bubble.fill",
      audioKey: null
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
  updateSectionBodies(page, repair);
  if (repair.audioPlanned) alignSelfPhraseCards(page);
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
  const tokens = (repair.breakdown || []).map((token) => ({ ...token }));
  const finalToken = tokens[tokens.length - 1];
  if (finalToken?.vietnamese !== page.title || finalToken?.english !== page.englishTitle) {
    tokens.push({
      id: "full",
      vietnamese: page.title,
      english: page.englishTitle,
      audioKey: page.audioKey ?? null
    });
  }
  audit.tokens = tokens;
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
    if (repair.title) {
      row[index.target_text] = repair.title;
      row[index.canonical_target_text] = repair.title;
    }
    if (repair.englishTitle) row[index.english_text] = repair.englishTitle;
    if (repair.pronunciation) row[index.pronunciation] = repair.pronunciation;
    if (repair.summary) row[index.family_summary] = repair.summary;
    if (repair.audioPlanned) {
      row[index.audio_key] = "";
      row[index.audio_status] = "planned";
      const note = row[index.notes] || "";
      if (!note.includes("Batch 16 semantic repair moved audio to planned")) {
        row[index.notes] = `${note}; Batch 16 semantic repair moved audio to planned`;
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
      batch: 16,
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
      reason: "premium_audit_batch_16"
    });
  }

  const csvChanges = [
    updateCSV("content-draft/viet/phrase-source.csv", repairsByPhraseID),
    updateCSV("content-draft/viet/autonomous-900/generated-rows.csv", repairsByPhraseID)
  ];

  const existingLedgerRows = fs.existsSync(ledgerPath)
    ? fs.readFileSync(ledgerPath, "utf8").split(/\n/).filter(Boolean)
    : [];
  const hasBatchRows = existingLedgerRows.some((line) => {
    try {
      const row = JSON.parse(line);
      return row.batch === 16 || row.reason === "premium_audit_batch_16";
    } catch {
      return false;
    }
  });

  if (!hasBatchRows) {
    fs.appendFileSync(ledgerPath, `${ledgerRows.map((row) => JSON.stringify(row)).join("\n")}\n`);
  }

  console.log(JSON.stringify({
    batch: 16,
    repairedPages: repairs.length,
    pageIDs: repairs.map((repair) => repair.id),
    csvChanges,
    ledgerRows: hasBatchRows ? 0 : ledgerRows.length,
    ledgerSkippedAlreadyPresent: hasBatchRows,
    ledgerPath: path.relative(repoRoot, ledgerPath)
  }, null, 2));
}

main();
