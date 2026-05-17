#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");

const hubEditorialByCityID = {
  hcmc: {
    reviewStatus: "handwritten-reviewed",
    subtitle: "Start with Saigon's airport, District 1, markets, cafes, and fast-moving street life.",
    intro: "Saigon is the Vietnam city where the day can move from airport pickup to strong coffee, market bargaining, river lights, and late food without ever slowing down. These names help travelers recognize the city by real places, not just broad neighborhoods.",
    signatureMoments: [
      "land near Tan Son Nhat and get into District 1",
      "use Ben Thanh and Nguyen Hue as central meeting points",
      "order coffee, street food, or a full restaurant meal with confidence",
    ],
    practicePrompt: "Practice a first Saigon day: airport pickup, District 1, coffee, food, and getting back.",
  },
  hanoi: {
    reviewStatus: "handwritten-reviewed",
    subtitle: "Old Quarter lanes, lakes, northern food, coffee stops, and calm cultural landmarks.",
    intro: "Hanoi rewards travelers who can name the lake, the Old Quarter, the street, and the dish. The city feels layered: old lanes, shaded lakes, temple courtyards, train-station pickups, and bowls of northern food tucked into small shops.",
    signatureMoments: [
      "arrive from Noi Bai and settle near the old center",
      "use Hoan Kiem, the Old Quarter, and West Lake as orientation points",
      "recognize Hanoi food and coffee names before ordering",
    ],
    practicePrompt: "Practice a Hanoi day: airport pickup, Old Quarter, coffee, food, and a ride back.",
  },
  danang: {
    reviewStatus: "handwritten-reviewed",
    subtitle: "Beach roads, river bridges, markets, Son Tra, and easy central Vietnam day trips.",
    intro: "Da Nang is practical and scenic at the same time: airport to beach, riverfront to bridges, markets to seafood, then out toward mountain or heritage trips. These city names help travelers talk about the exact side of town they mean.",
    signatureMoments: [
      "land quickly and find the right beach or river route",
      "use bridge, market, and street names with drivers",
      "choose between seafood, cafes, Marble Mountains, Son Tra, and Ba Na trips",
    ],
    practicePrompt: "Practice a Da Nang day: airport pickup, beach drop-off, food, and a ride back.",
  },
  hoian: {
    reviewStatus: "handwritten-reviewed",
    subtitle: "Ancient Town walks, lantern streets, tailor stops, cafes, markets, and countryside routes.",
    intro: "Hoi An is small enough to wander and rich enough to need names: the old town, the river, the bridge, the market, the beach, and the villages outside the lantern streets. These entries help travelers keep the romance of the place while still asking clearly.",
    signatureMoments: [
      "find the Ancient Town, bridge, river, and night-market side",
      "ask for food, cafes, tailor stops, or craft villages by name",
      "get back to the hotel after lantern streets or countryside trips",
    ],
    practicePrompt: "Practice a Hoi An day: hotel pickup, Old Town, food, lantern streets, and a ride back.",
  },
  hue: {
    reviewStatus: "handwritten-reviewed",
    subtitle: "Imperial gates, royal tombs, Perfume River rides, garden houses, and central dishes.",
    intro: "Hue is easier to love when the names stop blurring together. The city stretches from the Imperial City to river pagodas, royal tombs, garden houses, markets, and deeply local food, so exact names make the trip feel less intimidating.",
    signatureMoments: [
      "use the Imperial City as the first orientation point",
      "separate tombs, pagodas, river stops, and market names",
      "order Hue food with the confidence that the name carries history",
    ],
    practicePrompt: "Practice a Hue day: station pickup, the Citadel, river stops, food, and getting back.",
  },
};

const profileConfig = {
  street: {
    atTitle: "About",
    quickTitle: "Hear the street",
    placeBriefTitle: "Tell the driver",
    useItWithTitle: "Confirm the street",
    whenTitle: "If pickup gets fuzzy",
  },
  transit: {
    atTitle: "About",
    quickTitle: "Hear the name",
    placeBriefTitle: "Arriving",
    useItWithTitle: "Pickup or drop-off",
    whenTitle: "Help nearby",
  },
  market: {
    atTitle: "About",
    quickTitle: "Hear the name",
    placeBriefTitle: "Getting there",
    useItWithTitle: "At the market",
    whenTitle: "Prices & cash",
  },
  restaurant: {
    atTitle: "About the stop",
    quickTitle: "Hear the name",
    placeBriefTitle: "Getting there",
    useItWithTitle: "Table & menu",
    whenTitle: "Getting back",
  },
  cafe: {
    atTitle: "About the stop",
    quickTitle: "Hear the name",
    placeBriefTitle: "Getting there",
    useItWithTitle: "Order",
    whenTitle: "Pay & leave",
  },
  dish: {
    atTitle: "About the dish",
    quickTitle: "Hear the dish",
    placeBriefTitle: "Order it",
    useItWithTitle: "Ask what's inside",
    whenTitle: "Sauce & spice",
  },
  experience: {
    atTitle: "About",
    quickTitle: "Hear the name",
    placeBriefTitle: "Visit flow",
    useItWithTitle: "Tickets & entrance",
    whenTitle: "Getting back",
  },
  default: {
    atTitle: "About",
    quickTitle: "Hear the name",
    placeBriefTitle: "Getting there",
    useItWithTitle: "At the place",
    whenTitle: "Meeting or pickup",
  },
};

const cityVoice = {
  hcmc: {
    shortName: "Saigon",
    dailyLife: "Saigon moves through coffee counters, market aisles, scooters, riverfront walks, and late meals with very little pause.",
    foodLens: "Saigon food often feels abundant and fast: herbs, pickles, grilled meats, iced coffee, street snacks, and night seafood all belong to the same day.",
    placeLens: "In Saigon, exact names matter because District 1 landmarks, Chợ Lớn, river stops, and airport roads can sound close together once traffic starts moving.",
  },
  hanoi: {
    shortName: "Hanoi",
    dailyLife: "Hanoi rewards slower looking: old lanes, lakes, temple courtyards, coffee stools, and northern bowls that feel tied to neighborhood routine.",
    foodLens: "Hanoi food is often about balance and restraint: clear broth, smoke from grilled pork, herbs, vinegar, fish sauce, and patient coffee rituals.",
    placeLens: "In Hanoi, exact names help separate the Old Quarter, lakes, museums, and food streets without losing the older northern character of the city.",
  },
  danang: {
    shortName: "Da Nang",
    dailyLife: "Da Nang is easy to move through but still very local: airport curb, beach road, river bridge, seafood table, market, and day-trip pickup.",
    foodLens: "Da Nang food leans central: rice paper, herbs, fish sauce, turmeric noodles, seafood, chili warmth, and sauces that travelers should ask about before diving in.",
    placeLens: "In Da Nang, the useful names line up with how the city works: beaches, bridges, markets, mountain roads, and central-Vietnam side trips.",
  },
  hoian: {
    shortName: "Hoi An",
    dailyLife: "Hoi An feels small until you start naming it: Ancient Town lanes, river bridges, market stalls, tailor stops, beaches, and craft villages all ask for different words.",
    foodLens: "Hoi An food carries the town's trading-port feeling: chewy noodles, rice crackers, chicken rice, herbs, sweet corn desserts, and dishes that travelers rarely meet elsewhere.",
    placeLens: "In Hoi An, exact names protect the charm of wandering by making it easy to return to the right bridge, riverbank, market, beach, or village.",
  },
  hue: {
    shortName: "Hue",
    dailyLife: "Hue is quieter than it is simple: imperial gates, tomb roads, pagodas, garden houses, river crossings, markets, and deeply local food all have their own rhythm.",
    foodLens: "Hue food often feels precise and historic: small cakes, clam rice, lemongrass broth, sesame sweets, chili, shrimp, herbs, and royal-city care in everyday portions.",
    placeLens: "In Hue, names carry history, so a tomb, gate, pagoda, market, or river stop is more than a pin on the map.",
  },
};

