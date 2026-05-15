#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

if (!process.argv.includes("--draft")) {
  console.error(
    "polish-vietnamese-menu-copy.js is draft-only. Final menu prose is authored in content-draft/viet/menu/items/**; run native-ios/scripts/generate-vietnamese-menu-copy.js for production output."
  );
  process.exit(2);
}

const repoRoot = path.resolve(__dirname, "..", "..");
const menuPath = path.join(repoRoot, "native-ios", "Resources", "vietnamese-menu-copy.json");
const payload = JSON.parse(fs.readFileSync(menuPath, "utf8"));
const culturalOverridesPath = path.join(__dirname, "vietnamese-menu-cultural-copy-overrides.json");
const culturalOverrides = fs.existsSync(culturalOverridesPath)
  ? JSON.parse(fs.readFileSync(culturalOverridesPath, "utf8"))
  : {};

const exactCopy = {
  "food-pho-bo": {
    atAGlance:
      "Phở bò is Vietnam’s best-known noodle soup: clear, fragrant beef broth, soft rice noodles, and thin slices of beef finished with herbs. It feels light, comforting, and deeply satisfying.",
    goodToKnow:
      "Herbs, lime, chili, and bean sprouts usually arrive on the side. Add them little by little so the broth stays balanced.",
    usuallyIncludes: ["beef broth", "rice noodles", "sliced beef", "herbs", "lime"],
  },
  "food-bun-cha": {
    atAGlance:
      "Bún chả pairs smoky grilled pork with rice vermicelli, herbs, and a warm nước chấm dipping broth. The charm is sweet-savory pork, cool noodles, and bright herbs in the same bite.",
    goodToKnow:
      "The sauce is not a side note: nước chấm usually brings fish sauce, lime or vinegar, sugar, garlic, chili, and pickled vegetables into balance.",
    usuallyIncludes: ["rice vermicelli", "grilled pork", "fresh herbs", "nước chấm", "pickled vegetables"],
    commonOptions: ["extra nước chấm", "more herbs", "no chili", "extra noodles"],
  },
  "food-bun-thit-nuong": {
    atAGlance:
      "Bún thịt nướng is a grilled pork vermicelli bowl with herbs, pickles, peanuts, and nước chấm. It tastes smoky, cool, crunchy, and sweet-salty rather than heavy.",
    goodToKnow:
      "Nước chấm is the dressing here: fish sauce softened with lime, sugar, garlic, and chili. Pour it slowly and mix before adding more.",
    usuallyIncludes: ["rice vermicelli", "grilled pork", "fresh herbs", "nước chấm", "peanuts"],
    commonOptions: ["extra nước chấm", "more herbs", "no chili", "no peanuts"],
  },
  "food-bun-nem-nuong": {
    atAGlance:
      "Bún nem nướng builds a vermicelli bowl around grilled pork sausage, herbs, crunch, and a savory-sweet sauce. It is richer than a plain salad bowl but still fresh from the herbs.",
    goodToKnow:
      "Some shops use nước chấm; others lean into a thicker house sauce. Ask for sauce on the side if you want to control sweetness and heat.",
    usuallyIncludes: ["rice vermicelli", "grilled pork sausage", "fresh herbs", "house sauce", "crispy crunch"],
    commonOptions: ["sauce on the side", "more herbs", "no chili", "no peanuts"],
  },
  "food-bun-bo-nam-bo": {
    atAGlance:
      "Bún bò Nam Bộ is a southern-style beef vermicelli salad with seared beef, herbs, peanuts, fried shallots, and nước chấm. It should taste fresh, beefy, nutty, and bright.",
    goodToKnow:
      "The sauce is usually a fish-sauce dressing, not a thick gravy. Mix it through the noodles so the herbs, beef, and peanuts share the flavor.",
    usuallyIncludes: ["rice vermicelli", "seared beef", "fresh herbs", "nước chấm", "peanuts or fried shallots"],
    commonOptions: ["extra nước chấm", "more herbs", "no chili", "no peanuts"],
  },
  "food-bun-bo-xao": {
    atAGlance:
      "Bún bò xào is stir-fried beef over cool rice vermicelli with herbs, pickles, peanuts or fried shallots, and nước chấm. It is savory, bright, and built for mixing.",
    goodToKnow:
      "Nước chấm is the usual sauce: fish sauce balanced with lime, sugar, garlic, and chili. Start with half, mix, then add more if the noodles need it.",
    usuallyIncludes: ["rice vermicelli", "stir-fried beef", "fresh herbs", "nước chấm", "peanuts or fried shallots"],
    commonOptions: ["extra nước chấm", "more herbs", "no chili", "no peanuts"],
  },
  "food-bun-ga-nuong": {
    atAGlance:
      "Bún gà nướng is grilled chicken over rice vermicelli with herbs, pickles, crunch, and nước chấm. It is lighter than pork versions but still smoky and satisfying.",
    goodToKnow:
      "The nước chấm dressing is usually salty, sweet, sour, and a little garlicky. Add chili only after tasting the chicken and sauce together.",
    usuallyIncludes: ["rice vermicelli", "grilled chicken", "fresh herbs", "nước chấm", "fried shallots"],
    commonOptions: ["extra nước chấm", "more herbs", "no chili", "extra noodles"],
  },
  "food-bun-cha-ca": {
    atAGlance:
      "Bún chả cá is rice vermicelli with springy fish cakes, herbs, fried shallots, and a light sauce or broth depending on the shop. It should taste seafood-savory, fresh, and gentle.",
    goodToKnow:
      "Chả cá means fish cake here, not grilled pork. Ask whether it is served dry-style or with broth if the menu photo is unclear.",
    usuallyIncludes: ["rice vermicelli", "fish cakes", "fresh herbs", "nước chấm or light broth", "fried shallots"],
    commonOptions: ["extra fish cakes", "more herbs", "less chili", "extra noodles"],
  },
  "food-bun-dau-mam-tom": {
    atAGlance:
      "Bún đậu mắm tôm is a northern-style platter of rice vermicelli, fried tofu, herbs, and pungent shrimp-paste sauce. It is salty, vivid, and defined by the sauce.",
    goodToKnow:
      "Mắm tôm is fermented shrimp-paste sauce with a strong aroma. Many places can offer a milder nước chấm dip if you ask.",
    usuallyIncludes: ["rice vermicelli", "fried tofu", "fresh herbs", "mắm tôm", "pork optional"],
    commonOptions: ["mắm tôm on the side", "milder nước chấm", "more herbs", "no pork"],
  },
  "food-bun-mang-vit": {
    atAGlance:
      "Bún măng vịt is duck and bamboo shoot vermicelli soup. The broth is savory and warming, while herbs and ginger dipping sauce keep the duck from feeling heavy.",
    goodToKnow:
      "Duck often comes with a ginger fish-sauce dip on the side. Use it for the meat, then taste the broth before adding extra chili.",
    usuallyIncludes: ["rice vermicelli", "duck", "bamboo shoots", "herbs", "ginger fish-sauce dip"],
    commonOptions: ["extra herbs", "ginger dip", "less chili", "extra noodles"],
  },
  "food-cao-lau": {
    atAGlance:
      "Cao lầu is a Hội An noodle bowl with chewy noodles, pork, herbs, crisp bits, and a small amount of seasoned pork sauce. It is more concentrated and local-specialty than soup-like.",
    goodToKnow:
      "The sauce lightly coats the noodles instead of flooding the bowl. Mix well so the pork, herbs, and crisp topping share the seasoning.",
    usuallyIncludes: ["chewy rice noodles", "pork", "fresh herbs", "savory pork sauce", "crispy rice crackers"],
    commonOptions: ["extra herbs", "less chili", "extra sauce", "share size"],
  },
  "food-mi-quang-ga": {
    atAGlance:
      "Mì Quảng gà is a central-Vietnam noodle dish with wide turmeric rice noodles, chicken, herbs, peanuts, rice crackers, and just enough broth to coat the bowl.",
    goodToKnow:
      "Mì Quảng is not a normal soup. The turmeric broth is shallow and concentrated, so mix before judging whether it needs lime or chili.",
    usuallyIncludes: ["wide turmeric rice noodles", "chicken", "turmeric broth", "peanuts", "rice cracker"],
    commonOptions: ["extra herbs", "less chili", "extra broth", "no peanuts"],
  },
  "food-mi-quang-tom-thit": {
    atAGlance:
      "Mì Quảng tôm thịt is Quảng-style turmeric rice noodles with shrimp, pork, herbs, peanuts, rice cracker, and a shallow savory broth. It is nutty, fragrant, and deeply tied to central Vietnam.",
    goodToKnow:
      "The broth is meant to season the noodles, not cover them. Watch for both shrimp and pork if you avoid shellfish or pork.",
    usuallyIncludes: ["wide turmeric rice noodles", "shrimp and pork", "turmeric broth", "peanuts", "rice cracker"],
    commonOptions: ["extra herbs", "less chili", "extra broth", "no peanuts"],
  },
  "food-hu-tieu-kho": {
    atAGlance:
      "Hủ tiếu khô is dry rice noodles tossed with a savory house sauce, herbs, and toppings, usually with broth served on the side. It is glossy, springy, and more seasoned than plain noodles.",
    goodToKnow:
      "Khô means dry-style here, not dry in texture. The noodles are sauced, and the broth on the side is for sipping or loosening the bowl.",
    usuallyIncludes: ["rice noodles", "house sauce", "herbs", "fried shallots", "side broth"],
    commonOptions: ["extra sauce", "side broth", "more herbs", "no chili"],
  },
  "food-mien-xao-cua": {
    atAGlance:
      "Miến xào cua is glass noodles stir-fried with crab until the noodles soak up sweet seafood flavor. Expect springy noodles, crab, aromatics, and a glossy stir-fry sauce.",
    goodToKnow:
      "Glass noodles can clump as they cool, so eat while warm. The sauce is usually a light stir-fry seasoning rather than a separate dip.",
    usuallyIncludes: ["glass noodles", "crab", "garlic", "stir-fry sauce", "herbs"],
    commonOptions: ["less spicy", "extra herbs", "share size", "with rice"],
  },
  "food-mien-xao-hai-san": {
    atAGlance:
      "Miến xào hải sản is glass noodles stir-fried with seafood, aromatics, and a glossy stir-fry sauce. The noodles turn springy and soak up the seafood flavor.",
    goodToKnow:
      "This is a stir-fry, not a sauced vermicelli salad. Ask what seafood is included if shellfish matters.",
    usuallyIncludes: ["glass noodles", "seafood", "garlic", "stir-fry sauce", "herbs"],
    commonOptions: ["less spicy", "extra herbs", "share size", "with rice"],
  },
  "food-banh-hoi-thit-nuong": {
    atAGlance:
      "Bánh hỏi thịt nướng serves fine woven rice vermicelli sheets with grilled pork, herbs, scallion oil, and nước chấm. The texture is delicate; the pork brings the smoke.",
    goodToKnow:
      "Dip or spoon nước chấm lightly so the fine noodle sheets do not turn soggy. Herbs and scallion oil are part of the flavor.",
    usuallyIncludes: ["fine rice vermicelli sheets", "grilled pork", "scallion oil", "fresh herbs", "nước chấm"],
    commonOptions: ["extra nước chấm", "more herbs", "no chili", "share size"],
  },
  "food-banh-hoi-heo-quay": {
    atAGlance:
      "Bánh hỏi heo quay pairs fine rice vermicelli sheets with roasted pork, scallion oil, herbs, and nước chấm. It is about crisp pork against delicate noodles.",
    goodToKnow:
      "The nước chấm adds salt, sourness, and sweetness. Add it slowly so the roasted pork stays crisp and the noodle sheets stay light.",
    usuallyIncludes: ["fine rice vermicelli sheets", "roasted pork", "scallion oil", "fresh herbs", "nước chấm"],
    commonOptions: ["extra nước chấm", "more herbs", "no chili", "share size"],
  },
  "food-pho-ga": {
    atAGlance:
      "Phở gà is the gentler chicken version of phở, with clear broth, rice noodles, tender chicken, and fresh herbs. Order it when you want something warm, clean, and easy to love.",
    goodToKnow:
      "It is usually milder than beef phở. Add chili, lime, or herbs at the table if you want a brighter bowl.",
  },
  "food-bun-bo-hue": {
    atAGlance:
      "Bún bò Huế is a bold central-Vietnam noodle soup with lemongrass, chili warmth, beef, and thick round noodles. It is richer and spicier than phở.",
    goodToKnow:
      "Ask for less spicy if you are heat-sensitive. The broth is the point, so taste it before adding extra chili.",
  },
  "food-goi-cuon": {
    atAGlance:
      "Gỏi cuốn are fresh spring rolls wrapped in rice paper with herbs, noodles, and a light filling. They are cool, clean, and great as a starter or snack.",
    goodToKnow:
      "The dipping sauce changes the flavor. Peanut sauce is richer; nước chấm is lighter, salty, sweet, and bright.",
  },
  "food-banh-mi-bo-kho": {
    atAGlance:
      "Bánh mì bò kho is Vietnamese beef stew served with crisp baguette for dipping. The stew is warm, aromatic, and rich with beef, carrots, and gentle spice.",
    goodToKnow:
      "This is not a filled sandwich. Tear the bread and dip it into the broth, then use herbs, lime, or chili to brighten the stew.",
    usuallyIncludes: ["baguette", "beef stew", "carrots", "herbs", "spiced broth"],
    commonOptions: ["extra bread", "less spicy", "extra herbs", "share size"],
    quickSayVietnamese: "Cho tôi một phần bò kho bánh mì.",
    quickSayEnglish: "I’d like one order of beef stew with bread.",
    quickSaySoundOut: "chaw toy moht fuhn baw kaw banh mee",
  },
  "food-banh-tieu": {
    atAGlance:
      "Bánh tiêu is a hollow sesame donut with a crisp outside, airy middle, and gentle sweetness. It is a street snack, not a sandwich.",
    goodToKnow:
      "Freshness matters most. The outside should still have a little crackle, while the center stays light and hollow.",
    usuallyIncludes: ["fried sesame dough", "hollow center", "light sweetness"],
    commonOptions: ["freshly fried", "takeaway", "share size"],
  },
  "food-banh-pate-so": {
    atAGlance:
      "Bánh patê sô is a savory puff pastry with flaky layers and seasoned filling. It belongs to Vietnam’s bakery-counter snack lane.",
    goodToKnow:
      "It is best warm, when the pastry is flaky and the filling is aromatic. Treat it as a quick bakery snack, not a bánh mì.",
    usuallyIncludes: ["puff pastry", "savory filling", "buttery layers"],
    commonOptions: ["warm", "takeaway", "share size"],
  },
  "food-sup-cua": {
    atAGlance:
      "Súp cua is a thick crab soup with egg ribbons, pepper, cilantro, and sometimes corn or asparagus. It is warm, silky, and snack-sized.",
    goodToKnow:
      "A little pepper or chili can wake up the bowl, but the texture should stay silky and crab-sweet.",
    usuallyIncludes: ["crab soup", "egg ribbons", "corn or asparagus", "cilantro", "pepper"],
    commonOptions: ["pepper", "extra crab", "cilantro", "small bowl"],
  },
  "food-ngheu-xao-bo-toi": {
    atAGlance:
      "Nghêu xào bơ tỏi is clams stir-fried in garlic-butter sauce. It is briny, rich, aromatic, and best while the shells are still hot.",
    goodToKnow:
      "The sauce is garlic butter, not beef: bơ tỏi means butter-garlic. Order rice or bread if you want to catch the sauce.",
    usuallyIncludes: ["clams", "garlic-butter sauce", "herbs", "shells", "chili optional"],
    commonOptions: ["with rice", "extra sauce", "less chili", "share size"],
  },
  "food-ca-ri-de": {
    atAGlance:
      "Cà ri dê is goat curry with warm spice, tender goat, and a rich sauce often eaten with bread, rice, or noodles. It is aromatic and fuller-bodied than chicken curry.",
    goodToKnow:
      "Goat can taste stronger than beef or chicken. Curry sauce, herbs, and bread help round it out.",
    usuallyIncludes: ["goat", "curry sauce", "warm spices", "herbs", "bread or rice"],
    commonOptions: ["with bread", "with rice", "less spicy", "share size"],
  },
  "food-heo-quay-banh-hoi": {
    atAGlance:
      "Heo quay bánh hỏi pairs roasted pork with fine rice vermicelli sheets, herbs, scallion oil, and nước chấm. It is all about crisp pork against delicate noodles.",
    goodToKnow:
      "Add nước chấm lightly so the pork stays crisp and the fine noodle sheets stay delicate.",
    usuallyIncludes: ["roasted pork", "fine rice vermicelli sheets", "fresh herbs", "nước chấm", "scallion oil"],
    commonOptions: ["extra nước chấm", "more herbs", "share size", "extra pork"],
  },
  "food-com-tam-suon": {
    atAGlance:
      "Cơm tấm sườn is a classic broken-rice plate with a grilled pork chop, pickles, scallion oil, and dipping sauce. It is smoky, savory, and easy to order for lunch or dinner.",
    goodToKnow:
      "A fried egg is a common upgrade. Pour the sauce slowly so the rice gets flavor without becoming too wet.",
  },
  "food-ca-kho-to": {
    atAGlance:
      "Cá kho tộ is fish simmered in a clay pot with caramel sauce, pepper, and fish sauce until glossy and deeply savory. It is usually eaten with plain rice.",
    goodToKnow:
      "The sauce is concentrated and salty-sweet. Pair it with rice and ask about bones if you prefer easier pieces of fish.",
  },
  "food-bo-sot-vang": {
    atAGlance:
      "Bò sốt vang is a Vietnamese beef stew with warm spice, carrots, and red-wine depth. It is hearty, aromatic, and often eaten with bread or noodles.",
    goodToKnow:
      "This is food, not a wine order. Ask whether it comes with bread or noodles if the menu does not say.",
    commonOptions: ["with bread", "with noodles", "extra herbs", "share size"],
    usuallyIncludes: ["beef", "spiced broth", "carrots", "herbs", "bread or noodles"],
  },
  "food-bo-kho-banh-mi": {
    atAGlance:
      "Bò kho bánh mì is Vietnamese beef stew served with bread for dipping. The broth is warm with spice, carrots, herbs, and tender beef.",
    goodToKnow:
      "This is stew with bread, not a sandwich. Tear the baguette and use it to catch the broth and sauce.",
    usuallyIncludes: ["beef stew", "baguette", "carrots", "herbs", "spiced broth"],
    commonOptions: ["extra bread", "less spicy", "extra herbs", "share size"],
    quickSayVietnamese: "Cho tôi một phần bò kho bánh mì.",
    quickSayEnglish: "I’d like one order of beef stew with bread.",
    quickSaySoundOut: "chaw toy moht fuhn baw kaw banh mee",
  },
  "food-tom-hap-nuoc-dua": {
    atAGlance:
      "Tôm hấp nước dừa is shrimp steamed in coconut water for a clean, lightly sweet seafood dish. It is simple, fragrant, and best shared while hot.",
    goodToKnow:
      "It is often served with salt-pepper-lime dip. The flavor is delicate, so extra chili or sauce is usually optional.",
    commonOptions: ["salt-pepper-lime dip", "share size", "with rice", "extra sauce"],
    usuallyIncludes: ["shrimp", "coconut water", "steam aromatics", "herbs", "dipping salt"],
  },
  "food-ghe-hap-bia": {
    atAGlance:
      "Ghẹ hấp bia is blue crab steamed with beer and aromatics. It is light, sweet, and usually ordered as a shared seafood plate.",
    goodToKnow:
      "Ask about price and portion size before ordering crab. Some seafood spots price it by weight.",
    commonOptions: ["share size", "salt-pepper-lime dip", "with rice", "extra herbs"],
    usuallyIncludes: ["blue crab", "beer steam", "lemongrass", "herbs", "dipping salt"],
  },
  "food-ba-roi-chien-nuoc-mam": {
    usuallyIncludes: ["pork belly", "fish sauce glaze", "garlic", "scallions", "crispy edges"],
  },
  "food-ga-chien-nuoc-mam": {
    usuallyIncludes: ["chicken", "crispy coating", "fish sauce glaze", "garlic", "herbs"],
  },
  "food-canh-ga-chien-nuoc-mam": {
    usuallyIncludes: ["chicken wings", "crispy coating", "fish sauce glaze", "garlic", "herbs"],
  },
  "food-canh-ga-nuong": {
    usuallyIncludes: ["chicken wings", "grill seasoning", "garlic", "herbs", "dipping sauce"],
  },
  "food-ga-ham-thuoc-bac": {
    atAGlance:
      "Gà hầm thuốc bắc is chicken simmered with Vietnamese-Chinese herbs until the broth is dark, fragrant, and restorative. It is a warming dish for a slower meal.",
    goodToKnow:
      "The herbal flavor is distinctive and not spicy. Ask before ordering if you prefer a lighter chicken soup.",
    usuallyIncludes: ["chicken", "herbal broth", "ginger", "aromatics", "mushrooms"],
  },
  "drink-ca-phe-sua-da": {
    atAGlance:
      "Cà phê sữa đá is Vietnam’s iconic iced milk coffee: strong phin-brewed robusta, sweetened condensed milk, and plenty of ice. Bold, creamy, and made for hot afternoons.",
    goodToKnow:
      "It is usually stronger and sweeter than it looks. Ask for less sweet or more ice if you want it lighter.",
    usuallyIncludes: ["robusta coffee", "phin filter", "condensed milk", "ice"],
  },
  "drink-ca-phe-den-da": {
    atAGlance:
      "Cà phê đen đá is strong phin-brewed black coffee poured over ice. It is bold, bitter, and refreshing when you want the Vietnamese coffee hit without condensed milk.",
    goodToKnow:
      "This is the unsweetened or lightly sweetened black-coffee lane. Ask for đường riêng if you want sugar on the side.",
    usuallyIncludes: ["robusta coffee", "phin filter", "ice"],
  },
  "drink-ca-phe-sua-nong": {
    atAGlance:
      "Cà phê sữa nóng is hot Vietnamese milk coffee: phin-brewed robusta softened with condensed milk. It is sweet, strong, and better when you want the café ritual without ice.",
    goodToKnow:
      "The condensed milk settles low in the cup. Stir until the color evens out, then decide whether you want it stronger next time.",
    usuallyIncludes: ["robusta coffee", "phin filter", "condensed milk"],
    commonOptions: ["less sweet", "stronger", "with ice", "takeaway"],
  },
  "drink-ca-phe-den-nong": {
    atAGlance:
      "Cà phê đen nóng is hot black Vietnamese coffee from a phin filter. It is sharper, more aromatic, and more intense than the milk versions.",
    goodToKnow:
      "Order this when you want the robusta flavor to lead. Ask for sugar on the side if you do not want it pre-sweetened.",
    usuallyIncludes: ["robusta coffee", "phin filter"],
    commonOptions: ["sugar on the side", "stronger", "with ice", "takeaway"],
  },
  "drink-bac-xiu": {
    atAGlance:
      "Bạc xỉu is a softer, milkier coffee with more sweet milk than coffee. It is creamy, gentle, and a good pick if regular Vietnamese coffee feels too strong.",
    goodToKnow:
      "Think of it as coffee-flavored milk rather than a heavy caffeine hit. It is often served iced.",
    usuallyIncludes: ["robusta coffee", "phin filter", "condensed milk", "fresh milk", "ice optional"],
    commonOptions: ["less sweet", "more ice", "less coffee", "takeaway"],
  },
  "drink-ca-phe-trung": {
    atAGlance:
      "Cà phê trứng is Hanoi’s famous egg coffee: strong coffee under a whipped egg-yolk cream that drinks like warm tiramisu. It is rich, sweet, and worth trying slowly.",
    goodToKnow:
      "The egg is whipped into a custardy foam, not cooked like breakfast eggs. Ask whether it is served hot or iced before ordering.",
    usuallyIncludes: ["robusta coffee", "phin filter", "egg cream", "condensed milk"],
    commonOptions: ["hot", "iced", "less sweet", "takeaway"],
  },
  "drink-ca-phe-cot-dua": {
    atAGlance:
      "Cà phê cốt dừa is coconut coffee, often served cold with creamy coconut blended or layered against strong coffee. It feels tropical, rich, and almost dessert-like.",
    goodToKnow:
      "This can be closer to a café treat than a plain coffee. Ask for less sweet if you want the coffee bitterness to stay visible.",
    usuallyIncludes: ["robusta coffee", "phin filter", "coconut cream", "ice"],
    commonOptions: ["less sweet", "more coffee", "less ice", "takeaway"],
  },
  "drink-ca-phe-muoi": {
    atAGlance:
      "Cà phê muối is salt coffee, a creamy Vietnamese coffee with a lightly salted foam that makes the bitter robusta taste rounder and more caramel-like.",
    goodToKnow:
      "The salt should balance the sweetness, not taste like seawater. It is strongly associated with Huế-style café creativity.",
    usuallyIncludes: ["robusta coffee", "phin filter", "salted cream", "condensed milk"],
    commonOptions: ["less sweet", "more coffee", "iced", "takeaway"],
  },
  "drink-ca-phe-phin": {
    atAGlance:
      "Cà phê phin is Vietnamese drip coffee brewed through the small metal filter sitting on the cup. Order it when you want the slow, classic coffee ritual itself.",
    goodToKnow:
      "Phin coffee takes a few minutes. The pause is normal: the drip, the glass, and the slow first sip are part of Vietnamese café culture.",
    usuallyIncludes: ["robusta coffee", "phin filter"],
    commonOptions: ["black", "with condensed milk", "iced", "hot"],
  },
  "drink-ca-phe-sua-tuoi": {
    atAGlance:
      "Cà phê sữa tươi is coffee with fresh milk instead of only condensed milk. It is still Vietnamese coffee, but smoother, lighter, and less sticky-sweet.",
    goodToKnow:
      "This is a useful middle lane if condensed milk feels too heavy but black coffee feels too sharp.",
    usuallyIncludes: ["robusta coffee", "phin filter", "fresh milk", "ice optional"],
    commonOptions: ["less sweet", "more coffee", "iced", "takeaway"],
  },
  "drink-ca-phe-da-xay": {
    atAGlance:
      "Cà phê đá xay is blended iced coffee, a cold café drink where coffee, ice, milk, or cream become a thick shake-like cup.",
    goodToKnow:
      "Expect a dessert texture more than a sidewalk phin coffee. Ask for less sugar if you want it less sweet.",
    usuallyIncludes: ["coffee", "ice", "milk or cream", "sugar optional"],
    commonOptions: ["less sugar", "more coffee", "no whipped cream", "takeaway"],
  },
  "drink-ca-phe-latte": {
    atAGlance:
      "Cà phê latte is the familiar milk-forward latte found in modern Vietnamese cafés. It is useful when you want a softer coffee order in an international café setting.",
    goodToKnow:
      "This is not the classic phin drink, but many city cafés offer it beside Vietnamese coffee styles.",
    usuallyIncludes: ["espresso-style coffee", "steamed or fresh milk"],
    commonOptions: ["hot", "iced", "less sweet", "takeaway"],
  },
  "drink-ca-phe-espresso": {
    atAGlance:
      "Cà phê espresso is a short, concentrated coffee order in modern cafés. It is quick, strong, and different from the slower phin style.",
    goodToKnow:
      "Use this word in espresso-machine cafés. At traditional coffee shops, a black phin coffee may be the more natural strong order.",
    usuallyIncludes: ["espresso coffee", "small cup"],
    commonOptions: ["single", "double", "hot", "takeaway"],
  },
  "drink-ca-phe-mocha": {
    atAGlance:
      "Cà phê mocha is coffee with chocolate and milk, a modern café drink for when you want coffee but also something sweet and dessert-like.",
    goodToKnow:
      "It is familiar and easy in bigger cafés, but it will not tell you as much about Vietnam’s phin coffee culture as the local styles do.",
    usuallyIncludes: ["coffee", "milk", "chocolate"],
    commonOptions: ["hot", "iced", "less sweet", "takeaway"],
  },
  "drink-tra-da": {
    atAGlance:
      "Trà đá is plain iced tea, often served automatically at casual restaurants and street-food spots. It is light, unsweetened or barely sweet, and good with rich food.",
    goodToKnow:
      "It may come free or very cheap, depending on the place. Bottled tea is a different order.",
  },
  "drink-sinh-to-xoai": {
    atAGlance:
      "Sinh tố xoài is a thick mango smoothie, usually blended with ice and milk or condensed milk. It is bright, creamy, and dessert-like.",
    goodToKnow:
      "Ask for less sugar or less condensed milk if you want the fruit flavor to lead.",
  },
  "drink-nuoc-mia": {
    atAGlance:
      "Nước mía is fresh sugarcane juice pressed to order, usually served over ice with a little citrus. It is sweet, grassy, and extremely refreshing.",
    goodToKnow:
      "It is best freshly pressed. If you prefer it less cold, ask for no ice.",
    usuallyIncludes: ["sugarcane juice", "ice", "kumquat or lime"],
  },
  "drink-bia-hoi": {
    atAGlance:
      "Bia hơi is light fresh draft beer, usually served by the glass at casual beer halls and street tables. It is crisp, low-key, and made for sharing snacks.",
    goodToKnow:
      "Order it by the glass, not the bottle. It is usually freshest earlier in the day at busy places.",
    commonOptions: ["by the glass", "cold", "with snacks", "share pitcher"],
    quickSayVietnamese: "Cho tôi một ly bia hơi.",
    quickSayEnglish: "I’d like one glass of fresh draft beer.",
    usuallyIncludes: ["fresh draft beer", "chilled glass", "ice optional"],
  },
};

