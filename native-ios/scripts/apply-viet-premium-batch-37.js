#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-phrase-v500-dire-navi-can-i-walk-there",
    source: "content-draft/viet/canonical-pages/catalog-promoted/directions-navigation/v500-dire-navi-can-i-walk-there.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/directions-navigation/v500-dire-navi-can-i-walk-there.json",
    summary: "For checking whether a walk is realistic before you leave the curb, station, beach road, or old-town lane.",
    bodies: {
      "at-glance": "The map may look close, but heat, traffic, bridges, and missing sidewalks can change the answer.",
      "quick-say": "Show the map or address while you ask. A local answer may be about the safer route, not just distance.",
      breakdown: "Tôi có thể asks can I; đi bộ means walk; tới đó means there; được không asks if it is possible.",
      "natural-variants": "Excuse-me, how-to-get-there, near-here, and walking-time phrases help if the answer turns into directions.",
      "when-to-use": "Good before walking between markets, bridges, beach roads, stations, hotels, and old-town lanes.",
      "good-to-know": "A hesitant answer is travel advice. Ask for a pickup point or ride option if the route sounds rough.",
      "explore-next": "If walking is realistic, the next question is usually a first turn or a safe pickup point."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "đi bộ", english: "walk", keepTogetherReason: "walk phrase" },
      { id: "chunk-3", vietnamese: "tới đó", english: "there", keepTogetherReason: "destination phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is it possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    value: "turns a bare walking question into a safety and route judgment moment"
  },
  {
    id: "viet-phrase-v500-emer-safe-i-need-first-aid",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v500-emer-safe-i-need-first-aid.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v500-emer-safe-i-need-first-aid.json",
    summary: "For asking for basic medical help before the situation needs a clinic, ambulance, or longer explanation.",
    bodies: {
      "at-glance": "The injury is immediate enough to name first aid, but not every detail has to come first.",
      "quick-say": "Say the phrase, then point to the cut, burn, fall, or person who needs help.",
      breakdown: "Tôi cần means I need; sơ cứu means first aid.",
      "natural-variants": "Injured, someone-injured, and ambulance phrases help if the situation escalates.",
      "when-to-use": "Good at hotels, shops, attractions, stations, and staffed counters when someone can call or guide you.",
      "good-to-know": "Keep the first sentence short. Show the injury or photo after the phrase so the next step is clear.",
      "explore-next": "Hospital, take-me-to-hospital, unsafe, emergency, and help phrases cover the next safety move."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi cần", english: "I need", keepTogetherReason: "I-need phrase" },
      { id: "chunk-2", vietnamese: "sơ cứu", english: "first aid", keepTogetherReason: "first-aid phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-family-v500-emer-safe-i-am-injured",
        "viet-phrase-v500-emer-safe-someone-is-injured",
        "viet-phrase-v500-emer-safe-please-call-an-ambulance"
      ],
      "explore-next": [
        "viet-family-emergency-hospital",
        "viet-phrase-v900-emer-safe-please-take-me-to-the-hospital",
        "viet-family-emergency-not-safe",
        "viet-phrase-emergency-emergency",
        "viet-phrase-emergency-5"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces passport/police drift with injury and ambulance follow-ups while preserving three visible cards",
      "explore-next": "keeps five safety cards focused on hospital, unsafe, emergency, and help paths"
    },
    value: "makes the first-aid page an immediate medical help request instead of a generic emergency shell"
  },
  {
    id: "viet-phrase-v500-food-drin-i-am-allergic-to-shellfish",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v500-food-drin-i-am-allergic-to-shellfish.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v500-food-drin-i-am-allergic-to-shellfish.json",
    summary: "For stating a shellfish allergy before you order, accept a dish, or taste a sauce or broth.",
    bodies: {
      "at-glance": "Say it before eating, especially around broths, sauces, dried toppings, and shared seafood prep.",
      "quick-say": "Point to the dish, menu photo, or allergy note. Then let the allergy sentence stay short and clear.",
      breakdown: "Tôi bị dị ứng means I am allergic; với means to; động vật có vỏ means shellfish.",
      "when-to-use": "Good at street stalls, seafood restaurants, buffets, noodle shops, and cafes with sauces or toppings.",
      "good-to-know": "Shellfish can hide in broth, paste, dried shrimp, and sauce. Ask the shrimp or fish-sauce follow-up if needed.",
      "explore-next": "Fish-sauce allergy, broader allergy limits, no-meat ordering, and peanut-order repairs cover nearby food safety.",
      "natural-variants": "No-meat, without-ingredient, safe-dish, meat-type, and shrimp-check phrases help clarify the order."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi bị dị ứng", english: "I am allergic", keepTogetherReason: "allergy phrase" },
      { id: "chunk-2", vietnamese: "với", english: "to", keepTogetherReason: "to/with connector" },
      { id: "chunk-3", vietnamese: "động vật có vỏ", english: "shellfish", keepTogetherReason: "shellfish phrase" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-food-drin-can-i-order-this-without-meat",
        "viet-phrase-v500-food-drin-i-am-allergic-to-fish-sauce",
        "viet-phrase-v500-food-drin-i-cannot-eat-this-because-of-an-allergy",
        "viet-phrase-v500-food-drin-i-ordered-this-without-peanuts",
        "viet-phrase-v500-food-drin-please-make-it-without-peanuts"
      ]
    },
    cardParityLedger: {
      "explore-next": "aligns source to the rendered five-card allergy flow instead of thinning peanut and allergy repair cards"
    },
    value: "turns a title-repeat allergy page into a concrete food-safety warning"
  },
  {
    id: "viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in",
    source: "content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/v500-hote-acco-here-is-my-passport-for-check-in.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/hotel-accommodation/v500-hote-acco-here-is-my-passport-for-check-in.json",
    summary: "For handing over your passport at the front desk when check-in paperwork starts.",
    bodies: {
      "at-glance": "The desk has asked for ID and your booking screen is already open.",
      "quick-say": "Hand over the passport and say the phrase. Keep the booking name or confirmation visible.",
      breakdown: "Đây là means this is; hộ chiếu của tôi means my passport; để nhận phòng means for check-in.",
      "natural-variants": "Reservation, check-in, and polite check-in phrases cover the normal front-desk opening.",
      "when-to-use": "Good at hotels, guesthouses, homestays, and apartment desks before room keys or deposits come up.",
      "good-to-know": "Keep the passport in view and watch where it goes. A photo or quick scan is common; a long hold should be clear.",
      "explore-next": "Checkout time, quiet room, checkout, hot room, and air-conditioner phrases cover nearby hotel needs."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Đây là", english: "this is", keepTogetherReason: "this-is phrase" },
      { id: "chunk-2", vietnamese: "hộ chiếu của tôi", english: "my passport", keepTogetherReason: "my-passport phrase" },
      { id: "chunk-3", vietnamese: "để nhận phòng", english: "for check-in", keepTogetherReason: "check-in phrase" }
    ],
    value: "makes the passport page a specific front-desk handoff instead of hotel scaffolding"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-i-only-have-large-bills",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-i-only-have-large-bills.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-i-only-have-large-bills.json",
    summary: "For explaining that your cash is too large for the payment or change situation.",
    bodies: {
      "at-glance": "Use it before handing over a big note at a stall, taxi, ticket window, or small shop.",
      "quick-say": "Show the cash and the price together. The answer may be smaller bills, card, QR, or no change.",
      breakdown: "Tôi chỉ có means I only have; hóa đơn lớn carries the large-bill idea in this line.",
      "natural-variants": "Smaller-bills, exact-change, and receipt phrases cover the next cash step.",
      "when-to-use": "Good when the amount is small and your available note may be hard for the other person to break.",
      "good-to-know": "Small stalls and drivers may not have change for a large note. Show the cash before the payment gets awkward.",
      "explore-next": "Too-expensive, lower-price, final-price, show-another, and take-this phrases cover the rest of the payment flow."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi chỉ có", english: "I only have", keepTogetherReason: "I-only-have phrase" },
      { id: "chunk-2", vietnamese: "hóa đơn lớn", english: "large bills", keepTogetherReason: "large-bill phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-price-9",
        "viet-phrase-v500-mone-numb-pric-i-need-smaller-bills",
        "viet-phrase-v500-mone-numb-pric-do-i-need-exact-change"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces duplicate price-check cards with smaller-bill and exact-change follow-ups while preserving three visible cards"
    },
    value: "turns a bare cash page into a practical small-payment change moment while flagging the remaining wording risk"
  },
  {
    id: "viet-phrase-v500-mone-numb-pric-i-only-have-this-much",
    source: "content-draft/viet/canonical-pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-i-only-have-this-much.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/money-numbers-prices/v500-mone-numb-pric-i-only-have-this-much.json",
    summary: "For showing the amount you can pay when the price, fare, or cash limit is the issue.",
    bodies: {
      "at-glance": "This belongs in a market, taxi, ticket, or small-shop moment where the number is visible.",
      "quick-say": "Show the cash or calculator while you say it. Let the amount do most of the explaining.",
      breakdown: "Tôi chỉ có means I only have; bấy nhiêu thôi means only this much.",
      "natural-variants": "How-much and per-kilo phrases help if the amount needs to be checked first.",
      "when-to-use": "Good when you are negotiating, short on cash, or deciding whether the price still works.",
      "good-to-know": "Keep the tone calm. This phrase is clearer as a limit than as a hard bargain.",
      "explore-next": "Too-expensive, lower-price, final-price, show-another, and take-this phrases cover common market replies."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi chỉ có", english: "I only have", keepTogetherReason: "I-only-have phrase" },
      { id: "chunk-2", vietnamese: "bấy nhiêu thôi", english: "only this much", keepTogetherReason: "this-much phrase" }
    ],
    value: "turns the amount-limit page into a concrete cash and bargaining moment"
  },
  {
    id: "viet-phrase-v500-prob-help-please-help-me-contact-my-embassy",
    source: "content-draft/viet/canonical-pages/catalog-promoted/problems-help/v500-prob-help-please-help-me-contact-my-embassy.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/problems-help/v500-prob-help-please-help-me-contact-my-embassy.json",
    summary: "For asking a hotel, police desk, airline counter, or staffed place to help you reach your embassy.",
    bodies: {
      "at-glance": "The problem is serious enough that the embassy is the next contact, not just a translation request.",
      "quick-say": "Say the phrase, then show passport details, embassy contact info, a report, or the phone number you need called.",
      breakdown: "Xin hãy giúp means please help; tôi liên hệ means me contact; đại sứ quán của tôi means my embassy.",
      "natural-variants": "Nearest-embassy, contacted-embassy, and leave-contact-info phrases help if the next step becomes paperwork.",
      "when-to-use": "Good after lost documents, police reports, airline problems, hospital paperwork, or a serious travel problem.",
      "good-to-know": "Keep one goal visible: call, address, email, or report. That is easier to act on than the whole story.",
      "explore-next": "Need-help, embassy-contact, file-report, police-report, and report-copy phrases cover the next official step."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Xin hãy giúp", english: "please help", keepTogetherReason: "please-help phrase" },
      { id: "chunk-2", vietnamese: "tôi liên hệ", english: "me contact", keepTogetherReason: "contact-me phrase" },
      { id: "chunk-3", vietnamese: "với đại sứ quán của tôi", english: "my embassy", keepTogetherReason: "my-embassy phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-prob-help-where-is-the-nearest-embassy",
        "viet-phrase-v500-prob-help-i-have-contacted-my-embassy",
        "viet-phrase-v500-prob-help-can-i-leave-my-contact-information"
      ],
      "explore-next": [
        "viet-phrase-help-need-help-direct",
        "viet-phrase-help-premium-contact-embassy",
        "viet-phrase-help-5",
        "viet-phrase-v900-prob-help-i-need-a-police-report-for-insurance",
        "viet-phrase-v900-prob-help-please-give-me-a-copy-of-the-report"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces generic lost/help cards with embassy location, embassy contact, and contact-info follow-ups",
      "explore-next": "retargets the five-card set toward help, embassy contact, reports, and copies"
    },
    value: "turns the embassy page into a serious official-contact handoff"
  },
  {
    id: "viet-phrase-v500-sigh-acti-can-i-join-today",
    source: "content-draft/viet/canonical-pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-can-i-join-today.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/sightseeing-activities/v500-sigh-acti-can-i-join-today.json",
    summary: "For asking whether a tour, activity, class, or ticketed visit still has same-day space.",
    bodies: {
      "at-glance": "Ask before paying, waiting, or walking to the meeting point.",
      "quick-say": "Show the activity name, ticket counter, or booking screen while you ask.",
      breakdown: "Tôi có thể asks can I; tham gia means join; ngay hôm nay means today; không makes it a yes/no question.",
      "natural-variants": "Ticket price, start point, and photo-permission phrases help if the answer is yes.",
      "when-to-use": "Good at tour desks, museums, workshops, boat counters, cooking classes, and attraction entrances.",
      "good-to-know": "Same-day space may depend on time, group size, weather, or a guide. Ask for the start time next.",
      "explore-next": "Closing time, meeting point, advance booking, tour booking, and entrance phrases cover the next activity detail."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Tôi có thể", english: "can I", keepTogetherReason: "can-I question frame" },
      { id: "chunk-2", vietnamese: "tham gia", english: "join", keepTogetherReason: "join phrase" },
      { id: "chunk-3", vietnamese: "ngay hôm nay", english: "today", keepTogetherReason: "same-day phrase" },
      { id: "chunk-4", vietnamese: "không?", english: "yes/no?", keepTogetherReason: "yes-no ending" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-sight-4",
        "viet-phrase-sight-5",
        "viet-phrase-sight-6",
        "viet-family-v500-sigh-acti-i-have-a-tour-booking",
        "viet-phrase-v500-sigh-acti-where-is-the-entrance"
      ]
    },
    cardParityLedger: {
      "explore-next": "keeps five activity cards focused on timing, meeting point, booking, and entrance flow"
    },
    value: "turns the same-day activity page into a concrete availability check"
  },
  {
    id: "viet-phrase-v500-soci-smal-talk-please-do-not-take-my-photo",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-please-do-not-take-my-photo.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/social-small-talk/v500-soci-smal-talk-please-do-not-take-my-photo.json",
    summary: "For politely setting a photo boundary without turning the exchange into an argument.",
    bodies: {
      "at-glance": "Use it once, clearly, when a camera or phone is pointed at you.",
      "quick-say": "Keep your voice calm and your hand gesture small. The line is direct enough without extra explanation.",
      breakdown: "Làm ơn means please; đừng chụp ảnh means do not take photos; tôi means me.",
      "natural-variants": "Photography-allowed, photo-here, and what-to-avoid phrases cover the nearby photo-rule context.",
      "when-to-use": "Good in markets, homestays, tours, cafes, and street moments when you do not want to be photographed.",
      "good-to-know": "A short no is kinder than a long apology. Smile if it feels right, then move on.",
      "explore-next": "No-thank-you, alone-thank-you, not-interested, excuse-me, and thank-you-for-understanding phrases cover the boundary after that."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Làm ơn", english: "please", keepTogetherReason: "polite opener" },
      { id: "chunk-2", vietnamese: "đừng chụp ảnh", english: "do not take photos", keepTogetherReason: "photo-boundary phrase" },
      { id: "chunk-3", vietnamese: "tôi", english: "me", keepTogetherReason: "object pronoun" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-sigh-acti-is-photography-allowed",
        "viet-phrase-v900-sigh-acti-can-i-take-a-photo-here",
        "viet-phrase-v500-sigh-acti-what-should-i-avoid"
      ],
      "explore-next": [
        "viet-phrase-v500-soci-smal-talk-no-thank-you-im-not-interested",
        "viet-phrase-v500-soci-smal-talk-i-want-to-be-alone-thank-you",
        "viet-phrase-v900-shop-no-thank-you-ill-look-around-first",
        "viet-excuse-sorry",
        "viet-thanks-cam-on-ban-da-hieu"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces unrelated small-talk origin cards with photo-rule context while preserving three visible cards",
      "explore-next": "replaces generic small-talk cards with polite boundary phrases while preserving five visible cards"
    },
    value: "turns the photo-boundary page into a respectful consent moment"
  },
  {
    id: "viet-phrase-v900-airp-bord-arri-can-you-help-me-book-a-taxi",
    source: "content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-can-you-help-me-book-a-taxi.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/airport-border-arrival/v900-airp-bord-arri-can-you-help-me-book-a-taxi.json",
    summary: "For asking airport staff or a counter helper to help book a taxi when the ride setup is not simple.",
    bodies: {
      "at-glance": "The hotel address, pickup app, baggage, or arrival crowd makes booking awkward.",
      "quick-say": "Show the hotel address or booking screen while you ask. That keeps the ride request practical.",
      breakdown: "Bạn có thể asks can you; giúp tôi đặt means help me book; một chiếc taxi means a taxi; được không asks if possible.",
      "natural-variants": "Taxi counter, official taxi line, and Grab pickup phrases help if the answer points you somewhere else.",
      "when-to-use": "Good at airport counters, hotel-transfer desks, baggage areas, and pickup zones after arrival.",
      "good-to-know": "Confirm the destination and payment before leaving the counter. The right ride matters more than the fastest one.",
      "explore-next": "Pickup area, meet driver, cannot-find-driver, driver-card-payment, and hotel-address phrases cover the ride handoff."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bạn có thể", english: "can you", keepTogetherReason: "can-you question frame" },
      { id: "chunk-2", vietnamese: "giúp tôi đặt", english: "help me book", keepTogetherReason: "help-me-book phrase" },
      { id: "chunk-3", vietnamese: "một chiếc taxi", english: "a taxi", keepTogetherReason: "taxi noun phrase" },
      { id: "chunk-4", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v500-airp-bord-arri-where-is-the-taxi-counter",
        "viet-phrase-v900-airp-bord-arri-is-this-the-official-taxi-line",
        "viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point"
      ],
      "explore-next": [
        "viet-family-airport-pickup",
        "viet-phrase-airport-pickup-clearer",
        "viet-phrase-v500-airp-bord-arri-i-cannot-find-my-driver",
        "viet-phrase-v900-airp-bord-arri-can-i-pay-the-driver-by-card",
        "viet-phrase-v500-airp-bord-arri-i-am-staying-at-this-hotel"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces immigration/baggage/SIM cards with airport taxi routing cards",
      "explore-next": "retargets the five-card set toward pickup, driver, payment, and hotel address handoff"
    },
    value: "turns the airport taxi page into a real arrival ride setup"
  },
  {
    id: "viet-phrase-v900-emer-safe-i-am-safe-now",
    source: "content-draft/viet/canonical-pages/catalog-promoted/emergency-safety/v900-emer-safe-i-am-safe-now.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/emergency-safety/v900-emer-safe-i-am-safe-now.json",
    summary: "For telling someone the immediate danger has passed while you still may need the next practical step.",
    bodies: {
      "at-glance": "Use it after a scare, separation, theft, or unsafe ride when the first update is reassurance.",
      "quick-say": "Say it before the long story. Then show your location, contact, hotel, or report need.",
      breakdown: "Bây giờ means now; tôi means I; đã an toàn means am safe now.",
      "natural-variants": "Location, hotel contact, and contact-info phrases help if someone needs to know where you are.",
      "when-to-use": "Good at hotel desks, police counters, rides, clinics, and phone handoffs after the urgent moment settles.",
      "good-to-know": "This does not close the situation. It just tells the helper the danger level changed.",
      "explore-next": "Unsafe, emergency, help, hospital, and stolen-bag phrases stay nearby if the situation changes again."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Bây giờ", english: "now", keepTogetherReason: "time phrase" },
      { id: "chunk-2", vietnamese: "tôi", english: "I", keepTogetherReason: "speaker pronoun" },
      { id: "chunk-3", vietnamese: "đã an toàn", english: "am safe now", keepTogetherReason: "safe-now phrase" }
    ],
    cardTargets: {
      "natural-variants": [
        "viet-phrase-v900-emer-safe-please-send-my-location-to-this-person",
        "viet-family-help-call-hotel",
        "viet-phrase-v500-prob-help-can-i-leave-my-contact-information"
      ]
    },
    cardParityLedger: {
      "natural-variants": "replaces police/ambulance/passport drift with location, hotel contact, and contact-info follow-ups"
    },
    value: "turns the safe-now page into a reassurance and next-contact update"
  },
  {
    id: "viet-phrase-v900-food-drin-can-i-have-lime",
    source: "content-draft/viet/canonical-pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-lime.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/food-drink/v900-food-drin-can-i-have-lime.json",
    summary: "For asking for lime with a drink, noodle bowl, seafood plate, or dipping sauce.",
    bodies: {
      "at-glance": "Point to the bowl, glass, plate, or sauce so chanh clearly means the citrus side.",
      "quick-say": "Ask while the food is visible. A wedge, small dish, or squeeze bottle may be the answer.",
      breakdown: "Cho tôi xin means please give me; chanh means lime; được không asks if it is possible.",
      "when-to-use": "Good with noodle soups, grilled seafood, iced drinks, herbs, and sauce plates.",
      "good-to-know": "Chanh can mean lime or lemon depending on context. The food or drink in front of you makes the request clear.",
      "explore-next": "Napkins, half portion, two of these, one more, and one-portion phrases cover nearby table requests.",
      "natural-variants": "Herbs, utensils, rice, soup-on-the-side, and sauce-on-the-side phrases cover the rest of the meal."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Cho tôi xin", english: "please give me", keepTogetherReason: "polite request opener" },
      { id: "chunk-2", vietnamese: "chanh", english: "lime / citrus", keepTogetherReason: "lime noun" },
      { id: "chunk-3", vietnamese: "được không?", english: "is that possible?", keepTogetherReason: "polite yes-no ending" }
    ],
    cardTargets: {
      "explore-next": [
        "viet-phrase-v900-food-drin-can-i-have-napkins",
        "viet-phrase-v900-food-drin-can-i-order-half-a-portion",
        "viet-phrase-v900-food-drin-two-of-these-please",
        "viet-phrase-v900-food-drin-one-more-please",
        "viet-family-food-one-portion"
      ]
    },
    cardParityLedger: {
      "explore-next": "grows the source table-request set from two to five rendered table-request cards instead of thinning meal flow"
    },
    value: "turns the lime page into a concrete table-side food request"
  }
];

console.log(JSON.stringify(applyRepairs(37, repairs), null, 2));
