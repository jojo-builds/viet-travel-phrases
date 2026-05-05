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
  assert(standard, "Tôi không hiểu should keep one playable primary phrase row.");
  assert((standard.phrases ?? []).some((phrase) => phrase.vietnamese === "Tôi không hiểu"), "Tôi không hiểu primary phrase row missing.");
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

function main() {
  const pages = loadPages();
  validateNoDuplicateSimplePhraseHero(pages);
  validateTableAvailabilityMayHearPage(pages);
  console.log(JSON.stringify({
    ok: true,
    validated: [
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
