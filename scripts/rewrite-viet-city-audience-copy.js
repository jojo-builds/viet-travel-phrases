#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..");
const sourcePath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const handwrittenCopyDir = path.join(repoRoot, "content-draft", "viet", "city-library", "handwritten-copy");

const REVIEW_ID = "viet-city-reason-to-go-copy-2026-05-18";
let placeByID = new Map();

const cityProfiles = {
  danang: {
    name: "Da Nang",
    opening:
      "Da Nang comes into focus through river bridges, beach roads, seafood, markets, mountain day trips, and modern nights along the Han River.",
    subtitle: "River bridges, beach roads, seafood, markets, mountain day trips, and modern coastal nights.",
    texture: "beaches, bridges, markets, mountain roads, seafood stops, and central-Vietnam day trips",
    trip: "a Da Nang day can move from the airport to the beach, then into river lights, seafood, markets, and mountain trips without feeling like five separate plans",
    voice: "coastal, modern, scenic, and easy to move through",
  },
  hanoi: {
    name: "Hanoi",
    opening:
      "Hanoi comes into focus through shaded lakes, old lanes, temple courtyards, coffee shops, northern dishes, and streets that carry the city one turn at a time.",
    subtitle: "Old Quarter lanes, shaded lakes, temple courtyards, northern dishes, and coffee stops.",
    texture: "old lanes, shaded lakes, temple courtyards, coffee shops, food streets, and neighborhood edges",
    trip: "a Hanoi day rewards travelers who can recognize the lake, the old quarter, the street, and the dish before the city becomes a maze of similar names",
    voice: "layered, literary, old-city, food-rich, and calm under the traffic",
  },
  hcmc: {
    name: "Saigon",
    opening:
      "Saigon comes alive through airport arrival, District 1, coffee, markets, river lights, old civic buildings, and late food in the same long day.",
    subtitle: "District 1, markets, coffee, river lights, old civic buildings, and late food.",
    texture: "District 1 movement, market bargaining, coffee counters, old civic buildings, river lights, and late-night food",
    trip: "a Saigon day can start with a quick airport ride and end with market lights, coffee, street food, and a city that keeps moving",
    voice: "fast, social, commercial, bright, and full of first-day energy",
  },
  hoian: {
    name: "Hoi An",
    opening:
      "Hoi An comes into focus through yellow walls, lantern streets, river boats, old houses, tailor stops, markets, beaches, and villages beyond the Ancient Town.",
    subtitle: "Lantern streets, river boats, old houses, tailor stops, markets, beaches, and villages.",
    texture: "lantern streets, yellow walls, old houses, river boats, markets, beaches, tailor stops, and village routes",
    trip: "a Hoi An day is small enough to wander but rich enough that the old town, river, bridge, market, beach, and villages each deserve their own name",
    voice: "romantic, walkable, craft-heavy, river-led, and village-close",
  },
  hue: {
    name: "Hue",
    opening:
      "Hue opens as Vietnam's old royal capital with living rituals: imperial gates, river pagodas, tomb roads, garden houses, markets, incense, and deeply local food.",
    subtitle: "Imperial gates, river pagodas, tomb roads, garden houses, markets, incense, and local food.",
    texture: "imperial gates, royal tombs, pagodas, garden houses, markets, incense, the Perfume River, and central dishes",
    trip: "a Hue day makes more sense when the royal-city names, river stops, tomb routes, markets, and food traditions stop blurring together",
    voice: "historic, ritual, river-paced, imperial, and quietly sensory",
  },
};

const kindProfiles = {
  airport: {
    surface: "arrival",
    scene: "arrival doors, bags, pickup lanes, warm air, and the first ride toward the city",
    meaning: "the arrival threshold where bags, signs, and the first ride make Vietnam feel immediate",
    practical: "arrival, terminal, luggage, ticket, pickup, transfer, and drop-off phrases",
    texture: "arrival doors, city signs, warm air, first roads, waiting halls, and the first local name",
    belongs:
      "It is the moment the planned trip turns into real city movement: signs, sounds, bags, rides, and the first local name that has to feel familiar.",
  },
  station: {
    surface: "station",
    scene: "platforms, luggage, station gates, and the moment a city connects to the next part of the trip",
    meaning: "the handoff between travel days, city days, trains, buses, rides, and local names",
    practical: "arrival, platform, luggage, ticket, pickup, transfer, and drop-off phrases",
    texture: "station doors, route boards, waiting benches, city light, local signs, and onward roads",
    belongs:
      "It gives the trip a travel-day threshold, where city time, route time, station signs, and the next leg all meet in one named place.",
  },
  port: {
    surface: "port",
    scene: "boats, sea air, arrivals, and the edge between the city and the next crossing",
    meaning: "the trip turning toward islands, boats, ferries, and coastal travel",
    practical: "arrival, pier, luggage, ticket, pickup, transfer, and drop-off phrases",
    belongs:
      "It shows the city turning toward water, boats, islands, ferries, and the coastal routes that make Vietnam feel wider than one street plan.",
  },
  pier: {
    surface: "pier",
    scene: "boats, river or sea light, boarding points, and the small handoff before the next crossing",
    meaning: "the city opening onto water and the day changing pace",
    practical: "arrival, pier, luggage, ticket, pickup, transfer, and drop-off phrases",
    belongs:
      "It changes the pace of the day, moving the traveler from streets and markets into water, boat light, and a different rhythm of arrival.",
  },
  market: {
    surface: "market",
    scene: "stalls, food, bargaining, baskets, bags, and the city at its most immediate",
    meaning: "everyday shopping, snacks, gifts, bargaining, and local rhythm",
    practical: "market, cash, price, bag, meeting point, entrance, and pickup phrases",
    texture: "market aisles, produce colors, snack counters, bargaining rhythm, bags, and local shopping movement",
    belongs:
      "It puts everyday Vietnam in one vivid place: snacks, produce, bargaining, gifts, colors, smells, and the local rhythm of buying and eating.",
  },
  street: {
    surface: "street",
    scene: "a line through the city: cafes, signs, crossings, hotels, shops, and traffic all giving the neighborhood shape",
    meaning: "a named street scene of trees, shopfronts, crossings, cafes, and neighborhood movement",
    practical: "street, route, ride, meeting point, hotel, and cross-street phrases",
    texture: "street signs, shopfronts, scooters, crossings, cafe edges, and neighborhood movement",
    belongs:
      "It turns a broad city into something walkable: trees, signs, crossings, shops, hotels, and a street name the traveler can picture.",
  },
  neighborhood: {
    surface: "neighborhood",
    scene: "a pocket of the city with its own cafes, streets, hotels, shops, and evening rhythm",
    meaning: "the area identity behind cafes, streets, hotels, shops, and evening rhythm",
    practical: "street, route, ride, meeting point, hotel, and cross-street phrases",
    texture: "cafes, lanes, small shops, hotel edges, evening walks, and neighborhood identity",
    texture: "cafes, lanes, small shops, hotel edges, evening walks, and neighborhood identity",
    belongs:
      "It gives cafes, hotels, food streets, small shops, and evening walks a neighborhood identity the traveler can picture.",
  },
  restaurant: {
    surface: "restaurant",
    scene: "tables, menus, house dishes, drinks, staff movement, and the feeling of choosing where the meal happens",
    meaning: "local dining culture, house dishes, table rhythm, and the choice of where a meal happens",
    practical: "table, menu, order, drink, bill, payment, pickup, and recommendation phrases",
    texture: "tables, house dishes, menu details, staff rhythm, drinks, and evening meal energy",
    belongs:
      "It turns the city into a meal: house dishes, table rituals, drinks, shared plates, and the feeling of choosing where the night begins.",
  },
  cafe: {
    surface: "cafe",
    scene: "coffee, ice, milk, slow pauses, design details, and the softer rhythm between meals and sightseeing",
    meaning: "Vietnam's cafe culture and the slower rhythm between meals and sightseeing",
    practical: "coffee, tea, iced, sweet, table, menu, bill, and pickup phrases",
    texture: "coffee counters, iced glasses, street stools, design details, soft pauses, and cafe views",
    belongs:
      "It carries Vietnam's cafe culture: iced coffee, slow pauses, small rooms, street views, design details, and a softer rhythm between sights.",
  },
  dish: {
    surface: "dish",
    scene: "a bowl, plate, sauce, herbs, texture, steam, sweetness, spice, or crunch that makes the city taste specific",
    meaning: "local flavor, texture, herbs, sauce, steam, and the small meal rituals travelers remember",
    practical: "order, ingredient, sauce, spice, allergy, diet, sweet, and ice phrases",
    texture: "flavor, herbs, sauce, steam, texture, and small meal rituals",
    belongs:
      "It makes the city edible, turning flavor, texture, herbs, sauce, heat, sweetness, and local habit into something the traveler can imagine tasting.",
  },
  drink: {
    surface: "drink",
    scene: "ice, glass, sweetness, coffee or beer, and a pause in the city rhythm",
    meaning: "drink culture, street stools, cold glasses, local refreshment, and sidewalk pauses",
    practical: "ice, sweetness, glassware, cafe counters, street stools, price, and the pause between plans",
    texture: "iced glasses, cafe counters, street stools, local refreshment, sweetness, and city pauses",
    belongs:
      "It makes Vietnam's drink culture easy to imagine: iced coffee, cold glasses, small stools, sweetness, and the pause between the next walk and the next meal.",
  },
  dessert: {
    surface: "dessert",
    scene: "cups, coconut milk, jelly, shaved ice, sweetness, and color at a street dessert counter",
    meaning: "the sweet side of the city through cups, ice, fruit, jelly, coconut milk, and evening snack counters",
    practical: "cool bowls, toppings, coconut milk, color, sweetness, price, and dessert-counter details",
    texture: "dessert cups, coconut milk, jelly, shaved ice, fruit, color, and evening snack counters",
    belongs:
      "It gives the trip a sweet texture, where coconut milk, jelly, ice, fruit, and small dessert counters become part of the city memory.",
  },
  landmark: {
    surface: "landmark",
    scene: "a visual landmark that gives the city a shape in memory",
    meaning: "architecture, views, local pride, and history in visual form",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    texture: "architecture, views, local pride, history, city light, and landmark memory",
    belongs:
      "It gives the city a visual handle: architecture, views, local pride, history, and the landmark memory travelers carry into the trip.",
  },
  museum: {
    surface: "cultural stop",
    scene: "rooms, objects, art, artifacts, and the quieter side of understanding a place",
    meaning: "rooms, objects, art, and memory inside the city's story",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    texture: "gallery rooms, artifacts, quiet light, memory, local history, and display cases",
    belongs:
      "It gives the city a quieter way to speak: rooms, objects, art, artifacts, memory, and historical layers held inside the galleries.",
  },
  gallery: {
    surface: "gallery stop",
    scene: "framed works, quiet rooms, cafe edges, local artists, and a slower creative pause",
    meaning: "the contemporary creative side of the city shown through art, rooms, and cafe pauses",
    practical: "visiting, artworks, photos, timing, cafe pauses, or the way there",
    texture: "framed works, quiet rooms, cafe tables, local artists, soft light, and creative neighborhood texture",
    belongs:
      "It gives the city a contemporary creative side, where art rooms, cafe pauses, framed works, and local design sit beside the older streets outside.",
  },
  experience: {
    surface: "experience",
    scene: "a planned moment with its own pace, setting, sounds, and route across the day",
    meaning: "taking part in the place through movement, sound, scenery, and local texture",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    belongs:
      "It lets the traveler participate instead of only observe, with a setting, sound, route, and pace that make the city feel lived-in.",
  },
  attraction: {
    surface: "attraction",
    scene: "one of the named stops travelers imagine before they know the city's smaller details",
    meaning: "a named sight or experience that gives the trip a clear image",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    belongs:
      "It becomes one of the trip's named visual memories, the kind of stop people imagine while the itinerary is still forming at home.",
  },
  beach: {
    surface: "beach",
    scene: "sand, morning light, seafood, hotels, scooters, and the open edge of the city",
    meaning: "coastal Vietnam changing the pace of the trip",
    practical: "visit, entrance, photo, driver, pickup, and return phrases",
    belongs:
      "It changes the tempo of Vietnam into sand, morning light, seafood, sea air, beach roads, and the open edge of the city.",
  },
  nature: {
    surface: "nature stop",
    scene: "green edges, water, paths, shade, weather, and the quieter space outside the densest streets",
    meaning: "the city opening beyond buildings and traffic",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    texture: "green edges, paths, shade, water, weather, and quieter space beyond traffic",
    belongs:
      "It opens the city beyond streets and buildings, bringing in green edges, water, shade, weather, and the slower space around the urban core.",
  },
  park: {
    surface: "park",
    scene: "open paths, evening light, families, river edges, trees, and room to pause",
    meaning: "everyday city life in open air without a formal attraction",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    texture: "walking paths, trees, family time, shade, open lawns, and evening light",
    belongs:
      "It shows everyday city life in open air: families, walking paths, trees, river edges, evening light, and the room to pause between bigger sights.",
  },
  river: {
    surface: "river",
    scene: "boats, bridges, reflections, river walks, and the line that organizes the city",
    meaning: "geography, history, and everyday movement meeting",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    texture: "boats, bridges, reflections, river walks, waterline views, and evening light",
    belongs:
      "It organizes the city around water: boats, bridges, reflections, river walks, old stories, and the routes people follow across the day.",
  },
  canal: {
    surface: "canal",
    scene: "canal water, bridges, apartment edges, evening lights, and neighborhood life along the banks",
    meaning: "the city showing a softer everyday water route between districts",
    practical: "walks, bridge views, photos, cafe pauses, or the way back",
    texture: "canal water, small bridges, apartment lights, bank-side paths, and neighborhood movement",
    belongs:
      "It shows a softer water side of the city, where canal bridges, apartment lights, bank-side paths, and everyday neighborhood movement sit beside the bigger streets.",
  },
  fountainSquare: {
    surface: "fountain square",
    scene: "a roundabout fountain, snack stalls, evening lights, scooters, and friends meeting around the city center",
    meaning: "a social landmark where street food, traffic, fountains, and meetups gather",
    practical: "meeting, snacks, photos, walking, pickup point, or the way back",
    texture: "roundabout energy, fountain edges, snack stalls, evening lights, scooters, and city-center meetups",
    belongs:
      "It turns a traffic landmark into a social scene, where a fountain, snack stalls, evening lights, and friends meeting up become part of Saigon's street life.",
  },
  village: {
    surface: "village",
    scene: "workshops, homes, paths, craft, water, gardens, or fields at the edge of the tourist center",
    meaning: "local craft, village rhythm, and slower daily life",
    practical: "visit, entrance, ticket, photo, driver, pickup, and return phrases",
    belongs:
      "It brings village rhythm into the trip: craft, homes, gardens, water, workshops, and the slower daily life beside the better-known sights.",
  },
  lake: {
    surface: "lake",
    scene: "water, paths, shade, cafe edges, reflections, and a slower pocket of the city",
    meaning: "the city turning walkable around water instead of only traffic and streets",
    practical: "walking, meeting, photos, cafe stops, or the way back",
    texture: "water, walking paths, cafe edges, shade, bridges, and neighborhood views",
    belongs:
      "It gives the city a gentler waterline, where walks, cafe pauses, reflections, and neighborhood edges make the day easier to imagine.",
  },
  performance: {
    surface: "performance venue",
    scene: "stage light, music, masks, movement, applause, and a night-out culture stop",
    meaning: "living performance culture rather than a static monument",
    practical: "showtimes, seats, arrival, photos, or the way back",
    texture: "stage light, music, masks, theatre doors, evening streets, and cultural memory",
    belongs:
      "It turns culture into a live moment, with stage light, music, movement, and the feeling of sitting inside a local performance tradition.",
  },
  mall: {
    surface: "shopping stop",
    scene: "cool indoor floors, storefronts, food counters, meeting points, and a modern city pause",
    meaning: "modern shopping and a polished indoor break from heat, rain, or street movement",
    practical: "meeting, shops, food courts, payments, or the way back",
    texture: "storefronts, indoor food counters, city-center corners, cool air, and easy meetups",
    belongs:
      "It shows the modern city side: cool interiors, familiar shopping rhythms, food counters, and an easy pause between older streets and outdoor sights.",
  },
  tailor: {
    surface: "tailor stop",
    scene: "fabric walls, measuring tape, fittings, folded prints, and an old-town keepsake taking shape",
    meaning: "Hoi An's tailoring culture and the craft of turning fabric into something personal",
    practical: "fabric, fitting, timing, pickup, alterations, or the way back",
    texture: "fabric walls, measuring tape, fitting rooms, old-town shopfronts, and custom-made keepsakes",
    belongs:
      "It makes Hoi An's tailoring culture tangible: fabric, fitting, measuring, design choices, and the pleasure of taking home something made for the traveler.",
  },
  craft: {
    surface: "craft stop",
    scene: "hands, tools, materials, workshop light, and a local object being made",
    meaning: "local craft shown through materials, process, and patient hands",
    practical: "joining, watching, buying, timing, photos, or the way back",
    texture: "workshop tables, tools, hands, materials, old houses, and handmade keepsakes",
    belongs:
      "It makes the trip tactile, showing how wood, silk, pottery, incense, paper, or paint becomes part of local daily craft.",
  },
  retailMarket: {
    surface: "shopping market",
    scene: "fabric stacks, clothing rows, small counters, browsing, bargaining, and city retail energy",
    meaning: "shopping culture built around clothes, fabric, gifts, small counters, and browsing",
    practical: "sizes, colors, prices, bags, meeting, or the way back",
    texture: "clothing racks, fabric stacks, small counters, bags, gifts, and browsing lanes",
    belongs:
      "It turns shopping into a city scene, with fabric, clothing, small counters, bargaining, and the social rhythm of browsing.",
  },
  flowerMarket: {
    surface: "flower market",
    scene: "flower bundles, wet pavement, bright petals, vendors, scooters, and color spilling into the street",
    meaning: "the city showing itself through flowers, gifts, color, and everyday street trade",
    practical: "bouquets, colors, prices, meeting, photos, or the way back",
    texture: "flower bundles, street color, wet pavement, vendors, scooters, and gift stalls",
    belongs:
      "It gives the city color and scent, turning a market stop into flowers, gifts, street trade, and the kind of everyday beauty travelers remember.",
  },
  nightMarket: {
    surface: "night market",
    scene: "lanterns, food smoke, souvenir tables, warm light, snacks, and evening browsing",
    meaning: "the city shifting from daytime movement into food, lights, and browsing",
    practical: "snacks, gifts, prices, meeting, or the way back",
    texture: "lanterns, food smoke, small gifts, warm lights, river edges, and evening crowds",
    belongs:
      "It changes the city after dark, gathering snacks, lights, small gifts, food smoke, and easy wandering into one evening scene.",
  },
  rooftop: {
    surface: "viewpoint",
    scene: "skyline light, rooftops, old streets below, river edges, and the city seen from above",
    meaning: "the city turning into a skyline and a memory of height, light, and orientation",
    practical: "views, timing, drinks, photos, meeting, or the way back",
    texture: "skyline views, rooftops, river light, city-center streets, and evening air",
    belongs:
      "It gives the city a view from above, where streets, towers, river bends, and evening light become one memorable image.",
  },
  route: {
    surface: "route",
    scene: "a walk, ride, loop, or food route that connects several small moments into one city experience",
    meaning: "movement across the city as part of the discovery",
    practical: "starting point, timing, stops, photos, food, or the way back",
    texture: "street corners, food stops, cafe pauses, local movement, and the route between named places",
    belongs:
      "It turns movement itself into the experience, linking streets, food, views, stops, and small surprises into a day the traveler can picture.",
  },
  boatExperience: {
    surface: "boat experience",
    scene: "water light, boarding points, boat sounds, river or sea air, and the city changing pace on the water",
    meaning: "water travel as part of the place rather than only transport",
    practical: "boarding, timing, photos, water conditions, or the way back",
    texture: "boats, water light, riverbanks, bridges, boarding points, and a slower path across the day",
    belongs:
      "It puts the traveler on the water, where boats, riverbanks, bridges, palms, or sea light change the whole pace of the city.",
  },
  waterPier: {
    surface: "river landing",
    scene: "river steps, boats, boarding signs, skyline edges, and people shifting from street to water",
    meaning: "the city opening onto a river route rather than a road route",
    practical: "boarding, timing, tickets, meeting, or the way back",
    texture: "river steps, boarding points, boats, bridges, skyline views, and waterfront movement",
    belongs:
      "It is the river version of a threshold, where the traveler leaves the street rhythm and enters the city by water.",
  },
  workshop: {
    surface: "workshop",
    scene: "materials, hands, tools, instruction, and a small object or dish taking shape",
    meaning: "participating in local craft, cooking, or making rather than only watching",
    practical: "joining, timing, materials, photos, pickup, or the way back",
    texture: "workshop tables, ingredients, tools, instruction, hands, and a finished thing to remember",
    belongs:
      "It lets the traveler take part, turning craft, cooking, fabric, pottery, or incense into something seen, touched, and remembered.",
  },
  sacred: {
    surface: "sacred place",
    scene: "courtyards, incense, tiled roofs, statues, quiet shade, and respectful movement",
    meaning: "worship, architecture, local memory, and the quieter rhythm of a spiritual stop",
    practical: "visiting, dress, photos, timing, quiet waiting, or the way back",
    texture: "incense, courtyards, tiled roofs, temple gates, shade, and respectful pauses",
    belongs:
      "It brings the sacred side of Vietnam into the trip, where architecture, incense, worship, and quiet courtyards slow the day down.",
  },
  heritage: {
    surface: "heritage landmark",
    scene: "walls, gates, courtyards, old stone, tiled roofs, and a visible piece of history",
    meaning: "history made physical in architecture, ceremony, and place memory",
    practical: "visiting, photos, timing, route, or the way back",
    texture: "old walls, gates, courtyards, stone paths, tiled roofs, and ceremonial space",
    belongs:
      "It makes history visible, turning a name into walls, gates, courtyards, old stone, and the feeling of standing inside a larger story.",
  },
  historicSite: {
    surface: "historic site",
    scene: "earth paths, preserved structures, guide stops, trees, and the weight of history underfoot",
    meaning: "history held in paths, preserved spaces, local memory, and the quiet of the site",
    practical: "visiting, timing, photos, route, or the way back",
    texture: "earth paths, preserved spaces, guide stops, shaded trees, wartime history, and quiet exhibits",
    belongs:
      "It gives history a physical setting, where paths, preserved structures, trees, and quiet exhibits turn a name into a place the traveler can picture.",
  },
  nationalPark: {
    surface: "nature day trip",
    scene: "misty forest, mountain air, waterfalls, trails, and a cooler green world beyond the city",
    meaning: "the region opening into forest, water, weather, and mountain quiet",
    practical: "weather, trails, timing, photos, transport, or the way back",
    texture: "misty forest, waterfalls, mountain roads, trails, shade, and cooler air",
    belongs:
      "It widens the trip beyond city streets into forest, waterfalls, mountain weather, and the quieter nature around Central Vietnam.",
  },
  transferRoute: {
    surface: "arrival route",
    scene: "the road between arrival and the city the traveler came to imagine",
    meaning: "the trip shifting from flight or train into the first real route toward the destination",
    practical: "arrival, bags, meeting, route, timing, or the way there",
    texture: "airport doors, station exits, coastal roads, river bridges, luggage, and the first approach to town",
    belongs:
      "It is the transition from itinerary to arrival, where the traveler moves from flight, train, or road into the place they have been picturing.",
  },
  memorial: {
    surface: "civic memorial",
    scene: "a broad square, quiet lines, formal architecture, flags, and a respectful national memory",
    meaning: "civic memory, modern history, and the formal side of the capital",
    practical: "visiting, timing, dress, respectful waiting, photos, or the way back",
    texture: "broad squares, flags, formal stone, quiet lines, public memory, and respectful movement",
    belongs:
      "It brings civic memory into the trip, where formal architecture, public ritual, and national history ask for a slower, more respectful kind of attention.",
  },
  nightlifeStreet: {
    surface: "evening street",
    scene: "small stools, warm lights, glasses on tables, food smoke, music, and old streets getting louder after dark",
    meaning: "the city shifting into evening social life",
    practical: "meeting, drinks, food, timing, walking, or the way back",
    texture: "small stools, warm signs, food smoke, old lanes, music, and evening crowds",
    belongs:
      "It shows the city's social side after dark, where small stools, lights, drinks, food, and street sound make the neighborhood feel alive.",
  },
  foodWalk: {
    surface: "food walk",
    scene: "small tables, steam, herbs, sidewalks, shared plates, and the next bite around the corner",
    meaning: "food discovery as a route across the city",
    practical: "starting point, dishes, spice, allergies, timing, or the way back",
    texture: "small tables, steam, herbs, sidewalk seats, food lanes, and the route between bites",
    belongs:
      "It turns appetite into a route, linking small tables, street corners, dishes, and local rhythm into a walk the traveler can imagine.",
  },
};