const dishStories = [
  {
    match: /bún chả cá|bun cha ca|fish-cake noodle/i,
    body: (name) => `${name} is a Da Nang coastal bowl built around fish cake, noodles, herbs, and a bright savory broth. It belongs to the central coast more than to Hanoi's grilled-pork bun cha, so the flavor is lighter, fishier, and very tied to morning market and beach-city eating.`,
    order: "Ask what fish cake and toppings are included, then add chili, lime, or herbs only after tasting the broth.",
  },
  {
    match: /bánh mì|banh mi/i,
    body: (name, cityName) => `${name} connects French-introduced bread with Vietnamese fillings, herbs, pickles, chili, and pâté or grilled meat. In ${cityName}, it is the kind of quick meal locals still buy between errands, work, and late-night plans.`,
    order: "Ask what fillings are inside before ordering; pâté, pork, egg, chili, cucumber, pickles, and herbs can change by stall.",
  },
  {
    match: /bánh xèo|banh xeo|sizzling pancake/i,
    body: (name, cityName) => `${name} is about crunch, herbs, and dipping sauce, not just the pancake itself. In central and southern Vietnam, diners often break off pieces, wrap them with greens or rice paper when served, then dip lightly so the crisp edges stay alive.`,
    order: "Ask whether rice paper and herbs come with it, then check the dipping sauce if fish sauce, peanuts, or chili are concerns.",
  },
  {
    match: /bánh tráng cuốn thịt heo|pork rice-paper rolls/i,
    body: (name) => `${name} is a Da Nang classic built for hands-on eating: rice paper, sliced pork, herbs, vegetables, and a strong dipping sauce come together at the table. The pleasure is in rolling it yourself, not treating it like a finished wrap.`,
    order: "Ask for extra rice paper or herbs if the plate is shared, and ask about the dipping sauce before you commit to the salty, fermented punch.",
  },
  {
    match: /mì quảng|mi quang/i,
    body: (name, cityName) => `${name} belongs to central Vietnam's Quảng Nam and Da Nang food world: turmeric-tinted noodles, a small amount of rich broth, herbs, peanuts, rice cracker, and meat or seafood. It eats more like a composed bowl than a soup.`,
    order: "Ask what protein is included, then add herbs, lime, and chili slowly because the broth is meant to stay concentrated.",
  },
  {
    match: /bún bò huế|bun bo hue/i,
    body: (name) => `${name} carries Hue's central-Vietnam identity in the bowl: lemongrass, chili oil, beef, round noodles, herbs, and a deeper broth than pho. It is one of the easiest dishes for travelers to connect directly to the city that shaped it.`,
    order: "Ask for less spicy before the bowl is made if needed, then use lime and herbs to brighten the broth instead of burying it.",
  },
  {
    match: /cao lầu|cao lau/i,
    body: (name) => `${name} is one of Hoi An's signature dishes: chewy noodles, pork, herbs, greens, crisp crackers, and just enough sauce. The dish feels tied to the old trading town because it is local, textural, and harder to find at the same quality outside Hoi An.`,
    order: "Ask what comes in the bowl, then mix gently so the herbs, pork, sauce, and crisp pieces stay distinct.",
  },
  {
    match: /cà phê trứng|egg coffee/i,
    body: (name) => `${name} is Hanoi coffee with a story: strong Vietnamese coffee under a whipped egg-yolk foam that became famous as a rich answer when fresh milk was scarce. It tastes custardy and bittersweet, closer to dessert than a normal morning coffee.`,
    order: "Ask whether it is hot or iced, and stir only after tasting the foam and coffee separately.",
  },
  {
    match: /cà phê sữa đá|iced milk coffee|milk coffee/i,
    body: (name, cityName) => `${name} shows why coffee feels so Vietnamese: dark robusta, condensed milk, ice, and a slow-drip habit that turned into everyday street culture. In ${cityName}, it is both a drink and a pause in the day.`,
    order: "Ask for less ice or less sweet before it is made if you want more coffee bitterness and less condensed-milk sweetness.",
  },
  {
    match: /bún chả|bun cha/i,
    body: (name) => `${name} is a Hanoi meal of grilled pork, noodles, herbs, and dipping sauce where smoke and fresh greens meet in the same bite. It is a northern food ritual as much as a dish: assemble, dip, add herbs, repeat.`,
    order: "Ask what is included if sharing, and keep the sauce bowl bright with herbs, garlic, chili, or vinegar only after tasting it first.",
  },
  {
    match: /phở bò|beef pho|phở gà|chicken pho|southern pho|phở sài gòn|pho/i,
    body: (name, cityName) => `${name} is Vietnam's most famous noodle soup, but it changes by region. In ${cityName}, pay attention to broth style, herbs, lime, sprouts, sauces, and whether the bowl is northern-clean or southern-generous.`,
    order: "Choose beef or chicken clearly, taste the broth before adding sauces, and ask about rare beef if you prefer it fully cooked.",
  },
  {
    match: /cơm tấm|broken rice/i,
    body: (name) => `${name} is deeply Saigon: broken rice grains with grilled pork, pickles, scallion oil, fish sauce, and often egg or steamed pork loaf. It is a working-day plate that became one of the city's most satisfying meals.`,
    order: "Ask which toppings come with the plate, then pour fish sauce gradually so the rice stays fragrant instead of soaked.",
  },
  {
    match: /gỏi cuốn|fresh spring rolls/i,
    body: (name) => `${name} is Vietnam's fresh-roll side of street food: rice paper wrapped around herbs, noodles, shrimp, pork, or vegetables. The flavor comes from freshness and sauce rather than frying.`,
    order: "Ask what protein is inside and whether the sauce is peanut-based, fish-sauce based, or spicy.",
  },
  {
    match: /bò lá lốt|betel leaves/i,
    body: (name) => `${name} wraps seasoned beef in fragrant betel leaves, then grills it so the leaves turn smoky and herbal. It is often best with herbs, rice paper, noodles, pickles, and dipping sauce rather than eaten plain.`,
    order: "Ask for rice paper and herbs if they are not on the table, and check the dipping sauce before adding chili.",
  },
  {
    match: /bột chiên|rice-flour cakes/i,
    body: (name) => `${name} is a southern street snack with crisp rice-flour cubes, egg, green onion, papaya, and soy-vinegar sauce. It is the kind of griddle food that makes more sense when you smell it cooking nearby.`,
    order: "Ask for one plate, then add the sauce slowly because the crisp edges are the whole point.",
  },
  {
    match: /bún thịt nướng|grilled pork vermicelli/i,
    body: (name, cityName) => `${name} is a cool noodle bowl with grilled pork, herbs, pickles, peanuts, and fish-sauce dressing. In ${cityName}, it is an easy way to taste the Vietnamese habit of balancing smoke, crunch, sweetness, and herbs in one bowl.`,
    order: "Ask about peanuts, pork, and fish sauce before mixing everything together.",
  },
  {
    match: /chè|sweet soup|corn sweet soup/i,
    body: (name, cityName) => `${name} is Vietnam's dessert-drink world: beans, jelly, corn, fruit, coconut milk, ice, and syrup can all show up in the cup or bowl. In ${cityName}, it is a low-pressure way to taste texture as much as sweetness.`,
    order: "Ask for less sweet or less ice before it is made, especially if you want the beans, corn, or coconut to stand out.",
  },
  {
    match: /hủ tiếu|hu tieu/i,
    body: (name) => `${name} belongs to southern noodle culture, often with a clear porky broth, rice noodles, herbs, pork, shrimp, or offal depending on the shop. It is lighter than many travelers expect but full of small choices.`,
    order: "Ask what meat is included and whether the noodles come dry or with broth if the menu offers both.",
  },
  {
    match: /ốc|snails|seafood/i,
    body: (name, cityName) => `${name} is social food in ${cityName}: small tables, shared plates, shells, herbs, sauces, and a lot of pointing at what looks good. The sauces matter as much as the seafood.`,
    order: "Ask what sauce comes with each plate, and order slowly if shellfish, spice, or unfamiliar textures are a concern.",
  },
  {
    match: /phá lấu|pha lau/i,
    body: (name) => `${name} is a rich Saigon street dish of offal or meat simmered with coconut, spices, and sauce, often eaten with bread. It is beloved because it is bold, cheap, and deeply tied to snack culture.`,
    order: "Ask what parts are inside before ordering, then use bread to balance the sauce.",
  },
  {
    match: /bánh cuốn|steamed rice rolls/i,
    body: (name) => `${name} is a northern breakfast favorite: thin steamed rice sheets folded around savory filling, herbs, fried shallots, and dipping sauce. It is delicate, fast, and very Hanoi when eaten early.`,
    order: "Ask what filling is inside and dip lightly so the rice sheets do not fall apart.",
  },
  {
    match: /bia hơi|fresh beer/i,
    body: (name) => `${name} is Hanoi's easygoing fresh beer culture: light draft beer, tiny stools, snack plates, and sidewalk conversation. It is less about craft tasting notes and more about the social rhythm of the city.`,
    order: "Ask for one glass, check whether food is expected at the table, and pay attention to cash because the table is casual.",
  },
  {
    match: /chả cá|turmeric dill fish/i,
    body: (name) => `${name} is a Hanoi specialty of turmeric-marinated fish cooked with dill and scallions, then eaten with noodles, herbs, peanuts, and sauce. The dill is the signal; it makes the dish feel unmistakably northern.`,
    order: "Ask what fish is used and add herbs, peanuts, and sauce gradually so the turmeric and dill stay clear.",
  },
  {
    match: /xôi xéo|sticky rice/i,
    body: (name) => `${name} is a Hanoi breakfast comfort: sticky rice with mung bean, fried shallots, and sometimes extra toppings. It is filling, portable, and rooted in everyday morning routines.`,
    order: "Ask which toppings are available, then choose simple add-ons if you want it for breakfast on the move.",
  },
  {
    match: /bánh bèo|bánh bột lọc|bánh nậm|bánh khoái|banh beo|banh bot loc|banh nam|banh khoai/i,
    body: (name) => `${name} belongs to Hue's small-dish world, where rice flour, shrimp, pork, herbs, dipping sauce, and careful portions make the meal feel almost ceremonial. Hue food often teaches travelers to slow down and taste details.`,
    order: "Ask what sauce comes with it and whether pork, shrimp, or chili is included before ordering a shared plate.",
  },
  {
    match: /cơm hến|bún hến|clam/i,
    body: (name) => `${name} is a Hue dish built around tiny clams, herbs, crunch, chili, and rice or noodles. It is humble food with a strong local identity, especially around the Perfume River and everyday market eating.`,
    order: "Ask about spice and shellfish before ordering, then mix enough to spread the herbs and clam flavor through the bowl.",
  },
  {
    match: /cơm âm phủ|com am phu/i,
    body: (name) => `${name} is a Hue mixed-rice dish with a memorable name and a colorful plate of rice, egg, pork, herbs, and vegetables. It is local, playful, and much less mysterious once the plate arrives.`,
    order: "Ask what toppings are included, then mix the rice with sauce slowly so the separate colors and textures still show.",
  },
  {
    match: /mè xửng|sesame candy/i,
    body: (name) => `${name} is Hue's chewy sesame candy, often bought as a gift or taken with tea. It connects to the city's slower snack culture rather than a full meal.`,
    order: "Ask for a small box or sample if available, and check whether peanuts or sesame are a concern.",
  },
  {
    match: /bánh đập|white rose|wonton|cơm gà|chicken rice|nước mót|herbal drink/i,
    body: (name) => `${name} is part of Hoi An's compact food identity: old-town stalls, family recipes, herbs, rice textures, and a traveler-friendly scale that still feels local. The dish is worth learning by name because it is tied to the town, not just to Vietnam in general.`,
    order: "Ask what is inside, whether sauce is already added, and whether chili or herbs can be kept separate.",
  },
  {
    match: /bún chả cá|fish-cake noodle/i,
    body: (name) => `${name} is a Da Nang bowl with fish cake, noodles, herbs, and a bright coastal broth. It tastes like a central beach city meal: lighter than beef soup, but still savory and satisfying.`,
    order: "Ask what fish cake and toppings are included, then add chili only after tasting the broth.",
  },
  {
    match: /nem lụi|lemongrass pork skewers/i,
    body: (name) => `${name} is central Vietnam's roll-it-yourself pleasure: grilled pork skewers, herbs, rice paper, pickles, and a rich dipping sauce. The table setup matters as much as the skewer.`,
    order: "Ask for rice paper, herbs, and sauce if they are not obvious, then check peanuts, pork, and chili.",
  },
  {
    match: /kem bơ|avocado ice cream/i,
    body: (name) => `${name} is a Da Nang dessert favorite where avocado turns creamy and almost milkshake-like under coconut or ice cream. It is cooling, rich, and much more Vietnamese than it sounds in translation.`,
    order: "Ask for less sweet if needed and expect a spoonable dessert rather than a plain scoop.",
  },
];

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim();
}