const guideExactCopy = {
  "food-pho-bo": {
    whatItIs:
      "Phở bò is beef noodle soup with clear, fragrant broth, flat rice noodles, thin slices of beef, onion, herbs, and lime. The best bowls taste clean first, then deepen with beef sweetness and warm spice.",
    howToEnjoy:
      "Taste the broth first, then add herbs, lime, bean sprouts, or chili a little at a time. Keep the seasoning balanced so the broth still leads.",
    worthKnowing:
      "Phở is one of Vietnam’s signature noodle soups, with northern and southern styles differing in broth sweetness, herb plates, and condiments.",
    regionalAssociation: "Vietnam",
    originPosture: "regional-variation",
  },
  "food-bun-cha": {
    whatItIs:
      "Bún chả is grilled pork served with rice vermicelli, herbs, pickles, and warm nước chấm dipping broth. It should smell smoky, taste sweet-savory, and feel fresh from the herbs.",
    howToEnjoy:
      "Dip the pork and noodles into the nước chấm, or spoon a little sauce over the vermicelli. Add herbs and chili slowly so the smoky pork stays clear.",
    worthKnowing:
      "Bún chả is strongly associated with Hanoi. The sauce usually balances fish sauce, vinegar or lime, sugar, garlic, chili, and pickled vegetables.",
    regionalAssociation: "Hanoi",
    originPosture: "regional-association",
  },
  "food-bun-bo-xao": {
    whatItIs:
      "Bún bò xào is stir-fried beef over cool rice vermicelli with herbs, pickles, peanuts or fried shallots, and nước chấm. It is savory, bright, crunchy, and built for mixing.",
    howToEnjoy:
      "Pour the nước chấm gradually, then mix so the beef juices, herbs, noodles, and crunch share the flavor. Ask for no chili or no peanuts before it is assembled.",
    worthKnowing:
      "Nước chấm is the usual sauce: fish sauce balanced with lime, sugar, garlic, and chili. It is a dressing for the bowl, not a thick gravy.",
    originPosture: "category-context",
  },
  "food-bun-cha-ca": {
    whatItIs:
      "Bún chả cá is rice vermicelli with springy fish cakes, herbs, fried shallots, and a light sauce or broth depending on the shop. The flavor is seafood-savory and gentler than pork-heavy vermicelli bowls.",
    howToEnjoy:
      "Taste the fish cakes first, then add herbs, chili, or sauce gradually. If it comes with broth, sip before adding lime or chili.",
    worthKnowing:
      "Chả cá means fish cake in this dish. It is separate from Bún chả, the grilled-pork vermicelli dish, even though the names look close.",
    originPosture: "name-and-menu-context",
  },
  "food-bun-bo-hue": {
    whatItIs:
      "Bún bò Huế is a bold central-Vietnam noodle soup with lemongrass, chili warmth, beef, and thicker round noodles. It is richer, deeper, and usually spicier than phở.",
    howToEnjoy:
      "Taste before adding chili. If heat is a concern, ask for less spicy early, then use the herbs and lime to brighten the broth.",
    worthKnowing:
      "The name points to Huế, the former imperial capital, and the dish is strongly associated with central Vietnam. Recipes still shift by shop, especially the spice level and toppings.",
    regionalAssociation: "Huế and central Vietnam",
    originPosture: "regional-association",
  },
  "food-hu-tieu-nam-vang": {
    whatItIs:
      "Hủ tiếu Nam Vang is a rice-noodle soup with a clear savory broth and toppings that often include pork, shrimp, herbs, and crisp vegetables. It can feel lighter and more flexible than heavier beef soups.",
    howToEnjoy:
      "Ask whether it comes nước or khô if the shop offers both: soup-style or dry with broth on the side. Add chili slowly because the clear broth is easy to overwhelm.",
    worthKnowing:
      "The name points to Nam Vang, the Vietnamese name for Phnom Penh, and the dish is especially common in southern Vietnam. Treat that as menu context rather than one fixed recipe.",
    regionalAssociation: "southern Vietnam and Phnom Penh-style rice-noodle shops",
    originPosture: "commonly-associated-context",
  },
  "food-banh-mi-thit": {
    whatItIs:
      "Bánh mì thịt is a crisp Vietnamese baguette filled with pork, pickled vegetables, herbs, and often pâté or sauce. It is fast, portable, and one of the easiest street-food wins.",
    howToEnjoy:
      "Ask for no chili if you are heat-sensitive. Eat it soon after it is made, while the bread is still crisp and the pickles cut through the rich filling.",
    worthKnowing:
      "Bánh mì reflects Vietnam’s own baguette culture: French-influenced bread became a Vietnamese street-food form with local fillings, herbs, pickles, and sauces.",
    regionalAssociation: "Vietnam",
    originPosture: "cultural-context",
  },
  "food-banh-mi-bo-kho": {
    whatItIs:
      "Bánh mì bò kho is Vietnamese beef stew served with bread for dipping. The bowl brings tender beef, carrots, warm spice, herbs, and broth that the baguette is meant to catch.",
    howToEnjoy:
      "Tear the bread and dip it into the stew while the broth is hot. Add herbs, lime, or chili gradually so the warm spice stays balanced.",
    worthKnowing:
      "This order shows another side of bánh mì: bread as a tool for broth, not just a sandwich. Bò kho itself is a Vietnamese comfort stew with beef, carrots, and aromatics.",
    regionalAssociation: "Vietnam",
    originPosture: "cultural-context",
  },
  "food-banh-tieu": {
    whatItIs:
      "Bánh tiêu is a hollow sesame donut with a crisp outside, airy middle, and gentle sweetness. It is a street snack or bakery bite rather than a filled dessert.",
    howToEnjoy:
      "Eat it fresh if possible, while the outside still crackles. It is best simple: sesame aroma, light sweetness, and warm dough.",
    worthKnowing:
      "Bánh tiêu belongs to Vietnam’s everyday snack world, where fried dough, sesame, and portable bakery treats sit beside savory bread orders.",
    originPosture: "cultural-context",
  },
  "food-banh-pate-so": {
    whatItIs:
      "Bánh patê sô is a savory puff pastry with flaky layers and seasoned filling. It is familiar in shape but belongs naturally to Vietnamese bakery counters.",
    howToEnjoy:
      "Eat it warm for the best flaky texture. It works as a quick bakery snack rather than a full sandwich.",
    worthKnowing:
      "Patê sô reflects Vietnam’s bakery culture, where flaky pastry and savory fillings sit beside bánh mì and sweet snacks.",
    originPosture: "cultural-context",
  },
  "food-sup-cua": {
    whatItIs:
      "Súp cua is a thick crab soup, often with egg ribbons, pepper, cilantro, and corn or asparagus. It is a warm street snack, not a roll or salad.",
    howToEnjoy:
      "Eat it hot with pepper and herbs on top. If it is thick, stir once so the crab, egg, and broth stay balanced.",
    worthKnowing:
      "Súp cua is a small, comforting soup often sold as a snack. The texture should be silky, with crab sweetness and pepper doing most of the work.",
    originPosture: "cultural-context",
  },
  "food-banh-xeo": {
    whatItIs:
      "Bánh xèo is a sizzling turmeric-rice pancake folded around pork, shrimp, bean sprouts, and herbs. The fun is the contrast: crisp edges, fresh greens, and bright dipping sauce.",
    howToEnjoy:
      "Tear off a piece, wrap it with herbs or lettuce if served, then dip lightly. The sauce and herbs are part of the dish, not decoration.",
    worthKnowing:
      "Bánh xèo appears in different regional styles, from smaller central versions to larger southern pancakes, so size and fillings can change a lot.",
    regionalAssociation: "Vietnam",
    originPosture: "regional-variation",
  },
  "food-ngheu-xao-bo-toi": {
    whatItIs:
      "Nghêu xào bơ tỏi is clams stir-fried in garlic-butter sauce. It is briny, rich, aromatic, and best while the shells are still hot.",
    howToEnjoy:
      "Eat the clams hot and use rice or bread if you want to catch the garlic-butter sauce. Ask for less chili if you want the butter and clam flavor to stay clear.",
    worthKnowing:
      "Bơ tỏi means butter-garlic, not beef. On seafood menus, that phrase usually signals a rich garlic-butter sauce.",
    originPosture: "name-and-menu-context",
  },
  "food-ca-ri-de": {
    whatItIs:
      "Cà ri dê is goat curry with warm spice, tender goat, and a rich sauce often eaten with bread, rice, or noodles. It is aromatic and fuller-bodied than chicken curry.",
    howToEnjoy:
      "Ask whether it comes with bread, rice, or noodles. Use the starch to soften the curry and carry the sauce.",
    worthKnowing:
      "Dê means goat. In curry, the meat can be more aromatic than beef or chicken, so the spice and herbs do real work.",
    originPosture: "name-and-menu-context",
  },
  "food-cao-lau": {
    whatItIs:
      "Cao lầu is a Hội An noodle bowl with chewy noodles, pork, herbs, crisp bits, and just enough sauce to coat everything. It feels more like a composed local specialty than a soup.",
    howToEnjoy:
      "Mix the bowl so the sauce reaches the noodles, herbs, and pork. Add chili slowly if you want heat without losing the chewy noodle flavor.",
    worthKnowing:
      "Cao lầu is strongly associated with Hội An. The noodles, herbs, pork, and restrained sauce are part of the dish’s local identity.",
    regionalAssociation: "Hội An",
    originPosture: "regional-association",
  },
  "food-com-tam-suon": {
    whatItIs:
      "Cơm tấm sườn is a broken-rice plate with grilled pork chop, pickles, scallion oil, and fish-sauce dressing. It is smoky, savory, and built like a complete meal.",
    howToEnjoy:
      "Pour the sauce gradually so the rice gets flavor without turning wet. A fried egg is a common upgrade if you want the plate richer.",
    worthKnowing:
      "Cơm tấm is especially associated with southern Vietnam and Saigon-style everyday eating, where broken rice became a beloved base for grilled pork plates.",
    regionalAssociation: "southern Vietnam",
    originPosture: "regional-association",
  },
  "food-goi-cuon": {
    whatItIs:
      "Gỏi cuốn are fresh rice-paper rolls with herbs, noodles, and a light filling such as shrimp, pork, or tofu. They are cool, clean, and a gentle way into Vietnamese flavors.",
    howToEnjoy:
      "Dip, do not soak. Peanut sauce is richer; nước chấm is lighter, salty-sweet, and brighter.",
    worthKnowing:
      "These rolls are often called fresh spring rolls in English, which helps distinguish them from fried chả giò or nem rán.",
    regionalAssociation: "Vietnam",
    originPosture: "name-and-menu-context",
  },
  "food-bo-kho-banh-mi": {
    whatItIs:
      "Bò kho bánh mì is Vietnamese beef stew served with bread for dipping. The bowl brings tender beef, carrots, warm spice, herbs, and broth that the baguette is meant to catch.",
    howToEnjoy:
      "Tear the bread and dip it into the stew while the broth is hot. Add herbs, lime, or chili gradually so the warm spice stays balanced.",
    worthKnowing:
      "Bò kho is a Vietnamese comfort stew. With bánh mì, the bread is part of the dish because it carries the broth and sauce.",
    originPosture: "cultural-context",
  },
  "food-bun-dau-mam-tom": {
    whatItIs:
      "Bún đậu mắm tôm is a platter of rice vermicelli, fried tofu, herbs, and pungent shrimp-paste sauce, often with pork or other add-ons. It is vivid, salty, and very different from a tidy noodle bowl.",
    howToEnjoy:
      "Try the sauce carefully first; mắm tôm is strong even for confident eaters. If the aroma feels like too much, ask whether a milder fish-sauce dip is available.",
    worthKnowing:
      "Bún đậu mắm tôm is closely tied to casual northern-style snacking and sharing. The sauce is the point, so it is worth knowing before you order.",
    regionalAssociation: "northern Vietnam",
    originPosture: "regional-association",
    travelerCaution: "Contains shrimp paste and may include pork.",
  },
  "food-bun-mang-vit": {
    whatItIs:
      "Bún măng vịt is duck and bamboo shoot vermicelli soup. The broth is savory and warming, with bamboo shoots adding earthy crunch and herbs brightening the duck.",
    howToEnjoy:
      "Taste the broth first, then use the ginger fish-sauce dip for the duck. Add herbs and chili gradually so the bamboo shoot flavor still comes through.",
    worthKnowing:
      "Duck noodle soups often depend on the side dip as much as the broth. Ginger, fish sauce, and chili cut through the richness of the duck.",
    originPosture: "category-context",
  },
  "drink-ca-phe-sua-da": {
    whatItIs:
      "Cà phê sữa đá is strong Vietnamese robusta coffee mixed with sweetened condensed milk and poured over ice. It is bold, creamy, and made for hot afternoons.",
    howToEnjoy:
      "Stir well before drinking so the condensed milk lifts through the coffee. Ask for less sweet or more ice if you want it lighter.",
    worthKnowing:
      "This is the everyday icon of Vietnamese iced coffee. The flavor comes from robusta strength, condensed milk sweetness, and a slow phin drip.",
    regionalAssociation: "Vietnam",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-den-da": {
    whatItIs:
      "Cà phê đen đá is iced black Vietnamese coffee. Without condensed milk, the robusta comes through darker, sharper, and more refreshing over ice.",
    howToEnjoy:
      "Sip before adding sugar. If it is stronger than expected, ask for more ice or sugar on the side instead of turning it into milk coffee.",
    worthKnowing:
      "This is the cleanest way to taste the coffee base behind many Vietnamese café drinks: phin-brewed, bold, and often more intense than a typical American iced coffee.",
    regionalAssociation: "Vietnam",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-sua-nong": {
    whatItIs:
      "Cà phê sữa nóng is hot phin coffee with condensed milk. It keeps the sweet, creamy Vietnamese coffee profile but drops the ice.",
    howToEnjoy:
      "Stir from the bottom so the condensed milk fully blends into the coffee. Drink it slowly while the cup is still warm.",
    worthKnowing:
      "Hot milk coffee is useful in rainy weather, air-conditioned cafés, or early mornings when iced coffee feels too sharp.",
    regionalAssociation: "Vietnam",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-den-nong": {
    whatItIs:
      "Cà phê đen nóng is hot black Vietnamese coffee, usually phin-brewed and served small, strong, and aromatic.",
    howToEnjoy:
      "Treat it like a slow strong cup, not a large mug. Ask for sugar separately if you want to control the sweetness.",
    worthKnowing:
      "This order is a good bridge between espresso habits and Vietnamese phin culture: concentrated like a short coffee, but brewed with a different rhythm.",
    regionalAssociation: "Vietnam",
    originPosture: "cultural-context",
  },
  "drink-bac-xiu": {
    whatItIs:
      "Bạc xỉu is a milkier, gentler coffee drink with more sweet milk than coffee. It is creamy and friendly if regular Vietnamese coffee feels too strong.",
    howToEnjoy:
      "Order it iced when you want something cool and soft. Think of it as coffee-flavored milk rather than a heavy caffeine hit.",
    worthKnowing:
      "Bạc xỉu is closely associated with Saigon and Chợ Lớn café culture. The idea is simple and charming: lots of milk, just enough coffee.",
    regionalAssociation: "southern Vietnam",
    originPosture: "commonly-associated-context",
  },
  "drink-ca-phe-trung": {
    whatItIs:
      "Cà phê trứng is Hanoi-born egg coffee: strong coffee topped with whipped egg-yolk cream, sugar, and condensed milk. It tastes more like a warm coffee custard than a normal cup.",
    howToEnjoy:
      "Try the foam first, then stir if you want the creamy layer to blend into the coffee. Order it when you want a small dessert-like café moment.",
    worthKnowing:
      "Egg coffee is one of Vietnam’s most famous coffee creations and is strongly tied to Hanoi café culture. The backstory often points to resourceful cafés making richness from scarce milk.",
    regionalAssociation: "Hanoi",
    originPosture: "regional-association",
  },
  "drink-ca-phe-cot-dua": {
    whatItIs:
      "Cà phê cốt dừa is coconut coffee, usually cold, creamy, and layered or blended so coconut sweetness meets strong Vietnamese coffee.",
    howToEnjoy:
      "Let it soften for a moment if it arrives icy or blended. Stir lightly when you want the coconut and coffee to mix instead of staying in layers.",
    worthKnowing:
      "Coconut coffee shows the modern playful side of Vietnamese cafés: still built on a bold coffee base, but closer to a tropical dessert drink.",
    regionalAssociation: "Vietnamese cafés",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-muoi": {
    whatItIs:
      "Cà phê muối is salt coffee: robusta coffee with sweet milk and a lightly salted cream. The salt makes the cup taste round, rich, and caramel-like.",
    howToEnjoy:
      "Sip before judging the salt. A good cup should feel balanced, with the salt sharpening the cream and softening the coffee bitterness.",
    worthKnowing:
      "Salt coffee is especially associated with Huế, and it has spread because the sweet-salty balance feels both familiar and surprising.",
    regionalAssociation: "Huế",
    originPosture: "regional-association",
  },
  "drink-ca-phe-phin": {
    whatItIs:
      "Cà phê phin is coffee brewed through Vietnam’s small metal drip filter. It is less a flavor name than a way of making and waiting for the cup.",
    howToEnjoy:
      "Give the drip time. When the filter finishes, stir if milk is present, add ice if you want it cold, and taste before changing sweetness.",
    worthKnowing:
      "The phin filter is part of the social rhythm of Vietnamese cafés: order, sit, watch the drip, then linger over a strong small glass.",
    regionalAssociation: "Vietnam",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-sua-tuoi": {
    whatItIs:
      "Cà phê sữa tươi is Vietnamese coffee with fresh milk. Compared with condensed-milk coffee, it usually tastes lighter, smoother, and less syrupy.",
    howToEnjoy:
      "Choose it when you want milk coffee without the full sweetness of condensed milk. Ask for less sugar if the café sweetens it separately.",
    worthKnowing:
      "Fresh-milk coffee is common in modern cafés, where Vietnamese coffee habits meet latte-style preferences.",
    regionalAssociation: "Vietnamese cafés",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-da-xay": {
    whatItIs:
      "Cà phê đá xay is blended iced coffee, usually coffee, ice, milk or cream, and sugar turned into a thick café drink.",
    howToEnjoy:
      "Treat it like a cold dessert coffee. Ask for less sugar or more coffee if you want the drink less sweet and more grown-up.",
    worthKnowing:
      "This is the menu item for modern air-conditioned cafés, not the sidewalk phin ritual. It is still useful when you want a cold familiar order.",
    regionalAssociation: "modern Vietnamese cafés",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-latte": {
    whatItIs:
      "Cà phê latte is a latte-style coffee order with milk. It is the safer familiar choice in cafés that also serve espresso drinks.",
    howToEnjoy:
      "Ask whether it is hot or iced if the menu does not say. If you want a Vietnamese-style cup, choose phin coffee instead.",
    worthKnowing:
      "Vietnam’s café scene now includes both traditional phin drinks and global espresso drinks, so latte can be useful even though it is not the local classic.",
    regionalAssociation: "modern Vietnamese cafés",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-espresso": {
    whatItIs:
      "Cà phê espresso is espresso, a short concentrated coffee from an espresso machine rather than a phin filter.",
    howToEnjoy:
      "Use this in modern cafés where espresso machines are visible. In a traditional shop, ask for black phin coffee instead.",
    worthKnowing:
      "Espresso belongs to Vietnam’s modern café layer, but it is not the same experience as watching coffee drip through a phin.",
    regionalAssociation: "modern Vietnamese cafés",
    originPosture: "cultural-context",
  },
  "drink-ca-phe-mocha": {
    whatItIs:
      "Cà phê mocha is coffee with milk and chocolate. It is sweet, soft, and familiar when you want dessert energy more than a classic Vietnamese coffee.",
    howToEnjoy:
      "Ask for less sweet if you want the coffee to show through. It can be hot or iced depending on the café.",
    worthKnowing:
      "Mocha belongs to Vietnam’s modern café menu layer. The cultural story is stronger in phin, egg, salt, coconut, and bạc xỉu drinks.",
    regionalAssociation: "modern Vietnamese cafés",
    originPosture: "cultural-context",
  },
};

