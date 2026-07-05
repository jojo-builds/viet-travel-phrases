#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-tran-please-close-the-window",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-please-close-the-window.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-please-close-the-window.json",
    summary: "For asking a driver to shut a window when wind, rain, smoke, or noise is making the ride uncomfortable.",
    bodies: {
      "at-glance": "Use this during a taxi, Grab, bus, or shuttle ride when the open window is the problem, not the route.",
      "quick-say": "Say the line calmly and point to the window. A small gesture keeps it from sounding like a complaint about the whole ride.",
      breakdown: "Hay marks a polite request; dong cua so lai means close the window.",
      "natural-variants": "Destination, District 1, and stop-here cards help if the window request happens during a ride conversation.",
      "when-to-use": "Good when rain blows in, exhaust smell drifts through, road noise is too much, or the air conditioning is already on.",
      "good-to-know": "If the driver opened it for ventilation, add a polite face and point to yourself; the phrase asks for one small change.",
      "explore-next": "Stop-here and air-conditioning cards sit close by because window comfort often comes up mid-ride."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy", english: "please", keepTogetherReason: "polite request marker" },
      { id: "chunk-2", vietnamese: "đóng cửa sổ lại", english: "close the window", keepTogetherReason: "close-the-window phrase" }
    ],
    value: "turns a title-repeat transport page into a specific ride-comfort request without removing cards"
  },
  {
    id: "viet-family-food-menu",
    source: "content-draft/viet/canonical-pages/tier-one/food-drink/food-menu.json",
    audit: "content-draft/viet/breakdown-audit/pages/tier1/food-drink/food-menu.json",
    summary: "For getting the menu into view before choosing, pointing, or asking about a dish.",
    bodies: {
      "at-glance": "Ask for this before ordering when the counter is moving fast or the wall menu is hard to read.",
      "standard-way": "Keep your phone, table, or dish photo ready; once the menu appears, pointing can do most of the work.",
      breakdown: "Cho tôi xem means let me see; thực đơn is the menu; được không makes it a polite request.",
      "why-it-matters": "Menus in Vietnam can live on walls, QR codes, laminated sheets, or a server's memory. Getting the list visible lowers the pressure.",
      "traveler-insight": "If they gesture to a board or QR code, follow the point first, then use recommendation or not-spicy cards.",
      "when-to-use": "Good at street stalls, cafes, restaurants, hotel breakfasts, and counters where you cannot yet see what is available.",
      "local-tip": "Pointing at the dish name or photo is normal. It saves everyone from guessing through tone marks or unfamiliar menu names.",
      "good-to-know": "For allergies or dietary limits, move from the menu request to the specific food-safety phrase before ordering.",
      "explore-next": "Iced-tea, have-that, two-of-these, and one-more cards are natural once the menu choice is made."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cho tôi xem", english: "let me see", keepTogetherReason: "let-me-see phrase" },
      { id: "chunk-2", vietnamese: "thực đơn", english: "the menu", keepTogetherReason: "menu noun" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "replaces repeated food scaffolding with a concrete menu-ordering moment while preserving all phrase cards"
  },
  {
    id: "viet-phrase-money-premium-write-total",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/money-premium-write-total.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/money-write-total.json",
    summary: "For asking a seller or cashier to write the final amount where you can verify it.",
    bodies: {
      "at-glance": "Use this when spoken numbers are moving too fast, especially at markets, counters, stations, or small shops.",
      "quick-say": "Show the calculator, receipt, ticket, or item; the request is for a written number, not a renegotiation.",
      breakdown: "Hãy viết means please write; tổng số means the total; ra means out or down in this request.",
      "natural-variants": "How-much and per-kilo cards help before the total is final or if the unit price still needs checking.",
      "when-to-use": "Good before paying cash, comparing a ticket price, checking a market quote, or confirming an ATM-related amount.",
      "good-to-know": "A typed or written total avoids mistakes with large Vietnamese numbers, especially when zeros blur together.",
      "explore-next": "Too-expensive, lower-price, final-price, another-one, and take-this cards cover bargaining or choosing next."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy viết", english: "please write", keepTogetherReason: "please-write request" },
      { id: "chunk-2", vietnamese: "tổng số", english: "the total", keepTogetherReason: "total amount phrase" },
      { id: "chunk-3", vietnamese: "ra.", english: "out / down", keepTogetherReason: "write-it-out ending" }
    ],
    value: "turns a repeated money page into a visual-number confirmation tool without thinning cards"
  },
  {
    id: "viet-phrase-phone-premium-activate-sim",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/phone-premium-activate-sim.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/phone-activate-sim.json",
    summary: "For asking phone staff to help activate a local SIM before you leave the counter.",
    bodies: {
      "at-glance": "Best when the SIM is installed but data, calls, or registration still are not working.",
      "quick-say": "Keep the SIM pack, passport, receipt, and settings screen visible so the helper can see the problem quickly.",
      breakdown: "Bạn có thể asks can you; giúp tôi means help me; kích hoạt SIM means activate the SIM; được không softens the request.",
      "natural-variants": "Wi-Fi password and SIM-card cards help if activation turns into a connectivity or purchase question.",
      "when-to-use": "Good at SIM shops, airport kiosks, phone stores, hotel desks, or cafes where someone is helping with setup.",
      "good-to-know": "Test data before leaving. Open a map or browser while you are still beside the person who can fix it.",
      "explore-next": "Battery, charger, charging, data-top-up, and eSIM cards cover nearby phone problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you request frame" },
      { id: "chunk-2", vietnamese: "giúp tôi", english: "help me", keepTogetherReason: "help-me phrase" },
      { id: "chunk-3", vietnamese: "kích hoạt SIM", english: "activate the SIM", keepTogetherReason: "activate-SIM phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "soft yes-no ending" }
    ],
    value: "turns a title-repeat SIM page into a counter setup workflow without deleting follow-up cards"
  },
  {
    id: "viet-phrase-time-7",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/time-7.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/time-boarding.json",
    summary: "For checking boarding time against a ticket, gate screen, or airport announcement.",
    bodies: {
      "at-glance": "Use this at a gate, airline desk, lounge counter, or information desk when the schedule is not obvious.",
      "quick-say": "Show the boarding pass or flight number. The answer may be a time, a gate change, or a wait instruction.",
      breakdown: "Mấy giờ asks what time; bắt đầu means starts; lên máy bay means board the plane.",
      "natural-variants": "What-time, today, and tomorrow-morning cards cover shorter time checks outside the airport.",
      "when-to-use": "Good when the screen has changed, announcements are unclear, or the printed boarding time conflicts with what people are doing.",
      "good-to-know": "Boarding and departure are different times. If the reply sounds like a gate-closing time, ask them to write it.",
      "explore-next": "Booking, opening-time, later-time, wait, and ticket cards cover adjacent schedule questions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Mấy giờ", english: "what time", keepTogetherReason: "what-time question" },
      { id: "chunk-2", vietnamese: "bắt đầu", english: "starts", keepTogetherReason: "start verb" },
      { id: "chunk-3", vietnamese: "lên máy bay?", english: "board the plane?", keepTogetherReason: "boarding phrase" }
    ],
    value: "turns a title-repeat time page into an airport boarding check without changing card inventory"
  },
  {
    id: "viet-phrase-transport-premium-route-wrong",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/transport-premium-route-wrong.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/transport-route-wrong.json",
    summary: "For telling a driver or helper that the route on the map no longer matches where you need to go.",
    bodies: {
      "at-glance": "Use it when the car, motorbike, or walking route is clearly drifting from the map or agreed destination.",
      "quick-say": "Point to the map before saying the line. The screen makes the correction practical instead of confrontational.",
      breakdown: "Tuyến đường này means this route; sai means wrong.",
      "natural-variants": "Destination and District 1 cards help reset where the ride is supposed to go.",
      "when-to-use": "Good during taxi, Grab, motorbike, bus-station, or pickup moments when the road choice needs correcting now.",
      "good-to-know": "Stay calm and keep the map open. If safety feels wrong, switch to stop-here or unsafe phrases.",
      "explore-next": "Stop-here and go-this-way cards help you correct the ride without turning it into a long argument."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tuyến đường này", english: "this route", keepTogetherReason: "this-route phrase" },
      { id: "chunk-2", vietnamese: "sai.", english: "wrong.", keepTogetherReason: "wrong adjective" }
    ],
    value: "turns a generic route page into a map-backed ride correction without removing cards"
  },
  {
    id: "viet-phrase-v500-loca-serv-ever-task-i-need-an-umbrella",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-i-need-an-umbrella.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-i-need-an-umbrella.json",
    summary: "For asking a shop, hotel desk, or vendor for an umbrella during sudden rain or harsh sun.",
    bodies: {
      "at-glance": "Useful in Vietnam's fast weather shifts, when rain starts hard and the nearest shop is easier than waiting it out.",
      "quick-say": "Point to the rain, doorway, display rack, or your wet bag. The object matters more than a long explanation.",
      breakdown: "Tôi cần means I need; một chiếc ô means an umbrella.",
      "natural-variants": "Water, bag, and tissues cards fit the same small-shop stop.",
      "when-to-use": "Good at convenience stores, hotel desks, pharmacies, cafes, markets, and beach-town counters.",
      "good-to-know": "Ô can mean umbrella; if they look unsure, mime opening one or point to a rack.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and printing cards cover other quick errand needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "một chiếc ô", english: "an umbrella", keepTogetherReason: "umbrella noun phrase" }
    ],
    value: "turns a title-repeat errand page into a weather-specific shop request without thinning"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-can-you-restart-the-router",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-you-restart-the-router.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-can-you-restart-the-router.json",
    summary: "For asking staff or a host to restart the router when Wi-Fi has failed in your room or table area.",
    bodies: {
      "at-glance": "Best when the password is correct but pages, maps, calls, or work apps still will not load.",
      "quick-say": "Show the Wi-Fi screen or error message. It helps them tell router trouble from a password typo.",
      breakdown: "Bạn có thể asks can you; khởi động lại means restart; bộ định tuyến means router; không makes it a question.",
      "natural-variants": "Wi-Fi-password and SIM-card cards help if the problem is access, not the router itself.",
      "when-to-use": "Good at hotels, homestays, cafes, coworking spaces, or tour offices where staff control the network.",
      "good-to-know": "If they cannot restart it, ask for another network, a seat closer to the router, or the password again.",
      "explore-next": "Battery, charger, charging, data-top-up, and eSIM cards cover the next phone or internet workaround."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you request frame" },
      { id: "chunk-2", vietnamese: "khởi động lại", english: "restart", keepTogetherReason: "restart verb" },
      { id: "chunk-3", vietnamese: "bộ định tuyến", english: "router", keepTogetherReason: "router noun" },
      { id: "chunk-4", vietnamese: "không?", english: "is that possible?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a title-repeat router page into a concrete Wi-Fi troubleshooting request"
  },
  {
    id: "viet-phrase-v500-time-date-book-how-long-does-it-take",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-how-long-does-it-take.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v500-time-date-book-how-long-does-it-take.json",
    summary: "For checking the length of a ride, line, repair, tour, or appointment before you commit.",
    bodies: {
      "at-glance": "Good when the answer changes whether you wait, book, walk, pay, or choose another option.",
      "quick-say": "Ask with the route, queue, ticket, item, or appointment in view. The answer is usually an estimate.",
      breakdown: "Phải mất means it takes; bao lâu asks how long.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help if the estimate turns into scheduling.",
      "when-to-use": "Good at tour desks, clinics, repair counters, stations, restaurants, and hotel lobbies.",
      "good-to-know": "If the number matters, ask them to type it or point to a written time before you agree.",
      "explore-next": "Booking, opening-time, later-time, boarding, and wait cards cover the surrounding schedule questions."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Phải mất", english: "it takes", keepTogetherReason: "it-takes phrase" },
      { id: "chunk-2", vietnamese: "bao lâu?", english: "how long?", keepTogetherReason: "how-long question" }
    ],
    value: "turns a bare duration question into a practical wait-or-commit decision page"
  },
  {
    id: "viet-phrase-v500-time-date-book-i-need-to-change-my-booking",
    source: "content-draft/viet/canonical-pages/catalog-promoted/time-dates-booking/v500-time-date-book-i-need-to-change-my-booking.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/time-dates-booking/v500-time-date-book-i-need-to-change-my-booking.json",
    summary: "For changing a reservation while the date, time, ticket, or pickup details are still visible.",
    bodies: {
      "at-glance": "Use this before explaining the new date or time; first make clear that the booking itself needs changing.",
      "quick-say": "Show the confirmation, calendar, ticket, or message thread. Then point to the part that needs to move.",
      breakdown: "Tôi cần means I need; thay đổi means change; đặt chỗ của mình means my booking.",
      "natural-variants": "What-time, today, and tomorrow-morning cards help name the new time once staff agrees to check.",
      "when-to-use": "Good at tour counters, restaurants, hotels, clinics, transport desks, and message threads with a reservation.",
      "good-to-know": "If there is a fee or no availability, ask for the new total or another time before confirming.",
      "explore-next": "Booking, opening-time, later-time, boarding, and wait cards cover the most likely follow-ups."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "thay đổi", english: "change", keepTogetherReason: "change verb" },
      { id: "chunk-3", vietnamese: "đặt chỗ của mình", english: "my booking", keepTogetherReason: "my-booking phrase" }
    ],
    value: "turns a repeated booking page into a concrete reservation-change workflow without deleting cards"
  },
  {
    id: "viet-phrase-v500-unde-repa-i-missed-what-you-said",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-i-missed-what-you-said.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-i-missed-what-you-said.json",
    summary: "For recovering after you missed a spoken answer and need the person to repeat or show it.",
    bodies: {
      "at-glance": "Use it when the person already answered but the words moved too fast to catch.",
      "quick-say": "Say the line once, then point to your ear, the menu, the address, or the screen that caused the confusion.",
      breakdown: "Tôi đã bỏ lỡ means I missed; những gì bạn nói means what you said.",
      "natural-variants": "I-do-not-understand and slower-speech cards help if the repeat still comes too fast.",
      "when-to-use": "Good at counters, cafes, hotels, ride pickups, ticket desks, and any moment where spoken detail matters.",
      "good-to-know": "Ask for one repair move at a time: repeat it, slow down, write it, show it, or point to it.",
      "explore-next": "Repeat, write-it-down, meaning, which-one, and show-me cards cover the next repair step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã bỏ lỡ", english: "I missed", keepTogetherReason: "I-missed phrase" },
      { id: "chunk-2", vietnamese: "những gì bạn nói", english: "what you said", keepTogetherReason: "what-you-said phrase" }
    ],
    value: "turns a repeated repair page into a specific missed-answer recovery without losing cards"
  },
  {
    id: "viet-phrase-v500-unde-repa-please-point-to-it",
    source: "content-draft/viet/canonical-pages/catalog-promoted/understanding-repair/v500-unde-repa-please-point-to-it.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/understanding-repair/v500-unde-repa-please-point-to-it.json",
    summary: "For asking someone to indicate the exact item, word, direction, or option instead of explaining it again.",
    bodies: {
      "at-glance": "Use it when pointing would solve the confusion faster than another spoken explanation.",
      "quick-say": "Hold up the menu, receipt, phone, map, or form. Let them point, then confirm the exact item.",
      breakdown: "Hãy chỉ vào means please point to; nó means it.",
      "natural-variants": "I-do-not-understand and slower-speech cards help if pointing still leaves the choice unclear.",
      "when-to-use": "Good with menus, prices, addresses, platform signs, ticket rows, forms, and shop shelves.",
      "good-to-know": "After they point, repeat the item or show it back so both sides are looking at the same thing.",
      "explore-next": "Repeat, write-it-down, meaning, which-one, and show-me cards cover nearby repair moves."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy chỉ vào", english: "please point to", keepTogetherReason: "please-point-to phrase" },
      { id: "chunk-2", vietnamese: "nó", english: "it", keepTogetherReason: "it pronoun" }
    ],
    value: "turns a scaffolded repair page into a visual disambiguation page while preserving cards"
  }
];

console.log(JSON.stringify(applyRepairs("45", repairs), null, 2));