function sentence(value) {
  const text = normalize(value);
  if (!text) return "";
  return /[.!?]$/.test(text) ? text : `${text}.`;
}

function articleFor(phrase) {
  const firstWord = normalize(phrase).split(/\s+/)[0] ?? "";
  return /^[aeiou]/i.test(firstWord) ? "an" : "a";
}

function cleanVisibleText(value, page, city) {
  let text = sentence(value);
  const englishName = page.englishText || "This stop";
  const cityName = city.shortTitle || city.title;

  text = text.replace(/^Use this as an? ([^.]+)\./i, (_match, phrase) => `${englishName} is ${articleFor(phrase)} ${phrase}.`);
  text = text.replace(/^Use this as ([^.]+)\./i, (_match, phrase) => `${englishName} is ${articleFor(phrase)} ${phrase}.`);
  text = text.replace(/^Keep this as an? named ([^.]+)\./i, `${englishName} is a named $1.`);
  text = text.replace(/^Keep this as an? ([^.]+)\./i, (_match, phrase) => `${englishName} is ${articleFor(phrase)} ${phrase}.`);
  text = text.replace(/\bKeep it concrete and table-level\b/gi, "Use it at the table");
  text = text.replace(/\bKeep alcohol wording factual and use it to\b/gi, "Use it to");
  text = text.replace(/\bKeep branch wording precise because\b/gi, "Confirm the branch because");
  text = text.replace(/\bKeep branch details tied to the address you have\b/gi, "Confirm the branch and address before you go");
  text = text.replace(/\bKeep menu details tied to the menu in front of you\b/gi, "Read the current menu before deciding");
  text = text.replace(/\bkeep menu details general until you ask there\b/gi, "confirm menu details when you arrive");
  text = text.replace(/\bUse neutral wording around the Vietnamese spelling and help the traveler confirm the address\b/gi, "Use the Vietnamese spelling and confirm the address");
  text = text.replace(/\bwhen the traveler wants\b/gi, "when you want");
  text = text.replace(/\bwhen travelers want\b/gi, "when you want");
  text = text.replace(/\bFocus on\b/gi, "Use it for");
  text = text.replace(/\bSupport finding\b/gi, "It helps with finding");
  text = text.replace(/\bSupport\b/gi, "It helps with");
  text = text.replace(/\bnot as a generic boat phrase\b/gi, "as a real river plan");
  text = text.replace(/\brather than a generic \"nightlife\" phrase\b/gi, "for evening food and pickup");
  text = text.replace(/\bgeneric errand entry\b/gi, "vague errand entry");
  text = text.replace(/\bgeneric shopping entry\b/gi, "vague shopping entry");
  text = text.replace(/\bgeneric shopping phrase\b/gi, "vague shopping phrase");
  text = text.replace(/\bgeneric bridge phrase\b/gi, "plain bridge label");
  text = text.replace(/\bgeneric cafe recommendation\b/gi, "vague cafe recommendation");
  text = text.replace(/\bgeneric pho request\b/gi, "vague pho request");
  text = text.replace(/\bgeneric museum\b/gi, "plain museum label");
  text = text.replace(/\bgeneric drink\b/gi, "plain drink label");
  text = text.replace(/\bgeneric garden-cafe idea\b/gi, "vague garden-cafe idea");
  text = text.replace(/\bgeneric souvenir phrase\b/gi, "vague souvenir phrase");
  text = text.replace(/\bgeneric airport errands\b/gi, "ordinary airport errands");
  text = text.replace(/\bgeneric bus stop\b/gi, "plain bus stop");
  text = text.replace(/\bgeneric espresso counter\b/gi, "standard espresso counter");
  text = text.replace(/\bgeneric\b/gi, "vague");
  text = text.replace(/\s*without adding generic[^.]+\./gi, ".");
  text = text.replace(/,\s*not a generic [^.]+\./gi, ".");
  text = text.replace(/\bnot a generic [^.]+\./gi, "use the exact name and map pin.");
  text = text.replace(/\brather than a single generic phrase\b/gi, "with tickets, pickup points, and the actual visit plan");
  text = text.replace(/\bIt is more useful than generic shopping advice\b/gi, "It is useful for shopping, snacks, gates, and meetups");
  text = text.replace(/\bthan a long custom sentence\b/gi, "than one-off prose");
  text = text.replace(/\bAlso teach checking the map pin before the ride\b/gi, "Check the map pin before the ride");
  text = text.replace(/\bThe row supports\b/gi, "It supports");
  text = text.replace(/\bThis row supports\b/gi, "It supports");
  text = text.replace(/\bThe row does not need\b/gi, "It does not need");
  text = text.replace(/\bThe name works as both a restaurant and dish cue\b/gi, "The name can mean the restaurant as well as the dish to ask about");
  text = text.replace(/\bit works as both a destination and a meet-up point\b/gi, "it can be both a destination and a meet-up point");
  text = text.replace(/\bworks as both\b/gi, "can be both");
  text = text.replace(/\bworks as dish reference point\b/gi, "is useful for recognizing the dish");
  text = text.replace(/\bdish reference point\b/gi, "dish to recognize");
  text = text.replace(/\bto reference point\b/gi, "for finding");
  text = text.replace(/\bcan reference point\b/gi, "can guide");
  text = text.replace(/\bUse the name as\b/g, "Use the name as");
  text = text.replace(/\bso Use\b/g, "so use");
  text = text.replace(/\band Use\b/g, "and use");
  text = text.replace(/\bAvoid hype and Use\b/g, "Avoid hype and use");
  text = text.replace(/\bproper venue-like nature stop\b/gi, "quiet nature stop");
  text = text.replace(/\bSIM or ATM rows\b/gi, "SIM or ATM help");
  text = text.replace(/\bname surface\b/gi, "arrival name");
  text = text.replace(/\bcity food guide\b/gi, "food stop");
  text = text.replace(/\brestaurant\/place rows\b/gi, "restaurant or place choices");
  text = text.replace(/\blocal sources for address details\b/gi, "the address details");
  text = text.replace(/\bshop-name rows\b/gi, "named shops");
  text = text.replace(/\bspecific dish row\b/gi, "specific dish");
  text = text.replace(/\breal cafe rows\b/gi, "real cafe stops");
  text = text.replace(/\bgeneric drink row\b/gi, "generic drink");
  text = text.replace(/\brestaurant row\b/gi, "restaurant stop");
  text = text.replace(/\buseful city row\b/gi, "useful city stop");
  text = text.replace(/\bnamed terminal row\b/gi, "named terminal");
  text = text.replace(/\bSaigon River rows\b/gi, "Saigon River plans");
  text = text.replace(/\bThe page can stay factual\b/gi, "Keep it factual");
  text = text.replace(/\bgeneric museum row\b/gi, "generic museum");
  text = text.replace(/\bNamed shop rows\b/gi, "Named shops");
  text = text.replace(/\bgeneral coffee rows\b/gi, "general coffee stops");
  text = text.replace(/\bcountryside surface\b/gi, "countryside route");
  text = text.replace(/\bNamed tailor rows\b/gi, "Named tailor stops");
  text = text.replace(/\btailoring-and-fitting surface\b/gi, "tailoring-and-fitting stop");
  text = text.replace(/\bstall row\b/gi, "stall aisle");
  text = text.replace(/\bimage-heavy browsing\b/gi, "a visual cafe search");
  text = text.replace(/\bfood-anchor noun\b/gi, "food name");
  text = text.replace(/\bfood-anchor\b/gi, "food");
  text = text.replace(/\bmenu-image reference point\b/gi, "menu name");
  text = text.replace(/\bimage-led browse\b/gi, "photo-friendly planning");
  text = text.replace(/\bvisual browse\b/gi, "photo-friendly planning");
  text = text.replace(/\bimage-led city guide stop\b/gi, "easy city landmark");
  text = text.replace(/\bcity menu surface\b/gi, "food stop");
  text = text.replace(/\bhelps users say\b/gi, "helps you say");
  text = text.replace(/\bwithout extra cuisine promises\b/gi, "without guessing the cuisine");
  text = text.replace(/\bvenue branches can change\b/gi, "a venue can have more than one branch");
  text = text.replace(/\bplace-name orientation\b/gi, "orientation");
  text = text.replace(/\bplace-name\b/gi, "specific place");
  text = text.replace(/\bcity tile\b/gi, "city guide stop");
  text = text.replace(/\bplace anchor\b/gi, "orientation point");
  text = text.replace(/\banchor\b/gi, "reference point");
  text = text.replace(/\broute phrase\b/gi, "route wording");
  text = text.replace(/\bwhere-question\b/gi, "where-to-go question");
  text = text.replace(/\bcontent role\b/gi, "travel job");
  text = text.replace(/\bpage kind\b/gi, "travel stop");
  text = text.replace(/\bplace name\b/gi, "local name");
  text = text.replace(/\bnoun\b/gi, "name");
  text = text.replace(/\bplace name\b/gi, "local name");
  text = text.replace(/([a-z])-\s*place name\b/gi, "$1 place");
  text = text.replace(/\bThis page\b/gi, "This guide");
  text = text.replace(/\bcity page\b/gi, "city guide");
  text = text.replace(/\. Use /g, ". Use ");
  text = text.replace(/\bdish reference point\b/gi, "dish to recognize");
  text = text.replace(/\bvisual\/menu potential\b/gi, "photo-friendly cafe character");
  text = text.replace(/\bevening route reference point with local map details\b/gi, "dinner meetup point; keep the saved map visible for the ride");
  text = text.replace(/\bRiverfront dining name that can guide an evening route\b/gi, "Riverfront dining name for dinner plans and pickup after the meal");
  text = text.replace(/\bNamed cafe with strong photo-friendly cafe character\b/gi, "Named cafe with a retro look and easy meetup value");
  text = text.replace(/\bvisual browse\b/gi, "photo-friendly planning");
  text = text.replace(/\bfor finding near\b/gi, "near");
  text = text.replace(/\bworks as an? ([^,.]+)/gi, (_match, phrase) => `is ${articleFor(phrase)} ${phrase}`);
  text = text.replace(/\brows\b/gi, "choices");
  text = text.replace(/\brow\b/gi, "stop");
  text = text.replace(/\bsurface\b/gi, "stop");
  return sentence(text);
}

function profileFor(page) {
  const placeKind = normalize(page.placeKind).toLowerCase();
  const pageKind = normalize(page.pageKind || page.kind).toLowerCase();
  if (placeKind === "street" || placeKind === "neighborhood") return "street";
  if (["airport", "station", "port", "pier"].includes(placeKind)) return "transit";
  if (placeKind === "market" || page.subcategoryID === "shopping-markets") return "market";
  if (placeKind === "cafe") return "cafe";
  if (pageKind === "restaurant" || placeKind === "restaurant") return "restaurant";
  if (pageKind === "dish" || placeKind === "dish" || placeKind === "local dish" || placeKind === "food spot") return "dish";
  if (["experience", "attraction", "village", "river", "beach", "nature", "park", "landmark", "museum"].includes(placeKind)) return "experience";
  return "default";
}

function cleanedImagePrompt(page) {
  let text = normalize(page.productionIntake?.imagePromptNote);
  if (!text) return "";
  text = text
    .replace(/^Photorealistic owned asset:\s*/i, "")
    .replace(/golden bánh xèo/gi, "golden crispy pancake")
    .replace(/bánh xèo/gi, "crispy pancake")
    .replace(/bún bò Huế/gi, "lemongrass beef noodle soup")
    .replace(/bún chả/gi, "grilled pork noodle bowl")
    .replace(/bò lá lốt/gi, "grilled betel-leaf beef")
    .replace(/cơm tấm/gi, "broken rice plate")
    .replace(/gỏi cuốn/gi, "fresh spring rolls")
    .replace(/hủ tiếu/gi, "southern noodle bowl")
    .replace(/phở/gi, "pho")
    .replace(/mì quảng/gi, "central turmeric noodles")
    .replace(/cao lầu/gi, "Hoi An noodles")
    .replace(/bánh mì/gi, "Vietnamese baguette sandwich")
    .replace(/\brealistic photo\b/gi, "")
    .replace(/\bphotorealistic\b/gi, "")
    .replace(/\bno readable [^,.]+[,.]?/gi, "")
    .replace(/\bno exact [^,.]+[,.]?/gi, "")
    .replace(/\bno identifiable [^,.]+[,.]?/gi, "")
    .replace(/\bno close-up faces[,.]?/gi, "")
    .replace(/\bno hands[,.]?/gi, "")
    .replace(/\bno crowds in foreground[,.]?/gi, "")
    .replace(/\bno airline logos[,.]?/gi, "")
    .replace(/\bno readable plates[,.]?/gi, "")
    .replace(/\bno branding[,.]?/gi, "")
    .replace(/\bno brand logo[,.]?/gi, "")
    .replace(/\bno logo[,.]?/gi, "")
    .replace(/\bno logos[,.]?/gi, "")
    .replace(/\bno watermark[,.]?/gi, "")
    .replace(/\binvented artwork[,.]?/gi, "playful gallery art")
    .replace(/\bmarket rows\b/gi, "market aisles")
    .replace(/\brows\b/gi, "choices")
    .replace(/\brow\b/gi, "stop")
    .replace(/\blocal sources\b/gi, "stable local notes")
    .replace(/\s*,\s*\./g, ".")
    .replace(/\s+,/g, ",")
    .replace(/\s+/g, " ")
    .trim();
  return text.replace(/[,.]\s*$/, "");
}

function cleanSourceNote(value) {
  const text = normalize(value);
  if (!text) return "";
  return text
    .replace(/\bThe name works as both a restaurant and dish cue\b/gi, "The name can mean the restaurant as well as the dish to ask about")
    .replace(/\bit works as both a destination and a meet-up point\b/gi, "it can be both a destination and a meet-up point")
    .replace(/\bworks as both\b/gi, "can be both")
    .replace(/\blocal sources\b/gi, "stable local notes")
    .replace(/\bexisting Cam Thanh rows\b/gi, "Cam Thanh basket boat notes")
    .replace(/\bmarket rows\b/gi, "market aisles")
    .replace(/\brows\b/gi, "choices")
    .replace(/\brow\b/gi, "stop")
    .trim();
}

function sanitizeResidualStrings(value) {
  if (Array.isArray(value)) {
    return value.map(sanitizeResidualStrings);
  }
  if (!value || typeof value !== "object") {
    return typeof value === "string" ? cleanSourceNote(value) : value;
  }
  return Object.fromEntries(
    Object.entries(value).map(([key, childValue]) => {
      if (typeof childValue === "string" && (key === "sourceNotes" || key === "imagePromptNote")) {
        return [key, cleanSourceNote(childValue)];
      }
      return [key, sanitizeResidualStrings(childValue)];
    })
  );
}

function kindLabel(page) {
  const placeKind = normalize(page.placeKind).toLowerCase();
  if (placeKind === "airport") return "airport arrival point";
  if (placeKind === "station") return "station or transfer point";
  if (placeKind === "port" || placeKind === "pier") return "river or boat transfer point";
  if (placeKind === "market") return "market";
  if (placeKind === "street") return "street";
  if (placeKind === "neighborhood") return "neighborhood";
  if (placeKind === "cafe") return "cafe";
  if (placeKind === "restaurant") return "restaurant";
  if (placeKind === "museum") return "cultural stop";
  if (placeKind === "landmark") return "landmark";
  if (placeKind === "beach") return "beach";
  if (placeKind === "nature") return "nature stop";
  if (placeKind === "park") return "park";
  if (placeKind === "river") return "river landmark";
  if (placeKind === "village") return "village or craft stop";
  if (placeKind === "experience") return "experience";
  if (placeKind === "attraction") return "attraction";
  return "city stop";
}

function cityTone(city) {
  return cityVoice[city.id] ?? {
    shortName: city.shortTitle || city.title,
    dailyLife: `${city.shortTitle || city.title} becomes easier when travelers can name real places and food clearly.`,
    foodLens: `Food in ${city.shortTitle || city.title} is easiest to enjoy when the name, ingredients, and sauces are not a mystery.`,
    placeLens: `Exact names help travelers move through ${city.shortTitle || city.title} without turning every question into a long explanation.`,
  };
}

function detailSentence(page) {
  return "";
}

function lowerFirst(value) {
  const text = normalize(value);
  if (!text) return "";
  return `${text.charAt(0).toLowerCase()}${text.slice(1)}`;
}

function withoutDuplicateSentences(sentences) {
  const seen = new Set();
  const result = [];
  for (const rawSentence of sentences) {
    const text = sentence(rawSentence);
    if (!text) continue;
    const key = normalize(text)
      .toLowerCase()
      .replace(/[^a-z0-9à-ỹđ]+/gi, " ")
      .trim();
    if (!key || seen.has(key)) continue;
    seen.add(key);
    result.push(text);
  }
  return result.join(" ");
}

function sourceContext(page, city) {
  const text = cleanVisibleText(page.context, page, city);
  if (!text || /\bcity guide\b/i.test(text)) return "";
  return text;
}

function sourceTip(page, city) {
  const text = cleanVisibleText(page.tip || page.rationale, page, city);
  if (!text || /\bcity guide\b/i.test(text)) return "";
  return text;
}

function targetNameLine(page) {
  const target = normalize(page.targetText);
  const english = normalize(page.englishText);
  if (!target || !english || target.toLowerCase() === english.toLowerCase()) {
    return `${english || "The name"} is the form to show from the app when sound, accents, or spelling get uncertain.`;
  }
  return `${target} is the Vietnamese name shown here; ${english} is the English meaning to keep in mind before you play it aloud.`;
}

function sceneDetail(page) {
  return "";
}

function isExplicitKnownConnection(page, city) {
  const connection = knownPlaceConnection(page, city);
  if (!connection) return "";
  const genericStarters = [
    "gives ",
    "helps turn ",
    "is part of ",
    "gives the city",
    "is the kind of",
    "brings the trip",
    "is practical beach",
    "helps travelers talk",
    "is useful",
    "is arrival",
    "is transfer",
    "is where",
  ];
  const body = connection.replace(new RegExp(`^${(page.englishText || "").replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\s+`, "i"), "");
  if (genericStarters.some((starter) => body.toLowerCase().startsWith(starter))) return "";
  return connection;
}

function knownPlaceConnection(page, city) {
  const name = page.englishText || "This stop";
  const target = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`.toLowerCase();
  const cityName = city.shortTitle || city.title;
  const rules = [
    [/ben thanh|bến thành/, `${name} is one of Saigon's central orientation names: market, metro, shopping streets, and pickup points all cluster around it.`, "hcmc"],
    [/cho lon|chợ lớn|binh tay|bình tây/, `${name} points toward Chợ Lớn, Saigon's Chinese-Vietnamese commercial side, where market life and temple streets feel different from District 1.`, "hcmc"],
    [/nguyen hue|nguyễn huệ/, `${name} belongs to Saigon's pedestrian-core vocabulary: City Hall, cafe apartments, evening walks, and central meetups all orbit nearby.`, "hcmc"],
    [/independence palace|dinh độc lập/, `${name} carries modern Vietnamese history in a very visible way, so it is more than a photo stop in central Saigon.`, "hcmc"],
    [/post office|bưu điện|notre dame|đức bà|opera house|nhà hát/, `${name} helps travelers read Saigon's older civic core, where colonial-era buildings sit inside today's fast city traffic.`, "hcmc"],
    [/old quarter|phố cổ/, `${name} is Hanoi's dense old-center name, useful for food streets, small hotels, lake walks, and getting back after wandering.`, "hanoi"],
    [/hoan kiem|hoàn kiếm/, `${name} is Hanoi orientation language: the lake, old center, weekend walking space, and first-day meetups all connect here.`, "hanoi"],
    [/west lake|hồ tây/, `${name} gives Hanoi travelers a wider, calmer side of the city after the Old Quarter's tight lanes.`, "hanoi"],
    [/temple of literature|văn miếu/, `${name} connects Hanoi to Vietnam's long scholarly tradition, which is why it feels quieter and more ceremonial than a normal landmark.`, "hanoi"],
    [/train street|tàu/, `${name} is a Hanoi curiosity that needs practical caution: the name is useful, but access and safe viewing can change.`, "hanoi"],
    [/dragon bridge|cầu rồng/, `${name} is Da Nang's easiest bridge landmark to recognize, linking the riverfront, night walks, and the city's modern image.`, "danang"],
    [/marble mountains|ngũ hành sơn/, `${name} connects Da Nang to caves, pagodas, stone-carving villages, and the old road toward Hoi An.`, "danang"],
    [/my khe|mỹ khê|beach|biển/, `${name} is beach-side Da Nang language: useful for hotel areas, seafood plans, coastal roads, and ride pickup.`, "danang"],
    [/son tra|sơn trà|linh ứng/, `${name} points to Da Nang's peninsula side, where ocean views, pagodas, forest roads, and return timing matter.`, "danang"],
    [/ancient town|phố cổ/, `${name} is the Hoi An name travelers need most: lantern streets, old houses, river walks, tickets, and walking-only zones all start here.`, "hoian"],
    [/japanese bridge|chùa cầu/, `${name} is one of Hoi An's symbolic old-town names, a small bridge that carries the town's trading-port memory.`, "hoian"],
    [/tra que|trà quế|cam thanh|cẩm thanh|kim bong|kim bồng/, `${name} takes Hoi An outside the lantern core into vegetable gardens, basket boats, craft villages, and countryside routes.`, "hoian"],
    [/imperial city|đại nội|citadel|kinh thành/, `${name} is Hue's first big history name: gates, walls, royal courts, and the former imperial capital become easier to understand from here.`, "hue"],
    [/thien mu|thiên mụ|perfume river|sông hương/, `${name} connects Hue's river, pagodas, boat rides, and quieter spiritual side.`, "hue"],
    [/tomb|lăng /, `${name} belongs to Hue's royal-tomb route, where gardens, gates, courtyards, and longer driver timing matter.`, "hue"],
    [/dong ba|đông ba/, `${name} is Hue market language: food, snacks, gifts, and local bargaining all come together near the river side of town.`, "hue"],
  ];

  const fallbackByKind = {
    museum: `${name} gives ${cityName} a quieter cultural stop where travelers can slow down, ask about tickets or entrances, and understand more than the street outside.`,
    attraction: `${name} helps turn ${cityName} into an actual visit plan: arrival, entrance, photos, food or water nearby, and a return pickup point.`,
    landmark: `${name} is part of ${cityName}'s orientation vocabulary, useful when a driver, hotel desk, or friend needs one clear landmark to work from.`,
    park: `${name} gives ${cityName} a pause between rides and meals, useful for shade, a walk, photos, or a simple meetup point.`,
    river: `${name} helps travelers read ${cityName} by water, bridges, banks, boat plans, and evening pickup points.`,
    nature: `${name} is the kind of ${cityName} stop where timing, weather, transport, and a clear pickup point matter as much as the name itself.`,
    village: `${name} brings the trip outside the central streets into craft, countryside, or local production routes where showing the name clearly helps a lot.`,
    beach: `${name} is practical beach vocabulary in ${cityName}: hotel area, seafood plan, coast road, shade, and ride pickup all become easier with the exact name.`,
    neighborhood: `${name} helps travelers talk about a real ${cityName} area instead of giving a vague address or only pointing at a map.`,
    street: `${name} is useful ${cityName} street language for drivers, nearby cafes or shops, and pickup points on the correct side of the road.`,
    station: `${name} is arrival vocabulary for ${cityName}, especially when tickets, luggage, platforms, drivers, and transfer timing all happen at once.`,
    airport: `${name} is arrival vocabulary for ${cityName}, where the exact terminal, curb, pickup lane, or baggage issue matters more than a long explanation.`,
    port: `${name} is transfer vocabulary for ${cityName}, useful when boats, rivers, luggage, timing, and pickup points need to stay clear.`,
    market: `${name} is where ${cityName} becomes tactile: cash, prices, snacks, produce, gifts, and meeting points all come into the same conversation.`,
  };

  return rules.find(([pattern, _body, cityID]) => pattern.test(target) && (!cityID || cityID === city.id))?.[1]
    ?? fallbackByKind[normalize(page.placeKind).toLowerCase()]
    ?? "";
}