const categoryTips = {
  "Noodle soups": [
    "Taste the broth before adding chili or lime. The side herbs are there so you can season the bowl your way.",
    "Many noodle soups come with herbs, lime, and bean sprouts on the side. Add a little at a time.",
    "If you want a milder bowl, ask for less spicy or no chili. The soup will still have plenty of flavor.",
    "Noodle soups are common for breakfast or lunch, but you will find them throughout the day in busy areas.",
  ],
  "Dry noodles & vermicelli": [
    "These bowls are meant to be mixed. Pour the sauce gradually, then toss the noodles with herbs and toppings.",
    "If the sauce comes on the side, start with half. You can always add more after the noodles are mixed.",
    "Fresh herbs and crunchy toppings are part of the texture. Ask for no chili if you want the bowl gentler.",
    "Dry noodle bowls are filling without being soupy, which makes them easy in hot weather.",
  ],
  "Rice & sticky rice": [
    "Rice plates often come with pickles, herbs, and a small bowl of sauce. Add the sauce slowly.",
    "A fried egg is a common add-on for rice plates. It makes the order richer and more filling.",
    "These are dependable lunch orders: quick to serve, filling, and balanced by pickles or sauce.",
    "If the plate looks dry, the dipping sauce is usually meant to be spooned over the rice.",
  ],
  "Rolls, appetizers & street snacks": [
    "These are good shared starters. Ask for extra dipping sauce if everyone at the table is trying them.",
    "Fresh herbs are part of the flavor, not a garnish. Skip chili if you want the dip milder.",
    "Street snacks vary by region and stall. The sauce, herbs, and texture usually tell you how the bite is meant to work.",
    "If you are ordering several snacks, ask which sauce goes with which plate.",
  ],
  "Bánh mì, bread & buns": [
    "No chili is a useful request for bánh mì. Extra pickles or pâté are common upgrades.",
    "Bánh mì is usually quick and portable, but fillings vary a lot by stall.",
    "If the bread is not already toasted, you can ask for it toasted for more crunch.",
    "Some fillings are rich or saucy. Keep a napkin close if you are eating while walking.",
  ],
  Seafood: [
    "Seafood portions and prices can vary by weight. Ask the price first at seafood restaurants.",
    "Salt-pepper-lime dip is common with seafood. It adds brightness without covering the main flavor.",
    "Seafood dishes are often shared. Ask for rice if you want to make the plate a fuller meal.",
    "If bones or shells worry you, ask what is easiest to eat before ordering.",
  ],
  Pork: [
    "Pork dishes often pair well with plain rice, pickles, and herbs to balance the richness.",
    "Ask for less spicy if the dish has chili, or extra sauce if you plan to eat it with rice.",
    "Many pork plates are savory-sweet from caramel, grill seasoning, or fish sauce glaze.",
    "If you are sharing, order rice or vegetables alongside the richer pork dishes.",
  ],
  "Chicken & duck": [
    "Chicken and duck dishes often come with herbs, dipping sauce, or rice. Ask what comes with the plate.",
    "Grilled and fried versions are usually richer; steamed or boiled versions feel lighter.",
    "If you prefer less heat, ask for no chili or keep the dipping sauce on the side.",
    "Duck can be richer than chicken, so it is often best with herbs, pickles, or rice.",
  ],
  "Beef & goat": [
    "Beef and goat dishes can be richer or more aromatic than chicken dishes. Rice or bread helps balance them.",
    "Ask whether the dish comes with bread, noodles, or rice if the menu is unclear.",
    "Grilled versions are good for sharing; stews are better when you want a full meal.",
    "Goat dishes may have stronger seasoning. Ask for a recommendation if you are unsure.",
  ],
  Vegetarian: [
    "Vegetarian dishes may still use fish sauce at some places. Ask for chay if you need fully vegetarian food.",
    "Tofu, mushrooms, and greens are common bases. Soy sauce is the safer request than fish sauce.",
    "Vegetarian plates are usually lighter, but fried tofu and braised sauces can still be very satisfying.",
    "If you avoid egg or dairy, ask specifically; chay can mean different things by restaurant.",
  ],
  "Soups, hot pots & family-style": [
    "Family-style dishes are often shared. Ask for rice, noodles, or vegetables if they are not included.",
    "Hot pots usually arrive with raw or partly prepared ingredients that cook at the table.",
    "These dishes take more table space and time, so they are better for a sit-down meal.",
    "Ask for less spicy broth if you are ordering for a group with mixed spice tolerance.",
  ],
  "Desserts & sweets": [
    "Vietnamese desserts can be sweet, creamy, icy, or warm. Ask for less sweet if you prefer a lighter finish.",
    "Coconut milk and ice are common. Ask for no coconut or less ice when needed.",
    "Many desserts are served in small portions, so they are easy to try after a meal.",
    "Texture matters: beans, jellies, sticky rice, and fruit often share the same cup or bowl.",
  ],
  Coffee: [
    "Vietnamese coffee is usually strong. Ask for less sweet, more ice, or black coffee if you want it lighter.",
    "Phin-brewed coffee can take a few minutes. That slow drip is part of the experience.",
    "Condensed milk makes coffee sweet and creamy. Ask for black coffee if you want a sharper taste.",
    "Iced coffee is common, but hot versions are easy to order in cafés.",
  ],
  Tea: [
    "Tea can be plain, sweetened, fruity, or milky. Ask for less sweet if the drink is made to order.",
    "Iced tea may come very cold and light. Hot tea is usually served in a cup or small pot.",
    "Fruit teas can be sweeter than they look. No ice and less sugar are easy requests.",
    "Bubble tea and milk tea are dessert-like compared with plain Vietnamese tea.",
  ],
  Smoothies: [
    "Smoothies are often blended with ice and milk or condensed milk. Ask for less sugar if you want more fruit flavor.",
    "A smoothie can be closer to dessert than juice. It is a good cooling order in the afternoon.",
    "Some fruit smoothies are naturally creamy, especially avocado, coconut, and soursop.",
    "If you do not want dairy, ask before ordering; many stalls add milk by default.",
  ],
  "Juices & fresh drinks": [
    "Fresh drinks are usually served over ice. Ask for no ice or less sugar if you want more control.",
    "Some juices are pressed to order, while others may be pre-mixed at busy stalls.",
    "Citrus and cane drinks are especially refreshing with salty or grilled food.",
    "If sweetness matters, ask for less sugar before the drink is mixed.",
  ],
  "Water, soda & other drinks": [
    "For bottled drinks, ask for cold if you want it chilled. Ice may come separately.",
    "Beer and soda are usually easy pointing orders. Draft beer is ordered by the glass.",
    "Packaged drinks may come by bottle or can depending on the shop.",
    "If you are avoiding alcohol, check beer and rice-wine names carefully before ordering.",
  ],
};

