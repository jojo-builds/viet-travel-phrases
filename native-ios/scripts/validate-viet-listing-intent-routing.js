#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const authoredPagesPath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");

function fail(message) {
  throw new Error(message);
}

function assert(condition, message) {
  if (!condition) fail(message);
}

function normalize(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[đĐ]/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function loadPages() {
  const payload = JSON.parse(fs.readFileSync(authoredPagesPath, "utf8"));
  return payload.pages ?? [];
}

function pageByTitle(pages, title) {
  const page = pages.find((candidate) => candidate.title === title);
  assert(page, `Missing page: ${title}`);
  return page;
}

function section(page, id) {
  return (page.sections ?? []).find((candidate) => candidate.id === id);
}

function sectionText(page) {
  return (page.sections ?? [])
    .flatMap((item) => [
      item.id,
      item.title,
      item.body,
      ...(item.breakdown ?? []).flatMap((token) => [token.vietnamese, token.english]),
      ...(item.phrases ?? []).flatMap((phrase) => [phrase.vietnamese, phrase.english]),
    ])
    .filter(Boolean)
    .join("\n");
}

function validateNoDuplicateSimplePhraseHero(pages) {
  const page = pageByTitle(pages, "Tôi không hiểu");
  const atGlance = section(page, "at-glance");
  const standard = section(page, "standard-way");

  assert(atGlance, "Tôi không hiểu should keep a compact context section.");
  assert(!/means.+I don.t understand/i.test(atGlance.body ?? ""), "Tôi không hiểu should not repeat the hero in a Meaning section.");
  assert(/too quickly|unfamiliar words/i.test(atGlance.body ?? ""), "Tôi không hiểu needs traveler-useful context, not a duplicate definition.");
  assert(!/means.+I don.t understand/i.test(standard?.body ?? ""), "Tôi không hiểu standard way should not repeat the hero definition.");
  assert(!section(page, "quick-say"), "Tôi không hiểu should not keep a duplicate Quick say section.");
  assert(section(page, "traveler-insight")?.title === "Traveler insight", "Tôi không hiểu should keep recovery insight.");
}

function validateTableAvailabilityMayHearPage(pages) {
  const page = pageByTitle(pages, "Có phải đợi bàn không?");
  const keys = new Set((page.sections ?? []).map((item) => item.id));
  const fullText = sectionText(page);

  assert(keys.has("at-glance"), "Có phải đợi bàn không? needs a traveler context intro.");
  assert(keys.has("quick-say"), "Có phải đợi bàn không? should keep the primary saying row.");
  assert(section(page, "at-glance")?.title === "At a glance", "Có phải đợi bàn không? should be a traveler-says page.");
  assert(!keys.has("standard-way"), "Có phải đợi bàn không? should not keep a duplicate Standard way section.");

  const breakdown = section(page, "breakdown")?.breakdown ?? [];
  assert(!breakdown.some((token) => token.vietnamese === "Bàn" && normalize(token.english) === "you"), "Bàn is incorrectly glossed as you.");
  assert(breakdown.some((token) => token.vietnamese === "đợi bàn" && /wait/i.test(token.english)), "đợi bàn should stay together as wait for a table.");

  const nextText = sectionText({ sections: [section(page, "when-to-use"), section(page, "explore-next")] });
  for (const expected of ["Vui lòng cho một bàn", "Chúng ta đặt hàng ở đây hay tại quầy?", "Tính tiền giúp tôi"]) {
    assert(nextText.includes(expected), `Có phải đợi bàn không? missing relevant next phrase: ${expected}`);
  }
  for (const banned of [/thịt heo/i, /đậu phộng/i, /Món này cay/i, /Bác sĩ/i, /phòng khác/i]) {
    assert(!banned.test(fullText), `Có phải đợi bàn không? includes unrelated row: ${banned}`);
  }
}

function validateBaNaHillsJourneyPage(pages) {
  const page = pageByTitle(pages, "Bà Nà Hills");
  const titles = (page.sections ?? []).map((item) => item.title);
  const text = sectionText(page);

  for (const banned of ["Nearby needs", "What the name means"]) {
    assert(!titles.includes(banned), `Bà Nà Hills should not render ${banned}.`);
  }

  assert(
    titles.join(" > ").startsWith("More Park Than Viewpoint > Useful Phrases > Early, With Weather Checked > Cable Car Arrival > Bridge Before Wandering > Getting there > Tickets > Cable car > Photos > Getting back > Give It Room > Food & cash"),
    `Bà Nà Hills section order is wrong: ${titles.join(" > ")}`
  );

  const gettingThereText = sectionText({ sections: [section(page, "getting-there")] });
  assert(gettingThereText.includes("Cho tôi tới đây"), "Bà Nà Hills take-me-here row should live under Getting there.");
  assert(gettingThereText.includes("Chỉ trên bản đồ giúp tôi được không?"), "Bà Nà Hills map row should live under Getting there.");
  assert(gettingThereText.includes("Cho tôi xuống ngay đây"), "Bà Nà Hills stop-here row should live under Getting there.");
  assert(sectionText({ sections: [section(page, "food-cash")] }).includes("ATM gần nhất ở đâu?"), "Bà Nà Hills nearest-ATM row should live under Food & cash.");
  assert(!/nearby needs/i.test(text), "Bà Nà Hills still includes Nearby needs copy.");
}

function validateRestaurantOrderingPage(pages) {
  const page = pageByTitle(pages, "Anăn Sài Gòn");
  const titles = (page.sections ?? []).map((item) => item.title);

  assert(!titles.includes("Hear the restaurant"), "Restaurant page still says Hear the restaurant.");
  assert(
    titles.join(" > ").startsWith("Modern Vietnamese Inside Market Streets > Useful Phrases > Market Streets Shape The Dinner > Market Outside, Polish Inside > Before Dinner Settles In > Keep Everyday Food Around It"),
    `Restaurant section order is wrong: ${titles.join(" > ")}`
  );

  const usefulPhraseText = sectionText({ sections: [section(page, "quick-say")] });
  const fullText = sectionText(page);

  assert(usefulPhraseText.includes("Có phải đợi bàn không?"), "Anăn Sài Gòn should keep the wait-for-table row in Useful Phrases.");
  assert(usefulPhraseText.includes("Bạn đề xuất món gì?"), "Anăn Sài Gòn should keep the recommendation row in Useful Phrases.");
  assert(usefulPhraseText.includes("Tôi có thể thanh toán hóa đơn bằng thẻ không?"), "Anăn Sài Gòn should keep the card-payment row in Useful Phrases.");
  assert(!fullText.includes("Cho tôi một phần"), "Anăn Sài Gòn should not show the clipped one-portion row as its main order.");
  assert(!/đậu phộng|allergy|dị ứng|vegetarian|chay/i.test(fullText), "Anăn Sài Gòn contains unrelated diet/allergy rows.");
}

function main() {
  const pages = loadPages();
  validateBaNaHillsJourneyPage(pages);
  validateRestaurantOrderingPage(pages);
  validateNoDuplicateSimplePhraseHero(pages);
  validateTableAvailabilityMayHearPage(pages);
  console.log(JSON.stringify({
    ok: true,
    validated: [
      "Bà Nà Hills journey section split",
      "restaurant ordering section routing",
      "simple phrase duplicate suppression",
      "table wait question routing",
      "tone-sensitive Bàn breakdown",
      "restaurant seating row priority",
    ],
  }, null, 2));
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