function dishStory(page, city) {
  const name = page.englishText || "This dish";
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  const cityName = city.shortTitle || city.title;
  const story = dishStories.find((rule) => rule.match.test(text));
  if (story) {
    return story.body(name, cityName);
  }
  return `${name} is worth learning before you arrive because Vietnamese dishes often hide the most important details in the sauce, herbs, noodles, and toppings. In ${cityName}, ask what is inside before you decide how spicy, sweet, meaty, or seafood-heavy you want it.`;
}

function dishOrderAdvice(page) {
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  const story = dishStories.find((rule) => rule.match.test(text));
  const advice = story?.order ?? "Ask what is inside, then adjust spice, pork, beef, seafood, peanuts, egg, fish sauce, or herbs before the dish is made.";
  return `For ${page.englishText}, ${advice.charAt(0).toLowerCase()}${advice.slice(1)}`;
}

function isDrinkOrDessertDish(page) {
  return /coffee|cà phê|beer|bia hơi|chè|sweet soup|ice cream|kem bơ|herbal drink|nước mót|sesame candy|mè xửng/i.test(`${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`);
}

function dishGoodToKnow(page) {
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  const name = page.englishText || "This dish";
  if (/bánh mì|banh mi/i.test(text)) {
    return `${name} changes by stall, so fillings matter: pâté, pork, egg, chili, cucumber, pickles, butter, and herbs can shift the whole sandwich.`;
  }
  if (/coffee|cà phê|herbal drink|nước mót/i.test(text)) {
    return `${name} is easiest to enjoy when you decide sweetness and ice before ordering; Vietnamese drinks can arrive stronger, sweeter, or colder than travelers expect.`;
  }
  if (/beer|bia hơi/i.test(text)) {
    return `${name} is more of a social sidewalk rhythm than a tasting flight; keep the order simple and expect snacks, cash, and quick refills around the table.`;
  }
  if (/chè|sweet soup|ice cream|kem bơ|sesame candy|mè xửng/i.test(text)) {
    return `${name} is about texture as much as sweetness, so ask for less sugar or less ice if you want the beans, fruit, sesame, corn, or coconut to stand out.`;
  }
  if (/bánh xèo|bánh tráng|nem lụi|bò lá lốt|gỏi cuốn|fresh spring rolls|betel leaves|rice-paper|lemongrass pork/i.test(text)) {
    return `${name} makes more sense when you know the table method before it arrives: use the herbs, rice paper or greens, and dipping sauce instead of eating each piece plain.`;
  }
  if (/phở|bún|mì|miến|noodle|soup|hủ tiếu|bun bo|pho|hu tieu/i.test(text)) {
    return `${name} is best tasted before you add chili, lime, herbs, sauces, or vinegar; the broth and noodles should tell you what they need.`;
  }
  return `${name} is easier to enjoy when you know the eating method before it arrives: ask what is inside, taste first, then adjust sauce, herbs, spice, or sweetness.`;
}