function polishItem(item) {
  const polished = {
    atAGlance: atAGlanceFor(item),
    usuallyIncludes: includesFor(item),
    goodToKnow: tipFor(item),
    commonOptions: optionsFor(item),
    quickSayEnglish: quickSayEnglishFor(item),
  };
  const exact = {
    ...(exactCopy[item.itemID] ?? {}),
    ...(culturalOverrides[item.itemID] ?? {}),
  };
  const guideBase = {
    ...item,
    ...polished,
    ...exact,
  };
  const guide = guideCopyFor(guideBase);

  for (const field of [
    "whatItIs",
    "howToEnjoy",
    "worthKnowing",
    "regionalAssociation",
    "originPosture",
    "travelerCaution",
  ]) {
    if (Object.prototype.hasOwnProperty.call(exact, field)) {
      guide[field] = exact[field];
    }
  }
  guide.worthKnowing = vietnamConnectionCopyFor(item, guide.worthKnowing);

  return {
    ...polished,
    ...exact,
    ...guide,
  };
}

function atAGlanceFor(item) {
  const name = descriptiveName(item);
  const main = mainIngredient(item);
  const text = searchableText(item);

  switch (item.category) {
    case "Noodle soups":
      if (/porridge/i.test(item.englishTranslation)) {
        return `${item.vietnameseItem} is a comforting rice porridge with ${main}, scallions, and gentle savory flavor. It is warm, soft, and easy when you want a simple bowl.`;
      }
      return noodleSoupAtAGlanceFor(item);
    case "Dry noodles & vermicelli":
      return dryNoodleAtAGlanceFor(item);
    case "Rice & sticky rice":
      if (/sticky rice/i.test(item.englishTranslation) || item.itemID.includes("xoi")) {
        return `${item.vietnameseItem} is a sticky-rice order with ${main} and savory toppings. It is compact, filling, and common for breakfast or a quick meal.`;
      }
      return `${item.vietnameseItem} is a rice plate with ${name}, vegetables or pickles, and a small seasoning sauce. It is hearty, direct, and complete on one plate.`;
    case "Rolls, appetizers & street snacks":
      return snackAtAGlanceFor(item);
    case "Bánh mì, bread & buns":
      if (/stew/i.test(item.englishTranslation)) {
        return `${item.vietnameseItem} pairs crisp bread with ${name}, so you can dip into the broth and eat it like a hearty meal.`;
      }
      if (/banh-tieu|bánh tiêu|sesame donut/.test(text)) {
        return `${item.vietnameseItem} is a hollow sesame donut with a crisp outside, airy middle, and gentle sweetness. It is a street snack, not a sandwich.`;
      }
      if (/pate-so|patê sô|pâté sô|puff pastry/.test(text)) {
        return `${item.vietnameseItem} is a savory puff pastry with flaky layers and seasoned filling. It belongs to Vietnam’s bakery-counter snack lane.`;
      }
      if (/banh-bao|bánh bao|steamed bun/.test(text)) {
        return `${item.vietnameseItem} is a soft steamed bun with ${bunFillingName(item)} inside slightly sweet dough. It is filling enough for breakfast or a snack.`;
      }
      return `${item.vietnameseItem} is a Vietnamese bread order with ${main}, pickles, herbs, and a crisp baguette or soft bun. It is quick, satisfying, and easy to eat on the go.`;
    case "Seafood":
      return `${item.vietnameseItem} is ${name}, usually lifted by herbs, garlic, chili, or ${sauceNameFor(item)}. Seafood plates like this are often ordered for the table.`;
    case "Pork":
      return `${item.vietnameseItem} is ${name}, a savory pork order that works especially well with rice, pickles, herbs, or ${sauceNameFor(item)}.`;
    case "Chicken & duck":
      return `${item.vietnameseItem} is ${name}, a familiar poultry order usually served with herbs, rice, or ${sauceNameFor(item)} on the side.`;
    case "Beef & goat":
      return `${item.vietnameseItem} is ${name}, a hearty beef or goat order that is often best with bread, noodles, rice, or fresh herbs.`;
    case "Vegetarian":
      return `${item.vietnameseItem} is a meat-free Vietnamese dish with ${vegetarianAnchorFor(item)}, often plus tofu, mushrooms, greens, or soy-based sauce. It can be light, filling, or fried depending on the shop.`;
    case "Soups, hot pots & family-style":
      return `${item.vietnameseItem} is a shared-style dish with ${name}, built for a slower meal with rice, noodles, vegetables, or broth at the table.`;
    case "Desserts & sweets":
      return `${item.vietnameseItem} is a Vietnamese sweet with ${name}. Expect a small, satisfying finish that may be creamy, icy, chewy, or fruit-forward.`;
    case "Coffee":
      return `${item.vietnameseItem} is ${name} on the Vietnamese coffee menu. Notice whether the cup is phin-brewed or espresso-style, black or milky, hot or iced, then tune sugar and ice with the helper phrases.`;
    case "Tea":
      if (/hot|nong|nóng/.test(searchableText(item))) {
        return `${item.vietnameseItem} is a simple hot tea order, usually served in a cup or small pot. It is light, calming, and good beside a meal.`;
      }
      return `${item.vietnameseItem} is ${name}, a tea drink that can be light and refreshing or sweet and dessert-like, depending on the style.`;
    case "Smoothies":
      return `${item.vietnameseItem} is a thick smoothie made with ${main}, usually blended with ice and milk or condensed milk. It is cool, creamy, and fruit-forward.`;
    case "Juices & fresh drinks":
      return `${item.vietnameseItem} is a fresh Vietnamese drink with ${freshDrinkBase(item)}, usually served cold over ice. It is a bright pick when you want something refreshing.`;
    case "Water, soda & other drinks":
      if (isBeer(item)) {
        return `${item.vietnameseItem} is a beer order: ${name}. It is casual, cold, and usually ordered with snacks or a shared table meal.`;
      }
      if (isWineOrLiquor(item)) {
        return `${item.vietnameseItem} is an alcoholic drink: ${name}. Order it deliberately and ask about the pour or bottle size if you are unsure.`;
      }
      return `${item.vietnameseItem} is ${name}, a cold, simple, or familiar drink order. Check whether it comes chilled or with ice on the side.`;
    default:
      return `${item.vietnameseItem} is a Vietnamese menu name for ${name}. The Vietnamese wording helps when English translations vary by shop.`;
  }
}

function includesFor(item) {
  const text = searchableText(item);
  switch (item.category) {
    case "Noodle soups":
      if (/porridge|chao/.test(text)) {
        return ["rice porridge", mainIngredient(item), "scallions", "pepper", "fried shallots"];
      }
      return ["broth", noodleType(item), mainIngredient(item), "herbs", "lime"];
    case "Dry noodles & vermicelli":
      return [noodleType(item), dryNoodleMainFor(item), "fresh herbs", sauceNameFor(item), dryNoodleCrunchFor(item)];
    case "Rice & sticky rice":
      if (/xoi|sticky rice/.test(text)) {
        return ["sticky rice", mainIngredient(item), "fried shallots", "savory topping"];
      }
      return [riceType(item), mainIngredient(item), "pickles or vegetables", "scallion oil", "dipping sauce"];
    case "Rolls, appetizers & street snacks":
      return snackIncludesFor(item);
    case "Bánh mì, bread & buns":
      if (/banh-mi-bo-kho|bánh mì bò kho|stew/.test(text)) {
        return ["baguette", "beef stew", "carrots", "herbs", "spiced broth"];
      }
      if (/bao|bun/.test(text)) {
        return ["soft bun", mainIngredient(item), "savory filling"];
      }
      if (/banh-tieu|bánh tiêu|sesame donut/.test(text)) {
        return ["fried sesame dough", "hollow center", "light sweetness"];
      }
      if (/pate-so|patê sô|pâté sô|puff pastry/.test(text)) {
        return ["puff pastry", "savory filling", "buttery layers"];
      }
      return ["baguette", mainIngredient(item), "pickled vegetables", "cilantro", "chili optional"];
    case "Seafood":
      return [mainIngredient(item), seafoodCookingCue(item), "garlic or lemongrass", "herbs", sauceNameFor(item)];
    case "Pork":
      return [mainIngredient(item), porkCookingCue(item), "garlic", "scallions", sauceNameFor(item)];
    case "Chicken & duck":
      return [mainIngredient(item), poultryCookingCue(item), "garlic", "herbs", sauceNameFor(item)];
    case "Beef & goat":
      if (/stew|kho|sot-vang|bò kho|bo-kho/.test(text)) {
        return [mainIngredient(item), "spiced broth", "carrots", "herbs", "bread or noodles"];
      }
      return [mainIngredient(item), "garlic", "herbs", sauceNameFor(item), "rice optional"];
    case "Vegetarian":
      if (/bun|bún|vermicelli/.test(text)) {
        return [noodleType(item), "vegetables", "mushrooms or tofu", "herbs", sauceNameFor(item)];
      }
      return [vegetarianAnchorFor(item), "vegetables", "mushrooms or tofu", "herbs", sauceNameFor(item)];
    case "Soups, hot pots & family-style":
      return [mainIngredient(item), soupOrHotPotBaseFor(item), "vegetables", "herbs", "rice or noodles"];
    case "Desserts & sweets":
      if (/fruit|trai-cay/.test(text)) {
        return ["fresh fruit", "ice optional", "syrup or yogurt optional"];
      }
      if (/che|chè/.test(text)) {
        return ["sweet soup or pudding", "beans or fruit", "coconut milk", "ice optional"];
      }
      return ["sweet base", "coconut or milk", "chewy or creamy texture"];
    case "Coffee":
      return coffeeIncludes(item);
    case "Tea":
      return teaIncludes(item);
    case "Smoothies":
      return [mainIngredient(item), "ice", "milk or condensed milk", "sugar optional"];
    case "Juices & fresh drinks":
      return juiceIncludes(item);
    case "Water, soda & other drinks":
      return otherDrinkIncludes(item);
    default:
      return item.usuallyIncludes;
  }
}

