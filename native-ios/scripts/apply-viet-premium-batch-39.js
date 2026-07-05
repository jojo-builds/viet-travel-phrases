#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v900-tran-i-booked-through-the-app",
    source: "content-draft/viet/canonical-pages/catalog-promoted/transport/v900-tran-i-booked-through-the-app.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/transport/v900-tran-i-booked-through-the-app.json",
    summary: "For showing a ride, ticket, or pickup was already booked in an app.",
    bodies: {
      "at-glance": "The booking already exists. Keep the app screen open so the driver or counter staff can see the name, route, or fare.",
      "quick-say": "Say the line, then show the booking screen. The pickup point, destination, plate number, or payment note can stay on the phone.",
      breakdown: "Tôi đã đặt means I booked; qua ứng dụng means through the app.",
      "natural-variants": "Take-me-here, District 1, and stop-here cards cover the route if the app booking still needs a spoken backup.",
      "when-to-use": "Good at ride-app pickups, bus counters, hotel taxi desks, and any moment where staff need to know you already booked.",
      "good-to-know": "If the other person looks unsure, show the booking name and destination before repeating the sentence.",
      "explore-next": "Stop-here, route, air-conditioning, waiting, and cash phrases cover the ride after the booking is recognized."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi đã đặt", english: "I booked", keepTogetherReason: "I-booked phrase" },
      { id: "chunk-2", vietnamese: "qua ứng dụng", english: "through the app", keepTogetherReason: "through-the-app phrase" }
    ],
    value: "turns an app-booking shell into a concrete ride-screen handoff"
  },
  {
    id: "viet-family-food-bottled-water",
    source: "content-draft/viet/canonical-pages/tier-one/food-drink/food-bottled-water.json",
    audit: "content-draft/viet/breakdown-audit/pages/tier1/food-drink/food-bottled-water.json",
    summary: "For asking for sealed bottled water at a table, stall, hotel, or counter.",
    bodies: {
      "at-glance": "Ask before the meal moves on, especially when cups, ice, or tap water are already on the table.",
      "standard-way": "Point to the fridge, menu, or bottle size if there are choices. A short yes or no is enough.",
      breakdown: "Có asks whether they have it; nước suối means bottled water.",
      "why-it-matters": "Bottled water is often the safest simple drink request. It also opens the door to ice, straw, and payment follow-ups.",
      "traveler-insight": "If they point to a cooler, choose the size before asking for ice or another drink.",
      "when-to-use": "Good at street stalls, cafes, hotels, small shops, tour stops, and hot walks between sights.",
      "local-tip": "Nước suối is the useful phrase to recognize on bottles and menus.",
      "good-to-know": "If they offer ice, decide whether you want the bottle sealed first.",
      "explore-next": "Takeaway, payment, receipt, split-bill, and that-is-all phrases cover the table after the drink is settled."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có", english: "do you have", keepTogetherReason: "yes-no request opener" },
      { id: "chunk-2", vietnamese: "nước suối", english: "bottled water", keepTogetherReason: "bottled-water phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a repeated food template into a specific sealed-water request"
  },
  {
    id: "viet-phrase-food-premium-no-meat",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/food-premium-no-meat.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/food-no-meat.json",
    summary: "For making a no-meat limit clear before the dish is cooked or handed over.",
    bodies: {
      "at-glance": "Say it before pointing to a bowl, tray, skewer, dumpling, sandwich, or mixed filling.",
      "quick-say": "Point to the dish photo or menu line while you say the phrase. If the answer is unclear, ask what meat is inside.",
      breakdown: "Làm ơn means please; đừng có thịt means do not include meat.",
      "when-to-use": "Good at noodle shops, banh mi counters, buffets, family meals, and street stalls with mixed toppings.",
      "good-to-know": "Meat can show up as broth, pate, minced filling, sausage, or a small topping.",
      "explore-next": "Fish-sauce, shellfish, broader allergy, peanut, and no-peanut phrases cover the nearby food-safety path.",
      "natural-variants": "Without-ingredient, safe-dish, meat-type, shrimp-check, and fish-sauce questions help clarify the plate."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Làm ơn", english: "please", keepTogetherReason: "fixed polite phrase" },
      { id: "chunk-2", vietnamese: "đừng có thịt.", english: "do not include meat", keepTogetherReason: "no-meat phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v500-food-drin-i-am-allergic-to-fish-sauce",
        "viet-phrase-v500-food-drin-i-am-allergic-to-shellfish",
        "viet-phrase-v500-food-drin-i-cannot-eat-this-because-of-an-allergy",
        "viet-phrase-v500-food-drin-i-ordered-this-without-peanuts",
        "viet-phrase-v500-food-drin-please-make-it-without-peanuts"
      ]
    },
    cardParityLedger: {
      "explore-next": "grows first-class source to the rendered five-card food-safety flow without reducing visible cards"
    },
    value: "turns a title-repeat no-meat page into a concrete food-limit handoff"
  },
  {
    id: "viet-phrase-phone-6",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/phone-6.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/phone-data-topup.json",
    summary: "For asking a SIM shop, hotel desk, or phone counter to add more mobile data.",
    bodies: {
      "at-glance": "The phone is the evidence. Keep the data warning, SIM plan, or map app open.",
      "quick-say": "Show the screen while you say the line. Staff may need the carrier, phone number, or package amount next.",
      breakdown: "Tôi cần means I need; nạp thêm dữ liệu means add more mobile data.",
      "natural-variants": "Wi-Fi password, local SIM, and SIM-card questions cover the earlier phone setup path.",
      "when-to-use": "Good when maps, ride apps, messages, or bookings are failing because the data plan is empty or too small.",
      "good-to-know": "Ask the price and package length before handing over the phone or cash.",
      "explore-next": "Battery, charger, charging-point, eSIM, and verification-code phrases cover the usual phone-counter follow-ups."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "nạp thêm dữ liệu", english: "add more mobile data", keepTogetherReason: "data-top-up phrase" }
    ],
    value: "turns a generic phone page into a SIM/data-counter request and fixes data keep-together chunks"
  },
  {
    id: "viet-phrase-phone-premium-login-page-not-loading",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/phone-premium-login-page-not-loading.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/phone-login-page-not-loading.json",
    summary: "For showing staff that the Wi-Fi sign-in page will not open on your phone.",
    bodies: {
      "at-glance": "Open the stuck screen before you ask. The problem is the sign-in page, not the password yet.",
      "quick-say": "Say the line and show the blank, spinning, or error screen. Let staff tap the network name if they offer.",
      breakdown: "Trang đăng nhập Wi-Fi means Wi-Fi login page; không tải means does not load.",
      "natural-variants": "Wi-Fi password, common Wi-Fi, and SIM-card phrases cover the nearby connection setup path.",
      "when-to-use": "Good at hotels, cafes, coworking spaces, airports, buses, and shops with a captive Wi-Fi page.",
      "good-to-know": "If the page opens later, the next question is usually the password or verification code.",
      "explore-next": "Battery, charger, charging-point, data-top-up, and eSIM phrases cover the phone problems that can look similar."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Trang đăng nhập Wi-Fi", english: "Wi-Fi login page", keepTogetherReason: "Wi-Fi login-page phrase" },
      { id: "chunk-2", vietnamese: "không tải.", english: "does not load", keepTogetherReason: "does-not-load phrase" }
    ],
    value: "turns a mistranslated breakdown into a specific Wi-Fi captive-portal help page"
  },
  {
    id: "viet-phrase-v500-airp-bord-arri-can-i-get-a-written-report",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-can-i-get-a-written-report.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-can-i-get-a-written-report.json",
    summary: "For asking airport staff for a written report, claim note, or incident record.",
    bodies: {
      "at-glance": "The document matters later. Keep the baggage tag, form, receipt, or counter screen visible.",
      "quick-say": "Ask for the report before leaving the counter. A claim number, printed note, or photo can save a second trip.",
      breakdown: "Tôi có thể asks can I; nhận được means get; báo cáo bằng văn bản means written report.",
      "natural-variants": "Immigration, baggage claim, and SIM-card phrases cover the arrival basics nearby.",
      "when-to-use": "Good for lost luggage, damaged bags, canceled pickups, insurance claims, or anything staff say must be documented.",
      "good-to-know": "Check that the report has a date, counter name, and reference number before you leave.",
      "explore-next": "Pickup-area, driver-meeting, missing-bag, baggage-tag, and visa phrases cover the airport path around the report."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "nhận được", english: "get / receive", keepTogetherReason: "get-receive phrase" },
      { id: "chunk-3", vietnamese: "một báo cáo", english: "a report", keepTogetherReason: "report phrase" },
      { id: "chunk-4", vietnamese: "bằng văn bản", english: "in writing", keepTogetherReason: "written/in-writing phrase" },
      { id: "chunk-5", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a title-repeat report page into a concrete airport-document request"
  },
  {
    id: "viet-phrase-v500-dire-navi-do-i-go-over-the-bridge",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-do-i-go-over-the-bridge.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-do-i-go-over-the-bridge.json",
    summary: "For checking a bridge crossing before you keep walking, riding, or following the map.",
    bodies: {
      "at-glance": "Ask while the bridge, map route, or road sign is still in view.",
      "quick-say": "Show the map and ask the yes/no question. A point or short answer is enough before you move on.",
      breakdown: "Tôi có asks do I; đi qua cầu means go over the bridge; không? makes it a yes/no question.",
      "natural-variants": "How-to-get-there, nearby, and walking-time phrases help if the answer turns into a route explanation.",
      "when-to-use": "Good at river crossings, station exits, bridge approaches, and ride pickups where one wrong turn adds distance.",
      "good-to-know": "Bridge names can be hard to catch at speed. Let the map or sign carry the exact name.",
      "explore-next": "Left, right, straight, understand-now, and pickup-point phrases cover the next route move."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có", english: "do I", keepTogetherReason: "do-I question frame" },
      { id: "chunk-2", vietnamese: "đi qua cầu", english: "go over the bridge", keepTogetherReason: "bridge-crossing phrase" },
      { id: "chunk-3", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    value: "turns a generic directions page into a bridge-crossing route check"
  },
  {
    id: "viet-phrase-v500-food-drin-there-is-something-in-my-food",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-there-is-something-in-my-food.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-there-is-something-in-my-food.json",
    summary: "For pointing out a visible object or problem in your food before asking staff to fix it.",
    bodies: {
      "at-glance": "Show the bowl, plate, or photo first. The problem is easier to handle when it is visible.",
      "quick-say": "Say the line calmly and point to the spot. Keep the dish at the table until staff have seen it.",
      breakdown: "Có thứ gì đó means there is something; trong thức ăn means in the food; của tôi means my.",
      "when-to-use": "Good when there is hair, plastic, a shell piece, an insect, or any object that should not be in the dish.",
      "good-to-know": "Do not overexplain at first. Let staff see the problem, then ask whether they can change it.",
      "explore-next": "Change-this is the clean next ask if staff agree there is a problem.",
      "natural-variants": "Undercooked, cold, spoiled, not-spicy, and too-spicy phrases cover nearby food problems."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Có thứ gì đó", english: "there is something", keepTogetherReason: "there-is-something phrase" },
      { id: "chunk-2", vietnamese: "trong thức ăn", english: "in the food", keepTogetherReason: "in-the-food phrase" },
      { id: "chunk-3", vietnamese: "của tôi", english: "my", keepTogetherReason: "my/mine phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-food-drin-can-you-change-this"
      ]
    },
    cardParityLedger: {
      "explore-next": "aligns source to the single rendered change-this card; the source-only wrong-order card was not visible in the app"
    },
    value: "turns a title-repeat food-problem page into a visible object-in-food handoff"
  },
  {
    id: "viet-phrase-v500-loca-serv-ever-task-how-long-will-it-take",
    source: "content-draft/viet/canonical-pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-how-long-will-it-take.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/local-services-everyday-tasks/v500-loca-serv-ever-task-how-long-will-it-take.json",
    summary: "For asking how long a repair, print job, errand, wait, or service will take.",
    bodies: {
      "at-glance": "Ask before handing over the item if timing will change your plan.",
      "quick-say": "Point to the item or ticket and ask once. If the answer is fast, invite a typed or written time.",
      breakdown: "Sẽ mất means it will take; bao lâu? means how long?",
      "natural-variants": "Water, bag, and tissue phrases cover quick counter errands nearby.",
      "when-to-use": "Good at laundries, repair counters, print shops, pharmacies, hotel desks, and ticket windows.",
      "good-to-know": "A written pickup time is easier to trust than a fast spoken number.",
      "explore-next": "Sunscreen, open-this, card-payment, receipt, and printing phrases cover the next counter move."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Sẽ mất", english: "will take", keepTogetherReason: "will-take phrase" },
      { id: "chunk-2", vietnamese: "bao lâu?", english: "how long?", keepTogetherReason: "how-long phrase" }
    ],
    value: "turns a generic local-service page into a concrete timing check"
  },
  {
    id: "viet-phrase-v500-phon-inte-powe-i-need-a-charging-cable",
    source: "content-draft/viet/canonical-pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-i-need-a-charging-cable.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/phone-internet-power/v500-phon-inte-powe-i-need-a-charging-cable.json",
    summary: "For asking to buy or borrow a charging cable when your phone is running low.",
    bodies: {
      "at-glance": "Show the phone port or old cable if the connector type matters.",
      "quick-say": "Say the line and point to the phone. Staff may need to know iPhone, USB-C, length, or whether you want to buy it.",
      breakdown: "Tôi cần means I need; một cáp sạc means a charging cable.",
      "natural-variants": "Wi-Fi password, common Wi-Fi, and SIM-card phrases cover nearby phone setup needs.",
      "when-to-use": "Good at hotels, cafes, convenience stores, phone shops, bus counters, and airport charging corners.",
      "good-to-know": "If you only need to borrow one, ask to charge the phone here instead.",
      "explore-next": "Battery, charger, charge-here, data-top-up, and eSIM phrases cover the rest of the phone problem."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "một cáp sạc", english: "a charging cable", keepTogetherReason: "charging-cable phrase" }
    ],
    value: "turns a generic phone page into a concrete charging-cable counter request"
  },
  {
    id: "viet-phrase-v500-poli-basi-i-need-this",
    source: "content-draft/viet/canonical-pages/catalog-promoted/polite-basics/v500-poli-basi-i-need-this.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/polite-basics/v500-poli-basi-i-need-this.json",
    summary: "For pointing to an item, form, screen, photo, or document and saying you need that one.",
    bodies: {
      "at-glance": "This is a pointing phrase, not a greeting. Keep the object or screen visible.",
      "quick-say": "Point first, then say the line. It works best when the other person can see exactly what this means.",
      breakdown: "Tôi cần means I need; cái này means this one or this thing.",
      "natural-variants": "Hello and thank-you phrases help soften the exchange before or after the request.",
      "when-to-use": "Good at shops, pharmacies, print counters, ticket desks, hotel lobbies, and street stalls.",
      "good-to-know": "If the person brings the wrong item, point again and switch to this one or another one.",
      "explore-next": "Yes, no-thank-you, excuse-me, it-is-okay, and goodbye phrases cover the small polite moves around the request."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "cái này", english: "this one / this thing", keepTogetherReason: "this-one phrase" }
    ],
    value: "removes the wrong greeting/apology framing and makes the page a real pointing request"
  },
  {
    id: "viet-phrase-v900-dire-navi-please-write-the-address-for-me",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v900-dire-navi-please-write-the-address-for-me.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v900-dire-navi-please-write-the-address-for-me.json",
    summary: "For getting an address written clearly enough to show a driver, hotel desk, or map helper.",
    bodies: {
      "at-glance": "Ask before the name gets lost in fast speech or weak signal.",
      "quick-say": "Show your phone or notebook and ask for the address. A written line is easier to reuse with a driver.",
      breakdown: "Hãy viết means please write; địa chỉ means address; cho tôi means for me.",
      "natural-variants": "How-to-get-there, nearby, and walking-time phrases help if the address becomes a route question.",
      "when-to-use": "Good at hotels, cafes, clinics, tour desks, station counters, and shops before calling a ride.",
      "good-to-know": "Check the street number and district before you leave the counter.",
      "explore-next": "Left, right, straight, understand-now, and pickup-point phrases cover the route after the address is written."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Hãy viết", english: "please write", keepTogetherReason: "please-write phrase" },
      { id: "chunk-2", vietnamese: "địa chỉ", english: "address", keepTogetherReason: "address phrase" },
      { id: "chunk-3", vietnamese: "cho tôi", english: "for me", keepTogetherReason: "for-me phrase" }
    ],
    value: "turns a generic directions page into a written-address handoff"
  }
];

console.log(JSON.stringify(applyRepairs(39, repairs), null, 2));