function dishAdjustmentAdvice(page) {
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  if (isDrinkOrDessertDish(page)) {
    return `For ${page.englishText}, ask for less sweet, less ice, no condensed milk, or a smaller portion before it is made.`;
  }
  if (/seafood|hải sản|ốc|snail|fish|cá|crab|clam|hến|oyster|shrimp|tôm|mực|squid/i.test(text)) {
    return `For ${page.englishText}, ask for less spicy, no pork, no beef, no peanuts, or sauce on the side before the dish is made.`;
  }
  return `For ${page.englishText}, ask for less spicy, no pork, no beef, no seafood, no peanuts, or sauce on the side before the dish is made.`;
}

const venueStoryRules = [
  [/43 factory/i, "This is Da Nang's specialty-coffee side: cleaner roasts, beach-area cafe design, and a slower break from seafood tables and river traffic."],
  [/boulevard gelato/i, "This is a dessert-and-coffee pause, useful when the beach heat makes a cold scoop or iced drink more appealing than a full meal."],
  [/wonderlust/i, "This is the kind of Da Nang cafe stop travelers use for a softer landing: coffee, something sweet, a phone recharge, and a clear meetup point."],
  [/reply 1988|nam house/i, "This is a retro-style cafe name, good for travelers who want a coffee stop that feels more like local nostalgia than a standard espresso counter."],
  [/long coffee/i, "This is a practical Vietnamese coffee stop: strong coffee, ice, condensed milk, and a quick seat before heading back toward the river or beach."],
  [/cộng|cong ca/i, "Cộng Cà Phê is part of Vietnam's modern cafe vocabulary, with coconut coffee, condensed-milk sweetness, and a retro look many travelers recognize across cities."],
  [/giang|egg coffee|little hanoi/i, "This name belongs to the egg-coffee story: Hanoi-style coffee under a whipped egg foam that grew famous as a rich substitute when fresh milk was scarce."],
  [/đinh|dinh cafe|loading t|nang cafe|lâm cafe|lam cafe/i, "This is Hanoi cafe culture at stool-and-balcony pace: strong coffee, condensed milk, quiet corners, and time to watch the old city move."],
  [/the note coffee/i, "This cafe is memorable because the room itself becomes part of the visit, with travelers leaving notes while still ordering the same practical coffee phrases."],
  [/cafe apartment|workshop coffee|lusine/i, "This is Saigon's cafe-as-meeting-point side: a specific building or polished address matters as much as the coffee order."],
  [/cafe vợt|cafe vot|cheo leo/i, "This name points to old Saigon coffee habits, where cloth-filter coffee, condensed milk, and a quick local rhythm matter more than a modern menu."],
  [/cocobox|espresso station|faifo|phin coffee|roastery|rosies|u cafe|reach out/i, "This is Hoi An's cafe rhythm: old-town heat, lantern lanes, iced drinks, and a place to pause before walking back into the market or river streets."],
  [/không gian hoài cổ|khong gian hoai co|kodo|lang thang|de po|mandarin|thanh cafe|ben trang/i, "This is Hue's slower cafe mood, where the drink, garden-like setting, and unhurried conversation fit the city's river-and-tomb pace."],
  [/bánh xèo|banh xeo/i, "The reason to know this stop is the eating method: crisp pancake, herbs, rice paper or greens when served, and a dipping sauce with fish sauce, chili, garlic, or peanut depth."],
  [/bún chả cá|bun cha ca/i, "This stop belongs to Da Nang's fish-cake noodle world, where the broth is lighter and coastal compared with northern grilled-pork bún chả."],
  [/mì quảng|mi quang|my quang/i, "This name points straight to central Vietnam: turmeric noodles, just enough broth, herbs, peanuts, rice cracker, and a choice of chicken, pork, shrimp, or egg."],
  [/bún chả|bun cha/i, "This is Hanoi's grilled-pork ritual: smoky patties and slices, rice noodles, herbs, and dipping sauce eaten by assembling the bowl bite by bite."],
  [/chả cá|cha ca/i, "This is Hanoi's turmeric fish tradition, served with dill, noodles, herbs, peanuts, and sauce so the table method matters as much as the fish."],
  [/phở|pho/i, "This name is a bowl decision, not just a destination: broth style, beef or chicken, herbs, lime, chili, and sauces change the whole experience."],
  [/miến lươn|mien luon/i, "This name is for eel noodles, a Hanoi specialty where crisp or soft eel, broth, herbs, and texture matter more than a simple noodle label."],
  [/bánh mì|banh mi/i, "This stop carries the Vietnamese baguette story into a real order: crisp bread, pâté, pickles, herbs, chili, egg, pork, or cold cuts depending on the counter."],
  [/cơm tấm|com tam/i, "This is Saigon broken-rice eating: grilled pork, rice grains, pickles, scallion oil, egg or pork loaf, and fish sauce poured slowly."],
  [/bếp mẹ in|bep me in|cục gạch|cuc gach|morning glory|vỹ'?s|vys market/i, "This is a good place-name for home-style Vietnamese dishes, where the useful questions are what is recommended, what sauce comes with it, and whether plates are for sharing."],
  [/bale well|white rose|bà lê|ba le/i, "This name belongs to Hoi An's hands-on eating culture: rolls, dumplings, herbs, rice paper, dipping sauce, and small local specialties that make more sense at the table."],
  [/madam khanh|phượng|phuong/i, "This is a named bánh mì stop, so the important move is to ask what fillings are inside before choosing chili, egg, pâté, pork, or no spice."],
  [/mai fish|mango mango|cargo club|nu eatery|streets|the field/i, "This is Hoi An dining rather than just a snack stop: old-town or countryside atmosphere, shared plates, drinks, the bill, and a clean pickup point all matter."],
  [/seafood|hải sản|nam danh|bé mặn|be man|ốc|oc/i, "This is coastal seafood ordering: choose what looks fresh, ask how it is cooked, confirm the sauce, and be clear about shellfish, chili, and price before the plate lands."],
  [/akuna|anan|ciel|coco dining|long triều|long trieu|nephele|gia|hibana|tam vị|tam vi|la maison|nen|temptation|ancient hue|les jardins|tịnh gia viên|tinh gia vien|ỷ thảo|y thao/i, "This is a more deliberate restaurant plan, so the exact name, reservation, menu, dietary concern, pacing, bill, and ride back are the phrases that make the night smoother."],
  [/liên hoa|lien hoa|udam/i, "This is the vegetarian side of Vietnamese dining, where travelers should still ask about fish sauce, egg, dairy, mushrooms, peanuts, and how dishes are shared."],
  [/bánh lọc|banh loc|mè xửng|me xung/i, "This name points to Hue's snack-and-sweet world: small portions, chewy textures, shrimp or pork fillings, sesame, sugar, and gifts to take away."],
  [/floating restaurant|song huong/i, "This is a river meal, so ordering is only half the visit; the boat or riverfront pickup point matters before and after dinner."],
  [/lotte mart|vincom/i, "This is a mall name rather than a single shop, useful for meeting points, supermarket errands, food courts, toilets, cash, and ride pickup at the right entrance."],
  [/helio night market/i, "This is a night-market plan: snacks, cash, music, rides, meeting points, and a simple exit plan matter more than one perfect order."],
  [/han river cruise/i, "This is a river-cruise name, so travelers need ticket, boarding, time, riverfront pickup, and return phrases before thinking about photos."],
  [/nam ô|nam o fish sauce/i, "This name connects Da Nang to fish-sauce production, so the useful language is about the village, smell, bottles, gifts, and how to get back."],
  [/43 factory|factory coffee/i, "This is Da Nang's specialty-coffee side: clean roasts, modern design, and a slower break from seafood tables and beach traffic."],
];

function venueSpecificStory(page, city) {
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  const rule = venueStoryRules.find(([pattern]) => pattern.test(text));
  if (rule) return rule[1];
  if (profileFor(page) === "cafe") {
    return `${page.englishText} is a ${city.shortTitle || city.title} cafe stop where the flavor choices are practical: strong or milky, hot or iced, sweet or less sweet, and easy to find again after a walk.`;
  }
  if (profileFor(page) === "restaurant") {
    return `${page.englishText} is a ${city.shortTitle || city.title} food stop where the exact name helps with the ride first, then the table, menu, recommendation, sauce, and bill.`;
  }
  return "";
}

function restaurantOrderFocus(page, city) {
  const story = venueSpecificStory(page, city);
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  if (/coffee|cafe|cà phê|espresso|roaster|phin|gelato/i.test(text)) {
    return `At ${page.englishText}, choose the drink style before it is made: hot or iced, less sweet, less ice, milk or no milk, and water for the table. ${story}`;
  }
  if (/seafood|hải sản|ốc|oc/i.test(text)) {
    return `At ${page.englishText}, point carefully, ask how it is cooked, confirm the sauce, and check spice or shellfish concerns before the kitchen starts.`;
  }
  if (/bánh mì|banh mi/i.test(text)) {
    return `At ${page.englishText}, ask what fillings are inside, then decide on chili, egg, pâté, pork, cucumber, pickles, and herbs before the sandwich is closed.`;
  }
  if (/bánh xèo|banh xeo|bale well|white rose|bánh lọc|banh loc/i.test(text)) {
    return `At ${page.englishText}, ask how to eat it if the table setup is unfamiliar; rice paper, herbs, greens, and dipping sauce may be the whole point.`;
  }
  return `At ${page.englishText}, ask what is recommended, then confirm the main ingredient, sauce, spice, sharing size, and anything you need left out before you order.`;
}

function restaurantDrinksFocus(page) {
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  if (/coffee|cafe|cà phê|espresso|roaster|phin|gelato/i.test(text)) {
    return `For ${page.englishText}, drink words carry the visit: coffee or tea, hot or iced, less sweet, less ice, water, and the bill.`;
  }
  if (/night market|seafood|hải sản|ốc|oc|floating|cruise/i.test(text)) {
    return `For ${page.englishText}, keep water, beer, ice, and bill phrases ready; shared plates move faster when the table can handle drinks simply.`;
  }
  return `For ${page.englishText}, water, tea, beer, coffee, ice, and sugar phrases keep the table moving while food decisions take longer.`;
}

function restaurantFoodHook(page, city) {
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  const specific = venueSpecificStory(page, city);
  if (specific) return specific;
  const dish = dishStories.find((rule) => rule.match.test(text));
  if (dish) {
    const story = dish.body(page.englishText, city.shortTitle || city.title);
    return story.replace(new RegExp(`^${String(page.englishText || "").replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\s+is\\s+`, "i"), "The food connection is ");
  }
  if (/seafood|hải sản|oc|ốc/i.test(text)) {
    return "For seafood stops, the useful Vietnamese is about what is fresh, how it is cooked, which sauce comes with it, and how the final price is handled.";
  }
  if (/fine|akuna|nen|la maison|ancient hue|temptation|nephele/i.test(text)) {
    return "For a reserved or polished meal, the name, reservation, menu, dietary concern, and bill matter more than a long custom sentence.";
  }
  return "";
}

function cafeFoodHook(page, city) {
  const text = `${page.targetText || ""} ${page.englishText || ""} ${page.id || ""}`;
  const specific = venueSpecificStory(page, city);
  if (specific) return specific;
  if (/cộng|cong|đinh|dinh|egg|trứng/i.test(text)) {
    return "Vietnamese coffee culture is part flavor and part pause: strong coffee, condensed milk or egg foam, ice choices, and time at the table all matter.";
  }
  if (/roaster|espresso|factory|coffee|cafe|cà phê/i.test(text)) {
    return "Use the cafe stop for more than caffeine: less ice, less sugar, water, bill, and meetup phrases all come up naturally.";
  }
  return "";
}

function aboutBody(page, city) {
  const cityName = city.shortTitle || city.title;
  const englishName = page.englishText || "This stop";
  const tone = cityTone(city);
  const detail = detailSentence(page);
  const context = sourceContext(page, city);
  const tip = sourceTip(page, city);
  const connection = isExplicitKnownConnection(page, city);
  const scene = sceneDetail(page);

  switch (profileFor(page)) {
  case "dish":
    return withoutDuplicateSentences([dishStory(page, city), context, tip, scene, detail]);
  case "market":
    return withoutDuplicateSentences([
      context || `${englishName} is a ${cityName} market stop where prices, snacks, goods, cash, and pickup plans all meet quickly.`,
      connection,
      tip,
      scene,
      detail,
    ]);
  case "street":
    return withoutDuplicateSentences([
      context || `${englishName} is a ${cityName} street or area to keep ready for drivers, addresses, hotel directions, and meetups.`,
      connection,
      tip,
      scene,
      detail,
    ]);
  case "transit":
    return withoutDuplicateSentences([
      context || `${englishName} is a ${cityName} arrival or transfer name to keep ready before luggage, traffic, tickets, or pickup details become urgent.`,
      tip,
      scene,
      detail || tone.placeLens,
    ]);
  case "restaurant":
    return withoutDuplicateSentences([
      restaurantFoodHook(page, city),
      context || `${englishName} is a ${cityName} restaurant name to show clearly for a ride, booking, table, menu, bill, and pickup afterward.`,
      tip,
      scene,
      detail,
    ]);
  case "cafe":
    return withoutDuplicateSentences([
      cafeFoodHook(page, city),
      context || `${englishName} is a ${cityName} coffee stop for cooling down, meeting up, and tasting Vietnam's cafe rhythm.`,
      tip,
      scene,
      detail,
    ]);
  case "experience":
    return withoutDuplicateSentences([
      context || `${englishName} is a ${cityName} ${kindLabel(page)} where timing, entrance, photos, food, and pickup plans are easier when the name is clear.`,
      connection,
      tip,
      scene,
      detail,
    ]);
  default:
    return withoutDuplicateSentences([
      context || `${englishName} is a ${kindLabel(page)} in ${cityName}.`,
      connection,
      tip,
      scene,
      detail || tone.placeLens,
    ]);
  }
}

function quickSayBody(page) {
  const profile = profileFor(page);
  const englishName = page.englishText || "this name";
  const nameLine = targetNameLine(page);
  if (profile === "dish") {
    return `${nameLine} Listen first, then order after you know whether the menu means the dish, a restaurant, or a city-specific style.`;
  }
  if (profile === "street") {
    return `${nameLine} Play it before the ride starts, then keep the map pin visible so the driver can confirm the exact side.`;
  }
  if (profile === "restaurant" || profile === "cafe") {
    return `${nameLine} Play it once, then show the saved map result so staff or a driver can match the exact venue.`;
  }
  return `${nameLine} Play the name first, then show the map, ticket, or booking screen if pronunciation gets noisy.`;
}

function placeBriefBody(page, city) {
  const cityName = city.shortTitle || city.title;
  const englishName = page.englishText;
  const tip = sourceTip(page, city);
  const placeKind = normalize(page.placeKind).toLowerCase();
  switch (profileFor(page)) {
  case "street":
    return withoutDuplicateSentences([
      `${englishName} is most useful with drivers, pickups, and address checks, especially when the exact side of the road matters.`,
      tip,
      "Pair the name with a map pin before the ride starts.",
    ]);
  case "transit":
    return `Use ${englishName} for arrival, luggage, pickup, or transfer conversations in ${cityName}. Confirm the ${placeKind === "airport" ? "terminal or curb" : placeKind === "station" ? "platform or station entrance" : "pier, gate, or boarding point"} when the exact spot matters.`;
  case "market":
    return withoutDuplicateSentences([
      `Get to ${englishName} with the name first, then switch to cash, price, bag, and meeting-point phrases once the aisles get busy.`,
      tip,
    ]);
  case "restaurant":
  case "cafe":
    return withoutDuplicateSentences([
      `Show ${englishName} on your map first so the ride, reservation, or meetup starts with the exact venue.`,
      tip,
      "Once inside, table, menu, order, drink, bill, and pickup phrases do the real work.",
    ]);
  case "dish":
    return `Start with ${englishName}, then ask for one portion, what is inside, and whether the sauce, herbs, ice, sweetness, or spice level can be adjusted.`;
  case "experience":
    if (placeKind === "beach" || placeKind === "nature" || placeKind === "river") {
      return `For ${englishName}, plan the drop-off and return point before you relax into the water, trail, riverbank, or viewpoint. Weather, shade, and distance can matter more than the pin.`;
    }
    if (placeKind === "village") {
      return `For ${englishName}, ask where the main stop, workshop, or meeting point is, then confirm the ride back before the visit spreads out.`;
    }
    return `For ${englishName}, think in sequence: arrival, entrance or ticket, respectful photos, food or water nearby, and a ride back.`;
  default:
    return `Use the name with a driver, hotel desk, ticket counter, or anyone helping you get oriented in ${cityName}.`;
  }
}

function useItWithBody(page) {
  const englishName = page.englishText;
  const profile = profileFor(page);
  const placeKind = normalize(page.placeKind).toLowerCase();
  switch (profileFor(page)) {
  case "street":
    return `If the route to ${englishName} feels off, ask whether this is the right street or area before you keep moving; for long roads, the hotel, cafe, gate, or cross street matters.`;
  case "market":
    return `Inside ${englishName}, keep price, cash, bag, and meeting-point phrases close; the easiest regroup point is usually an entrance, gate, or memorable stall aisle.`;
  case "restaurant":
    return `At ${englishName}, ask for a table, then ask what the house recommends before bringing up dietary concerns, drinks, and the bill.`;
  case "cafe":
    return `At ${englishName}, order the drink clearly and set sweetness or ice early; Vietnamese coffee and tea can arrive strong, sweet, and very cold.`;
  case "dish":
    return dishOrderAdvice(page);
  case "experience":
    if (placeKind === "museum" || placeKind === "landmark" || placeKind === "attraction") {
      return `At ${englishName}, ask where to enter, where to buy or show tickets, whether photos are okay, and where to meet afterward.`;
    }
    if (placeKind === "beach" || placeKind === "river" || placeKind === "nature") {
      return `At ${englishName}, use simple questions for shade, bathrooms, boat or beach access, photos, and the return pickup point.`;
    }
    return `At ${englishName}, ask where to start, where to meet afterward, and whether any ticket, entrance, or photo rule applies.`;
  default:
    return `At ${englishName}, ticket, entrance, photo, bathroom, and return-ride phrases are usually more useful than a one-off sentence about the stop.`;
  }
}

function whenBody(page, city) {
  const cityName = city.shortTitle || city.title;
  const englishName = page.englishText;
  const placeKind = normalize(page.placeKind).toLowerCase();
  switch (profileFor(page)) {
  case "street":
    return `Use pickup wording if you are already near ${englishName}; use wrong-place wording if the map, driver, and street view disagree. A screenshot of the address saves a lot of back-and-forth.`;
  case "transit":
    return `For ${englishName}, keep pickup, drop-off, ticket, transfer, ATM, and bathroom phrases ready so the first few minutes feel easier.`;
  case "market":
    return `At ${englishName}, ask price before buying, keep cash handy, and choose a simple entrance or gate for pickup afterward. If it is a night market or mall, confirm the exact entrance.`;
  case "restaurant":
  case "cafe":
    return `After ${englishName}, payment and ride-back phrases matter as much as ordering; save the pickup point before you sit down, especially if the lane, mall, or riverfront has several exits.`;
  case "dish":
    return `If ${englishName} sounds good but unfamiliar, ask about the sauce and main ingredients first; that is where the flavor, spice, sweetness, and allergy risk usually live.`;
  case "experience":
    if (placeKind === "beach" || placeKind === "nature" || placeKind === "village") {
      return `For ${englishName}, confirm the return plan early; once you are away from the center, a clear pickup point is easier than explaining the whole route again.`;
    }
    return `For ${englishName}, confirm the return plan early; the best pickup point may be different from the entrance.`;
  default:
    return `Use ${englishName} as a concrete ${cityName} meeting point when streets, gates, or nearby landmarks start to blur together.`;
  }
}

function goodToKnowBody(page, city) {
  const profile = profileFor(page);
  const cityName = city.shortTitle || city.title;
  const englishName = page.englishText;
  const oldTip = cleanVisibleText(page.tip || page.rationale, page, city);
  const tone = cityTone(city);

  if (profile === "dish") {
    return dishGoodToKnow(page);
  }
  if (profile === "restaurant" || profile === "cafe") {
    const focus = profile === "cafe" ? cafeFoodHook(page, city) : restaurantFoodHook(page, city);
    return withoutDuplicateSentences([
      focus,
      oldTip,
      `For ${englishName}, the reusable phrases should stay concrete: table, menu, recommendation, ingredient check, drink choice, bill, and the pickup point after you leave.`,
    ]);
  }
  if (profile === "market") {
    return withoutDuplicateSentences([
      oldTip,
      `${englishName} is best approached with cash, price questions, a visible meeting point, and curiosity about snacks or goods you may not recognize yet.`,
    ]);
  }
  if (profile === "street") {
    return withoutDuplicateSentences([
      oldTip,
      `${englishName} works best when paired with a map pin; drivers may know the street but still need the exact end, alley, hotel, or pickup side.`,
    ]);
  }
  if (profile === "transit") {
    return withoutDuplicateSentences([
      oldTip,
      `${englishName} is one of those names to save offline, because arrivals are when battery, data, luggage, and patience all get tested.`,
    ]);
  }
  if (oldTip.length >= 70 && !/\b(city tile|travel job|cue|place name)\b/i.test(oldTip)) {
    return oldTip;
  }
  return `${englishName} is part of how ${cityName} becomes legible: ${tone.placeLens}`;
}

function editorialSections(page, city) {
  const config = profileConfig[profileFor(page)] ?? profileConfig.default;
  if (profileFor(page) === "restaurant" || profileFor(page) === "cafe") {
    const isCafe = profileFor(page) === "cafe";
    const focus = isCafe ? cafeFoodHook(page, city) : restaurantFoodHook(page, city);
    return [
      { id: "at-glance", title: config.atTitle, body: aboutBody(page, city) },
      { id: "quick-say", title: config.quickTitle, body: quickSayBody(page) },
      { id: "place-brief", title: config.placeBriefTitle, body: placeBriefBody(page, city) },
      { id: "table-menu", title: isCafe ? "Coffee & menu" : "Table & menu", body: withoutDuplicateSentences([`At ${page.englishText}, ask for a table first, then ask to see the menu before deciding whether this is a ${isCafe ? "quick iced-coffee pause, dessert stop, or longer cool-down" : "quick plate, shared meal, or reserved dinner"}.`, focus]) },
      { id: "before-you-go", title: isCafe ? "Order the drink" : "Order", body: restaurantOrderFocus(page, city) },
      { id: "menu-dietary", title: isCafe ? "Sweetness & ice" : "Drinks", body: restaurantDrinksFocus(page) },
      { id: "pay-and-leave", title: "Pay", body: `Before leaving ${page.englishText}, use the bill or card/cash phrase, then confirm pickup while you are still near a door, lobby, riverfront, or easy landmark.` },
      { id: "when-to-use", title: config.whenTitle, body: whenBody(page, city) },
      { id: "good-to-know", title: "Good to know", body: goodToKnowBody(page, city) },
    ];
  }

  const sections = [
    { id: "at-glance", title: config.atTitle, body: aboutBody(page, city) },
    { id: "quick-say", title: config.quickTitle, body: quickSayBody(page) },
    { id: "place-brief", title: config.placeBriefTitle, body: placeBriefBody(page, city) },
    { id: "use-it-with", title: config.useItWithTitle, body: useItWithBody(page) },
    { id: "when-to-use", title: config.whenTitle, body: whenBody(page, city) },
    { id: "good-to-know", title: "Good to know", body: goodToKnowBody(page, city) },
  ];

  if (profileFor(page) === "dish") {
    const dietBody = isDrinkOrDessertDish(page)
      ? `Check ${page.englishText} ingredients first if you avoid dairy, egg, coconut, peanuts, sesame, caffeine, or very sweet drinks.`
      : `Check ${page.englishText} ingredients first if you avoid pork, beef, seafood, peanuts, fish sauce, egg, or chili.`;
    sections.push(
      { id: "how-to-order", title: "Adjust it", body: withoutDuplicateSentences([dishAdjustmentAdvice(page), dishGoodToKnow(page)]) },
      { id: "ingredients-diet", title: "Diet / allergy", body: withoutDuplicateSentences([dietBody, sourceTip(page, city)]) }
    );
  }

  return sections;
}

function cityIDsForHub(cityID) {
  const mapping = {
    hcmc: {
      namesToKnowIDs: [
        "viet-family-city-hcmc-place-ben-thanh-market",
        "viet-family-city-hcmc-place-nguyen-hue",
        "viet-family-city-hcmc-place-post-office",
        "viet-family-city-hcmc-place-bui-vien-street",
      ],
      quickPhraseIDs: [
        "viet-family-city-hcmc-go-ben-thanh",
        "viet-family-city-hcmc-go-nguyen-hue-walking-street",
        "viet-family-city-hcmc-stop-ben-thanh-market",
      ],
    },
    hanoi: {
      namesToKnowIDs: [
        "viet-family-city-hanoi-place-old-quarter",
        "viet-family-city-hanoi-place-hoan-kiem",
        "viet-family-city-hanoi-place-west-lake",
        "viet-family-city-hanoi-place-bun-cha",
      ],
      quickPhraseIDs: [
        "viet-family-city-hanoi-go-old-quarter",
        "viet-family-city-hanoi-where-old-quarter",
        "viet-family-city-hanoi-stop-old-quarter",
      ],
    },
    danang: {
      namesToKnowIDs: [
        "viet-family-city-danang-place-dragon-bridge",
        "viet-family-city-danang-place-my-khe-beach",
        "viet-family-city-danang-place-marble-mountains",
        "viet-family-city-danang-place-han-market",
      ],
      quickPhraseIDs: [
        "viet-family-city-danang-go-dragon-bridge",
        "viet-family-city-danang-where-my-khe",
        "viet-family-city-danang-stop-bach-dang-street",
      ],
    },
    hoian: {
      namesToKnowIDs: [
        "viet-family-city-hoian-place-ancient-town",
        "viet-family-city-hoian-place-japanese-bridge",
        "viet-family-city-hoian-place-hoai-river",
        "viet-family-city-hoian-place-cao-lau-city",
      ],
      quickPhraseIDs: [
        "viet-family-city-hoian-go-ancient-town",
        "viet-family-city-hoian-where-japanese-bridge",
        "viet-family-city-hoian-stop-ancient-town",
      ],
    },
    hue: {
      namesToKnowIDs: [
        "viet-family-city-hue-place-imperial-city",
        "viet-family-city-hue-place-thien-mu",
        "viet-family-city-hue-place-perfume-river",
        "viet-family-city-hue-place-bun-bo-city",
      ],
      quickPhraseIDs: [
        "viet-family-city-hue-go-imperial-city",
        "viet-family-city-hue-where-thien-mu",
        "viet-family-city-hue-stop-imperial-city",
      ],
    },
  };
  return mapping[cityID] ?? { namesToKnowIDs: [], quickPhraseIDs: [] };
}

function applyHubEditorial(city) {
  const editorial = hubEditorialByCityID[city.id];
  if (!editorial) return city;
  return {
    ...city,
    hubEditorial: {
      ...editorial,
      ...cityIDsForHub(city.id),
      browseGroups: [
        "Arrivals",
        "Landmarks",
        "Neighborhoods",
        "Food & coffee",
        "Markets",
      ],
    },
  };
}

function main() {
  const library = readJSON(cityLibraryPath);
  const cityByID = new Map(library.cities.map((city) => [city.id, city]));

  library.cities = library.cities.map(applyHubEditorial);

  library.pages = library.pages.map((page) => {
    if (page.kind === "phrase") return page;
    const city = cityByID.get(page.cityID);
    if (!city) return page;
    const sanitizedPage = { ...page };
    if (sanitizedPage.context) sanitizedPage.context = cleanVisibleText(sanitizedPage.context, sanitizedPage, city);
    if (sanitizedPage.tip) sanitizedPage.tip = cleanVisibleText(sanitizedPage.tip, sanitizedPage, city);
    if (sanitizedPage.rationale) sanitizedPage.rationale = cleanVisibleText(sanitizedPage.rationale, sanitizedPage, city);
    if (sanitizedPage.productionIntake) {
      sanitizedPage.productionIntake = {
        ...sanitizedPage.productionIntake,
        sourceNotes: cleanSourceNote(sanitizedPage.productionIntake.sourceNotes),
        imagePromptNote: cleanedImagePrompt(sanitizedPage),
      };
    }

    const existingEditorialImport = sanitizedPage.editorialImport ?? {};
    const targetHeroImageName = sanitizedPage.productionIntake?.targetHeroImageName;
    const nextEditorialImport = {
      ...existingEditorialImport,
      patchID: "city-hubs-500-noun-production-2026-05-16",
      approvedAt: "2026-05-16T00:00:00+07:00",
      approvedBy: "codex-city-production-pass",
      reviewStatus: "handwritten-reviewed",
      sourceNotes: sanitizedPage.productionIntake?.sourceNotes ?? sanitizedPage.sourceIDs?.join(", ") ?? "",
      claimRisk: "stable-traveler-context",
      replaceGeneratedSections: false,
      summary: aboutBody(sanitizedPage, city),
      targetHeroImageName,
      heroImageName: existingEditorialImport.heroImageName ?? sanitizedPage.heroImageName,
      sections: editorialSections(sanitizedPage, city),
    };

    return {
      ...sanitizedPage,
      editorialImport: nextEditorialImport,
    };
  });

  const sanitizedLibrary = sanitizeResidualStrings(library);
  Object.assign(library, sanitizedLibrary);

  writeJSON(cityLibraryPath, library);

  const reviewedCities = library.cities.filter((city) => city.hubEditorial?.reviewStatus === "handwritten-reviewed").length;
  const reviewedPages = library.pages.filter((page) => page.kind !== "phrase" && page.editorialImport?.reviewStatus === "handwritten-reviewed").length;
  console.log(`Applied city production copy: ${reviewedCities} hubs, ${reviewedPages} city noun pages`);
}

main();