function optionsFor(item) {
  const text = searchableText(item);
  switch (item.category) {
    case "Noodle soups":
      return ["extra herbs", "chili", "bean sprouts", "less spicy", "no MSG"];
    case "Dry noodles & vermicelli":
      return ["extra sauce", "more herbs", "no chili", "extra noodles"];
    case "Rice & sticky rice":
      if (/xoi|xôi|sticky rice/.test(text)) {
        return ["extra topping", "fried shallots", "takeaway", "small portion"];
      }
      if (/com-chien|cơm chiên|fried rice|com-rang|cơm rang/.test(text)) {
        return ["extra vegetables", "less oil", "fried egg", "share size"];
      }
      if (/com-tam|cơm tấm|broken rice/.test(text)) {
        return ["fried egg", "extra nước mắm", "extra pickles", "extra rice"];
      }
      return ["fried egg", "extra rice", "less sauce", "extra pickles"];
    case "Rolls, appetizers & street snacks":
      if (/sup-cua|súp cua|crab soup/.test(text)) {
        return ["pepper", "extra crab", "cilantro", "small bowl"];
      }
      if (/goi-cuon|gỏi cuốn/.test(text)) {
        return ["peanut sauce", "nước chấm", "more herbs", "no chili"];
      }
      if (/goi-|gỏi|nom-|nộm|salad/.test(text)) {
        return ["less chili", "extra peanuts", "more herbs", "share size"];
      }
      if (/khoai-lang-chien|khoai-tay-chien|ca-vien-chien|fried sweet potato|french fries|fish balls/.test(text)) {
        return ["chili sauce", "freshly fried", "takeaway", "share size"];
      }
      return ["extra dipping sauce", "more herbs", "no chili", "share size"];
    case "Bánh mì, bread & buns":
      if (/banh-mi-bo-kho|bánh mì bò kho|stew/.test(text)) {
        return ["extra bread", "less spicy", "extra herbs", "share size"];
      }
      if (/banh-tieu|bánh tiêu|sesame donut/.test(text)) {
        return ["freshly fried", "takeaway", "share size"];
      }
      if (/pate-so|patê sô|pâté sô|puff pastry/.test(text)) {
        return ["warm", "takeaway", "share size"];
      }
      if (/banh-bao|bánh bao|steamed bun/.test(text)) {
        return ["warm", "takeaway", "extra filling", "share size"];
      }
      return ["no chili", "extra pâté", "extra pickles", "toasted bread"];
    case "Seafood":
      return ["salt-pepper-lime dip", "share size", "with rice", "extra sauce"];
    case "Pork":
    case "Chicken & duck":
    case "Beef & goat":
      return ["less spicy", "extra sauce", "with rice", "share size"];
    case "Vegetarian":
      return ["no fish sauce", "extra tofu", "with rice", "less spicy"];
    case "Soups, hot pots & family-style":
      return ["less spicy broth", "extra vegetables", "extra noodles", "share size"];
    case "Desserts & sweets":
      return ["less sweet", "more ice", "no coconut", "takeaway"];
    case "Coffee":
      if (/nong|hot/.test(text)) {
        return ["less sweet", "stronger", "with condensed milk", "takeaway"];
      }
      return ["less sweet", "more ice", "no ice", "takeaway"];
    case "Tea":
      if (/nong|hot/.test(text)) {
        return ["less sweet", "honey", "hot", "takeaway"];
      }
      return ["less sweet", "more ice", "no ice", "takeaway"];
    case "Smoothies":
      return ["less sugar", "no condensed milk", "less ice", "takeaway"];
    case "Juices & fresh drinks":
      return ["less sugar", "no ice", "more ice", "takeaway"];
    case "Water, soda & other drinks":
      if (isBeer(item)) {
        return item.itemID === "drink-bia-hoi" ? ["by the glass", "cold", "with snacks", "share pitcher"] : ["cold", "can or bottle", "with ice", "share bucket"];
      }
      if (isWineOrLiquor(item)) {
        return ["small glass", "bottle", "share size", "with ice"];
      }
      if (/soda|nuoc-ngot|nước ngọt/.test(text)) {
        return ["cold", "with ice", "no ice", "can or bottle"];
      }
      return ["cold", "large bottle", "no ice", "with ice"];
    default:
      return item.commonOptions;
  }
}

function tipFor(item) {
  const tips = categoryTips[item.category];
  if (!tips) {
    return item.goodToKnow;
  }

  return tips[stableIndex(item.itemID, tips.length)];
}

function dryNoodleAtAGlanceFor(item) {
  const text = searchableText(item);
  if (/soup|bún măng vịt|bun-mang-vit/.test(text)) {
    return `${item.vietnameseItem} is a vermicelli soup with ${dryNoodleMainFor(item)}, broth, herbs, and a bright dipping or seasoning sauce. It eats like a full noodle soup, not a dry salad bowl.`;
  }
  return `${item.vietnameseItem} pairs ${noodleType(item)} with ${dryNoodleMainFor(item)}, fresh herbs, ${dryNoodleCrunchFor(item)}, and ${sauceNameFor(item)}. The appeal is contrast: savory topping, cool herbs, soft noodles, and a bright finish.`;
}

function dryNoodleWhatItIsFor(item) {
  const text = searchableText(item);
  if (/soup|bún măng vịt|bun-mang-vit/.test(text)) {
    return `${item.vietnameseItem} is a vermicelli soup with ${dryNoodleMainFor(item)}, broth, herbs, and a dipping or seasoning sauce on the side. The bowl is warming but still lifted by herbs.`;
  }
  return `${item.vietnameseItem} is a dry-style noodle bowl with ${noodleType(item)}, ${dryNoodleMainFor(item)}, herbs, ${dryNoodleCrunchFor(item)}, and ${sauceNameFor(item)} mixed through. It should taste fresh, savory, and layered.`;
}

function dryNoodleMainFor(item) {
  const text = searchableText(item);
  if (/bun-dau-mam-tom|bún đậu mắm tôm/.test(text)) return "fried tofu";
  if (/bun-cha-ca|bún chả cá/.test(text)) return "fish cakes";
  if (/mi-quang-tom-thit|mì quảng tôm thịt/.test(text)) return "shrimp and pork";
  if (/mi-quang-ga|mì quảng gà/.test(text)) return "chicken";
  if (/banh-hoi-heo-quay|bánh hỏi heo quay/.test(text)) return "roasted pork";
  if (/banh-hoi-thit-nuong|bánh hỏi thịt nướng/.test(text)) return "grilled pork";
  if (/bun-cha(?!-ca)|bún chả(?! cá)/.test(text)) return "grilled pork";
  if (/bun-nem-nuong|bún nem nướng/.test(text)) return "grilled pork sausage";
  if (/bun-bo-xao|bún bò xào/.test(text)) return "stir-fried beef";
  if (/bun-bo-nam-bo|bún bò nam bộ/.test(text)) return "seared beef";
  if (/hu-tieu-kho|hủ tiếu khô/.test(text)) return "savory toppings";
  if (/mi-kho|mì khô/.test(text)) return "savory toppings";
  return mainIngredient(item);
}

function dryNoodleCrunchFor(item) {
  const text = searchableText(item);
  if (/mi-quang|mì quảng/.test(text)) return "peanuts and rice cracker";
  if (/cao-lau|cao lầu/.test(text)) return "crispy rice crackers";
  if (/banh-hoi|bánh hỏi/.test(text)) return "scallion oil";
  if (/bun-dau-mam-tom|bún đậu mắm tôm/.test(text)) return "fried tofu edges";
  if (/mien-xao|miến xào/.test(text)) return "aromatics";
  if (/peanut|đậu phộng|bun-bo|bún bò|bun-thit|bún thịt/.test(text)) return "peanuts or fried shallots";
  return "fried shallots or crunchy topping";
}

function snackAtAGlanceFor(item) {
  const text = searchableText(item);
  const name = descriptiveName(item);
  if (/sup-cua|súp cua|crab soup/.test(text)) {
    return `${item.vietnameseItem} is a thick crab soup with egg ribbons, pepper, cilantro, and sometimes corn or asparagus. It is warm, silky, and snack-sized.`;
  }
  if (/goi-|gỏi|nom-|nộm|salad/.test(text)) {
    return `${item.vietnameseItem} is ${name} with crisp vegetables or fruit, herbs, peanuts, and ${sauceNameFor(item)}. It should taste bright, crunchy, sweet, sour, and savory.`;
  }
  if (/banh-trang-nuong|bánh tráng nướng/.test(text)) {
    return `${item.vietnameseItem} is grilled rice paper with savory toppings, scallions, egg or sauce depending on the stall. It is crisp, smoky, and eaten hot.`;
  }
  if (/banh-trang-tron|bánh tráng trộn/.test(text)) {
    return `${item.vietnameseItem} is mixed rice-paper salad with chewy strips, herbs, chili, tangy dressing, and snack toppings. It is messy in the best way.`;
  }
  if (/khoai-lang-chien|khoai tây chiên|khoai-tay-chien|fried sweet potato|french fries/.test(text)) {
    return `${item.vietnameseItem} is ${name}, served hot for crunch and salt. Sauce is optional; the texture is the point.`;
  }
  if (/ca-vien-chien|cá viên chiên|fish balls/.test(text)) {
    return `${item.vietnameseItem} is fried fish balls, usually skewered or plated with chili sauce. It is a casual snack of bounce, crisp edges, and sauce.`;
  }
  if (/goi-cuon|gỏi cuốn|nem-cuon|nem cuốn|fresh rolls/.test(text)) {
    return `${item.vietnameseItem} is a fresh rice-paper roll with herbs, rice vermicelli, ${mainIngredient(item)}, and ${sauceNameFor(item)}. It is cool, clean, and dip-driven.`;
  }
  if (/cha-gio|chả giò|nem-ran|nem rán|fried spring rolls/.test(text)) {
    return `${item.vietnameseItem} is a fried spring roll with crisp wrapper, savory filling, herbs, and ${sauceNameFor(item)}. The contrast is crunch, herbs, and bright dip.`;
  }
  if (/banh-xeo|bánh xèo|banh-khot|bánh khọt|banh-can|bánh căn/.test(text)) {
    return `${item.vietnameseItem} is ${name}, usually eaten with herbs and ${sauceNameFor(item)}. Crisp edges, fresh greens, and the dip make the dish.`;
  }
  return `${item.vietnameseItem} is ${name}, usually served as a snack, starter, or shared plate with herbs, texture, and ${sauceNameFor(item)}.`;
}

function snackIncludesFor(item) {
  const text = searchableText(item);
  if (/sup-cua|súp cua|crab soup/.test(text)) {
    return ["crab soup", "egg ribbons", "corn or asparagus", "cilantro", "pepper"];
  }
  if (/goi-xoai|gỏi xoài/.test(text)) return ["green mango", "fresh herbs", "peanuts", "dried shrimp optional", sauceNameFor(item)];
  if (/goi-du-du|gỏi đu đủ|nom-bo-kho|nộm bò khô/.test(text)) return ["green papaya", mainIngredient(item), "fresh herbs", "peanuts", sauceNameFor(item)];
  if (/goi-ngo-sen|gỏi ngó sen/.test(text)) return ["lotus stem", "shrimp and pork", "fresh herbs", "peanuts", sauceNameFor(item)];
  if (/goi-ga|gỏi gà/.test(text)) return ["shredded chicken", "cabbage or herbs", "onion", "peanuts", sauceNameFor(item)];
  if (/banh-trang-nuong|bánh tráng nướng/.test(text)) return ["grilled rice paper", "egg or toppings", "scallions", "chili sauce"];
  if (/banh-trang-tron|bánh tráng trộn/.test(text)) return ["rice paper strips", "green mango", "herbs", "chili dressing", "snack toppings"];
  if (/khoai-lang-chien|fried sweet potato/.test(text)) return ["sweet potato", "crispy coating", "salt", "chili sauce optional"];
  if (/khoai-tay-chien|french fries/.test(text)) return ["potatoes", "crispy edges", "salt", "chili sauce optional"];
  if (/ca-vien-chien|cá viên chiên|fish balls/.test(text)) return ["fish balls", "fried edges", "chili sauce", "skewers optional"];
  if (/banh-cuon|bánh cuốn/.test(text)) return ["steamed rice rolls", "pork and mushroom filling", "fried shallots", "herbs", sauceNameFor(item)];
  if (/banh-beo|bánh bèo/.test(text)) return ["steamed rice cakes", "shrimp topping", "scallion oil", "fried shallots", sauceNameFor(item)];
  if (/banh-bot-loc|bánh bột lọc/.test(text)) return ["tapioca dumplings", "shrimp and pork", "scallion oil", sauceNameFor(item)];
  if (/banh-nam|bánh nậm/.test(text)) return ["steamed rice dumplings", "shrimp or pork topping", "banana leaf aroma", sauceNameFor(item)];
  if (/bo-bia|bò bía/.test(text)) return ["rice paper", "jicama", "sausage or egg", "herbs", sauceNameFor(item)];
  if (/chao-tom|chạo tôm/.test(text)) return ["shrimp paste", "sugarcane", "herbs", sauceNameFor(item)];
  if (/bo-la-lot|bò lá lốt/.test(text)) return ["beef in betel leaves", "herbs", "rice paper optional", sauceNameFor(item)];
  if (/fried|chien|chiên|ran|rán|cha-gio|chả giò|nem-ran|nem rán/.test(text)) {
    return ["fried wrapper", mainIngredient(item), "vegetables", "herbs", sauceNameFor(item)];
  }
  if (/banh|bánh|pancake|cake/.test(text)) {
    return ["rice flour batter", mainIngredient(item), "herbs", sauceNameFor(item)];
  }
  if (/roll|cuon|cuốn/.test(text)) {
    return ["rice paper", mainIngredient(item), "rice vermicelli", "herbs", sauceNameFor(item)];
  }
  return [descriptiveName(item), "fresh herbs", "crunch", sauceNameFor(item)];
}

function snackWhatItIsFor(item) {
  const text = searchableText(item);
  if (/sup-cua|súp cua|crab soup/.test(text)) {
    return `${item.vietnameseItem} is a thick crab soup, often with egg ribbons, pepper, cilantro, and corn or asparagus. It is a warm street snack, not a roll or salad.`;
  }
  if (/goi-|gỏi|nom-|nộm|salad/.test(text)) {
    return `${item.vietnameseItem} is ${descriptiveName(item)} with crisp vegetables or fruit, herbs, peanuts, and ${sauceNameFor(item)}. The flavor should be bright, tangy, crunchy, and savory.`;
  }
  if (/banh-trang-nuong|bánh tráng nướng/.test(text)) {
    return `${item.vietnameseItem} is grilled rice paper cooked crisp with savory toppings. It is often nicknamed Vietnamese pizza, but the appeal is the smoky crunch.`;
  }
  if (/banh-trang-tron|bánh tráng trộn/.test(text)) {
    return `${item.vietnameseItem} is mixed rice-paper salad with chewy strips, herbs, chili, tangy dressing, and snack toppings. It is a street-snack texture bomb.`;
  }
  if (/khoai-lang-chien|khoai-tay-chien|fried sweet potato|french fries/.test(text)) {
    return `${item.vietnameseItem} is ${descriptiveName(item)}, served hot and crisp. Sauce is optional; freshness and crunch matter most.`;
  }
  return `${item.vietnameseItem} is ${descriptiveName(item)}, usually served with herbs, texture, and ${sauceNameFor(item)}. The sauce and fresh sides complete the bite.`;
}

function snackHowToEnjoyFor(item) {
  const text = searchableText(item);
  if (/sup-cua|súp cua|crab soup/.test(text)) {
    return "Eat it hot with pepper and herbs on top. If it is thick, stir once so the crab, egg, and broth stay balanced.";
  }
  if (/goi-|gỏi|nom-|nộm|salad|banh-trang-tron|bánh tráng trộn/.test(text)) {
    return `Toss before eating so ${sauceNameFor(item)} coats the crisp ingredients. Add chili slowly; these salads can jump from bright to hot fast.`;
  }
  if (/banh-xeo|bánh xèo/.test(text)) {
    return guideExactCopy["food-banh-xeo"].howToEnjoy;
  }
  if (/khoai-lang-chien|khoai-tay-chien|ca-vien-chien|fried sweet potato|french fries|fish balls/.test(text)) {
    return "Eat while hot so the edges stay crisp. Use chili sauce lightly first if sweetness or heat matters.";
  }
  return `Use ${sauceNameFor(item)} lightly at first. If herbs, lettuce, or rice paper come with it, they are part of the bite.`;
}

function guideCopyFor(item) {
  return {
    whatItIs: whatItIsFor(item),
    howToEnjoy: howToEnjoyFor(item),
    worthKnowing: worthKnowingFor(item),
    regionalAssociation: regionalAssociationFor(item),
    originPosture: originPostureFor(item),
    travelerCaution: travelerCautionFor(item),
    ...(guideExactCopy[item.itemID] ?? {}),
  };
}

function noodleSoupAtAGlanceFor(item) {
  const text = searchableText(item);
  const name = descriptiveName(item);

  if (/pho|phở/.test(text)) {
    return `${item.vietnameseItem} is phở with ${phoToppingFor(item)}, flat rice noodles, herbs, and fragrant broth. It should feel clean, aromatic, and comforting.`;
  }
  if (/bun-rieu|bún riêu/.test(text)) {
    return `${item.vietnameseItem} is a tomato-bright rice vermicelli soup with crab flavor, herbs, and a lightly tangy broth. It is savory, fresh, and a little rustic.`;
  }
  if (/bun-mam|bún mắm/.test(text)) {
    return `${item.vietnameseItem} is a fermented-fish noodle soup with rice vermicelli, herbs, and a deep savory broth. It is bold, aromatic, and not shy.`;
  }
  if (/bun-thang|bún thang/.test(text)) {
    return `${item.vietnameseItem} is a delicate Hanoi noodle soup with chicken, egg, pork, herbs, and fine rice vermicelli. It is layered but restrained.`;
  }
  if (/bun-moc|bún mọc/.test(text)) {
    return `${item.vietnameseItem} is pork meatball noodle soup with rice vermicelli, herbs, and a clear savory broth. It is gentle, springy, and satisfying.`;
  }
  if (/bun-ca|bún cá/.test(text)) {
    return `${item.vietnameseItem} is fish noodle soup with rice vermicelli, herbs, and a light savory broth. The fish gives the bowl its clean seafood flavor.`;
  }
  if (/bun-oc|bún ốc/.test(text)) {
    return `${item.vietnameseItem} is snail noodle soup with rice vermicelli, herbs, and a tangy savory broth. It is chewy, bright, and distinctive.`;
  }
  if (/bun-sua|bún sứa/.test(text)) {
    return `${item.vietnameseItem} is jellyfish noodle soup with rice vermicelli, herbs, and a light coastal broth. The jellyfish adds a crisp, springy bite.`;
  }
  if (/hu-tieu|hủ tiếu/.test(text)) {
    return `${item.vietnameseItem} is a rice-noodle soup with clear savory broth, herbs, and ${mainIngredient(item)}. It usually feels lighter and more flexible than richer beef soups.`;
  }
  if (/mi-hoanh-thanh|mì hoành thánh/.test(text)) {
    return `${item.vietnameseItem} is wonton egg noodle soup with broth, egg noodles, wontons, herbs, and a bright finish from lime or chili.`;
  }
  if (/mien-ga|miến gà/.test(text)) {
    return `${item.vietnameseItem} is chicken glass noodle soup with clear broth, slippery glass noodles, herbs, and tender chicken. It is light but still warming.`;
  }
  if (/banh-canh|bánh canh/.test(text)) {
    return `${item.vietnameseItem} is a thick-noodle soup with ${mainIngredient(item)}, herbs, and a round savory broth. The chewy noodles are part of the pleasure.`;
  }

  return `${item.vietnameseItem} is ${name} with ${noodleType(item)}, ${mainIngredient(item)}, herbs, and broth. Lime, chili, or fresh herbs can brighten the bowl.`;
}