const pageOverrides = {
  "city-danang-place-asia-park": {
    summary:
      "Asia Park is Da Nang after dark: neon rides, food stalls, families walking under bright lights, and the Sun Wheel rising over the skyline. It shows the city's modern leisure side beside the beaches and bridges.",
    about:
      "This is Da Nang in a playful night-out mood: a Ferris wheel glow, open paths, snacks, rides, and families stretching the evening along the river side of the city.",
    picture:
      "Picture the Sun Wheel lifting above the skyline while the city shifts from beach day to lights, food, and open-air movement.",
    meaning:
      "Asia Park matters because it shows modern coastal Vietnam, where leisure, skyline, and family nightlife sit beside the older temple, market, and beach images travelers may already know.",
  },
  "city-danang-place-non-nuoc-stone-village": {
    summary:
      "Non Nuoc sits near the Marble Mountains, where Da Nang's stone-carving tradition becomes visible in Buddhas, lions, garden pieces, and polished marble shaped by local workshops.",
    about:
      "This is craft Da Nang at the foot of the mountains: stone dust, carved figures, polished marble, and workshops that turn a scenic stop into a living artisan district.",
    picture:
      "Picture sculptures lined along the route below Marble Mountains, with artisans, tools, and finished pieces making the craft visible before you arrive.",
    meaning:
      "Non Nuoc matters because it gives the Marble Mountains area a craft story: mountain, worship, workshop, and local livelihood meet in one place.",
  },
  "city-hanoi-place-ba-dinh-square": {
    summary:
      "Ba Dinh Square is Hanoi in its most formal public mood: a wide civic space, red flags, government facades, and the national ceremonies that give the capital its official weight.",
    about:
      "This is where Hanoi changes from old lanes and coffee streets into the symbolic capital: broad pavement, flags, official buildings, and a quieter sense of national history.",
    picture:
      "Picture the square in morning light, with flags moving above the open space and the city feeling suddenly ceremonial rather than crowded.",
    hear:
      "Hear Quảng trường Ba Đình while picturing the square in morning light: flags, open space, formal buildings, and the capital's ceremonial mood.",
    meaning:
      "Ba Dinh Square matters because it gives first-time travelers a clear view of Vietnam's civic story: ceremony, public memory, and the capital's formal heart.",
  },
  "city-hanoi-place-ethnology-museum": {
    summary:
      "The Vietnam Museum of Ethnology opens Hanoi into a wider Vietnam: textiles, tools, ritual objects, stilt houses, and outdoor architecture from communities across the country.",
    about:
      "This is a culture stop where Vietnam becomes more than one city or one postcard: galleries, craft objects, village-house forms, and the many ethnic traditions behind the country as a whole.",
    picture:
      "Picture walking from quiet exhibition rooms into a courtyard of stilt-house forms, wooden structures, and objects that make regional life easier to imagine.",
    hear:
      "Hear Bảo tàng Dân tộc học with the wider Vietnam story in mind: textiles, tools, stilt-house forms, ritual objects, and courtyard paths.",
    meaning:
      "The museum matters because it helps a traveler understand Vietnam as many cultures, materials, homes, rituals, and landscapes, not just the places on a route.",
  },
  "city-hanoi-place-cho-buoi-market": {
    summary:
      "Cho Buoi Market shows Hanoi's everyday buying rhythm: plant stalls, household goods, small vendors, narrow lanes, and the practical life that keeps a neighborhood moving.",
    about:
      "This is not a polished souvenir stop; it is Hanoi as a local market scene, with plants, goods, signs, and vendors giving the city a lived-in texture.",
    picture:
      "Picture lanes of plants and household goods, scooters edging past stalls, and a market morning that feels local before it feels touristic.",
    hear:
      "Hear Chợ Bưởi with a neighborhood market morning in mind: plant stalls, household goods, small vendors, and scooters edging past narrow lanes.",
    meaning:
      "Cho Buoi matters because it widens Hanoi beyond monuments and cafes into the daily neighborhood economy travelers pass through on the ground.",
  },
  "city-hanoi-place-coffee-hop": {
    summary:
      "A Hanoi coffee hop turns the city into a sequence of cups: egg coffee, iced milk coffee, tiny stools, upstairs cafes, and street views between stops.",
    about:
      "This is Hanoi through pauses rather than landmarks: one cafe table, then another, with sweetness, ice, old streets, and conversation making the city feel close.",
    picture:
      "Picture moving from cup to cup through old-lane Hanoi, with cafe signs, balcony views, condensed milk, and the sound of the street below.",
    hear:
      "Hear Đi cà phê Hà Nội while imagining a gentle cafe route: egg coffee, iced milk coffee, tiny stools, upstairs rooms, and Old Quarter street views.",
    meaning:
      "The coffee hop matters because Hanoi's cafe culture is a travel experience of its own, mixing French-era habits, local sweetness, small spaces, and slow observation.",
  },
  "city-hanoi-place-giang-cafe": {
    summary:
      "Giang Cafe is Hanoi's egg-coffee landmark: thick whipped yolk cream, small cups, tucked-away tables, and a cafe ritual travelers remember long after the cup is gone.",
    about:
      "This is one of Hanoi's most specific cafe images: a narrow entrance, close tables, sweet foam, coffee bitterness, and the feeling of finding something local and iconic.",
    picture:
      "Picture a small cup of egg coffee arriving with glossy foam on top, while old-quarter cafe tables and street sound gather around it.",
    hear:
      "Hear Cà phê Giảng while picturing the egg-coffee cup itself: glossy foam, coffee bitterness, close tables, and old-quarter street sound.",
    meaning:
      "Giang matters because egg coffee is not just a drink here; it is a Hanoi story of wartime substitution, sweetness, invention, and cafe culture.",
  },
  "city-hanoi-place-nguyen-huu-huan-street": {
    summary:
      "Nguyen Huu Huan Street is a Hanoi coffee street, where cafe signs, egg-coffee stops, narrow shopfronts, and Old Quarter movement make the neighborhood feel easy to explore.",
    about:
      "This street gives the coffee side of Hanoi a visible shape: close storefronts, upstairs rooms, tiny tables, and the next cup only a short walk away.",
    picture:
      "Picture a short Old Quarter street lined with cafe fronts, motorbikes, signs, and the promise of egg coffee tucked behind one doorway after another.",
    hear:
      "Hear Phố Nguyễn Hữu Huân with the coffee-street image in mind: cafe signs, motorbikes, narrow shopfronts, and egg-coffee stops close together.",
    meaning:
      "Nguyen Huu Huan matters because it turns Hanoi coffee from a single famous cup into a walkable neighborhood scene.",
  },
  "city-hanoi-place-literature-museum": {
    summary:
      "Vietnam Literature Museum gives Hanoi a quieter cultural stop: Vietnamese writing, authors, books, memory, and gallery rooms that connect the capital to its literary life.",
    about:
      "This is Hanoi through words and memory, where literature becomes a travel texture beside lakes, old streets, bookstores, and cafe tables.",
    picture:
      "Picture quiet rooms of books, author portraits, Vietnamese text, and a slower museum pause in a city that has always cared about language and learning.",
    hear:
      "Hear Bảo tàng Văn học Việt Nam with Hanoi's literary side in mind: books, writers, quiet rooms, and the capital's reading culture.",
    meaning:
      "The museum matters because Hanoi is not only food streets and lakes; it is also a literary capital with writers, memory, publishing, and study woven into the city.",
    practical:
      "The travel moment is quiet cultural discovery: books, author rooms, Vietnamese text, gallery pauses, and the literary side of Hanoi.",
    good:
      "Bảo tàng Văn học Việt Nam belongs with books, author portraits, quiet rooms, and Hanoi's long relationship with writing and study.",
    context:
      "Vietnam Literature Museum brings Hanoi's literary side into focus through books, author rooms, Vietnamese text, and quiet cultural memory.",
    tip:
      "Bảo tàng Văn học Việt Nam belongs beside books, author portraits, quiet rooms, and Hanoi's reading culture.",
    rationale:
      "Vietnam Literature Museum makes Hanoi feel more literary through books, authors, Vietnamese text, and quiet cultural memory.",
  },
  "city-hanoi-place-bia-hoi": {
    summary:
      "Bia hoi is Hanoi's fresh-beer sidewalk ritual: small stools, light beer, shared snacks, street corners, and the easy social pause between one walk and the next.",
    about:
      "This is Hanoi at stool height, where cold glasses, quick pours, neighborhood corners, and low tables make the city feel relaxed and social.",
    picture:
      "Picture a Hanoi corner with small plastic stools, fresh beer glasses, shared snacks, and old-lane movement passing close by.",
    hear:
      "Hear Bia hơi Hà Nội with the sidewalk scene in mind: small stools, cold glasses, shared snacks, and evening street life.",
    meaning:
      "Bia hoi matters because it shows Hanoi's casual social side, where the drink is simple but the street-corner ritual is memorable.",
    good:
      "Bia hơi Hà Nội belongs with small stools, fresh beer glasses, shared snacks, and Hanoi's relaxed sidewalk rhythm.",
  },
  "city-hanoi-place-turtle-tower": {
    summary:
      "Turtle Tower is the quiet landmark at the center of Hoan Kiem Lake, giving Hanoi a small, iconic silhouette of water, legend, reflection, and old-city calm.",
    about:
      "This is Hanoi's lake memory in one image: Turtle Tower sitting apart on the water while trees, walkers, and Old Quarter streets gather around the lake edge.",
    picture:
      "Picture Turtle Tower reflected in Hoan Kiem Lake as the city softens around the water and the Old Quarter waits just beyond the trees.",
    hear:
      "Hear Tháp Rùa with Hoan Kiem Lake in mind: water reflections, trees, legend, and the old center of Hanoi.",
    meaning:
      "Turtle Tower matters because it gives Hoan Kiem Lake its most recognizable symbol, tying Hanoi's old center to legend, water, and public memory.",
    practical:
      "The travel moment is Hoan Kiem Lake orientation: water reflections, walking paths, trees, Old Quarter edges, and the tower in the middle of the view.",
    good:
      "Tháp Rùa belongs with Hoan Kiem water, lake trees, old-city calm, and the small landmark silhouette travelers remember from Hanoi.",
    context:
      "Turtle Tower brings Hanoi's lake-and-legend story into focus through Hoan Kiem water, reflections, trees, and old-city calm.",
    tip:
      "Tháp Rùa belongs beside Hoan Kiem water, lake trees, reflections, and Hanoi's old-city calm.",
    rationale:
      "Turtle Tower brings Hanoi into focus through Hoan Kiem water, lake reflections, trees, and old-city legend.",
  },
  "city-hanoi-place-hanoi-railway-station": {
    summary:
      "Hanoi Railway Station is a classic capital arrival scene: yellow facade, route boards, luggage, shaded platforms, and streets leading back into old Hanoi.",
    about:
      "This is Hanoi through train travel, where the station facade and nearby streets make the city feel connected to longer journeys north and south.",
    picture:
      "Picture the yellow station facade, passengers with bags, route boards, and the first Hanoi streets waiting outside the doors.",
    meaning:
      "Hanoi Railway Station matters because it gives the capital a travel-day threshold, linking city time with rail routes, local signs, and the next leg of the trip.",
  },
  "city-hanoi-place-my-dinh-bus-station": {
    summary:
      "My Dinh Bus Station is Hanoi's western onward-road hub, where luggage, route signs, waiting benches, and city-edge streets point toward the next part of northern Vietnam.",
    about:
      "This is a different arrival edge from the railway station: wider roads, bus routes, local signs, and the feeling of Hanoi stretching toward the suburbs and beyond.",
    picture:
      "Picture a busy bus-station edge with route signs, waiting benches, bags, and the capital's outer streets moving around the terminal.",
    meaning:
      "My Dinh matters because it shows Hanoi as a travel hub, not only an old quarter: buses, signs, onward roads, and the wider north all connect here.",
  },
  "city-hoian-place-bay-mau-coconut-forest": {
    summary:
      "Bay Mau is where Hoi An changes texture: lantern streets give way to coconut palms, narrow waterways, basket boats, folk songs, and the water-village life around Cam Thanh.",
    about:
      "This is Hoi An beyond the old yellow walls: green coconut palms, low boats, river channels, and the village-water rhythm around Cam Thanh.",
    picture:
      "Picture basket boats moving through nipa palms while the Ancient Town slips farther away and the day slows into water.",
    meaning:
      "Bay Mau matters because Hoi An is not only lantern streets; it is also wetlands, village life, fishing culture, and the quieter river world around the old town.",
  },
  "city-hue-place-thuy-xuan-incense-village": {
    summary:
      "Thuy Xuan is Hue in scent and color: incense bundles opened like flowers, sandalwood in the air, and small workshops along the route to royal tombs.",
    about:
      "This is Hue's ritual craft made visible: bright incense fans, handmade sticks, temple scents, and workshops sitting close to the roads that lead toward tombs and hills.",
    picture:
      "Picture bundles of red, yellow, purple, and orange incense spreading outward like flowers while the air carries sandalwood and smoke.",
    meaning:
      "Thuy Xuan matters because Hue's beauty is also worship, memory, family altars, temple scent, and everyday craft, not only imperial monuments.",
  },
  "city-danang-place-bach-dang-street": {
    summary:
      "Bach Dang Street is Da Nang's riverfront spine: bridges, promenade walks, cafes, hotels, and Han River lights all make more sense from this edge of the city.",
  },
  "city-danang-place-43-factory": {
    summary:
      "43 Factory shows Da Nang's polished specialty-coffee side: clean roasts, bright interiors, and a slower beach-area pause between seafood, hotels, and river routes.",
    about:
      "This is Da Nang's contemporary cafe scene in a sharp, design-forward setting: specialty roasts, tropical plants, polished counters, and a quiet pause near the beach side of the city.",
    picture:
      "Picture bright coffee counters, clean glass, tropical plants, and a slower cup between beach mornings, seafood plans, and Han River evenings.",
    meaning:
      "43 Factory matters because Da Nang is not only beaches and bridges; it also has a modern coffee culture that feels calm, stylish, and very present-day.",
    good:
      "Cà phê 43 Factory feels attached to a real pause: clean roasts, bright counters, tropical plants, and Da Nang's polished cafe mood.",
  },
  "city-danang-place-3d-art-in-paradise": {
    summary:
      "3D Art in Paradise Da Nang is a playful indoor stop where painted rooms turn into photo illusions: oversized scenes, forced perspective, bright walls, and friends stepping into the artwork.",
    about:
      "This is Da Nang in a light, rainy-day mood: a place for optical illusions, funny photos, and a break from beaches, bridges, and outdoor sightseeing.",
    picture:
      "Picture rooms painted so the floor, walls, and camera angle make visitors look as if they are inside the scene.",
    meaning:
      "3D Art in Paradise matters because it adds a playful, camera-ready side to Da Nang, especially for families or travelers who want a low-pressure indoor pause.",
    hear:
      "Say Bảo tàng 3D Art in Paradise Đà Nẵng for 3D Art in Paradise Da Nang. It is a long venue name, so keep it together and connect it to the painted optical-illusion rooms.",
    practical:
      "Worth it if you want playful photo time, indoor cooling-off, friends posing in painted rooms, and a break between outdoor Da Nang plans.",
    good:
      "Bảo tàng 3D Art in Paradise Đà Nẵng belongs with playful painted rooms, optical illusions, and the easy fun of stepping into a photo scene.",
    context:
      "3D Art in Paradise adds a playful indoor Da Nang stop through painted rooms, forced perspective, bright walls, and friends stepping into the scene.",
    tip:
      "Bảo tàng 3D Art in Paradise Đà Nẵng belongs beside painted rooms, optical illusions, and the easy fun of a camera-ready indoor pause.",
    rationale:
      "3D Art in Paradise makes Da Nang feel more playful through painted rooms, optical illusions, and a low-pressure indoor break from outdoor sightseeing.",
  },
  "city-danang-place-museum": {
    summary:
      "Da Nang Museum is worth a stop if you want the city to feel less like only beaches and bridges. Its riverside building began as the French-era Governor's Palace, later served as Da Nang City Hall, and now holds the city's historical collection.",
    about:
      "This is Da Nang's city-history stop: a former French-era Governor's Palace and City Hall turned museum, facing the Han River and giving the modern coastal city an older civic story.",
    picture:
      "Expect rooms about Da Nang's urban growth, wartime history, cultural communities, and the City Hall building itself, with artifacts that make the city feel more layered.",
    hear:
      "Say Bảo tàng Đà Nẵng for Da Nang Museum. Bảo tàng means museum, and the full name matters because Da Nang has several museum stops.",
    meaning:
      "The payoff is context: the museum helps explain how Da Nang grew from an older port and civic center into the beach-and-bridge city many visitors see first.",
    practical:
      "Worth it if you want a slower cultural stop near the river, a rainy-afternoon plan, or background before visiting Cham sites, old streets, and central Da Nang.",
    good:
      "Choose this name for the main city-history museum. If you mean Cham sculpture or fine art, choose those more specific museum names instead.",
    context:
      "Da Nang Museum brings the city's civic history into focus through a former Governor's Palace and City Hall building, historical galleries, wartime memory, and Han River setting.",
    tip:
      "Bảo tàng Đà Nẵng names the main city-history museum, not the Cham Sculpture Museum or Da Nang Fine Arts Museum.",
    rationale:
      "Da Nang Museum makes the city feel more layered by connecting modern beach-and-bridge Da Nang to civic history, wartime memory, and a riverside heritage building.",
  },
  "city-danang-place-dragon-bridge-fire-show": {
    summary:
      "The Dragon Bridge fire show is Da Nang's riverfront spectacle: crowds along the Han River, the dragon head glowing after dark, and bursts of fire and water over the bridge.",
    about:
      "This is not a theater night; it is the city gathering outside, with river railings, scooters, families, skyline lights, and the bridge turning into the show.",
    picture:
      "Picture people lining the Han River as the dragon head lights up and the bridge breathes fire into the night air.",
    meaning:
      "The fire show matters because it turns Da Nang's most recognizable bridge into a shared weekend ritual, part landmark, part street gathering, part skyline memory.",
    practical:
      "The travel moment is riverfront waiting, evening crowds, bridge views, photos, scooters, skyline lights, and the sudden fire-and-water burst.",
    good:
      "Rồng phun lửa belongs with Han River crowds, evening bridge light, and the shared moment when the city looks up at the dragon.",
    context:
      "The Dragon Bridge fire show brings Da Nang's riverfront energy into focus through crowds, bridge lights, scooters, skyline, and bursts of fire and water.",
    tip:
      "Rồng phun lửa belongs beside Han River crowds, evening bridge light, and the shared moment when Da Nang looks up at the dragon.",
    rationale:
      "The Dragon Bridge fire show makes Da Nang feel vivid through riverfront crowds, bridge lights, skyline, and the fire-and-water burst after dark.",
  },
  "city-hue-place-ngo-mon-gate": {
    summary:
      "Ngo Mon Gate is the grand front gate of Hue's Imperial City, the first visual cue that you are entering Vietnam's old royal capital: walls, courtyards, ceremony, and layered history.",
  },
  "city-hue-place-railway-station": {
    summary:
      "Hue Railway Station feels like an old-capital arrival scene: shaded platforms, yellow station light, local signs, and the Perfume River city waiting beyond the doors.",
    about:
      "This is not just a travel checkpoint; it is the first edge of Hue for many visitors, with slower streets, station awnings, and the old royal city beginning just outside.",
    picture:
      "Picture the station doors opening onto Hue's softer pace: shaded benches, route boards, local signs, and streets that lead back toward the river and citadel.",
    meaning:
      "Hue Railway Station matters because arrival here already carries the city's mood: old-capital calm, river distance, shaded streets, and the first local name of the day.",
  },
  "city-hue-place-northern-bus-station": {
    summary:
      "Hue Northern Bus Station sits on the practical edge of the old capital, where shaded benches, local signs, onward streets, and citadel-side Hue start to replace the highway.",
    about:
      "This is a city-edge arrival point, but the scene is still Hue: slower light, local signs, waiting benches, and streets that pull the traveler back toward the royal city.",
    picture:
      "Picture the bus-station doors giving way to Hue's quieter streets, with local signs, shaded benches, and the old-capital rhythm waiting outside.",
    meaning:
      "Hue Northern Bus Station matters because it turns a travel leg back into Hue: old-capital pace, local signs, and the first familiar city texture after the ride.",
  },
  "city-hue-place-southern-bus-station": {
    summary:
      "Hue Southern Bus Station is a city-edge arrival scene: shaded waiting areas, local signs, slower streets, and the old capital beginning to reappear beyond the road.",
    about:
      "This is a threshold back into Hue, where highway movement gives way to local signs, softer light, and streets that point toward the river, citadel, and garden-house side of the city.",
    picture:
      "Picture the bus-station doors opening toward Hue's quieter streets, with local signs, shaded benches, and the old-capital pace waiting outside.",
    meaning:
      "Hue Southern Bus Station matters because even an arrival point can carry the city's mood: slower streets, local signs, and the first return to Hue's river-city calm.",
    practical:
      "The travel moment is arrival-edge Hue: local signs, shaded benches, onward streets, and the shift from highway movement into the old capital.",
    good:
      "Bến xe phía Nam Huế belongs with Hue's softer arrival edge: shaded benches, local signs, slower streets, and the river city waiting beyond the doors.",
  },
  "city-hue-place-phu-bai-airport": {
    summary:
      "Phu Bai Airport is Hue's soft arrival edge: warm air, low terminal doors, local signs, and the road toward the Perfume River and old royal capital.",
    about:
      "This is the first Hue threshold for many travelers, where airport doors open toward slower streets, river light, tomb roads, garden houses, and the old capital's calmer pace.",
    picture:
      "Picture the terminal doors giving way to warm central-Vietnam air, local signs, and the road that gradually turns into Hue's river city.",
    hear:
      "Hear Sân bay Phú Bài with Hue's old-capital arrival scene in mind: warm air, local signs, and the road toward the Perfume River.",
    meaning:
      "Phu Bai Airport matters because it starts the Hue story gently: arrival, warm air, local signs, and the first road toward imperial gates, pagodas, and the Perfume River.",
  },
  "city-hue-place-lien-hoa-vegetarian": {
    summary:
      "Lien Hoa Vegetarian Restaurant shows Hue's Buddhist vegetarian food culture in a simple, welcoming room: fresh dishes, calm decor, and the temple-adjacent rhythm behind chay meals.",
    about:
      "This is Hue at the table through chay food: vegetables, tofu, herbs, Buddhist influence, and a quieter meal style that belongs naturally beside pagodas and garden streets.",
    picture:
      "Picture a modest vegetarian dining room with fresh plates, Buddhist-style decor, and Hue's slower lunch rhythm just outside the door.",
    meaning:
      "Lien Hoa matters because vegetarian food in Hue is tied to Buddhist practice, temple days, family meals, and the old capital's quieter way of eating.",
  },
  "city-danang-place-domestic-terminal": {
    summary:
      "Da Nang Domestic Terminal is a first glimpse of the coastal city returning home to itself: Vietnamese signs, families with bags, warm air outside the doors, and the beach road waiting beyond the airport.",
    about:
      "This is a quieter arrival scene inside Da Nang: domestic travelers, short flights, local signs, and the feeling that the city is close enough to begin almost immediately.",
    picture:
      "Picture the doors opening into central Vietnam light, with beach roads, river bridges, seafood plans, and the Han River already nearby in the imagination.",
    meaning:
      "Da Nang Domestic Terminal matters because even a simple airport sub-place can make the first minutes feel oriented, local, and connected to the coastal city outside.",
  },
  "city-danang-place-international-terminal": {
    summary:
      "Da Nang International Terminal is where Vietnam first becomes visible for many central-Vietnam trips: glass doors, tropical air, Vietnamese signs, and the route toward beaches, Hoi An, or the Han River.",
    about:
      "This is the arrival threshold before Da Nang opens out into beach roads, river bridges, seafood dinners, mountain day trips, and old-town routes farther south.",
    picture:
      "Picture the airport doors, the warm air, and the first ride toward a coastal city that quickly turns into bridges, beach mornings, markets, and Central Vietnam food.",
    meaning:
      "Da Nang International Terminal matters because it is often the first real place-name in the trip, the point where Vietnam shifts from itinerary to lived arrival.",
  },
  "city-hoian-place-ancient-town-ticket-booth": {
    summary:
      "Hoi An Ancient Town ticket booth is a small gateway into the old town: yellow walls, heritage-house signs, lantern streets nearby, and the first sense that the Ancient Town has its own rhythm.",
    about:
      "This is the threshold before the old-town romance: a modest checkpoint beside yellow walls, tiled roofs, river walks, and house museums.",
    picture:
      "Picture a modest kiosk tucked into the old-town flow, with lantern streets, yellow facades, old houses, and the river walk waiting just beyond it.",
    meaning:
      "The ticket booth matters because it marks the moment Hoi An changes from open wandering into a protected old-town story of houses, bridges, assembly halls, and lantern-lit streets.",
  },
  "city-hue-place-songlab": {
    summary:
      "Sống Platform - SốngLab shows Hue's contemporary culture side: dark gallery rooms, digital light, local motifs, and a modern creative space beside the city's older imperial story.",
    about:
      "This is Hue after the tombs and gates: a culture room where digital art, design, and local motifs make the old capital feel current as well as historic.",
    picture:
      "Picture a dark immersive gallery with soft digital light and Hue motifs, then step back into a city of imperial gates, river streets, incense, and garden houses.",
    meaning:
      "Sống Platform - SốngLab matters because Hue is not only royal memory; it is also a living creative city with contemporary spaces layered into the old capital.",
  },
};

