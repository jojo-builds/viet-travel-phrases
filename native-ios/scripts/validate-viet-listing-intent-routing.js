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
  assert(/too fast|unclear|recovery/i.test(atGlance.body ?? ""), "Tôi không hiểu needs traveler-useful context, not a duplicate definition.");
  assert(!standard, "Tôi không hiểu should not repeat the hero as a duplicate primary row.");
  assert(!section(page, "quick-say"), "Tôi không hiểu should not keep a duplicate Quick say section.");
  assert(section(page, "traveler-insight")?.title === "Common follow-ups", "Tôi không hiểu should keep recovery follow-ups.");
}

function validateTableAvailabilityMayHearPage(pages) {
  const page = pageByTitle(pages, "Bàn này còn trống");
  const keys = new Set((page.sections ?? []).map((item) => item.id));
  const fullText = sectionText(page);

  assert(keys.has("at-glance"), "Bàn này còn trống needs a recognition intro.");
  assert(section(page, "at-glance")?.title === "You may hear", "Bàn này còn trống must be a You may hear page.");
  assert(!keys.has("quick-say") && !keys.has("standard-way"), "Bàn này còn trống must not render as Say this.");
  assert(!/Say this|Quick say/i.test(fullText), "Bàn này còn trống contains command-style phrase copy.");

  const breakdown = section(page, "breakdown")?.breakdown ?? [];
  const ban = breakdown.find((token) => token.vietnamese === "Bàn");
  assert(ban?.english === "table", `Bàn should mean table, got: ${ban?.english ?? "missing"}`);
  assert(!breakdown.some((token) => token.vietnamese === "Bàn" && normalize(token.english) === "you"), "Bàn is incorrectly glossed as you.");
  assert(breakdown.some((token) => token.vietnamese === "còn trống" && /available|open/i.test(token.english)), "còn trống should stay together as available/open.");

  const sayNext = section(page, "practice-pairs");
  assert(sayNext?.title === "Say next", "Bàn này còn trống should have Say next.");
  const nextText = sectionText({ sections: [sayNext] });
  for (const expected of ["Cho tôi bàn cho hai người", "Có phải đợi bàn không", "Cho tôi xem thực đơn", "Tính tiền"]) {
    assert(nextText.includes(expected), `Bàn này còn trống missing relevant next phrase: ${expected}`);
  }
  for (const banned of [/thịt heo/i, /đậu phộng/i, /Món này cay/i, /Bác sĩ/i, /phòng khác/i]) {
    assert(!banned.test(fullText), `Bàn này còn trống includes unrelated row: ${banned}`);
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
    titles.join(" > ").startsWith("About > Hear the name > Visit flow > Getting there > Tickets > Cable car > Photos > Getting back > Good to know > Food & cash > Name guide"),
    `Bà Nà Hills section order is wrong: ${titles.join(" > ")}`
  );

  const gettingThereText = sectionText({ sections: [section(page, "getting-there")] });
  assert(gettingThereText.includes("Bà Nà Hills ở đâu?"), "Bà Nà Hills where-is row should live under Getting there.");
  assert(gettingThereText.includes("Dừng ở Bà Nà Hills"), "Bà Nà Hills stop row should live under Getting there.");
  assert(sectionText({ sections: [section(page, "food-cash")] }).includes("Có ATM gần Bà Nà Hills không?"), "Bà Nà Hills ATM row should live under Food & cash.");
  assert(!/nearby needs/i.test(text), "Bà Nà Hills still includes Nearby needs copy.");
}

function validateRestaurantOrderingPage(pages) {
  const page = pageByTitle(pages, "Anăn Sài Gòn");
  const titles = (page.sections ?? []).map((item) => item.title);

  assert(titles.includes("Hear the name"), "Restaurant pages should say Hear the name, not Hear the restaurant.");
  assert(!titles.includes("Hear the restaurant"), "Restaurant page still says Hear the restaurant.");
  assert(
    titles.join(" > ").startsWith("About > Hear the name > Getting there > Table & menu > Order > Drinks > Pay > Getting back > Name guide > Good to know"),
    `Restaurant section order is wrong: ${titles.join(" > ")}`
  );

  const tableMenuText = sectionText({ sections: [section(page, "table-menu")] });
  const orderText = sectionText({ sections: [section(page, "before-you-go")] });
  const drinksText = sectionText({ sections: [section(page, "menu-dietary")] });

  assert(tableMenuText.includes("Cho tôi bàn cho hai người"), "Table-for-two row belongs under Table & menu.");
  assert(!orderText.includes("Cho tôi bàn cho hai người"), "Table-for-two row must not stay under Order.");
  assert(!orderText.includes("Cho tôi một phần"), "Anăn Sài Gòn should not show the clipped one-portion row as its main order.");
  assert(!/đậu phộng|allergy|dị ứng|vegetarian|chay/i.test(drinksText), "Restaurant Drinks section contains diet/allergy rows.");
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
      "traveler_may_hear table availability routing",
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