function noodleSoupWhatItIsFor(item) {
  const text = searchableText(item);
  const name = descriptiveName(item);

  if (/pho|phở/.test(text)) {
    return `${item.vietnameseItem} is phở with ${phoToppingFor(item)}, fragrant broth, flat rice noodles, onion, herbs, and lime. The bowl should taste clean first, then deepen with broth and spice.`;
  }
  if (/bun-rieu|bún riêu/.test(text)) {
    return `${item.vietnameseItem} is rice vermicelli in a crab-and-tomato broth with herbs and a tangy finish. The best bowls balance crab savoriness with tomato brightness.`;
  }
  if (/bun-mam|bún mắm/.test(text)) {
    return `${item.vietnameseItem} is rice vermicelli in a fermented-fish broth, usually with herbs and strong savory depth. It is one of the bolder noodle soups on the menu.`;
  }
  if (/bun-thang|bún thang/.test(text)) {
    return `${item.vietnameseItem} is a Hanoi noodle soup with fine rice vermicelli, chicken, egg, pork, herbs, and clear broth. It is known for many small toppings in a balanced bowl.`;
  }
  if (/bun-moc|bún mọc/.test(text)) {
    return `${item.vietnameseItem} is rice vermicelli soup with pork meatballs, herbs, and a clear savory broth. The meatballs give the bowl its soft, springy bite.`;
  }
  if (/bun-ca|bún cá/.test(text)) {
    return `${item.vietnameseItem} is fish noodle soup with rice vermicelli, herbs, and light broth. The fish can be fried, steamed, or fish-cake style depending on the shop.`;
  }
  if (/bun-oc|bún ốc/.test(text)) {
    return `${item.vietnameseItem} is snail noodle soup with rice vermicelli, herbs, and a tangy savory broth. Expect chew from the snails and brightness from the broth.`;
  }
  if (/bun-sua|bún sứa/.test(text)) {
    return `${item.vietnameseItem} is jellyfish noodle soup with rice vermicelli, herbs, and a light coastal broth. The jellyfish adds a crisp, springy texture.`;
  }
  if (/hu-tieu|hủ tiếu/.test(text)) {
    return `${item.vietnameseItem} is rice-noodle soup with clear savory broth, herbs, and ${mainIngredient(item)}. It is often lighter and more southern-feeling than phở.`;
  }
  if (/mi-hoanh-thanh|mì hoành thánh/.test(text)) {
    return `${item.vietnameseItem} is wonton egg noodle soup with broth, egg noodles, wontons, herbs, and a bright finish from lime or chili. The wontons are the defining bite.`;
  }
  if (/mi-ga|mì gà/.test(text)) {
    return `${item.vietnameseItem} is chicken egg noodle soup with broth, egg noodles, herbs, and tender chicken. It is a warmer, wheatier alternative to rice-noodle soups.`;
  }
  if (/mien-ga|miến gà/.test(text)) {
    return `${item.vietnameseItem} is chicken glass noodle soup with clear broth, slippery glass noodles, herbs, and tender chicken. The noodles feel lighter than egg noodles.`;
  }
  if (/banh-canh|bánh canh/.test(text)) {
    return `${item.vietnameseItem} is a thick-noodle soup with ${mainIngredient(item)}, herbs, and rounded savory broth. The chewy bánh canh noodles make it feel heartier.`;
  }

  return `${item.vietnameseItem} is ${name} with ${noodleType(item)}, ${mainIngredient(item)}, herbs, and broth. The topping should shape the broth’s flavor, not disappear into it.`;
}

function phoToppingFor(item) {
  const text = searchableText(item);
  if (/tai-nam|tái nạm/.test(text)) return "rare beef and brisket";
  if (/tai|tái/.test(text)) return "rare beef";
  if (/chin|chín/.test(text)) return "well-done beef";
  if (/bo-vien|bò viên/.test(text)) return "beef meatballs";
  if (/dac-biet|đặc biệt|special/.test(text)) return "a combination of beef toppings";
  if (/ga|gà/.test(text)) return "chicken";
  return "thin sliced beef";
}

function whatItIsFor(item) {
  const name = descriptiveName(item);
  const main = mainIngredient(item);
  const text = searchableText(item);

  switch (item.category) {
    case "Noodle soups":
      if (/porridge|chao|cháo/.test(text)) {
        const topping = main === "the main topping" ? "rice, scallions, and gentle savory flavor" : `${main}, scallions, and gentle savory flavor`;
        return `${item.vietnameseItem} is a soft rice porridge with ${topping}. It is a calming bowl when you want something warm and simple.`;
      }
      return noodleSoupWhatItIsFor(item);
    case "Dry noodles & vermicelli":
      return dryNoodleWhatItIsFor(item);
    case "Rice & sticky rice":
      if (/xoi|sticky rice|xôi/.test(text)) {
        const topping = main === "the main topping" ? name : main;
        return `${item.vietnameseItem} is a sticky-rice order with ${topping} and savory toppings. It is compact, filling, and common for breakfast or a quick meal.`;
      }
      return `${item.vietnameseItem} is a rice plate with ${name}, vegetables or pickles, and a small seasoning sauce on the side. It is a complete plate where the rice carries the main flavor.`;
    case "Rolls, appetizers & street snacks":
      if (item.itemID === "food-banh-xeo") {
        return guideExactCopy["food-banh-xeo"].whatItIs;
      }
      return snackWhatItIsFor(item);
    case "Bánh mì, bread & buns":
      if (item.itemID === "food-banh-mi-thit") {
        return guideExactCopy["food-banh-mi-thit"].whatItIs;
      }
      if (/stew|bò kho|bo-kho/.test(text)) {
        return `${item.vietnameseItem} pairs bread with ${name}, so the bread can scoop or dip into the spiced beef broth. It eats more like a hearty stew meal than a sandwich.`;
      }
      if (/banh-mi|bánh mì/.test(text)) {
        return `${item.vietnameseItem} is a bánh mì sandwich with ${banhMiFillingName(item)}, pickled vegetables, herbs, and usually sauce or pâté depending on the shop. The crisp bread and sharp pickles keep the filling lively.`;
      }
      if (/banh-bao|bánh bao|steamed bun/.test(text)) {
        return `${item.vietnameseItem} is a steamed bun with ${bunFillingName(item)} tucked inside a soft, slightly sweet dough. It works as a light meal or a filling snack.`;
      }
      if (/banh-tieu|bánh tiêu|sesame donut/.test(text)) {
        return `${item.vietnameseItem} is a hollow sesame donut with a crisp outside and airy middle. It is more of a street snack or sweet bite than a sandwich.`;
      }
      if (/pate-so|patê sô|pâté sô|puff pastry/.test(text)) {
        return `${item.vietnameseItem} is a savory puff pastry, often filled with seasoned meat or pâté-style filling. It is familiar in shape but Vietnamese in bakery-counter rhythm.`;
      }
      return `${item.vietnameseItem} is a bread or bun order with ${name}, often plus herbs, pickles, or a savory filling. Texture matters as much as the filling.`;
    case "Seafood":
      return `${item.vietnameseItem} is a seafood dish featuring ${name}, often supported by garlic, lemongrass, herbs, chili, or ${sauceNameFor(item)}. It is usually best shared.`;
    case "Pork":
      return `${item.vietnameseItem} is a pork dish featuring ${name}, usually balanced by rice, pickles, herbs, or ${sauceNameFor(item)}. Expect savory richness rather than a light snack.`;
    case "Chicken & duck":
      return `${item.vietnameseItem} is a poultry dish featuring ${name}, usually served with herbs, rice, or ${sauceNameFor(item)}. The seasoning can be gentle, grilled, fried, herbal, or deeply savory.`;
    case "Beef & goat":
      return `${item.vietnameseItem} is a beef or goat dish featuring ${name}, often richer or more aromatic than chicken dishes. Rice, noodles, bread, or herbs help balance it.`;
    case "Vegetarian":
      return vegetarianWhatItIsFor(item);
    case "Soups, hot pots & family-style":
      return `${item.vietnameseItem} is a shared-style dish featuring ${name}, broth, sauce, vegetables, rice, or noodles. It is better for a sit-down meal than a quick stop.`;
    case "Desserts & sweets":
      return `${item.vietnameseItem} is a Vietnamese sweet: ${name}. Expect a small finish that may be creamy, icy, chewy, fruity, or coconut-rich.`;
    case "Coffee":
      return `${item.vietnameseItem} is ${withArticle(name)} in Vietnam’s coffee lane, usually shaped by a strong coffee base and a clear choice about milk, sugar, ice, or café style.`;
    case "Tea":
      return `${item.vietnameseItem} is ${withArticle(name)}. Depending on the style, it can be plain and light or sweet enough to feel like a dessert drink.`;
    case "Smoothies":
      return `${item.vietnameseItem} is a smoothie with ${main}, ice, and often milk or condensed milk. It is cool, creamy, and closer to dessert than plain juice.`;
    case "Juices & fresh drinks":
      return `${item.vietnameseItem} is a fresh drink with ${freshDrinkBase(item)}, usually served cold over ice. It is a refreshing break from salty, grilled, or spicy food.`;
    case "Water, soda & other drinks":
      if (isBeer(item)) {
        return `${item.vietnameseItem} is ${withArticle(name)}, usually served cold and paired with snacks or a shared table meal.`;
      }
      if (isWineOrLiquor(item)) {
        return `${item.vietnameseItem} is an alcoholic drink: ${name}. Order it deliberately and ask about glass, bottle, or pour size if the menu is unclear.`;
      }
      return `${item.vietnameseItem} means ${name}. Check whether it comes cold, bottled, canned, or with a separate glass of ice.`;
    default:
      return `${item.vietnameseItem} is a Vietnamese menu name for ${name}. The Vietnamese wording is the most reliable anchor when the English translation changes by shop.`;
  }
}

function howToEnjoyFor(item) {
  const text = searchableText(item);

  switch (item.category) {
    case "Noodle soups":
      return "Taste the broth before adding lime, chili, or herbs. If the bowl looks spicy, ask for less chili before it is made.";
    case "Dry noodles & vermicelli":
      return `Add ${sauceNameFor(item)} gradually and mix well so the noodles, herbs, and toppings share the flavor. Hold back chili if you want a gentler bowl.`;
    case "Rice & sticky rice":
      return /xoi|sticky rice|xôi/.test(text)
        ? "Eat it while warm if possible. Sticky rice is filling, so a small portion can still be a real meal."
        : "Add sauce slowly and taste as you go. A fried egg, extra rice, or pickles can make the plate easier to share or finish.";
    case "Rolls, appetizers & street snacks":
      return snackHowToEnjoyFor(item);
    case "Bánh mì, bread & buns":
      if (/banh-mi-bo-kho|bánh mì bò kho|stew/.test(text)) {
        return "Tear the bread and dip it into the stew while the broth is hot. Add herbs or chili gradually so the warm spice stays balanced.";
      }
      if (/banh-tieu|bánh tiêu|sesame donut/.test(text)) {
        return "Eat it fresh if you can, while the outside is crisp and the middle is airy. It is more snack than dessert plate.";
      }
      if (/pate-so|patê sô|pâté sô|puff pastry/.test(text)) {
        return "Eat it warm for the best flaky texture. It works as a quick bakery snack rather than a full sandwich.";
      }
      return "Ask for no chili if you are heat-sensitive. Bread orders are best soon after they are made, while the texture is still fresh.";
    case "Seafood":
      return "Ask about portion size or price by weight before ordering at seafood spots. Salt-pepper-lime dip is bright, so start with a little.";
    case "Pork":
      return "Pair it with rice, pickles, or greens to balance the richness. Ask for extra sauce only if you plan to eat it with rice.";
    case "Chicken & duck":
      return "Use herbs, sauce, or rice to balance the seasoning. Fried and grilled versions are richer; steamed versions usually feel lighter.";
    case "Beef & goat":
      return "Ask whether it comes with bread, noodles, or rice. Stews feel like a meal; grilled plates are easier to share.";
    case "Vegetarian":
      return "If you avoid fish sauce, ask for chay and say no fish sauce too. Vegetarian styles can still vary by restaurant.";
    case "Soups, hot pots & family-style":
      return "Order this when you have time and table space. Ask for rice, noodles, or vegetables if they are not already included.";
    case "Desserts & sweets":
      return "Ask for less sweet, less ice, or no coconut if that matters. Texture is part of the fun, so expect beans, jellies, fruit, or sticky rice in some bowls.";
    case "Coffee":
      return "Use the coffee helper phrases if you want less sugar, less ice, no ice, or a black version. Small changes can make the cup feel completely different.";
    case "Tea":
      return "Ask for less sweet before it is mixed. Plain tea is light with meals; milk tea and fruit tea can be dessert-like.";
    case "Smoothies":
      return "Ask for less sugar or no condensed milk if you want more fruit flavor. Many smoothies are thick enough to feel like dessert.";
    case "Juices & fresh drinks":
      return "Ask for less sugar or no ice before the drink is mixed. Fresh juices are best when pressed or blended to order.";
    case "Water, soda & other drinks":
      if (isBeer(item)) {
        return "Ask whether it comes by glass, can, bottle, or draft. Many casual places serve beer with ice.";
      }
      if (isWineOrLiquor(item)) {
        return "Ask about glass, bottle, or shared size before ordering. Sip slowly if you are unsure how strong it is.";
      }
      return "Ask for cold, no ice, or a bottle if you want control. Packaged drinks can arrive with a separate glass of ice.";
    default:
      return "Point to the name or photo if pronunciation feels hard. The Vietnamese name is still useful because it anchors the order.";
  }
}