function readJSON(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJSON(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function hash(value) {
  let total = 0;
  for (const char of String(value)) total = (total * 31 + char.charCodeAt(0)) >>> 0;
  return total;
}

function pick(list, key) {
  return list[hash(key) % list.length];
}

function pickMany(parts, key) {
  const choices = parts.map((list, index) => pick(list, `${key}:${index}`));
  return choices.join(" ");
}

function articleFor(word) {
  return /^[aeiou]/i.test(String(word || "")) ? "an" : "a";
}

function cityCueFor(page, city) {
  const cityID = page.cityID || city.id;
  const text = pageSearchText(page);
  if (cityID === "hanoi") {
    if (/\b(ba dinh|ba đình|flag tower|cột cờ|cot co|mausoleum|lăng bác|lang bac|square|quảng trường|quang truong|memorial)\b/i.test(text)) {
      return pick([
        "the capital's formal civic side",
        "Ba Dinh's broad public space",
        "Hanoi's national-history setting",
      ], `${page.id}:hanoi-civic-formal-cue`);
    }
    if (/\b(airport|no[iị] bai|nội bài|station|bus|railway|ga |bến xe|ben xe)\b/i.test(text)) {
      return pick([
        "the first roads into Hanoi",
        "Hanoi's station-side streets",
        "the arrival edge of the capital",
      ], `${page.id}:hanoi-arrival-cue`);
    }
    if (/\b(museum|bảo tàng|bao tang|ethnology|fine arts|history|circus|theatre|theater|opera|show)\b/i.test(text)) {
      if (/\b(literature|văn học|van hoc)\b/i.test(text)) {
        return pick([
          "Hanoi's literary side",
          "the capital's book-and-gallery rhythm",
          "Hanoi's quieter reading-room culture",
        ], `${page.id}:hanoi-literature-cue`);
      }
      return pick([
        "Hanoi's museum-and-courtyard side",
        "the cultural stops around old Hanoi",
        "Hanoi's quieter gallery-and-stage rhythm",
      ], `${page.id}:hanoi-culture-cue`);
    }
    if (/\b(market|chợ|cho |long bien|đồng xuân|dong xuan|quảng bá|quang ba)\b/i.test(text)) {
      return pick([
        "Hanoi market-morning energy",
        "the capital's produce-and-stall rhythm",
        "Hanoi's market-side street life",
      ], `${page.id}:hanoi-market-cue`);
    }
    if (/\b(botanical|garden|park|công viên|cong vien)\b/i.test(text)) {
      return pick([
        "Hanoi park-and-shade rhythm",
        "the capital's open-air pauses",
        "Hanoi's garden-side calm",
      ], `${page.id}:hanoi-park-cue`);
    }
    if (/\b(coffee|cafe|café|cà phê|ca phe|egg coffee|iced milk coffee)\b/i.test(text)) {
      return pick([
        "Hanoi coffeehouse culture",
        "old-quarter cafe rhythm",
        "Hanoi's tiny-table coffee scene",
      ], `${page.id}:hanoi-coffee-cue`);
    }
    if (/\b(temple|pagoda|đền|den|chùa|chua|mausoleum|memorial|lake|hồ |ho )\b/i.test(text)) {
      return pick([
        "Hanoi's lake-and-temple side",
        "the capital's old civic rhythm",
        "Hoan Kiem and West Lake calm",
      ], `${page.id}:hanoi-civic-cue`);
    }
    if (/\b(bún|bun|phở|pho|chả cá|cha ca|bánh|banh|xôi|xoi|restaurant)\b/i.test(text)) {
      return pick([
        "Hanoi's steam-and-herb food streets",
        "old-quarter noodle tables",
        "Hanoi grill smoke and broth counters",
      ], `${page.id}:hanoi-food-cue`);
    }
    if (/\b(temple|pagoda|đền|den|chùa|chua|mausoleum|memorial|lake|hồ |ho )\b/i.test(text)) {
      return pick([
        "Hanoi's lake-and-temple side",
        "the capital's old civic rhythm",
        "Hoan Kiem and West Lake calm",
      ], `${page.id}:hanoi-civic-cue`);
    }
  }
  if (cityID === "hue") {
    if (/\b(station|bus|railway|ga |bến xe|ben xe)\b/i.test(text)) {
      return pick([
        "Hue's arrival-edge streets",
        "the old capital's station-side light",
        "Hue's quieter onward roads",
      ], `${page.id}:hue-arrival-cue`);
    }
    if (/\b(street|walking|phố|pho |đường|duong|nguyen dinh chieu)\b/i.test(text)) {
      return pick([
        "Hue's river-walk rhythm",
        "the old capital's evening street life",
        "Perfume River street light",
      ], `${page.id}:hue-street-cue`);
    }
  }
  const cues = {
    danang: [
      "coastal Da Nang",
      "Han River light",
      "central-Vietnam beach rhythm",
      "bridge-and-beach Da Nang",
      "Da Nang's seafood-and-mountain day",
    ],
    hanoi: [
      "Hanoi old-lane texture",
      "old-lane Hanoi",
      "Hanoi open-air city calm",
      "old-lane Hanoi",
      "Hanoi's food-and-cafe rhythm",
    ],
    hcmc: [
      "Saigon street energy",
      "District 1 movement",
      "Ben Thanh market energy",
      "Nguyen Hue city light",
      "Saigon river lights",
    ],
    hoian: [
      "Hoi An old-town texture",
      "lantern-street Hoi An",
      "yellow-wall old town",
      "Thu Bon river light",
      "Cam Thanh coconut-waterway life",
    ],
    hue: [
      "Hue river-city memory",
      "imperial Hue",
      "Perfume River calm",
      "royal-city memory",
      "citadel-side Hue",
    ],
  };
  return pick(cues[cityID] || [city.name], `${page.id}:city-cue`);
}

function addCityCueToTexture(page, city, texture) {
  return `${texture}, alongside ${cityCueFor(page, city)}`;
}

function isSesameCandyPage(page) {
  return /\b(me-xung|mè xửng|me xung|sesame candy)\b/i.test(pageSearchText(page));
}

function textureFor(page, profile, city, key = "texture") {
  const descriptor = normalizedLower([
    page.id,
    page.placeID,
    page.title,
    page.englishTitle,
    page.englishText,
    page.localName,
    page.vietnameseText,
  ].filter(Boolean).join(" "));
  if (profile.key === "transferRoute") {
    const routeTexture = /railway|station|ga /i.test(descriptor)
      ? "station doors, coastal roads, river bridges, luggage, and the first approach to town"
      : "airport doors, coastal roads, river bridges, luggage, and the first approach to town";
    return textureSlice(page, routeTexture, key);
  }
  if (profile.key === "drink" && /\b(bia|beer)\b/.test(descriptor)) {
    const beerTexture = "fresh beer glasses, small stools, corner tables, evening street light, shared snacks, and Hanoi sidewalk rhythm";
    return addCityCueToTexture(page, city, textureSlice(page, beerTexture, key));
  }
  if (profile.key === "sacred" && /\b(cathedral|church|notre dame|nhà thờ|nha tho)\b/.test(descriptor)) {
    const churchTexture = `cathedral facades, quiet pews, stained-glass light, courtyard shade, bells, and ${city.name} worship`;
    return addCityCueToTexture(page, city, textureSlice(page, churchTexture, key));
  }
  if (isSesameCandyPage(page)) {
    const sesameTexture = "sesame seeds, malt sweetness, peanut, cut squares, tea cups, and market wrapping paper";
    return addCityCueToTexture(page, city, textureSlice(page, sesameTexture, key));
  }
  const raw = profile.texture || city.texture;
  if (profile.texture) {
    return addCityCueToTexture(page, city, textureSlice(page, raw, key));
  }
  return textureSlice(page, raw, key);
}

function textureSlice(page, raw, key) {
  const parts = String(raw)
    .replace(/\band\b/g, ",")
    .split(",")
    .map((part) => part.trim())
    .filter(Boolean);
  if (parts.length <= 4) return raw;
  const count = Math.min(4, parts.length);
  const start = hash(`${page.id}:${key}`) % parts.length;
  const selected = [];
  for (let offset = 0; offset < parts.length && selected.length < count; offset += 1) {
    const part = parts[(start + offset) % parts.length];
    if (!selected.includes(part)) selected.push(part);
  }
  if (selected.length === 1) return selected[0];
  return `${selected.slice(0, -1).join(", ")}, and ${selected[selected.length - 1]}`;
}

function removePhotoPromptLanguage(value) {
  return String(value ?? "")
    .replace(/^Photorealistic owned asset:\s*/i, "")
    .replace(/^Photorealistic\s+/i, "")
    .replace(/\bphotorealistic\b/gi, "")
    .replace(/\brealistic(?:\s+no-logo)?\s+photo\b/gi, "")
    .replace(/\brealistic photo\b/gi, "")
    .replace(/\brealistic\b/gi, "")
    .replace(/\bdocumentary (?:travel )?style\b/gi, "")
    .replace(/\btravel documentary style\b/gi, "")
    .replace(/\bowned asset:\s*/gi, "")
    .replace(/\bno-logo photo\b/gi, "")
    .replace(/\bphoto-?realistic\b/gi, "")
    .replace(/\b(?:travel|food|documentary|street-food)\s+photo\b/gi, "")
    .replace(/\bphoto\b/gi, "")
    .replace(/\btravel documentary style\b/gi, "")
    .replace(/\bdocumentary(?:\s+[a-z-]+){0,4}\s+light\b/gi, "natural light")
    .replace(/\bdocumentary\b/gi, "")
    .replace(/\bwith signs blurred\b/gi, "with shopfront texture")
    .replace(/\bshopfronts blurred\b/gi, "old shopfront texture")
    .replace(/\binvented signage\b|\binvented signs\b/gi, "street-side details")
    .replace(/\bno storefront logos?\b/gi, "")
    .replace(/\bno storefront\b/gi, "")
    .replace(/\baerial-like but (?:realistic )?framing\b/gi, "wide coastal framing")
    .replace(/\bdocumentary food style\b|\bfood style\b/gi, "food counter scene")
    .replace(/\bstreet cart backdrop\b/gi, "street cart scene")
    .replace(/\broaster equipment\b/gi, "coffee bar")
    .replace(/\bsculptural canopy\b/gi, "curving riverside canopy")
    .replace(/\blow-light\b/gi, "evening")
    .replace(/\bblue hour\b/gi, "evening river light")
    .replace(/\bcinematic\b/gi, "wide and bright")
    .replace(/\bwide and bright but\b/gi, "wide and bright")
    .replace(/\bno tents or people\b/gi, "")
    .replace(/\bno people\b/gi, "")
    .replace(/\blocks detailed view\b/gi, "love locks and river light")
    .replace(/\blocks clear detail\b/gi, "love locks and river light")
    .replace(/\blocks visible texture\b/gi, "love locks and river light")
    .replace(/,\s*clear detail\b/gi, "")
    .replace(/,\s*visible texture\b/gi, "")
    .replace(/\bvisible texture\s+/gi, "")
    .replace(/\bdetailed view\b/gi, "visible texture")
    .replace(/\bclose-up\b/gi, "visible texture")
    .replace(/\bblurred\b/gi, "softly behind")
    .replace(/\barrival point\b/gi, "entry area")
    .replace(/\bmodern specialty coffee bar with coffee bar\b/gi, "modern specialty coffee bar")
    .replace(/\bcoffee bar with coffee bar\b/gi, "coffee bar")
    .replace(/\blagoon seafood platform\b/gi, "lagoon seafood raft")
    .replace(/\bseafood platform\b/gi, "seafood raft")
    .replace(/\bwith ([^,.]+?) in background\b/gi, "with $1 behind it")
    .replace(/\bVietnamese labels?\b/gi, "Vietnamese display details")
    .replace(/\briverside performance-island (?:entrance|arrival point) at dusk with lantern glow,? (?:or )?show posters\b/gi, "riverside show island at dusk with lantern glow")
    .replace(/\bhands-free setup\b/gi, "open workshop table")
    .replace(/\bno brand(?:ed)? (?:signage|signs?|logos?|marks?|branding)\b/gi, "")
    .replace(/\bno [^,.]*branding\b/gi, "")
    .replace(/\bno company (?:names?|marks?|branding)\b/gi, "")
    .replace(/\bno (?:tour|shop|resort|close-up|copied|posed|performers?'?|performer) [^,.]+/gi, "")
    .replace(/\bno [^,.]*(?:hands?|staff|faces?|face|traffic|animals?|tourists?|farmers?|labels?|plates?|artworks?|statues?|sculptures?|reproduction|copy|store|worshippers?|people close-ups?|close-ups?)\b/gi, "")
    .replace(/\bno exact [^,.]+/gi, "")
    .replace(/\bno signs?\b/gi, "")
    .replace(/\bno branding\b/gi, "")
    .replace(/\bno crowds?[^,.]*/gi, "")
    .replace(/\bno logos?\b/gi, "")
    .replace(/\bno brand(?:ed)?\b/gi, "")
    .replace(/\bno exact branding\b/gi, "")
    .replace(/\bno staged [^,.]+/gi, "")
    .replace(/\bbrand marks?\b/gi, "")
    .replace(/\bneutral signage\b/gi, "street-side details")
    .replace(/\bsoft signage\b/gi, "street-side details")
    .replace(/\bsignage\b/gi, "signs")
    .replace(/\blogos? replaced with (?:neutral |street )?signs?\b/gi, "city frontage")
    .replace(/\breplaced with street signs\b/gi, "city frontage")
    .replace(/\breplaced with street-side details\b/gi, "city frontage")
    .replace(/\bno brand(?:ed)? (?:signs?|logos?|marks?)\b/gi, "")
    .replace(/\bno visible [^,.]+/gi, "")
    .replace(/\bno visible\b/gi, "")
    .replace(/\bno readable [^,.]+/gi, "")
    .replace(/\bno identifiable [^,.]+/gi, "")
    .replace(/\binvented displays only\b/gi, "curated displays")
    .replace(/^local\s+([A-Z][a-z]+)\s+/i, "$1 ")
    .replace(/\bfaces? indistinct\b/gi, "people moving through the scene")
    .replace(/\bfaces? blurred\b/gi, "people moving through the scene")
    .replace(/\blogos?\b/gi, "")
    .replace(/\bforeground\b|\bbackground\b/gi, "")
    .replace(/\bcontrolled museum lighting\b|\bsoft museum lighting\b/gi, "quiet gallery light")
    .replace(/\bgallery interior\b/gi, "gallery rooms")
    .replace(/\bclear storefront context\b/gi, "a clear shopfront")
    .replace(/\bno diners facing camera\b/gi, "")
    .replace(/\bfacing camera\b/gi, "")
    .replace(/\bemphasis\b/gi, "")
    .replace(/\brider-free\b|\bmotorbike-free\b/gi, "open")
    .replace(/\bappetizing but\b/gi, "warm")
    .replace(/\bcinematic but\b/gi, "cinematic")
    .replace(/\bsunny but natural\b/gi, "sunny")
    .replace(/\blaptop-free\b/gi, "bright")
    .replace(/\bwith sea in\b/gi, "with sea beyond")
    .replace(/\bsafe riverfront distance\b/gi, "riverfront promenade")
    .replace(/^wide morning view of\s+/i, "broad morning view of ")
    .replace(/\bLandmark 81 in\b/gi, "Landmark 81 nearby")
    .replace(/\bmountains faint in\b/gi, "faint mountains beyond")
    .replace(/\btravel style\b/gi, "")
    .replace(/\bsculpture\/art\b/gi, "sculpture and art")
    .replace(/,\s*travel\b/gi, "")
    .replace(/,\s*labels\b/gi, "")
    .replace(/\blabels\b/gi, "")
    .replace(/\binvented artwork\b/gi, "optical-illusion gallery rooms")
    .replace(/,\s*family-friendly\b/gi, "")
    .replace(/,\s*Vietnamese\s*$/gi, "");
}

function removeLeadLogistics(value) {
  return String(value ?? "")
    .replace(/\b(pickup|pick-up)\b/gi, "arrival")
    .replace(/\bdriver\b/gi, "ride")
    .replace(/\bticket windows\b/gi, "station windows")
    .replace(/\btickets?\b/gi, "visit")
    .replace(/\bentrance\b/gi, "entry area")
    .replace(/\bbathroom\b/gi, "comfort")
    .replace(/\bterminal\b/gi, "arrival hall")
    .replace(/\btrain platform\b/gi, "station platform")
    .replace(/\bluggage\b/gi, "bags")
    .replace(/\bbill\b/gi, "meal ending")
    .replace(/\bpayment\b/gi, "checkout")
    .replace(/\bcash\b/gi, "market money")
    .replace(/\bprice\b/gi, "shopping")
    .replace(/\bATM\b/g, "cash stop")
    .replace(/\breturn ride\b|\bride back\b/gi, "return route")
    .replace(/\bdrop-off\b/gi, "arrival")
    .replace(/\btransfer\b/gi, "next leg");
}

function trimSentence(value) {
  return removeLeadLogistics(removePhotoPromptLanguage(value))
    .replace(/\s*,\s*(?:,|\.)/g, ".")
    .replace(/\s*,\s*(?:\.)/g, ".")
    .replace(/\.\s*((?:natural|warm|soft|clean|clear|golden)\s+(?:morning\s+|late afternoon\s+|daytime\s+)?(?:daylight|light)|natural late afternoon)\b/gi, ", $1")
    .replace(/\s*;\s*/g, ", ")
    .replace(/\s*,\s*,+/g, ",")
    .replace(/\s*\(\s*\)/g, "")
    .replace(/\s+/g, " ")
    .replace(/\s+,/g, ",")
    .replace(/\bwith\s*,/gi, "with")
    .replace(/,\s*(?:and\s*)?\./g, ".")
    .replace(/,\s*$/g, "")
    .replace(/\s+\./g, ".")
    .trim();
}

function normalizedLower(value) {
  return String(value ?? "")
    .normalize("NFC")
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase();
}

function stripUtilityLead(value) {
  return trimSentence(value)
    .replace(/(?:^|(?<=[.!?])\s+)\b(useful|helps?|use this|say the name|keep|confirm|ask|pair it|name clearly|ready)\b[^.]*\./gi, "")
    .replace(/(?:^|(?<=[.!?])\s+)\b(driver|pickup|ticket|entrance|bathroom|water|timing|ride back|return ride)\b[^.]*\./gi, "")
    .replace(/\s+/g, " ")
    .trim();
}

function cleanMeaning(value, fallback) {
  const cleaned = trimSentence(value)
    .replace(/\bfor (?:drivers?|rides?|hotels?|staff|ticket counters?|map orientation)[^.]*\.?/gi, "")
    .replace(/\bclear .*?name\b/gi, "recognizable name")
    .replace(/\bpractical\b/gi, "grounded")
    .replace(/\s+/g, " ")
    .trim();
  const lower = cleaned.toLowerCase();
  const practicalHits = (lower.match(/\b(driver|pickup|ticket|entrance|bathroom|terminal|luggage|platform|bill|payment)\b/g) || []).length;
  if (!cleaned || cleaned.length < 30 || practicalHits > 1) return fallback;
  return cleaned.replace(/\.$/, "");
}

function clause(value) {
  return String(value ?? "")
    .replace(/\.$/, "")
    .replace(/^where\s+/i, "")
    .replace(/^this\s+/i, "")
    .replace(/^the part of [^ ]+ where\s+/i, "")
    .trim();
}

function lowerFirst(value) {
  const text = String(value ?? "").trim();
  if (!text) return text;
  if (/^[A-Z]{2,}/.test(text)) return text;
  if (/^(West Lake|Hoan Kiem|Hanoi|Da Nang|Saigon|Hoi An|Hue|Ba Dinh|Ben Thanh|Old Quarter|Turtle Tower|Landmark 81)\b/.test(text)) return text;
  return text.charAt(0).toLowerCase() + text.slice(1);
}

function upperFirst(value) {
  const text = String(value ?? "").trim();
  if (!text) return text;
  return text.charAt(0).toUpperCase() + text.slice(1);
}

function sentence(value, fallback) {
  const cleaned = trimSentence(value);
  if (!cleaned) return fallback;
  return cleaned.endsWith(".") ? cleaned : `${cleaned}.`;
}

function pageTitle(page) {
  return (page.englishText || page.editorialImport?.englishTitle || page.id)
    .replace(/^St\.\s+/i, "Saint ");
}

function vietnameseName(page) {
  return page.targetText || page.editorialImport?.title || page.id;
}

function pageSearchText(page) {
  return [
    page.id,
    page.englishText,
    page.targetText,
    page.placeKind,
    page.pageKind,
    page.contentRole,
  ]
    .filter(Boolean)
    .join(" ")
    .toLowerCase();
}

function metadataKindForProfile(profile, page) {
  const key = profile.key;
  const titleText = `${page.id} ${page.englishText || ""} ${page.targetText || ""}`.toLowerCase();
  if (key === "cafe") return "cafe";
  if (key === "restaurant") return "restaurant";
  if (key === "dish") return "dish";
  if (key === "museum") return "museum";
  if (key === "street") return "street";
  if (key === "route") return "experience";
  if (key === "performance" || key === "workshop" || key === "craft" || key === "boatExperience") return "experience";
  if (key === "gallery" || key === "rooftop" || key === "fountainSquare") return "attraction";
  if (key === "lake" || key === "canal") return "nature";
  if (key === "drink" || key === "dessert") return key;
  if (key === "mall" || key === "retailMarket" || key === "flowerMarket" || key === "nightMarket" || key === "tailor") return "market";
  if (key === "sacred" || key === "heritage" || key === "memorial") return "landmark";
  if (/theatre|theater|circus|múa rối|tuồng|show|opera/.test(titleText)) return "experience";
  if (/lake|hồ /.test(titleText)) return "nature";
  if (/canal|kênh/.test(titleText)) return "nature";
  return page.placeKind;
}

function applyMetadataAlignment(page, profile) {
  const place = page.placeID ? placeByID.get(page.placeID) : null;
  const placeKind = metadataKindForProfile(profile, page);
  if (placeKind && placeKind !== page.placeKind) {
    page.placeKind = placeKind;
  }
  if (place && placeKind) {
    place.kind = placeKind;
    place.placeKind = placeKind;
  }
  if (profile.key === "drink" || profile.key === "dessert") {
    page.pageKind = profile.key;
    page.placeKind = profile.key;
    page.contentRole = profile.key;
    if (place) {
      place.kind = profile.key;
      place.placeKind = profile.key;
      place.contentRole = page.contentRole;
    }
  } else if (placeKind === "dish") {
    page.pageKind = "dish";
    page.contentRole = profile.key === "drink" ? "drink" : profile.key === "dessert" ? "dessert" : "dish";
    if (place) place.contentRole = page.contentRole;
  } else if (placeKind === "restaurant" || placeKind === "cafe") {
    page.pageKind = "restaurant";
    page.contentRole = placeKind === "cafe"
      ? "cafe"
      : ["dish", "drink", "dessert"].includes(page.contentRole) ? "everyday" : page.contentRole || "everyday";
    if (place) place.contentRole = page.contentRole;
  } else if (page.kind !== "phrase") {
    page.pageKind = "place";
    delete page.contentRole;
    if (place) delete place.contentRole;
  }
}

function kindFor(page) {
  const text = pageSearchText(page);
  const cafeHopText = /coffee-hop|coffee hop|cafe-hop|cafe hop|đi cà phê|di ca phe/.test(text);
  const coffeeStreetText = /coffee-street|coffee street|phố cà phê|pho ca phe/.test(text);
  const namedFoodVenueText = /place-(?:banh-xeo-ba-duong|banh-mi-huynh-hoa|banh-xeo-46a|com-tam-ba-ghien|banh-mi-phuong)\b/.test(text);
  const foodDishText = /place-(?:banh-mi|banh-xeo|bo-la-lot|bot-chien|bun-thit-nuong|com-tam|goi-cuon|hu-tieu|oc|pha-lau|pho-nam)\b|bánh mì|banh mi|bánh xèo|banh xeo|bò lá lốt|bo la lot|bột chiên|bot chien|bún thịt nướng|bun thit nuong|cơm tấm|com tam|gỏi cuốn|goi cuon|hủ tiếu|hu tieu|phá lấu|pha lau|southern pho|snails and seafood/.test(text);
  const drinkOrDessertName = /egg coffee|iced milk coffee|cà phê sữa đá|ca phe sua da|cà phê trứng|ca phe trung|fresh beer|bia hơi|bia hoi|sweet soup|chè|che\b|dessert|ice cream|kem\b|pudding|jelly|sesame candy|mè xửng|me xung|herbal drink|mót|mot herbal/.test(text);
  const cafeVenueText =
    !drinkOrDessertName &&
    /\bcafe\b|\bcafé\b|cà phê|ca phe|coffee roaster|coffee shop|tea house|bistro/.test(text);
  const inferred = [
    [/from-danang-(airport|railway-station)|for hoi an|đi hội an/, "transferRoute"],
    [/waterbus|boat-station|boat station|toa-kham|tòa khâm|bến thuyền|river landing/, "waterPier"],
    [/basket boat|dragon boat|snorkel boat|river boat|cruise|boat\b|thuyền/, "boatExperience"],
    [/turtle lake|hồ con rùa|ho con rua/, "fountainSquare"],
    [/canal|kênh|kenh/, "canal"],
    [/lake|hồ tây|truc bach|trúc bạch|bay mau lake|bảy mẫu lake/, "lake"],
    [/museum|bảo tàng|bao tang/, "museum"],
    [/circus|theatre|theater|tuong|tuồng|water puppet|múa rối|lune|show|a o show|à ố|nha nhac|nhã nhạc|duyet thi duong|duyệt thị đường|performance|performing-art|traditional-art-performance|opera/, "performance"],
    [/mausoleum|lăng bác|lăng chủ tịch/, "memorial"],
    [/coffee-street|coffee street|phố cà phê|pho ca phe/, "street"],
    [/coffee-hop|coffee hop|cafe-hop|cafe hop|đi cà phê|di ca phe/, "route"],
    [/cà phê|ca phe|iced milk coffee|coffee drink|bia hơi|bia hoi|fresh beer|beer\b|trà đá|tra da|sugarcane juice|nước mía|nuoc mia|herbal drink|mót|mot herbal/, "drink"],
    [/chè|che\b|sweet soup|dessert|ice cream|kem\b|pudding|jelly|sesame candy|mè xửng|me xung/, "dessert"],
    [/bia hoi|bia hơi|ta hien|tạ hiện|beer street|nightlife/, "nightlifeStreet"],
    [/street-food walk|street food walk|food tour|food evening|street-food evening/, "foodWalk"],
    [/42-nguyen-hue|42 nguyen hue|apartment facade|cafe-filled apartment/, "cafe"],
    [/3d-art|3d art|optical-illusion|art in paradise/, "experience"],
    [/manzi|art-space|art space|vietnam-art-gallery|vietnam art gallery|songlab|sốnglab|sống platform|digital art/, "gallery"],
    [/cooking class|lantern-making|making class|class\b|handicraft-workshop|craft workshop/, "workshop"],
    [/flower-market|flower market|hồ thị kỷ|ho thi ky/, "flowerMarket"],
    [/night market|chợ đêm/, "nightMarket"],
    [/tràng tiền plaza|trương tiền plaza|trang tien plaza|truong tien plaza|takashimaya|vincom|lotte mart|saigon centre|shopping-center|shopping center|\bmall\b|\bplaza\b/, "mall"],
    [/\ban dong\b|\ban đông\b|russian market|chợ nga|saigon square|fabric market|clothing market|shopping market/, "retailMarket"],
    [/tailor|couture|fitting|metiseko|bebe|yaly|boutique|làng lụa|silk village/, "tailor"],
    [/rooftop|skydeck|sky deck|landmark 81|viewpoint|observation|tower view/, "rooftop"],
    [/củ chi|cu chi|tunnels/, "historicSite"],
    [/walking route|walking tour|walk\b|loop|food tour|cafe hop|coffee hop|ride\b|bicycle|cyclo|motorbike|day trip/, "route"],
    [/national park|bạch mã|bach ma/, "nationalPark"],
    [/pagoda|temple|cathedral|church|đền|chùa|nhà thờ/, "sacred"],
    [/imperial|citadel|palace|gate|tomb|flag tower|old house|assembly hall|sanctuary|heritage|opera house/, "heritage"],
    [/pottery|carpentry|workshop|handicraft|craft|incense|weaving|ceramic|mộc|gốm|thủ công/, "craft"],
  ].find(([pattern]) => pattern.test(text))?.[1];
  const base =
    (kindProfiles[page.placeKind] ? page.placeKind : undefined) ||
    (kindProfiles[page.pageKind] ? page.pageKind : undefined) ||
    "landmark";
  if (namedFoodVenueText) return { ...kindProfiles.restaurant, key: "restaurant" };
  if (cafeHopText) return { ...kindProfiles.route, key: "route" };
  if (coffeeStreetText) return { ...kindProfiles.street, key: "street" };
  if (foodDishText) return { ...kindProfiles.dish, key: "dish" };
  if (cafeVenueText) return { ...kindProfiles.cafe, key: "cafe" };
  const strongInferences = new Set(["canal", "fountainSquare", "gallery", "workshop", "performance", "museum"]);
  const weakInferences = new Set(["mall", "tailor", "craft", "performance"]);
  const key = inferred && (strongInferences.has(inferred) || !(weakInferences.has(inferred) && ["station", "street", "dish", "museum", "park", "cafe", "restaurant", "village", "neighborhood", "port", "river", "landmark"].includes(base))) ? inferred : base;
  return { ...kindProfiles[key], key };
}

function oneLineScene(value) {
  return upperFirst(
    trimSentence(value)
      .replace(/\s*\.\s*$/, "")
      .replace(/\s*,\s*$/, "")
      .replace(/\bwith\s*\.\s*/gi, "")
      .trim()
  );
}

function pictureLead(scene, title) {
  const cleaned = oneLineScene(scene);
  if (!cleaned) return cleaned;
  if (cleaned.startsWith(title)) return cleaned;
  if (/^(Hue|Hanoi|Da Nang|Saigon|Hoi An|Vietnam|Vietnamese|Old Quarter)\b/.test(cleaned)) return cleaned;
  const titleTokens = String(title).split(/\s+/).filter(Boolean);
  const genericTitleWords = new Set(["Museum", "City", "Street", "Market", "Temple", "Pagoda", "Bridge", "Tower", "Station", "Airport", "Lake", "River", "Restaurant", "Cafe"]);
  const titleWords = new Set(titleTokens.filter((word) => word.length > 2 && !genericTitleWords.has(word)));
  const firstWord = cleaned.split(/\s+/)[0]?.replace(/[^\p{L}\p{N}-]/gu, "") || "";
  if (titleTokens[0] === firstWord) return cleaned;
  if (titleWords.has(firstWord)) return cleaned;
  return lowerFirst(cleaned);
}

function adaptSceneForProfile(scene, profile) {
  let text = oneLineScene(scene);
  text = text
    .replace(/^photorealistic\s+/i, "")
    .replace(/^close-up\s+of\s+/i, "")
    .replace(/^of\s+/i, "")
    .replace(/\btravel documentary style\b/gi, "")
    .replace(/\btraveler-level\b/gi, "from a visitor's eye level")
    .replace(/,\s*street-level(?: view)?(?: travel perspective)?\b/gi, "")
    .replace(/\bstreet-level(?: view)?(?: travel perspective)?\b/gi, "from a visitor's eye level")
    .replace(/\bno-brand\b/gi, "")
    .replace(/\bbook-themed interior hint\b/gi, "book-themed gallery rooms")
    .replace(/\binterior hint\b/gi, "interior details")
    .replace(/\bbutcher counters in,\s*/gi, "butcher counters, ")
    .replace(/\bstreet feel\b/gi, "street atmosphere")
    .replace(/\bclean daylight\b/gi, "daylight")
    .replace(/\brespectful daylight\b/gi, "quiet daylight")
    .replace(/\brespectful distance,\s*/gi, "")
    .replace(/,\s*(?:soft|warm|clean|quiet|respectful|natural)\s+daylight\b/gi, "")
    .replace(/,\s*daylight\b/gi, "")
    .replace(/,\s*natural light\b/gi, "")
    .replace(/,\s*natural (?:morning|late afternoon|evening)\b/gi, "")
    .replace(/,\s*soft (?:morning|late afternoon|evening) light\b/gi, "")
    .replace(/,\s*sunrise haze\b/gi, " at sunrise")
    .replace(/\bsoft white walls\b/gi, "quiet white gallery walls")
    .replace(/\bno-train\b/gi, "")
    .replace(/\s*,\s*,/g, ",")
    .replace(/\s*,\s*$/g, "")
    .trim();
  if (profile.key === "flowerMarket") {
    text = text
      .replace(/\band food stalls\b/gi, "and late-night street color")
      .replace(/\bfood stalls\b/gi, "flower stalls");
  }
  if (profile.key === "retailMarket" || profile.key === "mall" || profile.key === "tailor") {
    text = text
      .replace(/\bproduce\b/gi, "goods")
      .replace(/\bsnacks\b/gi, "small shops")
      .replace(/\bfood stalls\b/gi, "shop counters");
  }
  return oneLineScene(text);
}

function visualCue(page, profile, city) {
  if (profile.key === "transferRoute") {
    if (/railway|station|ga /i.test(pageSearchText(page))) {
      return `station doors giving way to roads, river bridges, fields, luggage, and the first approach toward ${city.name}`;
    }
    return `Da Nang airport doors giving way to roads, river bridges, fields, luggage, and the first approach toward ${city.name}`;
  }
  if (profile.key === "waterPier") {
    return `river steps, boat noses, skyline edges, and the change from street movement to water movement`;
  }
  if (["airport", "station", "port", "pier"].includes(page.placeKind) && !["lake", "boatExperience"].includes(profile.key)) {
    const transitScenes = {
      airport: [
        `arrival doors, warm air, first city signs, and the road toward ${city.name}`,
        `glass doors, city light outside, waiting families, and the first turn toward ${city.name}`,
        `the airport threshold where the trip turns from itinerary into street light and traffic`,
        `terminal doors, warm air, local signs, and the first road into the city`,
      ],
      station: [
        `station facade, route boards, waiting benches, and local streets just outside`,
        `station awnings, city signs, luggage, and the first view back into ${city.name}`,
        `station awnings, ticket windows, local signs, and the city just outside the doors`,
        `${city.name} station light, local signs, shaded benches, and onward streets`,
      ],
      port: [
        `waterfront boarding, sea air, and the move between city streets and island routes`,
        `ferry edges, ticket windows, boat sounds, and the open-water side of the trip`,
        `port gates, coastal light, and the point where the city turns toward water`,
      ],
      pier: [
        `boarding steps, boat noses, river light, and the pause before the day moves onto water`,
        `waterfront edges, small boats, handrails, and the change from street rhythm to river rhythm`,
        `river steps, boat sounds, waiting passengers, and the city seen from the waterline`,
      ],
    };
    return pick(transitScenes[page.placeKind] || [profile.scene], `${page.id}:transit-scene`);
  }
  const imageCue = trimSentence(page.editorialImport?.imagePromptNote || page.productionIntake?.imagePromptNote);
  if (imageCue && imageCue.length > 18) {
    return adaptSceneForProfile(imageCue, profile);
  }
  const sourceCue = stripUtilityLead(page.context) || stripUtilityLead(page.tip) || stripUtilityLead(page.rationale);
  if (sourceCue && sourceCue.length > 18) {
    return adaptSceneForProfile(sourceCue, profile);
  }
  return `${profile.scene} in ${city.name}`;
}

function sourceMeaning(page, profile, city) {
  return cleanMeaning(pageOverrides[page.id]?.meaning || profile.meaning, profile.meaning).replace(/\.$/, "");
}

function belongsFor(page, profile, city) {
  const title = pageTitle(page);
  const scene = oneLineScene(visualCue(page, profile, city));
  const sceneLead = pictureLead(scene, title);
  const sceneSentence = upperFirst(sceneLead);
  const texture = textureFor(page, profile, city, "belongs");
  const role = contextSurface(profile);
  const article = articleFor(role);
  const meaning = isSesameCandyPage(page)
    ? "Hue's sesame-candy tradition: chewy sweetness, roasted sesame, peanuts, tea, and old-capital gift counters"
    : profile.meaning;
  const openings = [
    `${sceneSentence} gives ${title} a concrete travel image, grounded in ${texture}.`,
    `With ${title}, the trip takes in ${meaning} through ${texture}.`,
    `What stands out is ${meaning}, set against ${texture}.`,
    `${sceneSentence} brings out ${meaning} through ${texture}.`,
    `Around ${title}, ${texture} make ${meaning} easier to feel.`,
    `The scene is ${sceneLead}; the reason to care is ${meaning}.`,
    `With ${title}, ${city.name} gains another layer: ${texture} and ${meaning}.`,
  ];
  return pick(openings, `${page.id}:belongs-open`);
}

function summaryFor(page, profile, city) {
  if (pageOverrides[page.id]?.summary) return pageOverrides[page.id].summary;
  const title = pageTitle(page);
  const scene = oneLineScene(visualCue(page, profile, city));
  const key = profile.key || page.placeKind || page.pageKind;
  const openerSets = {
    dish: [
      `With ${title}, ${city.name} becomes something the traveler can taste: ${scene}.`,
      `This dish gives the trip a flavor to imagine before arrival: ${scene}.`,
      `With ${title}, the trip gets a flavor to imagine before arrival: ${scene}.`,
    ],
    drink: [
      `With ${title}, ${city.name} gets a drink memory before arrival: ${scene}.`,
      `With ${title}, the city becomes something cold, sweet, strong, or social to imagine: ${scene}.`,
      `This drink turns a cafe, stool, or street pause into part of the trip: ${scene}.`,
    ],
    dessert: [
      `With ${title}, ${city.name} gets a sweet texture to imagine: ${scene}.`,
      `This dessert turns color, ice, coconut, and jelly into a city memory: ${scene}.`,
      `With ${title}, the trip gets a sweet stop between streets, markets, and evening walks: ${scene}.`,
    ],
    cafe: [
      `With ${title}, ${city.name} gets a coffee pause: ${scene}.`,
      `${title} is a small pause in the trip: ${scene}.`,
      `${title} turns cafe culture into a scene the traveler can picture: ${scene}.`,
    ],
    restaurant: [
      `${title} turns ${city.name} into a meal: ${scene}.`,
      `${title} gives the trip a restaurant scene to imagine before arrival: ${scene}.`,
      `${title} makes a meal feel like part of the itinerary: ${scene}.`,
    ],
    market: [
      `${title} shows ${city.name} at street level: ${scene}.`,
      `${title} brings the market side of ${city.name} into focus: ${scene}.`,
      `With ${title}, the trip has color, food, browsing, and everyday rhythm: ${scene}.`,
    ],
    retailMarket: [
      `${title} shows the shopping side of ${city.name}: ${scene}.`,
      `${title} is a browsing scene to imagine before the trip: ${scene}.`,
      `${title} turns clothes, counters, fabric, and gifts into a city moment: ${scene}.`,
    ],
    flowerMarket: [
      `With ${title}, ${city.name} gets color and scent: ${scene}.`,
      `${title} turns the market into flowers, gifts, and street energy: ${scene}.`,
      `${title} makes the city feel bright before the day even starts: ${scene}.`,
    ],
    mall: [
      `${title} shows the modern indoor side of ${city.name}: ${scene}.`,
      `${title} is a cool-air pause between outdoor sights: ${scene}.`,
      `${title} makes shopping, food counters, and meetups part of the city picture: ${scene}.`,
    ],
    tailor: [
      `${title} brings Hoi An's tailoring culture into focus: ${scene}.`,
      `${title} turns fabric, fittings, and old-town shopfronts into a keepsake scene: ${scene}.`,
      `${title} makes the custom-made side of Hoi An easy to picture: ${scene}.`,
    ],
    craft: [
      `This craft stop makes local craft visible: ${scene}.`,
      `This craft stop brings hands, tools, and materials into the trip: ${scene}.`,
      `${title} turns craft into something visible and local: ${scene}.`,
    ],
    workshop: [
      `${title} lets the traveler picture taking part: ${scene}.`,
      `${title} turns making, cooking, or craft into a trip moment: ${scene}.`,
      `With ${title}, ${city.name} gets a hands-on scene: ${scene}.`,
    ],
    lake: [
      `With ${title}, ${city.name} gets a slower waterline: ${scene}.`,
      `${title} makes the city feel walkable around water: ${scene}.`,
      `${title} is a lake scene to imagine before the streets get busy: ${scene}.`,
    ],
    river: [
      `With ${title}, ${city.name} gets a line of water to follow: ${scene}.`,
      `${title} organizes the city through boats, bridges, and reflections: ${scene}.`,
      `${title} gives the trip a clear river image: ${scene}.`,
    ],
    canal: [
      `With ${title}, ${city.name} gets a softer water route to picture: ${scene}.`,
      `${title} turns canal bridges and neighborhood edges into a city scene: ${scene}.`,
      `${title} makes everyday water movement easy to picture: ${scene}.`,
    ],
    fountainSquare: [
      `${title} turns a traffic landmark into a social city scene: ${scene}.`,
      `With ${title}, Saigon gets a fountain, snack, and meetup image to remember: ${scene}.`,
      `${title} makes a busy roundabout feel like part of local street life: ${scene}.`,
    ],
    waterPier: [
      `${title} is where the city shifts from street to river: ${scene}.`,
      `With ${title}, the waterfront becomes a vivid threshold: ${scene}.`,
      `${title} turns boarding a boat into a city scene: ${scene}.`,
    ],
    boatExperience: [
      `${title} puts the traveler on the water: ${scene}.`,
      `${title} changes the pace of the day through boats and water light: ${scene}.`,
      `${title} makes the river or sea part of the memory: ${scene}.`,
    ],
    performance: [
      `${title} turns culture into a live night-out scene: ${scene}.`,
      `With ${title}, ${city.name} gets stage light, sound, and movement: ${scene}.`,
      `${title} makes performance culture feel present before the traveler arrives: ${scene}.`,
    ],
    route: [
      `${title} turns movement around ${city.name} into the experience: ${scene}.`,
      `${title} connects small stops into a city route the traveler can imagine: ${scene}.`,
      `${title} makes the day feel like a walk, ride, or route instead of a loose list: ${scene}.`,
    ],
    rooftop: [
      `With ${title}, ${city.name} gets a view from above: ${scene}.`,
      `${title} turns the skyline into a memory before arrival: ${scene}.`,
      `${title} lets the traveler picture the city as light, height, and orientation: ${scene}.`,
    ],
    sacred: [
      `${title} brings the sacred side of ${city.name} into focus: ${scene}.`,
      `${title} slows the trip down through worship, architecture, and quiet: ${scene}.`,
      `${title} turns a spiritual stop into a scene the traveler can respect and remember: ${scene}.`,
    ],
    heritage: [
      `${title} makes ${city.name}'s history visible: ${scene}.`,
      `${title} gives old-city history a clear scene: ${scene}.`,
      `${title} turns history into a place the traveler can actually picture: ${scene}.`,
    ],
    nationalPark: [
      `${title} opens the trip beyond the city: ${scene}.`,
      `${title} brings mountain forest and cooler air into the Vietnam plan: ${scene}.`,
      `${title} turns a nature day trip into something visual before arrival: ${scene}.`,
    ],
    memorial: [
      `With ${title}, ${city.name} gets a formal civic memory to approach respectfully: ${scene}.`,
      `${title} turns national history into a quiet public scene: ${scene}.`,
      `${title} asks for a slower kind of attention in the trip: ${scene}.`,
    ],
    nightlifeStreet: [
      `${title} shows ${city.name} after dark: ${scene}.`,
      `With ${title}, the trip has an evening street scene to imagine: ${scene}.`,
      `${title} turns drinks, food, lights, and old streets into a social city moment: ${scene}.`,
    ],
    foodWalk: [
      `${title} turns appetite into a route across ${city.name}: ${scene}.`,
      `${title} makes food discovery feel like a walk across the city: ${scene}.`,
      `${title} connects small tables and street corners into one city experience: ${scene}.`,
    ],
    transferRoute: [
      `${title} is the route where the imagined trip starts becoming real: ${scene}.`,
      `${title} turns arrival into the first approach toward ${city.name}: ${scene}.`,
      `${title} is not the destination, but it is the threshold into it: ${scene}.`,
    ],
  };
  const openers = openerSets[key] || [
    `${title} adds this ${profile.surface} image to ${city.name}: ${scene}.`,
    `${title} brings this part of ${city.name} into view: ${scene}.`,
    `${title} gives the trip a named scene: ${scene}.`,
    `${title} gives ${city.name} a concrete travel image: ${scene}.`,
    `${title} brings this part of ${city.name} into view: ${scene}.`,
    `${title} turns an abstract name into a scene: ${scene}.`,
    `${title} gives the itinerary a vivid point of reference: ${scene}.`,
    `${title} carries the city picture through ${pictureLead(scene, title)}.`,
    `${title} becomes memorable through ${pictureLead(scene, title)}.`,
  ];
  if (["airport", "station", "port", "pier"].includes(page.placeKind) && key === page.placeKind) {
    return `${title} is where ${city.name} starts to feel real: ${scene}. ${belongsFor(page, profile, city)}`;
  }
  return `${pick(openers, page.id)} ${belongsFor(page, profile, city)}`;
}

function summaryLeadFor(page, profile, city) {
  if (pageOverrides[page.id]?.summary) return pageOverrides[page.id].summary;
  const title = pageTitle(page);
  const scene = pictureLead(visualCue(page, profile, city), title);
  const meaning = sourceMeaning(page, profile, city);
  const frames = {
    dish: `${title} is worth trying in ${city.name} because it gives the trip a flavor to imagine before arrival. Expect ${scene}.`,
    drink: `${title} is worth knowing in ${city.name} because drink culture is part pause, part local rhythm. Expect ${scene}.`,
    dessert: `${title} is worth trying in ${city.name} for sweetness, texture, color, and a small break between bigger plans. Expect ${scene}.`,
    cafe: `${title} is worth saving for ${city.name}'s cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect ${scene}.`,
    restaurant: `${title} is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect ${scene}.`,
    market: `${title} is worth browsing because it shows ${city.name} through stalls, snacks, goods, color, and everyday buying rhythm. Expect ${scene}.`,
    street: `${title} is worth recognizing because a named street can make ${city.name} feel walkable before arrival. Expect ${scene}.`,
    neighborhood: `${title} is worth recognizing because neighborhoods turn ${city.name} from landmarks into lived-in areas. Expect ${scene}.`,
    airport: `${title} is worth recognizing because it is where the planned trip first becomes ${city.name}. Expect ${scene}.`,
    station: `${title} is worth recognizing because travel days still carry the mood of ${city.name}. Expect ${scene}.`,
    port: `${title} is worth recognizing because it opens ${city.name} toward water, crossings, islands, or the next route. Expect ${scene}.`,
    museum: `${title} is worth a stop if you want ${city.name} to feel more layered than the streets outside. Expect ${scene}.`,
    heritage: `${title} is worth visiting because it makes history physical through architecture, gates, courtyards, and memory. Expect ${scene}.`,
    sacred: `${title} is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect ${scene}.`,
    beach: `${title} is worth picturing because it changes the trip into coastal Vietnam: sea air, sand, seafood, and open light. Expect ${scene}.`,
    river: `${title} is worth knowing because water helps organize ${city.name}: bridges, reflections, banks, boats, and evening light. Expect ${scene}.`,
  };
  return frames[profile.key] || `${title} is worth knowing in ${city.name} because it brings ${meaning} into the trip. Expect ${scene}.`;
}

function aboutFor(page, profile, city) {
  if (pageOverrides[page.id]?.about) return pageOverrides[page.id].about;
  const title = pageTitle(page);
  const scene = oneLineScene(visualCue(page, profile, city));
  const frames = [
    `At ${title}, notice ${pictureLead(scene, title)}.`,
    `For ${title}, picture ${pictureLead(scene, title)} before the trip begins.`,
    `For ${title}, picture ${pictureLead(scene, title)}.`,
    `${title} becomes more vivid through ${pictureLead(scene, title)}.`,
    `${title} becomes concrete through ${pictureLead(scene, title)}.`,
    `The scene around ${title} comes into focus through ${pictureLead(scene, title)}.`,
    `${city.name} becomes more specific at ${title}: ${pictureLead(scene, title)}.`,
    `For ${title}, the ${profile.surface} detail is worth a closer look: ${pictureLead(scene, title)}.`,
    `Before arrival, ${title} can have a clear image: ${scene}.`,
    `Before the traveler lands, ${title} can already feel like ${pictureLead(scene, title)}.`,
    `${title} invites a visual read first: ${pictureLead(scene, title)}.`,
    `${title} opens this part of ${city.name}: ${pictureLead(scene, title)}.`,
    `What makes ${title} easy to imagine: ${pictureLead(scene, title)}.`,
    `${title} starts as a travel image: ${pictureLead(scene, title)}.`,
    `${title} has a sensory first read: ${pictureLead(scene, title)}.`,
  ];
  return pick(frames, `${page.id}:about`);
}

function hearNameFor(page, profile, city) {
  if (pageOverrides[page.id]?.hear) return pageOverrides[page.id].hear;
  const title = pageTitle(page);
  const target = vietnameseName(page);
  const scene = oneLineScene(visualCue(page, profile, city));
  const sceneLead = pictureLead(scene, title);
  const texture = textureFor(page, profile, city, "hear");
  const frames = [
    `Hear ${target} with ${sceneLead} in view.`,
    `Hear ${target} while picturing ${sceneLead}.`,
    `The sound of ${target} sits next to ${sceneLead}.`,
    `The audio for ${target} belongs beside ${sceneLead}.`,
    `${target} sounds more grounded with ${sceneLead} in mind.`,
    `The rhythm of ${target} connects back to ${texture}.`,
    `Hear ${target} before arrival with ${sceneLead} in mind.`,
    `Hear ${target} while picturing ${sceneLead}.`,
    `The audio stays connected to a specific scene: ${sceneLead}.`,
    `${target} stays connected to a specific scene: ${sceneLead}.`,
    `${target} sits close to the image of ${sceneLead}.`,
    `Hear ${target} as part of this scene: ${sceneLead}.`,
    `The audio for ${target} feels clearer when the traveler can already picture ${sceneLead}.`,
  ];
  return pick(frames, `${page.id}:hear`);
}

function pictureFor(page, profile, city) {
  if (pageOverrides[page.id]?.picture) return pageOverrides[page.id].picture;
  const title = pageTitle(page);
  const cue = pictureLead(visualCue(page, profile, city), title);
  const texture = textureFor(page, profile, city, "picture");
  const textureSentence = upperFirst(texture);
  const stop = profile.key === "dish" ? "the dish" : profile.key === "drink" ? "the drink" : profile.key === "dessert" ? "the dessert" : "the stop";
  const frames = [
    `Picture ${cue}. Around it, the details are ${texture}; the trip can start to picture ${title} with those details.`,
    `Picture ${cue}. ${textureSentence} frame the way ${title} appears in the itinerary.`,
    `Picture ${cue}. The surrounding ${texture} connect ${title} to the city.`,
    `Picture ${cue}. ${title} feels more rooted in the city beside ${texture}.`,
    `Picture ${cue}. That image for ${title} works best with ${texture}.`,
    `Picture ${cue}. ${textureSentence} make ${title} feel rooted in the day.`,
    `Picture ${cue}. Around ${title}, ${texture} fill the scene.`,
    `Picture ${cue}. The memory around ${title} can include ${texture}.`,
    `Picture ${cue}. Around it, notice ${texture}; that setting makes ${title} easier to recognize later.`,
    `Picture ${cue}. ${title} stays with ${texture}.`,
    `Picture ${cue}. Those details give ${title} context before arrival: ${texture}.`,
    `Picture ${cue}. ${title} stays connected with ${texture}.`,
    `Picture ${cue}. The surrounding ${texture} make ${title} easier to place in the trip.`,
    `Picture ${cue}. ${title} keeps its place in the day through ${texture}.`,
    `Picture ${cue}. The image of ${title} feels richer when the mind also has ${texture}.`,
    `Picture ${cue}. That scene around ${title} can travel with ${texture} before arrival.`,
  ];
  return pick(frames, `${page.id}:picture`);
}

function meaningFor(page, profile, city) {
  if (pageOverrides[page.id]?.meaning) return pageOverrides[page.id].meaning;
  const title = pageTitle(page);
  const scene = oneLineScene(visualCue(page, profile, city));
  const texture = textureFor(page, profile, city, "meaning");
  const meaning = isSesameCandyPage(page)
    ? "Hue's sesame-candy tradition: chewy sweetness, roasted sesame, peanuts, tea, and old-capital gift counters"
    : profile.meaning;
  const frames = [
    `At ${title}, the scene brings ${meaning} into view: ${scene}.`,
    `At ${title}, notice ${scene} as ${meaning}.`,
    `For ${title}, notice the surrounding details: ${meaning}.`,
    `${title} connects to ${meaning} through ${scene}.`,
    `At ${title}, ${city.name} brings ${meaning} into view.`,
    `${title} belongs here because ${scene} points to ${meaning} before arrival.`,
    `${title} becomes easier to remember when it stays tied to ${scene}.`,
    `What gives ${title} weight is ${meaning}, grounded in ${scene}.`,
    `At ${title}, the itinerary gains ${meaning}.`,
    `With ${title}, this becomes easier to picture: ${meaning}.`,
    `For a curious traveler, ${title} opens a way to see ${meaning} before the trip begins.`,
    `${title} sits inside ${city.name}'s lived texture: ${meaning}.`,
  ];
  return pick(frames, `${page.id}:meaning`);
}

function practicalFor(page, profile, city) {
  if (pageOverrides[page.id]?.practical) return pageOverrides[page.id].practical;
  const title = pageTitle(page);
  const target = vietnameseName(page);
  const descriptor = normalizedLower([
    page.id,
    page.placeID,
    page.title,
    page.englishTitle,
    page.englishText,
    page.localName,
    page.vietnameseText,
  ].filter(Boolean).join(" "));
  const momentsBySurface = {
    arrival: "arrival halls, signs, luggage, city light, and the first handoff into the street",
    station: "platforms, route boards, waiting benches, luggage, and the city outside the station doors",
    port: "boats, sea air, boarding signs, luggage, and the next stretch of water",
    pier: "boats, river light, boarding steps, luggage, and the next stretch of water",
    market: "stalls, snacks, gifts, color, bargaining rhythm, and the movement of browsing",
    street: "street signs, shopfronts, crossings, hotel edges, and the shape of the neighborhood",
    neighborhood: "cafes, lanes, hotel edges, small shops, evening rhythm, and the area's local identity",
    restaurant: "tables, drinks, house dishes, menu details, staff rhythm, and the feeling of choosing the meal",
    cafe: "coffee counters, ice, sweetness, street stools, photos, and the pause between plans",
    dish: "menu names, texture, herbs, sauce, spice, sweetness, and the details that shape the taste",
    drink: "ice, sweetness, glassware, cafe counters, street stools, and the next pause in the day",
    dessert: "cool bowls, toppings, coconut milk, color, sweetness, and evening snack counters",
    landmark: "approach views, local pride, city light, architecture, and the story people attach to the stop",
    museum: "galleries, objects, quiet rooms, photos, and the story inside the museum",
    experience: "setting, sounds, timing, local texture, and the feeling of taking part",
    attraction: "views, arrival details, timing, local energy, and the named scene in the itinerary",
    beach: "sand, seafood stalls, morning light, hotels, scooters, and the open edge of the city",
    "nature stop": "weather, shade, paths, views, photos, and the quieter space beyond traffic",
    park: "walking paths, trees, family time, shade, photos, and everyday open-air rhythm",
    river: "boats, bridges, reflections, river walks, photos, and the waterline that organizes the city",
    canal: "walks, bridge views, water, cafe pauses, apartment lights, and quieter neighborhood rhythm",
    "fountain square": "snacks, evening lights, walking loops, scooters, and the way people gather",
    village: "craft, homes, garden edges, water, photos, and slower daily life",
    lake: "walking paths, shade, reflections, cafe pauses, photos, and quieter city rhythm",
    "performance venue": "showtimes, seats, stage lights, music, and the anticipation before the performance",
    "shopping stop": "shops, food counters, city pauses, cool air, small purchases, and indoor local rhythm",
    "tailor stop": "fabric, fitting rooms, measuring tape, alterations, and the patience of tailor culture",
    "craft stop": "watching hands work, materials, tools, photos, and local skill",
    "shopping market": "sizes, colors, fabric, vendor calls, bags, and market browsing",
    "flower market": "bouquets, color, early movement, scooters, photos, and market brightness",
    "night market": "snacks, gifts, lanterns, bargaining rhythm, food smoke, and evening browsing",
    viewpoint: "views, light, timing, drinks, photos, and the pause above the city",
    "food walk": "starting points, dish names, spice, texture, shared plates, and local appetite",
    route: "starting points, stops, street corners, food pauses, photos, and movement across the city",
    "boat experience": "boarding, river light, water movement, photos, and the pace of the crossing",
    "river landing": "boarding steps, tickets, river light, waiting edges, and movement across water",
    workshop: "materials, hands-on steps, tools, photos, and the craft rhythm",
    "sacred place": "respectful dress, incense, quiet waiting, photos, and the slower pace of the visit",
    "heritage landmark": "gates, courtyards, photos, route names, and the weight of the old city",
    "nature day trip": "weather, trails, views, photos, and the feeling of leaving the city behind",
    "arrival route": "airport doors, station exits, luggage, bridges, and the first approach to town",
    "gallery stop": "framed works, quiet rooms, local artists, cafe edges, and a slower creative pause",
    "cultural stop": "rooms, objects, art, memory, quiet light, and the story inside the stop",
    "civic memorial": "respectful dress, public memory, quiet lines, flags, and formal stone",
    "evening street": "drinks, small stools, food smoke, music, walking, and old streets after dark",
  };
  const isDish =
    normalizedLower(page.pageKind) === "dish" ||
    normalizedLower(page.pageKind) === "drink" ||
    normalizedLower(page.pageKind) === "dessert" ||
    normalizedLower(page.placeKind) === "dish" ||
    normalizedLower(page.placeKind) === "drink" ||
    normalizedLower(page.placeKind) === "dessert" ||
    normalizedLower(page.placeKind) === "local dish" ||
    normalizedLower(page.placeKind) === "food spot";
  let moments = isDish
    ? (isSesameCandyPage(page)
      ? "sesame seeds, malt sweetness, peanut, cut squares, tea cups, market wrapping paper, and old-capital gift counters"
      : profile.key === "drink" && /\b(bia|beer)\b/.test(descriptor)
      ? "fresh beer glasses, small stools, corner tables, shared snacks, and evening street rhythm"
      : profile.key === "drink" ? momentsBySurface.drink : profile.key === "dessert" ? momentsBySurface.dessert : momentsBySurface.dish)
    : (profile.key === "sacred" && /\b(cathedral|church|notre dame|nhà thờ|nha tho)\b/.test(descriptor))
      ? `cathedral facades, quiet pews, stained-glass light, courtyard shade, bells, and ${page.cityID === "hue" ? "Hue" : ""} city worship`.replace(/\s+/g, " ").trim()
    : momentsBySurface[profile.surface] || profile.practical;
  if (profile.key === "transferRoute") {
    moments = /railway|station|ga /i.test(descriptor)
      ? "station doors, luggage, river bridges, coastal roads, and the first approach to town"
      : "airport doors, luggage, river bridges, coastal roads, and the first approach to town";
  }
  if (["landmark", "heritage", "sacred", "museum", "gallery", "attraction"].includes(profile.key)) {
    moments = `${textureFor(page, profile, city, "language")} around ${pictureLead(visualCue(page, profile, city), title)}`;
  }
  const frames = [
    `Around ${title}, the day can include ${moments}.`,
    `When the traveler notices ${title}, the nearby details are ${moments}.`,
    `${target} sits close to the real trip details around ${title}: ${moments}.`,
    `In the itinerary, ${title} naturally sits near ${moments}.`,
    `The scene around ${title} becomes clearer when it includes ${moments}.`,
    `A traveler will usually meet ${title} alongside ${moments}.`,
    `For ${title}, the surrounding moment is grounded in ${moments}.`,
    `The day around ${title} can move through ${moments}.`,
    `${title} stays connected to ${moments}.`,
    `The small details around ${title} are ${moments}.`,
    `When the plan turns toward ${title}, the scene often includes ${moments}.`,
    `${target} belongs with the nearby scene of ${moments}.`,
    `Around ${title}, the travel moment holds ${moments}.`,
    `At ${title}, the trip often becomes about ${moments}.`,
    `${target} fits the day best when ${moments} are already easy to imagine.`,
    `Once ${title} feels familiar, the surrounding scene can include ${moments}.`,
  ];
  return pick(frames, `${page.id}:language`);
}

function goodToKnowFor(page, profile, city) {
  const title = pageTitle(page);
  const target = vietnameseName(page);
  const scene = oneLineScene(visualCue(page, profile, city));
  const texture = textureFor(page, profile, city, "good");
  if (page.id === "city-hue-place-lien-hoa-vegetarian") {
    return "Nhà hàng chay Liên Hoa brings back Hue's chay table: fresh plates, tofu, herbs, Buddhist influence, and a quieter lunch rhythm.";
  }
  if (pageOverrides[page.id]?.good) return pageOverrides[page.id].good;
  const needsExtraCityTexture = new Set([
    "city-danang-place-central-bus-station",
    "city-danang-place-hoa-trung-lake",
    "city-danang-place-nguyen-hien-dinh-tuong-theatre",
    "city-hanoi-place-ho-chi-minh-mausoleum",
    "city-hanoi-place-vietnam-national-tuong-theatre",
    "city-hcmc-place-bach-dang-waterbus-station",
    "city-hcmc-place-cu-chi-day-trip",
    "city-hcmc-place-mien-dong-bus-station",
    "city-hcmc-place-municipal-theatre-square",
    "city-hcmc-place-turtle-lake",
    "city-hoian-place-banh-mi-phuong",
    "city-hoian-place-bach-dang-boat-pier",
    "city-hoian-place-cham-islands-snorkel-boat",
    "city-hoian-place-duc-an-old-house",
    "city-hoian-place-from-danang-airport",
    "city-hue-place-bach-ma-national-park",
    "city-hue-place-thai-hoa-palace",
    "city-hue-place-toa-kham-boat-station",
  ]);
  const frames = [
    `${target} belongs with ${scene}, giving ${title} a specific travel scene before the trip begins.`,
    `${target} sits beside ${texture}, so ${title} feels connected to a real place.`,
    `${target} carries ${title}'s setting through ${texture} in ${city.name}.`,
    `${target} carries ${title}'s surrounding details: ${texture}, with ${scene} behind it.`,
    `For ${title}, the name stays close to ${texture}, which makes the stop feel rooted in ${city.name}.`,
    `${target} fits naturally with ${texture} around ${title}.`,
    `The image of ${title} feels more present when ${target} has ${texture} around it.`,
    `${target} feels less abstract when it sits beside ${texture} and the scene of ${title}.`,
    `${target} carries the surrounding image back to ${scene} and the place around it.`,
    `${target} lands better when the traveler already imagines ${texture} around ${title}.`,
    `${target} belongs to the real scene around ${title}: ${texture}.`,
    `${target} carries the visual details around it: ${texture}, plus the local setting of ${scene}.`,
    `The scene around ${title} stays vivid when ${target} sits beside ${texture}.`,
    `${target} feels like something heard in ${city.name}, with ${scene} around it.`,
    `The name and scene work together: ${target} beside ${scene}, with ${texture} nearby.`,
    `${target} belongs to ${scene}, especially the surrounding ${texture}.`,
    `${target} carries ${scene} forward when the traveler sees or hears the place later.`,
    `The name stays tied to ${texture}, giving ${title} a concrete setting in ${city.name}.`,
    `${target} carries ${title}'s scene through ${texture}.`,
    `The Vietnamese name for ${title} and the scene reinforce each other through ${texture}.`,
    `${target} belongs in the same image as ${texture}, with ${title} rooted in ${city.name}.`,
    `${target} keeps its setting close: ${scene}, surrounded by ${texture}.`,
    `${target} points back to ${scene}, where ${title} feels specific rather than abstract.`,
    `${target} points to ${title}'s scene through ${texture}.`,
    `${target} belongs to the scene, with ${texture} around it and ${city.name} in view.`,
  ];
  const body = pick(frames, `${page.id}:good`);
  if (needsExtraCityTexture.has(page.id)) {
    return body;
  }
  if (body.length >= 55) return body;
  return `${body} ${title} carries ${texture}.`;
}

function readerSafeCopy(value) {
  return sentence(
    trimSentence(value)
      .replace(/\btravel moment\b/gi, "trip moment")
      .replace(/\bthe trip moment is\b/gi, "worth it if you want")
      .replace(/\bplace name\b/gi, "label")
      .replace(/\bTraveler\b/g, "Visitor")
      .replace(/\btraveler\b/g, "visitor")
      .replace(/\bvisitor walking\b/gi, "walking")
      .replace(/\bthe traveler can\b/gi, "you can")
      .replace(/\ba traveler will usually meet\b/gi, "you will usually meet")
      .replace(/\bthe traveler already imagines\b/gi, "the scene already includes")
      .replace(/\bthe traveler sees or hears\b/gi, "you see or hear")
      .replace(/\bthe traveler arrives\b/gi, "arrival")
      .replace(/\bthe traveler lands\b/gi, "arrival")
      .replace(/\bthe traveler\b/gi, "you")
      .replace(/\btravelers\b/gi, "visitors")
      .replace(/\bnational map\b/gi, "country as a whole")
      .replace(/\bmaps\b/gi, "routes")
      .replace(/\bmap pin\b/gi, "saved place")
      .replace(/\bnot just another dot on a map\b/gi, "not just an abstract name")
      .replace(/\bstreet map\b/gi, "street plan")
      .replace(/\bthe map\b/gi, "the route")
      .replace(/\bmap\b/gi, "route")
      .replace(/\bdrivers?\b/gi, "rides")
      .replace(/\bpickup point\b/gi, "meeting point")
      .replace(/\bpicked up\b/gi, "met again")
      .replace(/\bpickup\b/gi, "meeting")
      .replace(/\breturn ride\b|\bride back\b/gi, "return plan")
      .replace(/\bpayoff\b/gi, "reason to go")
      .replace(/\.{2,}/g, ".")
      .replace(/\s+/g, " ")
      .trim()
  );
}

function reasonToGoFor(page, profile, city) {
  if (pageOverrides[page.id]?.about) return readerSafeCopy(pageOverrides[page.id].about);
  const title = pageTitle(page);
  const meaning = sourceMeaning(page, profile, city);
  const texture = textureFor(page, profile, city, "why-go");
  const frames = {
    dish: `${title} is worth trying because it turns ${city.name} into flavor: ${meaning}, with ${texture}.`,
    drink: `${title} is worth knowing because Vietnam's drink culture often carries the pause between bigger plans: ${texture}.`,
    dessert: `${title} is worth trying for the sweet side of ${city.name}: ${meaning}, with ${texture}.`,
    cafe: `${title} is worth saving when you want ${city.name}'s cafe culture, not just caffeine: ${texture}.`,
    restaurant: `${title} is worth considering when a meal should feel like part of the itinerary: ${meaning}, with ${texture}.`,
    market: `${title} is worth browsing because it shows everyday ${city.name}: ${texture}.`,
    street: `${title} is worth recognizing because streets shape how ${city.name} feels on the ground: ${texture}.`,
    neighborhood: `${title} is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: ${texture}.`,
    airport: `${title} is worth recognizing before arrival because it is where the trip first turns from plan into Vietnam: ${texture}.`,
    station: `${title} is worth recognizing because travel days still carry the city's mood: ${texture}.`,
    port: `${title} is worth recognizing because it opens ${city.name} toward water, crossings, and the next stretch of the trip: ${texture}.`,
    museum: `${title} is worth a stop when you want more than scenery: ${meaning}, with ${texture}.`,
    heritage: `${title} is worth visiting because it makes history physical: ${texture}.`,
    sacred: `${title} is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: ${texture}.`,
    beach: `${title} is worth picturing because it changes the trip into coastal Vietnam: ${texture}.`,
    river: `${title} is worth knowing because the water helps organize the city: ${texture}.`,
  };
  return readerSafeCopy(frames[profile.key] || `${title} is worth knowing because it gives ${city.name} a specific ${profile.surface} scene: ${texture}.`);
}

function whatYouGetFor(page, profile, city) {
  if (pageOverrides[page.id]?.meaning) return readerSafeCopy(pageOverrides[page.id].meaning);
  const title = pageTitle(page);
  const scene = pictureLead(visualCue(page, profile, city), title);
  const meaning = sourceMeaning(page, profile, city);
  const texture = textureFor(page, profile, city, "what-you-get");
  return readerSafeCopy(`At ${title}, you get ${meaning}: ${scene}, with ${texture}.`);
}

function sayItLocallyFor(page, profile, city) {
  if (pageOverrides[page.id]?.hear) return readerSafeCopy(pageOverrides[page.id].hear);
  const title = pageTitle(page);
  const target = vietnameseName(page);
  const texture = textureFor(page, profile, city, "say-locally");
  if (normalizedLower(target) === normalizedLower(title)) {
    return readerSafeCopy(`${title} usually stays as the venue name. Say it slowly and connect it to the scene around it: ${texture}.`);
  }
  return readerSafeCopy(`Say ${target} for ${title}. The local name is easier to remember once it sits beside ${texture}.`);
}

function worthItIfFor(page, profile, city) {
  if (pageOverrides[page.id]?.practical) return readerSafeCopy(pageOverrides[page.id].practical);
  const title = pageTitle(page);
  const texture = textureFor(page, profile, city, "worth-it-if");
  const frames = {
    dish: `Worth it if you want a food memory rather than only a place name: ${texture}.`,
    drink: `Worth it if a cold glass, coffee pause, or sidewalk drink would make the day feel more local: ${texture}.`,
    dessert: `Worth it if you want the sweet, textural side of the city: ${texture}.`,
    cafe: `Worth it if the trip needs a slower pause between walks, markets, meals, or heat: ${texture}.`,
    restaurant: `Worth it if the meal itself should be one of the day's memories: ${texture}.`,
    market: `Worth it if you like seeing daily life through browsing, snacks, color, small goods, and local rhythm: ${texture}.`,
    street: `Worth it if the street helps you understand the neighborhood before you are there: ${texture}.`,
    neighborhood: `Worth it if you want the city to feel like lived-in areas, not only landmarks: ${texture}.`,
    museum: `Worth it if you want context, quiet rooms, objects, and history instead of another outdoor stop: ${texture}.`,
    heritage: `Worth it if old walls, gates, courtyards, and public memory are part of the trip you want: ${texture}.`,
    sacred: `Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: ${texture}.`,
    beach: `Worth it if the Vietnam image in your head includes sea air, sand, seafood, and coastal mornings: ${texture}.`,
    nature: `Worth it if you want the trip to open beyond dense streets into water, shade, weather, or green edges: ${texture}.`,
  };
  return readerSafeCopy(frames[profile.key] || `Worth it if ${title} gives your itinerary a clearer image: ${texture}.`);
}

function beforeYouGoFor(page, profile, city) {
  const title = pageTitle(page);
  const scene = pictureLead(visualCue(page, profile, city), title);
  const texture = textureFor(page, profile, city, "before-you-go");
  const override = pageOverrides[page.id]?.tip || pageOverrides[page.id]?.rationale || "";
  const fallback = `${title} works best when the name is tied to the reason for going, not memorized as an abstract label. Picture ${scene} with ${texture}.`;
  return readerSafeCopy(override && override.length > 40 ? `${override}. Picture ${scene}.` : fallback);
}

function contextSurface(profile) {
  const labels = {
    dish: "food",
    drink: "drink",
    dessert: "sweet",
    cafe: "cafe",
    restaurant: "restaurant",
  };
  return labels[profile.key] || profile.surface;
}

function rewritePage(page) {
  const city = cityProfiles[page.cityID];
  if (!city) return false;
  const profile = kindFor(page);
  applyMetadataAlignment(page, profile);
  const title = pageTitle(page);
  const target = vietnameseName(page);
  const editorial = page.editorialImport || {};
  editorial.summary = readerSafeCopy(summaryLeadFor(page, profile, city));
  editorial.sections = [
    {
      id: "at-glance",
      title: "Why go",
      body: reasonToGoFor(page, profile, city),
    },
    {
      id: "place-brief",
      title: "What you'll get",
      body: whatYouGetFor(page, profile, city),
    },
    {
      id: "quick-say",
      title: "Say it locally",
      body: sayItLocallyFor(page, profile, city),
    },
    {
      id: "use-it-with",
      title: "Worth it if",
      body: worthItIfFor(page, profile, city),
    },
    {
      id: "when-to-use",
      title: "Before you go",
      body: beforeYouGoFor(page, profile, city),
    },
    {
      id: "good-to-know",
      title: "Good to know",
      body: readerSafeCopy(goodToKnowFor(page, profile, city)),
    },
  ];
  editorial.audienceRewrite = {
    reviewID: REVIEW_ID,
    standard: "reason-to-go-factual-hook-before-local-name",
    source: "source-owned city audience rewrite",
  };
  if (editorial.runtimeOverride?.kind === "ba-na-hills-journey") {
    editorial.runtimeOverride.reason =
      "Ba Na Hills is a full journey page in the native runtime; utility phrase sections extend the reviewed place-body sections after Why go, Say it locally, What you'll get, Day-trip landmark, Full-day timing, and Good to know.";
  }
  page.editorialImport = editorial;
  page.context = readerSafeCopy(pageOverrides[page.id]?.context
    ?? `For ${title}, ${city.name}'s ${contextSurface(profile)} story comes through ${textureFor(page, profile, city, "context")}.`);
  const texture = textureFor(page, profile, city, "tip");
  const tipTextureSentence = upperFirst(texture);
  page.tip = readerSafeCopy(pageOverrides[page.id]?.tip ?? pick([
    `${target} belongs beside ${texture} around ${title}.`,
    `${title} feels clearer with ${texture} around it.`,
    `${city.name}'s ${contextSurface(profile)} scene comes through ${texture}.`,
    `${target} feels tied to ${title} through ${texture}.`,
    `${title} becomes more specific beside ${texture}.`,
    `${tipTextureSentence} give ${title} a setting before the trip begins.`,
    `${target} points back to ${title} through ${texture}.`,
    `${title} stays rooted in ${city.name} through ${texture}.`,
    `${tipTextureSentence} make ${target} feel connected to a real stop.`,
    `${title} carries ${texture} into the travel plan.`,
    `${target} sits inside the scene around ${title}: ${texture}.`,
    `${city.name} feels more specific when ${title} is tied to ${texture}.`,
  ], `${page.id}:tip`));
  page.rationale = readerSafeCopy(pageOverrides[page.id]?.rationale
    ?? `${title} brings ${city.name} into focus through ${textureFor(page, profile, city, "rationale")}.`);
  return true;
}

function alignAllPagesWithPlaces(source) {
  const places = new Map((source.places || []).map((place) => [place.id, place]));
  for (const page of source.pages || []) {
    const place = page.placeID ? places.get(page.placeID) : null;
    if (!place) continue;
    const placeKind = place.placeKind || place.kind;
    if (placeKind) page.placeKind = placeKind;
    if (place.contentRole) {
      page.contentRole = place.contentRole;
    } else if (page.kind !== "place" || !["restaurant", "dish"].includes(page.pageKind)) {
      delete page.contentRole;
    }
  }
}

function rewriteCityHub(city) {
  const profile = cityProfiles[city.id];
  if (!profile) return false;
  const hub = city.hubEditorial || {};
  const livePageIDReplacements = {
    "viet-family-city-danang-place-my-khe-beach": "viet-family-city-danang-place-my-khe",
    "viet-family-city-danang-go-dragon-bridge": "viet-family-city-danang-place-dragon-bridge",
    "viet-family-city-danang-where-my-khe": "viet-family-city-danang-place-my-khe",
    "viet-family-city-hoian-where-japanese-bridge": "viet-family-city-hoian-place-japanese-bridge",
    "viet-family-city-hue-go-imperial-city": "viet-family-city-hue-place-imperial-city",
    "viet-family-city-hue-where-thien-mu": "viet-family-city-hue-place-thien-mu",
    "viet-family-city-hue-stop-imperial-city": "viet-family-city-hue-place-perfume-river",
  };
  hub.subtitle = profile.subtitle;
  hub.intro = profile.opening;
  hub.signatureMoments = hub.signatureMoments?.map((moment, index) => {
    const replacements = {
      danang: [
        "see how river bridges, beaches, markets, and mountain trips fit together",
        "recognize Da Nang's modern nights, seafood stops, and central-Vietnam day-trip names",
        "hear the names that make the coastal city feel familiar before the first ride",
      ],
      hanoi: [
        "see the Old Quarter, Hoan Kiem, West Lake, coffee, and northern dishes as one layered city",
        "recognize the lake, street, temple, and food names that make Hanoi easier to imagine",
        "hear the names that turn old lanes and cafe stops into places you already know",
      ],
      hcmc: [
        "see Saigon through District 1, markets, coffee, river lights, and late food",
        "recognize the names behind fast-moving streets, old civic buildings, and central meetups",
        "hear the city names that make the first day feel bright instead of abstract",
      ],
      hoian: [
        "see Hoi An through lantern streets, river boats, old houses, markets, and village routes",
        "recognize the names behind the Ancient Town, the bridge, the river, and the craft stops",
        "hear the names that let Hoi An feel close before the first evening walk",
      ],
      hue: [
        "see Hue through imperial gates, river pagodas, tomb roads, incense, markets, and local food",
        "recognize the names that separate royal history, living ritual, and city food",
        "hear the names that make the old capital feel vivid before arrival",
      ],
    };
    return replacements[city.id]?.[index] || moment;
  }) || [];
  hub.practicePrompt = `Practice ${profile.name} through place names, food names, and city moments that feel vivid before the trip.`;
  hub.namesToKnowIDs = (hub.namesToKnowIDs || []).map((pageID) => livePageIDReplacements[pageID] || pageID);
  hub.quickPhraseIDs = (hub.quickPhraseIDs || []).map((pageID) => livePageIDReplacements[pageID] || pageID);
  hub.audienceRewrite = {
    reviewID: REVIEW_ID,
    standard: "reason-to-go-factual-hook-before-local-name",
  };
  city.hubEditorial = hub;
  return true;
}

function syncHandwrittenCopyFiles(source) {
  fs.mkdirSync(handwrittenCopyDir, { recursive: true });
  for (const city of source.cities || []) {
    const cityID = city.id;
    if (!cityProfiles[cityID]) continue;
    const entries = (source.pages || [])
      .filter((page) => page.kind !== "phrase" && page.status === "approved" && page.cityID === cityID)
      .sort((a, b) => a.id.localeCompare(b.id))
      .map((page) => ({
        pageID: page.id,
        summary: page.editorialImport?.summary || "",
        context: page.context || "",
        tip: page.tip || "",
        rationale: page.rationale || "",
        sections: page.editorialImport?.sections || [],
      }));
    writeJSON(path.join(handwrittenCopyDir, `${cityID}.json`), {
      schemaVersion: 1,
      cityID,
      authoringStandard: "reason-to-go-factual-hook-before-local-name",
      entries,
    });
  }
}

function main() {
  const source = readJSON(sourcePath);
  placeByID = new Map((source.places || []).map((place) => [place.id, place]));
  let pageCount = 0;
  let hubCount = 0;
  for (const city of source.cities || []) {
    if (rewriteCityHub(city)) hubCount += 1;
  }
  for (const page of source.pages || []) {
    if (page.kind !== "phrase" && page.status === "approved" && rewritePage(page)) {
      pageCount += 1;
    }
  }
  alignAllPagesWithPlaces(source);
  syncHandwrittenCopyFiles(source);
  writeJSON(sourcePath, source);
  console.log(`Rewrote ${hubCount} city hubs and ${pageCount} city noun/place pages in ${path.relative(repoRoot, sourcePath)}`);
}

main();
