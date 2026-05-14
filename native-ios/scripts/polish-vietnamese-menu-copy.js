#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const menuPath = path.join(repoRoot, "native-ios", "Resources", "vietnamese-menu-copy.json");
const payload = JSON.parse(fs.readFileSync(menuPath, "utf8"));

const exactCopy = {
  "food-pho-bo": {
    atAGlance:
      "Phở bò is Vietnam’s best-known noodle soup: clear, fragrant beef broth, soft rice noodles, and thin slices of beef finished with herbs. It feels light, comforting, and deeply satisfying.",
    goodToKnow:
      "Herbs, lime, chili, and bean sprouts usually arrive on the side. Add them little by little so the broth stays balanced.",
    usuallyIncludes: ["beef broth", "rice noodles", "sliced beef", "herbs", "lime"],
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
      "It is usually stronger and sweeter than many travelers expect. Ask for less sweet or more ice if you want it lighter.",
    usuallyIncludes: ["robusta coffee", "phin filter", "condensed milk", "ice"],
  },
  "drink-ca-phe-den-da": {
    atAGlance:
      "Cà phê đen đá is strong phin-brewed black coffee poured over ice. It is bold, bitter, and refreshing when you want the Vietnamese coffee hit without condensed milk.",
    goodToKnow:
      "This is the unsweetened or lightly sweetened black-coffee lane. Ask for đường riêng if you want sugar on the side.",
  },
  "drink-bac-xiu": {
    atAGlance:
      "Bạc xỉu is a softer, milkier coffee with more sweet milk than coffee. It is creamy, gentle, and a good pick if regular Vietnamese coffee feels too strong.",
    goodToKnow:
      "Think of it as coffee-flavored milk rather than a heavy caffeine hit. It is often served iced.",
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
    "These are dependable lunch orders: simple to point at, quick to serve, and easy to customize.",
    "If the plate looks dry, the dipping sauce is usually meant to be spooned over the rice.",
  ],
  "Rolls, appetizers & street snacks": [
    "These are good shared starters. Ask for extra dipping sauce if everyone at the table is trying them.",
    "Fresh herbs are part of the flavor, not a garnish. Skip chili if you want the dip milder.",
    "Street snacks vary by region and stall. Pointing at the tray is normal if the names are hard to say.",
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
    "Tofu, mushrooms, and greens are common anchors. Soy sauce is the safer request than fish sauce.",
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

  return {
    ...polished,
    ...(exactCopy[item.itemID] ?? {}),
  };
}

function atAGlanceFor(item) {
  const name = descriptiveName(item);
  const main = mainIngredient(item);

  switch (item.category) {
    case "Noodle soups":
      if (/porridge/i.test(item.englishTranslation)) {
        return `${item.vietnameseItem} is a comforting rice porridge with ${main}, scallions, and gentle savory flavor. It is warm, soft, and easy when you want a simple bowl.`;
      }
      return `${item.vietnameseItem} is a warm bowl of ${name} with fragrant broth, noodles, herbs, and a fresh finish from lime or chili. It is filling without feeling heavy.`;
    case "Dry noodles & vermicelli":
      return `${item.vietnameseItem} is a noodle dish meant for mixing: ${name}, fresh herbs, crunchy bits, and a savory sauce or dressing. It is bright, flexible, and easy to customize.`;
    case "Rice & sticky rice":
      if (/sticky rice/i.test(item.englishTranslation) || item.itemID.includes("xoi")) {
        return `${item.vietnameseItem} is a sticky-rice order with ${main} and savory toppings. It is compact, filling, and common for breakfast or a quick meal.`;
      }
      return `${item.vietnameseItem} is a rice plate built around ${name}, usually balanced with pickles, herbs, and sauce. It is a reliable full meal when you want something familiar.`;
    case "Rolls, appetizers & street snacks":
      return `${item.vietnameseItem} is a snack or starter centered on ${name}. Expect fresh herbs, crunch, and a dipping sauce that brings the bite together.`;
    case "Bánh mì, bread & buns":
      if (/stew/i.test(item.englishTranslation)) {
        return `${item.vietnameseItem} pairs crisp bread with ${name}, so you can dip into the broth and eat it like a hearty meal.`;
      }
      return `${item.vietnameseItem} is a Vietnamese bread order with ${main}, pickles, herbs, and a crisp baguette or soft bun. It is quick, satisfying, and easy to eat on the go.`;
    case "Seafood":
      return `${item.vietnameseItem} is a seafood dish built around ${name}, usually lifted by herbs, garlic, chili, or a bright dipping sauce. It is a strong choice for sharing.`;
    case "Pork":
      return `${item.vietnameseItem} is ${name}, a savory pork order that works especially well with rice, pickles, herbs, or dipping sauce.`;
    case "Chicken & duck":
      return `${item.vietnameseItem} is ${name}, a familiar poultry order usually served with herbs, rice, or dipping sauce on the side.`;
    case "Beef & goat":
      return `${item.vietnameseItem} is ${name}, a hearty beef or goat order that is often best with bread, noodles, rice, or fresh herbs.`;
    case "Vegetarian":
      return `${item.vietnameseItem} is a meat-free Vietnamese dish built around ${name}, often with tofu, mushrooms, greens, or soy-based sauce. It is a good lighter order.`;
    case "Soups, hot pots & family-style":
      return `${item.vietnameseItem} is a shared-style dish with ${name}, built for a slower meal with rice, noodles, vegetables, or broth at the table.`;
    case "Desserts & sweets":
      return `${item.vietnameseItem} is a Vietnamese sweet with ${name}. Expect a small, satisfying finish that may be creamy, icy, chewy, or fruit-forward.`;
    case "Coffee":
      return `${item.vietnameseItem} is ${name}, a Vietnamese coffee order with bold flavor and a strong café-style finish. It may be hot, iced, black, or creamy.`;
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
      return `${item.vietnameseItem} is ${name}, an easy point-and-order choice when you want something cold, simple, or familiar.`;
    default:
      return `${item.vietnameseItem} is a Vietnamese menu item: ${name}. It is useful to recognize on menus and easy to order by name.`;
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
      return [noodleType(item), mainIngredient(item), "fresh herbs", "dressing or sauce", "crunchy topping"];
    case "Rice & sticky rice":
      if (/xoi|sticky rice/.test(text)) {
        return ["sticky rice", mainIngredient(item), "fried shallots", "savory topping"];
      }
      return [riceType(item), mainIngredient(item), "pickles or vegetables", "scallion oil", "dipping sauce"];
    case "Rolls, appetizers & street snacks":
      if (/fried|chien|ran|cha-gio|nem-ran/.test(text)) {
        return ["fried wrapper", mainIngredient(item), "vegetables", "herbs", "dipping sauce"];
      }
      if (/banh|bánh|pancake|cake/.test(text)) {
        return ["rice flour batter", mainIngredient(item), "herbs", "dipping sauce"];
      }
      return ["rice paper", mainIngredient(item), "rice vermicelli", "herbs", "dipping sauce"];
    case "Bánh mì, bread & buns":
      if (/bao|bun/.test(text)) {
        return ["soft bun", mainIngredient(item), "savory filling"];
      }
      return ["baguette", mainIngredient(item), "pickled vegetables", "cilantro", "chili optional"];
    case "Seafood":
      return [mainIngredient(item), seafoodCookingCue(item), "garlic or lemongrass", "herbs", "dipping sauce"];
    case "Pork":
      return [mainIngredient(item), porkCookingCue(item), "garlic", "scallions", "dipping sauce"];
    case "Chicken & duck":
      return [mainIngredient(item), poultryCookingCue(item), "garlic", "herbs", "dipping sauce"];
    case "Beef & goat":
      if (/stew|kho|sot-vang|bò kho|bo-kho/.test(text)) {
        return [mainIngredient(item), "spiced broth", "carrots", "herbs", "bread or noodles"];
      }
      return [mainIngredient(item), "garlic", "herbs", "dipping sauce", "rice optional"];
    case "Vegetarian":
      return [mainIngredient(item), "vegetables", "mushrooms or tofu", "herbs", "soy sauce"];
    case "Soups, hot pots & family-style":
      return [mainIngredient(item), "broth or sauce", "vegetables", "herbs", "rice or noodles"];
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
      return ["fried egg", "extra rice", "less sauce", "extra pickles"];
    case "Rolls, appetizers & street snacks":
      return ["extra dipping sauce", "more herbs", "no chili", "share size"];
    case "Bánh mì, bread & buns":
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

function quickSayEnglishFor(item) {
  const unit = servingUnit(item);
  const name = descriptiveName(item);
  return `I’d like one ${unit} of ${name}.`;
}

function servingUnit(item) {
  const text = searchableText(item);
  if (item.menuType === "Drink") {
    if (/nong|hot|coffee|cà phê|tra |trà /.test(text) && !/da|đá|iced|soda|beer|bia/.test(text)) {
      return "cup";
    }
    if (isBeer(item) && item.itemID === "drink-bia-hoi") {
      return "glass";
    }
    if (/water|nước suối|nuoc-suoi|nuoc-loc|nuoc-khoang|bottle/.test(text)) {
      return "bottle";
    }
    if (/beer|bia|wine|vang|ruou|rượu/.test(text)) {
      return "glass";
    }
    return "glass";
  }

  if (/soup|porridge|phở|pho|bún bò|bun-bo|bún riêu|bun-rieu|bánh canh|banh-canh|cháo|chao/.test(text)) {
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

function mainIngredient(item) {
  const text = searchableText(item);
  if (item.menuType === "Drink") {
    const drinkTests = [
      ["avocado", item.category === "Smoothies" ? /(^|[-\s])bo($|[-\s])|bơ|avocado/ : /avocado/],
      ["mango", /(^|[-\s])xoai($|[-\s])|xoài|mango/],
      ["strawberry", /(^|[-\s])dau($|[-\s])|dâu|strawberry/],
      ["banana", /(^|[-\s])chuoi($|[-\s])|chuối|banana/],
      ["soursop", /mang-cau|mãng cầu|soursop/],
      ["coconut", /(^|[-\s])dua($|[-\s])|dừa|coconut/],
      ["sapodilla", /sapoche|sapodilla/],
      ["dragon fruit", /thanh-long|thanh long|dragon fruit/],
      ["passion fruit", /chanh-day|chanh dây|passion fruit/],
      ["watermelon", /dua-hau|dưa hấu|watermelon/],
      ["jackfruit", /(^|[-\s])mit($|[-\s])|mít|jackfruit/],
      ["papaya", /du-du|đu đủ|papaya/],
      ["mixed fruit", /trai-cay|trái cây|mixed fruit/],
      ["pennywort", /rau-ma|rau má|pennywort/],
      ["blueberry", /viet-quat|việt quất|blueberry/],
      ["peach", /(^|[-\s])dao($|[-\s])|đào|peach/],
      ["apple", /(^|[-\s])tao($|[-\s])|táo|apple/],
      ["carrot", /ca-rot|cà rốt|carrot/],
      ["celery", /can-tay|cần tây|celery/],
      ["guava", /(^|[-\s])oi($|[-\s])|ổi|guava/],
      ["pineapple", /(^|[-\s])thom($|[-\s])|thơm|pineapple/],
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
    ["chicken wings", /canh-ga|cánh gà|chicken wings/],
    ["chicken", /(^|[-\s])ga($|[-\s])|gà|chicken/],
    ["duck", /(^|[-\s])vit($|[-\s])|vịt|duck/],
    ["pork belly", /ba-roi|ba rọi|pork belly/],
    ["pork ribs", /(^|[-\s])suon($|[-\s])|sườn|ribs/],
    ["roasted pork", /heo-quay|roasted pork/],
    ["pork", /(^|[-\s])(heo|thit|cha-lua|nem-nuong|lap-xuong)($|[-\s])|thịt|pork|chả lụa|lạp xưởng/],
    ["beef", /(^|[-\s])bo($|[-\s])|bò|beef/],
    ["goat", /(^|[-\s])de($|[-\s])|dê|goat/],
    ["veal", /be-thui|bê|veal/],
    ["shrimp", /(^|[-\s])tom($|[-\s])|tôm|shrimp/],
    ["crab", /(^|[-\s])(cua|ghe)($|[-\s])|ghẹ|crab/],
    ["squid", /(^|[-\s])muc($|[-\s])|mực|squid/],
    ["clams", /(^|[-\s])ngheu($|[-\s])|nghêu|clam/],
    ["snails", /(^|[-\s])oc($|[-\s])|ốc|snail/],
    ["fish", /food-ca-|cha-ca|chả cá|cá|fish/],
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

  return "the main topping";
}

function freshDrinkBase(item) {
  const main = mainIngredient(item);
  return /\bdrink\b/i.test(item.englishTranslation) ? main : descriptiveName(item);
}

function noodleType(item) {
  const text = searchableText(item);
  if (/mi|mì/.test(text)) {
    return "egg noodles";
  }
  if (/mien|miến/.test(text)) {
    return "glass noodles";
  }
  if (/hu-tieu|hủ tiếu/.test(text)) {
    return "rice noodles";
  }
  if (/bun|bún/.test(text)) {
    return "rice vermicelli";
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
  if (/chien|chiên|fried/.test(text)) return "crispy coating";
  if (/kho|caramelized/.test(text)) return "caramel sauce";
  return "savory sauce";
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
  if (/dua|dừa|coconut/.test(text)) return ["fresh coconut water", "ice optional"];
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