function worthKnowingFor(item) {
  const region = regionalAssociationFor(item);
  const text = searchableText(item);

  if (region) {
    const itemKind = item.menuType === "Drink" ? "drink" : "dish";
    const variationNoun = item.menuType === "Drink" ? "serving habits" : "recipes";
    return `${item.vietnameseItem} is associated with ${region}. That link tells you where the ${itemKind}’s local identity is strongest, even though ${variationNoun} still shift by city, shop, and family style.`;
  }

  switch (item.category) {
    case "Noodle soups":
      if (/porridge|chao|cháo/.test(text)) {
        return "In Vietnam, cháo is a rice-porridge comfort-food lane. The topping tells you whether the bowl stays gentle or turns more adventurous.";
      }
      return "Noodle soups are often breakfast or lunch food in Vietnam, but busy shops may serve them all day. The broth style can tell you as much as the toppings.";
    case "Dry noodles & vermicelli":
      return "In Vietnamese dry noodle and vermicelli bowls, cool herbs, warm toppings, bright sauce, crunch, and soft noodles all matter. Mixing is part of the dish.";
    case "Rice & sticky rice":
      return /xoi|sticky rice|xôi/.test(text)
        ? "In Vietnam, sticky rice is common as a portable breakfast or snack. It can be savory, sweet, or both depending on the topping."
        : "In Vietnam, rice plates are everyday food, not just restaurant food. They are good when you want something complete and easy to understand.";
    case "Rolls, appetizers & street snacks":
      return "In Vietnam, street snacks vary by region and stall, so the same name may look a little different from place to place. The sauce and texture are often the best clues.";
    case "Bánh mì, bread & buns":
      if (/banh-mi-chay|bánh mì chay/.test(text)) {
        return "In Vietnam, chay marks the vegetarian lane. For bánh mì, that usually means the local bread-and-pickle format stays, while the filling shifts to tofu, mushrooms, vegetables, or a meat-free spread.";
      }
      if (/banh-bao|bánh bao|steamed bun/.test(text)) {
        return "In Vietnam, bánh bao belongs to the snack-counter world: soft steamed dough, hidden filling, and quick takeaway warmth rather than crisp baguette texture.";
      }
      if (/banh-mi-bo-kho|bánh mì bò kho|stew/.test(text)) {
        return "Bánh mì bò kho shows how Vietnamese bread can be used for dipping, not only sandwiches. The broth, carrots, herbs, and bread make one meal.";
      }
      if (/banh-tieu|bánh tiêu|sesame donut/.test(text)) {
        return "In Vietnam, bánh tiêu sits in the street-snack and bakery world: sesame aroma, hollow crunch, and a light sweetness rather than a heavy filling.";
      }
      if (/pate-so|patê sô|pâté sô|puff pastry/.test(text)) {
        return "Patê sô reflects Vietnam’s bakery culture, where flaky pastry and savory fillings sit beside bánh mì and sweet snacks.";
      }
      return "Vietnamese bread orders are shaped by local fillings, herbs, pickles, sauces, and quick street-service habits, not just the bread itself.";
    case "Seafood":
      return "In Vietnam, seafood is often ordered for sharing, especially near the coast. Garlic, lemongrass, chili, fish sauce, and salt-pepper-lime dip often carry the local flavor.";
    case "Pork":
      return "In Vietnam, pork is common in everyday meals, from grilled rice plates to braised family dishes. Sauces often carry sweet-salty balance.";
    case "Chicken & duck":
      return "In Vietnam, chicken and duck dishes often rely on herbs, dipping sauce, or rice to complete the bite. The side sauce can be as important as the meat.";
    case "Beef & goat":
      return "In Vietnam, beef and goat dishes can lean aromatic, grilled, curry-spiced, or stew-like. If goat is unfamiliar, expect stronger seasoning than a simple chicken dish.";
    case "Vegetarian":
      return "In Vietnam, chay signals vegetarian food, but strict vegetarians should still ask about sauce, egg, or dairy because house practices differ.";
    case "Soups, hot pots & family-style":
      return "In Vietnamese family meals, soups, hot pots, and shared plates are about pacing the table with rice, vegetables, herbs, and broth.";
    case "Desserts & sweets":
      return "In Vietnam, sweets often care as much about texture as sweetness: beans, jellies, coconut milk, ice, sticky rice, and fruit can share one cup.";
    case "Coffee":
      return "Vietnamese coffee culture ranges from sidewalk phin cups to inventive café drinks. The best order depends on whether you want strong, creamy, icy, or dessert-like.";
    case "Tea":
      return "In Vietnam, tea ranges from plain meal tea to sweet fruit or milk tea. The same English word can cover very different drinks.";
    case "Smoothies":
      return "In Vietnamese cafés and street stalls, smoothies are warm-weather comfort. Condensed milk can make them richer and sweeter than a typical US smoothie.";
    case "Juices & fresh drinks":
      return "In Vietnam, fresh drinks are part refreshment, part street-side pause. Sugar and ice levels are flexible if you ask before mixing.";
    case "Water, soda & other drinks":
      if (isBeer(item)) {
        return "In Vietnam, beer is often a cold shared-table drink, sometimes poured over ice and paired with snacks.";
      }
      if (isWineOrLiquor(item)) {
        return "In Vietnam, rice liquor and local spirits usually belong to shared-table drinking, so pour size and setting matter.";
      }
      return "In Vietnam, simple drink orders still have local habits: bottled water may not be chilled, and canned drinks may arrive with a separate glass of ice.";
    default:
      return "Menu names are useful cultural clues. Learning the Vietnamese name helps you recognize the dish even when the English translation changes.";
  }
}

function vietnamConnectionCopyFor(item, current) {
  const value = String(current ?? "").trim();
  const context = vietnamConnectionSentenceFor(item);

  if (!value) {
    return context;
  }

  if (hasVietnamContext(value)) {
    return value;
  }

  return `${value} ${context}`;
}

function hasVietnamContext(value) {
  return /(vietnam|việt nam|vietnamese|hanoi|hà nội|huế|hội an|saigon|sài gòn|chợ lớn|mekong|mỹ tho|đà lạt|nha trang|phú yên|quảng nam|cầu mống|sóc trăng)/iu.test(value);
}

function vietnamConnectionSentenceFor(item) {
  const region = regionalAssociationFor(item);
  const text = searchableText(item);

  if (/bun-dau-mam-tom|bún đậu mắm tôm/.test(text)) {
    return "In northern Vietnamese snacking, the mắm tôm is the defining choice: pungent shrimp paste, tofu, herbs, and shared bites.";
  }
  if (/bun-mang-vit|bún măng vịt/.test(text)) {
    return "In Vietnam, bún măng vịt sits closer to a soup meal than a dry noodle bowl; the duck, bamboo-shoot broth, herbs, and ginger dip make it read local.";
  }
  if (/porridge|chao|cháo/.test(text)) {
    return "In Vietnam, cháo is a rice-porridge comfort-food lane. The topping tells you whether the bowl stays gentle or turns more adventurous.";
  }
  if (/banh-mi-chay|bánh mì chay/.test(text)) {
    return "In Vietnam, chay marks the vegetarian lane. For bánh mì, the bread-and-pickle format stays, while the filling shifts to tofu, mushrooms, vegetables, or a meat-free spread.";
  }
  if (/banh-bao|bánh bao|steamed bun/.test(text)) {
    return "In Vietnam, bánh bao belongs to the snack-counter world: soft steamed dough, hidden filling, and quick takeaway warmth rather than crisp baguette texture.";
  }
  if (/ruou-nep|rượu nếp/.test(text)) {
    return "Rượu nếp belongs to Vietnam’s rice-alcohol lane, so ask about pour size and setting before ordering; it is usually a deliberate shared-table drink, not a casual soft drink.";
  }

  if (region) {
    return `${item.vietnameseItem} is tied to ${region}; that link is part of its Vietnamese identity, even though shop versions still vary.`;
  }

  switch (item.category) {
    case "Noodle soups":
      return "In Vietnam, noodle soups get their identity from broth style, local herbs, and shop routine, not just the topping name.";
    case "Dry noodles & vermicelli":
      return "In Vietnamese dry noodle and vermicelli bowls, cool herbs, warm toppings, sauce, crunch, and soft noodles all matter.";
    case "Rice & sticky rice":
      return /xoi|sticky rice|xôi/.test(text)
        ? "In Vietnam, sticky rice can be a portable breakfast, snack, or small meal, with sweet or savory toppings changing the whole mood."
        : "In Vietnam, rice plates are everyday meals shaped by broken rice, scallion oil, pickles, fish-sauce caramel, and quick street-service habits.";
    case "Rolls, appetizers & street snacks":
      return "In Vietnam, snacks like this depend on rice paper, herbs, dipping sauce, and stall texture; the same name can shift by region.";
    case "Bánh mì, bread & buns":
      return "In Vietnam, bread orders come from local baguette culture: crisp bread, pickles, herbs, pâté or sauce, and fast street-service rhythm.";
    case "Seafood":
      return "In Vietnam, seafood dishes often reflect coastal eating and shared-table meals, with garlic, lemongrass, chili, salt-pepper-lime, or fish sauce doing the local work.";
    case "Pork":
      return "In Vietnamese home and street cooking, pork often gets its identity from caramelized fish sauce, grill smoke, pickles, herbs, or rice-plate sides.";
    case "Chicken & duck":
      return "In Vietnam, chicken and duck dishes often hinge on herbs and dipping sauce, so the side sauce can be as defining as the meat.";
    case "Beef & goat":
      return "In Vietnam, beef and goat dishes often lean on aromatics, herbs, curry spice, vinegar, or grill smoke rather than plain steak-style seasoning.";
    case "Vegetarian":
      return "In Vietnam, chay cooking adapts familiar noodle, soup, rice, and snack forms with tofu, mushrooms, vegetables, and soy-based sauces.";
    case "Soups, hot pots & family-style":
      return "In Vietnamese family meals, soups and hot pots are shared around rice, herbs, vegetables, and broth, so they carry table rhythm as much as flavor.";
    case "Desserts & sweets":
      return "In Vietnam, sweets often prize texture as much as sugar: beans, jellies, sticky rice, coconut milk, shaved ice, or fruit can share one bowl.";
    case "Coffee":
      return "In Vietnam’s café culture, coffee is often robusta-forward, phin-brewed, and shaped by condensed milk, ice, cream, coconut, egg, or salt.";
    case "Tea":
      return "In Vietnam, tea ranges from plain meal tea to sweet café drinks; ice, sugar, fruit, herbs, or milk can make the same word feel very different.";
    case "Smoothies":
      return "In Vietnamese cafés and street stalls, smoothies often use ripe fruit, ice, and condensed milk, so they sit closer to dessert than plain juice.";
    case "Juices & fresh drinks":
      return "In Vietnam, fresh drinks are part of street-side refreshment, with sugar, ice, kumquat, coconut water, pennywort, or sugarcane shaping the local style.";
    case "Water, soda & other drinks":
      if (isBeer(item)) {
        return "In Vietnam, beer is often treated as a cold shared-table drink, sometimes poured over ice and paired with snacks.";
      }
      if (isWineOrLiquor(item)) {
        return "In Vietnam, rice liquor and local spirits usually belong to shared-table drinking, so pour size and setting matter.";
      }
      return "In Vietnam, simple drink orders still carry local habits: bottled water may not be chilled, and canned drinks may arrive with a separate glass of ice.";
    default:
      return "In Vietnam, the Vietnamese menu name is the strongest clue when English translations change from shop to shop.";
  }
}

function regionalAssociationFor(item) {
  const text = searchableText(item);
  if (/hue|huế/.test(text)) return "Huế and central Vietnam";
  if (/hoi-an|hội an|hoi an|cao-lau|cao lầu/.test(text)) return "Hội An";
  if (/ha-noi|hà nội|hanoi|bun-cha(?!-ca)|bún chả(?! cá)|bun-thang|bún thang|cha-ca-la-vong|chả cá lã vọng/.test(text)) return "Hanoi";
  if (/sai-gon|sài gòn|saigon|com-tam|cơm tấm|bac-xiu|bạc xỉu/.test(text)) return "southern Vietnam";
  if (/da-lat|đà lạt|atiso/.test(text)) return "Đà Lạt";
  if (/my-tho|mỹ tho|hu-tieu-my-tho/.test(text)) return "Mỹ Tho and the Mekong Delta";
  if (/mien-tay|miền tây|mekong/.test(text)) return "the Mekong Delta";
  return "";
}

function originPostureFor(item) {
  if (regionalAssociationFor(item)) {
    return "regional-association";
  }
  if (/pho|phở|banh-mi|bánh mì|coffee|cà phê|ca-phe/.test(searchableText(item))) {
    return "cultural-context";
  }
  return "category-context";
}

function travelerCautionFor(item) {
  const text = searchableText(item);
  if (item.category === "Vegetarian" || /chay|vegetarian/.test(text)) {
    return "Ask whether the sauce is fully vegetarian if needed.";
  }
  if (/shrimp|tôm|crab|(^|[-\s])cua($|[-\s])|ghẹ|shellfish|seafood|mực|squid|(^|[-\s])ốc($|[-\s])|snail|nghêu|clam|(^|[-\s])sò($|[-\s])|sò huyết|cockle/.test(text)) {
    return "Contains or may contain seafood or shellfish.";
  }
  if (/pork|heo|thịt|sườn|pâté|pate|chả lụa|lạp xưởng|nem nướng/.test(text)) {
    return "May contain pork.";
  }
  if (/peanut|đậu phộng|dau-phong|mam-tom|mắm tôm|shrimp paste/.test(text)) {
    return "Ask about allergens or shrimp paste if needed.";
  }
  if (/spicy|chili|ớt|(^|[-\s])ot($|[-\s])|sa[-\s]?ot|sa tế|satay/.test(text)) {
    return "Ask for less spicy if heat is a concern.";
  }
  return "";
}

function quickSayEnglishFor(item) {
  const unit = servingUnit(item);
  const name = descriptiveName(item);
  return `I’d like one ${unit} of ${name}.`;
}

function servingUnit(item) {
  const text = searchableText(item);
  const quickSay = item.quickSayVietnamese.toLowerCase();

  if (/một chai/.test(quickSay)) return "bottle";
  if (/một ly/.test(quickSay)) return "glass";
  if (/một cốc|một tách/.test(quickSay)) return "cup";
  if (/một tô|một bát/.test(quickSay)) return "bowl";
  if (/một đĩa/.test(quickSay)) return "plate";
  if (/một ổ/.test(quickSay)) return "sandwich";
  if (/một phần/.test(quickSay)) return "order";

  if (item.menuType === "Drink") {
    if (/nong|hot|coffee|cà phê|tra |trà /.test(text) && !/da|đá|iced|soda|beer|bia/.test(text)) {
      return "cup";
    }
    if (isBeer(item) && item.itemID === "drink-bia-hoi") {
      return "glass";
    }
    if (isBeer(item) || /nước suối|nuoc-suoi|nuoc-loc|nuoc-khoang|\bwater\b|bottle/.test(text)) {
      return "bottle";
    }
    if (/wine|vang|ruou|rượu/.test(text)) {
      return "glass";
    }
    return "glass";
  }

  if (item.category === "Noodle soups" || /soup|porridge|phở|bún bò|bún riêu|bánh canh|cháo/.test(text)) {
    return "bowl";
  }
  if (/bánh mì|banh-mi|sandwich/.test(text)) {
    return "sandwich";
  }
  if (/rice plate|cơm|com-|xôi|xoi-/.test(text)) {
    return "plate";
  }
  if (/dessert|chè|che-|flan|kem|fruit plate/.test(text)) {
    return "serving";
  }
  return "order";
}

function descriptiveName(item) {
  const value = item.englishTranslation.trim();
  if (/^(Vietnamese|Hanoi|Hội An|Hoi An|Hue|Huế|Da Lat|Đà Lạt|Saigon|Thai|Phnom Penh|Hainanese)\b/.test(value)) {
    return value;
  }

  return value.charAt(0).toLowerCase() + value.slice(1);
}

function withArticle(value) {
  const trimmed = value.trim();
  if (!trimmed) {
    return "a menu item";
  }
  if (/^(a|an|the)\s/i.test(trimmed)) {
    return trimmed;
  }
  const article = /^[aeiou]/i.test(trimmed) ? "an" : "a";
  return `${article} ${trimmed}`;
}

function banhMiFillingName(item) {
  const text = searchableText(item);
  const name = descriptiveName(item)
    .replace(/^Vietnamese\s+/i, "")
    .replace(/\s*bánh mì$/i, "")
    .replace(/\s*sandwich$/i, "")
    .trim();

  if (/dac-biet|đặc biệt|special/.test(text)) return "assorted house fillings";
  if (/chay|vegetarian/.test(text)) return "vegetarian fillings";
  return name || "savory fillings";
}

function bunFillingName(item) {
  const text = searchableText(item);
  if (/chay|vegetarian/.test(text)) return "vegetarian fillings";
  if (/pork|thịt|thit|heo/.test(text)) return "pork filling";
  return descriptiveName(item).replace(/\s*steamed bun$/i, "").trim() || "savory filling";
}

function vegetarianWhatItIsFor(item) {
  const text = searchableText(item);
  const name = descriptiveName(item).replace(/^vegetarian\s+/i, "").trim();

  if (/pho|phở|bun-bo|bún bò|bun-rieu|bún riêu|hu-tieu|hủ tiếu/.test(text)) {
    return `${item.vietnameseItem} is a vegetarian noodle soup with broth, noodles, herbs, and meat-free toppings such as tofu, mushrooms, or vegetables. Ask about fish sauce if you are strict vegetarian.`;
  }

  if (/goi-cuon|gỏi cuốn|cha-gio|chả giò/.test(text)) {
    return `${item.vietnameseItem} is a vegetarian roll with herbs, vegetables, noodles, or tofu in the filling. The dipping sauce matters, so ask if you need it fully vegetarian.`;
  }

  if (/banh-xeo|bánh xèo/.test(text)) {
    return `${item.vietnameseItem} is a meat-free version of the sizzling rice pancake, usually folded around bean sprouts, mushrooms, tofu, or vegetables. Herbs and dipping sauce complete the bite.`;
  }

  if (/com|cơm|rice/.test(text)) {
    return `${item.vietnameseItem} is a vegetarian rice order with tofu, vegetables, mushrooms, or soy-based sides. It is a steady choice when you want one complete meat-free plate.`;
  }

  if (/mi-xao|mì xào|noodles/.test(text)) {
    return `${item.vietnameseItem} is a vegetarian noodle order with vegetables, tofu, mushrooms, or soy-based sauce. It is flexible, filling, and easy to ask for less oil or spice.`;
  }

  if (/lau|lẩu|hot pot/.test(text)) {
    return `${item.vietnameseItem} is a meat-free hot pot or shared dish with vegetables, mushrooms, tofu, broth, and noodles or rice. It is best when you have time to sit and share.`;
  }

  return `${item.vietnameseItem} is a meat-free version of ${name}, often using tofu, mushrooms, greens, noodles, rice, or soy-based sauce. It can be light, filling, or fried depending on the shop.`;
}

function vegetarianAnchorFor(item) {
  const text = searchableText(item);
  if (/eggplant|cà tím|ca-tim/.test(text)) return "eggplant";
  if (/tofu|đậu hũ|dau-hu/.test(text)) return "tofu";
  if (/mushroom|nấm|(^|[-\s])nam($|[-\s])/.test(text)) return "mushrooms";
  if (/noodle|phở|pho|bún|bun|hủ tiếu|hu-tieu|mì|mi-/.test(text)) return "noodles";
  if (/rice|cơm|com-/.test(text)) return "rice";
  if (/roll|gỏi cuốn|goi-cuon|chả giò|cha-gio/.test(text)) return "vegetable filling";
  if (/hot pot|lẩu|lau-/.test(text)) return "vegetables and tofu";
  return "vegetables and tofu";
}

