#!/usr/bin/env node

const path = require("path");
const { pathToFileURL } = require("url");
const { chromium } = require("playwright");

const root = __dirname;
const sourcePath = path.join(root, "storyboard-source.html");
const assetsDir = path.join(root, "assets");

const screens = [
  ["hanoi-city-hub", "hanoi-city-hub.png"],
  ["airport-category", "airport-category.png"],
  ["food-category", "food-category.png"],
  ["hotel-category", "hotel-category.png"],
  ["generic-category-template", "generic-category-template.png"],
  ["search-category-result", "search-category-result.png"],
];

async function main() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 1600, height: 2500 },
    deviceScaleFactor: 2,
  });
  const page = await context.newPage();
  await page.goto(pathToFileURL(sourcePath).href);
  await page.evaluate(() => document.fonts && document.fonts.ready);

  for (const [id, filename] of screens) {
    await page.locator(`#${id}`).screenshot({
      path: path.join(assetsDir, filename),
      animations: "disabled",
    });
  }

  await page.locator("#contact-sheet").screenshot({
    path: path.join(assetsDir, "category-page-system-contact-sheet.png"),
    animations: "disabled",
  });

  await browser.close();
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