function sauceNameFor(item) {
  const text = searchableText(item);

  if (item.category === "Vegetarian" || /chay|vegetarian/.test(text)) {
    if (/sot-ca-chua|sốt cà chua|tomato sauce/.test(text)) return "tomato sauce";
    if (/mo-hanh|mỡ hành|scallion oil/.test(text)) return "scallion oil";
    if (/canh-chua|canh chua|sour soup/.test(text)) return "sour broth";
    if (/kho|braised/.test(text)) return "soy-braised sauce";
    if (/goi-cuon|gỏi cuốn|cha-gio|chả giò|banh-xeo|bánh xèo|bun-dau|bún đậu/.test(text)) return "vegetarian nước chấm";
    return "vegetarian sauce";
  }

  if (/mam-tom|mắm tôm|shrimp paste/.test(text)) return "mắm tôm shrimp-paste sauce";
  if (/bun-cha-ca|bún chả cá/.test(text)) return "nước chấm or light broth";
  if (/bun-cha(?!-ca)|bún chả(?! cá)/.test(text)) return "nước chấm dipping broth";
  if (/bun-|bún|banh-hoi|bánh hỏi/.test(text)) return "nước chấm";
  if (/mi-quang|mì quảng/.test(text)) return "shallow turmeric broth";
  if (/cao-lau|cao lầu/.test(text)) return "savory pork sauce";
  if (/hu-tieu-kho|hủ tiếu khô|mi-kho|mì khô/.test(text)) return "savory house sauce";
  if (/goi-cuon|gỏi cuốn|nem-cuon|nem cuốn|fresh rolls/.test(text)) return "peanut sauce or nước chấm";
  if (/bo-bia|bò bía/.test(text)) return "hoisin-peanut sauce";
  if (/cha-gio|chả giò|nem-ran|nem rán|banh-xeo|bánh xèo|banh-khot|bánh khọt|banh-cuon|bánh cuốn|banh-beo|bánh bèo|banh-bot-loc|bánh bột lọc|banh-nam|bánh nậm/.test(text)) return "nước chấm";
  if (/goi-|gỏi|nom-|nộm|salad/.test(text)) return "fish-sauce lime dressing";
  if (/banh-trang-tron|bánh tráng trộn/.test(text)) return "tamarind-chili dressing";
  if (/banh-trang-nuong|bánh tráng nướng|ca-vien-chien|cá viên chiên|khoai.*chien|khoai.*chiên|fries|fish balls/.test(text)) return "chili sauce";

  if (/xi-dau|xì dầu|soy sauce/.test(text)) return "soy sauce";
  if (/rang-me|rang me|tamarind/.test(text)) return "tamarind sauce";
  if (/xao-dua|xào dừa|coconut sauce/.test(text)) return "coconut sauce";
  if (/bo-toi|bơ tỏi|garlic butter/.test(text)) return "garlic-butter sauce";
  if (/sa-te|sa tế|satay/.test(text)) return "satay chili sauce";
  if (/chua-ngot|chua ngọt|sweet-and-sour/.test(text)) return "sweet-and-sour sauce";
  if (/nuoc-mam|nước mắm|fish sauce fried|fish sauce/.test(text)) return "fish-sauce glaze";
  if (/muoi-ot|muối ớt|chili salt/.test(text)) return "chili-salt seasoning";
  if (/rang-muoi|rang muối|salt-roasted/.test(text)) return "salt-chili seasoning";
  if (/kho|rim|caramel/.test(text)) return "caramel fish-sauce glaze";
  if (/hap|hấp|steamed|nuoc-dua|nước dừa/.test(text)) return "salt-pepper-lime dip";

  if (/com-tam|cơm tấm|broken rice/.test(text)) return "nước mắm dressing";
  if (/com-ga-hoi-an|cơm gà hội an/.test(text)) return "chicken rice sauce";
  if (/com-ga-hai-nam|cơm gà hải nam|hainanese/.test(text)) return "ginger-scallion sauce";
  if (/bo-luc-lac|bò lúc lắc|shaking beef/.test(text)) return "pepper-lime dip";
  if (/fried rice|com-chien|cơm chiên|com-rang|cơm rang/.test(text)) return "soy-seasoned stir-fry";
  if (/mien-xao|miến xào|mi-xao|mì xào|xao|xào|stir-fried|stir fried/.test(text)) return "stir-fry sauce";

  if (/sot-ca-chua|sốt cà chua|tomato sauce/.test(text)) return "tomato sauce";
  if (/mo-hanh|mỡ hành|scallion oil/.test(text)) return "scallion oil";
  if (/canh-chua|canh chua|sour soup/.test(text)) return "sour broth";
  if (/chay|vegetarian/.test(text)) return "vegetarian sauce";

  return "nước chấm or house dipping sauce";
}

function soupOrHotPotBaseFor(item) {
  const text = searchableText(item);
  if (/canh-chua|canh chua|sweet-and-sour/.test(text)) return "sweet-and-sour broth";
  if (/lau|lẩu|hot pot/.test(text)) return "hot-pot broth";
  if (/sup|súp|soup/.test(text)) return "thick soup base";
  if (/kho-qua|khổ qua|bitter melon/.test(text)) return "clear broth";
  return "broth";
}

function mainIngredient(item) {
  const text = searchableText(item);
  if (item.menuType === "Drink") {
    const drinkTests = [
      ["avocado", item.category === "Smoothies" ? /(^|[-\s])bo($|[-\s])|bơ|avocado/ : /avocado/],
      ["mango", /(^|[-\s])xoai($|[-\s])|xoài|mango/],
      ["strawberry", /(^|[-\s])dau($|[-\s])|dâu|strawberry/],
      ["banana", /(^|[-\s])chuoi($|[-\s])|chuối|banana/],
      ["soursop", /mang-cau|mãng cầu|soursop/],
      ["watermelon", /dua-hau|dưa hấu|watermelon/],
      ["coconut", /(^|[-\s])dua($|[-\s])|dừa|coconut/],
      ["sapodilla", /sapoche|sapodilla/],
      ["dragon fruit", /thanh-long|thanh long|dragon fruit/],
      ["passion fruit", /chanh-day|chanh dây|passion fruit/],
      ["jackfruit", /(^|[-\s])mit($|[-\s])|mít|jackfruit/],
      ["papaya", /du-du|đu đủ|papaya/],
      ["mixed fruit", /trai-cay|trái cây|mixed fruit/],
      ["pennywort", /rau-ma|rau má|pennywort/],
      ["blueberry", /viet-quat|việt quất|blueberry/],
      ["peach", /(^|[-\s])dao($|[-\s])|đào|peach/],
      ["pineapple", /(^|[-\s])thom($|[-\s])|thơm|pineapple/],
      ["apple", /(^|[-\s])tao($|[-\s])|táo|\bapple\b/],
      ["carrot", /ca-rot|cà rốt|carrot/],
      ["celery", /can-tay|cần tây|celery/],
      ["guava", /(^|[-\s])oi($|[-\s])|ổi|guava/],
      ["ambarella", /(^|[-\s])coc($|[-\s])|cóc|ambarella/],
      ["lime", /(^|[-\s])chanh($|[-\s])|lime|lemon/],
      ["orange", /(^|[-\s])cam($|[-\s])|orange/],
      ["sugarcane", /(^|[-\s])mia($|[-\s])|mía|sugarcane/],
      ["aloe vera", /nha-dam|nha đam|aloe/],
      ["herbs and dried fruit", /sam-bo-luong|sâm bổ lượng|la-han-qua|la hán quả|nuoc-sam|nước sâm/],
    ];

    for (const [label, pattern] of drinkTests) {
      if (pattern.test(text)) {
        return label;
      }
    }

    return descriptiveName(item);
  }

  const tests = [
    ["pork and shrimp", /hu-tieu-nam-vang|hủ tiếu nam vang|Phnom Penh-style/i],
    ["seafood", /hai-san|hải sản|seafood/],
    ["shrimp and pork", /tom-thit|tôm thịt|shrimp and pork/],
    ["wontons", /hoanh-thanh|hoành thánh|wonton/],
    ["jellyfish", /bun-sua|bún sứa|jellyfish/],
    ["puff pastry filling", /pate-so|patê sô|pâté sô|puff pastry/],
    ["jicama and sausage", /bo-bia|bò bía|jicama and sausage/],
    ["green mango", /goi-xoai|gỏi xoài|green mango/],
    ["green papaya", /goi-du-du|gỏi đu đủ|nom-bo-kho|nộm bò khô|green papaya/],
    ["sweet potato", /khoai-lang|khoai lang|sweet potato/],
    ["potatoes", /khoai-tay|khoai tây|french fries/],
    ["mung bean", /xoi-xeo|xôi xéo|mung bean/],
    ["corn", /xoi-bap|xôi bắp|corn/],
    ["savory toppings", /xoi-man|xôi mặn|savory sticky rice/],
    ["chicken wings", /canh-ga|cánh gà|chicken wings/],
    ["chicken", /(^|[-\s])ga($|[-\s])|gà|chicken/],
    ["duck", /(^|[-\s])vit($|[-\s])|vịt|duck/],
    ["shrimp", /(^|[-\s])tom($|[-\s])|tôm|shrimp/],
    ["crab", /(^|[-\s])(cua|ghe)($|[-\s])|ghẹ|crab/],
    ["squid", /(^|[-\s])muc($|[-\s])|mực|squid/],
    ["clams", /(^|[-\s])ngheu($|[-\s])|nghêu|clam/],
    ["cockles", /sò|cockle/],
    ["snails", /(^|[-\s])oc($|[-\s])|(^|[-\s])ốc($|[-\s])|snail/],
    ["fish", /food-ca-(?!ri-)|cha-ca|chả cá|cá|fish/],
    ["pork belly", /ba-roi|ba rọi|pork belly/],
    ["pork ribs", /(^|[-\s])suon($|[-\s])|sườn|ribs/],
    ["roasted pork", /heo-quay|roasted pork/],
    ["pork", /(^|[-\s])(heo|thit|cha-lua|nem-nuong|lap-xuong)($|[-\s])|thịt|pork|chả lụa|lạp xưởng/],
    ["beef", /(^|[-\s])bo($|[-\s])|bò|beef/],
    ["goat", /(^|[-\s])de($|[-\s])|dê|goat/],
    ["veal", /be-thui|bê|veal/],
    ["tofu", /dau-hu|đậu hũ|tofu/],
    ["mushrooms", /(^|[-\s])nam($|[-\s])|nấm|mushroom/],
    ["egg", /(^|[-\s])trung($|[-\s])|trứng|egg/],
    ["mango", /(^|[-\s])xoai($|[-\s])|xoài|mango/],
    ["coconut", /(^|[-\s])dua($|[-\s])|dừa|coconut/],
    ["sugarcane", /(^|[-\s])mia($|[-\s])|mía|sugarcane/],
    ["orange", /(^|[-\s])cam($|[-\s])|orange/],
    ["lime", /(^|[-\s])chanh($|[-\s])|lime|lemon/],
  ];

  for (const [label, pattern] of tests) {
    if (pattern.test(text)) {
      return label;
    }
  }

  if (item.menuType === "Drink") {
    return descriptiveName(item);
  }

  return descriptiveName(item);
}

function freshDrinkBase(item) {
  const main = mainIngredient(item);
  return /\bdrink\b/i.test(item.englishTranslation) ? main : descriptiveName(item);
}

function noodleType(item) {
  const text = searchableText(item);
  if (/mi-quang|mì quảng/.test(text)) return "wide turmeric rice noodles";
  if (/mien|miến/.test(text)) {
    return "glass noodles";
  }
  if (/hu-tieu|hủ tiếu/.test(text)) {
    return "rice noodles";
  }
  if (/banh-hoi|bánh hỏi/.test(text)) {
    return "fine rice vermicelli sheets";
  }
  if (/bun|bún|vermicelli/.test(text)) {
    return "rice vermicelli";
  }
  if (/(^|[-\s])mi($|[-\s])|mì|egg noodles?/.test(text)) {
    return "egg noodles";
  }
  return "rice noodles";
}

function riceType(item) {
  return /com-tam|cơm tấm|broken rice/.test(searchableText(item)) ? "broken rice" : "rice";
}

function seafoodCookingCue(item) {
  const text = searchableText(item);
  if (/hap|hấp|steamed/.test(text)) return "steam aromatics";
  if (/nuong|nướng|grilled/.test(text)) return "grill seasoning";
  if (/xao|xào|stir-fried|stir fried/.test(text)) return "stir-fry aromatics";
  if (/chien|chiên|\bfried\b/.test(text)) return "crispy coating";
  if (/kho|caramelized/.test(text)) return "caramel sauce";
  return "seasoning";
}

function porkCookingCue(item) {
  const text = searchableText(item);
  if (/nuong|nướng|grilled/.test(text)) return "grill seasoning";
  if (/chien|chiên|fried/.test(text)) return "crispy edges";
  if (/kho|ram|caramel|braised/.test(text)) return "caramel sauce";
  return "savory seasoning";
}

function poultryCookingCue(item) {
  const text = searchableText(item);
  if (/nuong|nướng|grilled/.test(text)) return "grill seasoning";
  if (/chien|chiên|fried/.test(text)) return "crispy coating";
  if (/hap|hấp|steamed/.test(text)) return "steam aromatics";
  if (/kho|braised/.test(text)) return "braising sauce";
  return "savory seasoning";
}

function coffeeIncludes(item) {
  const text = searchableText(item);
  const includes = ["robusta coffee", "phin filter"];
  if (/sua|sữa|milk|bac-xiu|bạc xỉu|latte|mocha/.test(text)) includes.push("milk");
  if (/trung|trứng|egg/.test(text)) includes.push("egg cream");
  if (/cot-dua|cốt dừa|coconut/.test(text)) includes.push("coconut");
  if (/muoi|muối|salt/.test(text)) includes.push("salted cream");
  if (/da|đá|iced/.test(text)) includes.push("ice");
  return includes;
}

function teaIncludes(item) {
  const text = searchableText(item);
  const includes = ["tea"];
  if (/sua|sữa|milk/.test(text)) includes.push("milk");
  if (/tran-chau|trân châu|bubble/.test(text)) includes.push("tapioca pearls");
  if (/dao|đào|peach/.test(text)) includes.push("peach");
  if (/tac|tắc|kumquat/.test(text)) includes.push("kumquat");
  if (/chanh|lemon|lime/.test(text)) includes.push("lime");
  if (/gung|gừng|ginger/.test(text)) includes.push("ginger");
  if (/da|đá|iced|tac|chanh|dao|vai|vải/.test(text)) includes.push("ice");
  return includes;
}

function juiceIncludes(item) {
  const text = searchableText(item);
  if (/mia|mía|sugarcane/.test(text)) return ["sugarcane juice", "ice", "kumquat or lime"];
  if (/dua-hau|dưa hấu|watermelon/.test(text)) return ["watermelon", "water", "ice", "sugar optional"];
  if (/(^|[-\s])dua($|[-\s])|dừa|coconut/.test(text)) return ["fresh coconut water", "ice optional"];
  if (/rau-ma|rau má|pennywort/.test(text)) return ["pennywort", "water", "ice", "sugar optional"];
  return [mainIngredient(item), "water", "ice", "sugar optional"];
}

function otherDrinkIncludes(item) {
  const text = searchableText(item);
  if (isBeer(item)) return item.itemID === "drink-bia-hoi" ? ["fresh draft beer", "chilled glass", "ice optional"] : ["beer", "chilled bottle or can"];
  if (isWineOrLiquor(item)) return ["alcohol", "glass or bottle", "ice optional"];
  if (/soda|nuoc-ngot|nước ngọt/.test(text)) return ["soda water or soft drink", "ice", "lime or flavor syrup"];
  if (/sua|sữa|milk/.test(text)) return ["milk or soy milk", "ice optional", "sugar optional"];
  if (/energy|tang-luc|tăng lực/.test(text)) return ["energy drink", "chilled can"];
  return ["water or soft drink", "chilled bottle", "ice optional"];
}

function isBeer(item) {
  return /bia|beer/.test(searchableText(item));
}

function isWineOrLiquor(item) {
  return /ruou|rượu|wine|vang|liquor/.test(searchableText(item));
}

function searchableText(item) {
  return `${item.itemID} ${item.vietnameseItem} ${item.englishTranslation}`.toLowerCase();
}

function stableIndex(value, modulo) {
  let hash = 0;
  for (const character of value) {
    hash = (hash * 31 + character.charCodeAt(0)) >>> 0;
  }
  return hash % modulo;
}

payload.items = payload.items.map((item) => ({
  ...item,
  ...polishItem(item),
}));

fs.writeFileSync(menuPath, `${JSON.stringify(payload, null, 2)}\n`);
console.log(`Polished ${payload.items.length} Vietnamese menu rows`);
